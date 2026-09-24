import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import 'tesoros_categoria_screen.dart';

class TesorosExploracionScreen extends ConsumerStatefulWidget {
  const TesorosExploracionScreen({super.key});

  @override
  ConsumerState<TesorosExploracionScreen> createState() =>
      _TesorosExploracionScreenState();
}

class _TesorosExploracionScreenState
    extends ConsumerState<TesorosExploracionScreen> {
  static const double _designWidth = 1000;
  static const double _designHeight = 1575;

  // Único elemento correcto: el cofre representa el tesoro de la misión.
  static const String _elementoCorrecto = 'cofre';
  // Señuelos: se pueden tocar, dan una pequeña pista de "no es aquí",
  // pero no rompen el juego ni cuentan como error grave.
  static const List<String> _decoys = ['arbol', 'gota', 'hoja', 'huella'];

  // Coordenadas (0.0–1.0) calibradas sobre fondo_busqueda.png.
  // Distribuidas de forma ordenada: 2 arriba, 3 abajo, cada una
  // sobre un elemento del paisaje (árbol, río, camino, puente, etc.).
  final Map<String, Offset> _posiciones = const {
    'arbol': Offset(0.13, 0.42), // Tronco del árbol grande (izquierda)
    'hoja': Offset(0.82, 0.42), // Vegetación del lado derecho
    'gota': Offset(0.55, 0.72), // Sobre el río, parte media-baja
    'huella': Offset(0.78, 0.82), // Camino/puente, lado derecho
    'cofre': Offset(0.32, 0.82), // Camino bajo, cerca del niño
  };

  final Set<String> _decoysTocados = {};
  bool _encontrado = false;
  String? _mensajeFeedback;

  void _tocarElemento(String tipo) {
    if (_encontrado) return;

    if (tipo == _elementoCorrecto) {
      setState(() => _encontrado = true);
      _mostrarDialogoExito();
      return;
    }

    setState(() {
      _decoysTocados.add(tipo);
      _mensajeFeedback = 'Aquí no hay nada… ¡sigue buscando!';
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _mensajeFeedback = null);
    });
  }

  void _mostrarDialogoExito() {
    final veredaActual = ref.read(veredaSeleccionadaProvider);
    final mision = ref.read(misionActualProvider);

    // OJO: aquí NO sumamos monedas ni marcamos el tesoro como descubierto.
    // Eso lo hace TesorosCategoriaScreen._elegir() cuando el jugador acierta
    // la categoría — hacerlo también aquí duplicaba la recompensa.

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF8B5A2B), width: 4),
        ),
        title: const Text(
          '¡Tesoro Descubierto!',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Color(0xFF5C3A1E), fontWeight: FontWeight.w900),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech_rounded,
                    color: Colors.amber, size: 64)
                .animate()
                .scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text(
              '¡Has encontrado ${mision?.nombreTesoro ?? "el tesoro"} en ${veredaActual ?? "esta vereda"}!\n\nAhora dinos qué servicio ecosistémico representa.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FB54A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx).pop(); // Cierra diálogo
                // Reemplaza esta pantalla por la de categoría: si el jugador
                // acierta ahí, avanza; si falla, puede reintentar sin volver
                // a buscar el tesoro otra vez.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => const TesorosCategoriaScreen()),
                );
              },
              child: const Text('Continuar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pin(String tipo, Offset pos, BoxConstraints constraints) {
    final esCorrecto = tipo == _elementoCorrecto;
    final tocado = _decoysTocados.contains(tipo);

    return Positioned(
      left: constraints.maxWidth * pos.dx - 35,
      top: constraints.maxHeight * pos.dy - 35,
      child: GestureDetector(
        onTap: () => _tocarElemento(tipo),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.amber, width: 3),
            color: Colors.black.withValues(alpha: 0.3),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/images/icono_$tipo.png',
              width: 45,
              height: 45,
              errorBuilder: (c, e, s) =>
                  const Icon(Icons.star, color: Colors.amber, size: 30),
            ),
          ),
        ),
      )
          // Brillo/pulso constante para que se note que son interactivos,
          // sin delatar cuál es el correcto (todos laten igual).
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(
              begin: 1.0,
              end: esCorrecto ? 1.12 : 1.08,
              duration: 900.ms,
              curve: Curves.easeInOut)
          // Si un señuelo ya fue tocado, se atenúa para dar feedback visual
          // de "ya probé aquí" sin desaparecerlo del todo.
          .then()
          .custom(
            duration: 1.ms,
            builder: (context, value, child) =>
                Opacity(opacity: tocado ? 0.45 : 1.0, child: child),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coins = ref.watch(coinsProvider);
    final veredaActual = ref.watch(veredaSeleccionadaProvider) ?? 'Morasurco';
    final mision = ref.watch(misionActualProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            // 1. ESCENARIO FIJO Y ELÁSTICO
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _designWidth / _designHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                                'assets/images/fondo_busqueda.png',
                                fit: BoxFit.fill),
                          ),

                          // 2. PINES: 4 señuelos + 1 correcto (el cofre)
                          if (!_encontrado)
                            for (final tipo in [..._decoys, _elementoCorrecto])
                              _pin(tipo, _posiciones[tipo]!, constraints),

                          // 3. FEEDBACK "aquí no hay nada" flotante
                          if (_mensajeFeedback != null)
                            Positioned(
                              top: constraints.maxHeight * 0.08,
                              left: constraints.maxWidth * 0.15,
                              right: constraints.maxWidth * 0.15,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5C3A1E)
                                      .withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFFD98E41), width: 2),
                                ),
                                child: Text(
                                  _mensajeFeedback!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 200.ms)
                                  .then(delay: 1500.ms)
                                  .fadeOut(duration: 400.ms),
                            ),

                          // 4. PISTA DE LA MISIÓN — banner estilo madera, siempre visible
                          if (mision != null)
                            Positioned(
                              bottom: 20,
                              left: 20,
                              right: 20,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCE7B0),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: const Color(0xFF8B5A2B), width: 3),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 6,
                                        offset: Offset(0, 3))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.lightbulb,
                                        color: Color(0xFFD98E41), size: 26),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        mision.pista,
                                        style: const TextStyle(
                                          color: Color(0xFF5C3A1E),
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // 5. BARRA SUPERIOR
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset('assets/images/botonatras.png',
                        width: 65, height: 65),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD98E41),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF5C3A1E), width: 3),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 4),
                              blurRadius: 4)
                        ],
                      ),
                      // FittedBox: si el nombre de la vereda es largo, el
                      // letrero se achica para caber en vez de desbordarse.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          veredaActual,
                          maxLines: 1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                  color: Color(0xFF5C3A1E),
                                  offset: Offset(1, 1))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 130,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/coin_bg.png'),
                          fit: BoxFit.contain),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 35),
                    child: Text(
                      '$coins',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
