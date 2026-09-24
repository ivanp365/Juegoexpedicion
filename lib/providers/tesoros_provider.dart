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

  final misionesVereda = misionesDeVereda(vereda, nivel);

  // Si esta vereda no pertenece al nivel actual:
  if (misionesVereda.isEmpty) {
    // En Primaria, las veredas de Secundaria (Daza en adelante) permanecen con candado
    // En Secundaria, las veredas de Primaria ya quedan como completadas
    return nivel == NivelJuego.primaria ? EstadoVereda.bloqueada : EstadoVereda.completada;
  }

  // Si sí tiene misiones en este nivel:
  final todasDescubiertas = misionesVereda.every((m) => descubiertos.contains(m.id));
  if (todasDescubiertas) return EstadoVereda.completada;

  // Obtenemos solo las veredas activas para el nivel en juego
  final veredasDelNivel = veredasMorasurco.where((v) => misionesDeVereda(v, nivel).isNotEmpty).toList();
  final indiceEnNivel = veredasDelNivel.indexOf(vereda);

  // La primera vereda del nivel siempre arranca disponible (San Juan Bajo en N1, Daza en N2)
  if (indiceEnNivel <= 0) return EstadoVereda.disponible;

  // Desbloquea si la vereda anterior del MISMO nivel está completa
  final veredaAnterior = veredasDelNivel[indiceEnNivel - 1];
  final anteriorCompleta = misionesDeVereda(veredaAnterior, nivel).every((m) => descubiertos.contains(m.id));

  return anteriorCompleta ? EstadoVereda.disponible : EstadoVereda.bloqueada;
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

final unlockedTesorosLevelsProvider = StateProvider<List<int>>((ref) => [1]);
