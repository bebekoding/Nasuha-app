import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/charity_record.dart';
import '../../../../services/isar/isar_service.dart';
import '../../../achievements/data/achievement_engine.dart';

class SedekahRepository {
  SedekahRepository(this._service, this._achievements);
  final IsarService _service;
  final AchievementEngine _achievements;
  Isar get _isar => _service.isar;

  Future<void> add({
    required double amount,
    String? note,
    String? category,
  }) async {
    final now = DateTime.now();
    final r = CharityRecord()
      ..dateKey = now.isoDate
      ..createdAt = now
      ..amount = amount
      ..note = note
      ..category = category;
    await _isar.writeTxn(() => _isar.charityRecords.put(r));
    await _achievements.recomputeAll();
  }

  Future<void> update({
    required int id,
    required double amount,
    String? note,
    String? category,
  }) async {
    final r = await _isar.charityRecords.get(id);
    if (r == null) return;
    r
      ..amount = amount
      ..note = note
      ..category = category;
    await _isar.writeTxn(() => _isar.charityRecords.put(r));
    await _achievements.recomputeAll();
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.charityRecords.delete(id));
    await _achievements.recomputeAll();
  }

  Stream<List<CharityRecord>> watchAll() => _isar.charityRecords
      .where()
      .sortByCreatedAtDesc()
      .watch(fireImmediately: true);

  Stream<List<CharityRecord>> watchToday() {
    final today = DateTime.now().isoDate;
    return _isar.charityRecords
        .filter()
        .dateKeyEqualTo(today)
        .watch(fireImmediately: true);
  }

  Future<({double total, int count})> totalAll() async {
    final all = await _isar.charityRecords.where().findAll();
    return (
      total: all.fold<double>(0, (s, r) => s + r.amount),
      count: all.length
    );
  }

  Future<List<CharityRecord>> rangeFromToday(Duration range) async {
    final from = DateTime.now().subtract(range);
    return _isar.charityRecords
        .filter()
        .createdAtGreaterThan(from)
        .findAll();
  }
}

final sedekahRepositoryProvider = Provider<SedekahRepository>((ref) {
  return SedekahRepository(
    ref.watch(isarServiceProvider),
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
