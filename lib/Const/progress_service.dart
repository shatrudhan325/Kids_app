import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ═══════════════════════════════════════════════════════════════════
//  PROGRESS SERVICE — Global progress tracker for the app
// ═══════════════════════════════════════════════════════════════════

class ProgressService extends ChangeNotifier {
  // ── Singleton ──────────────────────────────────────────────
  static final ProgressService _instance = ProgressService._internal();
  factory ProgressService() => _instance;
  ProgressService._internal();

  SharedPreferences? _prefs;
  bool _isLoaded = false;

  // ── Core Stats ─────────────────────────────────────────────
  int _stars = 0;
  int _badges = 0;
  int _lessonsCompleted = 0;
  int _gamesPlayed = 0;
  int _quizzesTaken = 0;
  int _streakDays = 0;
  String _lastActiveDate = '';

  // ── Completed Content Tracking ─────────────────────────────
  Set<String> _completedLessons = {};   // e.g. "Hindi_Swar", "English_ABC"
  Set<String> _completedGames = {};     // e.g. "Math_Quiz"
  Set<String> _earnedBadges = {};       // e.g. "first_lesson", "5_games"

  // ── Daily Challenge ────────────────────────────────────────
  int _dailyChallengeProgress = 0;      // items done today
  int _dailyChallengeGoal = 5;          // items to complete
  String _dailyChallengeDate = '';

  // ── Getters ────────────────────────────────────────────────
  int get stars => _stars;
  int get badges => _badges;
  int get lessonsCompleted => _lessonsCompleted;
  int get gamesPlayed => _gamesPlayed;
  int get quizzesTaken => _quizzesTaken;
  int get streakDays => _streakDays;
  bool get isLoaded => _isLoaded;
  Set<String> get completedLessons => _completedLessons;
  Set<String> get earnedBadges => _earnedBadges;

  // Daily challenge
  double get dailyChallengePercent =>
      _dailyChallengeGoal == 0 ? 0 : (_dailyChallengeProgress / _dailyChallengeGoal).clamp(0.0, 1.0);
  int get dailyChallengeProgress => _dailyChallengeProgress;
  int get dailyChallengeGoal => _dailyChallengeGoal;

  // ── Daily Challenges Pool ──────────────────────────────────
  static const List<Map<String, dynamic>> challenges = [
    {'emoji': '🐾', 'text': 'Learn 5 new things today!', 'goal': 5},
    {'emoji': '🔢', 'text': 'Complete 3 lessons!', 'goal': 3},
    {'emoji': '📖', 'text': 'Read 2 stories today!', 'goal': 2},
    {'emoji': '🎨', 'text': 'Finish 4 activities!', 'goal': 4},
    {'emoji': '🕉️', 'text': 'Learn 5 Hindi letters!', 'goal': 5},
    {'emoji': '🎮', 'text': 'Play 3 games today!', 'goal': 3},
    {'emoji': '⭐', 'text': 'Earn 50 stars today!', 'goal': 50},
  ];

  Map<String, dynamic> get todayChallenge {
    final dayIndex = DateTime.now().day % challenges.length;
    return challenges[dayIndex];
  }

  // ── Badge Definitions ──────────────────────────────────────
  static const Map<String, Map<String, String>> badgeDefinitions = {
    'first_lesson': {'name': 'First Step! 🐣', 'desc': 'Complete your first lesson'},
    'five_lessons': {'name': 'Explorer 🗺️', 'desc': 'Complete 5 lessons'},
    'ten_lessons': {'name': 'Scholar 📚', 'desc': 'Complete 10 lessons'},
    'first_game': {'name': 'Player One 🎮', 'desc': 'Play your first game'},
    'five_games': {'name': 'Game Master 🏅', 'desc': 'Play 5 games'},
    'star_50': {'name': 'Star Collector ⭐', 'desc': 'Earn 50 stars'},
    'star_100': {'name': 'Super Star 🌟', 'desc': 'Earn 100 stars'},
    'star_500': {'name': 'Mega Star 💫', 'desc': 'Earn 500 stars'},
    'streak_3': {'name': 'On Fire 🔥', 'desc': '3 day streak'},
    'streak_7': {'name': 'Unstoppable 🚀', 'desc': '7 day streak'},
    'daily_done': {'name': 'Challenge Champ 🏆', 'desc': 'Complete a daily challenge'},
  };

  // ═══════════════════════════════════════════════════════════
  //  INITIALIZATION
  // ═══════════════════════════════════════════════════════════
  Future<void> init() async {
    if (_isLoaded) return;
    _prefs = await SharedPreferences.getInstance();
    _loadAll();
    _checkStreak();
    _checkDailyChallenge();
    _isLoaded = true;
    notifyListeners();
  }

  void _loadAll() {
    _stars = _prefs?.getInt('stars') ?? 0;
    _badges = _prefs?.getInt('badges') ?? 0;
    _lessonsCompleted = _prefs?.getInt('lessonsCompleted') ?? 0;
    _gamesPlayed = _prefs?.getInt('gamesPlayed') ?? 0;
    _quizzesTaken = _prefs?.getInt('quizzesTaken') ?? 0;
    _streakDays = _prefs?.getInt('streakDays') ?? 0;
    _lastActiveDate = _prefs?.getString('lastActiveDate') ?? '';
    _dailyChallengeProgress = _prefs?.getInt('dailyChallengeProgress') ?? 0;
    _dailyChallengeDate = _prefs?.getString('dailyChallengeDate') ?? '';

    final lessonsJson = _prefs?.getString('completedLessons') ?? '[]';
    _completedLessons = Set<String>.from(jsonDecode(lessonsJson));

    final gamesJson = _prefs?.getString('completedGames') ?? '[]';
    _completedGames = Set<String>.from(jsonDecode(gamesJson));

    final badgesJson = _prefs?.getString('earnedBadges') ?? '[]';
    _earnedBadges = Set<String>.from(jsonDecode(badgesJson));
  }

  Future<void> _saveAll() async {
    await _prefs?.setInt('stars', _stars);
    await _prefs?.setInt('badges', _badges);
    await _prefs?.setInt('lessonsCompleted', _lessonsCompleted);
    await _prefs?.setInt('gamesPlayed', _gamesPlayed);
    await _prefs?.setInt('quizzesTaken', _quizzesTaken);
    await _prefs?.setInt('streakDays', _streakDays);
    await _prefs?.setString('lastActiveDate', _lastActiveDate);
    await _prefs?.setInt('dailyChallengeProgress', _dailyChallengeProgress);
    await _prefs?.setString('dailyChallengeDate', _dailyChallengeDate);
    await _prefs?.setString('completedLessons', jsonEncode(_completedLessons.toList()));
    await _prefs?.setString('completedGames', jsonEncode(_completedGames.toList()));
    await _prefs?.setString('earnedBadges', jsonEncode(_earnedBadges.toList()));
  }

  // ═══════════════════════════════════════════════════════════
  //  STREAK MANAGEMENT
  // ═══════════════════════════════════════════════════════════
  void _checkStreak() {
    final today = _todayStr();
    if (_lastActiveDate.isEmpty) {
      _streakDays = 0;
      return;
    }
    final lastDate = DateTime.tryParse(_lastActiveDate);
    if (lastDate == null) return;

    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
        .inDays;

    if (diff > 1) {
      _streakDays = 0; // Streak broken
    }
    // if diff == 0, same day — no change
    // if diff == 1, consecutive — streak maintained (incremented on activity)
  }

  void _markActive() {
    final today = _todayStr();
    if (_lastActiveDate != today) {
      final lastDate = DateTime.tryParse(_lastActiveDate);
      final now = DateTime.now();
      if (lastDate != null) {
        final diff = DateTime(now.year, now.month, now.day)
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;
        if (diff == 1) {
          _streakDays++;
        } else if (diff > 1) {
          _streakDays = 1;
        }
      } else {
        _streakDays = 1;
      }
      _lastActiveDate = today;
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  DAILY CHALLENGE
  // ═══════════════════════════════════════════════════════════
  void _checkDailyChallenge() {
    final today = _todayStr();
    if (_dailyChallengeDate != today) {
      // New day — reset challenge
      _dailyChallengeProgress = 0;
      _dailyChallengeDate = today;
      _dailyChallengeGoal = todayChallenge['goal'] as int;
    }
  }

  void _advanceDailyChallenge({int amount = 1}) {
    _checkDailyChallenge();
    _dailyChallengeProgress += amount;
    if (_dailyChallengeProgress >= _dailyChallengeGoal) {
      _tryAwardBadge('daily_done');
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  PUBLIC ACTIONS — Call these from screens
  // ═══════════════════════════════════════════════════════════

  /// Called when a lesson topic is viewed/completed
  Future<void> completeLesson(String lessonId) async {
    _markActive();

    if (!_completedLessons.contains(lessonId)) {
      _completedLessons.add(lessonId);
      _lessonsCompleted++;
      _stars += 10; // 10 stars per new lesson
      _advanceDailyChallenge();

      // Badge checks
      if (_lessonsCompleted == 1) _tryAwardBadge('first_lesson');
      if (_lessonsCompleted >= 5) _tryAwardBadge('five_lessons');
      if (_lessonsCompleted >= 10) _tryAwardBadge('ten_lessons');
    } else {
      _stars += 2; // 2 stars for revisiting
    }

    _checkStarBadges();
    _checkStreakBadges();
    await _saveAll();
    notifyListeners();
  }

  /// Called when a game is played
  Future<void> completeGame(String gameId) async {
    _markActive();
    _gamesPlayed++;
    _stars += 15; // 15 stars per game

    if (!_completedGames.contains(gameId)) {
      _completedGames.add(gameId);
    }

    _advanceDailyChallenge();

    if (_gamesPlayed == 1) _tryAwardBadge('first_game');
    if (_gamesPlayed >= 5) _tryAwardBadge('five_games');

    _checkStarBadges();
    _checkStreakBadges();
    await _saveAll();
    notifyListeners();
  }

  /// Called when a quiz is completed
  Future<void> completeQuiz({int bonusStars = 0}) async {
    _markActive();
    _quizzesTaken++;
    _stars += 20 + bonusStars;
    _advanceDailyChallenge();

    _checkStarBadges();
    _checkStreakBadges();
    await _saveAll();
    notifyListeners();
  }

  /// Called when Magic AI is used
  Future<void> usedMagicAI() async {
    _markActive();
    _stars += 5;
    _advanceDailyChallenge();
    _checkStarBadges();
    await _saveAll();
    notifyListeners();
  }

  /// Add arbitrary stars (e.g. for bonus activities)
  Future<void> addStars(int amount) async {
    _stars += amount;
    _checkStarBadges();
    await _saveAll();
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  //  BADGE SYSTEM
  // ═══════════════════════════════════════════════════════════
  void _tryAwardBadge(String badgeId) {
    if (!_earnedBadges.contains(badgeId)) {
      _earnedBadges.add(badgeId);
      _badges = _earnedBadges.length;
    }
  }

  void _checkStarBadges() {
    if (_stars >= 50) _tryAwardBadge('star_50');
    if (_stars >= 100) _tryAwardBadge('star_100');
    if (_stars >= 500) _tryAwardBadge('star_500');
  }

  void _checkStreakBadges() {
    if (_streakDays >= 3) _tryAwardBadge('streak_3');
    if (_streakDays >= 7) _tryAwardBadge('streak_7');
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════
  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  bool isLessonCompleted(String lessonId) => _completedLessons.contains(lessonId);
}
