import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_app/Const/Quiz_data.dart';
import 'package:kids_app/Const/Quiz_game.dart';
import 'package:kids_app/Const/progress_service.dart';

// ═══════════════════════════════════════════════════════════════════
//  QUIZ HUB — Premium Dark-themed Quiz Category Screen
// ═══════════════════════════════════════════════════════════════════

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final _progress = ProgressService();
  late AnimationController _bgController;
  late AnimationController _pulseController;
  String _selectedFilter = 'All';

  static const _filters = ['All', 'Easy', 'Science', 'Language', 'Math'];

  List<QuizCategory> get _filtered {
    if (_selectedFilter == 'All') return QuizContent.categories;
    if (_selectedFilter == 'Easy') {
      return QuizContent.categories.where((c) =>
        ['Animals', 'Fruits', 'Colors', 'Shapes'].contains(c.name)).toList();
    }
    if (_selectedFilter == 'Science') {
      return QuizContent.categories.where((c) =>
        ['Science', 'Space', 'Body'].contains(c.name)).toList();
    }
    if (_selectedFilter == 'Language') {
      return QuizContent.categories.where((c) =>
        ['Hindi', 'GK'].contains(c.name)).toList();
    }
    if (_selectedFilter == 'Math') {
      return QuizContent.categories.where((c) =>
        ['Numbers', 'Shapes'].contains(c.name)).toList();
    }
    return QuizContent.categories;
  }

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final hPad = (sw * 0.048).clamp(12.0, 22.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: Stack(
        children: [
          _buildAnimatedBg(sw, sh),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── App Bar ──
              SliverAppBar(
                pinned: true,
                expandedHeight: (sh * 0.09).clamp(60.0, 80.0),
                backgroundColor: const Color(0xFF1A1A2E),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('🧩 Quiz Zone',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                          fontSize: (sw * 0.05).clamp(16.0, 22.0))),
                  titlePadding: EdgeInsets.only(left: hPad, bottom: 14),
                ),
              ),

              // ── Stats Banner ──
              SliverToBoxAdapter(child: _buildStatsBanner(sw, sh, hPad)),

              // ── Featured Quiz ──
              SliverToBoxAdapter(child: _buildFeaturedQuiz(sw, sh, hPad)),

              // ── Filter Chips ──
              SliverToBoxAdapter(child: _buildFilterChips(sw, sh, hPad)),

              // ── Section Label ──
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 4),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    '${_filtered.length} Categor${_filtered.length == 1 ? 'y' : 'ies'}',
                    style: TextStyle(color: Colors.white38,
                        fontSize: (sw * 0.028).clamp(10.0, 13.0), letterSpacing: 1),
                  ),
                ),
              ),

              // ── Quiz Grid ──
              SliverPadding(
                padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 32),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: (sw * 0.035).clamp(10.0, 16.0),
                    mainAxisSpacing: (sw * 0.035).clamp(10.0, 16.0),
                    childAspectRatio: sw < 360 ? 0.78 : 0.88,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _buildCategoryCard(_filtered[i], sw, sh),
                    childCount: _filtered.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  ANIMATED BACKGROUND
  // ═══════════════════════════════════════════════════════════
  Widget _buildAnimatedBg(double sw, double sh) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (_, __) => Stack(
        children: List.generate(8, (i) {
          final rng = Random(i * 37);
          final size = 60.0 + rng.nextDouble() * 140;
          final dx = rng.nextDouble();
          final dy = rng.nextDouble();
          final opacity = 0.03 + rng.nextDouble() * 0.05;
          final colors = [
            Colors.pinkAccent, Colors.purpleAccent,
            Colors.cyanAccent, Colors.orangeAccent,
          ];
          final color = colors[i % colors.length];
          final phase = i * 0.5;
          final floatX = sin((_bgController.value * 2 * pi) + phase) * 10;
          final floatY = cos((_bgController.value * 2 * pi) + phase) * 8;

          return Positioned(
            left: sw * dx + floatX - size / 2,
            top: sh * dy + floatY - size / 2,
            child: Container(
              width: size, height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(opacity), color.withOpacity(0)],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  STATS BANNER
  // ═══════════════════════════════════════════════════════════
  Widget _buildStatsBanner(double sw, double sh, double hPad) {
    final totalQuestions = QuizContent.categories
        .fold<int>(0, (s, c) => s + c.levels.values.fold<int>(0, (ss, l) => ss + l.length));
    return Container(
      margin: EdgeInsets.fromLTRB(hPad, hPad, hPad, 0),
      padding: EdgeInsets.all((sw * 0.04).clamp(14.0, 20.0)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular((sw * 0.06).clamp(20.0, 28.0)),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statChip('🧩', 'Topics', '${QuizContent.categories.length}', const Color(0xFFF093FB)),
          _statChip('❓', 'Questions', '$totalQuestions', const Color(0xFF48CAE4)),
          _statChip('📝', 'Taken', '${_progress.quizzesTaken}', const Color(0xFF43E97B)),
          _statChip('⭐', 'Stars', '${_progress.stars}', const Color(0xFFFFD200)),
        ],
      ),
    );
  }

  Widget _statChip(String emoji, String label, String value, Color color) {
    final sw = MediaQuery.of(context).size.width;
    return Column(children: [
      Text(emoji, style: TextStyle(fontSize: (sw * 0.05).clamp(18.0, 24.0))),
      SizedBox(height: (sw * 0.008).clamp(2.0, 4.0)),
      Text(value, style: TextStyle(color: Colors.white, fontSize: (sw * 0.04).clamp(14.0, 18.0), fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white54, fontSize: (sw * 0.025).clamp(9.0, 11.0))),
    ]);
  }

  // ═══════════════════════════════════════════════════════════
  //  FEATURED QUIZ (rotating daily)
  // ═══════════════════════════════════════════════════════════
  Widget _buildFeaturedQuiz(double sw, double sh, double hPad) {
    final dayIdx = DateTime.now().day % QuizContent.categories.length;
    final featured = QuizContent.categories[dayIdx];
    final featuredH = (sh * 0.2).clamp(130.0, 170.0);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizLevelSelect(category: featured),
        ));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(hPad, hPad, hPad, 0),
        height: featuredH,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular((sw * 0.07).clamp(20.0, 30.0)),
          gradient: LinearGradient(
            colors: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFFF093FB).withOpacity(0.45), blurRadius: 24, offset: const Offset(0, 8)),
          ],
        ),
        child: Stack(children: [
          Positioned(right: -20, top: -20,
            child: Container(width: featuredH * 0.9, height: featuredH * 0.9,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.07)))),
          Positioned(left: -15, bottom: -30,
            child: Container(width: featuredH * 0.6, height: featuredH * 0.6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
          Padding(
            padding: EdgeInsets.all(hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: (sw * 0.025).clamp(8.0, 12.0), vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text('🎯 QUIZ OF THE DAY', style: TextStyle(color: Colors.white,
                      fontSize: (sw * 0.026).clamp(9.0, 12.0), fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                SizedBox(height: (sh * 0.012).clamp(6.0, 12.0)),
                Row(children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) {
                      final offset = sin(_pulseController.value * pi) * 5;
                      return Transform.translate(
                        offset: Offset(0, -offset),
                        child: Text(featured.icon, style: TextStyle(fontSize: (sw * 0.088).clamp(28.0, 40.0))),
                      );
                    },
                  ),
                  SizedBox(width: (sw * 0.03).clamp(8.0, 14.0)),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(featured.name, style: TextStyle(color: Colors.white,
                        fontSize: (sw * 0.054).clamp(18.0, 24.0), fontWeight: FontWeight.bold)),
                    Text(featured.subtitle, style: TextStyle(color: Colors.white70,
                        fontSize: (sw * 0.032).clamp(11.0, 14.0))),
                  ])),
                ]),
                SizedBox(height: (sh * 0.012).clamp(6.0, 10.0)),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: (sw * 0.05).clamp(14.0, 22.0),
                      vertical: (sh * 0.008).clamp(5.0, 8.0)),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.play_arrow_rounded, color: const Color(0xFFF5576C),
                        size: (sw * 0.048).clamp(16.0, 22.0)),
                    const SizedBox(width: 4),
                    Text('Start Quiz', style: TextStyle(color: const Color(0xFFF5576C),
                        fontWeight: FontWeight.bold, fontSize: (sw * 0.032).clamp(11.0, 14.0))),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FILTER CHIPS
  // ═══════════════════════════════════════════════════════════
  Widget _buildFilterChips(double sw, double sh, double hPad) {
    return SizedBox(
      height: (sh * 0.065).clamp(44.0, 56.0),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: (sh * 0.012).clamp(6.0, 10.0)),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _filters[i];
          final active = cat == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: (sw * 0.04).clamp(12.0, 18.0), vertical: 6),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFF093FB) : const Color(0xFF1E2A45),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: active ? const Color(0xFFF093FB) : Colors.white24),
              ),
              child: Text(cat, style: TextStyle(
                  color: active ? Colors.white : Colors.white60,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  fontSize: (sw * 0.032).clamp(11.0, 14.0))),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  CATEGORY CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildCategoryCard(QuizCategory cat, double sw, double sh) {
    final totalQ = cat.levels.values.fold<int>(0, (s, l) => s + l.length);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => QuizLevelSelect(category: cat),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cat.colors[0].withOpacity(0.85), cat.colors[1].withOpacity(0.85)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular((sw * 0.06).clamp(18.0, 26.0)),
          boxShadow: [
            BoxShadow(color: cat.colors[0].withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 6)),
          ],
        ),
        child: Stack(children: [
          // Decorative blob
          Positioned(right: -14, bottom: -14,
            child: Container(width: sw * 0.18, height: sw * 0.18,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
          Padding(
            padding: EdgeInsets.all((sw * 0.04).clamp(12.0, 18.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                if (cat.badge.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(10)),
                    child: Text(cat.badge, style: TextStyle(fontSize: (sw * 0.024).clamp(9.0, 11.0))),
                  ),
                if (cat.badge.isEmpty) const SizedBox(height: 20),
                const Spacer(),
                Text(cat.icon, style: TextStyle(fontSize: (sw * 0.1).clamp(32.0, 44.0))),
                SizedBox(height: (sh * 0.008).clamp(4.0, 8.0)),
                Text(cat.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                    fontSize: (sw * 0.036).clamp(12.0, 16.0))),
                SizedBox(height: (sh * 0.004).clamp(2.0, 4.0)),
                Text(cat.subtitle, style: TextStyle(color: Colors.white70,
                    fontSize: (sw * 0.026).clamp(9.0, 12.0))),
                SizedBox(height: (sh * 0.008).clamp(4.0, 8.0)),
                // Questions count pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Text('$totalQ Qs · 3 Levels', style: TextStyle(color: Colors.white,
                      fontSize: (sw * 0.022).clamp(8.0, 10.0))),
                ),
              ],
            ),
          ),
          // Play arrow
          Positioned(
            right: (sw * 0.025).clamp(8.0, 14.0),
            bottom: (sw * 0.025).clamp(8.0, 14.0),
            child: Container(
              width: (sw * 0.08).clamp(26.0, 36.0),
              height: (sw * 0.08).clamp(26.0, 36.0),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white,
                  size: (sw * 0.05).clamp(16.0, 22.0)),
            ),
          ),
        ]),
      ),
    );
  }
}
