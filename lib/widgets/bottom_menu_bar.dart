import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../models/avatar_model.dart';

import '../screens/escoge_avatar_screen.dart';
import '../screens/instrucciones_screen.dart';
import '../screens/logros_screen.dart';
import '../screens/coleccion_screen.dart';
import '../screens/ajustes_screen.dart';

enum ContextoJuego { home, clasificacion, lombricarrera, minijuegos }

class _MenuColors {
  static const woodLight = Color(0xFFC08850);
  static const woodMid = Color(0xFF8B5A2B);
  static const woodDark = Color(0xFF5C3A1E);
  static const woodShadow = Color(0xFF2E1A0A);
  static const gold = Color(0xFFF2C94C);
  static const goldDark = Color(0xFFB8860B);
  static const leaf = Color(0xFF4A8B3A);
  static const leafDark = Color(0xFF2D5A1F);
  static const cream = Color(0xFFFFF3E0);
}

class BottomMenuBar extends ConsumerWidget {
  final ContextoJuego juegoActual;
  const BottomMenuBar({super.key, required this.juegoActual});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedAvatarProvider);
    final playerName = ref.watch(playerNameProvider);

    final avatarActivo = catalogoAvatares.firstWhere(
      (a) => a.id == selectedId,
      orElse: () => catalogoAvatares.first,
    );

    return Container(
      height: 125,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 78,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _MenuColors.woodLight,
                    _MenuColors.woodMid,
                    _MenuColors.woodDark,
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: _MenuColors.woodShadow, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 5)),
                  BoxShadow(color: Colors.white24, blurRadius: 2, offset: Offset(0, -1)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CustomPaint(painter: _WoodGrainPainter()),
                    ),
                  ),
                  const Positioned(left: -8, top: -8, child: _LeafCluster(rotation: -0.4)),
                  const Positioned(right: -8, top: -8, child: _LeafCluster(rotation: 0.4, flip: true)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: _MenuButton(
                                  image: 'assets/images/icono_instrucciones.webp',
                                  label: 'INSTRUCCIONES',
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => InstruccionesScreen(juego: juegoActual),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: _MenuButton(
                                  image: 'assets/images/icono_logros.webp',
                                  label: 'LOGROS',
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const LogrosScreen()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 74),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: _MenuButton(
                                  image: 'assets/images/icono_coleccion.webp',
                                  label: 'COLECCI\u00D3N',
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ColeccionScreen()),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: _MenuButton(
                                  image: 'assets/images/icono_ajustes.webp',
                                  label: 'AJUSTES',
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AjustesScreen()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EscogeAvatarScreen()),
                  ),
                  customBorder: const CircleBorder(),
                  splashColor: _MenuColors.gold.withValues(alpha: 0.4),
                  highlightColor: _MenuColors.gold.withValues(alpha: 0.2),
                  child: _PlayerMedallion(
                    avatarPath: avatarActivo.imagePath,
                    playerName: playerName.trim().isEmpty ? 'Jugador' : playerName,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerMedallion extends StatelessWidget {
  final String avatarPath;
  final String playerName;
  const _PlayerMedallion({required this.avatarPath, required this.playerName});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_MenuColors.woodLight, _MenuColors.woodDark],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _MenuColors.woodShadow, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
              BoxShadow(color: Colors.white24, blurRadius: 1, offset: Offset(0, -1)),
            ],
          ),
          child: Text(
            playerName,
            style: const TextStyle(
              color: _MenuColors.cream,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
              shadows: [
                Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 1),
              ],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [_MenuColors.gold, _MenuColors.goldDark],
            ),
            boxShadow: [
              const BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
              BoxShadow(
                color: _MenuColors.gold.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(color: _MenuColors.woodShadow, width: 3),
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
              ],
              image: DecorationImage(
                image: AssetImage(avatarPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;
  const _MenuButton({required this.image, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 36,
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) =>
                const Icon(Icons.star, color: _MenuColors.gold, size: 28),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _MenuColors.cream,
              fontSize: 7,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
              shadows: [
                Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafCluster extends StatelessWidget {
  final double rotation;
  final bool flip;
  const _LeafCluster({this.rotation = 0, this.flip = false});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Transform.scale(
        scaleX: flip ? -1 : 1,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            children: [
              Positioned(left: 0, top: 8, child: Transform.rotate(angle: -0.3, child: _SingleLeaf(size: 16, color: _MenuColors.leaf, darkColor: _MenuColors.leafDark))),
              Positioned(left: 10, top: 0, child: Transform.rotate(angle: 0.2, child: _SingleLeaf(size: 18, color: _MenuColors.leaf, darkColor: _MenuColors.leafDark))),
              Positioned(left: 4, top: 18, child: Transform.rotate(angle: -0.5, child: _SingleLeaf(size: 13, color: _MenuColors.leaf, darkColor: _MenuColors.leafDark))),
            ],
          ),
        ),
      ),
    );
  }
}

class _SingleLeaf extends StatelessWidget {
  final double size;
  final Color color;
  final Color darkColor;
  const _SingleLeaf({required this.size, required this.color, required this.darkColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 0.6,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, darkColor],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size * 0.6),
          bottomRight: Radius.circular(size * 0.6),
          topRight: Radius.circular(size * 0.15),
          bottomLeft: Radius.circular(size * 0.15),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 2, offset: Offset(1, 1)),
        ],
      ),
    );
  }
}

class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _MenuColors.woodShadow.withValues(alpha: 0.15)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double y = 10; y < size.height; y += 14) {
      final path = Path()..moveTo(0, y);
      for (double x = 0; x < size.width; x += 20) {
        final wave = (x / 60) % 1 - 0.5;
        path.lineTo(x, y + wave * 2);
      }
      canvas.drawPath(path, paint);
    }

    final knotPaint = Paint()
      ..color = _MenuColors.woodShadow.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.5), 3, knotPaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.4), 2.5, knotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}