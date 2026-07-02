import 'package:drift/drift.dart' show OrderingMode, OrderingTerm, Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/charity_record.dart';
import '../../../../services/database/app_database.dart';
import '../../../achievements/data/achievement_engine.dart';

class SedekahRepository {
  SedekahRepository(this._db, this._achievements);

  final AppDatabase _db;
  final AchievementEngine _achievements;

  Future<void> add({
    required double amount,
    String? note,
    String? category,
  }) async {
    final now = DateTime.now();
    await _db.into(_db.charityRecordsTable).insert(
          CharityRecordsTableCompanion.insert(
            dateKey: now.isoDate,
            createdAt: now,
            amount: amount,
            note: Value(note),
            category: Value(category),
          ),
        );
    await _achievements.recomputeAll();
  }

  Future<void> update({
    required int id,
    required double amount,
    String? note,
    String? category,
  }) async {
    await (_db.update(_db.charityRecordsTable)..where((t) => t.id.equals(id)))
        .write(
      CharityRecordsTableCompanion(
        amount: Value(amount),
        note: Value(note),
        category: Value(category),
      ),
    );
    await _achievements.recomputeAll();
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.charityRecordsTable)..where((t) => t.id.equals(id)))
        .go();
    await _achievements.recomputeAll();
  }

  Stream<List<CharityRecord>> watchAll() {
    return (_db.select(_db.charityRecordsTable)
          ..orderBy(
              [(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map(_rowToDomain).toList());
  }

  Stream<List<CharityRecord>> watchToday() {
    final today = DateTime.now().isoDate;
    return (_db.select(_db.charityRecordsTable)
          ..where((t) => t.dateKey.equals(today)))
        .watch()
        .map((rows) => rows.map(_rowToDomain).toList());
  }

  Future<({double total, int count})> totalAll() async {
    final rows = await _db.select(_db.charityRecordsTable).get();
    return (
      total: rows.fold<double>(0, (s, r) => s + r.amount),
      count: rows.length,
    );
  }

  Future<List<CharityRecord>> rangeFromToday(Duration range) async {
    final from = DateTime.now().subtract(range);
    // Filter di Dart — data sedekah pribadi kecil (max ratusan), tak perlu
    // WHERE di SQL; ini juga menghindari inkonsistensi API DateTime antar
    // versi Drift.
    final rows = await _db.select(_db.charityRecordsTable).get();
    return rows
        .where((r) => r.createdAt.isAfter(from))
        .map(_rowToDomain)
        .toList();
  }

  CharityRecord _rowToDomain(CharityRecordRow r) => CharityRecord(
        id: r.id,
        dateKey: r.dateKey,
        createdAt: r.createdAt,
        amount: r.amount,
        note: r.note,
        category: r.category,
      );
}

final sedekahRepositoryProvider = Provider<SedekahRepository>((ref) {
  return SedekahRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(achievementEngineProvider),
  );
});

final sedekahTodayProvider = StreamProvider<List<CharityRecord>>((ref) {
  return ref.watch(sedekahRepositoryProvider).watchToday();
});

final sedekahAllProvider = StreamProvider<List<CharityRecord>>((ref) {
  return ref.watch(sedekahRepositoryProvider).watchAll();
});

final sedekahTotalProvider =
    FutureProvider<({double total, int count})>((ref) {
  ref.watch(sedekahAllProvider);
  return ref.watch(sedekahRepositoryProvider).totalAll();
});
