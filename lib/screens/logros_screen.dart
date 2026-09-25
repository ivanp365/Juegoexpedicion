import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/logro.dart';
import '../providers/logros_provider.dart';
import '../providers/game_provider.dart';
import '../widgets/pantalla_header.dart';
import '../widgets/bgm_scope.dart';
import '../providers/audio_manager.dart';

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

    return BgmScope(mode: BgmMode.menu, child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.webp', fit: BoxFit.cover),
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

                      return GestureDetector(
                        onTap: () => _mostrarDetalleLogro(
                          context,
                          logro,
                          desbloqueado,
                          progresoActual,
                          progreso.toDouble(),
                        ),
                        child: _LogroCard(
                                logro: logro,
                                desbloqueado: desbloqueado,
                                progreso: progreso.toDouble(),
                                progresoActual: progresoActual)
                            .animate(delay: (60 * index).ms)
                            .fadeIn(duration: 300.ms)
                            .moveY(begin: 12, end: 0),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
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

void _mostrarDetalleLogro(
  BuildContext context,
  Logro logro,
  bool desbloqueado,
  int progresoActual,
  double progreso,
) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFF3E0),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF9C6A3A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: desbloqueado
                ? Image.asset(logro.imagen, fit: BoxFit.contain)
                : Opacity(
                    opacity: 0.55,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                      child: Image.asset(logro.imagen, fit: BoxFit.contain),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Text(
            logro.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3E2712),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: desbloqueado
                  ? const Color(0xFF6FCB4B).withValues(alpha: 0.25)
                  : const Color(0xFF9C6A3A).withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: desbloqueado
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF9C6A3A),
                width: 1.5,
              ),
            ),
            child: Text(
              desbloqueado ? 'Desbloqueado' : 'Bloqueado',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: desbloqueado
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF6B4423),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '¿Cómo conseguirlo?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3E2712),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            logro.descripcion,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B4423),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (!desbloqueado && logro.tipo != TipoMetrica.meta) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progreso.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: const Color(0xFFE0D2BC),
                color: const Color(0xFF6FCB4B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$progresoActual / ${logro.meta}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6B4423),
              ),
            ),
          ] else if (desbloqueado) ...[
            const Icon(Icons.verified_rounded,
                color: Color(0xFF4CAF50), size: 40),
            const SizedBox(height: 4),
            const Text(
              'Ya lo tienes!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2E7D32),
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C6A3A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Entendido',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    ),
  );
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
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0, 0, 0, 1, 0,
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
                  ? 'Desbloquea los demas'
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