import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tesoros_mapa_screen.dart';

class TesorosIntroScreen extends StatelessWidget {
  const TesorosIntroScreen({super.key});

  static const double _designWidth = 1000;
  static const double _designHeight = 1575;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: _designWidth,
            height: _designHeight,
            child: Builder(
              builder: (context) {
                const w = _designWidth;
                const h = _designHeight;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/instrucciones/fondo_instrucciones.webp',
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: h * 0.03, 
                      left: w * 0.12, 
                      right: w * 0.12,
                      child: Image.asset(
                        'assets/images/instrucciones/titulo_instrucciones.webp',
                        fit: BoxFit.contain,
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(delay: 3.seconds, duration: 1500.ms, color: Colors.white54),
                    ),
                    
                    // ÍCONOS - Bajamos la coordenada 'y' de 0.275 a 0.285
                    _IconoAnimado(img: 'brujula', x: 0.052, y: 0.285, w: w, h: h, delayIn: 300, shimmerStart: 0),
                    _IconoAnimado(img: 'lupa', x: 0.288, y: 0.285, w: w, h: h, delayIn: 700, shimmerStart: 1500),
                    _IconoAnimado(img: 'diamante', x: 0.528, y: 0.285, w: w, h: h, delayIn: 1100, shimmerStart: 3000),
                    _IconoAnimado(img: 'hoja', x: 0.760, y: 0.285, w: w, h: h, delayIn: 1500, shimmerStart: 4500),
                    
                    Positioned(
                      bottom: h * 0.06, 
                      left: w * 0.15,
                      right: w * 0.15,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const TesorosMapaScreen(),
                            settings: const RouteSettings(name: 'tesoros_mapa'),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/instrucciones/boton_comenzar.webp',
                          fit: BoxFit.contain,
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scaleXY(begin: 1.0, end: 1.06, duration: 900.ms, curve: Curves.easeInOut),
                      )
                      .animate()
                      .slideY(begin: 1.5, end: 0.0, duration: 800.ms, curve: Curves.easeOutBack),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _IconoAnimado extends StatelessWidget {
  final String img;
  final double x;
  final double y;
  final double w;
  final double h;
  final int delayIn;
  final int shimmerStart;

  const _IconoAnimado({
    required this.img, required this.x, required this.y,
    required this.w, required this.h, required this.delayIn, required this.shimmerStart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: w * x, top: h * y, 
      width: w * 0.19, height: w * 0.19,
      child: Image.asset('assets/images/instrucciones/$img.webp', fit: BoxFit.contain)
      .animate()
      .scaleXY(begin: 0, end: 1, duration: 1200.ms, curve: Curves.elasticOut, delay: delayIn.ms)
      .animate(onPlay: (c) => c.repeat())
      .shimmer(delay: shimmerStart.ms, duration: 1500.ms, color: Colors.white70)
      .then(delay: (4500 - shimmerStart).ms), 
    );
  }
}