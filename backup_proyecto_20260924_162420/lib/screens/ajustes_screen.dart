import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ajustes_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/pantalla_header.dart';

class AjustesScreen extends ConsumerStatefulWidget {
  const AjustesScreen({super.key});
  @override
  ConsumerState<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends ConsumerState<AjustesScreen> {
  late TextEditingController _nombreController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _mostrarAcercaDe() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFF3E0),
        title: const Text('Acerca de', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF3E2712))),
        content: const Text(
          'Expedición Ambiental 2026\nUniversidad de Nariño\nGrupo de Investigación PIFIL 2026',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF3E2712), height: 1.5),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6FCB4B), shape: const StadiumBorder()),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CERRAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmarRestablecerProgreso() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFFFF3E0),
        title: const Text('¿Restablecer progreso?', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFE53935))),
        content: const Text(
          'Esto borrará tus hojas doradas, niveles desbloqueados, avatares y logros.\n\nEsta acción no se puede deshacer.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF3E2712), height: 1.4),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCELAR', style: TextStyle(color: Color(0xFF6B4423), fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE53935), shape: const StadiumBorder()),
            onPressed: () async {
              await resetearProgreso(ref);
              if (!mounted) return;
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Progreso restablecido', textAlign: TextAlign.center)),
              );
            },
            child: const Text('SÍ, RESTABLECER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ajustes = ref.watch(ajustesProvider);
    final nombreActual = ref.watch(playerNameProvider);

    // Sincronizar el TextField con el nombre real (solo la primera vez)
    if (_nombreController.text.isEmpty && nombreActual.isNotEmpty) {
      _nombreController.text = nombreActual;
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Ajustes'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF6B4423), width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Volumen', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF3E2712))),
                          Row(
                            children: [
                              Icon(ajustes.silenciado ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: const Color(0xFF6B4423)),
                              Expanded(
                                child: Slider(
                                  value: ajustes.volumen,
                                  onChanged: ajustes.silenciado ? null : (v) => ref.read(ajustesProvider.notifier).cambiarVolumen(v),
                                  activeColor: const Color(0xFF6FCB4B),
                                  inactiveColor: const Color(0xFFE0D2BC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Silenciar sonido', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF3E2712))),
                              Switch(
                                value: ajustes.silenciado,
                                activeColor: const Color(0xFF6FCB4B),
                                onChanged: (v) => ref.read(ajustesProvider.notifier).alternarSilencio(v),
                              ),
                            ],
                          ),
                          const Divider(height: 30, color: Color(0xFFDBC1A0)),
                          const Text('Nombre del jugador', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF3E2712))),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _nombreController,
                                  maxLength: 18,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    counterText: '',
                                    hintText: 'Tu nombre',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF9C6A3A))),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6FCB4B), shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
                                onPressed: () {
                                  final nuevo = _nombreController.text.trim();
                                  ref.read(playerNameProvider.notifier).state = nuevo.isEmpty ? 'Aventurero' : nuevo;
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nombre guardado', textAlign: TextAlign.center)));
                                },
                                child: const Text('GUARDAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          const Divider(height: 30, color: Color(0xFFDBC1A0)),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF6B4423), width: 1.5),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _mostrarAcercaDe,
                              icon: const Icon(Icons.info_outline_rounded, color: Color(0xFF6B4423)),
                              label: const Text('ACERCA DE', style: TextStyle(color: Color(0xFF6B4423), fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFE53935), width: 1.5),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _confirmarRestablecerProgreso,
                              icon: const Icon(Icons.restart_alt_rounded, color: Color(0xFFE53935)),
                              label: const Text('RESTABLECER PROGRESO', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
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