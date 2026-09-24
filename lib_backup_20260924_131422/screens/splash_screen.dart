import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'character_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Le damos 4 segundos exactos para que la animación se luzca completa
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const CharacterSelectionScreen(),
          // Transición de desvanecimiento (Fade) entre el logo y el juego
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Usamos tu fondo de madera y bosque para mantener la temática
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          
          // Un filtro semitransparente muy sutil para oscurecer el fondo y hacer que el logo brille más
          Container(color: Colors.black.withOpacity(0.3)),
          
          Center(
            child: Image.asset(
              'assets/images/home_logo-Photoroom.png', // Tu logo real
              width: 320,
              fit: BoxFit.contain,
            )
            .animate()
            // 1. Entrada elástica (Efecto Boing) y rotación sutil
            .scaleXY(begin: 0.0, end: 1.0, duration: 1200.ms, curve: Curves.elasticOut)
            .rotate(begin: -0.05, end: 0.0, duration: 1000.ms, curve: Curves.easeOut)
            
            // 2. Destello de luz mágico atravesando el letrero
            .then(delay: 200.ms)
            .shimmer(duration: 900.ms, color: Colors.white.withOpacity(0.6), angle: 1.2)
            
            // 3. Efecto de respiración/latido simulando hojas vivas
            .then(delay: 300.ms)
            .scaleXY(end: 1.05, duration: 800.ms, curve: Curves.easeInOutSine)
            .then()
            .scaleXY(end: 1.0, duration: 800.ms, curve: Curves.easeInOutSine),
          ),
        ],
      ),
    );
  }
}
