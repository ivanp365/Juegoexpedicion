import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/logro.dart';

class LogrosStats {
  final int residuosAcertadosTotal;
  final int preguntasCorrectasTotal;
  final int monedasMaximas;

  const LogrosStats({
    this.residuosAcertadosTotal = 0,
    this.preguntasCorrectasTotal = 0,
    this.monedasMaximas = 0,
  });

  LogrosStats copyWith({int? residuosAcertadosTotal, int? preguntasCorrectasTotal, int? monedasMaximas}) {
    return LogrosStats(
      residuosAcertadosTotal: residuosAcertadosTotal ?? this.residuosAcertadosTotal,
      preguntasCorrectasTotal: preguntasCorrectasTotal ?? this.preguntasCorrectasTotal,
      monedasMaximas: monedasMaximas ?? this.monedasMaximas,
    );
  }

  Set<String> calcularDesbloqueados() {
    final desbloqueados = <String>{};
    for (final logro in listaDeLogros) {
      if (logro.tipo == TipoMetrica.meta) continue;
      int valorActual;
      switch (logro.tipo) {
        case TipoMetrica.residuos:
          valorActual = residuosAcertadosTotal;
          break;
        case TipoMetrica.preguntas:
          valorActual = preguntasCorrectasTotal;
          break;
        case TipoMetrica.monedas:
          valorActual = monedasMaximas;
          break;
        case TipoMetrica.meta:
          valorActual = 0;
          break;
      }
      if (valorActual >= logro.meta) desbloqueados.add(logro.id);
    }
    final totalNoMeta = listaDeLogros.where((l) => l.tipo != TipoMetrica.meta).length;
    if (desbloqueados.length >= totalNoMeta) {
      final metaLogro = listaDeLogros.firstWhere((l) => l.tipo == TipoMetrica.meta);
      desbloqueados.add(metaLogro.id);
    }
    return desbloqueados;
  }
}

class LogrosNotifier extends StateNotifier<LogrosStats> {
  LogrosNotifier() : super(const LogrosStats()) {
    _cargar();
  }

  static const _kResiduos = 'logros_residuos_total';
  static const _kPreguntas = 'logros_preguntas_total';
  static const _kMonedasMax = 'logros_monedas_max';

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    state = LogrosStats(
      residuosAcertadosTotal: prefs.getInt(_kResiduos) ?? 0,
      preguntasCorrectasTotal: prefs.getInt(_kPreguntas) ?? 0,
      monedasMaximas: prefs.getInt(_kMonedasMax) ?? 0,
    );
  }

  Future<void> _guardar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kResiduos, state.residuosAcertadosTotal);
    await prefs.setInt(_kPreguntas, state.preguntasCorrectasTotal);
    await prefs.setInt(_kMonedasMax, state.monedasMaximas);
  }

  void registrarResiduoAcertado() {
    state = state.copyWith(residuosAcertadosTotal: state.residuosAcertadosTotal + 1);
    _guardar();
  }

  void registrarPreguntaCorrecta() {
    state = state.copyWith(preguntasCorrectasTotal: state.preguntasCorrectasTotal + 1);
    _guardar();
  }

  void actualizarMonedasActuales(int monedasActuales) {
    if (monedasActuales > state.monedasMaximas) {
      state = state.copyWith(monedasMaximas: monedasActuales);
      _guardar();
    }
  }

  Future<void> resetear() async {
    state = const LogrosStats();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kResiduos);
    await prefs.remove(_kPreguntas);
    await prefs.remove(_kMonedasMax);
  }
}

final logrosProvider = StateNotifierProvider<LogrosNotifier, LogrosStats>((ref) => LogrosNotifier());