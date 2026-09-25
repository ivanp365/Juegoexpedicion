import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../providers/logros_provider.dart';
import '../providers/audio_manager.dart';
import '../models/pregunta_salvavidas.dart';
import '../widgets/bottom_menu_bar.dart';
import '../widgets/bgm_scope.dart';

class Residuo {
  final String nombre;
  final String imagen;
  final String contenedorCorrecto;

  Residuo({required this.nombre, required this.imagen, required this.contenedorCorrecto});
}

final List<Residuo> _bancoResiduos = [
  Residuo(nombre: 'Botella Plástica', imagen: 'assets/images/Botella Plastica.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Caja de Cartón', imagen: 'assets/images/Caja Carton.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Botella de Vidrio', imagen: 'assets/images/Botella de vidrio.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Revistas', imagen: 'assets/images/Revistas.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Bolsa Plástica', imagen: 'assets/images/Bolsa plastica.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Tapa Plástica', imagen: 'assets/images/Tapa de botella Plastica.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Olla de Metal', imagen: 'assets/images/olla.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Envase de Yogur', imagen: 'assets/images/Envase de yogur.webp', contenedorCorrecto: 'blanco'),
  Residuo(nombre: 'Cáscara de Banano', imagen: 'assets/images/Cascara de banano1.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Restos de Comida', imagen: 'assets/images/Restos de comida cruda.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Fruta en Mal Estado', imagen: 'assets/images/Fruta en mal estado.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Restos de Cosecha', imagen: 'assets/images/Restos de cosecha.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Espina de Pescado', imagen: 'assets/images/espina de pescado.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Estiércol', imagen: 'assets/images/estiercol de vaca.webp', contenedorCorrecto: 'verde'),
  Residuo(nombre: 'Medicamentos', imagen: 'assets/images/Medicamentos.webp', contenedorCorrecto:'rojo'),
  Residuo(nombre: 'Pilas Usadas', imagen: 'assets/images/pilas.webp', contenedorCorrecto: 'rojo'),
  Residuo(nombre: 'Bombillos', imagen: 'assets/images/Bombillos.webp', contenedorCorrecto: 'rojo'),
  Residuo(nombre: 'Vidrio Roto', imagen: 'assets/images/Botella de vidrio rota.webp', contenedorCorrecto: 'rojo'),
  Residuo(nombre: 'Agroquímicos', imagen: 'assets/images/residuos de agroquimicos.webp', contenedorCorrecto: 'rojo'),
  Residuo(nombre: 'Seguridad Médica', imagen: 'assets/images/Elementos de seguridad.webp', contenedorCorrecto: 'rojo'),
  Residuo(nombre: 'Residuos de Barrido', imagen: 'assets/images/Residuos de Barrido.webp', contenedorCorrecto: 'negro'),
  Residuo(nombre: 'Plato Desechable', imagen: 'assets/images/Plato de salchipapa.webp', contenedorCorrecto: 'negro'),
  Residuo(nombre: 'Pañales Usados', imagen: 'assets/images/Pañales desechables usados.webp', contenedorCorrecto: 'negro'),
  Residuo(nombre: 'Empaque de Mecato', imagen: 'assets/images/empaque de producto.webp', contenedorCorrecto: 'negro'),
  Residuo(nombre: 'Lapiceros', imagen: 'assets/images/Lapiceros.webp', contenedorCorrecto: 'negro'),
  Residuo(nombre: 'Llanta', imagen: 'assets/images/LLanta.webp', contenedorCorrecto: 'negro'),
];

enum FeedbackStatus { none, success, error }

class JuegoClasificacionScreen extends ConsumerStatefulWidget {
  final int nivel;
  const JuegoClasificacionScreen({super.key, required this.nivel});

  @override
  ConsumerState<JuegoClasificacionScreen> createState() => _JuegoClasificacionScreenState();
}

class _JuegoClasificacionScreenState extends ConsumerState<JuegoClasificacionScreen> {
  int vidas = 3;
  int residuoActualIndex = 0;
  late List<Residuo> rondaActual;
  FeedbackStatus feedback = FeedbackStatus.none;
  String? selectedBin;

  bool _mostrandoFeedbackPop = false;
  bool _feedbackExito = true;
  String _feedbackTexto = '';
  int _feedbackTrigger = 0;

  int aciertosDirectos = 0;
  int preguntasGanadas = 0;
  int preguntasFalladas = 0;
  int monedasGanadasRonda = 0;

  void _dispararFeedback({required bool exito, required String texto}) {
    setState(() {
      _mostrandoFeedbackPop = true;
      _feedbackExito = exito;
      _feedbackTexto = texto;
      _feedbackTrigger++;
    });
  }

  @override
  void initState() {
    super.initState();
    final random = Random();
    rondaActual = List.from(_bancoResiduos)..shuffle(random);
    rondaActual = rondaActual.take(6).toList();
  }

  void _procesarJugada(String contenedorSeleccionado) async {
    if (feedback != FeedbackStatus.none) return;

    final residuo = rondaActual[residuoActualIndex];

    if (residuo.contenedorCorrecto == contenedorSeleccionado) {
      AudioManager.playSfx('correct.wav');
      setState(() {
        selectedBin = contenedorSeleccionado;
        feedback = FeedbackStatus.success;
        aciertosDirectos++;
        monedasGanadasRonda += 50;
      });
      ref.read(coinsProvider.notifier).state += 50;
      ref.read(logrosProvider.notifier).registrarResiduoAcertado();
      ref.read(logrosProvider.notifier).actualizarMonedasActuales(ref.read(coinsProvider));
      _dispararFeedback(exito: true, texto: '¡Correcto! +50');
      await Future.delayed(const Duration(milliseconds: 900));
      _siguienteResiduo();
    } else {
      AudioManager.playSfx('incorrect.mp3');
      setState(() {
        selectedBin = contenedorSeleccionado;
        feedback = FeedbackStatus.error;
      });

      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;

      bool salvado = await _mostrarPreguntaSalvavidas();

      if (salvado) {
        AudioManager.playSfx('correct.wav');
        setState(() {
          preguntasGanadas++;
          monedasGanadasRonda += 15;
          feedback = FeedbackStatus.success;
          selectedBin = residuo.contenedorCorrecto;
        });
        ref.read(coinsProvider.notifier).state += 15;
        ref.read(logrosProvider.notifier).registrarResiduoAcertado();
        ref.read(logrosProvider.notifier).registrarPreguntaCorrecta();
        ref.read(logrosProvider.notifier).actualizarMonedasActuales(ref.read(coinsProvider));
        if (!mounted) return;
        _dispararFeedback(exito: true, texto: '¡Te salvaste! +15');
        await Future.delayed(const Duration(milliseconds: 900));
        _siguienteResiduo();
      } else {
        if (!mounted) return;
        AudioManager.playSfx('incorrect.mp3');
        _dispararFeedback(exito: false, texto: '-1 Corazón');
        setState(() {
          preguntasFalladas++;
          vidas--;
          feedback = FeedbackStatus.none;
          selectedBin = null;
        });
        await Future.delayed(const Duration(milliseconds: 700));
        if (vidas <= 0) {
          _mostrarDerrota();
        } else {
          _siguienteResiduo();
        }
      }
    }
  }

  void _siguienteResiduo() {
    if (!mounted) return;
    if (residuoActualIndex < 5) {
      setState(() {
        feedback = FeedbackStatus.none;
        selectedBin = null;
        residuoActualIndex++;
      });
    } else {
      _mostrarVictoria();
    }
  }

  Future<void> _mostrarImagenCompleta(String imagePath) async {
    Timer? timer;
    if (!mounted) return;
    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (dialogContext) {
        timer = Timer(const Duration(seconds: 10), () {
          if (Navigator.of(dialogContext).canPop()) {
            Navigator.of(dialogContext).pop();
          }
        });
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 60, color: Colors.white),
              ),
            ),
          ),
        ).animate().fadeIn(duration: 250.ms).scale(curve: Curves.easeOutBack);
      },
    );
    timer?.cancel();
  }

  Future<bool> _mostrarPreguntaSalvavidas() async {
    final listaPreguntas = widget.nivel == 1 ? preguntasNivel1 : preguntasNivel2;
    final pregunta = listaPreguntas[Random().nextInt(listaPreguntas.length)];

    final opcionesOriginales = List<String>.from(pregunta.opciones);
    final opcionCorrectaStr = opcionesOriginales[pregunta.indiceCorrecto];
    opcionesOriginales.shuffle(Random());

    if (!mounted) return false;
    await _mostrarImagenCompleta(pregunta.imagen);
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF6B4423), width: 3),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¡PREGUNTA SALVAVIDAS!', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _mostrarImagenCompleta(pregunta.imagen),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(pregunta.imagen, height: 110, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 40)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(pregunta.pregunta, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3E2712))),
                  const SizedBox(height: 10),
                  ...List.generate(opcionesOriginales.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF3E2712),
                            side: const BorderSide(color: Color(0xFF9C6A3A), width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          ),
                          onPressed: () => Navigator.of(context).pop(opcionesOriginales[index] == opcionCorrectaStr),
                          child: Text(opcionesOriginales[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ).animate().scale(curve: Curves.easeOutBack),
        );
      },
    ) ?? false;
  }

  void _mostrarVictoria() => _mostrarResultados(gano: true);
  void _mostrarDerrota() => _mostrarResultados(gano: false);

  void _mostrarResultados({required bool gano}) {
    if (gano) {
      AudioManager.playSfx('victory.wav');
    }
    final totalResiduos = rondaActual.length;
    final totalCorrectos = aciertosDirectos + preguntasGanadas;
    final colorPrincipal = gano ? const Color(0xFF4CAF50) : const Color(0xFFE65100);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 380),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF6B4423), width: 4),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16, offset: Offset(0, 6))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                gano ? Icons.emoji_events_rounded : Icons.eco_rounded,
                color: colorPrincipal,
                size: 64,
                shadows: const [Shadow(color: Colors.black26, blurRadius: 6)],
              ).animate().scale(begin: const Offset(0.4, 0.4), duration: 400.ms, curve: Curves.easeOutBack)
                  .then()
                  .shimmer(duration: 1200.ms, color: Colors.white70),
              const SizedBox(height: 6),
              Text(
                gano ? '¡JUEGO TERMINADO!' : '¡SIN CORAZONES!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: colorPrincipal),
              ),
              const SizedBox(height: 2),
              Text(
                gano ? '¡Excelente clasificación ambiental!' : 'Casi lo logras, ¡inténtalo de nuevo!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B4423), fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Container(
                width: 96, height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6FCB4B),
                  border: Border.all(color: const Color(0xFF3E2712), width: 3),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$totalCorrectos/$totalResiduos', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    const Text('ACIERTOS', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ],
                ),
              ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF9C6A3A), width: 1.2),
                ),
                child: Column(
                  children: [
                    _StatRow(icon: Icons.check_circle_rounded, iconColor: const Color(0xFF4CAF50), label: 'Aciertos directos', valor: '$aciertosDirectos'),
                    const Divider(height: 14, color: Color(0xFFDBC1A0)),
                    _StatRow(icon: Icons.health_and_safety_rounded, iconColor: const Color(0xFF2196F3), label: 'Preguntas salvadas', valor: '$preguntasGanadas'),
                    const Divider(height: 14, color: Color(0xFFDBC1A0)),
                    _StatRow(icon: Icons.cancel_rounded, iconColor: const Color(0xFFE53935), label: 'Preguntas falladas', valor: '$preguntasFalladas'),
                    const Divider(height: 14, color: Color(0xFFDBC1A0)),
                    _StatRow(icon: Icons.monetization_on_rounded, iconColor: const Color(0xFFFFB300), label: 'Hojas doradas ganadas', valor: '$monedasGanadasRonda'),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms).moveY(begin: 12, end: 0),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrincipal,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () { Navigator.of(context).pop(); Navigator.of(context).pop(); },
                  child: Text(
                    gano ? 'CONTINUAR' : 'VOLVER AL MAPA',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ).animate().scale(curve: Curves.easeOutBack, duration: 350.ms),
    );
  }

  @override
  Widget build(BuildContext context) {
    final residuoActual = rondaActual[residuoActualIndex];
    final String corazonesAsset = vidas >= 3 ? 'assets/images/3corazones.webp' : vidas == 2 ? 'assets/images/2corazones.webp' : 'assets/images/1corazones.webp';

    return BgmScope(mode: BgmMode.home, child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondo_clasificacion.webp', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(corazonesAsset, height: 42, fit: BoxFit.contain)
                          .animate(key: ValueKey(vidas))
                          .shake(hz: 4, curve: Curves.easeInOut, duration: 500.ms)
                          .scaleXY(begin: 1.25, end: 1.0, duration: 350.ms, curve: Curves.easeOutBack),
                      Consumer(builder: (context, ref, _) {
                        return Container(
                          height: 44, width: 135,
                          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/coin_bg.webp'), fit: BoxFit.contain)),
                          alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 32),
                          child: Text('${ref.watch(coinsProvider)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17))
                              .animate(key: ValueKey(ref.watch(coinsProvider)))
                              .scaleXY(begin: 1.4, end: 1.0, duration: 300.ms, curve: Curves.easeOutBack),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset('assets/images/letreroclasificacion.webp', height: 90, fit: BoxFit.contain)
                    .animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -4, end: 4, duration: 2500.ms, curve: Curves.easeInOutSine)
                    .shimmer(delay: 2.seconds, duration: 1.seconds, color: Colors.white54),
                const SizedBox(height: 12),
                SizedBox(
                  width: 140, height: 42,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/aquivacontadorderesiduos.webp', fit: BoxFit.contain),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('${residuoActualIndex + 1} / 6', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  flex: 13,
                  child: Transform.scale(
                    scale: 1.08,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/aquivanlosresiduosyeltexto.webp', fit: BoxFit.contain),
                        Draggable<String>(
                          data: residuoActual.contenedorCorrecto,
                          feedback: Material(color: Colors.transparent, child: Image.asset(residuoActual.imagen, height: 105)),
                          childWhenDragging: Opacity(opacity: 0.25, child: Image.asset(residuoActual.imagen, height: 80)),
                          child: Image.asset(residuoActual.imagen, height: 80)
                              .animate(key: ValueKey(residuoActualIndex))
                              .scaleXY(begin: 0.2, end: 1.0, duration: 350.ms, curve: Curves.easeOutBack),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(child: _BinTarget(type: 'blanco', image: 'assets/images/contblanco.webp', isSelected: selectedBin == 'blanco', feedback: feedback, onAccept: _procesarJugada)),
                      Expanded(child: _BinTarget(type: 'verde', image: 'assets/images/contenedorverde.webp', isSelected: selectedBin == 'verde', feedback: feedback, onAccept: _procesarJugada)),
                      Expanded(child: _BinTarget(type: 'rojo', image: 'assets/images/contenedorrojo.webp', isSelected: selectedBin == 'rojo', feedback: feedback, onAccept: _procesarJugada)),
                      Expanded(child: _BinTarget(type: 'negro', image: 'assets/images/contenedornegro.webp', isSelected: selectedBin == 'negro', feedback: feedback, onAccept: _procesarJugada)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const BottomMenuBar(juegoActual: ContextoJuego.clasificacion),
              ],
            ),
          ),
          if (_mostrandoFeedbackPop)
            _ScreenFlash(key: ValueKey('flash_$_feedbackTrigger'), color: (_feedbackExito ? Colors.green : Colors.red).withValues(alpha: 0.25)),
          if (_mostrandoFeedbackPop)
            _FeedbackPop(
              key: ValueKey('pop_$_feedbackTrigger'),
              exito: _feedbackExito,
              texto: _feedbackTexto,
              onFinished: () { if (mounted) setState(() => _mostrandoFeedbackPop = false); },
            ),
        ],
      ),
    ));
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String valor;
  const _StatRow({required this.icon, required this.iconColor, required this.label, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3E2712))),
        ),
        Text(valor, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: iconColor)),
      ],
    );
  }
}

class _BinTarget extends StatelessWidget {
  final String type;
  final String image;
  final bool isSelected;
  final FeedbackStatus feedback;
  final Function(String) onAccept;

  const _BinTarget({required this.type, required this.image, required this.isSelected, required this.feedback, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (details) => onAccept(type),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: 200.ms,
          curve: Curves.easeOutBack,
          transform: Matrix4.identity()..scale(isHovered ? 1.08 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: (isSelected && feedback == FeedbackStatus.success)
                    ? Colors.greenAccent.withValues(alpha: 0.6)
                    : (isSelected && feedback == FeedbackStatus.error)
                        ? Colors.redAccent.withValues(alpha: 0.6)
                        : Colors.transparent,
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
        );
      },
    );
  }
}

class _FeedbackPop extends StatelessWidget {
  final bool exito;
  final String texto;
  final VoidCallback onFinished;
  const _FeedbackPop({super.key, required this.exito, required this.texto, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    final color = exito ? const Color(0xFF4CAF50) : const Color(0xFFE53935);
    final icono = exito ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return IgnorePointer(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, color: color, size: 90, shadows: const [Shadow(color: Colors.black45, blurRadius: 10)])
                .animate(onComplete: (_) => onFinished())
                .scale(begin: const Offset(0.3, 0.3), end: const Offset(1.2, 1.2), duration: 350.ms, curve: Curves.easeOutBack)
                .then(delay: 500.ms)
                .scale(end: const Offset(0.8, 0.8), duration: 300.ms)
                .fadeOut(duration: 300.ms),
            const SizedBox(height: 6),
            Text(
              texto,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                shadows: const [Shadow(color: Colors.white, blurRadius: 4, offset: Offset(1, 1))],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 300.ms).moveY(begin: 10, end: 0),
          ],
        ),
      ),
    );
  }
}

class _ScreenFlash extends StatelessWidget {
  final Color color;
  const _ScreenFlash({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(color: color)
          .animate()
          .fadeIn(duration: 100.ms)
          .then(delay: 150.ms)
          .fadeOut(duration: 400.ms),
    );
  }
}