import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kids_app/Const/progress_service.dart';
import 'package:kids_app/Screens/Learn.dart';
import 'package:kids_app/Screens/Quize.dart';
import 'package:kids_app/Screens/Drawing.dart';
import 'package:kids_app/Screens/Games.dart';
import 'package:kids_app/Screens/Magic_ai.dart';

// ═══════════════════════════════════════════════════════════════════
//  ADVANCED KIDS DASHBOARD — Premium Edition
// ═══════════════════════════════════════════════════════════════════

class AdvancedKidsDashboard extends StatefulWidget {
  const AdvancedKidsDashboard({super.key});
  @override
  State<AdvancedKidsDashboard> createState() => _AdvancedKidsDashboardState();
}

class _AdvancedKidsDashboardState extends State<AdvancedKidsDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final _progress = ProgressService();

  // ── Animation Controllers ──────────────────────────────────
  late AnimationController _bgController;
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late AnimationController _funFactController;

  // ── Fun Facts Auto-Scroll ──────────────────────────────────
  final PageController _funFactPC = PageController(viewportFraction: 0.88);
  int _funFactPage = 0;
  Timer? _funFactTimer;

  // ── Feature Cards Data ─────────────────────────────────────
  final List<Map<String, dynamic>> features = [
    {
      'title': 'Learn',
      'icon': '📚',
      'colors': [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      'subtitle': 'Explore Lessons',
      'routeName': 'learn',
      'badge': '',
    },
    {
      'title': 'Games',
      'icon': '🎮',
      'colors': [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      'subtitle': '8 Fun Games',
      'routeName': 'games',
      'badge': 'HOT',
    },
    {
      'title': 'Drawing',
      'icon': '🎨',
      'colors': [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      'subtitle': 'Draw & Create',
      'routeName': 'drawing',
      'badge': 'NEW',
    },
    {
      'title': 'Quiz',
      'icon': '🧩',
      'colors': [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      'subtitle': 'Win Badges',
      'routeName': 'quiz',
      'badge': 'NEW',
    },
    {
      'title': 'Magic AI',
      'icon': '✨',
      'colors': [const Color(0xFFFFD200), const Color(0xFFFF6B00)],
      'subtitle': 'Ask Anything!',
      'routeName': 'magic',
      'badge': '⚡',
    },
  ];

  // ── Fun Facts ──────────────────────────────────────────────
  static const List<Map<String, dynamic>> _funFacts = [
    {'emoji': '🐝', 'fact': 'Honey never spoils! Jars 3000 years old are still edible.', 'grad': [Color(0xFFFFB347), Color(0xFFFF6B6B)]},
    {'emoji': '🐙', 'fact': 'Octopuses have 3 hearts and blue blood!', 'grad': [Color(0xFF6EC6FF), Color(0xFF2979FF)]},
    {'emoji': '⚡', 'fact': 'Lightning is 5 times hotter than the sun\'s surface!', 'grad': [Color(0xFFFFEB3B), Color(0xFFFF9800)]},
    {'emoji': '🦕', 'fact': 'Dinosaurs lived on Earth for 165 million years!', 'grad': [Color(0xFF66BB6A), Color(0xFF388E3C)]},
    {'emoji': '🌍', 'fact': 'Earth spins at 1,670 km/hr — faster than a jet!', 'grad': [Color(0xFF42A5F5), Color(0xFF1565C0)]},
    {'emoji': '🐳', 'fact': 'A blue whale\'s tongue weighs as much as an elephant!', 'grad': [Color(0xFF26C6DA), Color(0xFF00838F)]},
    {'emoji': '🍌', 'fact': 'Bananas are berries, but strawberries are not!', 'grad': [Color(0xFFFFCA28), Color(0xFFF57F17)]},
    {'emoji': '🌙', 'fact': 'The Moon is slowly drifting away from Earth!', 'grad': [Color(0xFF7E57C2), Color(0xFF311B92)]},
  ];

  // Daily challenge is now managed by ProgressService

  @override
  void initState() {
    super.initState();

    // Listen for progress changes
    _progress.addListener(_onProgressChanged);

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _funFactController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Auto-scroll fun facts
    _funFactTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_funFactPage + 1) % _funFacts.length;
      _funFactPC.animateToPage(next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    });
  }

  void _onProgressChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _progress.removeListener(_onProgressChanged);
    _bgController.dispose();
    _pulseController.dispose();
    _bounceController.dispose();
    _funFactController.dispose();
    _funFactPC.dispose();
    _funFactTimer?.cancel();
    super.dispose();
  }

  // ── Time-based greeting ────────────────────────────────────
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get _greetEmoji {
    final h = DateTime.now().hour;
    if (h < 12) return '🌅';
    if (h < 17) return '☀️';
    return '🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                _buildDailyChallengeBanner(),
                _buildQuickStats(),
                _buildFunFactsCarousel(),
                _buildSectionTitle('🚀 Pick an Adventure'),
                _buildFeaturedCard(),
                _buildFeatureGrid(),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
          _buildFloatingNavbar(),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ANIMATED BACKGROUND with floating particles
  // ═══════════════════════════════════════════════════════════
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F0E17),
                Color(0xFF1A1A2E),
                Color(0xFF16213E),
                Color(0xFF0F0E17),
              ],
              stops: [0.0, 0.35, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: List.generate(14, (i) {
              final rng = Random(i * 42);
              final size = 60.0 + rng.nextDouble() * 180;
              final dx = rng.nextDouble();
              final dy = rng.nextDouble();
              final opacity = 0.03 + rng.nextDouble() * 0.06;
              final colors = [
                Colors.blueAccent, Colors.purpleAccent,
                Colors.cyanAccent, Colors.pinkAccent,
                Colors.tealAccent, Colors.orangeAccent,
              ];
              final color = colors[i % colors.length];
              // Gentle floating offset
              final phase = i * 0.45;
              final floatX = sin((_bgController.value * 2 * pi) + phase) * 12;
              final floatY = cos((_bgController.value * 2 * pi) + phase) * 10;

              return Positioned(
                left: MediaQuery.of(context).size.width * dx + floatX - size / 2,
                top: MediaQuery.of(context).size.height * dy + floatY - size / 2,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color.withOpacity(opacity),
                        color.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  HEADER — Time greeting + Streak + Avatar
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    final sw = MediaQuery.of(context).size.width;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        (sw * 0.06).clamp(16.0, 28.0), 20,
        (sw * 0.06).clamp(16.0, 28.0), 8,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  Row(
                    children: [
                      Text(
                        '$_greetEmoji $_greeting,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: (sw * 0.038).clamp(13.0, 17.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bachoo! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (sw * 0.07).clamp(24.0, 32.0),
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Streak badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B6B).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${_progress.streakDays} Day Streak!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (sw * 0.028).clamp(10.0, 13.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Avatar with animated glow
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, child) {
                final glow = 0.3 + _pulseController.value * 0.4;
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFD200).withOpacity(glow),
                        const Color(0xFFFF6B00).withOpacity(glow),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFD200).withOpacity(glow * 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: child,
                );
              },
              child: const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF1E2A45),
                child: Text('🦁', style: TextStyle(fontSize: 32)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  DAILY CHALLENGE BANNER
  // ═══════════════════════════════════════════════════════════
  Widget _buildDailyChallengeBanner() {
    final sw = MediaQuery.of(context).size.width;
    final challenge = _progress.todayChallenge;
    final challengePercent = _progress.dailyChallengePercent;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: (sw * 0.05).clamp(16.0, 24.0),
          vertical: 10,
        ),
        padding: EdgeInsets.all((sw * 0.05).clamp(16.0, 22.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((sw * 0.07).clamp(22.0, 30.0)),
          gradient: LinearGradient(
            colors: challengePercent >= 1.0
                ? [const Color(0xFF43E97B), const Color(0xFF38F9D7)]
                : [const Color(0xFF7C6FFF), const Color(0xFF48CAE4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C6FFF).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Progress Ring
            SizedBox(
              width: (sw * 0.18).clamp(58.0, 78.0),
              height: (sw * 0.18).clamp(58.0, 78.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: challengePercent,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    challengePercent >= 1.0 ? '✅' : challenge['emoji'] as String,
                    style: TextStyle(
                      fontSize: (sw * 0.08).clamp(26.0, 36.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: (sw * 0.04).clamp(12.0, 18.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      challengePercent >= 1.0 ? '🎉 CHALLENGE COMPLETE!' : '🎯 TODAY\'S CHALLENGE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (sw * 0.024).clamp(9.0, 11.0),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: (sw * 0.02).clamp(6.0, 10.0)),
                  Text(
                    challenge['text'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (sw * 0.04).clamp(14.0, 18.0),
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: (sw * 0.015).clamp(4.0, 8.0)),
                  Text(
                    '${_progress.dailyChallengeProgress}/${_progress.dailyChallengeGoal} done · ${(challengePercent * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: (sw * 0.03).clamp(10.0, 13.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  QUICK STATS ROW
  // ═══════════════════════════════════════════════════════════
  Widget _buildQuickStats() {
    final sw = MediaQuery.of(context).size.width;
    final stats = [
      {'emoji': '⭐', 'label': 'Stars', 'value': '${_progress.stars}', 'color': const Color(0xFFFFD200)},
      {'emoji': '🏆', 'label': 'Badges', 'value': '${_progress.badges}', 'color': const Color(0xFFFF9800)},
      {'emoji': '📚', 'label': 'Lessons', 'value': '${_progress.lessonsCompleted}', 'color': const Color(0xFF42A5F5)},
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (sw * 0.05).clamp(16.0, 24.0),
          vertical: 12,
        ),
        child: Row(
          children: stats.map((stat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(
                  vertical: (sw * 0.035).clamp(12.0, 18.0),
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (stat['color'] as Color).withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (stat['color'] as Color).withOpacity(0.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      stat['emoji'] as String,
                      style: TextStyle(fontSize: (sw * 0.06).clamp(20.0, 28.0)),
                    ),
                    SizedBox(height: (sw * 0.01).clamp(3.0, 6.0)),
                    Text(
                      stat['value'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (sw * 0.05).clamp(18.0, 24.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      stat['label'] as String,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: (sw * 0.028).clamp(10.0, 13.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FUN FACTS CAROUSEL
  // ═══════════════════════════════════════════════════════════
  Widget _buildFunFactsCarousel() {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              (sw * 0.06).clamp(16.0, 28.0), 12,
              (sw * 0.06).clamp(16.0, 28.0), 8,
            ),
            child: Row(
              children: [
                Text(
                  '💡 Did You Know?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (sw * 0.045).clamp(16.0, 20.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Dot indicators
                Row(
                  children: List.generate(
                    _funFacts.length.clamp(0, 5),
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: i == (_funFactPage % 5) ? 16 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: i == (_funFactPage % 5)
                            ? Colors.cyanAccent
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: (sh * 0.12).clamp(80.0, 100.0),
            child: PageView.builder(
              controller: _funFactPC,
              onPageChanged: (i) => setState(() => _funFactPage = i),
              itemCount: _funFacts.length,
              itemBuilder: (_, i) {
                final fact = _funFacts[i];
                final grad = fact['grad'] as List<Color>;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  padding: EdgeInsets.symmetric(
                    horizontal: (sw * 0.04).clamp(14.0, 20.0),
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [grad[0].withOpacity(0.85), grad[1].withOpacity(0.85)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: grad[0].withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        fact['emoji'] as String,
                        style: TextStyle(fontSize: (sw * 0.09).clamp(30.0, 42.0)),
                      ),
                      SizedBox(width: (sw * 0.03).clamp(8.0, 14.0)),
                      Expanded(
                        child: Text(
                          fact['fact'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: (sw * 0.033).clamp(12.0, 15.0),
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  SECTION TITLE
  // ═══════════════════════════════════════════════════════════
  Widget _buildSectionTitle(String title) {
    final sw = MediaQuery.of(context).size.width;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        (sw * 0.06).clamp(16.0, 28.0), 18,
        (sw * 0.06).clamp(16.0, 28.0), 10,
      ),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: (sw * 0.052).clamp(18.0, 24.0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FEATURED CARD — Full-width Learn card
  // ═══════════════════════════════════════════════════════════
  Widget _buildFeaturedCard() {
    final sw = MediaQuery.of(context).size.width;
    final learn = features[0];

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => _handleCardTap('learn'),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: (sw * 0.05).clamp(16.0, 24.0),
          ),
          height: (sw * 0.38).clamp(110.0, 160.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((sw * 0.065).clamp(22.0, 28.0)),
            gradient: LinearGradient(
              colors: learn['colors'] as List<Color>,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: (learn['colors'] as List<Color>)[0].withOpacity(0.45),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -30, top: -30,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                left: -20, bottom: -40,
                child: Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all((sw * 0.05).clamp(16.0, 24.0)),
                child: Row(
                  children: [
                    // Animated bounce icon
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (_, __) {
                        final offset = sin(_bounceController.value * pi) * 6;
                        return Transform.translate(
                          offset: Offset(0, -offset),
                          child: Text(
                            learn['icon'] as String,
                            style: TextStyle(
                              fontSize: (sw * 0.14).clamp(46.0, 64.0),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: (sw * 0.04).clamp(12.0, 20.0)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            learn['title'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (sw * 0.06).clamp(20.0, 28.0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Hindi · ABC · Stories · Science & more',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: (sw * 0.03).clamp(10.0, 14.0),
                            ),
                          ),
                          SizedBox(height: (sw * 0.02).clamp(6.0, 12.0)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: (sw * 0.035).clamp(12.0, 18.0),
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow_rounded,
                                    color: (learn['colors'] as List<Color>)[0],
                                    size: (sw * 0.04).clamp(14.0, 20.0)),
                                const SizedBox(width: 4),
                                Text(
                                  'Start Learning',
                                  style: TextStyle(
                                    color: (learn['colors'] as List<Color>)[0],
                                    fontWeight: FontWeight.bold,
                                    fontSize: (sw * 0.03).clamp(11.0, 14.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FEATURE GRID — 2x2 for Games, Videos, Quiz, Magic AI
  // ═══════════════════════════════════════════════════════════
  Widget _buildFeatureGrid() {
    final sw = MediaQuery.of(context).size.width;
    final gridFeatures = features.sublist(1); // Skip Learn (featured above)

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: (sw * 0.05).clamp(16.0, 24.0),
        vertical: 12,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: (sw * 0.035).clamp(12.0, 18.0),
          mainAxisSpacing: (sw * 0.035).clamp(12.0, 18.0),
          childAspectRatio: (sw < 360) ? 0.82 : 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _PremiumKidCard(
            data: gridFeatures[index],
            bounceAnimation: _bounceController,
            onTap: () => _handleCardTap(gridFeatures[index]['routeName']),
          ),
          childCount: gridFeatures.length,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  NAVIGATION HANDLING
  // ═══════════════════════════════════════════════════════════
  void _handleCardTap(String routeName) {
    Widget nextScreen;
    switch (routeName) {
      case 'learn':
        nextScreen = const LearnScreen();
        break;
      case 'games':
        nextScreen = const GamesScreen();
        break;
      case 'drawing':
        nextScreen = const DrawingScreen();
        break;
      case 'quiz':
        nextScreen = const QuizScreen();
        break;
      case 'magic':
        nextScreen = const MagicAIPage();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FLOATING BOTTOM NAVBAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildFloatingNavbar() {
    final sw = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: (sw * 0.2).clamp(72.0, 85.0),
        margin: EdgeInsets.all((sw * 0.05).clamp(16.0, 24.0)),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.home_rounded, 0, 'Home'),
                _navItem(Icons.auto_awesome_rounded, 1, 'Magic'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    final isSelected = _selectedIndex == index;
    final isMagic = index == 1;
    final sw = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (isMagic) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MagicAIPage()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected && !isMagic
              ? (sw * 0.05).clamp(16.0, 24.0)
              : (sw * 0.035).clamp(10.0, 16.0),
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected && !isMagic
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected && !isMagic
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isMagic
                  ? Colors.orangeAccent
                  : (isSelected ? const Color(0xFF6E48AA) : Colors.white54),
              size: isMagic ? 30 : 26,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isMagic
                    ? Colors.orangeAccent
                    : (isSelected ? const Color(0xFF6E48AA) : Colors.white54),
                fontSize: (sw * 0.026).clamp(9.0, 12.0),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            // Active dot indicator
            if (isSelected && !isMagic) ...[
              const SizedBox(height: 3),
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6E48AA),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  PREMIUM KID CARD — with badges, animations, and glow
// ═══════════════════════════════════════════════════════════════════
class _PremiumKidCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  final Animation<double> bounceAnimation;

  const _PremiumKidCard({
    required this.data,
    required this.onTap,
    required this.bounceAnimation,
  });

  @override
  State<_PremiumKidCard> createState() => _PremiumKidCardState();
}

class _PremiumKidCardState extends State<_PremiumKidCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final colors = widget.data['colors'] as List<Color>;
    final badge = widget.data['badge'] as String;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _scale = 0.92);
      },
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((sw * 0.065).clamp(22.0, 28.0)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -18, bottom: -18,
                child: Container(
                  width: sw * 0.2, height: sw * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                left: -12, top: -12,
                child: Container(
                  width: sw * 0.12, height: sw * 0.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
              ),
              // Badge
              if (badge.isNotEmpty)
                Positioned(
                  right: (sw * 0.03).clamp(8.0, 14.0),
                  top: (sw * 0.03).clamp(8.0, 14.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: badge == 'NEW'
                          ? Colors.redAccent
                          : badge == 'HOT'
                              ? Colors.deepOrange
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: badge != '⚡'
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: badge == '⚡'
                            ? (sw * 0.04).clamp(14.0, 18.0)
                            : (sw * 0.024).clamp(8.0, 11.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Main content
              Padding(
                padding: EdgeInsets.all((sw * 0.04).clamp(14.0, 20.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouncing icon
                    AnimatedBuilder(
                      animation: widget.bounceAnimation,
                      builder: (_, __) {
                        final offset = sin(widget.bounceAnimation.value * pi) * 4;
                        return Transform.translate(
                          offset: Offset(0, -offset),
                          child: Text(
                            widget.data['icon'] as String,
                            style: TextStyle(
                              fontSize: (sw * 0.12).clamp(40.0, 54.0),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: (sw * 0.025).clamp(8.0, 14.0)),
                    Text(
                      widget.data['title'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (sw * 0.048).clamp(16.0, 22.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: (sw * 0.01).clamp(2.0, 6.0)),
                    Text(
                      widget.data['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: (sw * 0.028).clamp(10.0, 13.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Play arrow
              Positioned(
                right: (sw * 0.025).clamp(8.0, 12.0),
                bottom: (sw * 0.025).clamp(8.0, 12.0),
                child: Container(
                  width: (sw * 0.075).clamp(26.0, 34.0),
                  height: (sw * 0.075).clamp(26.0, 34.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: (sw * 0.045).clamp(16.0, 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
