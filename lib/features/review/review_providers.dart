import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/enums.dart';

/// Melyik feladattal indul a kör: vegyes, vagy csak egy feladattípus.
enum ReviewMode { mix, cards, build, translate }

/// A Review fül „Focus” szűrője (szint, címke).
class ReviewFocusNotifier extends Notifier<ReviewFocus> {
  @override
  ReviewFocus build() => const ReviewFocus();

  void setLevel(CefrLevel? level) =>
      state = ReviewFocus(level: level, tagId: state.tagId, tagName: state.tagName);

  void setTag(int? id, String? name) =>
      state = ReviewFocus(level: state.level, tagId: id, tagName: id == null ? null : name);

  void clear() => state = const ReviewFocus();
}

final reviewFocusProvider = NotifierProvider<ReviewFocusNotifier, ReviewFocus>(
  ReviewFocusNotifier.new,
);

/// Az esedékes elemek a Focus szerint – élőben.
final reviewDueProvider = StreamProvider<DueSummary>((ref) {
  final focus = ref.watch(reviewFocusProvider);
  return ref.watch(reviewRepositoryProvider).watchDue(focus);
});
