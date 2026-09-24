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
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: AspectRatio(
            aspectRatio: _designWidth / _designHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                return Stack(
                  children: [
                    // 1. FONDO
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/instrucciones/fondo_instrucciones.png',
                        fit: BoxFit.fill,
                      ),
                    ),

                    // 2. TÍTULO MÁS PEQUEÑO, MÁS ARRIBA Y CON BRILLO
                    Positioned(
                      top: h * 0.02, // Más arriba (antes 0.05)
                      left: w * 0.12, // Más pequeño (antes 0.05)
                      right: w * 0.12,
                      child: Image.asset(
                        'assets/images/instrucciones/titulo_instrucciones.png',
                        fit: BoxFit.contain,
                      )
                      .animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                      .animate(onPlay: (c) => c.repeat())
                      .shimmer(delay: 3.seconds, duration: 1500.ms, color: Colors.white54),
                    ),

                    // 3. ÍCONOS: MÁS ARRIBA, ENTRADA LENTA Y BRILLO EN CASCADA
                    // Se subió "y" a 0.29. delayIn es para la entrada, shimmerStart para la cascada.
                    _IconoAnimado(img: 'brujula', x: 0.065, y: 0.29, w: w, h: h, delayIn: 300, shimmerStart: 0),
                    _IconoAnimado(img: 'lupa', x: 0.295, y: 0.29, w: w, h: h, delayIn: 700, shimmerStart: 1500),
                    _IconoAnimado(img: 'diamante', x: 0.525, y: 0.29, w: w, h: h, delayIn: 1100, shimmerStart: 3000),
                    _IconoAnimado(img: 'hoja', x: 0.755, y: 0.29, w: w, h: h, delayIn: 1500, shimmerStart: 4500),

                    // 4. BOTÓN "COMENZAR EXPEDICIÓN"
                    Positioned(
                      bottom: h * 0.045, 
                      left: w * 0.12,
                      right: w * 0.12,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => const TesorosMapaScreen(),
                            settings: const RouteSettings(name: 'tesoros_mapa'),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/instrucciones/boton_comenzar.png',
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

// Widget auxiliar rediseñado para sincronizar la ola de luz
class _IconoAnimado extends StatelessWidget {
  final String img;
  final double x;
  final double y;
  final double w;
  final double h;
  final int delayIn;
  final int shimmerStart;

  const _IconoAnimado({
    required this.img,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.delayIn,
    required this.shimmerStart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: w * x,
      top: h * y,
      width: w * 0.185, 
      height: w * 0.185,
      child: Image.asset(
        'assets/images/instrucciones/$img.png',
        fit: BoxFit.contain,
      )
      // 1. Entrada más lenta y relajada (1200ms)
      .animate()
      .scaleXY(begin: 0, end: 1, duration: 1200.ms, curve: Curves.elasticOut, delay: delayIn.ms)
      
      // 2. Ola de brillo (shimmer en cascada sincronizado a 6 segundos totales)
      .animate(onPlay: (c) => c.repeat())
      .shimmer(delay: shimmerStart.ms, duration: 1500.ms, color: Colors.white70)
      .then(delay: (4500 - shimmerStart).ms), 
    );
  }
}
