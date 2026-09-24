import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../providers/tesoros_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../models/tesoro_model.dart';
import '../../providers/game_provider.dart';
import '../../widgets/tesoros_theme.dart';
import '../../widgets/tesoros_widgets.dart';

class TesorosFinalizacionScreen extends ConsumerStatefulWidget {
  const TesorosFinalizacionScreen({super.key});
  @override ConsumerState<TesorosFinalizacionScreen> createState() => _TesorosFinalizacionScreenState();
}
class _TesorosFinalizacionScreenState extends ConsumerState<TesorosFinalizacionScreen> {
  late final ConfettiController _confettiController;
  @override void initState() { super.initState(); _confettiController = ConfettiController(duration: const Duration(seconds: 2))..play(); }
  @override void dispose() { _confettiController.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final coins = ref.watch(coinsProvider);
    final progresoCategorias = ref.watch(progresoPorCategoriaProvider);
    final nivel = ref.watch(nivelJuegoProvider);
    final totalMisiones = misionesDeNivel(nivel).length;
    return Scaffold(
      backgroundColor: TC.woodDeep,
      body: SafeArea(child: Stack(alignment: Alignment.topCenter, children: [Align(alignment: Alignment.topCenter, child: ConfettiWidget(confettiController: _confettiController, blastDirection: math.pi / 2, emissionFrequency: 0.06, numberOfParticles: 18, maxBlastForce: 18, minBlastForce: 8, gravity: 0.25, colors: const [TC.goldBright, TC.leaf, TC.gold, Colors.white])), Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Text('¡EXPEDICIÓN COMPLETADA!', textAlign: TextAlign.center, style: TextStyle(color: TC.cream, fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 8), Text('Has descubierto los $totalMisiones tesoros de Morasurco.', textAlign: TextAlign.center, style: const TextStyle(color: TC.creamDark)), const SizedBox(height: 24), WoodPanel(child: Column(children: [for (final c in CategoriaEcosistemica.values) Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Icon(c.iconoCategoria, color: c.color, size: 18), const SizedBox(width: 8), Expanded(child: Text(c.nombre, style: const TextStyle(color: TC.cream))), Text('${progresoCategorias[c]}/${misionesDeNivel(nivel).where((m) => m.categoria == c).length}', style: const TextStyle(color: TC.goldBright, fontWeight: FontWeight.w900))])), const Divider(color: TC.woodShadow, height: 20), Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [const Icon(Icons.eco_rounded, color: TC.goldBright, size: 16), const SizedBox(width: 8), Text('$coins monedas acumuladas', style: const TextStyle(color: TC.cream, fontSize: 13))])), Text('$totalMisiones/$totalMisiones tesoros', style: const TextStyle(color: TC.cream, fontSize: 13))])), const SizedBox(height: 28), ElevatedButton(onPressed: () => Navigator.of(context).popUntil((r) => r.settings.name == 'tesoros_mapa' || r.isFirst), style: ElevatedButton.styleFrom(backgroundColor: TC.leaf, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('VOLVER AL MAPA', style: TextStyle(fontWeight: FontWeight.w900)))]))])),
    );
  }
}

