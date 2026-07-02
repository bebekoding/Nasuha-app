import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../core/constants/app_constants.dart';

/// Whether the Quran reader is in "Fokus" mode (full ayat saja, latar gelap)
/// instead of the default "Terjemah" mode. Persisted in SharedPreferences so
/// the choice sticks across surahs and sessions.
class QuranFocusModeController extends StateNotifier<bool> {
  QuranFocusModeController(this._ref)
      : super(_ref
                .read(sharedPrefsProvider)
                .getBool(AppConstants.prefsQuranFocusMode) ??
            false);

  final Ref _ref;

  Future<void> toggle() => set(!state);

  Future<void> set(bool value) async {
    state = value;
    await _ref
        .read(sharedPrefsProvider)
        .setBool(AppConstants.prefsQuranFocusMode, value);
  }
}

final quranFocusModeProvider =
    StateNotifierProvider<QuranFocusModeController, bool>(
  (ref) => QuranFocusModeController(ref),
);
