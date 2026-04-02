import 'package:flutter/material.dart';
import 'package:kids_app/Const/All_games.dart';

class GamesContent {
  static final List<Map<String, dynamic>> games = [
    {
      "name": "Color Match",
      "icon": "🎨",
      "color": const Color(0xFFF57C00),
      "description": "Learn color names",
      "difficulty": "Easy",
      "category": "Visual",
      "screen": const LevelSelectScreen(
        name: "Color Match",
        icon: "🎨",
        description: "Identify colors by their name!\nTap the color that matches.",
        builder: _colorMatch,
      ),
    },
    {
      "name": "Memory Flip",
      "icon": "🃏",
      "color": const Color(0xFF2E7D32),
      "description": "Match emoji to words",
      "difficulty": "Medium",
      "category": "Memory",
      "screen": const LevelSelectScreen(
        name: "Memory Flip",
        icon: "🃏",
        description: "Find matching card pairs!\nFlip cards and train your memory.",
        builder: _memoryFlip,
      ),
    },
    {
      "name": "Math Run",
      "icon": "➕",
      "color": const Color(0xFF1565C0),
      "description": "Solve math fast!",
      "difficulty": "Hard",
      "category": "Math",
      "screen": const LevelSelectScreen(
        name: "Math Run",
        icon: "➕",
        description: "Solve math problems quickly!\nChoose the correct answer.",
        builder: _mathRun,
      ),
    },
    {
      "name": "Bubble Pop",
      "icon": "🫧",
      "color": const Color(0xFFAD1457),
      "description": "Count in order",
      "difficulty": "Easy",
      "category": "Math",
      "screen": const LevelSelectScreen(
        name: "Bubble Pop",
        icon: "🫧",
        description: "Pop bubbles in the right order!\nCount from 1 to the last number.",
        builder: _bubblePop,
      ),
    },
    {
      "name": "Shape Finder",
      "icon": "🔷",
      "color": const Color(0xFF6A1B9A),
      "description": "Identify shapes",
      "difficulty": "Easy",
      "category": "Visual",
      "screen": const LevelSelectScreen(
        name: "Shape Finder",
        icon: "🔷",
        description: "Find and identify shapes!\nTap the shape that matches the name.",
        builder: _shapeFinder,
      ),
    },
    {
      "name": "Quick Tap",
      "icon": "⚡",
      "color": const Color(0xFFC62828),
      "description": "Find letters & numbers",
      "difficulty": "Medium",
      "category": "Language",
      "screen": const LevelSelectScreen(
        name: "Quick Tap",
        icon: "⚡",
        description: "Find the letter or number fast!\nTap before time runs out.",
        builder: _quickTap,
      ),
    },
    {
      "name": "Word Spell",
      "icon": "🔤",
      "color": const Color(0xFF4527A0),
      "description": "Spell with tiles",
      "difficulty": "Medium",
      "category": "Language",
      "screen": const LevelSelectScreen(
        name: "Word Spell",
        icon: "🔤",
        description: "Spell the word using letter tiles!\nTap letters in the right order.",
        builder: _wordSpell,
      ),
    },
    {
      "name": "Animal Quiz",
      "icon": "🐾",
      "color": const Color(0xFFBF360C),
      "description": "Guess + learn facts",
      "difficulty": "Easy",
      "category": "Science",
      "screen": const LevelSelectScreen(
        name: "Animal Quiz",
        icon: "🐾",
        description: "Guess the animal from its emoji!\nLearn amazing animal facts.",
        builder: _animalQuiz,
      ),
    },
  ];

  static Widget _colorMatch(int level) => ColorMatchGame(level: level);
  static Widget _memoryFlip(int level) => MemoryFlipGame(level: level);
  static Widget _mathRun(int level) => MathRunGame(level: level);
  static Widget _bubblePop(int level) => BubblePopGame(level: level);
  static Widget _shapeFinder(int level) => ShapeFinderGame(level: level);
  static Widget _quickTap(int level) => QuickTapGame(level: level);
  static Widget _wordSpell(int level) => WordSpellGame(level: level);
  static Widget _animalQuiz(int level) => AnimalQuizGame(level: level);
}
