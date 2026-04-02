import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════
// 🎨 SHARED DESIGN TOKENS
// ═══════════════════════════════════════════════════════════
const Color _kBg = Color(0xFF0F0E17);
const Color _kSurface = Color(0xFF1A1A2E);
const Color _kCard = Color(0xFF1E2A45);
const Color _kAccent = Color(0xFF7C6FFF);
const Color _kGold = Color(0xFFFFD700);
const Color _kGreen = Color(0xFF43A047);
const Color _kRed = Color(0xFFE53935);

// ─── Responsive size helper ───────────────────────────────
// Usage: _rs(ctx, 20) → scales 20px relative to 390px baseline
double _rs(BuildContext ctx, double base) {
  final sw = MediaQuery.of(ctx).size.shortestSide;
  return (base * sw / 390).clamp(base * 0.72, base * 1.25);
}

AppBar _gameAppBar(String title) => AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      backgroundColor: _kSurface,
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );

// ─── Progress Header ──────────────────────────────────────
class _ProgressHeader extends StatelessWidget {
  final int current, total, score, lives;
  const _ProgressHeader(
      {required this.current,
      required this.total,
      required this.score,
      required this.lives});
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final iconSz = _rs(context, 22);
    final fs = _rs(context, 13);
    final hPad = (sw * 0.042).clamp(12.0, 18.0);
    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 10),
      color: _kSurface,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: List.generate(
                3,
                (i) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                          i < lives ? Icons.favorite : Icons.favorite_border,
                          color: i < lives ? _kRed : Colors.white24,
                          size: iconSz),
                    )),
          ),
          Text('Q $current / $total',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: fs,
                  fontWeight: FontWeight.w500)),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: _rs(context, 12), vertical: 5),
            decoration: BoxDecoration(
                color: _kCard, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.star_rounded, color: _kGold, size: _rs(context, 18)),
              const SizedBox(width: 4),
              Text('$score',
                  style: TextStyle(
                      color: _kGold,
                      fontWeight: FontWeight.bold,
                      fontSize: _rs(context, 15))),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: total > 0 ? (current / total).clamp(0.0, 1.0) : 0,
            backgroundColor: _kCard,
            valueColor: const AlwaysStoppedAnimation(_kAccent),
            minHeight: _rs(context, 7),
          ),
        ),
      ]),
    );
  }
}

// ─── Game Over Overlay ────────────────────────────────────
class _GameOverOverlay extends StatelessWidget {
  final int score, total;
  final VoidCallback onRestart, onBack;
  const _GameOverOverlay(
      {required this.score,
      required this.total,
      required this.onRestart,
      required this.onBack});
  int get _stars {
    if (total == 0) return 1;
    final r = score / total;
    if (r >= 0.8) return 3;
    if (r >= 0.5) return 2;
    return 1;
  }
  String get _msg =>
      _stars == 3 ? '🏆 Amazing!' : _stars == 2 ? '👏 Good Job!' : '💪 Keep Going!';
  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final margin = (sw * 0.065).clamp(18.0, 30.0);
    final pad = (sw * 0.07).clamp(20.0, 30.0);
    final starSz = _rs(context, 48);
    return Container(
      color: Colors.black.withOpacity(0.88),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(_rs(context, 28)),
            border: Border.all(color: _kAccent.withOpacity(0.5), width: 1.5),
            boxShadow: [
              BoxShadow(color: _kAccent.withOpacity(0.3), blurRadius: 30)
            ],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(_msg,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: _rs(context, 22),
                    fontWeight: FontWeight.bold)),
            SizedBox(height: _rs(context, 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  3,
                  (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.star_rounded,
                            size: starSz,
                            color: i < _stars ? _kGold : Colors.white24),
                      )),
            ),
            SizedBox(height: _rs(context, 10)),
            Text('$score / $total correct',
                style: TextStyle(
                    color: Colors.white60, fontSize: _rs(context, 16))),
            SizedBox(height: _rs(context, 22)),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.symmetric(vertical: _rs(context, 13)),
                  ),
                  child: Text('← Back',
                      style: TextStyle(fontSize: _rs(context, 14))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRestart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.symmetric(vertical: _rs(context, 13)),
                    elevation: 8,
                    shadowColor: _kAccent.withOpacity(0.5),
                  ),
                  child: Text('▶ Play Again',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _rs(context, 14))),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 🎯 LEVEL SELECT SCREEN
// ═══════════════════════════════════════════════════════════
class LevelSelectScreen extends StatelessWidget {
  final String name, icon, description;
  final Widget Function(int level) builder;
  const LevelSelectScreen({
    super.key,
    required this.name,
    required this.icon,
    required this.description,
    required this.builder,
  });

  static const _levels = [
    {
      'num': 1,
      'title': 'Beginner',
      'emoji': '⭐',
      'desc': 'Simple & fun to start!',
      'hint': 'Basic concepts',
      'colors': [Color(0xFF43A047), Color(0xFF1B5E20)],
    },
    {
      'num': 2,
      'title': 'Explorer',
      'emoji': '⭐⭐',
      'desc': 'Ready for more challenge?',
      'hint': 'More variety',
      'colors': [Color(0xFFFFA726), Color(0xFFE65100)],
    },
    {
      'num': 3,
      'title': 'Champion',
      'emoji': '⭐⭐⭐',
      'desc': 'Only the best can win!',
      'hint': 'Expert difficulty',
      'colors': [Color(0xFFEF5350), Color(0xFF7B1FA2)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final hPad = (sw * 0.055).clamp(16.0, 26.0);
    final emojiSz = (sw * 0.17).clamp(56.0, 80.0);
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('Select Level'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: hPad * 0.6),
        child: Column(children: [
          SizedBox(height: sh * 0.015),
          Container(
            padding: EdgeInsets.all(hPad),
            decoration: BoxDecoration(
              color: _kSurface,
              borderRadius: BorderRadius.circular(_rs(context, 24)),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(children: [
              Text(icon, style: TextStyle(fontSize: emojiSz)),
              SizedBox(height: _rs(context, 12)),
              Text(name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: _rs(context, 22),
                      fontWeight: FontWeight.bold)),
              SizedBox(height: _rs(context, 6)),
              Text(description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: _rs(context, 13))),
            ]),
          ),
          SizedBox(height: sh * 0.03),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Choose Difficulty',
                style: TextStyle(
                    color: Colors.white54,
                    fontSize: _rs(context, 12),
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: sh * 0.015),
          ...List.generate(_levels.length, (i) {
            final lv = _levels[i];
            final colors = lv['colors'] as List<Color>;
            return Padding(
              padding: EdgeInsets.only(bottom: _rs(context, 14)),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => builder(lv['num'] as int))),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: _rs(context, 20),
                      vertical: _rs(context, 16)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(_rs(context, 20)),
                    boxShadow: [
                      BoxShadow(
                          color: colors[0].withOpacity(0.45),
                          blurRadius: 16,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(children: [
                          Text(lv['emoji'] as String,
                              style: TextStyle(fontSize: _rs(context, 17))),
                          SizedBox(width: _rs(context, 8)),
                          Text(lv['title'] as String,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: _rs(context, 17),
                                  fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: _rs(context, 4)),
                        Text(lv['desc'] as String,
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: _rs(context, 12))),
                        SizedBox(height: _rs(context, 2)),
                        Text(lv['hint'] as String,
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: _rs(context, 10))),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(_rs(context, 10)),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2)),
                      child: Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: _rs(context, 24)),
                    ),
                  ]),
                ),
              ),
            );
          }),
        ]),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 1. 🎨 COLOR MATCH — 3 Levels
// L1: 4 colors, 8 rounds | L2: 6 colors, 10 rounds | L3: 8 colors, 12 rounds
// ═══════════════════════════════════════════════════════════
class ColorMatchGame extends StatefulWidget {
  final int level;
  const ColorMatchGame({super.key, this.level = 1});
  @override
  State<ColorMatchGame> createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  static const _allColors = <Map<String, Object>>[
    {'name': 'RED', 'color': Color(0xFFEF5350)},
    {'name': 'BLUE', 'color': Color(0xFF42A5F5)},
    {'name': 'GREEN', 'color': Color(0xFF66BB6A)},
    {'name': 'YELLOW', 'color': Color(0xFFFFEE58)},
    {'name': 'PURPLE', 'color': Color(0xFFAB47BC)},
    {'name': 'ORANGE', 'color': Color(0xFFFFA726)},
    {'name': 'PINK', 'color': Color(0xFFEC407A)},
    {'name': 'CYAN', 'color': Color(0xFF26C6DA)},
  ];
  int get _total => widget.level == 1 ? 8 : widget.level == 2 ? 10 : 12;
  int get _colorCount => widget.level == 1 ? 4 : widget.level == 2 ? 6 : 8;

  final _rng = Random();
  int _score = 0, _lives = 3, _round = 0;
  bool _gameOver = false, _answered = false;
  late String _target;
  late List<Map<String, Object>> _opts;

  @override
  void initState() {
    super.initState();
    _next();
  }

  void _next() {
    if (_round >= _total) { setState(() => _gameOver = true); return; }
    final pool = List<Map<String, Object>>.from(_allColors.take(_colorCount))
      ..shuffle(_rng);
    _opts = pool.take(4).toList();
    _target = _opts[_rng.nextInt(4)]['name'] as String;
    _answered = false;
  }

  void _pick(Map<String, Object> c) {
    if (_answered || _gameOver) return;
    final ok = (c['name'] as String) == _target;
    setState(() {
      _answered = true;
      if (ok) { _score++; }
      else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _restart() => setState(() {
        _score = 0; _lives = 3; _round = 0; _gameOver = false; _next();
      });

  Color _optColor(Map<String, Object> c) {
    if (!_answered) return c['color'] as Color;
    return (c['name'] as String) == _target ? _kGreen : _kRed;
  }

  @override
  Widget build(BuildContext context) {
    final targetColor = _allColors
        .firstWhere((c) => c['name'] == _target)['color'] as Color;
    final lvLabel = ['', '⭐ Beginner', '⭐⭐ Explorer', '⭐⭐⭐ Champion'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🎨 Color Match  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(
              current: _round, total: _total, score: _score, lives: _lives),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 28, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_kCard, _kSurface],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(children: [
                        const Text('Find the color:',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 16)),
                        const SizedBox(height: 10),
                        Text(_target,
                            style: TextStyle(
                              color: targetColor,
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 6,
                              shadows: const [
                                Shadow(blurRadius: 20, color: Colors.black54)
                              ],
                            )),
                      ]),
                    ),
                    const SizedBox(height: 32),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.8,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _opts
                          .map((c) => GestureDetector(
                                onTap: () => _pick(c),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: _optColor(c),
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: [
                                      BoxShadow(
                                          color: (c['color'] as Color)
                                              .withOpacity(0.5),
                                          blurRadius: 14,
                                          offset: const Offset(0, 5))
                                    ],
                                  ),
                                  child: Center(
                                      child: Text(c['name'] as String,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              shadows: [
                                                Shadow(
                                                    blurRadius: 4,
                                                    color: Colors.black38)
                                              ]))),
                                ),
                              ))
                          .toList(),
                    ),
                  ]),
            ),
          ),
        ]),
        if (_gameOver)
          _GameOverOverlay(
              score: _score,
              total: _total,
              onRestart: _restart,
              onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 2. 🃏 MEMORY FLIP — 3 Levels
// L1: 6 pairs emoji-emoji | L2: 8 pairs emoji+word | L3: 10 pairs emoji+word
// ═══════════════════════════════════════════════════════════
class _MemCard {
  final String text;
  final int pairId;
  bool flipped, matched;
  _MemCard({required this.text, required this.pairId, this.flipped = false, this.matched = false});
}

class MemoryFlipGame extends StatefulWidget {
  final int level;
  const MemoryFlipGame({super.key, this.level = 1});
  @override
  State<MemoryFlipGame> createState() => _MemoryFlipGameState();
}

class _MemoryFlipGameState extends State<MemoryFlipGame> {
  // L1: emoji pairs only (pure memory)
  static const _l1Pairs = [
    ['🍎', '🍎'], ['🐶', '🐶'], ['🌟', '🌟'],
    ['🐱', '🐱'], ['🚀', '🚀'], ['🌈', '🌈'],
  ];
  // L2/L3: emoji → word (vocabulary memory)
  static const _allWordPairs = [
    ['🍎', 'APPLE'], ['🐶', 'DOG'], ['🌟', 'STAR'],
    ['🐱', 'CAT'],   ['🚀', 'ROCKET'], ['🌈', 'RAINBOW'],
    ['🏠', 'HOUSE'], ['🎈', 'BALLOON'], ['🦋', 'BUTTERFLY'],
    ['🌸', 'FLOWER'],
  ];

  int get _pairCount => widget.level == 1 ? 6 : widget.level == 2 ? 8 : 10;
  late List<_MemCard> _cards;
  int? _firstIdx;
  bool _locked = false;
  int _moves = 0, _matchedCount = 0;
  bool _gameOver = false;

  @override
  void initState() { super.initState(); _init(); }

  void _init() {
    final deck = <_MemCard>[];
    if (widget.level == 1) {
      for (int i = 0; i < _pairCount; i++) {
        deck.add(_MemCard(text: _l1Pairs[i][0], pairId: i));
        deck.add(_MemCard(text: _l1Pairs[i][1], pairId: i));
      }
    } else {
      final pairs = _allWordPairs.take(_pairCount).toList();
      for (int i = 0; i < pairs.length; i++) {
        deck.add(_MemCard(text: pairs[i][0], pairId: i));
        deck.add(_MemCard(text: pairs[i][1], pairId: i));
      }
    }
    deck.shuffle(Random());
    setState(() {
      _cards = deck; _firstIdx = null; _locked = false;
      _moves = 0; _matchedCount = 0; _gameOver = false;
    });
  }

  void _tap(int i) {
    if (_locked || _cards[i].flipped || _cards[i].matched) return;
    setState(() => _cards[i].flipped = true);
    if (_firstIdx == null) { _firstIdx = i; return; }
    final first = _firstIdx!;
    _firstIdx = null;
    _moves++;
    if (_cards[first].pairId == _cards[i].pairId && first != i) {
      setState(() {
        _cards[first].matched = true; _cards[i].matched = true; _matchedCount++;
        if (_matchedCount == _pairCount) _gameOver = true;
      });
    } else {
      _locked = true;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() { _cards[first].flipped = false; _cards[i].flipped = false; _locked = false; });
      });
    }
  }

  Color _cardBg(_MemCard c) {
    if (c.matched) return _kGreen.withOpacity(0.6);
    if (c.flipped) return _kAccent;
    return _kCard;
  }

  Widget _chip(IconData ic, String label, String val, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Icon(ic, color: color, size: 18), const SizedBox(width: 6),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            Text(val, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final cols = widget.level == 3 ? 5 : 4;
    final lvLabel = ['', '⭐', '⭐⭐', '⭐⭐⭐'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🃏 Memory Flip  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          Container(
            color: _kSurface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _chip(Icons.touch_app, 'Moves', '$_moves', Colors.blueAccent),
              _chip(Icons.check_circle, 'Matched', '$_matchedCount / $_pairCount', _kGreen),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.level == 1 ? 'Match the pairs! 🔍' : 'Match emoji to its word! 🔍',
              style: const TextStyle(color: Colors.white54, fontSize: 14)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: widget.level == 3 ? 0.75 : 0.85,
                ),
                itemCount: _cards.length,
                itemBuilder: (_, i) {
                  final c = _cards[i];
                  return GestureDetector(
                    onTap: () => _tap(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: _cardBg(c),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                        boxShadow: c.matched
                            ? [BoxShadow(color: _kGreen.withOpacity(0.3), blurRadius: 8)]
                            : [],
                      ),
                      child: Center(
                        child: c.flipped || c.matched
                            ? Text(c.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: c.text.length <= 2 ? (widget.level == 3 ? 22 : 26) : 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                            : const Text('?',
                                style: TextStyle(color: Colors.white38, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ]),
        if (_gameOver)
          _GameOverOverlay(score: _matchedCount, total: _pairCount, onRestart: _init, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 3. ➕ MATH RUN — 3 Levels
// L1: + only, 1-9, 15s | L2: +/−, 1-15, 12s | L3: +/−/×, 1-20, 10s
// ═══════════════════════════════════════════════════════════
class MathRunGame extends StatefulWidget {
  final int level;
  const MathRunGame({super.key, this.level = 1});
  @override
  State<MathRunGame> createState() => _MathRunGameState();
}

class _MathRunGameState extends State<MathRunGame> {
  int get _total => widget.level == 1 ? 10 : widget.level == 2 ? 12 : 15;
  int get _timePerQ => widget.level == 1 ? 15 : widget.level == 2 ? 12 : 10;
  int get _maxNum => widget.level == 1 ? 9 : widget.level == 2 ? 15 : 20;
  List<String> get _ops => widget.level == 1 ? ['+'] : widget.level == 2 ? ['+', '-'] : ['+', '-', '×'];

  final _rng = Random();
  int _score = 0, _lives = 3, _round = 0, _timeLeft = 15;
  bool _gameOver = false, _answered = false;
  late int _a, _b, _correct;
  late String _op;
  late List<int> _opts;
  Timer? _timer;
  int? _selected;

  @override
  void initState() { super.initState(); _next(); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _timePerQ;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_timeLeft <= 0) { t.cancel(); _timeout(); }
      else { setState(() => _timeLeft--); }
    });
  }

  void _timeout() {
    setState(() { _answered = true; if (--_lives <= 0) { _gameOver = true; return; } });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _next() {
    if (_round >= _total) { setState(() => _gameOver = true); return; }
    _op = _ops[_rng.nextInt(_ops.length)];
    _a = _rng.nextInt(_maxNum) + 1;
    _b = _rng.nextInt(_maxNum ~/ 2) + 1;
    if (_op == '-' && _b > _a) { final t = _a; _a = _b; _b = t; }
    _correct = _op == '+' ? _a + _b : _op == '-' ? _a - _b : _a * _b;
    final wrong = <int>{};
    while (wrong.length < 3) {
      final w = _correct + _rng.nextInt(11) - 5;
      if (w != _correct && w >= 0) wrong.add(w);
    }
    _opts = ([_correct, ...wrong])..shuffle(_rng);
    _answered = false; _selected = null;
    _startTimer();
  }

  void _pick(int opt) {
    if (_answered || _gameOver) return;
    _timer?.cancel();
    final ok = opt == _correct;
    setState(() {
      _answered = true; _selected = opt;
      if (ok) { _score++; } else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _restart() {
    _timer?.cancel();
    setState(() { _score = 0; _lives = 3; _round = 0; _gameOver = false; _answered = false; });
    _next();
  }

  Color _btnColor(int opt) {
    if (!_answered) return _kCard;
    if (opt == _correct) return _kGreen;
    if (opt == _selected) return _kRed;
    return _kCard;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = _timeLeft / _timePerQ;
    final timerColor = ratio > 0.5 ? _kGreen : ratio > 0.25 ? Colors.orange : _kRed;
    final lvLabel = ['', '⭐ Addition', '⭐⭐ Add & Subtract', '⭐⭐⭐ All Operations'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('➕ Math Run  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(current: _round, total: _total, score: _score, lives: _lives),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: 80, height: 80,
                child: Stack(alignment: Alignment.center, children: [
                  CircularProgressIndicator(
                      value: ratio, strokeWidth: 7,
                      backgroundColor: _kCard,
                      valueColor: AlwaysStoppedAnimation(timerColor)),
                  Text('$_timeLeft', style: TextStyle(color: timerColor, fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_kCard, _kSurface],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text('$_a  $_op  $_b  = ?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 4)),
              ),
              const SizedBox(height: 28),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 12, mainAxisSpacing: 12,
                childAspectRatio: 2.2,
                physics: const NeverScrollableScrollPhysics(),
                children: _opts.map((opt) => GestureDetector(
                  onTap: () => _pick(opt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    decoration: BoxDecoration(
                      color: _btnColor(opt),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white12),
                      boxShadow: [BoxShadow(color: _btnColor(opt).withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Center(child: Text('$opt',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                  ),
                )).toList(),
              ),
            ]),
          )),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _total, onRestart: _restart, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 4. 🫧 BUBBLE POP — 3 Levels
// L1: Count 1→10 | L2: Count 1→15 | L3: Count 1→20
// ═══════════════════════════════════════════════════════════
class _Bubble {
  final int number;
  double x, y;
  bool popped;
  _Bubble({required this.number, required this.x, required this.y, this.popped = false});
}

class BubblePopGame extends StatefulWidget {
  final int level;
  const BubblePopGame({super.key, this.level = 1});
  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  int get _max => widget.level == 1 ? 10 : widget.level == 2 ? 15 : 20;
  double get _bSize => widget.level == 3 ? 62.0 : 72.0;

  final _rng = Random();
  late List<_Bubble> _bubbles;
  int _nextNum = 1, _score = 0, _lives = 3;
  bool _gameOver = false, _shake = false;

  @override
  void initState() { super.initState(); _init(); }

  void _init() {
    final nums = List.generate(_max, (i) => i + 1)..shuffle(_rng);
    setState(() {
      _bubbles = nums.map((n) => _Bubble(
          number: n,
          x: 0.05 + _rng.nextDouble() * 0.78,
          y: 0.05 + _rng.nextDouble() * 0.80)).toList();
      _nextNum = 1; _score = 0; _lives = 3; _gameOver = false; _shake = false;
    });
  }

  void _pop(int num) {
    if (_gameOver) return;
    if (num == _nextNum) {
      setState(() {
        _bubbles.firstWhere((b) => b.number == num).popped = true;
        _score++; _nextNum++;
        if (_nextNum > _max) _gameOver = true;
      });
    } else {
      setState(() { _shake = true; if (--_lives <= 0) { _gameOver = true; return; } });
      Future.delayed(const Duration(milliseconds: 400),
          () => mounted ? setState(() => _shake = false) : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bSize = _bSize;
    final lvLabel = ['', '1 → 10', '1 → 15', '1 → 20'];
    const bubbleColors = [
      [Color(0xFF6C63FF), Color(0xFF48CAE4)],
      [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
      [Color(0xFF43A047), Color(0xFF00E5FF)],
      [Color(0xFFFF9800), Color(0xFFFFEB3B)],
      [Color(0xFFE91E63), Color(0xFF9C27B0)],
    ];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🫧 Bubble Pop  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          Container(
            color: _kSurface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(i < _lives ? Icons.favorite : Icons.favorite_border,
                    color: i < _lives ? _kRed : Colors.white24, size: 22),
              ))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 80),
                transform: _shake ? (Matrix4.identity()..translate(8.0)) : Matrix4.identity(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                      color: _kAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kAccent.withOpacity(0.5))),
                  child: Text('Tap: $_nextNum',
                      style: const TextStyle(color: _kAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  const Icon(Icons.star_rounded, color: _kGold, size: 18),
                  const SizedBox(width: 4),
                  Text('$_score', style: const TextStyle(color: _kGold, fontWeight: FontWeight.bold)),
                ]),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Count from 1 to $_max in order!',
                style: const TextStyle(color: Colors.white38, fontSize: 13)),
          ),
          Expanded(child: LayoutBuilder(builder: (ctx, box) {
            return Stack(children: _bubbles.map((b) {
              if (b.popped) return const SizedBox.shrink();
              final colors = bubbleColors[b.number % bubbleColors.length];
              final isNext = b.number == _nextNum;
              return Positioned(
                left: b.x * (box.maxWidth - bSize),
                top: b.y * (box.maxHeight - bSize),
                child: GestureDetector(
                  onTap: () => _pop(b.number),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: bSize, height: bSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: colors,
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      boxShadow: [BoxShadow(
                          color: colors[0].withOpacity(isNext ? 0.8 : 0.35),
                          blurRadius: isNext ? 22 : 10,
                          spreadRadius: isNext ? 3 : 0)],
                      border: isNext ? Border.all(color: Colors.white, width: 2.5) : null,
                    ),
                    child: Center(child: Text('${b.number}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: isNext ? 22 : 18,
                            fontWeight: FontWeight.bold,
                            shadows: const [Shadow(blurRadius: 4, color: Colors.black38)]))),
                  ),
                ),
              );
            }).toList());
          })),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _max, onRestart: _init, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 5. 🔷 SHAPE FINDER — 3 Levels
// L1: 4 shapes, 8 Qs | L2: 6 shapes, 10 Qs | L3: 6 shapes, 12 Qs harder
// ═══════════════════════════════════════════════════════════
class _ShapePainter extends CustomPainter {
  final String shape;
  final Color color;
  _ShapePainter(this.shape, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;
    switch (shape) {
      case 'Circle':
        canvas.drawCircle(Offset(cx, cy), r, p);
        break;
      case 'Square':
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2), p);
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r, cy + r * 0.8)
          ..lineTo(cx - r, cy + r * 0.8)
          ..close();
        canvas.drawPath(path, p);
        break;
      case 'Star':
        final path = Path();
        for (int i = 0; i < 10; i++) {
          final rad = (i * 36 - 90) * (3.14159 / 180);
          final ir = i.isEven ? r : r * 0.45;
          final x = cx + ir * cos(rad);
          final y = cy + ir * sin(rad);
          i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
        }
        path.close();
        canvas.drawPath(path, p);
        break;
      case 'Rectangle':
        canvas.drawRRect(RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(cx, cy), width: r * 2.2, height: r * 1.2),
            const Radius.circular(6)), p);
        break;
      case 'Diamond':
        final path = Path()
          ..moveTo(cx, cy - r)
          ..lineTo(cx + r * 0.7, cy)
          ..lineTo(cx, cy + r)
          ..lineTo(cx - r * 0.7, cy)
          ..close();
        canvas.drawPath(path, p);
        break;
    }
  }
  @override
  bool shouldRepaint(_ShapePainter o) => o.shape != shape || o.color != color;
}

class ShapeFinderGame extends StatefulWidget {
  final int level;
  const ShapeFinderGame({super.key, this.level = 1});
  @override
  State<ShapeFinderGame> createState() => _ShapeFinderGameState();
}

class _ShapeFinderGameState extends State<ShapeFinderGame> {
  static const _allShapes = ['Circle', 'Square', 'Triangle', 'Star', 'Rectangle', 'Diamond'];
  static const _colors = [
    Color(0xFF7C6FFF), Color(0xFF43A047), Color(0xFFFF6B6B),
    Color(0xFFFFD700), Color(0xFF26C6DA), Color(0xFFEC407A),
  ];
  int get _total => widget.level == 1 ? 8 : widget.level == 2 ? 10 : 12;
  int get _shapeCount => widget.level == 1 ? 4 : 6;

  final _rng = Random();
  int _score = 0, _lives = 3, _round = 0;
  bool _gameOver = false, _answered = false;
  late String _target;
  late List<String> _opts;
  int? _selectedIdx;

  @override
  void initState() { super.initState(); _next(); }

  void _next() {
    if (_round >= _total) { setState(() => _gameOver = true); return; }
    final pool = List<String>.from(_allShapes.take(_shapeCount))..shuffle(_rng);
    _opts = pool.take(4).toList();
    _target = _opts[_rng.nextInt(4)];
    _answered = false; _selectedIdx = null;
  }

  void _pick(int idx) {
    if (_answered || _gameOver) return;
    final ok = _opts[idx] == _target;
    setState(() {
      _answered = true; _selectedIdx = idx;
      if (ok) { _score++; } else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _restart() => setState(() { _score = 0; _lives = 3; _round = 0; _gameOver = false; _next(); });

  Color _colorFor(String shape) => _colors[_allShapes.indexOf(shape) % _colors.length];

  @override
  Widget build(BuildContext context) {
    final lvLabel = ['', '⭐ Basic', '⭐⭐ More Shapes', '⭐⭐⭐ Expert'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🔷 Shape Finder  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(current: _round, total: _total, score: _score, lives: _lives),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [_kCard, _kSurface],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(children: [
                  const Text('Tap the shape:', style: TextStyle(color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(_target, style: TextStyle(
                      color: _colorFor(_target), fontSize: 36,
                      fontWeight: FontWeight.w900, letterSpacing: 3)),
                ]),
              ),
              const SizedBox(height: 28),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 14, mainAxisSpacing: 14,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(_opts.length, (i) {
                  final shape = _opts[i];
                  final isTarget = shape == _target;
                  Color bg = _kCard;
                  if (_answered) {
                    if (isTarget) bg = _kGreen.withOpacity(0.7);
                    else if (i == _selectedIdx) bg = _kRed.withOpacity(0.7);
                  }
                  return GestureDetector(
                    onTap: () => _pick(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: bg, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        CustomPaint(
                          size: const Size(80, 80),
                          painter: _ShapePainter(shape,
                              _answered ? (isTarget ? _kGreen : Colors.white38) : _colorFor(shape)),
                        ),
                        const SizedBox(height: 8),
                        Text(shape, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  );
                }),
              ),
            ]),
          )),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _total, onRestart: _restart, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 6. ⚡ QUICK TAP — 3 Levels
// L1: Letters A-J, 30s | L2: All A-Z, 25s | L3: Numbers 1-30, 20s
// ═══════════════════════════════════════════════════════════
class QuickTapGame extends StatefulWidget {
  final int level;
  const QuickTapGame({super.key, this.level = 1});
  @override
  State<QuickTapGame> createState() => _QuickTapGameState();
}

class _QuickTapGameState extends State<QuickTapGame> {
  static const _lettersEasy = ['A','B','C','D','E','F','G','H','I','J'];
  static const _lettersAll  = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
  static const _numbers     = ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30'];

  int get _total => 15;
  int get _gameSecs => widget.level == 1 ? 30 : widget.level == 2 ? 25 : 20;
  List<String> get _pool => widget.level == 1 ? _lettersEasy : widget.level == 2 ? _lettersAll : _numbers;

  final _rng = Random();
  int _score = 0, _lives = 3, _round = 0, _timeLeft = 30;
  bool _gameOver = false, _answered = false;
  late String _target;
  late List<String> _grid;
  Timer? _timer;

  @override
  void initState() { super.initState(); _startTimer(); _next(); }
  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = _gameSecs;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_timeLeft <= 0) { t.cancel(); setState(() => _gameOver = true); }
      else { setState(() => _timeLeft--); }
    });
  }

  void _next() {
    if (_round >= _total) { setState(() => _gameOver = true); return; }
    final picked = (List<String>.from(_pool)..shuffle(_rng)).take(9).toList();
    _target = picked[_rng.nextInt(9)];
    _grid = picked..shuffle(_rng);
    _answered = false;
  }

  void _tap(String val) {
    if (_answered || _gameOver) return;
    final ok = val == _target;
    setState(() {
      _answered = true;
      if (ok) { _score++; } else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _restart() {
    _timer?.cancel();
    setState(() { _score = 0; _lives = 3; _round = 0; _gameOver = false; });
    _startTimer(); _next();
  }

  @override
  Widget build(BuildContext context) {
    final timerRatio = _timeLeft / _gameSecs;
    final timerColor = timerRatio > 0.5 ? _kGreen : timerRatio > 0.25 ? Colors.orange : _kRed;
    final lvLabel = ['', '⭐ A-J', '⭐⭐ A-Z', '⭐⭐⭐ Numbers'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('⚡ Quick Tap  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(current: _round, total: _total, score: _score, lives: _lives),
          Expanded(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 64, height: 64,
                  child: Stack(alignment: Alignment.center, children: [
                    CircularProgressIndicator(
                        value: timerRatio, strokeWidth: 5,
                        backgroundColor: _kCard,
                        valueColor: AlwaysStoppedAnimation(timerColor)),
                    Text('$_timeLeft', style: TextStyle(color: timerColor, fontSize: 18, fontWeight: FontWeight.bold)),
                  ]),
                ),
                const SizedBox(width: 20),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_kAccent, Color(0xFF48CAE4)]),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(children: [
                    const Text('Find this:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    Text(_target, style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                  ]),
                )),
              ]),
              const SizedBox(height: 28),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 12, mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: _grid.map((val) {
                  final isTarget = val == _target;
                  Color bg = _kCard;
                  if (_answered && isTarget) bg = _kGreen;
                  return GestureDetector(
                    onTap: () => _tap(val),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: bg, borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                        boxShadow: [BoxShadow(color: bg.withOpacity(0.4), blurRadius: 8)],
                      ),
                      child: Center(child: Text(val,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: val.length > 1 ? 20 : 30,
                              fontWeight: FontWeight.bold))),
                    ),
                  );
                }).toList(),
              ),
            ]),
          )),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _total, onRestart: _restart, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 7. 🔤 WORD SPELL — 3 Levels
// L1: 3-4 letter words | L2: 5-6 letter words | L3: 7-8 letter words
// ═══════════════════════════════════════════════════════════
class WordSpellGame extends StatefulWidget {
  final int level;
  const WordSpellGame({super.key, this.level = 1});
  @override
  State<WordSpellGame> createState() => _WordSpellGameState();
}

class _WordSpellGameState extends State<WordSpellGame> {
  static const _l1 = [
    {'emoji':'🐕','word':'DOG',  'hint':'Man\'s best friend'},
    {'emoji':'🐈','word':'CAT',  'hint':'Says meow'},
    {'emoji':'☀️','word':'SUN',  'hint':'Shines in the day'},
    {'emoji':'🐝','word':'BEE',  'hint':'Makes honey'},
    {'emoji':'🐷','word':'PIG',  'hint':'Lives on a farm'},
    {'emoji':'🐄','word':'COW',  'hint':'Gives us milk'},
    {'emoji':'🐜','word':'ANT',  'hint':'Very tiny bug'},
    {'emoji':'🍳','word':'EGG',  'hint':'Chickens lay these'},
    {'emoji':'🌙','word':'MOON', 'hint':'Glows at night'},
    {'emoji':'🎵','word':'SONG', 'hint':'Music you sing'},
  ];
  static const _l2 = [
    {'emoji':'🍎','word':'APPLE',  'hint':'A red fruit'},
    {'emoji':'🏠','word':'HOUSE',  'hint':'Where you live'},
    {'emoji':'🍞','word':'BREAD',  'hint':'Made from wheat'},
    {'emoji':'🍇','word':'GRAPE',  'hint':'Small purple fruit'},
    {'emoji':'🐴','word':'HORSE',  'hint':'You can ride it'},
    {'emoji':'🕐','word':'CLOCK',  'hint':'Tells the time'},
    {'emoji':'👟','word':'SHOES',  'hint':'You wear on feet'},
    {'emoji':'🌸','word':'FLOWER', 'hint':'Plants produce these'},
    {'emoji':'🍊','word':'ORANGE', 'hint':'Citrus fruit'},
    {'emoji':'🎠','word':'CASTLE', 'hint':'Kings live here'},
  ];
  static const _l3 = [
    {'emoji':'🌈','word':'RAINBOW',   'hint':'7 colors in the sky'},
    {'emoji':'🎈','word':'BALLOON',   'hint':'Floats in the air'},
    {'emoji':'🐔','word':'CHICKEN',   'hint':'Clucks on the farm'},
    {'emoji':'🐬','word':'DOLPHIN',   'hint':'Smart ocean animal'},
    {'emoji':'🌋','word':'VOLCANO',   'hint':'Mountain of fire'},
    {'emoji':'🐧','word':'PENGUIN',   'hint':'Cannot fly, loves cold'},
    {'emoji':'🦋','word':'BUTTERFLY', 'hint':'Beautiful insect'},
    {'emoji':'🐘','word':'ELEPHANT',  'hint':'Biggest land animal'},
    {'emoji':'🦜','word':'PARROT',    'hint':'Can repeat your words'},
    {'emoji':'🦒','word':'GIRAFFE',   'hint':'Tallest animal'},
  ];

  List<Map<String, String>> get _words => widget.level == 1
      ? List<Map<String, String>>.from(_l1)
      : widget.level == 2
          ? List<Map<String, String>>.from(_l2)
          : List<Map<String, String>>.from(_l3);

  final _rng = Random();
  int _score = 0, _lives = 3, _round = 0;
  bool _gameOver = false, _hintUsed = false;
  late List<Map<String, String>> _shuffled;
  late Map<String, String> _current;
  late List<String> _tiles;
  final List<String> _typed = [];

  @override
  void initState() {
    super.initState();
    _shuffled = List.from(_words)..shuffle(_rng);
    _next();
  }

  void _next() {
    if (_round >= _shuffled.length) { setState(() => _gameOver = true); return; }
    _current = _shuffled[_round];
    final word = _current['word']!;
    const extras = ['E','R','T','S','N','I','O','A','L','P','M','U'];
    final pool = (List<String>.from(extras)..shuffle(_rng)).take(4);
    _tiles = [...word.split(''), ...pool]..shuffle(_rng);
    _typed.clear();
    _hintUsed = false;
  }

  void _tapTile(int idx) {
    if (_typed.length >= _current['word']!.length) return;
    setState(() => _typed.add(_tiles[idx]));
    if (_typed.length == _current['word']!.length) _checkWord();
  }

  void _backspace() {
    if (_typed.isEmpty) return;
    setState(() => _typed.removeLast());
  }

  void _useHint() {
    if (_hintUsed) return;
    setState(() { _hintUsed = true; if (_typed.isEmpty) _typed.add(_current['word']![0]); });
  }

  void _checkWord() {
    final ok = _typed.join() == _current['word'];
    setState(() {
      if (ok) { _score++; } else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() { _round++; _next(); });
    });
  }

  void _restart() {
    _shuffled = List.from(_words)..shuffle(_rng);
    setState(() { _score = 0; _lives = 3; _round = 0; _gameOver = false; _next(); });
  }

  @override
  Widget build(BuildContext context) {
    final word = _current['word']!;
    final typed = _typed.join();
    Color slotBg = _kCard;
    if (_typed.length == word.length) {
      slotBg = typed == word ? _kGreen.withOpacity(0.5) : _kRed.withOpacity(0.5);
    }
    final lvLabel = ['', '⭐ Short Words', '⭐⭐ Medium Words', '⭐⭐⭐ Long Words'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🔤 Word Spell  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(current: _round, total: _shuffled.length, score: _score, lives: _lives),
          Expanded(child: SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF48CAE4)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(_current['emoji']!, style: const TextStyle(fontSize: 72)),
              ),
              const SizedBox(height: 8),
              Text(_current['hint']!, style: const TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(color: slotBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(word.length, (i) {
                  final filled = i < _typed.length;
                  return Container(
                    width: (word.length > 6) ? 30 : 36, height: 44,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: filled ? _kAccent.withOpacity(0.4) : Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: filled ? _kAccent : Colors.white24),
                    ),
                    child: Center(child: Text(filled ? _typed[i] : '',
                        style: TextStyle(color: Colors.white, fontSize: (word.length > 6) ? 16 : 20, fontWeight: FontWeight.bold))),
                  );
                })),
              ),
              const SizedBox(height: 20),
              Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center,
                  children: List.generate(_tiles.length, (i) => GestureDetector(
                    onTap: () => _tapTile(i),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9C63FF)]),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: _kAccent.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))],
                      ),
                      child: Center(child: Text(_tiles[i],
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ))),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                GestureDetector(
                  onTap: _backspace,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.backspace, color: Colors.white60, size: 18),
                      SizedBox(width: 6),
                      Text('Back', style: TextStyle(color: Colors.white60)),
                    ]),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _hintUsed ? null : _useHint,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: _hintUsed ? _kCard.withOpacity(0.5) : _kGold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _hintUsed ? Colors.white12 : _kGold),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.lightbulb, color: _hintUsed ? Colors.white24 : _kGold, size: 18),
                      const SizedBox(width: 6),
                      Text('Hint', style: TextStyle(color: _hintUsed ? Colors.white24 : _kGold)),
                    ]),
                  ),
                ),
              ]),
            ]),
          ))),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _shuffled.length, onRestart: _restart, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 8. 🐾 ANIMAL QUIZ — 3 Levels
// L1: 6 common pets | L2: 10 wild animals | L3: 12 exotic, harder options
// ═══════════════════════════════════════════════════════════
class AnimalQuizGame extends StatefulWidget {
  final int level;
  const AnimalQuizGame({super.key, this.level = 1});
  @override
  State<AnimalQuizGame> createState() => _AnimalQuizGameState();
}

class _AnimalQuizGameState extends State<AnimalQuizGame> {
  static const _l1 = [
    {'e':'🐶','a':'Dog',     'o':['Dog','Cat','Fish','Bird'],        'f':'Dogs are the most loyal pets in the world!'},
    {'e':'🐱','a':'Cat',     'o':['Rabbit','Cat','Dog','Hamster'],   'f':'Cats sleep up to 16 hours a day!'},
    {'e':'🐟','a':'Fish',    'o':['Fish','Crab','Duck','Frog'],      'f':'Fish can feel pain and stress too.'},
    {'e':'🐰','a':'Rabbit',  'o':['Mouse','Rabbit','Squirrel','Fox'],'f':'Rabbits can jump 3 feet high!'},
    {'e':'🐴','a':'Horse',   'o':['Donkey','Camel','Horse','Deer'],  'f':'Horses can sleep both standing and lying down.'},
    {'e':'🐓','a':'Chicken', 'o':['Duck','Chicken','Turkey','Goose'],'f':'Chickens have their own language with 30+ sounds!'},
  ];
  static const _l2 = [
    {'e':'🐘','a':'Elephant','o':['Lion','Elephant','Tiger','Bear'],        'f':'Elephants never forget — best memory of any animal!'},
    {'e':'🦁','a':'Lion',    'o':['Cheetah','Leopard','Lion','Tiger'],      'f':'Lions are the only cats that live in groups called prides.'},
    {'e':'🦊','a':'Fox',     'o':['Wolf','Cat','Fox','Dog'],                'f':'Foxes use Earth\'s magnetic field to hunt prey!'},
    {'e':'🐧','a':'Penguin', 'o':['Duck','Penguin','Eagle','Parrot'],       'f':'Penguins propose with pebbles — they give rocks as gifts!'},
    {'e':'🐬','a':'Dolphin', 'o':['Shark','Whale','Dolphin','Fish'],        'f':'Dolphins sleep with one eye open to stay alert!'},
    {'e':'🦒','a':'Giraffe', 'o':['Camel','Giraffe','Horse','Zebra'],       'f':'A giraffe\'s tongue is 18 inches long and dark purple!'},
    {'e':'🦓','a':'Zebra',   'o':['Horse','Donkey','Zebra','Deer'],         'f':'Every zebra has a unique stripe pattern, like fingerprints!'},
    {'e':'🐊','a':'Crocodile','o':['Crocodile','Lizard','Alligator','Gecko'],'f':'Crocodiles have been on Earth for 200 million years!'},
    {'e':'🐆','a':'Cheetah', 'o':['Leopard','Tiger','Cheetah','Jaguar'],    'f':'Cheetahs can accelerate from 0 to 60 mph in 3 seconds!'},
    {'e':'🦏','a':'Rhino',   'o':['Hippo','Elephant','Rhino','Buffalo'],    'f':'A rhino\'s horn is made of the same stuff as your nails!'},
  ];
  static const _l3 = [
    {'e':'🦈','a':'Shark',    'o':['Shark','Whale','Dolphin','Ray'],         'f':'Sharks have been on Earth for 450 million years!'},
    {'e':'🦜','a':'Parrot',   'o':['Parrot','Crow','Sparrow','Owl'],         'f':'Parrots can mimic speech and live 80+ years!'},
    {'e':'🦋','a':'Butterfly','o':['Moth','Butterfly','Bee','Dragonfly'],    'f':'Butterflies taste with their feet — truly!'},
    {'e':'🐙','a':'Octopus',  'o':['Squid','Jellyfish','Octopus','Crab'],    'f':'Octopuses have 3 hearts and blue blood!'},
    {'e':'🦩','a':'Flamingo', 'o':['Crane','Heron','Flamingo','Stork'],      'f':'Flamingos are pink because of the food they eat!'},
    {'e':'🐺','a':'Wolf',     'o':['Fox','Coyote','Wolf','Hyena'],           'f':'Wolves howl to communicate with their pack over long distances.'},
    {'e':'🦦','a':'Otter',    'o':['Beaver','Otter','Mink','Seal'],          'f':'Otters hold hands while sleeping so they don\'t drift apart!'},
    {'e':'🦚','a':'Peacock',  'o':['Turkey','Peacock','Pheasant','Eagle'],   'f':'Only male peacocks have the beautiful tail feathers!'},
    {'e':'🐻','a':'Polar Bear','o':['Grizzly','Polar Bear','Panda','Seal'],  'f':'Polar bears have black skin under their white fur!'},
    {'e':'🦕','a':'Dinosaur', 'o':['Dragon','Dinosaur','Crocodile','Lizard'],'f':'Dinosaurs roamed Earth for 165 million years!'},
  ];

  int get _total => widget.level == 1 ? 6 : widget.level == 2 ? 10 : 10;
  List<Map<String, Object>> get _allQ => widget.level == 1
      ? List<Map<String, Object>>.from(_l1)
      : widget.level == 2
          ? List<Map<String, Object>>.from(_l2)
          : List<Map<String, Object>>.from(_l3);

  final _rng = Random();
  late List<Map<String, Object>> _questions;
  int _score = 0, _lives = 3, _round = 0;
  bool _gameOver = false, _answered = false;
  String? _selected;
  late List<String> _opts;

  @override
  void initState() {
    super.initState();
    _questions = List.from(_allQ)..shuffle(_rng);
    _setupRound();
  }

  void _setupRound() {
    if (_round >= _total) { setState(() => _gameOver = true); return; }
    final q = _questions[_round % _questions.length];
    _opts = List<String>.from(q['o'] as List)..shuffle(_rng);
    _answered = false; _selected = null;
  }

  void _pick(String opt) {
    if (_answered || _gameOver) return;
    final q = _questions[_round % _questions.length];
    final ok = opt == (q['a'] as String);
    setState(() {
      _answered = true; _selected = opt;
      if (ok) { _score++; } else { if (--_lives <= 0) { _gameOver = true; return; } }
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() { _round++; _setupRound(); });
    });
  }

  void _restart() {
    _questions = List.from(_allQ)..shuffle(_rng);
    setState(() { _score = 0; _lives = 3; _round = 0; _gameOver = false; });
    _setupRound();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_round % _questions.length];
    final answer = q['a'] as String;
    final fact = q['f'] as String;
    final lvLabel = ['', '⭐ Pets', '⭐⭐ Wild Animals', '⭐⭐⭐ Exotic'];
    return Scaffold(
      backgroundColor: _kBg,
      appBar: _gameAppBar('🐾 Animal Quiz  ${lvLabel[widget.level]}'),
      body: Stack(children: [
        Column(children: [
          _ProgressHeader(current: _round, total: _total, score: _score, lives: _lives),
          Expanded(child: SingleChildScrollView(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(q['e'] as String, style: const TextStyle(fontSize: 90)),
              ),
              const SizedBox(height: 16),
              const Text('Which animal is this?',
                  style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              ..._opts.map((opt) {
                Color bg = _kCard;
                if (_answered) {
                  if (opt == answer) bg = _kGreen;
                  else if (opt == _selected) bg = _kRed;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => _pick(opt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: bg, borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                        boxShadow: [BoxShadow(color: bg.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Text(opt, textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              }),
              if (_answered) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _kAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _kAccent.withOpacity(0.4)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('💡', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(fact,
                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5))),
                  ]),
                ),
              ],
            ]),
          ))),
        ]),
        if (_gameOver) _GameOverOverlay(score: _score, total: _total, onRestart: _restart, onBack: () => Navigator.pop(context)),
      ]),
    );
  }
}
