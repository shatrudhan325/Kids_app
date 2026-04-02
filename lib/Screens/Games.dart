import 'package:flutter/material.dart';
import 'package:kids_app/Const/Games_data.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});
  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  static const _categories = ['All', 'Math', 'Language', 'Visual', 'Memory', 'Science'];
  String _selected = 'All';

  List<Map<String, dynamic>> get _filtered => _selected == 'All'
      ? GamesContent.games
      : GamesContent.games.where((g) => g['category'] == _selected).toList();

  Color _diffColor(String d) => d == 'Easy'
      ? const Color(0xFF43A047)
      : d == 'Medium'
          ? const Color(0xFFFFA726)
          : const Color(0xFFEF5350);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final isSmall = sw < 360;
    final hPad = (sw * 0.048).clamp(12.0, 22.0);
    final featuredH = (sh * 0.22).clamp(140.0, 190.0);
    final gridAspect = isSmall ? 0.78 : sw > 414 ? 0.95 : 0.88;
    final featured = GamesContent.games.first;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: (sh * 0.09).clamp(60.0, 80.0),
            backgroundColor: const Color(0xFF1A1A2E),
            flexibleSpace: FlexibleSpaceBar(
              title: Text('🎮 Fun Zone',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (sw * 0.05).clamp(16.0, 22.0))),
              titlePadding: EdgeInsets.only(left: hPad, bottom: 14),
            ),
          ),

          // ── Featured Card ─────────────────────────────────
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => featured['screen'])),
              child: Container(
                margin: EdgeInsets.fromLTRB(hPad, hPad, hPad, 0),
                height: featuredH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular((sw * 0.07).clamp(20.0, 30.0)),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C6FFF), Color(0xFF48CAE4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF7C6FFF).withOpacity(0.45),
                        blurRadius: 24,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Stack(children: [
                  Positioned(
                    right: -20, top: -20,
                    child: Container(
                      width: featuredH * 0.9,
                      height: featuredH * 0.9,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(hPad),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: (sw * 0.025).clamp(8.0, 12.0),
                              vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('⭐ GAME OF THE DAY',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (sw * 0.026).clamp(9.0, 12.0),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1)),
                        ),
                        SizedBox(height: (sh * 0.012).clamp(6.0, 12.0)),
                        Row(children: [
                          Text(featured['icon'],
                              style: TextStyle(
                                  fontSize: (sw * 0.088).clamp(28.0, 40.0))),
                          SizedBox(width: (sw * 0.03).clamp(8.0, 14.0)),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(featured['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: (sw * 0.054).clamp(18.0, 24.0),
                                          fontWeight: FontWeight.bold)),
                                  Text(featured['description'],
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: (sw * 0.032).clamp(11.0, 14.0))),
                                ]),
                          ),
                        ]),
                        SizedBox(height: (sh * 0.015).clamp(8.0, 14.0)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: (sw * 0.05).clamp(14.0, 22.0),
                              vertical: (sh * 0.01).clamp(6.0, 10.0)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.play_arrow_rounded,
                                color: const Color(0xFF7C6FFF),
                                size: (sw * 0.048).clamp(16.0, 22.0)),
                            const SizedBox(width: 4),
                            Text('Play Now',
                                style: TextStyle(
                                    color: const Color(0xFF7C6FFF),
                                    fontWeight: FontWeight.bold,
                                    fontSize: (sw * 0.032).clamp(11.0, 14.0))),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),

          // ── Category Chips ────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: (sh * 0.065).clamp(44.0, 56.0),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: hPad,
                    vertical: (sh * 0.012).clamp(6.0, 10.0)),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final active = cat == _selected;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                          horizontal: (sw * 0.04).clamp(12.0, 18.0),
                          vertical: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF7C6FFF)
                            : const Color(0xFF1E2A45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: active
                                ? const Color(0xFF7C6FFF)
                                : Colors.white24),
                      ),
                      child: Text(cat,
                          style: TextStyle(
                              color: active ? Colors.white : Colors.white60,
                              fontWeight: active
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: (sw * 0.032).clamp(11.0, 14.0))),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Section Label ────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 4),
            sliver: SliverToBoxAdapter(
              child: Text(
                '${_filtered.length} Game${_filtered.length == 1 ? '' : 's'}',
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: (sw * 0.028).clamp(10.0, 13.0),
                    letterSpacing: 1),
              ),
            ),
          ),

          // ── Game Grid ─────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 32),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: (sw * 0.035).clamp(10.0, 16.0),
                mainAxisSpacing: (sw * 0.035).clamp(10.0, 16.0),
                childAspectRatio: gridAspect,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final game = _filtered[i];
                  final diff = game['difficulty'] as String;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => game['screen'])),
                    child: Container(
                      decoration: BoxDecoration(
                        color: (game['color'] as Color).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(
                            (sw * 0.06).clamp(18.0, 26.0)),
                        boxShadow: [
                          BoxShadow(
                              color: (game['color'] as Color).withOpacity(0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: Stack(children: [
                        // decorative blob
                        Positioned(
                          right: -14, bottom: -14,
                          child: Container(
                            width: sw * 0.18,
                            height: sw * 0.18,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.08)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              (sw * 0.04).clamp(12.0, 18.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Difficulty badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(diff,
                                    style: TextStyle(
                                        color: _diffColor(diff),
                                        fontSize: (sw * 0.024).clamp(9.0, 11.0),
                                        fontWeight: FontWeight.bold)),
                              ),
                              const Spacer(),
                              Text(game['icon'],
                                  style: TextStyle(
                                      fontSize: (sw * 0.1).clamp(32.0, 44.0))),
                              SizedBox(height: (sh * 0.008).clamp(4.0, 8.0)),
                              Text(game['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: (sw * 0.036).clamp(12.0, 16.0))),
                              SizedBox(height: (sh * 0.004).clamp(2.0, 4.0)),
                              Text(game['description'],
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: (sw * 0.026).clamp(9.0, 12.0))),
                              SizedBox(height: (sh * 0.01).clamp(6.0, 10.0)),
                              // Category pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(game['category'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (sw * 0.024).clamp(9.0, 11.0))),
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
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2)),
                            child: Icon(Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: (sw * 0.05).clamp(16.0, 22.0)),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
