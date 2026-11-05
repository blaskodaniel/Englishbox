import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../domain/srs.dart';
import '../../services/speech_service.dart';
import '../../widgets/chunky_button.dart';
import 'review_providers.dart';
import 'review_session.dart';
import 'widgets/build_sentence_task.dart';
import 'widgets/session_done.dart';
import 'widgets/session_parts.dart';
import 'widgets/translate_task.dart';
import 'widgets/word_card_task.dart';

/// Egy ismétlési kör, teljes képernyőn (alsó sáv nélkül).
///
/// Indításkor egyszer összeállítja a kártyákat, utána a [ReviewSession] tartja
/// az állapotot. Minden válasz azonnal mentődik, így ha félbehagyod, sem
/// vész el semmi.
class ReviewSessionScreen extends ConsumerStatefulWidget {
  const ReviewSessionScreen({super.key, required this.mode});

  final ReviewMode mode;

  @override
  ConsumerState<ReviewSessionScreen> createState() => _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends ConsumerState<ReviewSessionScreen> {
  ReviewSession? _session;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final repo = ref.read(reviewRepositoryProvider);
      final settings = await ref.read(settingsRepositoryProvider).get();
      final due = await repo.loadDue(ref.read(reviewFocusProvider));
      final entries = selectEntries(due, widget.mode, settings.sessionLength);
      final examples = await repo.firstExamples(
        entries.where((e) => !e.isTranslatable).map((e) => e.item.id),
      );
      final pool = await repo.sentencePool();
      final cards = buildCards(
        entries,
        mode: widget.mode,
        answerMode: settings.answerMode,
        examples: examples,
        englishPool: pool.english,
        hungarianPool: pool.hungarian,
      );
      if (mounted) setState(() => _session = ReviewSession(cards));
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  /// Értékelés: a kör állapota frissül, a válasz a háttérben mentődik.
  AnswerOutcome _grade(ReviewGrade grade) {
    final session = _session!;
    final card = session.current!;
    final outcome = session.answer(grade, DateTime.now());
    ref
        .read(reviewRepositoryProvider)
        .recordAnswer(
          itemId: card.item.id,
          task: card.task,
          grade: grade,
          next: outcome.next,
          xp: outcome.xp,
        )
        .catchError((Object e) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Could not save your answer: $e')));
          }
        });
    setState(() {});
    return outcome;
  }

  void _next() {
    ref.read(speechServiceProvider).stop();
    setState(() => _session!.advance());
  }

  void _gradeAndNext(ReviewGrade grade) {
    _grade(grade);
    _next();
  }

  void _speak(String text) => ref.read(speechServiceProvider).speak(text);

  void _close() => context.pop();

  @override
  Widget build(BuildContext context) {
    final session = _session;
    return Scaffold(
      body: SafeArea(
        child: switch (session) {
          null when _error != null => _Message(
            title: 'Something went wrong',
            subtitle: '$_error',
            onBack: _close,
          ),
          null => const Center(child: CircularProgressIndicator()),
          ReviewSession(total: 0) => _Message(
            title: 'Nothing to review',
            subtitle: 'You are all caught up for now.',
            onBack: _close,
          ),
          ReviewSession(isDone: true) => _done(session),
          _ => Column(
            children: [
              SessionHeader(
                progress: session.progress,
                // Játék mód nélkül nem mutatunk XP-t.
                xp: ref.watch(gameModeProvider) ? session.xp : null,
                onClose: _close,
              ),
              Expanded(child: _task(session)),
            ],
          ),
        },
      ),
    );
  }

  Widget _task(ReviewSession session) {
    final card = session.current!;
    // A kulcs miatt minden új kártya friss állapottal indul (mint React `key`).
    final key = ValueKey('${session.position}-${card.task.name}');
    return switch (card.task) {
      ReviewTask.wordCard => WordCardTask(
        key: key,
        card: card,
        counter: '${session.position + 1} / ${session.total}',
        onGrade: _gradeAndNext,
        onSpeak: _speak,
      ),
      ReviewTask.buildSentence => BuildSentenceTask(
        key: key,
        card: card,
        onGrade: _grade,
        onNext: _next,
        showXp: ref.watch(gameModeProvider),
        onUseKeyboard: () => setState(() => session.switchTask(ReviewTask.freeTranslation)),
      ),
      ReviewTask.freeTranslation => TranslateTask(
        key: key,
        card: card,
        onGrade: _gradeAndNext,
        // Csak akkor van hová visszalépni, ha a kártyához készültek csempék
        // (vagyis mondatépítésből váltottunk át).
        onUseTiles: card.tiles.isEmpty
            ? null
            : () => setState(() => session.switchTask(ReviewTask.buildSentence)),
      ),
    };
  }

  Widget _done(ReviewSession session) {
    final due = ref.watch(reviewDueProvider).value;
    final remaining = due == null ? 0 : selectEntries(due, widget.mode, 1 << 30).length;
    return SessionDone(
      session: session,
      streak: ref.watch(streakProvider).current,
      remaining: remaining,
      showXp: ref.watch(gameModeProvider),
      onContinue: _close,
      onMore: () => context.pushReplacement('/review/session?mode=${widget.mode.name}'),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.title, required this.subtitle, required this.onBack});

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          ChunkyButton(label: 'Back', onPressed: onBack),
        ],
      ),
    );
  }
}
