import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/tesoro_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import '../../providers/audio_manager.dart';
import '../../widgets/bgm_scope.dart';
import 'tesoros_intro_screen.dart';

class TesorosNivelScreen extends ConsumerStatefulWidget {
  const TesorosNivelScreen({super.key});

  @override
  ConsumerState<TesorosNivelScreen> createState() => _TesorosNivelScreenState();
}

class _TesorosNivelScreenState extends ConsumerState<TesorosNivelScreen> {
  @override
  Widget build(BuildContext context) {
    return BgmScope(mode: BgmMode.home, child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondo_clasificacion.webp', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                const _TopBar(),
                const Spacer(flex: 1),
                
                Image.asset('assets/images/letreroseleccionatunivel.webp', height: 110, fit: BoxFit.contain)
                    .animate().scaleXY(begin: 0.5, end: 1.0, duration: 600.ms, curve: Curves.easeOutBack)
                    .shimmer(delay: 2.seconds),
                
                const Spacer(flex: 1),
                
                _LevelCard(level: 1, image: 'assets/images/cardnivel1clasificacion.webp', cost: 0),
                const SizedBox(height: 25),
                _LevelCard(level: 2, image: 'assets/images/cardnivel2clasificacion.webp', cost: 500),
                
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    ));
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
            onTap: () {
              AudioManager.playSfx('button_back.wav');
              Navigator.of(context).maybePop();
            },
            child: Image.asset('assets/images/botonatras.webp', width: 65, height: 65)
                .animate().scaleXY(begin: 0.8, end: 1.0, duration: 400.ms),
          ),
          Container(
            height: 48, width: 140,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/coin_bg.webp'), fit: BoxFit.contain)
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

class _LevelCard extends ConsumerStatefulWidget {
  final int level;
  final String image;
  final int cost;
  
  const _LevelCard({required this.level, required this.image, required this.cost});
  @override
  ConsumerState<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends ConsumerState<_LevelCard> {
  bool _isPressed = false;
  
  @override
  Widget build(BuildContext context) {
    final unlockedLevels = ref.watch(unlockedTesorosLevelsProvider);
    final coins = ref.watch(coinsProvider);
    final isUnlocked = unlockedLevels.contains(widget.level);

    void handleTap() {
      if (isUnlocked) {
        AudioManager.playSfx('button_click.wav');
        ref.read(nivelJuegoProvider.notifier).state = widget.level == 1 ? NivelJuego.primaria : NivelJuego.secundaria;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const TesorosIntroScreen()
        ));
      } else {
        if (coins >= widget.cost) {
          AudioManager.playSfx('coin.wav');
          ref.read(coinsProvider.notifier).state = coins - widget.cost;
          ref.read(unlockedTesorosLevelsProvider.notifier).state = [...unlockedLevels, widget.level];
        } else {
          AudioManager.playSfx('button_back.wav');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No tienes suficientes hojas doradas'))
          );
        }
      }
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: handleTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(widget.image, fit: BoxFit.contain)
                  .animate().slideX(begin: widget.level == 1 ? -0.2 : 0.2, end: 0).fadeIn(),
              
              if (!isUnlocked)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5), 
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/candado.webp', width: 50)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(end: 1.1),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black87, 
                            borderRadius: BorderRadius.circular(15), 
                            border: Border.all(color: Colors.amber, width: 2)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text('${widget.cost}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}