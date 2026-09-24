import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_manager.dart';

class AjustesState {
  final double volumen;
  final bool silenciado;

  const AjustesState({this.volumen = 0.8, this.silenciado = false});

  AjustesState copyWith({double? volumen, bool? silenciado}) {
    return AjustesState(
      volumen: volumen ?? this.volumen,
      silenciado: silenciado ?? this.silenciado,
    );
  }
}

class AjustesNotifier extends StateNotifier<AjustesState> {
  AjustesNotifier() : super(const AjustesState()) {
    _cargar();
  }

  static const _kVolumen = 'ajustes_volumen';
  static const _kSilenciado = 'ajustes_silenciado';

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    state = AjustesState(
      volumen: prefs.getDouble(_kVolumen) ?? 0.8,
      silenciado: prefs.getBool(_kSilenciado) ?? false,
    );
    // Sincronizar el AudioManager con los ajustes guardados
    AudioManager.updateSettings(state.volumen, state.silenciado);
  }

  Future<void> cambiarVolumen(double valor) async {
    state = state.copyWith(volumen: valor);
    AudioManager.updateSettings(valor, state.silenciado);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kVolumen, valor);
  }

  Future<void> alternarSilencio(bool valor) async {
    state = state.copyWith(silenciado: valor);
    AudioManager.updateSettings(state.volumen, valor);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSilenciado, valor);
  }
}

final ajustesProvider =
    StateNotifierProvider<AjustesNotifier, AjustesState>(
        (ref) => AjustesNotifier());