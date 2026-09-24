import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tesoro_model.dart';
import '../../providers/game_provider.dart';
import '../../providers/tesoros_provider.dart';
import 'tesoro_conseguido_screen.dart';

// --- NUEVA ANIMACIÓN DEL TÍTULO: FLOTACIÓN 3D Y ROTACIÓN SUAVE ---
class FloatingTitleAnimation extends StatefulWidget {
  final Widget child;
  const FloatingTitleAnimation({super.key, required this.child});

  @override
  State<FloatingTitleAnimation> createState() => _FloatingTitleAnimationState();
}

class _FloatingTitleAnimationState extends State<FloatingTitleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moveAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    // Animación cíclica de 3 segundos
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    
    // Movimiento vertical suave (flote de arriba a abajo)
    _moveAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    // Rotación muy sutil para dar efecto de balanceo orgánico
    _rotateAnimation = Tween<double>(begin: -0.015, end: 0.015).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _moveAnimation.value),
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

// --- ANIMACIÓN DEL RECUADRO CENTRAL: RESPLANDOR CADA 3 SEGUNDOS ---
class PeriodicGlowBox extends StatefulWidget {
  final Widget child;
  final BorderRadius borderRadius;

  const PeriodicGlowBox({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  State<PeriodicGlowBox> createState() => _PeriodicGlowBoxState();
}

class _PeriodicGlowBoxState extends State<PeriodicGlowBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _glowAnimation = Tween<double>(begin: 0.0, end: 24.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _controller.forward().then((_) => _controller.reverse());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFF0B3).withValues(alpha: _glowAnimation.value > 0 ? 0.75 : 0.0),
                blurRadius: _glowAnimation.value,
                spreadRadius: _glowAnimation.value * 0.35,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// --- TARJETA DE CATEGORÍA: REBOTE ---
class BouncingCard extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const BouncingCard({super.key, required this.imagePath, required this.onTap});

  @override
  State<BouncingCard> createState() => _BouncingCardState();
}

class _BouncingCardState extends State<BouncingCard> {
  bool _isPressed = false;
  bool _pulse = false;

  void _handleTapUp() {
    setState(() {
      _isPressed = false;
      _pulse = true;
    });
    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted) setState(() => _pulse = false);
    });
    Future.delayed(const Duration(milliseconds: 260), widget.onTap);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.9 : (_pulse ? 1.14 : 1.0);
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => _handleTapUp(),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: _pulse ? 140 : 100),
        curve: _pulse ? Curves.easeOut : Curves.easeIn,
        child: Image.asset(widget.imagePath, fit: BoxFit.contain),
      ),
    );
  }
}

// --- PANTALLA PRINCIPAL ---
class TesorosCategoriaScreen extends ConsumerWidget {
  const TesorosCategoriaScreen({super.key});

  static const Map<String, String> _nombresRecursos = {
    'recursos_medicinales': 'Recursos medicinales',
    'alimentos': 'Alimentos',
    'materias_primas': 'Materias primas',
    'energias_renovables': 'Energías renovables',
    'agua_dulce': 'Suministro de agua dulce',
    'calidad_del_aire': 'Regulación de la calidad del aire',
    'recursos_ornamentales': 'Recursos ornamentales',
    'captura_de_carbono': 'Captura de carbono',
    'regulacion_del_clima': 'Regulación del clima',
    'calidad_del_agua': 'Regulación de la calidad del agua',
    'riesgos_naturales': 'Moderación de riesgos naturales',
    'control_erosion': 'Control de la erosión',
    'fertilidad_del_suelo': 'Mantenimiento de la fertilidad del suelo',
    'enfermedades_y_plagas': 'Control natural de plagas',
    'polinizacion': 'Polinización',
    'habitat': 'Hábitat',
    'diversidad_genetica': 'Conservación genética',
    'ecoturismo': 'Ecoturismo',
    'recreacion': 'Recreación',
    'valores_esteticos': 'Valores estéticos',
    'cultural_y_patrimonio': 'Identidad y patrimonio',
    'espirituales_y_religiosos': 'Valores espirituales',
    'ciencia_y_educacion': 'Ciencia y educación',
    'salud_y_bienestar': 'Salud y bienestar',
  };

  void _elegir(BuildContext context, WidgetRef ref, TesoroMision mision, CategoriaEcosistemica elegida) {
    if (elegida == mision.categoria) {
      final actuales = ref.read(tesorosDescubiertosProvider);
      if (!actuales.contains(mision.id)) {
        ref.read(tesorosDescubiertosProvider.notifier).state = [...actuales, mision.id];
      }
      ref.read(coinsProvider.notifier).state += 15;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const TesoroConseguidoScreen()));
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFFFFF8EC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFF8B5A2B), width: 4)),
          title: const Text('Casi...', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5C3A1E), fontWeight: FontWeight.w900, fontSize: 24)),
          content: Text(
            'Este tesoro en realidad es un servicio de ${mision.categoria.nombre}. ¡Inténtalo con otra categoría!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD98E41), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mision = ref.watch(misionActualProvider);
    final coins = ref.watch(coinsProvider);

    if (mision == null) return const Scaffold(body: SizedBox.shrink());

    final nombreArchivo = mision.recursoId;
    final nombreRecurso = _nombresRecursos[nombreArchivo] ?? mision.nombreTesoro;
    final size = MediaQuery.of(context).size;
    final scale = size.width / 400;

    // CONDICIÓN: Si el texto es mayor a 20 caracteres, es considerado largo.
    final bool isLongText = nombreRecurso.length > 20;
    // Reduce la fuente si es largo, para que salte de línea sin verse desproporcionado
    final double textFontSize = isLongText ? 12.0 * scale : 15.0 * scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // 1. FONDO PANTALLA COMPLETA
            Image.asset('assets/images/fondo_categoria.png', fit: BoxFit.fill, width: size.width, height: size.height),

            // 2. TÍTULO CON FLOTACIÓN 3D
            Positioned(
              top: size.height * 0.12,
              left: size.width * 0.10,
              right: size.width * 0.10,
              height: size.height * 0.15,
              child: FloatingTitleAnimation(
                child: Image.asset('assets/images/titulo_pregunta.png', fit: BoxFit.contain),
              ),
            ),

            // 3. CUADRO DE MADERA Y RECURSO
            Positioned(
              top: size.height * 0.28,
              left: size.width * 0.15,
              right: size.width * 0.15,
              height: size.height * 0.24,
              child: PeriodicGlowBox(
                borderRadius: BorderRadius.circular(18),
                child: LayoutBuilder(
                  builder: (context, marco) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset('assets/images/marco_tesoro.png', fit: BoxFit.fill, width: double.infinity, height: double.infinity),
                        
                        Positioned(
                          top: marco.maxHeight * 0.09,
                          bottom: marco.maxHeight * 0.26,
                          child: Image.asset(
                            'assets/images/tesoros/$nombreArchivo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const Icon(Icons.park, color: Colors.green, size: 60),
                          ),
                        ),

                        // TEXTO DINÁMICO Y SUBIDO DE POSICIÓN
                        Positioned(
                          bottom: marco.maxHeight * 0.125, // <-- Subido un poco para que no toque el borde
                          left: marco.maxWidth * 0.10,
                          right: marco.maxWidth * 0.10,
                          child: Center(
                            child: Text(
                              nombreRecurso,
                              textAlign: TextAlign.center,
                              maxLines: isLongText ? 2 : 1, // Permite 2 líneas si es largo
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: textFontSize, 
                                height: 1.05, // Espaciado entre líneas apretado
                                fontWeight: FontWeight.w900, 
                                shadows: const [Shadow(color: Colors.black54, offset: Offset(1.5, 1.5), blurRadius: 2)]
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // 4. TARJETAS DE CATEGORÍAS
            Positioned(
              top: size.height * 0.565,
              left: size.width * 0.10,
              width: size.width * 0.34,
              child: BouncingCard(
                imagePath: 'assets/images/cat_provision.png',
                onTap: () => _elegir(context, ref, mision, CategoriaEcosistemica.provision),
              ),
            ),
            Positioned(
              top: size.height * 0.565,
              right: size.width * 0.10,
              width: size.width * 0.34,
              child: BouncingCard(
                imagePath: 'assets/images/cat_regulacion.png',
                onTap: () => _elegir(context, ref, mision, CategoriaEcosistemica.regulacion),
              ),
            ),
            Positioned(
              top: size.height * 0.695,
              left: size.width * 0.10,
              width: size.width * 0.34,
              child: BouncingCard(
                imagePath: 'assets/images/cat_soporte.png',
                onTap: () => _elegir(context, ref, mision, CategoriaEcosistemica.soporte),
              ),
            ),
            Positioned(
              top: size.height * 0.695,
              right: size.width * 0.10,
              width: size.width * 0.34,
              child: BouncingCard(
                imagePath: 'assets/images/cat_cultural.png',
                onTap: () => _elegir(context, ref, mision, CategoriaEcosistemica.cultural),
              ),
            ),

            // 5. BARRA SUPERIOR
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset('assets/images/botonatras.png', width: 65, height: 65),
                  ),
                  Container(
                    height: 48,
                    width: 140,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/coin_bg.png'), fit: BoxFit.contain),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 35),
                    child: Text(
                      '$coins',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
