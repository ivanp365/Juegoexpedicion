import 'package:flutter/material.dart';
import '../widgets/bottom_menu_bar.dart';
import '../widgets/pantalla_header.dart';

class InstruccionesScreen extends StatelessWidget {
  final ContextoJuego juego;
  const InstruccionesScreen({super.key, required this.juego});

  Map<String, dynamic> get _contenido {
    switch (juego) {
      case ContextoJuego.clasificacion:
        return {
          'titulo': 'Clasificacion',
          'imagen': 'assets/images/letreroclasificacion.png',
          'pasos': [
            'Arrastra cada residuo hacia el contenedor correcto: blanco (aprovechables), verde (orgÃ¡nicos), rojo (peligrosos) o negro (no aprovechables).',
            'Si aciertas, ganas 50 hojas doradas y pasas al siguiente residuo.',
            'Si fallas, se activa una Pregunta Salvavidas: respÃ³ndela bien para salvarte y ganar 15 hojas doradas.',
            'Si tambiÃ©n fallas la pregunta, pierdes un corazÃ³n. Â¡Cuidado, solo tienes 3!',
            'Clasifica los 6 residuos de la ronda para completar el nivel.',
          ],
        };
      case ContextoJuego.lombricarrera:
        return {
          'titulo': 'Lombricarrera',
          'imagen': 'assets/images/cardlombricarrera1.png',
          'pasos': [
            'Avanza por el tablero respondiendo correctamente preguntas ambientales.',
            'Compite contra la IA o contra otro jugador para llegar primero a la meta.',
            'Cada respuesta correcta te da un impulso para avanzar en la carrera.',
          ],
        };
      case ContextoJuego.minijuegos:
        return {
          'titulo': 'Minijuegos',
          'imagen': 'assets/images/letrerominijuegos.png',
          'pasos': [
            'Elige entre los distintos minijuegos disponibles.',
            'Cada uno te ayuda a aprender sobre el cuidado del medio ambiente.',
            'Gana hojas doradas para desbloquear nuevos avatares.',
          ],
        };
      case ContextoJuego.home:
        return {
          'titulo': 'Expedicion Ambiental',
          'imagen': 'assets/images/letreroexpedicionambiental.png',
          'pasos': [
            'Explora los 3 minijuegos: Clasificaton, LombriCarrera y Tesoros Ambientales.',
            'Gana hojas doradas para desbloquear avatares y niveles.',
            'Completa logros para conseguir insignias especiales.',
            'Personaliza tu avatar y nombre desde el boton central del menu.',
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _contenido;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/Fondohome.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const PantallaHeader(titulo: 'Instrucciones'),
                const SizedBox(height: 8),
                if ((c['imagen'] as String).isNotEmpty)
                  Image.asset(c['imagen'] as String,
                      height: 70, fit: BoxFit.contain),
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
                            color: const Color(0xFF6B4423), width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['titulo'] as String,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF3E2712))),
                          const SizedBox(height: 12),
                          ...List.generate((c['pasos'] as List<String>).length,
                              (i) {
                            final paso = (c['pasos'] as List<String>)[i];
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
                                        color: Color(0xFF6FCB4B)),
                                    child: Text('${i + 1}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13)),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(paso,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF3E2712),
                                              height: 1.3))),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
