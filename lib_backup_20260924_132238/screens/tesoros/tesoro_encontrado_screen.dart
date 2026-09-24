import 'package:flutter/material.dart';
import '../../models/tesoro_model.dart';
import '../../providers/tesoros_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/game_provider.dart';
import '../../widgets/tesoros_theme.dart';
import '../../widgets/tesoros_widgets.dart';
import 'tesoros_categoria_screen.dart';

class TesoroEncontradoScreen extends ConsumerWidget {
  const TesoroEncontradoScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final mision = ref.watch(misionActualProvider);
    if (mision == null) return const SizedBox.shrink();
    return Scaffold(
      backgroundColor: TC.woodDeep,
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [GemaWidget(size: 88, color: mision.categoria.color).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).then().shimmer(duration: 900.ms, color: Colors.white70), const SizedBox(height: 12), const Text('¡TESORO ENCONTRADO!', style: TextStyle(color: TC.cream, fontSize: 22, fontWeight: FontWeight.w900)), const SizedBox(height: 20), WoodPanel(destacado: true, child: Column(children: [Text('Has descubierto:', style: TextStyle(color: TC.woodDeep.withValues(alpha: 0.8), fontSize: 12)), const SizedBox(height: 6), Text(mision.nombreTesoro, textAlign: TextAlign.center, style: const TextStyle(color: TC.woodDeep, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 10), Text(mision.descripcion, textAlign: TextAlign.center, style: TextStyle(color: TC.woodDeep.withValues(alpha: 0.8), fontSize: 13))])), const SizedBox(height: 28), ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TesorosCategoriaScreen())), style: ElevatedButton.styleFrom(backgroundColor: TC.leaf, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))), child: const Text('DESCUBRIR SU SERVICIO', style: TextStyle(fontWeight: FontWeight.w900)))])),
      ),
    );
  }
}


