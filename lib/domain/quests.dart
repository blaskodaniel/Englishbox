import 'enums.dart';

/// A mai nap tevékenysége – a napi küldetések ebből számolnak.
class TodayActivity {
  const TodayActivity({
    this.itemsAdded = 0,
    this.ownExamples = 0,
    this.reviewed = 0,
    this.claimed = const {},
  });

  /// Ma mentett új elemek (az Add képernyőről; a példamondatok nem számítanak).
  final int itemsAdded;

  /// Ma írt saját példák (elemrészletről vagy szerkesztéskor).
  final int ownExamples;

  /// Ma ismételt különböző elemek.
  final int reviewed;

  /// Ma már felvett küldetésjutalmak.
  final Set<Quest> claimed;
}

/// Egy napi küldetés állapota.
class QuestProgress {
  const QuestProgress({
    required this.quest,
    required this.title,
    required this.progress,
    required this.target,
    required this.reward,
    required this.claimed,
  });

  final Quest quest;
  final String title;
  final int progress;

  /// 0 → ma nem teljesíthető (pl. nincs mit ismételni).
  final int target;
  final int reward;
  final bool claimed;

  bool get isAvailable => target > 0;
  bool get isComplete => isAvailable && progress >= target;
  bool get canClaim => isComplete && !claimed;
  double get fraction => isAvailable ? (progress / target).clamp(0, 1).toDouble() : 0;
}

abstract final class QuestRules {
  static int reward(Quest quest) => switch (quest) {
    Quest.addItems => 20,
    Quest.reviewItems => 30,
    Quest.ownExample => 10,
  };
}

/// A mai küldetések a beállításokból (napi cél, kör hossza) és a mai tevékenységből.
List<QuestProgress> buildDailyQuests({
  required int dailyGoal,
  required int sessionLength,
  required int dueCount,
  required TodayActivity today,
}) {
  // Annyit kérünk ismételni, amennyi egyáltalán esedékes volt ma.
  final reviewTarget = (dueCount + today.reviewed).clamp(0, sessionLength);

  QuestProgress quest(Quest quest, String title, int progress, int target) => QuestProgress(
    quest: quest,
    title: title,
    progress: progress.clamp(0, target),
    target: target,
    reward: QuestRules.reward(quest),
    claimed: today.claimed.contains(quest),
  );

  String items(int n) => n == 1 ? '1 new item' : '$n new items';
  String due(int n) => n == 1 ? '1 due item' : '$n due items';

  return [
    quest(Quest.addItems, 'Add ${items(dailyGoal)}', today.itemsAdded, dailyGoal),
    quest(
      Quest.reviewItems,
      reviewTarget > 0 ? 'Review ${due(reviewTarget)}' : 'Nothing to review today',
      today.reviewed,
      reviewTarget,
    ),
    quest(Quest.ownExample, 'Write your own example', today.ownExamples, 1),
  ];
}
