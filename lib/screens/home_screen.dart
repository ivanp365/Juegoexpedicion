import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../widgets/bottom_menu_bar.dart';
import 'clasificacion_screen.dart';
import 'lombricarrera_modo_screen.dart';
import 'tesoros/tesoros_nivel_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                children: [
                  const _TopBar(),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 8,
                    child: Image.asset(
                            'assets/images/letreroexpedicionambiental.png',
                            fit: BoxFit.contain)
                        .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .moveY(
                            begin: -6,
                            end: 6,
                            duration: 2500.ms,
                            curve: Curves.easeInOutSine),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 11,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _GameCard(
                          image: 'assets/images/cardclasificacion.png',
                          delay: 0,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const ClasificacionScreen()),
                            );
                          },
                        ),
                        _GameCard(
                          image: 'assets/images/cardlombricarrera1.png',
                          delay: 150,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const LombricarreraModoScreen()),
                            );
                          },
                        ),
                        _GameCard(
                          image: 'assets/images/cardtesorosambientales.png',
                          delay: 300,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const TesorosNivelScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                  const BottomMenuBar(juegoActual: ContextoJuego.home),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(coinsProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 48,
          width: 140,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/coin_bg.png'),
              fit: BoxFit.contain,
            ),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 35),
          child: Text(
            '$coins',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ],
    );
  }
}

class _GameCard extends StatefulWidget {
  final String image;
  final int delay;
  final VoidCallback onTap;

  const _GameCard(
      {required this.image, required this.delay, required this.onTap});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Image.asset(widget.image, fit: BoxFit.contain)
                .animate()
                .fadeIn(delay: widget.delay.ms, duration: 600.ms)
                .slideY(
                    begin: 0.15,
                    end: 0,
                    delay: widget.delay.ms,
                    curve: Curves.easeOutBack),
          ),
        ),
      ),
    );
  }
}


