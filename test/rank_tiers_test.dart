import 'package:flutter_test/flutter_test.dart';
import 'package:muhasabah/features/rank/data/rank_tiers.dart';

void main() {
  test('negative XP maps to deficit tiers', () {
    expect(rankForXp(-50).tier.title, 'Ghafil'); // 0..-500 band
    expect(rankForXp(-50).tier.level, 0);
    expect(rankForXp(-800).tier.title, 'Zhalim'); // -500..-1500
    expect(rankForXp(-800).tier.level, -1);
    expect(rankForXp(-2000).tier.title, 'Ghariq'); // -1500..-3000
    expect(rankForXp(-9999).tier.title, 'Ghariq'); // below floor stays Ghariq
    expect(rankForXp(-9999).fraction, 0); // clamped at 0% of floor
  });

  test('zero and positive XP map correctly', () {
    expect(rankForXp(0).tier.title, 'Mubtadi');
    expect(rankForXp(0).tier.level, 1);
    expect(rankForXp(660).tier.title, 'Murid'); // level 4
    expect(rankForXp(660).next!.title, 'Abid');
    expect(rankForXp(660).xpRemaining, 340); // 1000 - 660
    expect(rankForXp(999999).tier.title, 'Muqarrab');
    expect(rankForXp(999999).isMax, true);
  });

  test('climbing out of deficit shows upward progress', () {
    // -2000 sits in Ghariq band (-3000..-1500), 1000/1500 toward Zhalim
    final p = rankForXp(-2000);
    expect(p.next!.title, 'Zhalim');
    expect((p.fraction * 100).round(), 67);
  });
}
