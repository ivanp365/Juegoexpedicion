import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';
import 'providers/game_provider.dart';
import 'providers/route_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Contexto de audio global: evita que los efectos (SFX) le "roben" el
  // foco de audio al reproductor de música de fondo. Sin esto, en Android
  // cada AudioPlayer nuevo (cada SFX) puede pausar/cortar el player de la
  // música y esta nunca se reanuda sola.
  await AudioPlayer.global.setAudioContext(AudioContext(
    android: AudioContextAndroid(
      isSpeakerphoneOn: false,
      stayAwake: false,
      contentType: AndroidContentType.music,
      usageType: AndroidUsageType.game,
      audioFocus: AndroidAudioFocus.none,
    ),
    iOS: AudioContextIOS(
      category: AVAudioSessionCategory.playback,
      options: {AVAudioSessionOptions.mixWithOthers},
    ),
  ));

  // Inicializar Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('[Firebase] Inicializado correctamente');
  } catch (e) {
    debugPrint('[Firebase] Error al inicializar: $e');
    // No bloqueamos la app si Firebase falla
  }

  final overrides = await cargarProgresoGuardado();
  runApp(ProviderScope(overrides: overrides, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Selección de Personaje',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Baloo2'),
      navigatorObservers: [routeObserver],
      home: const SplashScreen(),
    );
  }
}
