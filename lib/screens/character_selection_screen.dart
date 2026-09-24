import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/avatar.dart';
import '../providers/game_provider.dart';
import 'home_screen.dart';

class CharacterSelectionScreen extends ConsumerWidget {
  final bool esCambioAvatar;
  const CharacterSelectionScreen({super.key, this.esCambioAvatar = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 5),
                _TopBar(),
                const SizedBox(height: 5),
                Image.asset('assets/images/title.png', height: 100, fit: BoxFit.contain)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(delay: 3.seconds, duration: 1.seconds, color: Colors.white54),
                const SizedBox(height: 10),
                const _NameField(),
                const SizedBox(height: 5),
                Expanded(child: _BoardSection()),
                const SizedBox(height: 5),
                _PlayButton(esCambioAvatar: esCambioAvatar),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(coinsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Container(
            height: 48,
            width: 140,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/coin_bg.png'),
                fit: BoxFit.contain,
              ),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 35),
            child: Text(
              '$coins',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _NameField extends ConsumerStatefulWidget {
  const _NameField();
  @override
  ConsumerState<_NameField> createState() => _NameFieldState();
}

class _NameFieldState extends ConsumerState<_NameField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(playerNameProvider));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 410,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/name_bg.png', fit: BoxFit.contain),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: 185, right: 115, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ClipRect(
                  child: TextField(
                    controller: _controller,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.brown,
                      height: 1.2,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tu nombre...',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => ref.read(playerNameProvider.notifier).state = value,
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

class _BoardSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.92,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/board.png', fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(flex: 12),
                  Expanded(flex: 36, child: _AvatarHorizontalList(avatars: kBoyAvatars)),
                  const Spacer(flex: 9),
                  Expanded(flex: 36, child: _AvatarHorizontalList(avatars: kGirlAvatars)),
                  const Spacer(flex: 7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarHorizontalList extends StatelessWidget {
  final List<AvatarData> avatars;
  const _AvatarHorizontalList({required this.avatars});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final double scaleCorrection = avatar.id == 'boy_2' ? 0.92 : 1.0;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Consumer(builder: (context, ref, _) {
            final isUnlocked = ref.watch(unlockedAvatarsProvider).contains(avatar.id);
            final isSelected = ref.watch(selectedAvatarProvider) == avatar.id;

            return GestureDetector(
              onTap: () => ref.read(selectedAvatarProvider.notifier).state = avatar.id,
              child: AspectRatio(
                aspectRatio: 0.70,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Positioned.fill(
                      child: Transform.scale(
                        scale: scaleCorrection,
                        child: Image.asset(avatar.imageAsset, fit: BoxFit.contain)
                            .animate(target: isSelected ? 1 : 0)
                            .scaleXY(end: 1.08, duration: 200.ms)
                            .shimmer(duration: 500.ms),
                      ),
                    ),

                    // Candado si está bloqueado
                    AnimatedSwitcher(
                      duration: 400.ms,
                      transitionBuilder: (child, animation) => ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      ),
                      child: !isUnlocked
                          ? Padding(
                              key: const ValueKey('locked'),
                              padding: const EdgeInsets.only(top: 10, right: 10),
                              child: Image.asset('assets/images/candado.png', width: 24),
                            )
                          : const SizedBox.shrink(key: ValueKey('unlocked')),
                    ),

                    // Precio bloqueado (pastilla dorada flotante)
                    if (!isUnlocked && avatar.price > 0)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFFFFE08A), Color(0xFFF2C94C), Color(0xFFB8860B)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFF3E2712), width: 1.8),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2)),
                              BoxShadow(color: Color(0x80FFE08A), blurRadius: 6, spreadRadius: 1),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.eco_rounded, color: Color(0xFF3E2712), size: 12),
                              const SizedBox(width: 3),
                              Text(
                                '${avatar.price}',
                                style: const TextStyle(
                                  color: Color(0xFF3E2712),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(color: Colors.white70, offset: Offset(0.5, 0.5), blurRadius: 1),
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
          }),
        );
      },
    );
  }
}
class _PlayButton extends ConsumerWidget {
  final bool esCambioAvatar;
  const _PlayButton({required this.esCambioAvatar});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedAvatarProvider);
    final name = ref.watch(playerNameProvider);
    final unlockedAvatars = ref.watch(unlockedAvatarsProvider);
    final coins = ref.watch(coinsProvider);

    final avatarSeleccionado = buscarAvatarPorId(selectedId);
    final isUnlocked = unlockedAvatars.contains(selectedId);
    final canAdvance = name.trim().isNotEmpty && isUnlocked;

    final btnImage = isUnlocked ? 'assets/images/btn_jugar.png' : 'assets/images/btn_comprar.png';

    void handleTap() {
      if (canAdvance) {
        if (esCambioAvatar) {
          Navigator.of(context).pop();
          return;
        }
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 750),
            pageBuilder: (_, __, ___) => const HomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      } else if (!isUnlocked && avatarSeleccionado != null) {
        final cost = avatarSeleccionado.price;
        if (coins >= cost) {
          ref.read(coinsProvider.notifier).state = coins - cost;
          ref.read(unlockedAvatarsProvider.notifier).state = [...unlockedAvatars, selectedId];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No tienes suficientes monedas', textAlign: TextAlign.center)),
          );
        }
      }
    }

    return GestureDetector(
      onTap: handleTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 240),
        child: AnimatedSwitcher(
          duration: 400.ms,
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Image.asset(btnImage, key: ValueKey(btnImage), height: 80, fit: BoxFit.contain),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(begin: 1.0, end: 1.04, duration: 1200.ms),
      ),
    );
  }
}







