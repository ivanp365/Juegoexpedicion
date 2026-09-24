import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logros_provider.dart';

const _kCoins = 'progreso_monedas';
const _kNivelesClasificacion = 'progreso_niveles_clasificacion';
const _kNivelesLombricarrera = 'progreso_niveles_lombricarrera';
const _kAvataresDesbloqueados = 'progreso_avatares_desbloqueados';
const _kAvatarSeleccionado = 'progreso_avatar_seleccionado';
const _kNombreJugador = 'progreso_nombre_jugador';
// Nueva constante para Tesoros
const _kTesorosDescubiertos = 'progreso_tesoros_descubiertos';

final coinsProvider = StateProvider<int>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) => prefs.setInt(_kCoins, next));
  });
  return 1000;
});

final unlockedClasificacionLevelsProvider = StateProvider<List<int>>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) =>
      prefs.setStringList(_kNivelesClasificacion, next.map((e) => e.toString()).toList()));
  });
  return [1];
});

final unlockedLombricarreraLevelsProvider = StateProvider<List<int>>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) =>
      prefs.setStringList(_kNivelesLombricarrera, next.map((e) => e.toString()).toList()));
  });
  return [1];
});

final unlockedAvatarsProvider = StateProvider<List<String>>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) =>
      prefs.setStringList(_kAvataresDesbloqueados, next));
  });
  return ['boy_1', 'girl_1'];
});

final selectedAvatarProvider = StateProvider<String>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_kAvatarSeleccionado, next));
  });
  return 'boy_1';
});

final selectedAvatarIdProvider = StateProvider<String>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_kAvatarSeleccionado, next));
  });
  return 'boy_1';
});

final playerNameProvider = StateProvider<String>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) => prefs.setString(_kNombreJugador, next));
  });
  return 'Aventurero';
});

// NUEVOS PROVIDERS DE TESOROS
final tesorosDescubiertosProvider = StateProvider<List<String>>((ref) {
  ref.listenSelf((previous, next) {
    SharedPreferences.getInstance().then((prefs) => prefs.setStringList(_kTesorosDescubiertos, next));
  });
  return [];
});
final misionIndexProvider = StateProvider<int>((ref) => 0); 


Future<List<Override>> cargarProgresoGuardado() async {
  final prefs = await SharedPreferences.getInstance();

  final monedas = prefs.getInt(_kCoins) ?? 1000;
  final nivelesClasificacion = (prefs.getStringList(_kNivelesClasificacion) ?? ['1']).map(int.parse).toList();
  final nivelesLombricarrera = (prefs.getStringList(_kNivelesLombricarrera) ?? ['1']).map(int.parse).toList();
  final avataresDesbloqueados = prefs.getStringList(_kAvataresDesbloqueados) ?? ['boy_1', 'girl_1'];
  final avatarSeleccionado = prefs.getString(_kAvatarSeleccionado) ?? 'boy_1';
  final nombreJugador = prefs.getString(_kNombreJugador) ?? 'Aventurero';
  final tesorosDescubiertos = prefs.getStringList(_kTesorosDescubiertos) ?? [];

  return [
    coinsProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setInt(_kCoins, next));
      });
      return monedas;
    }),
    unlockedClasificacionLevelsProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) =>
          p.setStringList(_kNivelesClasificacion, next.map((e) => e.toString()).toList()));
      });
      return nivelesClasificacion;
    }),
    unlockedLombricarreraLevelsProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) =>
          p.setStringList(_kNivelesLombricarrera, next.map((e) => e.toString()).toList()));
      });
      return nivelesLombricarrera;
    }),
    unlockedAvatarsProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setStringList(_kAvataresDesbloqueados, next));
      });
      return avataresDesbloqueados;
    }),
    selectedAvatarProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setString(_kAvatarSeleccionado, next));
      });
      return avatarSeleccionado;
    }),
    selectedAvatarIdProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setString(_kAvatarSeleccionado, next));
      });
      return avatarSeleccionado;
    }),
    playerNameProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setString(_kNombreJugador, next));
      });
      return nombreJugador;
    }),
    tesorosDescubiertosProvider.overrideWith((ref) {
      ref.listenSelf((previous, next) {
        SharedPreferences.getInstance().then((p) => p.setStringList(_kTesorosDescubiertos, next));
      });
      return tesorosDescubiertos;
    }),
  ];
}

Future<void> resetearProgreso(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_kCoins);
  await prefs.remove(_kNivelesClasificacion);
  await prefs.remove(_kNivelesLombricarrera);
  await prefs.remove(_kAvataresDesbloqueados);
  await prefs.remove(_kAvatarSeleccionado);
  await prefs.remove(_kNombreJugador);
  await prefs.remove(_kTesorosDescubiertos);

  ref.read(coinsProvider.notifier).state = 0;
  ref.read(unlockedClasificacionLevelsProvider.notifier).state = [1];
  ref.read(unlockedLombricarreraLevelsProvider.notifier).state = [1];
  ref.read(unlockedAvatarsProvider.notifier).state = ['boy_1', 'girl_1'];
  ref.read(selectedAvatarProvider.notifier).state = 'boy_1';
  ref.read(selectedAvatarIdProvider.notifier).state = 'boy_1';
  ref.read(playerNameProvider.notifier).state = 'Aventurero';
  ref.read(tesorosDescubiertosProvider.notifier).state = [];

  await ref.read(logrosProvider.notifier).resetear();
}
