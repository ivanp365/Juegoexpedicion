import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import 'lombricarrera_nivel_screen.dart';

class LombricarreraModoScreen extends ConsumerWidget {
  const LombricarreraModoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondo_clasificacion.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const _TopBar(),
                const Spacer(flex: 1),
                Image.asset('assets/images/lombricarrera/letreroseleccionamodo.png', height: 140, fit: BoxFit.contain)
                    .animate().scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack)
                    .shimmer(delay: 2.seconds, duration: 1.seconds, color: Colors.white54),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: _ModeCard(
                          image: 'assets/images/lombricarrera/cardcontraotrojugador.png',
                          delay: 100,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const LombricarreraNivelScreen(modo: 'vsJugador'),
                            ));
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ModeCard(
                          image: 'assets/images/lombricarrera/cardcontralaia.png',
                          delay: 250,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const LombricarreraNivelScreen(modo: 'vsIA'),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
              ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Image.asset('assets/images/botonatras.png', width: 65, height: 65)
                .animate().scaleXY(begin: 0.8, end: 1.0, duration: 400.ms),
          ),
          Container(
            height: 48, width: 140,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/coin_bg.png'), fit: BoxFit.contain)
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 35),
            child: Text('$coins', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatefulWidget {
  final String image;
  final VoidCallback onTap;
  final int delay;
  const _ModeCard({required this.image, required this.onTap, this.delay = 0});
  @override
  State<_ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<_ModeCard> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Image.asset(widget.image, fit: BoxFit.contain)
            .animate(delay: widget.delay.ms)
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack),
      ),
    );
  }
}
