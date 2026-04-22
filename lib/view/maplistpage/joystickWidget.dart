import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String kFlaskBaseUrl = 'http://192.168.1.199:5000';

class RobotJoystick extends StatefulWidget {
  const RobotJoystick({super.key});

  @override
  State<RobotJoystick> createState() => _RobotJoystickState();
}

class _RobotJoystickState extends State<RobotJoystick> {
  static const double _baseRadius = 90.0;
  static const double _knobRadius = 36.0;

  Offset _knobOffset = Offset.zero;
  bool _isDragging = false;
  bool _isSending = false;

  /// Sends Android-style payload.
  /// horizontal : -1.0 (left)  → +1.0 (right)
  /// vertical   : -1.0 (back)  → +1.0 (forward)
  ///
  /// Backend mapping (unchanged):
  ///   linear_x  = vertical  * 0.25
  ///   angular_z = -horizontal * 0.9
  Future<void> _sendCmd(double horizontal, double vertical) async {
    if (_isSending) return;
    _isSending = true;
    try {
      await http
          .post(
        Uri.parse('$kFlaskBaseUrl/joystick_cmd'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'horizontal': horizontal,
          'vertical': vertical,
        }),
      )
          .timeout(const Duration(milliseconds: 300));
    } catch (_) {}
    _isSending = false;
  }

  void _onDrag(Offset localPos) {
    final center = Offset(_baseRadius, _baseRadius);

    final delta = localPos - center;
    final dist = delta.distance;
    final clamped = dist > _baseRadius ? delta / dist * _baseRadius : delta;

    setState(() => _knobOffset = clamped);

    // Map pixel offset → [-1, 1] range
    //   dx positive = right  → horizontal positive
    //   dy positive = down   → vertical NEGATIVE (screen Y is inverted)
    final horizontal = clamped.dx / _baseRadius;   // right = +1
    final vertical   = -clamped.dy / _baseRadius;  // up    = +1  (forward)

    _sendCmd(horizontal, vertical);
    print("horizontal== $horizontal , vertical== $vertical");
    HapticFeedback.selectionClick();
  }

  void _onRelease() {
    setState(() {
      _knobOffset = Offset.zero;
      _isDragging = false;
    });
    _sendCmd(0.0, 0.0); // stop the robot
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final size = _baseRadius * 2;

    return GestureDetector(
      onPanStart: (d) {
        setState(() => _isDragging = true);
        _onDrag(d.localPosition);
      },
      onPanUpdate: (d) => _onDrag(d.localPosition),
      onPanEnd: (_) => _onRelease(),
      onPanCancel: _onRelease,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Glow ring
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F5D4)
                        .withOpacity(_isDragging ? 0.4 : 0.15),
                    blurRadius: _isDragging ? 40 : 20,
                    spreadRadius: _isDragging ? 6 : 2,
                  ),
                ],
              ),
            ),

            // Base plate
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFF1E2640), Color(0xFF0D1220)],
                  stops: [0.4, 1.0],
                ),
                border: Border.all(
                  color: const Color(0xFF00F5D4).withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: CustomPaint(painter: _CrosshairPainter()),
            ),

            // Knob — springs back when released
            Positioned(
              left: _baseRadius + _knobOffset.dx - _knobRadius,
              top:  _baseRadius + _knobOffset.dy - _knobRadius,
              child: AnimatedContainer(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 220),
                curve: Curves.elasticOut,
                width:  _knobRadius * 2,
                height: _knobRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: const Alignment(-0.3, -0.3),
                    colors: _isDragging
                        ? [const Color(0xFF00F5D4), const Color(0xFF00897B)]
                        : [const Color(0xFF2EE8CC), const Color(0xFF00897B)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00F5D4)
                          .withOpacity(_isDragging ? 0.7 : 0.4),
                      blurRadius: _isDragging ? 24 : 12,
                      spreadRadius: _isDragging ? 4 : 1,
                    ),
                    const BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width:  _knobRadius * 0.55,
                    height: _knobRadius * 0.55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.25),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00F5D4).withOpacity(0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawLine(Offset(12, cy), Offset(size.width - 12, cy), paint);
    canvas.drawLine(Offset(cx, 12), Offset(cx, size.height - 12), paint);

    for (final r in [size.width * 0.25, size.width * 0.40]) {
      canvas.drawCircle(Offset(cx, cy), r, paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
