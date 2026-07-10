import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'compass_service.dart';

CompassService create() => _WebCompassService();

@JS('window')
external JSObject get _window;

@JS('DeviceOrientationEvent')
external JSObject? get _deviceOrientationEvent;

extension type _OrientationEvent(JSObject _) implements JSObject {
  external double? get alpha;
  external bool? get absolute;

  /// iOS Safari: heading kompas langsung (derajat clockwise dari utara).
  external double? get webkitCompassHeading;
}

class _WebCompassService implements CompassService {
  @override
  bool get needsPermissionGesture {
    final ctor = _deviceOrientationEvent;
    if (ctor == null) return false;
    return ctor.hasProperty('requestPermission'.toJS).toDart;
  }

  @override
  Future<bool> requestPermission() async {
    if (!needsPermissionGesture) return true;
    try {
      final result = await (_deviceOrientationEvent!
              .callMethod('requestPermission'.toJS) as JSPromise)
          .toDart;
      return (result as JSString?)?.toDart == 'granted';
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<double?> headings() {
    late StreamController<double?> controller;
    JSFunction? absCb;
    JSFunction? relCb;

    void handle(_OrientationEvent e, {required bool fromAbsoluteEvent}) {
      double? heading;
      final wk = e.webkitCompassHeading;
      if (wk != null && !wk.isNaN) {
        heading = wk;
      } else {
        final alpha = e.alpha;
        final absolute = e.absolute ?? fromAbsoluteEvent;
        if (alpha != null && absolute) {
          heading = (360 - alpha) % 360;
        }
      }
      if (heading != null && !controller.isClosed) {
        controller.add(heading);
      }
    }

    void attach() {
      // Seed null: desktop browser tanpa sensor tidak akan pernah kirim
      // event — tanpa seed, StreamProvider menggantung di loading.
      scheduleMicrotask(() {
        if (!controller.isClosed) controller.add(null);
      });
      absCb = ((JSObject e) =>
          handle(_OrientationEvent(e), fromAbsoluteEvent: true)).toJS;
      relCb = ((JSObject e) =>
          handle(_OrientationEvent(e), fromAbsoluteEvent: false)).toJS;
      try {
        _window.callMethod(
            'addEventListener'.toJS, 'deviceorientationabsolute'.toJS, absCb);
        _window.callMethod(
            'addEventListener'.toJS, 'deviceorientation'.toJS, relCb);
      } catch (_) {
        // Browser tanpa API sama sekali — seed null sudah cukup.
      }
    }

    void detach() {
      try {
        if (absCb != null) {
          _window.callMethod('removeEventListener'.toJS,
              'deviceorientationabsolute'.toJS, absCb);
        }
        if (relCb != null) {
          _window.callMethod(
              'removeEventListener'.toJS, 'deviceorientation'.toJS, relCb);
        }
      } catch (_) {}
    }

    controller = StreamController<double?>.broadcast(
      onListen: attach,
      onCancel: detach,
    );
    return controller.stream;
  }
}
