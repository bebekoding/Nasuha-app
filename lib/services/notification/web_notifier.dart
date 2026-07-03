import 'dart:async';
import 'dart:js_interop';

/// Web-only notification helper. Membungkus `window.Notification` browser
/// API + setTimeout-based scheduler.
///
/// Keterbatasan: notif hanya tampil saat tab **terbuka**. Untuk background
/// (tab tertutup) perlu Service Worker + Push Subscription + backend server,
/// out of scope untuk v1.2.2.
class WebNotifier {
  WebNotifier._();
  static final WebNotifier instance = WebNotifier._();

  /// Map id → JS timeout handle, supaya bisa di-cancel.
  final Map<int, int> _timers = {};

  /// True bila browser mendukung Notification API.
  bool get isSupported => _notificationSupported();

  /// Nilai izin saat ini: 'default', 'granted', atau 'denied'.
  String get permission {
    if (!isSupported) return 'denied';
    return _notificationPermission();
  }

  /// Minta izin ke user. Return true jika akhirnya 'granted'.
  Future<bool> requestPermission() async {
    if (!isSupported) return false;
    final completer = Completer<bool>();
    _notificationRequestPermission((JSString result) {
      completer.complete(result.toDart == 'granted');
    }.toJS);
    return completer.future;
  }

  /// Tampilkan notifikasi immediate.
  void show({
    required String title,
    required String body,
    String? tag,
    String? icon,
  }) {
    if (!isSupported || permission != 'granted') return;
    _showNotification(
      title,
      body,
      tag ?? '',
      icon ?? '/icons/Icon-192.png',
    );
  }

  /// Jadwalkan notifikasi via setTimeout. Return true kalau berhasil
  /// dijadwalkan (waktu di masa depan, dalam batas 24h, dan tab masih
  /// terbuka saat memori berjalan).
  bool schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
    String? tag,
    String? icon,
  }) {
    if (!isSupported) return false;
    final delay = when.difference(DateTime.now());
    if (delay.isNegative) return false;
    // Batas aman setTimeout ~24 hari, tapi realistis untuk adzan cukup 24 jam.
    if (delay.inHours > 24) return false;

    cancel(id);
    final handle = _setTimeout(() {
      _timers.remove(id);
      if (permission == 'granted') {
        _showNotification(
          title,
          body,
          tag ?? 'nasuha-$id',
          icon ?? '/icons/Icon-192.png',
        );
      }
    }.toJS, delay.inMilliseconds);
    _timers[id] = handle;
    return true;
  }

  void cancel(int id) {
    final handle = _timers.remove(id);
    if (handle != null) _clearTimeout(handle);
  }

  void cancelAll() {
    for (final h in _timers.values) {
      _clearTimeout(h);
    }
    _timers.clear();
  }
}

// ─── JS interop ────────────────────────────────────────────────────────────

@JS('window.Notification')
external JSAny? _notificationCtor;

bool _notificationSupported() => _notificationCtor != null;

@JS('window.Notification.permission')
external String _notificationPermissionRaw;

String _notificationPermission() => _notificationPermissionRaw;

@JS('window.Notification.requestPermission')
external void _notificationRequestPermission(JSFunction cb);

@JS('window.setTimeout')
external int _setTimeout(JSFunction fn, int ms);

@JS('window.clearTimeout')
external void _clearTimeout(int handle);

/// Constructor `new Notification(title, {body, tag, icon})` via helper.
@JS('nasuhaShowNotification')
external void _showNotification(
    String title, String body, String tag, String icon);
