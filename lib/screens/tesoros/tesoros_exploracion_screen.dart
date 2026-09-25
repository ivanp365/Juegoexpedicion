import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import 'tesoros_categoria_screen.dart';
import '../../providers/audio_manager.dart';

class TesorosExploracionScreen extends ConsumerStatefulWidget {
  const TesorosExploracionScreen({super.key});

  @override
  ConsumerState<TesorosExploracionScreen> createState() => _TesorosExploracionScreenState();
}

class _TesorosExploracionScreenState extends ConsumerState<TesorosExploracionScreen> {
  static const double _designWidth = 1000;
  static const double _designHeight = 1575;

  static const String _elementoCorrecto = 'cofre';
  static const List<String> _decoys = ['arbol', 'gota', 'hoja', 'huella'];

  // Coordenadas ultra-centradas para asegurar que ningún círculo escape de la pantalla
  final List<Offset> _coordenadasFijas = const [
    Offset(0.35, 0.35), 
    Offset(0.65, 0.38), 
    Offset(0.30, 0.50), 
    Offset(0.68, 0.55), 
    Offset(0.50, 0.65), 
  ];

  late Map<String, Offset> _posicionesAleatorias;
  final Set<String> _elementosRevelados = {}; 

  bool _encontrado = false;
  String? _mensajeFeedback;

  @override
  void initState() {
    super.initState();
    _generarDistribucionAleatoria();
  }

  void _generarDistribucionAleatoria() {
    final todosLosElementos = [..._decoys, _elementoCorrecto]..shuffle(math.Random()); 
    _posicionesAleatorias = {};
    for (int i = 0; i < todosLosElementos.length; i++) {
      _posicionesAleatorias[todosLosElementos[i]] = _coordenadasFijas[i];
    }
  }

  void _tocarElemento(String tipo) {
    if (_encontrado || _elementosRevelados.contains(tipo)) return;

    setState(() => _elementosRevelados.add(tipo));

    if (tipo == _elementoCorrecto) {
      AudioManager.playSfx('victory.wav');
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _encontrado = true);
          _mostrarDialogoExito();
        }
      });
      return;
    }

    AudioManager.playSfx('incorrect.mp3');
    setState(() => _mensajeFeedback = 'Aquí no hay nada… ¡sigue buscando!');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _mensajeFeedback = null);
    });
  }

  void _mostrarDialogoExito() {
    final veredaActual = ref.read(veredaSeleccionadaProvider);
    final mision = ref.read(misionActualProvider);

    showDialog(
      context: context, barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EC),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF8B5A2B), width: 4)),
        title: const Text('¡Tesoro Descubierto!', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5C3A1E), fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.military_tech_rounded, color: Colors.amber, size: 64).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text('¡Has encontrado ${mision?.nombreTesoro ?? "el tesoro"} en ${veredaActual ?? "esta vereda"}!\n\nAhora dinos qué servicio ecosistémico representa.', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6FB54A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TesorosCategoriaScreen()));
              },
              child: const Text('Continuar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pinMisterioso(String tipo, Offset pos, BoxConstraints constraints) {
    final revelado = _elementosRevelados.contains(tipo);
    final esCorrecto = tipo == _elementoCorrecto;

    return Positioned(
      left: constraints.maxWidth * pos.dx - 50, 
      top: constraints.maxHeight * pos.dy - 50,
      child: GestureDetector(
        onTap: () => _tocarElemento(tipo),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: revelado ? math.pi : 0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutBack,
          builder: (context, double val, child) {
            bool mostrandoFrente = val < (math.pi / 2);
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(val),
              child: mostrandoFrente
                  ? const _CaraMisteriosa()
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(math.pi),
                      child: _CaraRevelada(tipo: tipo, esCorrecto: esCorrecto),
                    ),
            );
          },
        ),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _designWidth,
                height: _designHeight,
                child: Builder(
                  builder: (context) {
                    const constraints = BoxConstraints.tightFor(width: _designWidth, height: _designHeight);
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset('assets/images/fondo_busqueda.webp', fit: BoxFit.fill),
                        ),
                        if (!_encontrado)
                          for (final tipo in _posicionesAleatorias.keys)
                            _pinMisterioso(tipo, _posicionesAleatorias[tipo]!, constraints),
                        
                        // TEXTO GIGANTE
                        if (_mensajeFeedback != null)
                          Positioned(
                            top: constraints.maxHeight * 0.16, left: constraints.maxWidth * 0.05, right: constraints.maxWidth * 0.05,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5C3A1E).withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFD98E41), width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4))],
                              ),
                              child: Text(
                                _mensajeFeedback!, 
                                textAlign: TextAlign.center, 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 34)
                              ),
                            ).animate().fadeIn(duration: 200.ms).then(delay: 1500.ms).fadeOut(duration: 400.ms),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          
          if (mision != null)
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7B0),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF8B5A2B), width: 3),
                      boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Color(0xFFD98E41), size: 26),
                        const SizedBox(width: 10),
                        Expanded(child: Text(mision.pista, style: const TextStyle(color: Color(0xFF5C3A1E), fontStyle: FontStyle.italic, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        AudioManager.playSfx('button_back.wav');
                        Navigator.of(context).pop();
                      },
                      child: Image.asset('assets/images/botonatras.webp', width: 55, height: 55),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD98E41), borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF5C3A1E), width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 4)],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            veredaActual, maxLines: 1,
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, shadows: [Shadow(color: Color(0xFF5C3A1E), offset: Offset(1, 1))]),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 44, width: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/coin_bg.webp'), fit: BoxFit.contain),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 28),
                      child: Text('$coins', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaraMisteriosa extends StatelessWidget {
  const _CaraMisteriosa();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, height: 100, // Círculos GIGANTES
      decoration: BoxDecoration(
        shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFE08A), width: 4), color: const Color(0xFF5C3A1E),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: const Center(child: Text('?', style: TextStyle(color: Color(0xFFFFE08A), fontSize: 60, fontWeight: FontWeight.w900, shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))]))),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1.0, end: 1.08, duration: 1.seconds, curve: Curves.easeInOut);
  }
}

class _CaraRevelada extends StatelessWidget {
  final String tipo;
  final bool esCorrecto;
  const _CaraRevelada({required this.tipo, required this.esCorrecto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, height: 100, // Círculos GIGANTES
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: esCorrecto ? Colors.greenAccent : Colors.amber, width: esCorrecto ? 5 : 4),
        color: Colors.black.withValues(alpha: 0.6),
      ),
      child: Center(child: Image.asset('assets/images/icono_$tipo.webp', width: 65, height: 65, errorBuilder: (c, e, s) => const Icon(Icons.star, color: Colors.amber, size: 45))),
    );
  }
}