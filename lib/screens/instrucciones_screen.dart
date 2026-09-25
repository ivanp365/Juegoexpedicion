import 'package:flutter/material.dart';
import '../widgets/bottom_menu_bar.dart';
import '../widgets/pantalla_header.dart';
import '../widgets/bgm_scope.dart';
import '../providers/audio_manager.dart';

class InstruccionesScreen extends StatefulWidget {
  final ContextoJuego juego;
  const InstruccionesScreen({super.key, required this.juego});
  @override
  State<InstruccionesScreen> createState() => _InstruccionesScreenState();
}

class _InstruccionesScreenState extends State<InstruccionesScreen> {
  Map<String, dynamic> get _contenido {
    switch (widget.juego) {
      case ContextoJuego.clasificacion:
        return {
          'titulo': 'Clasificación',
          'imagen': 'assets/images/letreroclasificacion.webp',
          'pasos': [
            'Arrastra cada residuo hacia el contenedor correcto: blanco (aprovechables), verde (orgánicos), rojo (peligrosos) o negro (no aprovechables).',
            'Si aciertas, ganas 50 hojas doradas y pasas al siguiente residuo.',
            'Si fallas, se activa una Pregunta Salvavidas: respóndela bien para salvarte y ganar 15 hojas doradas.',
            'Si también fallas la pregunta, pierdes un corazón. ¡Cuidado, solo tienes 3!',
            'Clasifica los 6 residuos de la ronda para completar el nivel.',
          ],
        };
      case ContextoJuego.lombricarrera:
        return {
          'titulo': 'Lombricarrera',
          'imagen': 'assets/images/cardlombricarrera1.webp',
          'pasos': [
            'Avanza por el tablero respondiendo correctamente preguntas ambientales.',
            'Compite contra la IA o contra otro jugador para llegar primero a la meta.',
            'Cada respuesta correcta te da un impulso para avanzar en la carrera.',
            'Usa las cartas especiales para frenar a tus rivales o impulsarte.',
            'Gana la partida para conseguir hojas doradas y desbloquear logros.',
          ],
        };
      case ContextoJuego.minijuegos:
        return {
          'titulo': 'Minijuegos',
          'imagen': 'assets/images/letrerominijuegos.webp',
          'pasos': [
            'Elige entre los distintos minijuegos disponibles desde el menú principal.',
            'Cada uno te ayuda a aprender sobre el cuidado del medio ambiente.',
            'Gana hojas doradas para desbloquear nuevos avatares y niveles.',
            'Completa logros para conseguir insignias especiales.',
          ],
        };
      case ContextoJuego.home:
        return {
          'titulo': 'Expedición Ambiental',
          'imagen': 'assets/images/letreroexpedicionambiental.webp',
          'pasos': [
            'Explora los 3 minijuegos: Clasificatón, LombriCarrera y Tesoros Ambientales.',
            'Gana hojas doradas para desbloquear avatares y niveles.',
            'Completa logros para conseguir insignias especiales.',
            'Personaliza tu avatar y nombre desde el botón central del menú.',
            'Revisa tus logros para saber qué te falta por conseguir.',
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _contenido;
    final titulo = (c['titulo'] as String?) ?? '';
    final imagen = (c['imagen'] as String?) ?? '';
    final pasos = (c['pasos'] as List<String>?) ?? <String>[];

    return BgmScope(mode: BgmMode.menu, child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Fondohome.webp',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFB8E0A0)),
          ),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Instrucciones'),
                const SizedBox(height: 8),
                if (imagen.isNotEmpty)
                  Image.asset(
                    imagen,
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6B4423),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (titulo.isNotEmpty)
                            Text(
                              titulo,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF3E2712),
                              ),
                            ),
                          if (titulo.isNotEmpty) const SizedBox(height: 12),
                          if (pasos.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Pronto tendrás instrucciones para este modo de widget.juego.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF3E2712),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            ...List.generate(pasos.length, (i) {
                              final paso = pasos[i];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF6FCB4B),
                                      ),
                                      child: Text(
                                        '${i + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        paso,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF3E2712),
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                BottomMenuBar(juegoActual: widget.juego),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}