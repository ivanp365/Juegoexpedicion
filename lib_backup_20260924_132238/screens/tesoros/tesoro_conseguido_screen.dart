import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../../models/tesoro_model.dart';
import '../../providers/tesoros_provider.dart';
import '../../widgets/tesoros_theme.dart';
import 'tesoros_finalizacion_screen.dart';

class TesoroConseguidoScreen extends ConsumerStatefulWidget {
  const TesoroConseguidoScreen({super.key});

  @override
  ConsumerState<TesoroConseguidoScreen> createState() =>
      _TesoroConseguidoScreenState();
}

class _TesoroConseguidoScreenState
    extends ConsumerState<TesoroConseguidoScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti =
        ConfettiController(duration: const Duration(milliseconds: 1800));
    // Se dispara después del primer frame para que el confeti caiga sobre
    // una pantalla ya construida, no antes.
    WidgetsBinding.instance.addPostFrameCallback((_) => _confetti.play());
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mision = ref.watch(misionActualProvider);
    final vereda = ref.watch(veredaSeleccionadaProvider) ?? '';

    if (mision == null) return const SizedBox.shrink();
    final catColor = mision.categoria.color;

    return Scaffold(
      backgroundColor: TC.woodDeep,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Halo de luz cálida detrás de la tarjeta, para que no se sienta
          // un fondo plano de un solo color.
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.1,
                  colors: [TC.woodDeep.withValues(alpha: 0.0), TC.woodDeep],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 0.9,
                  colors: [
                    catColor.withValues(alpha: 0.18),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),

          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 26,
            emissionFrequency: 0.02,
            maxBlastForce: 22,
            minBlastForce: 9,
            gravity: 0.25,
            colors: [TC.goldBright, TC.leaf, catColor, Colors.white],
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),

                  Icon(Icons.emoji_events_rounded,
                          color: TC.goldBright, size: 34)
                      .animate()
                      .fadeIn(duration: 350.ms)
                      .scale(
                          begin: const Offset(0.4, 0.4),
                          curve: Curves.elasticOut,
                          duration: 600.ms),
                  const SizedBox(height: 8),
                  const Text(
                    '¡Tesoro conseguido!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TC.cream,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms)
                      .slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 28),

                  // Retrato del tesoro en un medallón dorado, con brillo.
                  Container(
                    width: 132,
                    height: 132,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TC.goldBright, const Color(0xFF8B5A2B)],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: TC.goldBright.withValues(alpha: 0.45),
                            blurRadius: 24,
                            spreadRadius: 2),
                      ],
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFFFF8EC)),
                      padding: const EdgeInsets.all(18),
                      child: Image.asset(
                        'assets/images/tesoros/${mision.recursoId}.png',
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => Icon(
                            mision.categoria.iconoCategoria,
                            color: catColor,
                            size: 48),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(
                      begin: const Offset(0.6, 0.6),
                      curve: Curves.elasticOut,
                      duration: 700.ms),

                  const SizedBox(height: 20),

                  Text(
                    mision.nombreTesoro,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: TC.cream,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ).animate().fadeIn(delay: 150.ms),

                  const SizedBox(height: 14),

                  // Chips: ubicación + categoría con su color real.
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Chip(
                          icon: Icons.location_on_rounded,
                          label: vereda,
                          color: TC.goldBright),
                      _Chip(
                          icon: mision.categoria.iconoCategoria,
                          label: mision.categoria.nombre,
                          color: catColor),
                    ],
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.10)),
                    ),
                    child: Text(
                      mision.descripcion,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: TC.creamDark, fontSize: 14, height: 1.5),
                    ),
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.08, end: 0),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: TC.goldBright.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: TC.goldBright.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.eco_rounded, color: TC.leaf, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          '+15 monedas',
                          style: TextStyle(
                              color: TC.leaf,
                              fontWeight: FontWeight.w900,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  )
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 300.ms)
                      .then()
                      .shimmer(
                          duration: 1200.ms,
                          color: Colors.white.withValues(alpha: 0.5)),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (ref.read(expedicionCompletadaProvider)) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) =>
                                    const TesorosFinalizacionScreen()),
                            (route) => route.isFirst,
                          );
                        } else {
                          Navigator.of(context).popUntil((route) =>
                              route.settings.name == 'tesoros_mapa' ||
                              route.isFirst);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TC.leaf,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 6,
                        shadowColor: TC.leaf.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.explore_rounded, size: 20),
                          SizedBox(width: 10),
                          Text('CONTINUAR EXPLORANDO',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Chip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}
