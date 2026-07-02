import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../models/user_settings.dart';
import '../../../../services/isar/isar_service.dart';

class SettingsController extends StateNotifier<UserSettings> {
  SettingsController(this._service) : super(_load(_service)) {
    _watch();
  }

  final IsarService _service;
  Isar get _isar => _service.isar;

  static UserSettings _load(IsarService s) {
    return s.isar.userSettings.getSync(0) ?? UserSettings();
  }

  void _watch() {
    _isar.userSettings
        .watchObject(0, fireImmediately: true)
        .listen((event) {
      if (event != null) state = event;
    });
  }

  Future<void> update(UserSettings Function(UserSettings) mutate) async {
    final next = mutate(state);
    await _isar.writeTxn(() async {
      await _isar.userSettings.put(next);
    });
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, UserSettings>((ref) {
  return SettingsController(ref.watch(isarServiceProvider));
});
