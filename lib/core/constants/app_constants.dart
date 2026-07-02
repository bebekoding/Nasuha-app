class AppConstants {
  AppConstants._();

  // Kaaba coordinates
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  // Quran API (https://equran.id/apidev)
  static const String quranBaseUrl = 'https://equran.id/api/v2';

  // Notification channel
  static const String adhanChannelId = 'adhan_channel';
  static const String adhanChannelName = 'Adzan';
  static const String reminderChannelId = 'reminder_channel';
  static const String reminderChannelName = 'Pengingat';

  // Storage keys
  static const String prefsThemeMode = 'pref_theme_mode';
  static const String prefsOnboardingDone = 'pref_onboarding_done';
  static const String prefsCalculationMethod = 'pref_calc_method';
  static const String prefsBiometricEnabled = 'pref_biometric';
  static const String prefsCloudSyncEnabled = 'pref_cloud_sync';
  static const String prefsMuhasabahEnabled = 'pref_muhasabah_enabled';
  static const String prefsSedekahHidden = 'pref_sedekah_hidden';
  static const String prefsMuhasabahHidden = 'pref_muhasabah_hidden';
  static const String prefsQuranFocusMode = 'pref_quran_focus_mode';
}
