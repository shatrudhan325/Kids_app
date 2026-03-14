import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

////////////////////////////////////////////////////////
/// 🎨 COLOR MATCH
////////////////////////////////////////////////////////

class ColorMatchGame extends StatefulWidget {
  const ColorMatchGame({super.key});

  @override
  State<ColorMatchGame> createState() => _ColorMatchGameState();
}

class _ColorMatchGameState extends State<ColorMatchGame> {
  final colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];

  late Color target;
  int score = 0;

  @override
  void initState() {
    super.initState();
    nextRound();
  }

  void nextRound() {
    colors.shuffle();
    target = colors.first;
  }

  void check(Color selected) {
    if (selected == target) score++;
    setState(() => nextRound());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Color Match")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score: $score"),
          const SizedBox(height: 20),
          Container(height: 120, width: 120, color: target),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            children: colors
                .map(
                  (c) => GestureDetector(
                    onTap: () => check(c),
                    child: Container(height: 70, width: 70, color: c),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🃏 MEMORY FLIP
////////////////////////////////////////////////////////

class MemoryFlipGame extends StatefulWidget {
  const MemoryFlipGame({super.key});

  @override
  State<MemoryFlipGame> createState() => _MemoryFlipGameState();
}

class _MemoryFlipGameState extends State<MemoryFlipGame> {
  List<String> cards = ["🍎", "🍎", "🐶", "🐶", "⭐", "⭐"];
  List<bool> flipped = [];
  int? first;

  @override
  void initState() {
    super.initState();
    cards.shuffle();
    flipped = List.generate(cards.length, (_) => false);
  }

  void flip(int i) {
    if (flipped[i]) return;

    setState(() => flipped[i] = true);

    if (first == null) {
      first = i;
    } else {
      if (cards[first!] != cards[i]) {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            flipped[first!] = false;
            flipped[i] = false;
          });
        });
      }
      first = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memory Flip")),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: cards.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => flip(i),
          child: Card(
            child: Center(
              child: Text(
                flipped[i] ? cards[i] : "?",
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ➕ MATH RUN
////////////////////////////////////////////////////////

class MathRunGame extends StatefulWidget {
  const MathRunGame({super.key});

  @override
  State<MathRunGame> createState() => _MathRunGameState();
}

class _MathRunGameState extends State<MathRunGame> {
  int a = 0;
  int b = 0;
  int score = 0;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    next();
  }

  void next() {
    final r = Random();
    a = r.nextInt(10);
    b = r.nextInt(10);
  }

  void check() {
    if (int.tryParse(controller.text) == a + b) score++;
    controller.clear();
    setState(() => next());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Math Run")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score: $score"),
          const SizedBox(height: 20),
          Text("$a + $b = ?", style: const TextStyle(fontSize: 30)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(controller: controller),
          ),
          ElevatedButton(onPressed: check, child: const Text("Submit")),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🫧 BUBBLE POP GAME
////////////////////////////////////////////////////////

class BubblePopGame extends StatefulWidget {
  const BubblePopGame({super.key});

  @override
  State<BubblePopGame> createState() => _BubblePopGameState();
}

class _BubblePopGameState extends State<BubblePopGame> {
  int score = 0;

  void pop() {
    setState(() => score++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bubble Pop")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Score: $score"),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: pop,
            child: const Icon(Icons.circle, size: 120, color: Colors.pink),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🔷 SHAPE FINDER
////////////////////////////////////////////////////////

class ShapeFinderGame extends StatelessWidget {
  const ShapeFinderGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shape Finder")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        children: const [
          Icon(Icons.circle, size: 80),
          Icon(Icons.square, size: 80),
          Icon(Icons.star, size: 80),
          Icon(Icons.favorite, size: 80),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ⚡ QUICK TAP GAME
////////////////////////////////////////////////////////

class QuickTapGame extends StatefulWidget {
  const QuickTapGame({super.key});

  @override
  State<QuickTapGame> createState() => _QuickTapGameState();
}

class _QuickTapGameState extends State<QuickTapGame> {
  int score = 0;
  int timeLeft = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 0) {
        t.cancel();
      } else {
        setState(() => timeLeft--);
      }
    });
  }

  void tap() {
    if (timeLeft > 0) setState(() => score++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quick Tap")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Time: $timeLeft"),
          Text("Score: $score"),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: tap,
            child: const Icon(Icons.flash_on, size: 100, color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
