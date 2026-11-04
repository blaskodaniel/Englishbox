import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db.dart';

class XpRepository {
  XpRepository(this._db);

  final AppDatabase _db;

  Future<void> award(int amount, XpReason reason, {int? itemId}) async {
    if (amount <= 0) return;
    await _db.into(_db.xpEvents).insert(
          XpEventsCompanion.insert(
            amount: amount,
            reason: reason,
            itemId: Value(itemId),
          ),
        );
  }

  /// Az összes eddig szerzett XP.
  Stream<int> watchTotal() {
    final sum = _db.xpEvents.amount.sum();
    final query = _db.selectOnly(_db.xpEvents)..addColumns([sum]);
    return query.watchSingle().map((row) => row.read(sum) ?? 0);
  }
}
