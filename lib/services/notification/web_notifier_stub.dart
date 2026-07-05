/// Stub untuk platform non-web. Semua method no-op; guard `kIsWeb` di
/// NotificationService memastikan tidak dipanggil di mobile.
class WebNotifier {
  WebNotifier._();
  static final WebNotifier instance = WebNotifier._();

  bool get isSupported => false;
  String get permission => 'denied';
  Future<bool> requestPermission() async => false;
  void show({
    required String title,
    required String body,
    String? tag,
    String? icon,
  }) {}
  bool schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? tag,
    String? icon,
  }) =>
      false;
  void cancel(int id) {}
  void cancelAll() {}
  Future<String?> subscribeToFcm() async => null;
  Future<bool> unsubscribeFromFcm() async => false;
}
