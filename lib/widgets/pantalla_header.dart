import 'package:flutter/material.dart';

class PantallaHeader extends StatelessWidget {
  final String titulo;
  final VoidCallback? onVolver;
  const PantallaHeader({super.key, required this.titulo, this.onVolver});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: onVolver ?? () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6B4423),
                  border: Border.all(color: Colors.white, width: 2)),
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
          Expanded(
            child: Text(titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
