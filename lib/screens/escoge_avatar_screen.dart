import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/avatar_model.dart';
import '../providers/game_provider.dart';

// ============================================================
// PALETA PREMIUM
// ============================================================
class _C {
  static const woodLightest = Color(0xFFE0B584);
  static const woodLight = Color(0xFFC08850);
  static const woodMid = Color(0xFF8B5A2B);
  static const woodDark = Color(0xFF5C3A1E);
  static const woodShadow = Color(0xFF2E1A0A);
  static const woodDeep = Color(0xFF1A0E04);
  static const goldBright = Color(0xFFFFE08A);
  static const gold = Color(0xFFF2C94C);
  static const goldDark = Color(0xFFB8860B);
  static const goldDeep = Color(0xFF7A5800);
  static const leaf = Color(0xFF6FB54A);
  static const leafDark = Color(0xFF3A6B22);
  static const leafDeep = Color(0xFF1E3A10);
  static const cream = Color(0xFFFFF8EC);
  static const creamDark = Color(0xFFE8D4B0);
  static const red = Color(0xFFD9342B);
  static const redDark = Color(0xFF8B1F1A);
  static const blueLight = Color(0xFF8BCFF0);
  static const blue = Color(0xFF4A90B8);
}

class EscogeAvatarScreen extends ConsumerStatefulWidget {
  const EscogeAvatarScreen({super.key});
  @override
  ConsumerState<EscogeAvatarScreen> createState() => _EscogeAvatarScreenState();
}

class _EscogeAvatarScreenState extends ConsumerState<EscogeAvatarScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  String? _avatarPendiente;
  bool _editando = false;

  late AnimationController _entranceCtrl;
  late AnimationController _glowCtrl;

  @override
  void initState() {
    super.initState();
    _nameController.text = ref.read(playerNameProvider);
    _avatarPendiente = ref.read(selectedAvatarProvider);

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _entranceCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  void _guardarNombre() {
    final n = _nameController.text.trim();
    ref.read(playerNameProvider.notifier).state = n.isEmpty ? 'Jugador' : n;
    setState(() => _editando = false);
    _snack('Nombre guardado', _C.leaf);
  }

  void _seleccionar(AvatarModel a) => setState(() => _avatarPendiente = a.id);

  void _comprar(AvatarModel a) {
    final coins = ref.read(coinsProvider);
    if (coins < a.cost) {
      _snack('No tienes suficientes hojas doradas', _C.red);
      return;
    }
    ref.read(coinsProvider.notifier).state = coins - a.cost;
    final u = ref.read(unlockedAvatarsProvider);
    ref.read(unlockedAvatarsProvider.notifier).state = [...u, a.id];
    ref.read(selectedAvatarProvider.notifier).state = a.id;
    setState(() => _avatarPendiente = a.id);
    _snack('¡${a.name} desbloqueado!', _C.leaf);
  }

  void _jugar() {
    if (_avatarPendiente == null) return;
    ref.read(selectedAvatarProvider.notifier).state = _avatarPendiente!;
    Navigator.of(context).pop();
  }

  void _snack(String m, Color c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m, textAlign: TextAlign.center),
        backgroundColor: c,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = ref.watch(unlockedAvatarsProvider);
    final coins = ref.watch(coinsProvider);

    final ninos = catalogoAvatares.where((a) => a.genero == 'niño').toList();
    final ninas = catalogoAvatares.where((a) => a.genero == 'niña').toList();

    final pend = _avatarPendiente;
    final avatarPend = pend == null ? null : catalogoAvatares.firstWhere((a) => a.id == pend);
    final estaDesbloqueado = pend != null && unlocked.contains(pend);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset(
            'assets/images/Fondohome.webp',
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(color: const Color(0xFF3A5A2A)),
          ),

          // Capa de luz volumétrica (rayos suaves desde arriba)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.7),
                    radius: 1.2,
                    colors: [
                      _C.goldBright.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Marco ornamental
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _FramePainter()),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTop(coins),
                const SizedBox(height: 2),
                _buildNombreJugador(),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildBanner('NIÑOS'),
                        const SizedBox(height: 14),
                        _buildGrid(ninos, unlocked, pend),
                        const SizedBox(height: 26),
                        _buildBanner('NIÑAS'),
                        const SizedBox(height: 14),
                        _buildGrid(ninas, unlocked, pend),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 22,
            left: 0,
            right: 0,
            child: Center(child: _buildAccion(avatarPend, estaDesbloqueado, coins)),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP
  // ------------------------------------------------------------
  Widget _buildTop(int coins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/images/botonatras.webp',
              width: 54,
              height: 54,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(Icons.arrow_back, size: 32),
            ),
          ),
          const Spacer(),
          _buildMonedaPill(coins),
        ],
      ),
    );
  }

  Widget _buildMonedaPill(int coins) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_C.woodLight, _C.woodDark],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _C.woodShadow, width: 2.5),
        boxShadow: [
          const BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
          BoxShadow(color: _C.goldBright.withValues(alpha: 0.25), blurRadius: 8, spreadRadius: 1),
          const BoxShadow(color: Colors.white30, blurRadius: 1, offset: Offset(0, -1)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Medallón de la moneda
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [_C.goldBright, _C.gold, _C.goldDeep],
                stops: [0.0, 0.6, 1.0],
              ),
              border: Border.all(color: _C.woodShadow, width: 2),
              boxShadow: [
                BoxShadow(
                  color: _C.goldBright.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                const BoxShadow(color: Colors.black45, blurRadius: 3, offset: Offset(0, 2)),
              ],
            ),
            child: const Icon(Icons.eco_rounded, color: _C.woodShadow, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            '$coins',
            style: const TextStyle(
              color: _C.cream,
              fontWeight: FontWeight.w900,
              fontSize: 17,
              letterSpacing: 0.5,
              shadows: [
                Shadow(color: Colors.black, offset: Offset(1.5, 1.5), blurRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // NOMBRE
  // ------------------------------------------------------------
  Widget _buildNombreJugador() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_C.woodLightest, _C.woodLight, _C.woodDark],
            stops: [0.0, 0.4, 1.0],
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: _C.woodShadow, width: 3),
          boxShadow: [
            const BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5)),
            BoxShadow(color: _C.goldBright.withValues(alpha: 0.2), blurRadius: 6, spreadRadius: 1),
            const BoxShadow(color: Colors.white30, blurRadius: 1, offset: Offset(0, -1)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [_C.cream, _C.creamDark],
                ),
                border: Border.all(color: _C.woodShadow, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 1)),
                ],
              ),
              child: const Icon(Icons.person_rounded, color: _C.woodDark, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              'TU NOMBRE:',
              style: TextStyle(
                color: _C.cream,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.8,
                shadows: [
                  Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 1),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _editando
                  ? TextField(
                      controller: _nameController,
                      autofocus: true,
                      maxLength: 15,
                      onSubmitted: (_) => _guardarNombre(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        counterText: '',
                        border: InputBorder.none,
                        hintText: 'Escribe tu nombre',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    )
                  : Text(
                      _nameController.text.isEmpty ? 'Escribe tu nombre' : _nameController.text,
                      style: TextStyle(
                        color: _nameController.text.isEmpty ? Colors.white70 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        shadows: const [
                          Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1),
                        ],
                      ),
                    ),
            ),
            IconButton(
              onPressed: _editando ? _guardarNombre : () => setState(() => _editando = true),
              icon: Icon(
                _editando ? Icons.check_rounded : Icons.edit_rounded,
                color: _C.cream,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BANNER PREMIUM (placa + hojas + brillo)
  // ------------------------------------------------------------
  Widget _buildBanner(String titulo) {
    return SizedBox(
      height: 60,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Hojas a los lados
          Positioned(left: -14, top: 2, child: _Hoja(size: 34, rot: -0.5)),
          Positioned(left: 6, top: 14, child: _Hoja(size: 22, rot: -0.2)),
          Positioned(right: -14, top: 2, child: _Hoja(size: 34, rot: 0.5, flip: true)),
          Positioned(right: 6, top: 14, child: _Hoja(size: 22, rot: 0.2, flip: true)),

          // Placa central
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_C.woodLightest, _C.woodLight, _C.woodDark],
                stops: [0.0, 0.45, 1.0],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: _C.woodShadow, width: 3),
              boxShadow: [
                const BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5)),
                BoxShadow(color: _C.goldBright.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1),
                const BoxShadow(color: Colors.white30, blurRadius: 1, offset: Offset(0, -1)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded, color: _C.goldBright, size: 16),
                const SizedBox(width: 10),
                Text(
                  titulo,
                  style: const TextStyle(
                    color: _C.cream,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    shadows: [
                      Shadow(color: Colors.black87, offset: Offset(1.5, 1.5), blurRadius: 2),
                      Shadow(color: Color(0xFFFFE5B4), offset: Offset(-0.5, -0.5), blurRadius: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.auto_awesome_rounded, color: _C.goldBright, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // GRID con animación de entrada
  // ------------------------------------------------------------
  Widget _buildGrid(List<AvatarModel> avatares, List<String> unlocked, String? pend) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.75,
      children: List.generate(avatares.length, (i) {
        final a = avatares[i];
        final delay = (i * 0.08).clamp(0.0, 0.5);
        return AnimatedBuilder(
          animation: _entranceCtrl,
          builder: (context, child) {
            final t = ((_entranceCtrl.value - delay) / (1 - delay)).clamp(0.0, 1.0);
            final curve = Curves.easeOutBack.transform(t);
            return Opacity(
              opacity: t.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: curve,
                child: child,
              ),
            );
          },
          child: _buildCard(a, unlocked.contains(a.id), pend == a.id),
        );
      }),
    );
  }

  // ------------------------------------------------------------
  // CARD PREMIUM
  // ------------------------------------------------------------
  Widget _buildCard(AvatarModel avatar, bool desbloqueado, bool seleccionado) {
    return GestureDetector(
      onTap: () => _seleccionar(avatar),
      child: AnimatedScale(
        scale: seleccionado ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: seleccionado
                  ? [_C.goldBright, _C.gold, _C.goldDark]
                  : [_C.woodLightest, _C.woodLight, _C.woodDark],
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: _C.woodShadow,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.55), blurRadius: 10, offset: Offset(0, 5)),
              // Brillo dorado si está seleccionado
              if (seleccionado)
                BoxShadow(
                  color: _C.goldBright.withValues(alpha: 0.7),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
            ],
          ),
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: seleccionado ? _C.woodDeep : _C.woodShadow,
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Imagen
                        Image.asset(
                          avatar.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: _C.cream,
                            child: const Icon(Icons.person, size: 40, color: _C.woodDark),
                          ),
                        ),

                        // Oscurecer si está bloqueado
                        if (!desbloqueado)
                          Container(
                            color: Colors.black.withValues(alpha: 0.6),
                          ),

                        // Brillo de esquina (siempre)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 30,
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.25),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Candado si bloqueado
                        if (!desbloqueado)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: _CandadoPremium(),
                          ),



                        // Check si seleccionado
                        if (seleccionado)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                gradient: const RadialGradient(
                                  colors: [_C.goldBright, _C.gold],
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: _C.woodDeep, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _C.goldBright.withValues(alpha: 0.7),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.check_rounded, color: _C.woodDeep, size: 13),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Nombre
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_C.cream, _C.creamDark],
                      ),
                    ),
                    child: Text(
                      avatar.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: _C.woodDeep,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Estado
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: desbloqueado
                            ? [_C.leaf, _C.leafDark]
                            : [_C.gold, _C.goldDark],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!desbloqueado) ...[
                          const Icon(Icons.eco_rounded, color: Colors.white, size: 11),
                          const SizedBox(width: 3),
                        ] else ...[
                          const Icon(Icons.check_circle_rounded, color: Colors.white, size: 11),
                          const SizedBox(width: 3),
                        ],
                        Text(
                          desbloqueado ? 'TUYO' : '${avatar.cost}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.4,
                            shadows: [
                              Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1),
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
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTÓN ACCIÓN
  // ------------------------------------------------------------
  Widget _buildAccion(AvatarModel? avatar, bool desbloqueado, int coins) {
    if (avatar == null) return const SizedBox.shrink();

    if (desbloqueado) {
      return _BtnAsset(
        asset: 'assets/images/btn_jugar.webp',
        onTap: _jugar,
        width: 240,
        glow: _C.leaf,
      );
    }

    final puede = coins >= avatar.cost;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!puede)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_C.red, _C.redDark],
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Text(
              'Te faltan ${avatar.cost - coins} hojas',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                shadows: [
                  Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1),
                ],
              ),
            ),
          ),
        _BtnAsset(
          asset: 'assets/images/btn_comprar.webp',
          onTap: puede ? () => _comprar(avatar) : null,
          width: 240,
          opacity: puede ? 1.0 : 0.5,
          glow: _C.gold,
        ),
      ],
    );
  }
}

// ============================================================
// BOTÓN CON ASSET + BRILLO
// ============================================================
class _BtnAsset extends StatefulWidget {
  final String asset;
  final VoidCallback? onTap;
  final double width;
  final double opacity;
  final Color glow;
  const _BtnAsset({
    required this.asset,
    required this.onTap,
    this.width = 220,
    this.opacity = 1.0,
    this.glow = _C.gold,
  });
  @override
  State<_BtnAsset> createState() => _BtnAssetState();
}

class _BtnAssetState extends State<_BtnAsset> {
  bool _p = false;
  @override
  Widget build(BuildContext context) {
    final on = widget.onTap != null;
    return GestureDetector(
      onTapDown: on ? (_) => setState(() => _p = true) : null,
      onTapUp: on
          ? (_) {
              setState(() => _p = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: on ? () => setState(() => _p = false) : null,
      child: AnimatedScale(
        scale: _p ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.opacity,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: widget.width,
            height: widget.width * 0.38,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: widget.glow.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Image.asset(
              widget.asset,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Container(
                decoration: BoxDecoration(
                  color: _C.leaf,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: _C.woodShadow, width: 3),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.asset.contains('comprar') ? 'COMPRAR' : 'JUGAR',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HOJA decorativa premium
// ============================================================
class _Hoja extends StatelessWidget {
  final double size;
  final double rot;
  final bool flip;
  const _Hoja({required this.size, this.rot = 0, this.flip = false});
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rot,
      child: Transform.scale(
        scaleX: flip ? -1 : 1,
        child: Container(
          width: size,
          height: size * 0.62,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_C.leaf, _C.leafDark, _C.leafDeep],
              stops: [0.0, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size * 0.6),
              bottomRight: Radius.circular(size * 0.6),
              topRight: Radius.circular(size * 0.15),
              bottomLeft: Radius.circular(size * 0.15),
            ),
            boxShadow: const [
              BoxShadow(color: Colors.black54, blurRadius: 3, offset: Offset(1, 2)),
            ],
          ),
          // Vena central
          child: CustomPaint(painter: _HojaVenaPainter()),
        ),
      ),
    );
  }
}

class _HojaVenaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = _C.leafDeep.withValues(alpha: 0.4)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.5,
        size.width,
        0,
      );
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ============================================================
// CANDADO PREMIUM
// ============================================================
class _CandadoPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [_C.red, _C.redDark],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          const BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
          BoxShadow(color: _C.red.withValues(alpha: 0.5), blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: const Icon(Icons.lock_rounded, color: Colors.white, size: 13),
    );
  }
}

// ============================================================
// MARCO ORNAMENTAL DE LA PANTALLA
// ============================================================
class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Marco exterior dorado sutil
    final borderPaint = Paint()
      ..color = _C.gold.withValues(alpha: 0.35)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTRB(8, 8, size.width - 8, size.height - 8);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(24));
    canvas.drawRRect(rrect, borderPaint);

    // Esquinas decorativas (arcos dorados)
    final cornerPaint = Paint()
      ..color = _C.goldBright.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Esquina superior izquierda
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(24, 24), radius: 16),
      math.pi,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Esquina superior derecha
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - 24, 24), radius: 16),
      -math.pi / 2,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Esquina inferior izquierda
    canvas.drawArc(
      Rect.fromCircle(center: Offset(24, size.height - 24), radius: 16),
      3 * math.pi / 2,
      math.pi / 2,
      false,
      cornerPaint,
    );

    // Esquina inferior derecha
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - 24, size.height - 24), radius: 16),
      0,
      math.pi / 2,
      false,
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}