import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_app/Const/Quiz_data.dart';
import 'package:kids_app/Const/progress_service.dart';

// ═══════════════════════════════════════════════════════════════════
//  QUIZ GAME ENGINE — Premium Interactive Quiz with Timer & Scoring
// ═══════════════════════════════════════════════════════════════════

const Color _kBg = Color(0xFF0F0E17);
const Color _kSurface = Color(0xFF1A1A2E);
const Color _kCard = Color(0xFF1E2A45);
const Color _kAccent = Color(0xFF7C6FFF);
const Color _kGold = Color(0xFFFFD700);
const Color _kGreen = Color(0xFF43A047);
const Color _kRed = Color(0xFFE53935);

double _rs(BuildContext ctx, double base) {
  final sw = MediaQuery.of(ctx).size.shortestSide;
  return (base * sw / 390).clamp(base * 0.72, base * 1.25);
}

// ═══════════════════════════════════════════════════════════════════
//  LEVEL SELECT FOR QUIZ
// ═══════════════════════════════════════════════════════════════════
class QuizLevelSelect extends StatelessWidget {
  final QuizCategory category;
  const QuizLevelSelect({super.key, required this.category});

  static const _levels = [
    {
      'num': 1, 'title': 'Beginner', 'emoji': '⭐',
      'desc': 'Easy & fun questions!', 'hint': 'Basic concepts',
      'colors': [Color(0xFF43A047), Color(0xFF1B5E20)],
    },
    {
      'num': 2, 'title': 'Explorer', 'emoji': '⭐⭐',
      'desc': 'Think a little harder!', 'hint': 'More challenging',
      'colors': [Color(0xFFFFA726), Color(0xFFE65100)],
    },
    {
      'num': 3, 'title': 'Champion', 'emoji': '⭐⭐⭐',
      'desc': 'Only the smartest win!', 'hint': 'Expert level',
      'colors': [Color(0xFFEF5350), Color(0xFF7B1FA2)],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final hPad = (sw * 0.055).clamp(16.0, 26.0);
    final emojiSz = (sw * 0.17).clamp(56.0, 80.0);

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        title: Text('${category.icon} ${category.name} Quiz',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _kSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: hPad * 0.6),
        child: Column(children: [
          SizedBox(height: sw * 0.03),
          // Category info card
          Container(
            padding: EdgeInsets.all(hPad),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: category.colors,
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(_rs(context, 24)),
              boxShadow: [
                BoxShadow(color: category.colors[0].withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(children: [
              Text(category.icon, style: TextStyle(fontSize: emojiSz)),
              SizedBox(height: _rs(context, 10)),
              Text(category.name,
                  style: TextStyle(color: Colors.white, fontSize: _rs(context, 24), fontWeight: FontWeight.bold)),
              SizedBox(height: _rs(context, 4)),
              Text(category.subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: _rs(context, 13))),
              SizedBox(height: _rs(context, 10)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${category.levels.values.fold<int>(0, (s, l) => s + l.length)} Questions Total',
                  style: TextStyle(color: Colors.white, fontSize: _rs(context, 12), fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
          SizedBox(height: sw * 0.06),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Choose Difficulty',
                style: TextStyle(color: Colors.white54, fontSize: _rs(context, 12),
                    letterSpacing: 1, fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: sw * 0.03),
          // Level cards
          ...List.generate(_levels.length, (i) {
            final lv = _levels[i];
            final colors = lv['colors'] as List<Color>;
            final lvNum = lv['num'] as int;
            final questions = category.levels[lvNum] ?? [];
            return Padding(
              padding: EdgeInsets.only(bottom: _rs(context, 14)),
              child: GestureDetector(
                onTap: () {
                  if (questions.isEmpty) return;
                  HapticFeedback.mediumImpact();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => QuizGameScreen(category: category, level: lvNum),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: _rs(context, 20), vertical: _rs(context, 16)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(_rs(context, 20)),
                    boxShadow: [BoxShadow(color: colors[0].withOpacity(0.45), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(lv['emoji'] as String, style: TextStyle(fontSize: _rs(context, 17))),
                          SizedBox(width: _rs(context, 8)),
                          Text(lv['title'] as String,
                              style: TextStyle(color: Colors.white, fontSize: _rs(context, 17), fontWeight: FontWeight.bold)),
                        ]),
                        SizedBox(height: _rs(context, 4)),
                        Text(lv['desc'] as String,
                            style: TextStyle(color: Colors.white70, fontSize: _rs(context, 12))),
                        SizedBox(height: _rs(context, 2)),
                        Text('${questions.length} questions · ${lv['hint']}',
                            style: TextStyle(color: Colors.white54, fontSize: _rs(context, 10))),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.all(_rs(context, 10)),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.2)),
                      child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: _rs(context, 24)),
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

// ═══════════════════════════════════════════════════════════════════
//  QUIZ GAME SCREEN — The Actual Quiz Gameplay
// ═══════════════════════════════════════════════════════════════════
class QuizGameScreen extends StatefulWidget {
  final QuizCategory category;
  final int level;
  const QuizGameScreen({super.key, required this.category, required this.level});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> with TickerProviderStateMixin {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  int _streak = 0;
  int _bestStreak = 0;
  bool _answered = false;
  int? _selectedIndex;
  bool _gameOver = false;
  String? _currentFunFact;

  // Timer
  late int _timePerQuestion;
  int _timeLeft = 0;
  Timer? _timer;

  // Animations
  late AnimationController _questionAnimController;
  late AnimationController _timerPulseController;
  late Animation<double> _questionSlide;
  late Animation<double> _questionFade;

  int get _total => _questions.length;

  @override
  void initState() {
    super.initState();
    _questions = List.from(widget.category.levels[widget.level] ?? [])..shuffle(Random());
    _timePerQuestion = widget.level == 1 ? 20 : widget.level == 2 ? 15 : 12;

    _questionAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _timerPulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);

    _questionSlide = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _questionAnimController, curve: Curves.easeOutCubic),
    );
    _questionFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionAnimController, curve: Curves.easeOut),
    );

    _startQuestion();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionAnimController.dispose();
    _timerPulseController.dispose();
    super.dispose();
  }

  void _startQuestion() {
    if (_currentIndex >= _total || _lives <= 0) {
      _endGame();
      return;
    }
    _timeLeft = _timePerQuestion;
    _answered = false;
    _selectedIndex = null;
    _currentFunFact = null;
    _questionAnimController.forward(from: 0);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_timeLeft <= 1) {
        t.cancel();
        _handleTimeout();
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _handleTimeout() {
    if (_answered) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _answered = true;
      _lives--;
      _streak = 0;
      if (_lives <= 0) {
        _endGame();
      }
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || _gameOver) return;
      setState(() => _currentIndex++);
      _startQuestion();
    });
  }

  void _selectAnswer(int index) {
    if (_answered || _gameOver) return;
    _timer?.cancel();
    HapticFeedback.mediumImpact();

    final question = _questions[_currentIndex];
    final correct = index == question.correctIndex;

    setState(() {
      _answered = true;
      _selectedIndex = index;

      if (correct) {
        _score++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
        // Bonus points for time left
        final timeBonus = (_timeLeft / _timePerQuestion * 5).round();
        _score += timeBonus;
        if (question.funFact != null) _currentFunFact = question.funFact;
      } else {
        _lives--;
        _streak = 0;
        if (_lives <= 0) {
          Future.delayed(const Duration(milliseconds: 800), () => _endGame());
          return;
        }
      }
    });

    Future.delayed(Duration(milliseconds: _currentFunFact != null ? 2500 : 1200), () {
      if (!mounted || _gameOver) return;
      setState(() => _currentIndex++);
      _startQuestion();
    });
  }

  void _endGame() {
    _timer?.cancel();
    setState(() => _gameOver = true);
    // Save progress
    final bonusStars = _bestStreak >= 3 ? 10 : 0;
    ProgressService().completeQuiz(bonusStars: bonusStars);
  }

  void _restart() {
    _questions.shuffle(Random());
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _lives = 3;
      _streak = 0;
      _bestStreak = 0;
      _gameOver = false;
      _answered = false;
      _selectedIndex = null;
      _currentFunFact = null;
    });
    _startQuestion();
  }

  Color _optionColor(int index) {
    if (!_answered) return _kCard;
    final q = _questions[_currentIndex < _total ? _currentIndex : _total - 1];
    if (index == q.correctIndex) return _kGreen;
    if (index == _selectedIndex) return _kRed;
    return _kCard;
  }

  IconData? _optionIcon(int index) {
    if (!_answered) return null;
    final q = _questions[_currentIndex < _total ? _currentIndex : _total - 1];
    if (index == q.correctIndex) return Icons.check_circle_rounded;
    if (index == _selectedIndex) return Icons.cancel_rounded;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    final lvLabel = ['', '⭐ Beginner', '⭐⭐ Explorer', '⭐⭐⭐ Champion'];

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        title: Text('${widget.category.icon} ${widget.category.name}  ${lvLabel[widget.level]}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: _rs(context, 16))),
        backgroundColor: _kSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Stack(children: [
        Column(children: [
          // Progress header
          _buildProgressHeader(sw),
          // Main content
          if (!_gameOver && _currentIndex < _total)
            Expanded(child: _buildQuestionArea(sw, sh)),
        ]),
        if (_gameOver) _buildGameOverOverlay(sw, sh),
      ]),
    );
  }

  Widget _buildProgressHeader(double sw) {
    final hPad = (sw * 0.042).clamp(12.0, 18.0);
    final progress = _total > 0 ? (_currentIndex / _total).clamp(0.0, 1.0) : 0.0;
    final timerPct = _timePerQuestion > 0 ? _timeLeft / _timePerQuestion : 0.0;
    final timerColor = timerPct > 0.5 ? _kGreen : timerPct > 0.25 ? Colors.orange : _kRed;

    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 12),
      color: _kSurface,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Lives
          Row(children: List.generate(3, (i) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(i < _lives ? Icons.favorite : Icons.favorite_border,
                color: i < _lives ? _kRed : Colors.white24, size: _rs(context, 20)),
          ))),
          // Question counter
          Text('Q ${_currentIndex + 1} / $_total',
              style: TextStyle(color: Colors.white54, fontSize: _rs(context, 13), fontWeight: FontWeight.w500)),
          // Score
          Container(
            padding: EdgeInsets.symmetric(horizontal: _rs(context, 12), vertical: 5),
            decoration: BoxDecoration(color: _kCard, borderRadius: BorderRadius.circular(20)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.star_rounded, color: _kGold, size: _rs(context, 18)),
              const SizedBox(width: 4),
              Text('$_score', style: TextStyle(color: _kGold, fontWeight: FontWeight.bold, fontSize: _rs(context, 15))),
            ]),
          ),
        ]),
        const SizedBox(height: 8),
        // Question progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: _kCard,
            valueColor: AlwaysStoppedAnimation(widget.category.colors[0]),
            minHeight: _rs(context, 5),
          ),
        ),
        const SizedBox(height: 6),
        // Timer bar
        Row(children: [
          AnimatedBuilder(
            animation: _timerPulseController,
            builder: (_, __) {
              final scale = timerPct <= 0.25 ? 1.0 + _timerPulseController.value * 0.15 : 1.0;
              return Transform.scale(
                scale: scale,
                child: Icon(Icons.timer_rounded, color: timerColor, size: _rs(context, 16)),
              );
            },
          ),
          const SizedBox(width: 6),
          Text('$_timeLeft s', style: TextStyle(color: timerColor, fontSize: _rs(context, 12), fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: timerPct,
                backgroundColor: _kCard,
                valueColor: AlwaysStoppedAnimation(timerColor),
                minHeight: _rs(context, 5),
              ),
            ),
          ),
          if (_streak >= 2) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('🔥 $_streak', style: TextStyle(color: Colors.white, fontSize: _rs(context, 11), fontWeight: FontWeight.bold)),
            ),
          ],
        ]),
      ]),
    );
  }

  Widget _buildQuestionArea(double sw, double sh) {
    final question = _questions[_currentIndex];
    final hPad = (sw * 0.05).clamp(16.0, 24.0);

    return AnimatedBuilder(
      animation: _questionAnimController,
      builder: (_, __) => Opacity(
        opacity: _questionFade.value,
        child: Transform.translate(
          offset: Offset(0, _questionSlide.value),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(hPad),
            child: Column(children: [
              // Question card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all((sw * 0.06).clamp(18.0, 28.0)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [widget.category.colors[0].withOpacity(0.15), _kSurface],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(_rs(context, 24)),
                  border: Border.all(color: widget.category.colors[0].withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: widget.category.colors[0].withOpacity(0.1), blurRadius: 20)],
                ),
                child: Column(children: [
                  if (question.hint != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('💡 Hint: ${question.hint}',
                            style: TextStyle(color: Colors.amber, fontSize: _rs(context, 11))),
                      ),
                    ),
                  Text(question.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: _rs(context, 20),
                          fontWeight: FontWeight.bold, height: 1.4)),
                ]),
              ),
              SizedBox(height: sh * 0.025),
              // Options
              ...List.generate(question.options.length, (i) {
                final optColor = _optionColor(i);
                final icon = _optionIcon(i);
                final labels = ['A', 'B', 'C', 'D'];
                return Padding(
                  padding: EdgeInsets.only(bottom: _rs(context, 10)),
                  child: GestureDetector(
                    onTap: () => _selectAnswer(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(
                        horizontal: _rs(context, 16), vertical: _rs(context, 14)),
                      decoration: BoxDecoration(
                        color: optColor,
                        borderRadius: BorderRadius.circular(_rs(context, 16)),
                        border: Border.all(
                          color: _answered && (i == _questions[_currentIndex].correctIndex)
                              ? _kGreen : _answered && i == _selectedIndex
                              ? _kRed : Colors.white12,
                          width: _answered ? 2 : 1,
                        ),
                        boxShadow: _answered && (i == _questions[_currentIndex].correctIndex)
                            ? [BoxShadow(color: _kGreen.withOpacity(0.3), blurRadius: 12)]
                            : [],
                      ),
                      child: Row(children: [
                        Container(
                          width: _rs(context, 32), height: _rs(context, 32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _answered && i == _questions[_currentIndex].correctIndex
                                ? _kGreen.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                          ),
                          child: Center(
                            child: icon != null
                                ? Icon(icon, color: Colors.white, size: _rs(context, 20))
                                : Text(labels[i],
                                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold,
                                        fontSize: _rs(context, 14))),
                          ),
                        ),
                        SizedBox(width: _rs(context, 12)),
                        Expanded(
                          child: Text(question.options[i],
                              style: TextStyle(color: Colors.white, fontSize: _rs(context, 15),
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ),
                  ),
                );
              }),
              // Fun fact display
              if (_currentFunFact != null)
                AnimatedOpacity(
                  opacity: _currentFunFact != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    margin: EdgeInsets.only(top: _rs(context, 8)),
                    padding: EdgeInsets.all(_rs(context, 14)),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.withOpacity(0.15), Colors.orange.withOpacity(0.08)],
                      ),
                      borderRadius: BorderRadius.circular(_rs(context, 16)),
                      border: Border.all(color: Colors.amber.withOpacity(0.3)),
                    ),
                    child: Row(children: [
                      Text('🧠', style: TextStyle(fontSize: _rs(context, 24))),
                      SizedBox(width: _rs(context, 10)),
                      Expanded(
                        child: Text(_currentFunFact!,
                            style: TextStyle(color: Colors.amber.shade100, fontSize: _rs(context, 12),
                                fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)),
                      ),
                    ]),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(double sw, double sh) {
    final maxScore = _total * (1 + (_timePerQuestion * 5 / _timePerQuestion).round());
    final pct = maxScore > 0 ? (_score / maxScore).clamp(0.0, 1.0) : 0.0;
    final stars = pct >= 0.7 ? 3 : pct >= 0.4 ? 2 : 1;
    final msg = stars == 3 ? '🏆 Amazing!' : stars == 2 ? '👏 Good Job!' : '💪 Keep Going!';
    final margin = (sw * 0.065).clamp(18.0, 30.0);
    final pad = (sw * 0.07).clamp(20.0, 30.0);

    return Container(
      color: Colors.black.withOpacity(0.88),
      child: Center(
        child: Container(
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.circular(_rs(context, 28)),
            border: Border.all(color: widget.category.colors[0].withOpacity(0.5), width: 1.5),
            boxShadow: [BoxShadow(color: widget.category.colors[0].withOpacity(0.3), blurRadius: 30)],
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(msg, style: TextStyle(color: Colors.white, fontSize: _rs(context, 24), fontWeight: FontWeight.bold)),
            SizedBox(height: _rs(context, 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.star_rounded, size: _rs(context, 48),
                    color: i < stars ? _kGold : Colors.white24),
              )),
            ),
            SizedBox(height: _rs(context, 16)),
            // Stats
            Container(
              padding: EdgeInsets.all(_rs(context, 16)),
              decoration: BoxDecoration(
                color: _kCard, borderRadius: BorderRadius.circular(_rs(context, 16)),
              ),
              child: Column(children: [
                _statRow('📊 Score', '$_score points'),
                _statRow('✅ Correct', '${_currentIndex < _total ? _currentIndex : _total} / $_total'),
                _statRow('🔥 Best Streak', '$_bestStreak in a row'),
                _statRow('⭐ Stars Earned', '+${20 + (_bestStreak >= 3 ? 10 : 0)}'),
              ]),
            ),
            SizedBox(height: _rs(context, 20)),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.symmetric(vertical: _rs(context, 13)),
                  ),
                  child: Text('← Back', style: TextStyle(fontSize: _rs(context, 14))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.category.colors[0],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: EdgeInsets.symmetric(vertical: _rs(context, 13)),
                    elevation: 8,
                    shadowColor: widget.category.colors[0].withOpacity(0.5),
                  ),
                  child: Text('▶ Play Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: _rs(context, 14))),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(color: Colors.white54, fontSize: _rs(context, 13))),
        Text(value, style: TextStyle(color: Colors.white, fontSize: _rs(context, 13), fontWeight: FontWeight.bold)),
      ]),
    );
  }
}
