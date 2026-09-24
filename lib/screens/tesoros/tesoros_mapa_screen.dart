import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tesoro_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import '../../widgets/bottom_menu_bar.dart';
import '../../widgets/tesoros_theme.dart';
import 'tesoros_coleccion_screen.dart';
import 'tesoros_finalizacion_screen.dart';
import 'tesoros_mision_screen.dart';

const Map<String, String> veredaPines = {
  'San Juan Bajo': 'assets/images/pin_sanjuanbajo.png',
  'San Juan Alto': 'assets/images/pin_sanjuanalto.png',
  'La Joseña': 'assets/images/pin_lajosena.png',
  'Tosoabí': 'assets/images/pin_tosoabi.png',
  'Daza': 'assets/images/daza.png', // ✅ Imagen corregida
  'Chachatoy': 'assets/images/pin_chachatoy.png',
  'Pinasaco': 'assets/images/pin_pinasaco.png',
  'San Antonio de Aranda': 'assets/images/pin_sanantonio.png',
  'Tescual': 'assets/images/pin_tescual.png',
};

const Map<String, Offset> coordenadasMapa = {
  'San Juan Bajo': Offset(0.20, 0.32),
  'San Juan Alto': Offset(0.48, 0.35),
  'La Joseña': Offset(0.80, 0.38),
  'Tosoabí': Offset(0.22, 0.50),
  'Daza': Offset(0.50, 0.54),
  'Chachatoy': Offset(0.85, 0.52),
  'Pinasaco': Offset(0.20, 0.68),
  'San Antonio de Aranda': Offset(0.50, 0.72),
  'Tescual': Offset(0.82, 0.75),
};

class TesorosMapaScreen extends ConsumerWidget {
  const TesorosMapaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final descubiertos = ref.watch(tesorosDescubiertosProvider);
    final nivel = ref.watch(nivelJuegoProvider);
    final completada = ref.watch(expedicionCompletadaProvider);
    final coins = ref.watch(coinsProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (completada) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const TesorosFinalizacionScreen()));
      }
    });

    final totalMisiones = misionesDeNivel(nivel).length;
    final totalDescubiertos =
        misionesDeNivel(nivel).where((m) => descubiertos.contains(m.id)).length;

    return Scaffold(
      backgroundColor: TC.woodDeep,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/mapa_morasurco_fondo.png',
              fit: BoxFit.cover),

          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  for (final vereda in veredasMorasurco)
                    _PinVeredaAnimado(
                        vereda: vereda, areaSize: constraints.biggest),
                ],
              );
            },
          ),

          // ✅ Título subido a top: 40
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
                child: Image.asset('assets/images/titulo_tesoros.png',
                    height: 110, fit: BoxFit.contain)),
          ),

          // HUD (Píldoras marrones)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Píldora de Tesoros Encontrados (Izquierda)
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const TesorosColeccionScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3A1E),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: const Color(0xFFFFE08A), width: 2.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.inventory_2_rounded,
                              color: Color(0xFFFFE08A), size: 18),
                          const SizedBox(width: 8),
                          Text('$totalDescubiertos / $totalMisiones',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16)),
                        ],
                      ),
                    ),
                  ),

                  // Píldora de Monedas Globales (Derecha)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C3A1E),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: const Color(0xFF6FB54A), width: 2.5),
                    ),
                    child: Row(
                      children: [
                        Text('$coins',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16)),
                        const SizedBox(width: 8),
                        const Icon(Icons.eco_rounded,
                            color: Color(0xFF6FB54A), size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: BottomMenuBar(juegoActual: ContextoJuego.home),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinVeredaAnimado extends ConsumerStatefulWidget {
  final String vereda;
  final Size areaSize;
  const _PinVeredaAnimado({required this.vereda, required this.areaSize});

  @override
  ConsumerState<_PinVeredaAnimado> createState() => _PinVeredaAnimadoState();
}

class _PinVeredaAnimadoState extends ConsumerState<_PinVeredaAnimado>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -8)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coord = coordenadasMapa[widget.vereda] ?? const Offset(0.5, 0.5);
    final estado = ref.watch(estadoVeredaProvider(widget.vereda));
    final nivel = ref.watch(nivelJuegoProvider);
    final descubiertos = ref.watch(tesorosDescubiertosProvider);
    final misionesVereda = misionesDeVereda(widget.vereda, nivel);

    final bloqueada = estado == EstadoVereda.bloqueada;

    final rutaImagen =
        veredaPines[widget.vereda] ?? 'assets/images/pin_sanjuanbajo.png';

    const double pinWidth = 90;
    const double pinHeight = 110;

    return Positioned(
      left: (coord.dx * widget.areaSize.width) - (pinWidth / 2),
      top: (coord.dy * widget.areaSize.height) - pinHeight,
      child: GestureDetector(
        onTap: () {
          if (bloqueada) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Completa la vereda anterior para avanzar')));
            return;
          }
          final pendientes = misionesVereda
              .where((m) => !descubiertos.contains(m.id))
              .toList();
          if (pendientes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Tesoros descubiertos en esta zona')));
          } else {
            ref.read(veredaSeleccionadaProvider.notifier).state = widget.vereda;
            ref.read(misionActualProvider.notifier).state = pendientes.first;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const TesorosMisionScreen(),
                settings: const RouteSettings(name: 'tesoros_mision')));
          }
        },
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, bloqueada ? 0 : _bounceAnimation.value),
              child: child,
            );
          },
          child: Opacity(
            opacity: bloqueada ? 0.6 : 1.0,
            child: SizedBox(
              width: pinWidth,
              height: pinHeight + 20, // Espacio extra para el letrero
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // 1️⃣ Imagen del pin (recortada para ocultar el letrero pintado)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.78, // Muestra solo el 78% superior
                      child: Image.asset(
                        rutaImagen,
                        width: pinWidth,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // 2️⃣ Candado si está bloqueada
                  if (bloqueada)
                    Positioned(
                      top: pinHeight * 0.25,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.black45, shape: BoxShape.circle),
                        child: const Icon(Icons.lock_rounded,
                            color: Colors.white, size: 28),
                      ),
                    ),

                  // 3️⃣ Letrero personalizado (ajusta el "top" para subirlo/bajarlo)
                  Positioned(
                    top: pinHeight *
                        0.62, // ← MÁS BAJO = más abajo. Prueba 0.55 - 0.70
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3A1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFFFE08A), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.vereda,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
