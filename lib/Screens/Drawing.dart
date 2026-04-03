import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

// ═══════════════════════════════════════════════════════════════════
//  DRAWING STUDIO — Premium Kids Drawing App with Full Toolset
// ═══════════════════════════════════════════════════════════════════

const Color _kBg = Color(0xFF0F0E17);
const Color _kSurface = Color(0xFF1A1A2E);
const Color _kCard = Color(0xFF1E2A45);
const Color _kAccent = Color(0xFF7C6FFF);

// ── Drawing Tool Enum ──
enum DrawTool { pen, brush, marker, spray, eraser, line, rectangle, circle, triangle, star, fill, text }

// ── Stroke Data ──
class DrawStroke {
  final List<Offset> points;
  final Color color;
  final double width;
  final DrawTool tool;
  final bool isFilled;
  final String? text;

  DrawStroke({
    required this.points,
    required this.color,
    required this.width,
    required this.tool,
    this.isFilled = false,
    this.text,
  });
}

// ═══════════════════════════════════════════════════════════════════
//  DRAWING SCREEN
// ═══════════════════════════════════════════════════════════════════
class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});
  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> with TickerProviderStateMixin {
  // ── State ──
  final List<DrawStroke> _strokes = [];
  final List<DrawStroke> _redoStack = [];
  List<Offset> _currentPoints = [];
  DrawTool _currentTool = DrawTool.pen;
  Color _currentColor = Colors.white;
  double _strokeWidth = 4.0;
  bool _isFilled = false;
  Color _canvasColor = Colors.white;
  bool _showColorPicker = false;
  bool _showToolPanel = false;
  bool _showStrokeSlider = false;
  bool _isCanvasColorPicker = false;
  String _pendingText = '';

  // ── Stickers ──
  final List<_StickerItem> _stickers = [];
  bool _showStickerPicker = false;

  // ── Templates ──
  bool _showTemplates = false;

  // ── Animation ──
  late AnimationController _toolPanelController;
  late Animation<double> _toolPanelSlide;

  // ── Canvas Key for Export ──
  final GlobalKey _canvasKey = GlobalKey();

  // ── Color Palette ──
  static const List<Color> _palette = [
    Colors.white, Colors.black,
    Color(0xFFE53935), Color(0xFFD81B60), Color(0xFF8E24AA),
    Color(0xFF5E35B1), Color(0xFF3949AB), Color(0xFF1E88E5),
    Color(0xFF039BE5), Color(0xFF00ACC1), Color(0xFF00897B),
    Color(0xFF43A047), Color(0xFF7CB342), Color(0xFFCDDC39),
    Color(0xFFFFEB3B), Color(0xFFFFC107), Color(0xFFFF9800),
    Color(0xFFFF5722), Color(0xFF795548), Color(0xFF607D8B),
    Color(0xFFFF80AB), Color(0xFF82B1FF), Color(0xFFB9F6CA),
    Color(0xFFFFF9C4),
  ];

  static const List<Color> _canvasColors = [
    Colors.white, Color(0xFF0F0E17), Color(0xFF1A1A2E),
    Color(0xFFFFF8E1), Color(0xFFE8F5E9), Color(0xFFE3F2FD),
    Color(0xFFFCE4EC), Color(0xFFF3E5F5), Color(0xFF263238),
  ];

  // ── Tool definitions ──
  static const List<Map<String, dynamic>> _toolDefs = [
    {'tool': DrawTool.pen, 'icon': Icons.edit, 'label': 'Pen'},
    {'tool': DrawTool.brush, 'icon': Icons.brush, 'label': 'Brush'},
    {'tool': DrawTool.marker, 'icon': Icons.format_paint, 'label': 'Marker'},
    {'tool': DrawTool.spray, 'icon': Icons.grain, 'label': 'Spray'},
    {'tool': DrawTool.eraser, 'icon': Icons.auto_fix_off, 'label': 'Eraser'},
    {'tool': DrawTool.line, 'icon': Icons.show_chart, 'label': 'Line'},
    {'tool': DrawTool.rectangle, 'icon': Icons.crop_square, 'label': 'Rectangle'},
    {'tool': DrawTool.circle, 'icon': Icons.circle_outlined, 'label': 'Circle'},
    {'tool': DrawTool.triangle, 'icon': Icons.change_history, 'label': 'Triangle'},
    {'tool': DrawTool.star, 'icon': Icons.star_outline, 'label': 'Star'},
    {'tool': DrawTool.fill, 'icon': Icons.format_color_fill, 'label': 'Fill'},
    {'tool': DrawTool.text, 'icon': Icons.text_fields, 'label': 'Text'},
  ];

  // ── Sticker data ──
  static const List<String> _stickerEmojis = [
    '⭐', '❤️', '🌈', '🦋', '🌸', '🌻', '🐱', '🐶', '🐰', '🦁',
    '🐻', '🐼', '🦊', '🐸', '🐝', '🌟', '✨', '💫', '🎈', '🎀',
    '🎨', '🎵', '🌙', '☀️', '🌺', '🍎', '🍭', '🧁', '🎂', '🏠',
    '🚀', '⚽', '🎯', '👑', '💎', '🔥', '💖', '🌊', '🍀', '🎪',
  ];

  @override
  void initState() {
    super.initState();
    _toolPanelController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 300),
    );
    _toolPanelSlide = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _toolPanelController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _toolPanelController.dispose();
    super.dispose();
  }

  void _undo() {
    if (_strokes.isNotEmpty) {
      setState(() {
        _redoStack.add(_strokes.removeLast());
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      setState(() {
        _strokes.add(_redoStack.removeLast());
      });
    }
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _kSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Canvas?', style: TextStyle(color: Colors.white)),
        content: const Text('This will erase everything!',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _strokes.clear();
                _redoStack.clear();
                _stickers.clear();
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: _kAccent),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _addTextStroke(Offset position) {
    showDialog(
      context: context,
      builder: (ctx) {
        String txt = '';
        return AlertDialog(
          backgroundColor: _kSurface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Text', style: TextStyle(color: Colors.white)),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Type here...',
              hintStyle: const TextStyle(color: Colors.white38),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kAccent),
              ),
            ),
            onChanged: (v) => txt = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                if (txt.isNotEmpty) {
                  setState(() {
                    _strokes.add(DrawStroke(
                      points: [position],
                      color: _currentColor,
                      width: _strokeWidth * 4,
                      tool: DrawTool.text,
                      text: txt,
                    ));
                    _redoStack.clear();
                  });
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(backgroundColor: _kAccent),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _toggleToolPanel() {
    setState(() => _showToolPanel = !_showToolPanel);
    if (_showToolPanel) {
      _toolPanelController.forward();
    } else {
      _toolPanelController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        title: Text('🎨 Drawing Studio',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,
                fontSize: (sw * 0.045).clamp(15.0, 20.0))),
        backgroundColor: _kSurface,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.undo_rounded, color: Colors.white70),
              onPressed: _strokes.isNotEmpty ? _undo : null),
          IconButton(icon: const Icon(Icons.redo_rounded, color: Colors.white70),
              onPressed: _redoStack.isNotEmpty ? _redo : null),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.white70),
              onPressed: _clearCanvas),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Top toolbar ──
          _buildTopToolbar(sw),
          // ── Canvas ──
          Expanded(
            child: Stack(
              children: [
                _buildCanvas(sw, sh),
                // ── Tool panel overlay ──
                if (_showToolPanel) _buildToolPanel(sw),
                // ── Color picker overlay ──
                if (_showColorPicker) _buildColorPicker(sw),
                // ── Sticker picker overlay ──
                if (_showStickerPicker) _buildStickerPicker(sw),
                // ── Templates overlay ──
                if (_showTemplates) _buildTemplatesOverlay(sw),
                // ── Stroke width slider ──
                if (_showStrokeSlider) _buildStrokeSlider(sw),
              ],
            ),
          ),
          // ── Bottom toolbar ──
          _buildBottomToolbar(sw),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  TOP TOOLBAR — Quick actions
  // ═══════════════════════════════════════════════════════════
  Widget _buildTopToolbar(double sw) {
    final toolName = _toolDefs.firstWhere((t) => t['tool'] == _currentTool)['label'] as String;
    return Container(
      height: (sw * 0.12).clamp(42.0, 52.0),
      color: _kSurface,
      padding: EdgeInsets.symmetric(horizontal: (sw * 0.03).clamp(8.0, 14.0)),
      child: Row(
        children: [
          // Current tool indicator
          GestureDetector(
            onTap: _toggleToolPanel,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (sw * 0.03).clamp(10.0, 14.0), vertical: 6),
              decoration: BoxDecoration(
                color: _kAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _kAccent.withOpacity(0.5)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(_toolDefs.firstWhere((t) => t['tool'] == _currentTool)['icon'] as IconData,
                    color: _kAccent, size: (sw * 0.045).clamp(16.0, 20.0)),
                const SizedBox(width: 6),
                Text(toolName, style: TextStyle(color: _kAccent,
                    fontSize: (sw * 0.03).clamp(10.0, 13.0), fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Icon(Icons.expand_more, color: _kAccent, size: (sw * 0.04).clamp(14.0, 18.0)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          // Current color
          GestureDetector(
            onTap: () => setState(() {
              _showColorPicker = !_showColorPicker;
              _isCanvasColorPicker = false;
              _showStickerPicker = false;
              _showTemplates = false;
              _showStrokeSlider = false;
            }),
            child: Container(
              width: (sw * 0.08).clamp(28.0, 36.0),
              height: (sw * 0.08).clamp(28.0, 36.0),
              decoration: BoxDecoration(
                color: _currentTool == DrawTool.eraser ? _canvasColor : _currentColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38, width: 2),
                boxShadow: [BoxShadow(color: _currentColor.withOpacity(0.4), blurRadius: 8)],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Stroke width
          GestureDetector(
            onTap: () => setState(() {
              _showStrokeSlider = !_showStrokeSlider;
              _showColorPicker = false;
              _showStickerPicker = false;
              _showTemplates = false;
            }),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: (sw * 0.025).clamp(8.0, 12.0), vertical: 6),
              decoration: BoxDecoration(
                color: _kCard, borderRadius: BorderRadius.circular(14),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: _strokeWidth.clamp(2.0, 12.0),
                  height: _strokeWidth.clamp(2.0, 12.0),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text('${_strokeWidth.round()}px', style: TextStyle(color: Colors.white54,
                    fontSize: (sw * 0.028).clamp(10.0, 12.0))),
              ]),
            ),
          ),
          const Spacer(),
          // Fill toggle (for shapes)
          if (_currentTool == DrawTool.rectangle || _currentTool == DrawTool.circle ||
              _currentTool == DrawTool.triangle || _currentTool == DrawTool.star)
            GestureDetector(
              onTap: () => setState(() => _isFilled = !_isFilled),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _isFilled ? _kAccent.withOpacity(0.3) : _kCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _isFilled ? _kAccent : Colors.white24),
                ),
                child: Text(_isFilled ? 'Filled' : 'Outline',
                    style: TextStyle(color: _isFilled ? _kAccent : Colors.white54,
                        fontSize: (sw * 0.028).clamp(10.0, 12.0), fontWeight: FontWeight.w600)),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  CANVAS
  // ═══════════════════════════════════════════════════════════
  Widget _buildCanvas(double sw, double sh) {
    return RepaintBoundary(
      key: _canvasKey,
      child: GestureDetector(
        onPanStart: (d) {
          if (_currentTool == DrawTool.text) {
            _addTextStroke(d.localPosition);
            return;
          }
          if (_currentTool == DrawTool.fill) {
            setState(() {
              _canvasColor = _currentColor;
            });
            return;
          }
          setState(() {
            _currentPoints = [d.localPosition];
            _showColorPicker = false;
            _showToolPanel = false;
            _showStickerPicker = false;
            _showTemplates = false;
            _showStrokeSlider = false;
          });
        },
        onPanUpdate: (d) {
          if (_currentTool == DrawTool.text || _currentTool == DrawTool.fill) return;
          setState(() {
            if (_isShapeTool) {
              // For shapes, only keep start and current point
              if (_currentPoints.isNotEmpty) {
                _currentPoints = [_currentPoints.first, d.localPosition];
              }
            } else if (_currentTool == DrawTool.spray) {
              // Spray: add random dots around cursor
              final rng = Random();
              for (int i = 0; i < 5; i++) {
                _currentPoints.add(Offset(
                  d.localPosition.dx + (rng.nextDouble() - 0.5) * _strokeWidth * 6,
                  d.localPosition.dy + (rng.nextDouble() - 0.5) * _strokeWidth * 6,
                ));
              }
            } else {
              _currentPoints.add(d.localPosition);
            }
          });
        },
        onPanEnd: (_) {
          if (_currentTool == DrawTool.text || _currentTool == DrawTool.fill) return;
          if (_currentPoints.isNotEmpty) {
            setState(() {
              _strokes.add(DrawStroke(
                points: List.from(_currentPoints),
                color: _currentTool == DrawTool.eraser ? _canvasColor : _currentColor,
                width: _currentTool == DrawTool.eraser ? _strokeWidth * 3 : _strokeWidth,
                tool: _currentTool,
                isFilled: _isFilled,
              ));
              _currentPoints = [];
              _redoStack.clear();
            });
          }
        },
        child: Container(
          color: _canvasColor,
          child: CustomPaint(
            painter: _DrawingPainter(
              strokes: _strokes,
              currentPoints: _currentPoints,
              currentColor: _currentTool == DrawTool.eraser ? _canvasColor : _currentColor,
              currentWidth: _currentTool == DrawTool.eraser ? _strokeWidth * 3 : _strokeWidth,
              currentTool: _currentTool,
              isFilled: _isFilled,
              canvasColor: _canvasColor,
            ),
            child: SizedBox.expand(
              child: Stack(
                children: _stickers.map((s) => Positioned(
                  left: s.position.dx - 20,
                  top: s.position.dy - 20,
                  child: GestureDetector(
                    onPanUpdate: (d) {
                      setState(() {
                        s.position = s.position + d.delta;
                      });
                    },
                    child: Text(s.emoji, style: TextStyle(fontSize: s.size)),
                  ),
                )).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _isShapeTool => _currentTool == DrawTool.line || _currentTool == DrawTool.rectangle ||
      _currentTool == DrawTool.circle || _currentTool == DrawTool.triangle || _currentTool == DrawTool.star;

  // ═══════════════════════════════════════════════════════════
  //  TOOL PANEL
  // ═══════════════════════════════════════════════════════════
  Widget _buildToolPanel(double sw) {
    return Positioned(
      left: (sw * 0.03).clamp(8.0, 14.0),
      top: 8,
      child: AnimatedBuilder(
        animation: _toolPanelController,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _toolPanelSlide.value * -200),
          child: Opacity(opacity: 1 - _toolPanelSlide.value, child: child),
        ),
        child: Container(
          width: (sw * 0.7).clamp(240.0, 320.0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _kSurface.withOpacity(0.95),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Drawing Tools', style: TextStyle(color: Colors.white54,
                  fontSize: (sw * 0.028).clamp(10.0, 12.0), fontWeight: FontWeight.w600, letterSpacing: 1)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6, runSpacing: 6,
                children: _toolDefs.map((td) {
                  final tool = td['tool'] as DrawTool;
                  final isSelected = _currentTool == tool;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _currentTool = tool;
                        _showToolPanel = false;
                      });
                      _toolPanelController.reverse();
                    },
                    child: Container(
                      width: (sw * 0.15).clamp(52.0, 68.0),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? _kAccent.withOpacity(0.3) : _kCard,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? _kAccent : Colors.white12),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(td['icon'] as IconData,
                            color: isSelected ? _kAccent : Colors.white54,
                            size: (sw * 0.05).clamp(18.0, 22.0)),
                        const SizedBox(height: 3),
                        Text(td['label'] as String,
                            style: TextStyle(color: isSelected ? _kAccent : Colors.white38,
                                fontSize: (sw * 0.022).clamp(8.0, 10.0), fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  COLOR PICKER
  // ═══════════════════════════════════════════════════════════
  Widget _buildColorPicker(double sw) {
    final colors = _isCanvasColorPicker ? _canvasColors : _palette;
    final title = _isCanvasColorPicker ? 'Canvas Color' : 'Pick a Color';
    return Positioned(
      left: (sw * 0.05).clamp(12.0, 20.0),
      right: (sw * 0.05).clamp(12.0, 20.0),
      top: 8,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(title, style: TextStyle(color: Colors.white54,
                  fontSize: (sw * 0.03).clamp(11.0, 13.0), fontWeight: FontWeight.w600)),
              const Spacer(),
              if (!_isCanvasColorPicker)
                GestureDetector(
                  onTap: () => setState(() => _isCanvasColorPicker = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kCard, borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Canvas BG', style: TextStyle(color: Colors.white38,
                        fontSize: (sw * 0.025).clamp(9.0, 11.0))),
                  ),
                ),
              if (_isCanvasColorPicker)
                GestureDetector(
                  onTap: () => setState(() => _isCanvasColorPicker = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kCard, borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Pen Color', style: TextStyle(color: Colors.white38,
                        fontSize: (sw * 0.025).clamp(9.0, 11.0))),
                  ),
                ),
            ]),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: colors.map((c) {
                final selected = _isCanvasColorPicker ? c == _canvasColor : c == _currentColor;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (_isCanvasColorPicker) {
                        _canvasColor = c;
                      } else {
                        _currentColor = c;
                      }
                      _showColorPicker = false;
                    });
                  },
                  child: Container(
                    width: (sw * 0.09).clamp(32.0, 40.0),
                    height: (sw * 0.09).clamp(32.0, 40.0),
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: selected ? _kAccent : Colors.white24,
                        width: selected ? 3 : 1,
                      ),
                      boxShadow: selected
                          ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 10)]
                          : [],
                    ),
                    child: selected
                        ? Icon(Icons.check, color: c.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                            size: (sw * 0.04).clamp(14.0, 18.0))
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  STROKE WIDTH SLIDER
  // ═══════════════════════════════════════════════════════════
  Widget _buildStrokeSlider(double sw) {
    return Positioned(
      left: (sw * 0.05).clamp(12.0, 20.0),
      right: (sw * 0.05).clamp(12.0, 20.0),
      top: 8,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        ),
        child: Column(children: [
          Text('Stroke Width: ${_strokeWidth.round()}px',
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 8),
          Row(children: [
            const Text('1', style: TextStyle(color: Colors.white38, fontSize: 11)),
            Expanded(
              child: Slider(
                value: _strokeWidth,
                min: 1, max: 30,
                activeColor: _kAccent,
                inactiveColor: _kCard,
                onChanged: (v) => setState(() => _strokeWidth = v),
              ),
            ),
            const Text('30', style: TextStyle(color: Colors.white38, fontSize: 11)),
          ]),
          // Preview
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: _kCard, borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                width: _strokeWidth.clamp(1, 30) * 3,
                height: _strokeWidth.clamp(1, 30),
                decoration: BoxDecoration(
                  color: _currentColor,
                  borderRadius: BorderRadius.circular(_strokeWidth / 2),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  STICKER PICKER
  // ═══════════════════════════════════════════════════════════
  Widget _buildStickerPicker(double sw) {
    return Positioned(
      left: (sw * 0.05).clamp(12.0, 20.0),
      right: (sw * 0.05).clamp(12.0, 20.0),
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          color: _kSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stickers', style: TextStyle(color: Colors.white54,
                fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, crossAxisSpacing: 4, mainAxisSpacing: 4,
                ),
                itemCount: _stickerEmojis.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    setState(() {
                      _stickers.add(_StickerItem(
                        emoji: _stickerEmojis[i],
                        position: Offset(
                          MediaQuery.of(context).size.width / 2,
                          MediaQuery.of(context).size.height / 3,
                        ),
                        size: 40,
                      ));
                      _showStickerPicker = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _kCard, borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text(_stickerEmojis[i],
                        style: TextStyle(fontSize: (sw * 0.05).clamp(18.0, 24.0)))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  TEMPLATES OVERLAY
  // ═══════════════════════════════════════════════════════════
  Widget _buildTemplatesOverlay(double sw) {
    final templates = [
      {'name': 'Blank White', 'color': Colors.white},
      {'name': 'Dark Canvas', 'color': const Color(0xFF0F0E17)},
      {'name': 'Warm Sand', 'color': const Color(0xFFFFF8E1)},
      {'name': 'Mint Fresh', 'color': const Color(0xFFE8F5E9)},
      {'name': 'Sky Blue', 'color': const Color(0xFFE3F2FD)},
      {'name': 'Rose Petal', 'color': const Color(0xFFFCE4EC)},
    ];

    return Positioned(
      left: (sw * 0.05).clamp(12.0, 20.0),
      right: (sw * 0.05).clamp(12.0, 20.0),
      top: 8,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kSurface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Canvas Templates', style: TextStyle(color: Colors.white54,
                fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: templates.map((t) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _canvasColor = t['color'] as Color;
                      _strokes.clear();
                      _redoStack.clear();
                      _stickers.clear();
                      _showTemplates = false;
                    });
                  },
                  child: Container(
                    width: (sw * 0.25).clamp(80.0, 100.0),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _kCard, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(children: [
                      Container(
                        height: 40, width: double.infinity,
                        decoration: BoxDecoration(
                          color: t['color'] as Color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white12),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(t['name'] as String, style: TextStyle(color: Colors.white54,
                          fontSize: (sw * 0.024).clamp(8.0, 10.0)),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  BOTTOM TOOLBAR
  // ═══════════════════════════════════════════════════════════
  Widget _buildBottomToolbar(double sw) {
    return Container(
      height: (sw * 0.16).clamp(56.0, 68.0),
      color: _kSurface,
      padding: EdgeInsets.symmetric(horizontal: (sw * 0.02).clamp(6.0, 12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _bottomBtn(Icons.brush, 'Tools', () => _toggleToolPanel()),
          _bottomBtn(Icons.palette, 'Colors', () => setState(() {
            _showColorPicker = !_showColorPicker;
            _isCanvasColorPicker = false;
            _showStickerPicker = false;
            _showTemplates = false;
            _showStrokeSlider = false;
          })),
          _bottomBtn(Icons.emoji_emotions, 'Stickers', () => setState(() {
            _showStickerPicker = !_showStickerPicker;
            _showColorPicker = false;
            _showTemplates = false;
            _showStrokeSlider = false;
          })),
          _bottomBtn(Icons.grid_on, 'Templates', () => setState(() {
            _showTemplates = !_showTemplates;
            _showColorPicker = false;
            _showStickerPicker = false;
            _showStrokeSlider = false;
          })),
          _bottomBtn(Icons.line_weight, 'Size', () => setState(() {
            _showStrokeSlider = !_showStrokeSlider;
            _showColorPicker = false;
            _showStickerPicker = false;
            _showTemplates = false;
          })),
        ],
      ),
    );
  }

  Widget _bottomBtn(IconData icon, String label, VoidCallback onTap) {
    final sw = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white60, size: (sw * 0.06).clamp(20.0, 26.0)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.white38,
              fontSize: (sw * 0.024).clamp(8.0, 10.0))),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STICKER ITEM
// ═══════════════════════════════════════════════════════════════════
class _StickerItem {
  final String emoji;
  Offset position;
  final double size;
  _StickerItem({required this.emoji, required this.position, required this.size});
}

// ═══════════════════════════════════════════════════════════════════
//  CUSTOM PAINTER — Renders all strokes
// ═══════════════════════════════════════════════════════════════════
class _DrawingPainter extends CustomPainter {
  final List<DrawStroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;
  final DrawTool currentTool;
  final bool isFilled;
  final Color canvasColor;

  _DrawingPainter({
    required this.strokes,
    required this.currentPoints,
    required this.currentColor,
    required this.currentWidth,
    required this.currentTool,
    required this.isFilled,
    required this.canvasColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw all completed strokes
    for (final stroke in strokes) {
      _drawStroke(canvas, stroke);
    }
    // Draw current stroke
    if (currentPoints.isNotEmpty) {
      _drawStroke(canvas, DrawStroke(
        points: currentPoints,
        color: currentColor,
        width: currentWidth,
        tool: currentTool,
        isFilled: isFilled,
      ));
    }
  }

  void _drawStroke(Canvas canvas, DrawStroke stroke) {
    final paint = Paint()
      ..color = stroke.color
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    switch (stroke.tool) {
      case DrawTool.pen:
        _drawFreehand(canvas, stroke, paint);
        break;
      case DrawTool.brush:
        paint.strokeWidth = stroke.width * 2;
        paint.color = stroke.color.withOpacity(0.6);
        _drawFreehand(canvas, stroke, paint);
        break;
      case DrawTool.marker:
        paint.strokeWidth = stroke.width * 3;
        paint.color = stroke.color.withOpacity(0.35);
        paint.strokeCap = StrokeCap.square;
        _drawFreehand(canvas, stroke, paint);
        break;
      case DrawTool.spray:
        final dotPaint = Paint()..color = stroke.color;
        for (final pt in stroke.points) {
          canvas.drawCircle(pt, stroke.width * 0.3, dotPaint);
        }
        break;
      case DrawTool.eraser:
        paint.color = canvasColor;
        paint.strokeWidth = stroke.width;
        _drawFreehand(canvas, stroke, paint);
        break;
      case DrawTool.line:
        if (stroke.points.length >= 2) {
          canvas.drawLine(stroke.points.first, stroke.points.last, paint);
        }
        break;
      case DrawTool.rectangle:
        if (stroke.points.length >= 2) {
          final rect = Rect.fromPoints(stroke.points.first, stroke.points.last);
          if (stroke.isFilled) paint.style = PaintingStyle.fill;
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            paint,
          );
        }
        break;
      case DrawTool.circle:
        if (stroke.points.length >= 2) {
          final center = stroke.points.first;
          final radius = (stroke.points.last - stroke.points.first).distance;
          if (stroke.isFilled) paint.style = PaintingStyle.fill;
          canvas.drawCircle(center, radius, paint);
        }
        break;
      case DrawTool.triangle:
        if (stroke.points.length >= 2) {
          final start = stroke.points.first;
          final end = stroke.points.last;
          final path = Path()
            ..moveTo((start.dx + end.dx) / 2, start.dy)
            ..lineTo(end.dx, end.dy)
            ..lineTo(start.dx, end.dy)
            ..close();
          if (stroke.isFilled) paint.style = PaintingStyle.fill;
          canvas.drawPath(path, paint);
        }
        break;
      case DrawTool.star:
        if (stroke.points.length >= 2) {
          final center = stroke.points.first;
          final radius = (stroke.points.last - stroke.points.first).distance;
          final path = _createStarPath(center, radius, radius * 0.4, 5);
          if (stroke.isFilled) paint.style = PaintingStyle.fill;
          canvas.drawPath(path, paint);
        }
        break;
      case DrawTool.fill:
        // Fill is handled in gesture, not painting
        break;
      case DrawTool.text:
        if (stroke.points.isNotEmpty && stroke.text != null) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: stroke.text,
              style: TextStyle(
                color: stroke.color,
                fontSize: stroke.width,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(canvas, stroke.points.first);
        }
        break;
    }
  }

  void _drawFreehand(Canvas canvas, DrawStroke stroke, Paint paint) {
    if (stroke.points.length < 2) {
      if (stroke.points.isNotEmpty) {
        canvas.drawCircle(stroke.points.first, paint.strokeWidth / 2, paint..style = PaintingStyle.fill);
      }
      return;
    }
    final path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      final p0 = stroke.points[i - 1];
      final p1 = stroke.points[i];
      final mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
    }
    canvas.drawPath(path, paint);
  }

  Path _createStarPath(Offset center, double outerR, double innerR, int points) {
    final path = Path();
    final angle = pi / points;
    for (int i = 0; i < 2 * points; i++) {
      final r = i.isEven ? outerR : innerR;
      final a = i * angle - pi / 2;
      final pt = Offset(center.dx + r * cos(a), center.dy + r * sin(a));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter old) => true;
}
