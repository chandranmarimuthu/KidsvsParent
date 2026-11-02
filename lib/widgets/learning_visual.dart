import 'dart:math' as math;

import 'package:flutter/material.dart';

class LearningPathIllustration extends StatefulWidget {
  const LearningPathIllustration({super.key, required this.pathId, required this.accentColor});

  final String pathId;
  final Color accentColor;

  @override
  State<LearningPathIllustration> createState() => _LearningPathIllustrationState();
}

class _LearningPathIllustrationState extends State<LearningPathIllustration> with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(vsync: this, duration: const Duration(milliseconds: 3600))..repeat();

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: '${widget.pathId.replaceAll('_', ' ')} animated learning illustration',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: ColoredBox(
            color: widget.accentColor.withValues(alpha: 0.13),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _motion,
                builder: (context, child) => CustomPaint(
                  painter: _LearningPathPainter(pathId: widget.pathId, phase: _motion.value, accent: widget.accentColor),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      );
}

class ScienceConceptIllustration extends StatefulWidget {
  const ScienceConceptIllustration({super.key, required this.index});

  final int index;

  @override
  State<ScienceConceptIllustration> createState() => _ScienceConceptIllustrationState();
}

class _ScienceConceptIllustrationState extends State<ScienceConceptIllustration> with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))..repeat();

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Animated science concept illustration',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ColoredBox(
            color: const Color(0xFFE6F2EE),
            child: SizedBox(
              height: 132,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: _motion,
                builder: (context, child) => CustomPaint(
                  painter: _ScienceConceptPainter(index: widget.index, phase: _motion.value),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      );
}

class _LearningPathPainter extends CustomPainter {
  _LearningPathPainter({required this.pathId, required this.phase, required this.accent});

  final String pathId;
  final double phase;
  final Color accent;

  static const _ink = Color(0xFF26443F);
  static const _paper = Color(0xFFFFFEF7);
  static const _coral = Color(0xFFE98770);
  static const _yellow = Color(0xFFF2C75C);
  static const _green = Color(0xFF6EAA83);
  static const _blue = Color(0xFF78ACCA);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 190);
    _circle(canvas, 34, 30, 17, Colors.white.withValues(alpha: 0.55));
    _circle(canvas, 325, 45, 28, Colors.white.withValues(alpha: 0.42));
    switch (pathId) {
      case 'dictionary':
        _book(canvas, 180, 95, 106, 70, accent);
        _text(canvas, 'A', 95, 86, 31, _coral);
        _text(canvas, 'அ', 266, 91, 28, _green);
        _circle(canvas, 98, 57 + math.sin(phase * math.pi * 2) * 5, 5, _yellow);
        _text(canvas, 'WORDS', 180, 164, 13, _ink);
      case 'thirukkural':
        _book(canvas, 180, 101, 132, 82, _yellow);
        _text(canvas, '“', 180, 78 + math.sin(phase * math.pi * 2) * 3, 54, _coral);
        _text(canvas, 'WISDOM', 180, 166, 13, _ink);
      case 'letter_tracing':
        final letter = TextPainter(text: const TextSpan(text: 'A', style: TextStyle(fontSize: 106, fontWeight: FontWeight.w800, color: _paper)), textDirection: TextDirection.ltr)..layout();
        letter.paint(canvas, Offset(180 - letter.width / 2, 20));
        _dottedLine(canvas, const Offset(126, 128), const Offset(180, 35), _coral, phase);
        _dottedLine(canvas, const Offset(180, 35), const Offset(234, 128), _green, phase + 0.3);
        _line(canvas, 145, 110, 215, 110, _blue, 3);
        _text(canvas, 'TRACE THE SHAPE', 180, 163, 12, _ink);
      case 'drawing':
        _circle(canvas, 280, 48, 20, _yellow);
        _hill(canvas, 48, 136, 155, _green);
        _hill(canvas, 208, 142, 134, _blue);
        _line(canvas, 94, 124, 129, 83, _coral, 8);
        _line(canvas, 129, 83, 163, 124, _coral, 8);
        _line(canvas, 110, 103, 148, 103, _coral, 6);
        canvas.save();
        canvas.translate(245, 104);
        canvas.rotate(math.sin(phase * math.pi * 2) * 0.14 - 0.35);
        _line(canvas, 0, 0, 45, -35, accent, 9);
        _circle(canvas, 47, -37, 5, _yellow);
        canvas.restore();
        _text(canvas, 'MAKE A PICTURE', 180, 169, 12, _ink);
      case 'stories':
        _ground(canvas, 0, 146, 360, _green);
        final growth = 46 + 18 * (0.5 + 0.5 * math.sin(phase * math.pi * 2));
        _line(canvas, 180, 145, 180, 145 - growth, _green, 7);
        _leaf(canvas, 180, 145 - growth * 0.64, -1, _green);
        _leaf(canvas, 180, 145 - growth * 0.82, 1, _green);
        _circle(canvas, 180, 151, 9, _coral);
        _circle(canvas, 280, 49, 18, _yellow);
        _text(canvas, 'GROW AT YOUR PACE', 180, 174, 12, _ink);
      case 'coding':
        final nodes = [const Offset(64, 82), const Offset(144, 82), const Offset(224, 82), const Offset(304, 82)];
        for (var index = 0; index < nodes.length; index++) {
          final active = (phase * nodes.length).floor() % nodes.length == index;
          _box(canvas, nodes[index].dx - 24, nodes[index].dy - 23, 48, 48, active ? _yellow : _paper, _ink);
          _text(canvas, '${index + 1}', nodes[index].dx, nodes[index].dy + 1, 18, _ink);
          if (index < nodes.length - 1) _line(canvas, nodes[index].dx + 26, 82, nodes[index + 1].dx - 26, 82, accent, 4);
        }
        final robotX = 64 + 240 * phase;
        _box(canvas, robotX - 13, 118, 26, 22, accent, _ink);
        _circle(canvas, robotX - 6, 126, 2.5, Colors.white);
        _circle(canvas, robotX + 6, 126, 2.5, Colors.white);
        _text(canvas, 'GIVE CLEAR STEPS', 180, 165, 12, _ink);
      case 'puzzles':
        for (var index = 0; index < 4; index++) {
          final x = 70.0 + index * 73;
          final pulse = index == (phase * 4).floor() ? 1.0 : 0.78;
          _box(canvas, x - 25, 60, 50, 50, index == 3 ? _yellow.withValues(alpha: pulse) : _paper, _ink);
          _text(canvas, index == 3 ? '?' : '${index * 2 + 2}', x, 86, 23, _ink);
        }
        _text(canvas, 'NOTICE THE PATTERN', 180, 153, 12, _ink);
      case 'science':
        _circle(canvas, 105, 83, 31, _yellow);
        for (var ray = 0; ray < 8; ray++) {
          final angle = ray * math.pi / 4 + phase * math.pi / 8;
          _line(canvas, 105 + math.cos(angle) * 40, 83 + math.sin(angle) * 40, 105 + math.cos(angle) * 50, 83 + math.sin(angle) * 50, _yellow, 3);
        }
        _circle(canvas, 236, 82, 44, _blue.withValues(alpha: 0.74));
        _circle(canvas, 221, 68, 11, _green);
        _circle(canvas, 248, 96, 14, _green);
        _circle(canvas, 236 + math.cos(phase * math.pi * 2) * 66, 82 + math.sin(phase * math.pi * 2) * 26, 8, _coral);
        _line(canvas, 232, 133, 232, 107, _green, 5);
        _leaf(canvas, 232, 120, -1, _green);
        _leaf(canvas, 232, 113, 1, _green);
        _text(canvas, 'LOOK CLOSELY', 180, 167, 12, _ink);
      case 'india_history':
        _box(canvas, 135, 80, 90, 72, _paper, _ink);
        _box(canvas, 124, 71, 112, 13, _coral, _ink);
        for (var pillar = 0; pillar < 4; pillar++) {
          _box(canvas, 143 + pillar * 21, 94, 11, 58, _yellow, _ink);
        }
        _line(canvas, 129, 153, 231, 153, _green, 5);
        final flagWave = math.sin(phase * math.pi * 2) * 5;
        _line(canvas, 273, 63, 273, 143, _ink, 3);
        _box(canvas, 276, 68 + flagWave, 38, 9, _coral, _coral);
        _box(canvas, 276, 77 + flagWave, 38, 9, _paper, _ink);
        _box(canvas, 276, 86 + flagWave, 38, 9, _green, _green);
        _text(canvas, 'PEOPLE · PLACES · STORIES', 180, 171, 11, _ink);
      default:
        _circle(canvas, 180, 88, 42, accent);
        _text(canvas, 'EXPLORE', 180, 160, 14, _ink);
    }
    canvas.restore();
  }

  void _book(Canvas canvas, double x, double y, double width, double height, Color pageColor) {
    final left = Rect.fromCenter(center: Offset(x - width * 0.24, y), width: width * 0.48, height: height);
    final right = Rect.fromCenter(center: Offset(x + width * 0.24, y), width: width * 0.48, height: height);
    final border = Paint()..color = _ink..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawRRect(RRect.fromRectAndRadius(left, const Radius.circular(9)), Paint()..color = _paper);
    canvas.drawRRect(RRect.fromRectAndRadius(right, const Radius.circular(9)), Paint()..color = pageColor.withValues(alpha: 0.55));
    canvas.drawRRect(RRect.fromRectAndRadius(left, const Radius.circular(9)), border);
    canvas.drawRRect(RRect.fromRectAndRadius(right, const Radius.circular(9)), border);
    _line(canvas, x, y - height / 2 + 5, x, y + height / 2 - 5, _ink, 2);
    for (var row = 0; row < 3; row++) {
      _line(canvas, x - width * 0.4, y - 14 + row * 14, x - 10, y - 14 + row * 14, _blue, 2);
      _line(canvas, x + 10, y - 14 + row * 14, x + width * 0.4, y - 14 + row * 14, _blue, 2);
    }
  }

  void _circle(Canvas canvas, double x, double y, double radius, Color color) => canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
  void _box(Canvas canvas, double x, double y, double width, double height, Color color, Color border) {
    final rect = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, width, height), const Radius.circular(9));
    canvas.drawRRect(rect, Paint()..color = color);
    canvas.drawRRect(rect, Paint()..color = border..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _line(Canvas canvas, double x1, double y1, double x2, double y2, Color color, double width) =>
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), Paint()..color = color..strokeWidth = width..strokeCap = StrokeCap.round);

  void _text(Canvas canvas, String value, double centerX, double centerY, double size, Color color) {
    final painter = TextPainter(text: TextSpan(text: value, style: TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: color)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, Offset(centerX - painter.width / 2, centerY - painter.height / 2));
  }

  void _dottedLine(Canvas canvas, Offset start, Offset end, Color color, double offset) {
    for (var index = 0; index <= 14; index++) {
      final progress = (index / 14 + offset) % 1;
      _circle(canvas, start.dx + (end.dx - start.dx) * progress, start.dy + (end.dy - start.dy) * progress, 2.2, color);
    }
  }

  void _hill(Canvas canvas, double left, double bottom, double width, Color color) {
    final path = Path()..moveTo(left, bottom)..quadraticBezierTo(left + width * 0.5, bottom - 82, left + width, bottom)..close();
    canvas.drawPath(path, Paint()..color = color.withValues(alpha: 0.72));
  }

  void _ground(Canvas canvas, double left, double top, double width, Color color) =>
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(left, top, width, 55), const Radius.circular(28)), Paint()..color = color.withValues(alpha: 0.45));

  void _leaf(Canvas canvas, double x, double y, double direction, Color color) {
    final leaf = Path()
      ..moveTo(x, y)
      ..quadraticBezierTo(x + direction * 24, y - 23, x + direction * 29, y - 5)
      ..quadraticBezierTo(x + direction * 22, y + 6, x, y)
      ..close();
    canvas.drawPath(leaf, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _LearningPathPainter oldDelegate) => oldDelegate.phase != phase || oldDelegate.pathId != pathId || oldDelegate.accent != accent;
}

class _ScienceConceptPainter extends CustomPainter {
  _ScienceConceptPainter({required this.index, required this.phase});

  final int index;
  final double phase;

  static const _ink = Color(0xFF26443F);
  static const _green = Color(0xFF68A87F);
  static const _blue = Color(0xFF6AAFC8);
  static const _yellow = Color(0xFFF2C75C);
  static const _coral = Color(0xFFE98770);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 360, size.height / 132);
    switch (index) {
      case 0:
        _plant(canvas);
      case 1:
        _waterCycle(canvas);
      case 2:
        _shadow(canvas);
      case 3:
        _sound(canvas);
      case 4:
        _force(canvas);
      case 5:
        _habitat(canvas);
      default:
        _plant(canvas);
    }
    canvas.restore();
  }

  void _plant(Canvas canvas) {
    _circle(canvas, 294, 35, 18, _yellow);
    _line(canvas, 176, 113, 176, 56, _green, 6);
    _leaf(canvas, 176, 84, -1);
    _leaf(canvas, 176, 70, 1);
    _box(canvas, 146, 104, 60, 16, _coral);
    final beamOpacity = 0.3 + math.sin(phase * math.pi * 2).abs() * 0.55;
    final beam = Path()..moveTo(279, 54)..lineTo(203, 86)..lineTo(203, 57)..close();
    canvas.drawPath(beam, Paint()..color = _yellow.withValues(alpha: beamOpacity * 0.4));
    _text(canvas, 'SUNLIGHT + WATER', 270, 103, 11, _ink);
  }

  void _waterCycle(Canvas canvas) {
    _box(canvas, 34, 91, 292, 27, _blue.withValues(alpha: 0.62));
    _cloud(canvas, 177, 42);
    for (var drop = 0; drop < 3; drop++) {
      final y = 62 + ((phase + drop / 3) % 1) * 34;
      _drop(canvas, 151 + drop * 24, y, _blue);
    }
    _line(canvas, 89, 84, 89, 52, _coral, 3);
    _line(canvas, 89, 52, 120, 52, _coral, 3);
    _text(canvas, 'WARM → RISE → COOL', 180, 119, 11, _ink);
  }

  void _shadow(Canvas canvas) {
    _circle(canvas, 75, 38, 21, _yellow);
    _line(canvas, 93, 53, 146, 80, _yellow, 3);
    _line(canvas, 95, 45, 148, 65, _yellow, 3);
    _box(canvas, 165, 43, 40, 49, _coral);
    final shadowWidth = 74 + math.sin(phase * math.pi * 2) * 17;
    final shadow = Path()..moveTo(205, 91)..lineTo(205 + shadowWidth, 109)..lineTo(205, 109)..close();
    canvas.drawPath(shadow, Paint()..color = _ink.withValues(alpha: 0.23));
    _line(canvas, 30, 111, 329, 111, _green, 4);
    _text(canvas, 'LIGHT TRAVELS STRAIGHT', 180, 120, 10, _ink);
  }

  void _sound(Canvas canvas) {
    _box(canvas, 43, 49, 54, 46, _coral);
    final amplitude = 10 + math.sin(phase * math.pi * 2).abs() * 8;
    for (var wave = 0; wave < 3; wave++) {
      final rect = Rect.fromCenter(center: Offset(108 + wave * 13, 72), width: amplitude + wave * 17, height: 42 + wave * 16);
      canvas.drawArc(rect, -math.pi / 3, math.pi / 1.5, false, Paint()..color = _blue..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);
    }
    _line(canvas, 212, 73, 311, 73, _ink, 2);
    for (var bead = 0; bead < 5; bead++) {
      final x = 218.0 + bead * 21;
      final y = 73 + math.sin(phase * math.pi * 2 + bead * 0.8) * 15;
      _circle(canvas, x, y, 5, bead.isEven ? _yellow : _green);
    }
    _text(canvas, 'VIBRATION MAKES SOUND', 263, 112, 10, _ink);
  }

  void _force(Canvas canvas) {
    _line(canvas, 41, 98, 319, 98, _green, 4);
    _circle(canvas, 178 + math.sin(phase * math.pi * 2) * 20, 77, 21, _yellow);
    _line(canvas, 93, 76, 144, 76, _coral, 6);
    _arrowHead(canvas, 144, 76, 0, _coral);
    _line(canvas, 264, 76, 216, 76, _blue, 6);
    _arrowHead(canvas, 216, 76, math.pi, _blue);
    _text(canvas, 'PUSH', 114, 53, 11, _ink);
    _text(canvas, 'PULL', 240, 53, 11, _ink);
  }

  void _habitat(Canvas canvas) {
    _circle(canvas, 285, 33, 17, _yellow);
    _line(canvas, 178, 103, 178, 54, _coral, 8);
    _circle(canvas, 178, 49, 29, _green);
    _circle(canvas, 155, 61, 20, _green.withValues(alpha: 0.8));
    _circle(canvas, 201, 60, 20, _green.withValues(alpha: 0.8));
    _box(canvas, 23, 91, 104, 23, _blue.withValues(alpha: 0.55));
    _circle(canvas, 76, 78, 7, _coral);
    _line(canvas, 75, 83, 75, 91, _ink, 2);
    _line(canvas, 70, 87, 62, 82, _ink, 2);
    _line(canvas, 80, 87, 88, 82, _ink, 2);
    _line(canvas, 30, 116, 330, 116, _green, 4);
    _text(canvas, 'FOOD · WATER · SHELTER', 255, 108, 10, _ink);
  }

  void _circle(Canvas canvas, double x, double y, double radius, Color color) => canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
  void _box(Canvas canvas, double x, double y, double width, double height, Color color) {
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, width, height), const Radius.circular(8)), Paint()..color = color);
  }

  void _line(Canvas canvas, double x1, double y1, double x2, double y2, Color color, double width) =>
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), Paint()..color = color..strokeWidth = width..strokeCap = StrokeCap.round);

  void _text(Canvas canvas, String value, double centerX, double centerY, double size, Color color) {
    final painter = TextPainter(text: TextSpan(text: value, style: TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: color)), textDirection: TextDirection.ltr)..layout();
    painter.paint(canvas, Offset(centerX - painter.width / 2, centerY - painter.height / 2));
  }

  void _leaf(Canvas canvas, double x, double y, int direction) {
    final leaf = Path()
      ..moveTo(x, y)
      ..quadraticBezierTo(x + direction * 25, y - 22, x + direction * 30, y - 4)
      ..quadraticBezierTo(x + direction * 19, y + 8, x, y)
      ..close();
    canvas.drawPath(leaf, Paint()..color = _green);
  }

  void _cloud(Canvas canvas, double x, double y) {
    _circle(canvas, x - 17, y + 6, 15, Colors.white);
    _circle(canvas, x, y, 21, Colors.white);
    _circle(canvas, x + 19, y + 7, 14, Colors.white);
  }

  void _drop(Canvas canvas, double x, double y, Color color) {
    final path = Path()..moveTo(x, y - 7)..quadraticBezierTo(x - 9, y + 4, x, y + 8)..quadraticBezierTo(x + 9, y + 4, x, y - 7)..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _arrowHead(Canvas canvas, double x, double y, double angle, Color color) {
    final tip = Offset(x, y);
    final first = Offset(x - math.cos(angle - 0.55) * 13, y - math.sin(angle - 0.55) * 13);
    final second = Offset(x - math.cos(angle + 0.55) * 13, y - math.sin(angle + 0.55) * 13);
    canvas.drawPath(Path()..moveTo(tip.dx, tip.dy)..lineTo(first.dx, first.dy)..lineTo(second.dx, second.dy)..close(), Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ScienceConceptPainter oldDelegate) => oldDelegate.phase != phase || oldDelegate.index != index;
}
