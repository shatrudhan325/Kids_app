import 'package:flutter/material.dart';
import 'package:kids_app/Const/Games_data.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("🎮 Fun Zone"),
            backgroundColor: Color(0xFF1A1A2E),
            pinned: true,
          ),
          SliverToBoxAdapter(child: _buildFeaturedGame(context)),
          _buildGameGrid(context),
        ],
      ),
    );
  }

  ////////////////////////////////////////////////////////
  /// FEATURED GAME (Clickable)
  ////////////////////////////////////////////////////////

  Widget _buildFeaturedGame(BuildContext context) {
    final featuredGame = GamesContent.games.first;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => featuredGame['screen']),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.blueAccent],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "QUEST OF THE DAY",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Color Match",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.play_arrow_rounded, color: Colors.white, size: 50),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  /// GAME GRID (No Switch Case Needed)
  ////////////////////////////////////////////////////////

  Widget _buildGameGrid(BuildContext context) {
    final games = GamesContent.games;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          final game = games[i];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => game['screen']),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: game['color'] as Color,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(game['icon'], style: const TextStyle(fontSize: 40)),
                  const SizedBox(height: 10),
                  Text(
                    game['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      game['description'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }, childCount: games.length),
      ),
    );
  }
}
