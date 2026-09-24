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
  'Daza': 'assets/images/daza.png',
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

class FloatingTitleAnimation extends StatefulWidget {
  final Widget child;
  const FloatingTitleAnimation({super.key, required this.child});
  @override State<FloatingTitleAnimation> createState() => _FloatingTitleAnimationState();
}

class _FloatingTitleAnimationState extends State<FloatingTitleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _rotateAnimation;

  @override void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _moveAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _rotateAnimation = Tween<double>(begin: -0.015, end: 0.015).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override void dispose() { _controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _moveAnimation.value), 
        child: Transform.rotate(angle: _rotateAnimation.value, child: child)
      ),
      child: widget.child,
    );
  }
}

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
          Image.asset('assets/images/mapa_morasurco_fondo.png', fit: BoxFit.cover),

          // Renderiza los 9 pines siempre en el mapa
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  for (final vereda in veredasMorasurco)
                    _PinVeredaAnimado(vereda: vereda, areaSize: constraints.biggest),
                ],
              );
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 5,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingTitleAnimation(
                child: Image.asset('assets/images/titulo_tesoros.png', height: 100, fit: BoxFit.contain),
              ),
            ),
          ),

          // HUD Superior
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TesorosColeccionScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5C3A1E),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFFFE08A), width: 2.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.inventory_2_rounded, color: Color(0xFFFFE08A), size: 18),
                        const SizedBox(width: 8),
                        Text('$totalDescubiertos / $totalMisiones',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 48,
                  width: 140,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/images/coin_bg.png'), fit: BoxFit.contain),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 35),
                  child: Text('$coins', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ],
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

  @override ConsumerState<_PinVeredaAnimado> createState() => _PinVeredaAnimadoState();
}

class _PinVeredaAnimadoState extends ConsumerState<_PinVeredaAnimado> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override void dispose() { _controller.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    final coord = coordenadasMapa[widget.vereda] ?? const Offset(0.5, 0.5);
    final estado = ref.watch(estadoVeredaProvider(widget.vereda));
    final nivel = ref.watch(nivelJuegoProvider);
    final descubiertos = ref.watch(tesorosDescubiertosProvider);
    final misionesVereda = misionesDeVereda(widget.vereda, nivel);
    final bloqueada = estado == EstadoVereda.bloqueada;

    final rutaImagen = veredaPines[widget.vereda] ?? 'assets/images/pin_sanjuanbajo.png';
    const double pinWidth = 90;
    const double pinHeight = 110;

    return Positioned(
      left: (coord.dx * widget.areaSize.width) - (pinWidth / 2),
      top: (coord.dy * widget.areaSize.height) - pinHeight,
      child: GestureDetector(
        onTap: () {
          // Si está bloqueada, da el mensaje pedagógico exacto
          if (bloqueada) {
            if (nivel == NivelJuego.primaria && misionesVereda.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Esta vereda se desbloquea en el Nivel 2 (Secundaria)!'))
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Completa la vereda anterior para avanzar'))
              );
            }
            return;
          }

          final pendientes = misionesVereda.where((m) => !descubiertos.contains(m.id)).toList();
          if (pendientes.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tesoros descubiertos en esta zona'))
            );
          } else {
            ref.read(veredaSeleccionadaProvider.notifier).state = widget.vereda;
            ref.read(misionActualProvider.notifier).state = pendientes.first;
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const TesorosMisionScreen(),
              settings: const RouteSettings(name: 'tesoros_mision')
            ));
          }
        },
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, bloqueada ? 0 : _bounceAnimation.value),
            child: child,
          ),
          child: Opacity(
            opacity: bloqueada ? 0.6 : 1.0,
            child: SizedBox(
              width: pinWidth,
              height: pinHeight + 20, 
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.78, 
                      child: Image.asset(rutaImagen, width: pinWidth, fit: BoxFit.contain),
                    ),
                  ),

                  if (bloqueada)
                    Positioned(
                      top: pinHeight * 0.25,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
                      ),
                    ),

                  Positioned(
                    top: pinHeight * 0.62,
                    child: Container(
                      width: pinWidth * 0.9,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C3A1E),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFE08A), width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2))],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.vereda,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
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
