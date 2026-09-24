import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/logro.dart';
import '../providers/logros_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/pantalla_header.dart';

class LogrosScreen extends ConsumerStatefulWidget {
  const LogrosScreen({super.key});
  @override
  ConsumerState<LogrosScreen> createState() => _LogrosScreenState();
}

class _LogrosScreenState extends ConsumerState<LogrosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final monedasActuales = ref.read(coinsProvider);
      ref
          .read(logrosProvider.notifier)
          .actualizarMonedasActuales(monedasActuales);
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(logrosProvider);
    final desbloqueados = stats.calcularDesbloqueados();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Logros'),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.78),
                    itemCount: listaDeLogros.length,
                    itemBuilder: (context, index) {
                      final logro = listaDeLogros[index];
                      final desbloqueado = desbloqueados.contains(logro.id);
                      final progresoActual = _valorActual(logro.tipo, stats);
                      final progreso = logro.tipo == TipoMetrica.meta
                          ? (desbloqueado
                              ? 1.0
                              : desbloqueados.length /
                                  (listaDeLogros.length - 1))
                          : (progresoActual / logro.meta).clamp(0.0, 1.0);

                      return _LogroCard(
                              logro: logro,
                              desbloqueado: desbloqueado,
                              progreso: progreso.toDouble(),
                              progresoActual: progresoActual)
                          .animate(delay: (60 * index).ms)
                          .fadeIn(duration: 300.ms)
                          .moveY(begin: 12, end: 0);
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

  int _valorActual(TipoMetrica tipo, LogrosStats stats) {
    switch (tipo) {
      case TipoMetrica.residuos:
        return stats.residuosAcertadosTotal;
      case TipoMetrica.preguntas:
        return stats.preguntasCorrectasTotal;
      case TipoMetrica.monedas:
        return stats.monedasMaximas;
      case TipoMetrica.victoriasLombricarrera:
        return stats.victoriasLombricarrera;
      case TipoMetrica.meta:
        return 0;
    }
  }
}

class _LogroCard extends StatelessWidget {
  final Logro logro;
  final bool desbloqueado;
  final double progreso;
  final int progresoActual;
  const _LogroCard(
      {required this.logro,
      required this.desbloqueado,
      required this.progreso,
      required this.progresoActual});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: desbloqueado
                ? const Color(0xFFFFB300)
                : const Color(0xFF9C6A3A),
            width: 2.4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: desbloqueado
                ? Image.asset(logro.imagen, fit: BoxFit.contain)
                : Opacity(
                    opacity: 0.55,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]),
                      child: Image.asset(logro.imagen, fit: BoxFit.contain),
                    ),
                  ),
          ),
          const SizedBox(height: 4),
          Text(logro.titulo,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3E2712))),
          const SizedBox(height: 4),
          if (!desbloqueado) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                  value: progreso,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE0D2BC),
                  color: const Color(0xFF6FCB4B)),
            ),
            const SizedBox(height: 2),
            Text(
              logro.tipo == TipoMetrica.meta
                  ? 'Desbloquea los demÃ¡s'
                  : '$progresoActual / ${logro.meta}',
              style: const TextStyle(
                  fontSize: 9.5,
                  color: Color(0xFF6B4423),
                  fontWeight: FontWeight.w600),
            ),
          ] else
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF4CAF50), size: 20),
        ],
      ),
    );
  }
}

