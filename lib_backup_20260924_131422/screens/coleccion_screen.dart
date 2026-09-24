import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/logro.dart';
import '../providers/logros_provider.dart';
import '../widgets/pantalla_header.dart';

class ColeccionScreen extends ConsumerWidget {
  const ColeccionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(logrosProvider);
    final desbloqueados = stats.calcularDesbloqueados();
    final logrosDesbloqueados =
        listaDeLogros.where((l) => desbloqueados.contains(l.id)).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Colección'),
                Expanded(
                  child: logrosDesbloqueados.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emoji_events_outlined,
                                    size: 64,
                                    color: Colors.white.withValues(alpha: 0.8)),
                                const SizedBox(height: 12),
                                const Text(
                                    'Aún no tienes insignias.\n¡Sigue jugando para desbloquearlas!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        shadows: [
                                          Shadow(
                                              color: Colors.black54,
                                              blurRadius: 4)
                                        ])),
                              ],
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.85),
                          itemCount: logrosDesbloqueados.length,
                          itemBuilder: (context, index) {
                            final logro = logrosDesbloqueados[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: const Color(0xFFFFB300), width: 2.4),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3))
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Image.asset(logro.imagen,
                                          fit: BoxFit.contain)),
                                  const SizedBox(height: 4),
                                  Text(logro.titulo,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF3E2712))),
                                ],
                              ),
                            ).animate(delay: (60 * index).ms).scale(
                                begin: const Offset(0.7, 0.7),
                                duration: 300.ms,
                                curve: Curves.easeOutBack);
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
