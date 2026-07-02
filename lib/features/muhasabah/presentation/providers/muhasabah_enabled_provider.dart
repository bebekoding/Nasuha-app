import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../core/constants/app_constants.dart';

/// Whether the user has opted in to the Muhasabah (self-reflection) feature.
/// Defaults to false — the feature is optional and gated behind a walkthrough.
class MuhasabahEnabledController extends StateNotifier<bool> {
  MuhasabahEnabledController(this._prefs)
      : super(_prefs.getBool(AppConstants.prefsMuhasabahEnabled) ?? false);

  final SharedPreferences _prefs;

  Future<void> enable() async {
    await _prefs.setBool(AppConstants.prefsMuhasabahEnabled, true);
    state = true;
  }

  Future<void> disable() async {
    await _prefs.setBool(AppConstants.prefsMuhasabahEnabled, false);
    state = false;
  }
}

final muhasabahEnabledProvider =
    StateNotifierProvider<MuhasabahEnabledController, bool>((ref) {
  return MuhasabahEnabledController(ref.watch(sharedPrefsProvider));
});
