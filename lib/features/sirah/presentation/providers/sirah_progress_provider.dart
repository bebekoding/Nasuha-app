import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/theme_controller.dart' show sharedPrefsProvider;
import '../../data/sirah_data.dart';

/// Snapshot progres baca Sirah — read chapters + last opened.
class SirahProgress {
  final Set<int> read;
  final int? lastOpened;
  const SirahProgress({this.read = const {}, this.lastOpened});

  int get total => kSirahChapters.length;
  int get done => read.length;
  double get fraction => total == 0 ? 0 : done / total;
  bool isRead(int chapterNumber) => read.contains(chapterNumber);
  bool get isStarted => done > 0 || lastOpened != null;

  SirahProgress copyWith({Set<int>? read, int? lastOpened}) => SirahProgress(
        read: read ?? this.read,
        lastOpened: lastOpened ?? this.lastOpened,
      );
}

const _kReadKey = 'sirah_read_chapters_v1';
const _kLastOpenedKey = 'sirah_last_opened_v1';

class SirahProgressNotifier extends StateNotifier<SirahProgress> {
  SirahProgressNotifier(this._prefs) : super(_load(_prefs));

  final SharedPreferences _prefs;

  static SirahProgress _load(SharedPreferences prefs) {
    final list = prefs.getStringList(_kReadKey) ?? const [];
    final read = <int>{};
    for (final s in list) {
      final n = int.tryParse(s);
      if (n != null) read.add(n);
    }
    final last = prefs.getInt(_kLastOpenedKey);
    return SirahProgress(read: read, lastOpened: last);
  }

  /// Tandai chapter sudah dibuka/dibaca + set sebagai last opened.
  /// Idempotent — aman dipanggil berkali-kali per chapter.
  Future<void> markRead(int chapterNumber) async {
    final already = state.read.contains(chapterNumber);
    if (already && state.lastOpened == chapterNumber) return;
    final next = {...state.read, chapterNumber};
    state = state.copyWith(read: next, lastOpened: chapterNumber);
    await _prefs.setStringList(
        _kReadKey, next.map((e) => e.toString()).toList());
    await _prefs.setInt(_kLastOpenedKey, chapterNumber);
  }

  Future<void> reset() async {
    state = const SirahProgress();
    await _prefs.remove(_kReadKey);
    await _prefs.remove(_kLastOpenedKey);
  }
}

final sirahProgressProvider =
    StateNotifierProvider<SirahProgressNotifier, SirahProgress>((ref) {
  return SirahProgressNotifier(ref.watch(sharedPrefsProvider));
});
