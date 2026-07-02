import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key, this.redirectTo = '/'});

  /// Where to navigate after a successful unlock.
  final String redirectTo;

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _auth = LocalAuthentication();
  bool _authenticating = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    setState(() {
      _authenticating = true;
      _error = null;
    });
    try {
      final canCheck = await _auth.canCheckBiometrics ||
          await _auth.isDeviceSupported();
      if (!canCheck) {
        setState(() {
          _error =
              'Perangkat ini tidak mendukung biometrik atau PIN sistem. '
              'Nonaktifkan kunci di Pengaturan jika ingin masuk.';
          _authenticating = false;
        });
        return;
      }
      final ok = await _auth.authenticate(
        localizedReason: 'Buka aplikasi Nasuha',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      if (!mounted) return;
      if (ok) {
        context.go(widget.redirectTo);
      } else {
        setState(() {
          _error = 'Otentikasi dibatalkan.';
          _authenticating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal otentikasi: $e';
        _authenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_outline, size: 56),
                ),
                const SizedBox(height: 24),
                Text('Nasuha Terkunci',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Otentikasi diperlukan untuk membuka aplikasi.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: _authenticating ? null : _authenticate,
                  icon: const Icon(Icons.fingerprint),
                  label: Text(_authenticating
                      ? 'Menunggu otentikasi…'
                      : 'Buka kunci'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
