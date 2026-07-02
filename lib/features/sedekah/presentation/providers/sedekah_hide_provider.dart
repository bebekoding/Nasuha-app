import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../core/constants/app_constants.dart';

/// Whether sedekah amounts are masked (privacy). Persisted across sessions.
class SedekahHiddenController extends StateNotifier<bool> {
  SedekahHiddenController(this._prefs)
      : super(_prefs.getBool(AppConstants.prefsSedekahHidden) ?? false);

  final SharedPreferences _prefs;

  Future<void> toggle() async {
    final next = !state;
    await _prefs.setBool(AppConstants.prefsSedekahHidden, next);
    state = next;
  }
}

final sedekahHiddenProvider =
    StateNotifierProvider<SedekahHiddenController, bool>((ref) {
  return SedekahHiddenController(ref.watch(sharedPrefsProvider));
});
