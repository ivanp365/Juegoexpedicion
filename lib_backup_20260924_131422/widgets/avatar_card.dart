import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

class AvatarCard extends ConsumerWidget {
  final String avatarId;
  final String name;
  final String imageAsset;
  final int price;

  const AvatarCard({
    super.key,
    required this.avatarId,
    required this.name,
    required this.imageAsset,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos la lista de avatares desbloqueados y monedas desde Riverpod
    final unlockedAvatars = ref.watch(unlockedAvatarsProvider);
    final coins = ref.watch(coinsProvider);
    
    // Verificamos si este avatar ya está desbloqueado
    final isUnlocked = unlockedAvatars.contains(avatarId);

    void handleTap() {
      if (isUnlocked) {
        // Seleccionar avatar activo
        ref.read(selectedAvatarProvider.notifier).state = avatarId;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Avatar $name seleccionado!')),
        );
      } else {
        // Intentar comprar el avatar
        if (coins >= price) {
          // Descontar monedas
          ref.read(coinsProvider.notifier).state = coins - price;
          // Añadir a la lista de desbloqueados
          ref.read(unlockedAvatarsProvider.notifier).state = [...unlockedAvatars, avatarId];
          // Seleccionarlo automáticamente
          ref.read(selectedAvatarProvider.notifier).state = avatarId;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('¡Has desbloqueado a $name!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No tienes suficientes hojas doradas')),
          );
        }
      }
    }

    return GestureDetector(
      onTap: handleTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked ? const Color(0xFF6FCB4B) : const Color(0xFF9C6A3A),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(imageAsset, fit: BoxFit.contain),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF3E2712),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
            if (!isUnlocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, color: Colors.amber, size: 36),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.monetization_on, color: Colors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '$price',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
