import 'package:audioplayers/audioplayers.dart';

/// Modos de musica de fondo.
enum BgmMode {
  /// Pantallas de juego (home, clasificacion, lombri, tesoros).
  home,

  /// Menus secundarios (seleccion, logros, coleccion, instrucciones, ajustes).
  menu,

  /// Sin musica.
  none,
}

class AudioManager {
  static final AudioPlayer _bgm = AudioPlayer()
    ..setReleaseMode(ReleaseMode.loop);

  static double _volumen = 0.8;
  static bool _silenciado = false;

  static BgmMode? _modoActual;
  static String? _pistaActual;

  static BgmMode? get modoActual => _modoActual;
  static String? get pistaActual => _pistaActual;

  static String _archivoPara(BgmMode modo) {
    switch (modo) {
      case BgmMode.home:
        return 'home_theme.mp3';
      case BgmMode.menu:
        return 'menu_secondary_theme.mp3';
      case BgmMode.none:
        return '';
    }
  }

  /// Actualiza el volumen y el estado de silencio.
  static void updateSettings(double volumen, bool silenciado) {
    _volumen = volumen;
    _silenciado = silenciado;
    _bgm.setVolume(_silenciado ? 0 : _volumen);
  }

  /// Cambia al modo indicado. Si es el mismo modo, no hace nada.
  static Future<void> setMode(BgmMode modo) async {
    if (_modoActual == modo) return;
    _modoActual = modo;

    if (modo == BgmMode.none) {
      await stopBgm();
      return;
    }

    final archivo = _archivoPara(modo);
    try {
      await _bgm.stop();
      await _bgm.setVolume(_silenciado ? 0 : _volumen);
      await _bgm.play(AssetSource('audio/$archivo'));
      _pistaActual = archivo;
    } catch (_) {
      // Si falla no rompemos la app
    }
  }

  /// Reproduce una pista arbitraria por nombre.
  /// Compatibilidad con codigo existente.
  static Future<void> playBgm(String fileName) async {
    if (_pistaActual == fileName) return;
    try {
      await _bgm.stop();
      await _bgm.setVolume(_silenciado ? 0 : _volumen);
      await _bgm.play(AssetSource('audio/$fileName'));
      _pistaActual = fileName;
      _modoActual = null; // pista manual, no encaja en un modo
    } catch (_) {}
  }

  static Future<void> stopBgm() async {
    try {
      await _bgm.stop();
      _pistaActual = null;
    } catch (_) {}
  }

  /// Reproduce un efecto corto (SFX).
  static Future<void> playSfx(String fileName) async {
    if (_silenciado) return;
    try {
      final sfx = AudioPlayer();
      await sfx.setVolume(_volumen);
      await sfx.play(AssetSource('audio/$fileName'));
      sfx.onPlayerComplete.listen((_) => sfx.dispose());
    } catch (_) {}
  }
}