import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/pregunta_lombricarrera.dart';
import '../models/banco_lombricarrera.dart';
import '../widgets/bottom_menu_bar.dart';
import '../providers/game_provider.dart';
import '../providers/logros_provider.dart';
import '../providers/audio_manager.dart';

class LombricarreraJuegoScreen extends ConsumerStatefulWidget {
  final String modo;
  final int nivel;

  const LombricarreraJuegoScreen({super.key, required this.modo, required this.nivel});

  @override
  ConsumerState<LombricarreraJuegoScreen> createState() => _LombricarreraJuegoScreenState();
}

class _LombricarreraJuegoScreenState extends ConsumerState<LombricarreraJuegoScreen> {
  int posJ1 = 0;
  int posJ2 = 0;
  int turnoActual = 1;

  bool mostrandoPregunta = false;
  bool tirandoDado = false;
  bool mostrandoFeedback = false;
  int? indexSeleccionado;

  int valorDado = 1;
  late PreguntaLombri preguntaActual;
  int animDadoDisplay = 1;
  String animCatDisplay = 'assets/images/lombricarrera/lombricultura.webp';

  final Random _rnd = Random();
  final List<String> _categoriasAssets = ['lombricultura.webp', 'cuidado.webp', 'reciclaje.webp', 'retolombripng.webp'];

  late List<PreguntaLombri> _preguntasPartida;
  int _indicePregunta = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioManager.playBgm('home_theme.mp3');
    });
    _preguntasPartida = obtenerPreguntasAleatorias(widget.nivel, cantidad: 30);
    _prepararTurno();
  }

  void _prepararTurno() async {
    if (turnoActual == 2 && widget.modo == 'vsIA') {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      _iniciarTiroAnimado(esIA: true);
    }
  }

  void _tirarDadoJugador() {
    if (mostrandoPregunta || tirandoDado || (turnoActual == 2 && widget.modo == 'vsIA')) return;
    _iniciarTiroAnimado(esIA: false);
  }

  void _iniciarTiroAnimado({required bool esIA}) async {
    setState(() => tirandoDado = true);

    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 70));
      if (!mounted) return;
      setState(() {
        animDadoDisplay = _rnd.nextInt(4) + 1;
        animCatDisplay = 'assets/images/lombricarrera/${_categoriasAssets[_rnd.nextInt(4)]}';
      });
    }

    valorDado = _rnd.nextInt(4) + 1;

    if (_indicePregunta >= _preguntasPartida.length) _indicePregunta = 0;
    preguntaActual = _preguntasPartida[_indicePregunta];
    _indicePregunta++;

    animDadoDisplay = valorDado;
    if (preguntaActual.color == 'verde') animCatDisplay = 'assets/images/lombricarrera/lombricultura.webp';
    else if (preguntaActual.color == 'azul') animCatDisplay = 'assets/images/lombricarrera/cuidado.webp';
    else if (preguntaActual.color == 'amarillo') animCatDisplay = 'assets/images/lombricarrera/reciclaje.webp';
    else if (preguntaActual.color == 'morado') animCatDisplay = 'assets/images/lombricarrera/retolombripng.webp';

    setState(() {
      tirandoDado = false;
      mostrandoPregunta = true;
      mostrandoFeedback = false;
      indexSeleccionado = null;
    });

    if (esIA) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      bool acierta = _rnd.nextDouble() <= 0.60;
      if (acierta) {
        _evaluarRespuesta(preguntaActual.indiceCorrecto);
      } else {
        int opcIncorrecta;
        do { opcIncorrecta = _rnd.nextInt(4); } while (opcIncorrecta == preguntaActual.indiceCorrecto);
        _evaluarRespuesta(opcIncorrecta);
      }
    }
  }

  void _evaluarRespuesta(int index) async {
    if (mostrandoFeedback) return;
    setState(() { indexSeleccionado = index; mostrandoFeedback = true; });

    bool esCorrecto = index == preguntaActual.indiceCorrecto;
    final esJugadorHumano = turnoActual == 1 || (turnoActual == 2 && widget.modo != 'vsIA');

    if (esCorrecto && esJugadorHumano) {
      AudioManager.playSfx('correct.wav');
      ref.read(coinsProvider.notifier).state += 10;
      ref.read(logrosProvider.notifier).registrarPreguntaCorrecta();
      ref.read(logrosProvider.notifier).actualizarMonedasActuales(ref.read(coinsProvider));
    } else if (!esCorrecto) {
      AudioManager.playSfx('incorrect.mp3');
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (esCorrecto) {
      setState(() {
        if (turnoActual == 1) posJ1 = (posJ1 + valorDado > 20) ? 20 : posJ1 + valorDado;
        else posJ2 = (posJ2 + valorDado > 20) ? 20 : posJ2 + valorDado;
      });
      await Future.delayed(const Duration(milliseconds: 1000));
      if (!mounted) return;
    }

    if (posJ1 >= 20 || posJ2 >= 20) {
      String mensaje = '';
      if (posJ1 >= 20) {
        AudioManager.playSfx('victory.wav');
        mensaje = '¡Jugador 1 Gana!\n+50 Hojas Doradas';
        ref.read(coinsProvider.notifier).state += 50;
        ref.read(logrosProvider.notifier).registrarVictoriaLombricarrera();
        ref.read(logrosProvider.notifier).actualizarMonedasActuales(ref.read(coinsProvider));
      } else if (widget.modo == 'vsIA') {
        mensaje = '¡La IA Gana!\nSigue intentándolo';
      } else {
        mensaje = '¡Jugador 2 Gana!\nSigue intentándolo';
      }
      _mostrarVictoria(mensaje);
      return;
    }

    setState(() { mostrandoPregunta = false; turnoActual = turnoActual == 1 ? 2 : 1; });
    _prepararTurno();
  }

  void _mostrarVictoria(String mensaje) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3E0),
        title: Text(mensaje, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.green, fontSize: 22)),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6FCB4B)),
            onPressed: () { Navigator.of(context).pop(); Navigator.of(context).pop(); },
            child: const Text('SALIR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/fondo_clasificacion.webp', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              AudioManager.playSfx('button_back.wav');
                              Navigator.of(context).maybePop();
                            },
                            child: Image.asset('assets/images/botonatras.webp', width: 45),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.asset('assets/images/lombricarrera/letreroprincipallombricarrera.webp', height: 60)
                            .animate().scaleXY(begin: 0.8, end: 1.0, curve: Curves.easeOutBack),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 8.0),
                          child: Container(
                            height: 35, width: 90,
                            decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage('assets/images/coin_bg.webp'), fit: BoxFit.contain)
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 25),
                            child: Text('${ref.watch(coinsProvider)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: _MarcadorJugador(
                    imagenFondo: 'assets/images/lombricarrera/tablerojugadorvacioparallenar.webp',
                    nombre: 'Jugador 1', turnoActivo: turnoActual == 1, posicion: posJ1,
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  flex: 3,
                  child: _MarcadorJugador(
                    imagenFondo: widget.modo == 'vsIA' ? 'assets/images/lombricarrera/tableroiaparallenar.webp' : 'assets/images/lombricarrera/tablerojugadorvacioparallenar.webp',
                    nombre: widget.modo == 'vsIA' ? 'IA' : 'Jugador 2',
                    esIA: widget.modo == 'vsIA',
                    turnoActivo: turnoActual == 2, posicion: posJ2,
                  ),
                ),
                if (!mostrandoPregunta)
                  Expanded(
                    flex: 6,
                    child: GestureDetector(
                      onTap: _tirarDadoJugador,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!tirandoDado)
                            Text(turnoActual == 1 ? '¡Tu Turno! Toca para girar' : (widget.modo== 'vsIA' ? 'Turno de la IA...' : 'Turno del Jugador 2'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(1, 1))])),
                          const SizedBox(height: 10),
                          _LetreroDado(
                            alto: 80,
                            child: tirandoDado
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset('assets/images/lombricarrera/$animDadoDisplay.webp', height: 45),
                                      const SizedBox(width: 15),
                                      Image.asset(animCatDisplay, height: 45),
                                    ],
                                  )
                                : const Icon(Icons.touch_app, color: Colors.white70, size: 35).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 0.9, end: 1.2),
                          ).animate(target: tirandoDado ? 1 : 0).shake(hz: 8),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: _CajaPregunta(
                        pregunta: preguntaActual, dado: animDadoDisplay, iconoCat: animCatDisplay,
                        onRespuesta: _evaluarRespuesta,
                        bloquearToque: (turnoActual == 2 && widget.modo == 'vsIA') || mostrandoFeedback,
                        mostrarFeedback: mostrandoFeedback, indexSeleccionado: indexSeleccionado,
                      ).animate().slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack).fadeIn(),
                    ),
                  ),
                const SizedBox(height: 5),
                const BottomMenuBar(juegoActual: ContextoJuego.lombricarrera),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LetreroDado extends StatelessWidget {
  final double alto;
  final Widget child;
  const _LetreroDado({required this.alto, required this.child});
  static const double _ratio = 2.57;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: alto,
      width: alto * _ratio,
      padding: EdgeInsets.symmetric(horizontal: alto * 0.28, vertical: alto * 0.14),
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/lombricarrera/tabladondevaeldadoycategoria.webp'), fit: BoxFit.contain),
      ),
      child: FittedBox(fit: BoxFit.scaleDown, child: child),
    );
  }
}

class _MarcadorJugador extends StatelessWidget {
  final String imagenFondo;
  final String nombre;
  final bool turnoActivo;
  final int posicion;
  final bool esIA;

  const _MarcadorJugador({required this.imagenFondo, required this.nombre, required this.turnoActivo, required this.posicion, this.esIA = false});

  static const double _gridLeft = 0.064;
  static const double _gridRight = 0.067;
  static const double _gridTop = 0.378;
  static const double _gridBottom = 0.136;

  @override
  Widget build(BuildContext context) {
    final List<int> fila1 = List.generate(10, (i) => i + 1);
    final List<int> fila2 = List.generate(10, (i) => 20 - i);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Opacity(
        opacity: turnoActivo ? 1.0 : 0.85,
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(imagenFondo), fit:BoxFit.fill)),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double w = constraints.maxWidth;
              final double h = constraints.maxHeight;
              return Stack(
                children: [
                  Positioned(
                    left: w * 0.285, top: h * 0.15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: esIA ? const Color(0xFF1E6FD9) : const Color(0xFFD32F2F),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(nombre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11.5, height: 1.1)),
                    ),
                  ),
                  if (turnoActivo)
                    Positioned(
                      left: w * 0.285, top: h * 0.272,
                      child: const Text('(turno actual)', style: TextStyle(color: Color(0xFF6B4423), fontSize: 10, fontWeight: FontWeight.w700, height: 1.0)),
                    ),
                  Positioned(
                    right: w * 0.073, top: h * 0.164,
                    width: w * 0.171, height: h * 0.154,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('$posicion/20', style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: w * _gridLeft, right: w * _gridRight,
                    top: h * _gridTop, bottom: h * _gridBottom,
                    child: Column(
                      children: [
                        Expanded(child: Row(children: fila1.map((num) => Expanded(child: _CasillaGrilla(numero: num, posicionActual: posicion))).toList())),
                        Expanded(child: Row(children: fila2.map((num) => Expanded(child: _CasillaGrilla(numero: num, posicionActual: posicion))).toList())),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CasillaGrilla extends StatelessWidget {
  final int numero;
  final int posicionActual;
  const _CasillaGrilla({required this.numero, required this.posicionActual});

  @override
  Widget build(BuildContext context) {
    final bool esActual = numero == posicionActual;
    final Widget contenido = FittedBox(
      fit: BoxFit.scaleDown,
      child: numero == 20
          ? Icon(Icons.flag, color: esActual ? Colors.white : Colors.orange, size: 16)
          : Text('$numero', style: TextStyle(color: esActual ? Colors.white : const Color(0xFF6B4423), fontSize: 13, fontWeight: FontWeight.w900)),
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1.5),
      alignment: Alignment.center,
      decoration: esActual
          ? BoxDecoration(
              color: const Color(0xFF6FCB4B).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.6), blurRadius: 6, spreadRadius: 1)],
            )
          : null,
      child: esActual ? contenido.animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 0.9, end: 1.1) : contenido,
    );
  }
}

class _CajaPregunta extends StatelessWidget {
  final PreguntaLombri pregunta;
  final int dado;
  final String iconoCat;
  final Function(int) onRespuesta;
  final bool bloquearToque;
  final bool mostrarFeedback;
  final int? indexSeleccionado;

  const _CajaPregunta({required this.pregunta, required this.dado, required this.iconoCat, required this.onRespuesta, required this.bloquearToque, required this.mostrarFeedback, required this.indexSeleccionado});

  static const double _padLados = 0.078;
  static const double _padArriba = 0.14;
  static const double _padAbajo = 0.15;
  static const double _altoMaxBoton = 42;
  static const double _espacio = 8;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: 30,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/lombricarrera/cuadroendondevalaspreguntasyrespuestas.webp'), fit: BoxFit.fill),
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(c.maxWidth * _padLados, c.maxHeight * _padArriba, c.maxWidth * _padLados, c.maxHeight * _padAbajo),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Text(pregunta.texto, textAlign: TextAlign.center, maxLines: 3,overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E2712))),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: LayoutBuilder(
                          builder: (context, o) {
                            final double altoBoton = ((o.maxHeight - _espacio) / 2).clamp(28.0,_altoMaxBoton).toDouble();
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _filaOpciones(0, 1, altoBoton),
                                const SizedBox(height: _espacio),
                                _filaOpciones(2, 3, altoBoton),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: -5,
          child: _LetreroDado(
            alto: 62,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/lombricarrera/$dado.webp', height: 28),
                const SizedBox(width: 8),
                Image.asset(iconoCat, height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filaOpciones(int a, int b, double alto) {
    const letras = ['a', 'b', 'c', 'd'];
    Widget boton(int i) => _BotonOpcion(letras[i], pregunta.opciones[i], bloquearToque ? null :() => onRespuesta(i), _obtenerEstado(i), alto);
    return Row(
      children: [
        Expanded(child: boton(a)),
        const SizedBox(width: _espacio),
        Expanded(child: boton(b)),
      ],
    );
  }

  String _obtenerEstado(int index) {
    if (!mostrarFeedback) return 'normal';
    if (index == pregunta.indiceCorrecto) return 'correcto';
    if (index == indexSeleccionado) return 'incorrecto';
    return 'normal';
  }
}

class _BotonOpcion extends StatefulWidget {
  final String letra;
  final String texto;
  final VoidCallback? onTap;
  final String estadoFeedback;
  final double alto;
  const _BotonOpcion(this.letra, this.texto, this.onTap, this.estadoFeedback, this.alto);
  @override State<_BotonOpcion> createState() => _BotonOpcionState();
}

class _BotonOpcionState extends State<_BotonOpcion> {
  bool _isPressed = false;
  @override Widget build(BuildContext context) {
    Color? colorBorde;
    Color colorFondo = Colors.white;
    if (widget.estadoFeedback == 'correcto') { colorBorde = Colors.green; colorFondo = Colors.green.shade100; }
    else if (widget.estadoFeedback == 'incorrecto') { colorBorde = Colors.red; colorFondo = Colors.red.shade100; }

    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0, duration: const Duration(milliseconds: 100),
        child: Container(
          height: widget.alto,
          decoration: BoxDecoration(
            color: colorFondo,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: colorBorde ?? const Color(0xFF9C6A3A), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFF9C6A3A), width: 1))),
                child: Text(widget.letra.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF3E2712))),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(widget.texto, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 11, color: Color(0xFF2C1A0B)), maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ).animate(target: widget.estadoFeedback != 'normal' ? 1 : 0).scaleXY(end: 1.05, duration: 300.ms),
      ),
    );
  }
}