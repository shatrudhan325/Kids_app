import 'package:flutter/material.dart';
import 'package:kids_app/Const/All_games.dart';

class GamesContent {
  static final List<Map<String, dynamic>> games = [
    {
      "name": "Color Match",
      "icon": "🎨",
      "color": Colors.orange,
      "description": "Match the correct color",
      "screen": const ColorMatchGame(),
    },
    {
      "name": "Memory Flip",
      "icon": "🃏",
      "color": Colors.green,
      "description": "Find matching cards",
      "screen": const MemoryFlipGame(),
    },
    {
      "name": "Math Run",
      "icon": "🏃",
      "color": Colors.blue,
      "description": "Solve math quickly",
      "screen": const MathRunGame(),
    },
    {
      "name": "Bubble Pop",
      "icon": "🫧",
      "color": Colors.pink,
      "description": "Pop the bubbles fast",
      "screen": const BubblePopGame(),
    },
    {
      "name": "Shape Finder",
      "icon": "🔷",
      "color": Colors.purple,
      "description": "Identify shapes",
      "screen": const ShapeFinderGame(),
    },
    {
      "name": "Quick Tap",
      "icon": "⚡",
      "color": Colors.red,
      "description": "Tap as fast as you can",
      "screen": const QuickTapGame(),
    },
  ];
}
