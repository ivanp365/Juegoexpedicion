import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import 'tesoros_exploracion_screen.dart';
import '../../providers/audio_manager.dart';

class TesorosMisionScreen extends ConsumerWidget {
  const TesorosMisionScreen({super.key});

  static const double _designWidth = 1000;
  static const double _designHeight = 1575;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mision = ref.watch(misionActualProvider);
    final coins = ref.watch(coinsProvider);

    if (mision == null) {
      return Scaffold(body: Center(child: TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Volver al mapa'))));
    }

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
                    const w = _designWidth;
                    const h = _designHeight;
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset('assets/images/nueva_mision_bg.webp', fit: BoxFit.fill),
                        ),
                        Positioned(
                          top: h * 0.448, left: w * 0.28, right: w * 0.12,
                          child: Text(
                            mision.nombreTesoro, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Positioned(
                          top: h * 0.54, left: w * 0.28, right: w * 0.30,
                          child: Text(
                            mision.descripcion, maxLines: 6, softWrap: true, overflow: TextOverflow.fade,
                            style: const TextStyle(color: Colors.black87, fontSize: 27, height: 1.25),
                          ),
                        ),
                        Positioned(
                          top: h * 0.728, left: w * 0.335, right: w * 0.15,
                          child: Text(
                            mision.pista, maxLines: 3, softWrap: true, overflow: TextOverflow.fade,
                            style: const TextStyle(color: Color(0xFF5C3A1E), fontSize: 22, fontStyle: FontStyle.italic, height: 1.2),
                          ),
                        ),
                        Positioned(
                          top: h * 0.825, left: w * 0.15, right: w * 0.15, height: h * 0.07,
                          child: GestureDetector(
                            onTap: () {
                              AudioManager.playSfx('button_click.wav');
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const TesorosExploracionScreen()),
                              );
                            },
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
          
          // BARRA SUPERIOR AISLADA EN UN SAFEAREA REAL
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
                    Container(
                      height: 44, width: 130,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/images/coin_bg.webp'), fit: BoxFit.contain),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 32),
                      child: Text('$coins', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
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