import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../services/speech_service.dart';
import '../../widgets/level_picker.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/segmented_picker.dart';
import 'backup_actions.dart';
import 'widgets/settings_parts.dart';

const _appVersion = '1.0.0';

/// Beállítások. Minden változás azonnal mentődik – nincs „Save” gomb.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _username = TextEditingController();
  bool _usernameLoaded = false;
  bool _busy = false;

  @override
  void dispose() {
    _username.dispose();
    super.dispose();
  }

  Future<void> _update(AppSettingsCompanion changes) =>
      ref.read(settingsRepositoryProvider).update(changes);

  /// Akcentus vagy sebesség változott → rögtön meg is hallod.
  Future<void> _updateVoice(AppSettingsCompanion changes) async {
    await _update(changes);
    await ref.read(speechServiceProvider).speak('Hello! This is how I sound.');
  }

  Future<void> _pickTime(Settings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.reminderMinutes ~/ 60,
        minute: settings.reminderMinutes % 60,
      ),
    );
    if (picked == null) return;
    await _update(AppSettingsCompanion(reminderMinutes: Value(picked.hour * 60 + picked.minute)));
  }

  Future<void> _runBusy(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    // A név mezőt csak egyszer töltjük ki – utána a felhasználó gépel bele,
    // nem írjuk felül minden mentés után (mint egy „uncontrolled” input).
    if (settings != null && !_usernameLoaded) {
      _username.text = settings.username;
      _usernameLoaded = true;
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: 'Settings',
              leadingIcon: Icons.arrow_back_rounded,
              leadingLabel: 'Back',
              onLeading: () => context.pop(),
            ),
            Expanded(
              child: settings == null
                  ? const Center(child: CircularProgressIndicator())
                  : _body(settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(Settings s) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        _profile(s),
        const SizedBox(height: 22),
        SettingsSection(
          title: 'Learning',
          children: [
            LabeledSetting(
              label: 'Daily goal · new items',
              child: SegmentedPicker<int>(
                options: const [(3, '3'), (5, '5'), (10, '10'), (20, '20')],
                value: s.dailyGoal,
                onChanged: (v) => _update(AppSettingsCompanion(dailyGoal: Value(v))),
              ),
            ),
            LabeledSetting(
              label: 'Review session length',
              child: SegmentedPicker<int>(
                options: const [(10, '10'), (20, '20'), (30, '30')],
                value: s.sessionLength,
                onChanged: (v) => _update(AppSettingsCompanion(sessionLength: Value(v))),
              ),
            ),
            LabeledSetting(
              label: 'Translation answers',
              child: SegmentedPicker<AnswerMode>(
                options: const [
                  (AnswerMode.wordBank, 'Word bank'),
                  (AnswerMode.keyboard, 'Keyboard'),
                  (AnswerMode.mix, 'Mix'),
                ],
                value: s.answerMode,
                onChanged: (v) => _update(AppSettingsCompanion(answerMode: Value(v))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SettingsSection(
          title: 'Game',
          padded: false,
          children: [
            SwitchRow(
              title: 'Game mode',
              subtitle: 'XP, levels and daily quests',
              value: s.gameMode,
              onChanged: (v) => _update(AppSettingsCompanion(gameMode: Value(v))),
            ),
            SwitchRow(
              title: 'Streak freeze',
              subtitle: "One missed day a week won't break your streak",
              value: s.streakFreeze,
              onChanged: (v) => _update(AppSettingsCompanion(streakFreeze: Value(v))),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SettingsSection(
          title: 'Reminder',
          padded: false,
          children: [
            SwitchRow(
              title: 'Daily reminder',
              subtitle: "Only if you haven't practised yet",
              value: s.reminderEnabled,
              onChanged: (v) => _update(AppSettingsCompanion(reminderEnabled: Value(v))),
            ),
            Opacity(
              opacity: s.reminderEnabled ? 1 : 0.5,
              child: SettingsRow(
                title: 'Time',
                onTap: s.reminderEnabled ? () => _pickTime(s) : null,
                trailing: _TimeChip(minutes: s.reminderMinutes),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SettingsSection(
          title: 'Pronunciation',
          children: [
            LabeledSetting(
              label: 'Accent',
              child: SegmentedPicker<Accent>(
                options: const [(Accent.british, 'British'), (Accent.american, 'American')],
                value: s.accent,
                onChanged: (v) => _updateVoice(AppSettingsCompanion(accent: Value(v))),
              ),
            ),
            LabeledSetting(
              label: 'Speed',
              child: SegmentedPicker<SpeechSpeed>(
                options: const [
                  (SpeechSpeed.slow, 'Slow'),
                  (SpeechSpeed.normal, 'Normal'),
                  (SpeechSpeed.fast, 'Fast'),
                ],
                value: s.speechSpeed,
                onChanged: (v) => _updateVoice(AppSettingsCompanion(speechSpeed: Value(v))),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        SettingsSection(
          title: 'Your data',
          padded: false,
          footer:
              'Everything is stored on this phone. Works offline, no account needed. '
              'Make a backup now and then – if you lose your phone, it is the only copy.',
          children: [
            SettingsRow(
              leading: const Icon(Icons.download_rounded, color: AppColors.sentence),
              title: 'Export backup',
              subtitle: lastBackupLabel(s.lastBackupAt, DateTime.now()),
              onTap: _busy ? null : () => _runBusy(() => exportBackup(context, ref)),
            ),
            SettingsRow(
              leading: const Icon(Icons.upload_rounded, color: AppColors.word),
              title: 'Import backup',
              subtitle: 'Restore from a backup file',
              onTap: _busy
                  ? null
                  : () => _runBusy(() async {
                      await importBackup(context, ref);
                      // A visszaállított név kerüljön a mezőbe.
                      _usernameLoaded = false;
                    }),
              trailing: _busy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 22),
        const Text(
          'Englishbox · version $_appVersion',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _profile(Settings s) {
    final name = _username.text.trim();
    return SettingsSection(
      title: 'Profile',
      children: [
        Row(
          spacing: 14,
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: AppColors.accentShadow, offset: Offset(0, 4))],
              ),
              child: name.isEmpty
                  ? const Icon(Icons.person_rounded, size: 32, color: AppColors.onAccent)
                  : Text(
                      name.characters.first.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onAccent,
                      ),
                    ),
            ),
            Expanded(
              child: TextField(
                controller: _username,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(labelText: 'Username', hintText: 'Your name'),
                onChanged: (v) {
                  setState(() {}); // az avatar kezdőbetűje
                  _update(AppSettingsCompanion(username: Value(v.trim())));
                },
              ),
            ),
          ],
        ),
        LevelPicker(
          label: 'My level now',
          value: s.levelNow,
          // Kötelező mező: ugyanarra koppintva (null) nem töröljük.
          onChanged: (v) {
            if (v != null) _update(AppSettingsCompanion(levelNow: Value(v)));
          },
        ),
        LevelPicker(
          label: 'My goal',
          value: s.levelGoal,
          onChanged: (v) {
            if (v != null) _update(AppSettingsCompanion(levelGoal: Value(v)));
          },
        ),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.minutes});

  final int minutes;

  @override
  Widget build(BuildContext context) {
    String two(int n) => n.toString().padLeft(2, '0');
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderStrong, width: 2),
      ),
      child: Text(
        '${two(minutes ~/ 60)}:${two(minutes % 60)}',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
