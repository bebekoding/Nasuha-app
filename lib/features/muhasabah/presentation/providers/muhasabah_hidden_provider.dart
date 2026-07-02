import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../core/constants/app_constants.dart';

/// Whether amal/dosa point values are masked on the Muhasabah screen.
/// Defaults to TRUE — the focus is on doing the deed, not chasing a number.
class MuhasabahHiddenController extends StateNotifier<bool> {
  MuhasabahHiddenController(this._prefs)
      : super(_prefs.getBool(AppConstants.prefsMuhasabahHidden) ?? true);

  final SharedPreferences _prefs;

  Future<void> toggle() async {
    final next = !state;
    await _prefs.setBool(AppConstants.prefsMuhasabahHidden, next);
    state = next;
  }
}

final muhasabahHiddenProvider =
    StateNotifierProvider<MuhasabahHiddenController, bool>((ref) {
  return MuhasabahHiddenController(ref.watch(sharedPrefsProvider));
});
