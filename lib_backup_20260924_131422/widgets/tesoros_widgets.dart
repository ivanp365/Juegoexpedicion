import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'tesoros_theme.dart';

class WoodPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool destacado;
  const WoodPanel({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.destacado = false});
  @override Widget build(BuildContext context) => Container(padding: padding, decoration: TC.woodPanel(destacado: destacado), child: child);
}

class GemaWidget extends StatelessWidget {
  final double size;
  final Color color;
  final bool bloqueada;
  const GemaWidget({super.key, this.size = 64, this.color = TC.goldBright, this.bloqueada = false});
  @override Widget build(BuildContext context) {
    if (bloqueada) return Container(width: size, height: size, decoration: BoxDecoration(color: TC.woodShadow, shape: BoxShape.circle, border: Border.all(color: TC.woodDeep, width: 2)), child: Icon(Icons.lock_rounded, color: TC.creamDark.withValues(alpha: 0.5), size: size * 0.4));
    return CustomPaint(size: Size(size, size), painter: _GemaPainter(color: color));
  }
}

class _GemaPainter extends CustomPainter {
  final Color color;
  _GemaPainter({required this.color});
  @override void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()..moveTo(w * 0.5, 0)..lineTo(w, h * 0.38)..lineTo(w * 0.5, h)..lineTo(0, h * 0.38)..close();
    final paint = Paint()..shader = LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.9), color, color.withValues(alpha: 0.7)], stops: const [0.0, 0.5, 1.0]).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(path, paint);
    canvas.drawPath(path, Paint()..color = TC.woodShadow..style = PaintingStyle.stroke..strokeWidth = 2.5);
    canvas.drawPath(Path()..moveTo(w * 0.5, h * 0.08)..lineTo(w * 0.62, h * 0.38)..lineTo(w * 0.5, h * 0.3)..close(), Paint()..color = Colors.white.withValues(alpha: 0.55));
  }
  @override bool shouldRepaint(covariant _GemaPainter oldDelegate) => oldDelegate.color != color;
}

class Hoja extends StatelessWidget {
  final double size, rot;
  final bool flip;
  const Hoja({super.key, required this.size, this.rot = 0, this.flip = false});
  @override Widget build(BuildContext context) => Transform.rotate(angle: rot, child: Transform.scale(scaleX: flip ? -1 : 1, child: Container(width: size, height: size * 0.62, decoration: BoxDecoration(gradient: const LinearGradient(colors: [TC.leaf, TC.leafDark, TC.leafDeep], stops: [0.0, 0.6, 1.0]), borderRadius: BorderRadius.only(topLeft: Radius.circular(size * 0.6), bottomRight: Radius.circular(size * 0.6), topRight: Radius.circular(size * 0.15), bottomLeft: Radius.circular(size * 0.15)), boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 3, offset: Offset(1, 2))]))));
}

class MascotaBubble extends StatelessWidget {
  final String texto, pose;
  const MascotaBubble({super.key, required this.texto, this.pose = 'senalando'});
  @override Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const RadialGradient(colors: [TC.goldBright, TC.gold, TC.goldDeep]), border: Border.all(color: TC.woodShadow, width: 2.5)), clipBehavior: Clip.antiAlias, child: Icon(Icons.hiking_rounded, color: TC.woodDeep, size: 22)), const SizedBox(width: 10), Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10), decoration: BoxDecoration(color: TC.cream, borderRadius: BorderRadius.circular(16), border: Border.all(color: TC.woodShadow, width: 2)), child: Text(texto, style: const TextStyle(color: TC.woodDeep, fontSize: 13, fontStyle: FontStyle.italic))))]);
}

class TerrenoPlaceholder extends StatelessWidget {
  const TerrenoPlaceholder({super.key});
  @override Widget build(BuildContext context) => CustomPaint(painter: _ColinasPainter(), child: Container());
}

class _ColinasPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF8BCFF0), Color(0xFFBFE6C8)]).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
    _colina(canvas, size, alturaBase: 0.55, amplitud: 40, color: TC.leafDark.withValues(alpha: 0.55));
    _colina(canvas, size, alturaBase: 0.7, amplitud: 55, color: TC.leaf);
    final path = Path()..moveTo(size.width * 0.2, size.height)..quadraticBezierTo(size.width * 0.5, size.height * 0.75, size.width * 0.85, size.height * 0.55);
    canvas.drawPath(path, Paint()..color = TC.regulacion..strokeWidth = 14..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }
  void _colina(Canvas canvas, Size size, {required double alturaBase, required double amplitud, required Color color}) {
    final path = Path()..moveTo(0, size.height)..lineTo(0, size.height * alturaBase);
    for (double x = 0; x <= size.width; x += size.width / 6) path.lineTo(x, size.height * alturaBase + amplitud * math.sin(x / size.width * math.pi * 2));
    path..lineTo(size.width, size.height)..close();
    canvas.drawPath(path, Paint()..color = color);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
