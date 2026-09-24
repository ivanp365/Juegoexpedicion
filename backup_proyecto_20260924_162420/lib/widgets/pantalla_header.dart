import 'package:flutter/material.dart';
import '../providers/audio_manager.dart';

class PantallaHeader extends StatelessWidget {
  final String titulo;
  final VoidCallback? onVolver;
  final bool mostrarBotonAtras;

  const PantallaHeader({
    super.key,
    required this.titulo,
    this.onVolver,
    this.mostrarBotonAtras = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (mostrarBotonAtras)
            GestureDetector(
              onTap: () {
                AudioManager.playSfx('button_back.wav');
                if (onVolver != null) {
                  onVolver!();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
              child: _BotonAtras(),
            )
          else
            const SizedBox(width: 48),

          Expanded(
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _BotonAtras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/botonatras.webp',
      width: 48,
      height: 48,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6B4423),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 22,
          ),
        );
      },
    );
  }
}