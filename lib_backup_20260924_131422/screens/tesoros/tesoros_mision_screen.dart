import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import 'tesoros_exploracion_screen.dart';

class TesorosMisionScreen extends ConsumerWidget {
  const TesorosMisionScreen({super.key});

  static const double _designWidth = 1000;
  static const double _designHeight = 1575;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mision = ref.watch(misionActualProvider);
    final coins = ref.watch(coinsProvider);

    if (mision == null) {
      return Scaffold(
          body: Center(
              child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Volver al mapa'))));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _designWidth / _designHeight,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final scale = constraints.maxWidth / _designWidth;

                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                                'assets/images/nueva_mision_bg.png',
                                fit: BoxFit.fill),
                          ),

                          // 2. TÍTULO DE LA MISIÓN — ya estaba perfecto, sin cambios
                          Positioned(
                            top: constraints.maxHeight * 0.448,
                            left: constraints.maxWidth * 0.28,
                            right: constraints.maxWidth * 0.12,
                            child: Text(
                              mision.nombreTesoro,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30 * scale,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),

                          // 3. DESCRIPCIÓN — letra un poco más grande, MISMO ancho de caja
                          // (left/right sin tocar) para que si no cabe, salte de línea
                          // en vez de ensancharse o desbordar.
                          Positioned(
                            top: constraints.maxHeight * 0.54,
                            left: constraints.maxWidth * 0.28,
                            right: constraints.maxWidth * 0.30,
                            child: Text(
                              mision.descripcion,
                              maxLines: 6,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 27 * scale,
                                height: 1.25,
                              ),
                            ),
                          ),

                          // 4. PISTA — corrida a la derecha (más aire tras el ícono);
                          // el borde derecho (donde termina el texto) NO se movió,
                          // así que ahora tiene menos ancho y salta antes de renglón.
                          Positioned(
                            top: constraints.maxHeight * 0.728,
                            left: constraints.maxWidth * 0.335,
                            right: constraints.maxWidth * 0.15,
                            child: Text(
                              mision.pista,
                              maxLines: 3,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: const Color(0xFF5C3A1E),
                                fontSize: 22 * scale,
                                fontStyle: FontStyle.italic,
                                height: 1.2,
                              ),
                            ),
                          ),

                          // 5. BOTÓN ACEPTAR MISIÓN — el texto ya viene dibujado en la
                          // imagen, así que aquí solo dejamos el área táctil, sin Text.
                          Positioned(
                            top: constraints.maxHeight * 0.825,
                            left: constraints.maxWidth * 0.15,
                            right: constraints.maxWidth * 0.15,
                            height: constraints.maxHeight * 0.07,
                            child: GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const TesorosExploracionScreen()),
                              ),
                              child: Container(color: Colors.transparent),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // 6. BARRA SUPERIOR
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
                  Container(
                    height: 48,
                    width: 140,
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
