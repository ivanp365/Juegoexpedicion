import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../providers/logros_provider.dart';
import '../widgets/pantalla_header.dart';
import 'character_selection_screen.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monedas = ref.watch(coinsProvider);
    final stats = ref.watch(logrosProvider);
    final nombreJugador = ref.watch(playerNameProvider);
    final desbloqueados = stats.calcularDesbloqueados().length;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Mi Perfil'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 96, height: 96,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF6FCB4B), border: Border.all(color: Colors.white, width: 4), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))]),
                          padding: const EdgeInsets.all(8),
                          child: Container(decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF29ABE2)), child: Image.asset('assets/images/icono_perfil.png', fit: BoxFit.contain)),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          nombreJugador.trim().isEmpty ? 'Explorador Ambiental' : nombreJugador,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF6B4423), width: 3),
                          ),
                          child: Column(
                            children: [
                              _StatFila(icon: Icons.eco_rounded, color: const Color(0xFF4CAF50), label: 'Hojas doradas', valor: '$monedas'),
                              const Divider(height: 20, color: Color(0xFFDBC1A0)),
                              _StatFila(icon: Icons.delete_sweep_rounded, color: const Color(0xFF2196F3), label: 'Residuos clasificados', valor: '${stats.residuosAcertadosTotal}'),
                              const Divider(height: 20, color: Color(0xFFDBC1A0)),
                              _StatFila(icon: Icons.psychology_rounded, color: const Color(0xFF9C27B0), label: 'Preguntas acertadas', valor: '${stats.preguntasCorrectasTotal}'),
                              const Divider(height: 20, color: Color(0xFFDBC1A0)),
                              _StatFila(icon: Icons.emoji_events_rounded, color: const Color(0xFFFFB300), label: 'Logros desbloqueados', valor: '$desbloqueados / 9'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF29ABE2), padding: const EdgeInsets.symmetric(vertical: 14), shape: const StadiumBorder()),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CharacterSelectionScreen(esCambioAvatar: true)));
                            },
                            icon: const Icon(Icons.face_retouching_natural_rounded, color: Colors.white),
                            label: const Text('CAMBIAR DE AVATAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
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

class _StatFila extends StatelessWidget {
  final IconData icon; final Color color; final String label; final String valor;
  const _StatFila({required this.icon, required this.color, required this.label, required this.valor});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3E2712)))),
        Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}