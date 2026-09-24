import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tesoro_model.dart';
import 'game_provider.dart';

final nivelJuegoProvider = StateProvider<NivelJuego>((ref) => NivelJuego.primaria);
final veredaSeleccionadaProvider = StateProvider<String?>((ref) => null);
final misionActualProvider = StateProvider<TesoroMision?>((ref) => null);
enum EstadoVereda { bloqueada, disponible, completada }

final estadoVeredaProvider = Provider.family<EstadoVereda, String>((ref, vereda) {
  final descubiertos = ref.watch(tesorosDescubiertosProvider);
  final nivel = ref.watch(nivelJuegoProvider);
  final indice = veredasMorasurco.indexOf(vereda);
  bool veredaCompleta(String v) {
    final misionesV = misionesDeVereda(v, nivel);
    return misionesV.isNotEmpty && misionesV.every((m) => descubiertos.contains(m.id));
  }
  if (veredaCompleta(vereda)) return EstadoVereda.completada;
  if (indice <= 0) return EstadoVereda.disponible;
  return veredaCompleta(veredasMorasurco[indice - 1]) ? EstadoVereda.disponible : EstadoVereda.bloqueada;
});

final expedicionCompletadaProvider = Provider<bool>((ref) {
  final descubiertos = ref.watch(tesorosDescubiertosProvider);
  final misiones = misionesDeNivel(ref.watch(nivelJuegoProvider));
  return misiones.isNotEmpty && misiones.every((m) => descubiertos.contains(m.id));
});

final progresoPorCategoriaProvider = Provider<Map<CategoriaEcosistemica, int>>((ref) {
  final descubiertos = ref.watch(tesorosDescubiertosProvider);
  final misiones = misionesDeNivel(ref.watch(nivelJuegoProvider));
  final mapa = <CategoriaEcosistemica, int>{for (final c in CategoriaEcosistemica.values) c: 0};
  for (final m in misiones) {
    if (descubiertos.contains(m.id)) mapa[m.categoria] = (mapa[m.categoria] ?? 0) + 1;
  }
  return mapa;
});

// Estado para controlar qué niveles de Tesoros están desbloqueados
final unlockedTesorosLevelsProvider = StateProvider<List<int>>((ref) {
  // Inicialmente solo el Nivel 1 (Primaria) está desbloqueado
  return [1]; 
});
