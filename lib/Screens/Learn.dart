import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_app/Const/Learning_data.dart';

// ═══════════════════════════════════════════════════════════
// 📚 LEARN SCREEN — HUB
// ═══════════════════════════════════════════════════════════
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});
  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedCat = 'Stories';

  // per-category display gradient (top-level header only)
  static const _catGradients = {
    'Science': [Color(0xFF00838F), Color(0xFF004D40)],
    'Stories': [Color(0xFF4527A0), Color(0xFF1A237E)],
    'Animals': [Color(0xFFE65100), Color(0xFFBF360C)],
    'Math':    [Color(0xFF2E7D32), Color(0xFF1B5E20)],
    'ABC':     [Color(0xFF1565C0), Color(0xFF0D47A1)],
    'Hindi':   [Color(0xFFB71C1C), Color(0xFF880E4F)],
    'Poems':   [Color(0xFF9C27B0), Color(0xFF4A148C)],
    'Colors':  [Color(0xFFC2185B), Color(0xFF880E4F)],
  };

  List<Color> get _grad =>
      _catGradients[_selectedCat] ?? [const Color(0xFF7C6FFF), const Color(0xFF48CAE4)];

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final cats = LearningContent.categories.keys.toList();
    final topics = LearningContent.data[_selectedCat] ?? [];
    final catMeta = LearningContent.categories;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── SliverAppBar with gradient ─────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: (sh * 0.18).clamp(120.0, 160.0),
            backgroundColor: const Color(0xFF1A1A2E),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
              title: Text('📚 Learn Zone',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (sw * 0.05).clamp(16.0, 22.0))),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: _grad,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Stack(children: [
                  Positioned(
                    right: -30, top: -30,
                    child: Container(
                      width: 180, height: 180,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.07)),
                    ),
                  ),
                  Positioned(
                    left: sw * 0.4,
                    bottom: 30,
                    child: Text(
                      catMeta[_selectedCat]?['emoji'] ?? '📚',
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                ]),
              ),
            ),
          ),

          // ── Category Chips ─────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF1A1A2E),
              height: (sh * 0.07).clamp(52.0, 64.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                    horizontal: (sw * 0.04).clamp(12.0, 20.0),
                    vertical: 10),
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = cats[i];
                  final meta = catMeta[cat]!;
                  final active = cat == _selectedCat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCat = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: EdgeInsets.symmetric(
                          horizontal: (sw * 0.035).clamp(10.0, 16.0),
                          vertical: 6),
                      decoration: BoxDecoration(
                        color: active
                            ? (meta['color'] as Color)
                            : const Color(0xFF1E2A45),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: active
                                ? (meta['color'] as Color)
                                : Colors.white24),
                        boxShadow: active
                            ? [BoxShadow(
                                color: (meta['color'] as Color).withOpacity(0.4),
                                blurRadius: 10)]
                            : [],
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(meta['emoji'] as String,
                            style: TextStyle(
                                fontSize: (sw * 0.038).clamp(13.0, 18.0))),
                        const SizedBox(width: 5),
                        Text(cat,
                            style: TextStyle(
                                color: active ? Colors.white : Colors.white54,
                                fontWeight: active
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: (sw * 0.03).clamp(11.0, 14.0))),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Section label ──────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                (sw * 0.045).clamp(14.0, 20.0), 14, 20, 6),
            sliver: SliverToBoxAdapter(
              child: Text('${topics.length} Lessons',
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: (sw * 0.028).clamp(10.0, 13.0),
                      letterSpacing: 1)),
            ),
          ),

          // ── Topic Grid ─────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                (sw * 0.04).clamp(12.0, 18.0),
                4,
                (sw * 0.04).clamp(12.0, 18.0),
                32),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: (sw * 0.03).clamp(10.0, 14.0),
                mainAxisSpacing: (sw * 0.03).clamp(10.0, 14.0),
                childAspectRatio: (sw < 360) ? 0.82 : 0.88,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _TopicCard(
                  topic: topics[i],
                  catEmoji: catMeta[_selectedCat]?['emoji'] ?? '📚',
                ),
                childCount: topics.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Topic Card Widget ───────────────────────────────────
class _TopicCard extends StatelessWidget {
  final Map<String, dynamic> topic;
  final String catEmoji;
  const _TopicCard({required this.topic, required this.catEmoji});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final color = topic['color'] as Color;
    final type = topic['type'] as String? ?? 'card';
    final typeIcon = type == 'poem' ? '🎵' : type == 'story' ? '📖' : '🃏';

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LearnTopicScreen(topic: topic))),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, Colors.black, 0.35)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular((sw * 0.055).clamp(16.0, 24.0)),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.45),
                blurRadius: 12,
                offset: const Offset(0, 5))
          ],
        ),
        child: Stack(children: [
          // decorative circle
          Positioned(
            right: -18, bottom: -18,
            child: Container(
              width: sw * 0.2, height: sw * 0.2,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all((sw * 0.04).clamp(10.0, 16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text('$typeIcon ${type[0].toUpperCase()}${type.substring(1)}',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: (sw * 0.025).clamp(9.0, 11.0))),
                ),
                const Spacer(),
                Text(topic['icon'] as String,
                    style:
                        TextStyle(fontSize: (sw * 0.1).clamp(32.0, 46.0))),
                SizedBox(height: (sw * 0.015).clamp(4.0, 8.0)),
                Text(topic['title'] as String,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: (sw * 0.034).clamp(12.0, 15.0))),
                SizedBox(height: (sw * 0.01).clamp(3.0, 6.0)),
                Text(topic['sub'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: (sw * 0.026).clamp(9.0, 12.0))),
                SizedBox(height: (sw * 0.015).clamp(5.0, 10.0)),
                // content count
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                      '${(topic['content'] as List).length} cards',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: (sw * 0.025).clamp(9.0, 11.0))),
                ),
              ],
            ),
          ),
          // play button
          Positioned(
            right: (sw * 0.025).clamp(8.0, 12.0),
            bottom: (sw * 0.025).clamp(8.0, 12.0),
            child: Container(
              width: (sw * 0.08).clamp(26.0, 34.0),
              height: (sw * 0.08).clamp(26.0, 34.0),
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
  }
}

// ═══════════════════════════════════════════════════════════
// 📄 TOPIC DETAIL — Card Swiper + TTS
// ═══════════════════════════════════════════════════════════
class LearnTopicScreen extends StatefulWidget {
  final Map<String, dynamic> topic;
  const LearnTopicScreen({super.key, required this.topic});
  @override
  State<LearnTopicScreen> createState() => _LearnTopicScreenState();
}

class _LearnTopicScreenState extends State<LearnTopicScreen> {
  final FlutterTts _tts = FlutterTts();
  late PageController _pc;
  late List<String> _items;
  int _page = 0;
  bool _speaking = false;
  bool _autoPlay = false;
  Timer? _autoTimer;
  bool _ttsReady = false;

  Color get _color => widget.topic['color'] as Color;
  String get _type => widget.topic['type'] as String? ?? 'card';

  @override
  void initState() {
    super.initState();
    _items = List<String>.from(widget.topic['content'] as List);
    _pc = PageController();
    _initTtsAndSpeak();
  }

  Future<void> _initTtsAndSpeak() async {
    await _setupTts();
    // Only speak after TTS is fully initialised
    if (mounted && _items.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 300));
      _speak(_items[0]);
    }
  }

  Future<void> _setupTts() async {
    try {
      final isHindi = (widget.topic['title'] as String)
          .contains(RegExp(r'[\u0900-\u097F]'));
      await _tts.setLanguage(isHindi ? 'hi-IN' : 'en-US');
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.1);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      _tts.setStartHandler(() => mounted ? setState(() => _speaking = true) : null);
      _tts.setCompletionHandler(
          () => mounted ? setState(() => _speaking = false) : null);
      _tts.setErrorHandler((msg) {
        debugPrint('TTS Error: $msg');
        if (mounted) setState(() => _speaking = false);
      });
      _ttsReady = true;
    } catch (e) {
      debugPrint('TTS setup failed: $e');
      _ttsReady = false;
    }
  }

  String _clean(String text) {
    // Remove emojis for TTS but keep the meaningful text
    final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]',
        unicode: true);
    return text.replaceAll(emojiRegex, '').replaceAll('—', ' ').trim();
  }

  Future<void> _speak(String text) async {
    if (!_ttsReady) return;
    try {
      await _tts.stop();
      final cleaned = _clean(text);
      if (cleaned.isNotEmpty) await _tts.speak(cleaned);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
    }
  }

  void _toggleAutoPlay() {
    setState(() => _autoPlay = !_autoPlay);
    if (_autoPlay) {
      _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        if (_page < _items.length - 1) {
          _pc.nextPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
        } else {
          _toggleAutoPlay(); // stop at end
        }
      });
    } else {
      _autoTimer?.cancel();
    }
  }

  void _onPageChanged(int idx) {
    setState(() => _page = idx);
    _speak(_items[idx]);
  }

  @override
  void dispose() {
    _tts.stop();
    _autoTimer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  // ── Parse emoji + text from a content string ──────────
  (String emoji, String text) _parse(String raw) {
    final emojiRegex = RegExp(
        r'^([\u{1F300}-\u{1FAFF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F000}-\u{1F02F}]+)\s*',
        unicode: true);
    final match = emojiRegex.firstMatch(raw);
    if (match != null) {
      return (match.group(0)!.trim(), raw.substring(match.end).trim());
    }
    return ('', raw.trim());
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sw = mq.size.width;
    final sh = mq.size.height;
    final color = _color;
    final cardH = (sh * 0.52).clamp(300.0, 480.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(widget.topic['title'] as String,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
        actions: [
          // Auto-play toggle
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: _toggleAutoPlay,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _autoPlay
                      ? color.withOpacity(0.8)
                      : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_autoPlay ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(_autoPlay ? 'Stop' : 'Auto',
                      style: const TextStyle(color: Colors.white, fontSize: 12)),
                ]),
              ),
            ),
          ),
          // Speak all
          IconButton(
            icon: Icon(
                _speaking ? Icons.volume_up : Icons.volume_up_outlined,
                color: _speaking ? color : Colors.white70),
            onPressed: () => _speak(_items[_page]),
            tooltip: 'Read aloud',
          ),
        ],
      ),
      body: Column(children: [
        // ── Progress bar ────────────────────────────────
        LinearProgressIndicator(
          value: _items.isNotEmpty ? (_page + 1) / _items.length : 0,
          backgroundColor: const Color(0xFF1E2A45),
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 3,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (sw * 0.04).clamp(12.0, 20.0)),
            child: Column(children: [
              SizedBox(height: (sh * 0.016).clamp(10.0, 16.0)),

              // ── Page counter ──────────────────────────
              Text('${_page + 1} / ${_items.length}',
                  style: TextStyle(
                      color: Colors.white38,
                      fontSize: (sw * 0.032).clamp(11.0, 14.0))),
              SizedBox(height: (sh * 0.012).clamp(8.0, 14.0)),

              // ── Main Card Swiper ──────────────────────
              SizedBox(
                height: cardH,
                child: PageView.builder(
                  controller: _pc,
                  onPageChanged: _onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _items.length,
                  itemBuilder: (_, i) {
                    final raw = _items[i];
                    final (emoji, text) = _parse(raw);
                    return _ContentCard(
                      emoji: emoji,
                      text: text,
                      raw: raw,
                      color: color,
                      type: _type,
                      onTap: () => _speak(raw),
                      screenWidth: sw,
                    );
                  },
                ),
              ),

              SizedBox(height: (sh * 0.018).clamp(10.0, 18.0)),

              // ── Dot Indicators ────────────────────────
              SizedBox(
                height: 12,
                child: _items.length <= 30
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 5),
                        itemBuilder: (_, i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: i == _page ? 20 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? color
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )
                    : Text(
                        '${_page + 1} of ${_items.length}',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
              ),

              SizedBox(height: (sh * 0.02).clamp(12.0, 20.0)),

              // ── Navigation Row ─────────────────────────
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // Previous
                _NavBtn(
                  icon: Icons.arrow_back_ios_rounded,
                  enabled: _page > 0,
                  color: color,
                  onTap: () => _pc.previousPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut),
                ),
                SizedBox(width: (sw * 0.06).clamp(16.0, 28.0)),

                // Speak button
                GestureDetector(
                  onTap: () => _speak(_items[_page]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: (sw * 0.16).clamp(54.0, 70.0),
                    height: (sw * 0.16).clamp(54.0, 70.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [color, Color.lerp(color, Colors.black, 0.25)!]),
                      boxShadow: [
                        BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 16,
                            offset: const Offset(0, 5))
                      ],
                    ),
                    child: Icon(
                        _speaking ? Icons.volume_up : Icons.volume_up_outlined,
                        color: Colors.white,
                        size: (sw * 0.07).clamp(22.0, 32.0)),
                  ),
                ),

                SizedBox(width: (sw * 0.06).clamp(16.0, 28.0)),

                // Next
                _NavBtn(
                  icon: Icons.arrow_forward_ios_rounded,
                  enabled: _page < _items.length - 1,
                  color: color,
                  onTap: () => _pc.nextPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut),
                ),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ─── Content Card ─────────────────────────────────────────
class _ContentCard extends StatelessWidget {
  final String emoji, text, raw;
  final Color color;
  final String type;
  final VoidCallback onTap;
  final double screenWidth;
  const _ContentCard({
    required this.emoji,
    required this.text,
    required this.raw,
    required this.color,
    required this.type,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final isPoem = type == 'poem';
    final isStory = type == 'story';
    final emojiSize = isPoem || isStory
        ? (screenWidth * 0.12).clamp(38.0, 60.0)
        : emoji.isNotEmpty
            ? (screenWidth * 0.22).clamp(72.0, 110.0)
            : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (screenWidth * 0.02).clamp(4.0, 12.0),
            vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.92),
                Color.lerp(color, Colors.black, 0.4)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 8))
            ],
          ),
          child: Stack(children: [
            // decorative blobs
            Positioned(
              right: -30, top: -30,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06)),
              ),
            ),
            Positioned(
              left: -20, bottom: -20,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05)),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: EdgeInsets.all((screenWidth * 0.06).clamp(16.0, 28.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Emoji
                    if (emoji.isNotEmpty && emojiSize > 0) ...[
                      Text(emoji,
                          style: TextStyle(
                              fontSize: emojiSize,
                              shadows: const [
                                Shadow(blurRadius: 10, color: Colors.black38)
                              ])),
                      SizedBox(height: (sh * 0.02).clamp(10.0, 20.0)),
                    ],
                    // Main text
                    Text(
                      isPoem || isStory ? raw : text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize(screenWidth, isPoem, isStory, text),
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        shadows: const [
                          Shadow(blurRadius: 6, color: Colors.black38)
                        ],
                      ),
                    ),
                    SizedBox(height: (sh * 0.015).clamp(8.0, 16.0)),
                    // Tap hint
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.volume_up, color: Colors.white70, size: 14),
                        const SizedBox(width: 5),
                        Text('Tap to hear',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: (screenWidth * 0.028).clamp(10.0, 13.0))),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  double _fontSize(double sw, bool isPoem, bool isStory, String text) {
    if (isStory) return (sw * 0.042).clamp(14.0, 20.0);
    if (isPoem) return (sw * 0.05).clamp(17.0, 24.0);
    if (text.length > 20) return (sw * 0.052).clamp(18.0, 24.0);
    return (sw * 0.07).clamp(24.0, 36.0);
  }
}

// ─── Navigation Button ────────────────────────────────────
class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;
  const _NavBtn(
      {required this.icon,
      required this.enabled,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: (sw * 0.12).clamp(40.0, 54.0),
        height: (sw * 0.12).clamp(40.0, 54.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? color.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
              color: enabled ? color.withOpacity(0.5) : Colors.white12),
        ),
        child: Icon(icon,
            color: enabled ? color : Colors.white24,
            size: (sw * 0.055).clamp(18.0, 26.0)),
      ),
    );
  }
}
