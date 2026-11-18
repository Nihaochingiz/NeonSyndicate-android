import 'dart:math';

import 'package:material_ui/material_ui.dart';

const bloodRed = Color(0xFFD21F2B);
const deepRed = Color(0xFF760D16);
const ink = Color(0xFF0B0A0C);
const panel = Color(0xFF171419);
const ivory = Color(0xFFF3E9DE);
const gold = Color(0xFFD8A84E);

void main() => runApp(const NeonSyndicateApp());

class NeonSyndicateApp extends StatelessWidget {
  const NeonSyndicateApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Neon Syndicate',
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: bloodRed,
        brightness: Brightness.dark,
        surface: panel,
      ),
      fontFamily: 'sans-serif',
    ),
    home: const GameScreen(),
  );
}

enum CardKind { fighter, strike, heal, command }

class SyndicateCard {
  const SyndicateCard({
    required this.name,
    required this.subtitle,
    required this.cost,
    required this.kind,
    this.attack = 0,
    this.health = 0,
  });

  final String name;
  final String subtitle;
  final int cost;
  final CardKind kind;
  final int attack;
  final int health;

  IconData get icon => switch (kind) {
    CardKind.fighter => Icons.person,
    CardKind.strike => Icons.local_fire_department,
    CardKind.heal => Icons.local_hospital,
    CardKind.command => Icons.groups,
  };
}

class Fighter {
  Fighter(this.card) : attack = card.attack, health = card.health;
  final SyndicateCard card;
  int attack;
  int health;
  bool ready = false;
}

const cardPool = <SyndicateCard>[
  SyndicateCard(
    name: 'Street Punk',
    subtitle: 'Fast hands, bad manners.',
    cost: 1,
    kind: CardKind.fighter,
    attack: 1,
    health: 2,
  ),
  SyndicateCard(
    name: 'Family Runner',
    subtitle: 'Carries messages and trouble.',
    cost: 1,
    kind: CardKind.fighter,
    attack: 2,
    health: 1,
  ),
  SyndicateCard(
    name: 'Club Bouncer',
    subtitle: 'Nobody passes for free.',
    cost: 2,
    kind: CardKind.fighter,
    attack: 2,
    health: 3,
  ),
  SyndicateCard(
    name: 'Debt Collector',
    subtitle: 'Every promise has a price.',
    cost: 2,
    kind: CardKind.fighter,
    attack: 3,
    health: 2,
  ),
  SyndicateCard(
    name: 'Silent Blade',
    subtitle: 'A shadow with a sharp edge.',
    cost: 3,
    kind: CardKind.fighter,
    attack: 4,
    health: 2,
  ),
  SyndicateCard(
    name: 'Casino Fixer',
    subtitle: 'The house always wins.',
    cost: 3,
    kind: CardKind.fighter,
    attack: 3,
    health: 4,
  ),
  SyndicateCard(
    name: 'Neon Ronin',
    subtitle: 'Loyal only to the night.',
    cost: 4,
    kind: CardKind.fighter,
    attack: 5,
    health: 4,
  ),
  SyndicateCard(
    name: 'Red Dragon',
    subtitle: 'The clan’s feared lieutenant.',
    cost: 5,
    kind: CardKind.fighter,
    attack: 6,
    health: 6,
  ),
  SyndicateCard(
    name: 'The Chairman',
    subtitle: 'Power wears a calm face.',
    cost: 7,
    kind: CardKind.fighter,
    attack: 8,
    health: 8,
  ),
  SyndicateCard(
    name: 'Drive-by',
    subtitle: 'Deal 3 damage to the enemy boss.',
    cost: 2,
    kind: CardKind.strike,
  ),
  SyndicateCard(
    name: 'Backroom Doctor',
    subtitle: 'Restore 4 health to your boss.',
    cost: 2,
    kind: CardKind.heal,
  ),
  SyndicateCard(
    name: 'Oath of Blood',
    subtitle: 'Give your fighters +1/+1.',
    cost: 3,
    kind: CardKind.command,
  ),
];

List<SyndicateCard> makeDeck(Random random) {
  final deck = <SyndicateCard>[];
  for (var i = 0; i < 2; i++) {
    deck.addAll(cardPool);
  }
  deck.shuffle(random);
  return deck;
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _random = Random();
  late List<SyndicateCard> _playerDeck;
  late List<SyndicateCard> _enemyDeck;
  final List<SyndicateCard> _playerHand = [];
  final List<SyndicateCard> _enemyHand = [];
  final List<Fighter> _playerBoard = [];
  final List<Fighter> _enemyBoard = [];

  int _playerHealth = 30;
  int _enemyHealth = 30;
  int _energy = 1;
  int _maxEnergy = 1;
  int _turn = 1;
  int? _selectedFighter;
  bool _playerTurn = true;
  bool _gameOver = false;
  String _message = 'Your move, boss.';

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  void _startGame() {
    _playerDeck = makeDeck(_random);
    _enemyDeck = makeDeck(_random);
    _playerHand.clear();
    _enemyHand.clear();
    _playerBoard.clear();
    _enemyBoard.clear();
    _playerHealth = 30;
    _enemyHealth = 30;
    _energy = 1;
    _maxEnergy = 1;
    _turn = 1;
    _selectedFighter = null;
    _playerTurn = true;
    _gameOver = false;
    _message = 'Your move, boss.';
    for (var i = 0; i < 3; i++) {
      _draw(_playerDeck, _playerHand);
      _draw(_enemyDeck, _enemyHand);
    }
  }

  void _draw(List<SyndicateCard> deck, List<SyndicateCard> hand) {
    if (deck.isNotEmpty && hand.length < 8) hand.add(deck.removeLast());
  }

  void _playCard(int index) {
    if (!_playerTurn || _gameOver) return;
    final card = _playerHand[index];
    if (card.cost > _energy) {
      setState(() => _message = 'Not enough influence.');
      return;
    }
    if (card.kind == CardKind.fighter && _playerBoard.length >= 5) {
      setState(() => _message = 'Your crew is full.');
      return;
    }
    setState(() {
      _energy -= card.cost;
      _playerHand.removeAt(index);
      _resolveCard(card, player: true);
      _message = '${card.name} entered the streets.';
      _checkWinner();
    });
  }

  void _resolveCard(SyndicateCard card, {required bool player}) {
    final board = player ? _playerBoard : _enemyBoard;
    switch (card.kind) {
      case CardKind.fighter:
        board.add(Fighter(card));
      case CardKind.strike:
        if (player) {
          _enemyHealth -= 3;
        } else {
          _playerHealth -= 3;
        }
      case CardKind.heal:
        if (player) {
          _playerHealth = min(30, _playerHealth + 4);
        } else {
          _enemyHealth = min(30, _enemyHealth + 4);
        }
      case CardKind.command:
        for (final fighter in board) {
          fighter.attack++;
          fighter.health++;
        }
    }
  }

  void _selectFighter(int index) {
    if (!_playerTurn || !_playerBoard[index].ready || _gameOver) return;
    setState(() {
      _selectedFighter = _selectedFighter == index ? null : index;
      _message = _selectedFighter == null
          ? 'Choose a fighter.'
          : 'Choose an enemy target.';
    });
  }

  void _attackEnemyBoss() {
    if (_selectedFighter == null || !_playerTurn || _gameOver) return;
    setState(() {
      final fighter = _playerBoard[_selectedFighter!];
      _enemyHealth -= fighter.attack;
      fighter.ready = false;
      _message =
          '${fighter.card.name} hit the rival boss for ${fighter.attack}.';
      _selectedFighter = null;
      _checkWinner();
    });
  }

  void _attackEnemyFighter(int targetIndex) {
    if (_selectedFighter == null || !_playerTurn || _gameOver) return;
    setState(() {
      final attacker = _playerBoard[_selectedFighter!];
      final defender = _enemyBoard[targetIndex];
      final attackerName = attacker.card.name;
      attacker.health -= defender.attack;
      defender.health -= attacker.attack;
      attacker.ready = false;
      _enemyBoard.removeWhere((fighter) => fighter.health <= 0);
      _playerBoard.removeWhere((fighter) => fighter.health <= 0);
      _selectedFighter = null;
      _message = '$attackerName started a street fight.';
    });
  }

  Future<void> _endTurn() async {
    if (!_playerTurn || _gameOver) return;
    setState(() {
      _playerTurn = false;
      _selectedFighter = null;
      _message = 'The rival clan is moving...';
    });
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted || _gameOver) return;
    _runEnemyTurn();
  }

  void _runEnemyTurn() {
    final enemyEnergyMax = min(10, _turn);
    var enemyEnergy = enemyEnergyMax;
    _draw(_enemyDeck, _enemyHand);
    for (final fighter in _enemyBoard) {
      fighter.ready = true;
    }

    while (true) {
      final playable =
          _enemyHand
              .asMap()
              .entries
              .where(
                (entry) =>
                    entry.value.cost <= enemyEnergy &&
                    (entry.value.kind != CardKind.fighter ||
                        _enemyBoard.length < 5),
              )
              .toList()
            ..sort((a, b) => b.value.cost.compareTo(a.value.cost));
      if (playable.isEmpty) break;
      final choice = playable.first;
      enemyEnergy -= choice.value.cost;
      _enemyHand.removeAt(choice.key);
      _resolveCard(choice.value, player: false);
      if (_gameOver) break;
    }

    final attackers = List<Fighter>.from(
      _enemyBoard.where((fighter) => fighter.ready),
    );
    for (final attacker in attackers) {
      if (_playerBoard.isNotEmpty) {
        _playerBoard.sort((a, b) => a.health.compareTo(b.health));
        final defender = _playerBoard.first;
        attacker.health -= defender.attack;
        defender.health -= attacker.attack;
        _playerBoard.removeWhere((fighter) => fighter.health <= 0);
        _enemyBoard.removeWhere((fighter) => fighter.health <= 0);
      } else {
        _playerHealth -= attacker.attack;
      }
      attacker.ready = false;
      _checkWinner();
      if (_gameOver) break;
    }

    if (!_gameOver) {
      _turn++;
      _maxEnergy = min(10, _turn);
      _energy = _maxEnergy;
      _draw(_playerDeck, _playerHand);
      for (final fighter in _playerBoard) {
        fighter.ready = true;
      }
      _playerTurn = true;
      _message = 'Your move, boss.';
    }
    if (mounted) setState(() {});
  }

  void _checkWinner() {
    if (_enemyHealth <= 0) {
      _enemyHealth = 0;
      _gameOver = true;
      _playerTurn = false;
      _message = 'The city belongs to you.';
    } else if (_playerHealth <= 0) {
      _playerHealth = 0;
      _gameOver = true;
      _playerTurn = false;
      _message = 'Your syndicate has fallen.';
    }
  }

  void _restart() => setState(_startGame);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(turn: _turn, energy: _energy, maxEnergy: _maxEnergy),
            _BossPanel(
              title: 'RIVAL OYABUN',
              health: _enemyHealth,
              cards: _enemyHand.length,
              enemy: true,
              selectedTarget: _selectedFighter != null,
              onTap: _attackEnemyBoss,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF100E11),
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: bloodRed.withValues(alpha: .35),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: _BoardRow(
                        fighters: _enemyBoard,
                        enemy: true,
                        selected: null,
                        onTap: _attackEnemyFighter,
                      ),
                    ),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: Colors.white12,
                    ),
                    Expanded(
                      child: _BoardRow(
                        fighters: _playerBoard,
                        enemy: false,
                        selected: _selectedFighter,
                        onTap: _selectFighter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _BossPanel(
              title: 'YOUR CLAN',
              health: _playerHealth,
              cards: _playerDeck.length,
              enemy: false,
            ),
            Container(
              height: 142,
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: _playerHand.isEmpty
                  ? const Center(
                      child: Text(
                        'Your hand is empty',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _playerHand.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 7),
                      itemBuilder: (context, index) => _HandCard(
                        card: _playerHand[index],
                        playable:
                            _playerTurn && _playerHand[index].cost <= _energy,
                        onTap: () => _playCard(index),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: ivory, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_gameOver)
                    FilledButton.icon(
                      onPressed: _restart,
                      icon: const Icon(Icons.refresh),
                      label: const Text('REMATCH'),
                    )
                  else
                    FilledButton(
                      onPressed: _playerTurn ? _endTurn : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: bloodRed,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('END TURN'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.turn,
    required this.energy,
    required this.maxEnergy,
  });
  final int turn;
  final int energy;
  final int maxEnergy;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
    child: Row(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: bloodRed,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.local_fire_department),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NEON SYNDICATE',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              Text(
                'WAR FOR THE NIGHT',
                style: TextStyle(fontSize: 9, color: gold, letterSpacing: 2),
              ),
            ],
          ),
        ),
        Text(
          'TURN $turn',
          style: const TextStyle(fontSize: 10, color: Colors.white54),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: deepRed,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: bloodRed),
          ),
          child: Row(
            children: [
              const Icon(Icons.bolt, size: 16, color: gold),
              Text(
                '$energy/$maxEnergy',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _BossPanel extends StatelessWidget {
  const _BossPanel({
    required this.title,
    required this.health,
    required this.cards,
    required this.enemy,
    this.selectedTarget = false,
    this.onTap,
  });
  final String title;
  final int health;
  final int cards;
  final bool enemy;
  final bool selectedTarget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selectedTarget ? deepRed : panel,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selectedTarget ? bloodRed : Colors.white10,
          width: selectedTarget ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: enemy ? deepRed : const Color(0xFF29232C),
            child: Icon(
              enemy ? Icons.visibility : Icons.shield,
              color: enemy ? bloodRed : ivory,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  enemy ? 'Kuroda Family' : 'Crimson Dragon Clan',
                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                ),
              ],
            ),
          ),
          Icon(Icons.style, size: 15, color: Colors.white38),
          const SizedBox(width: 3),
          Text('$cards', style: const TextStyle(color: Colors.white54)),
          const SizedBox(width: 12),
          const Icon(Icons.favorite, color: bloodRed, size: 20),
          const SizedBox(width: 4),
          Text(
            '$health',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}

class _BoardRow extends StatelessWidget {
  const _BoardRow({
    required this.fighters,
    required this.enemy,
    required this.selected,
    required this.onTap,
  });
  final List<Fighter> fighters;
  final bool enemy;
  final int? selected;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (fighters.isEmpty) {
      return Center(
        child: Text(
          enemy ? 'Rival streets are quiet' : 'Play a fighter from your hand',
          style: const TextStyle(color: Colors.white24, fontSize: 11),
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < fighters.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _FighterToken(
                  fighter: fighters[i],
                  enemy: enemy,
                  selected: selected == i,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FighterToken extends StatelessWidget {
  const _FighterToken({
    required this.fighter,
    required this.enemy,
    required this.selected,
    required this.onTap,
  });
  final Fighter fighter;
  final bool enemy;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 62,
      height: 76,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: selected
              ? [bloodRed, deepRed]
              : [const Color(0xFF302931), panel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? gold
              : fighter.ready
              ? bloodRed
              : Colors.white12,
          width: selected ? 2 : 1,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: bloodRed.withValues(alpha: .45),
                  blurRadius: 12,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              fighter.card.icon,
              size: 30,
              color: fighter.ready ? ivory : Colors.white30,
            ),
          ),
          Positioned(
            left: 4,
            right: 4,
            top: 4,
            child: Text(
              fighter.card.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 5,
            bottom: 4,
            child: _StatBadge(
              value: fighter.attack,
              icon: Icons.flash_on,
              color: gold,
            ),
          ),
          Positioned(
            right: 5,
            bottom: 4,
            child: _StatBadge(
              value: fighter.health,
              icon: Icons.favorite,
              color: bloodRed,
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.value,
    required this.icon,
    required this.color,
  });
  final int value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 11, color: color),
      Text(
        '$value',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900),
      ),
    ],
  );
}

class _HandCard extends StatelessWidget {
  const _HandCard({
    required this.card,
    required this.playable,
    required this.onTap,
  });
  final SyndicateCard card;
  final bool playable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedOpacity(
      opacity: playable ? 1 : .48,
      duration: const Duration(milliseconds: 150),
      child: Container(
        width: 94,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3B1117), Color(0xFF171419)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: playable ? bloodRed : Colors.white12,
            width: playable ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: bloodRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${card.cost}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                Icon(card.icon, size: 20, color: gold),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              card.name,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Text(
              card.subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 7, color: Colors.white54),
            ),
            const SizedBox(height: 4),
            if (card.kind == CardKind.fighter)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatBadge(
                    value: card.attack,
                    icon: Icons.flash_on,
                    color: gold,
                  ),
                  _StatBadge(
                    value: card.health,
                    icon: Icons.favorite,
                    color: bloodRed,
                  ),
                ],
              )
            else
              Text(
                card.kind.name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 8,
                  color: gold,
                  letterSpacing: 1,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
