import 'package:flutter/material.dart';
import '../../widgets/tesoros_theme.dart';
import '../../widgets/tesoros_widgets.dart';
import 'tesoros_mapa_screen.dart';

class TesorosIntroScreen extends StatelessWidget {
  const TesorosIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TC.woodDeep,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.travel_explore_rounded,
                  color: TC.goldBright, size: 56),
              const SizedBox(height: 16),
              const Text('TESOROS AMBIENTALES',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: TC.cream,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5)),
              const SizedBox(height: 12),
              const Text(
                  'Explora Morasurco y descubre los tesoros\nque la naturaleza nos brinda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: TC.creamDark, fontSize: 14)),
              const SizedBox(height: 28),
              const _PasoJuego(icono: '🗺️', texto: 'Explora'),
              const _PasoJuego(icono: '🔎', texto: 'Resuelve la mision'),
              const _PasoJuego(icono: '💎', texto: 'Encuentra el tesoro'),
              const _PasoJuego(
                  icono: '🌱', texto: 'Descubre su servicio ecosistemico'),
              const SizedBox(height: 24),
              const MascotaBubble(
                  texto: '¡Vamos! Te voy a acompanar en toda la expedicion.'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    // Sin "const" aquí: TesorosMapaScreen no tiene un
                    // constructor const, así que "const TesorosMapaScreen()"
                    // no es una expresión constante válida.
                    builder: (_) => TesorosMapaScreen(),
                    settings: const RouteSettings(name: 'tesoros_mapa'),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TC.leaf,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('COMENZAR EXPEDICION',
                    style: TextStyle(
                        fontWeight: FontWeight.w900, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasoJuego extends StatelessWidget {
  final String icono;
  final String texto;
  const _PasoJuego({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icono, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(texto,
                  style: const TextStyle(color: TC.cream, fontSize: 15))),
        ],
      ),
    );
  }
}
