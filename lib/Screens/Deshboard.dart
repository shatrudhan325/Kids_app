import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Ensure these filenames match your actual files exactly (Case Sensitive)
import 'package:kids_app/Screens/Learn.dart';
import 'package:kids_app/Screens/Quize.dart'; // Check if this should be Quiz.dart
import 'package:kids_app/Screens/Videos.dart';
import 'package:kids_app/Screens/Games.dart';
import 'package:kids_app/Screens/Magic_ai.dart';

class AdvancedKidsDashboard extends StatefulWidget {
  const AdvancedKidsDashboard({Key? key}) : super(key: key);

  @override
  State<AdvancedKidsDashboard> createState() => _AdvancedKidsDashboardState();
}

class _AdvancedKidsDashboardState extends State<AdvancedKidsDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> features = [
    {
      "title": "Learn",
      "icon": "📚",
      "colors": [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      "subtitle": "12 Lessons",
      "routeName": "learn",
    },
    {
      "title": "Games",
      "icon": "🎮",
      "colors": [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      "subtitle": "New Highscore!",
      "routeName": "games",
    },
    {
      "title": "Videos",
      "icon": "📺",
      "colors": [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      "subtitle": "Watch & Sing",
      "routeName": "videos",
    },
    {
      "title": "Quiz",
      "icon": "🧩",
      "colors": [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      "subtitle": "Win Badges",
      "routeName": "quiz",
    },
  ];

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
                _buildRewardHeroCard(),
                _buildSectionTitle("Pick an Adventure"),
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

  // --- BACKGROUND ---
  Widget _buildAnimatedBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6E48AA), Color(0xFF9D50BB), Color(0xFF1A1A2E)],
        ),
      ),
      child: Stack(
        children: [
          _buildBlob(
            top: -50,
            left: -50,
            color: Colors.blueAccent.withOpacity(0.3),
          ),
          _buildBlob(
            bottom: 100,
            right: -50,
            color: Colors.pinkAccent.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildBlob({
    double? top,
    double? left,
    double? right,
    double? bottom,
    required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 100, spreadRadius: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "👋 Hello Bachoo!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Let's play and learn!",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            _buildAvatarCircle(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarCircle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: const CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white,
        child: Text("🦁", style: TextStyle(fontSize: 30)),
      ),
    );
  }

  Widget _buildRewardHeroCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9A9E).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Level 10 Explorer",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You're doing great! 🌟",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.7,
                      minHeight: 12,
                      backgroundColor: Colors.white30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            const Text("🏆", style: TextStyle(fontSize: 50)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 15),
      sliver: SliverToBoxAdapter(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _KidCard(
            data: features[index],
            onTap: () => _handleCardTap(features[index]['routeName']),
          ),
          childCount: features.length,
        ),
      ),
    );
  }

  void _handleCardTap(String routeName) {
    Widget nextScreen;
    switch (routeName) {
      case "learn":
        nextScreen = const LearnScreen();
        break;
      case "games":
        nextScreen = const GamesScreen();
        break;
      case "videos":
        nextScreen = const VideosScreen();
        break;
      case "quiz":
        nextScreen = const QuizScreen();
        break;
      default:
        return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  Widget _buildFloatingNavbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 85,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navIcon(Icons.home_rounded, 0, "Home"),
                _navIcon(Icons.auto_awesome_rounded, 1, "Magic"),
                _navIcon(Icons.face_rounded, 2, "Me"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ONLY ONE VERSION OF THIS FUNCTION ALLOWED:
  Widget _navIcon(IconData icon, int index, String label) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MagicAIPage()),
          );
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected && index != 1 ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: index == 1
                  ? Colors.orangeAccent
                  : (isSelected ? Colors.deepPurple : Colors.white60),
              size: index == 1 ? 32 : 28,
            ),
            if (isSelected && index != 1) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _KidCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;
  const _KidCard({required this.data, required this.onTap});

  @override
  State<_KidCard> createState() => _KidCardState();
}

class _KidCardState extends State<_KidCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
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
            borderRadius: BorderRadius.circular(35),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.data['colors'],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.data['colors'][0].withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.data['icon'], style: const TextStyle(fontSize: 50)),
              const SizedBox(height: 12),
              Text(
                widget.data['title'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data['subtitle'],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
