import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/muhasabah_repository.dart';
import 'muhasabah_enabled_provider.dart';

/// Auto-records amalan points when the user genuinely uses a related feature.
/// All logging is gated on the Muhasabah feature being enabled, and each tag
/// is recorded at most once per day (handled by the repository).
class MuhasabahAutoLogger {
  MuhasabahAutoLogger(this._repo, {required this.enabled});

  final MuhasabahRepository _repo;
  final bool enabled;

  Future<void> _log(String slug) async {
    if (!enabled) return;
    await _repo.autoLogOncePerDay(slug);
  }

  /// Opening a surah to read.
  Future<void> onReadQuran() => _log('baca_quran');

  /// A sedekah/zakat record was added today.
  Future<void> onSedekahRecorded() => _log('sedekah');

  /// Opening a dzikir category. Only "pagi" (07:00–10:30) and
  /// "petang" (15:30–17:00) auto-log, and only within their time window.
  Future<void> onOpenDzikir(String categoryId, {DateTime? now}) async {
    final t = now ?? DateTime.now();
    final mins = t.hour * 60 + t.minute;
    if (categoryId == 'pagi' && mins >= 7 * 60 && mins <= 10 * 60 + 30) {
      await _log('dzikir_pagi');
    } else if (categoryId == 'petang' &&
        mins >= 15 * 60 + 30 &&
        mins <= 17 * 60) {
      await _log('dzikir_petang');
    }
  }
}

final muhasabahAutoLoggerProvider = Provider<MuhasabahAutoLogger>((ref) {
  return MuhasabahAutoLogger(
    ref.watch(muhasabahRepositoryProvider),
    enabled: ref.watch(muhasabahEnabledProvider),
  );
});
