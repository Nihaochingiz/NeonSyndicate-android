import 'package:flutter_test/flutter_test.dart';
import 'package:neon_syndicate/main.dart';

void main() {
  test('a generated deck contains two copies of every card', () {
    final deck = [...cardPool, ...cardPool];
    expect(deck.length, cardPool.length * 2);
  });

  test('fighter stats are initialized from the card', () {
    final fighter = Fighter(cardPool.first);
    expect(fighter.attack, cardPool.first.attack);
    expect(fighter.health, cardPool.first.health);
    expect(fighter.ready, isFalse);
  });
}
