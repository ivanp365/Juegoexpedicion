import 'package:flutter/material.dart';
import '../widgets/tesoros_theme.dart';

enum CategoriaEcosistemica { provision, regulacion, soporte, cultural }
extension CategoriaEcosistemicaX on CategoriaEcosistemica {
  String get nombre {
    switch (this) {
      case CategoriaEcosistemica.provision: return 'Provisión';
      case CategoriaEcosistemica.regulacion: return 'Regulación';
      case CategoriaEcosistemica.soporte: return 'Soporte';
      case CategoriaEcosistemica.cultural: return 'Cultural';
    }
  }
  Color get color {
    switch (this) {
      case CategoriaEcosistemica.provision: return TC.provision;
      case CategoriaEcosistemica.regulacion: return TC.regulacion;
      case CategoriaEcosistemica.soporte: return TC.soporte;
      case CategoriaEcosistemica.cultural: return TC.cultural;
    }
  }
  IconData get iconoCategoria {
    switch (this) {
      case CategoriaEcosistemica.provision: return Icons.eco_rounded;
      case CategoriaEcosistemica.regulacion: return Icons.water_drop_rounded;
      case CategoriaEcosistemica.soporte: return Icons.grass_rounded;
      case CategoriaEcosistemica.cultural: return Icons.diversity_3_rounded;
    }
  }
}

enum NivelJuego { primaria, secundaria }
class TesoroMision {
  final String id, pista, veredaCorrecta, nombreTesoro, descripcion;
  final CategoriaEcosistemica categoria;
  final IconData iconoTesoro;
  final String recursoId;
  const TesoroMision({required this.id, required this.pista, required this.veredaCorrecta, required this.nombreTesoro, required this.descripcion, required this.categoria, required this.iconoTesoro, required this.recursoId});
}

const List<String> veredasMorasurco = ['San Juan Bajo', 'San Juan Alto', 'La Joseña', 'Tosoabí', 'Daza', 'Chachatoy', 'Pinasaco', 'San Antonio de Aranda', 'Tescual'];
enum TipoZona { bosque, cultivo, laguna }
const Map<String, TipoZona> veredaTipoZona = {'San Juan Bajo': TipoZona.cultivo, 'San Juan Alto': TipoZona.bosque, 'La Joseña': TipoZona.laguna, 'Tosoabí': TipoZona.laguna, 'Daza': TipoZona.cultivo, 'Chachatoy': TipoZona.bosque, 'Pinasaco': TipoZona.cultivo, 'San Antonio de Aranda': TipoZona.bosque, 'Tescual': TipoZona.laguna};
const Map<String, Offset> veredaCoordenadas = {'San Juan Alto': Offset(0.38, 0.30), 'La Joseña': Offset(0.68, 0.32), 'Daza': Offset(0.50, 0.37), 'Tosoabí': Offset(0.82, 0.35), 'San Juan Bajo': Offset(0.20, 0.42), 'Chachatoy': Offset(0.48, 0.46), 'Pinasaco': Offset(0.76, 0.45), 'San Antonio de Aranda': Offset(0.28, 0.54), 'Tescual': Offset(0.62, 0.55)};

const Map<String, CategoriaEcosistemica> categoriaDeRecurso = {
  'recursos_medicinales': CategoriaEcosistemica.provision,
  'alimentos': CategoriaEcosistemica.provision,
  'materias_primas': CategoriaEcosistemica.provision,
  'energias_renovables': CategoriaEcosistemica.provision,
  'agua_dulce': CategoriaEcosistemica.provision,
  'calidad_del_aire': CategoriaEcosistemica.regulacion,
  'recursos_ornamentales': CategoriaEcosistemica.regulacion,
  'captura_de_carbono': CategoriaEcosistemica.regulacion,
  'regulacion_del_clima': CategoriaEcosistemica.regulacion,
  'calidad_del_agua': CategoriaEcosistemica.regulacion,
  'riesgos_naturales': CategoriaEcosistemica.regulacion,
  'control_erosion': CategoriaEcosistemica.regulacion,
  'fertilidad_del_suelo': CategoriaEcosistemica.regulacion,
  'enfermedades_y_plagas': CategoriaEcosistemica.regulacion,
  'polinizacion': CategoriaEcosistemica.regulacion,
  'habitat': CategoriaEcosistemica.soporte,
  'diversidad_genetica': CategoriaEcosistemica.soporte,
  'ecoturismo': CategoriaEcosistemica.cultural,
  'recreacion': CategoriaEcosistemica.cultural,
  'valores_esteticos': CategoriaEcosistemica.cultural,
  'cultural_y_patrimonio': CategoriaEcosistemica.cultural,
  'espirituales_y_religiosos': CategoriaEcosistemica.cultural,
  'ciencia_y_educacion': CategoriaEcosistemica.cultural,
  'salud_y_bienestar': CategoriaEcosistemica.cultural,
};

const Map<int, String> monedaPorVereda = {
  1: 'San Juan Bajo', 2: 'San Juan Bajo', 3: 'San Juan Bajo',
  4: 'San Juan Alto', 5: 'San Juan Alto', 6: 'San Juan Alto',
  7: 'La Joseña', 8: 'La Joseña', 9: 'La Joseña',
  10: 'Tosoabí', 11: 'Tosoabí', 12: 'Tosoabí',
  13: 'Daza', 14: 'Daza', 15: 'Daza',
  16: 'Chachatoy', 17: 'Chachatoy',
  18: 'Pinasaco', 19: 'Pinasaco',
  20: 'San Antonio de Aranda', 21: 'San Antonio de Aranda',
  22: 'Tescual', 23: 'Tescual', 24: 'Tescual',
};

const Map<int, String> monedaRecursoConfirmado = {
  1: 'materias_primas',
  2: 'control_erosion',
};

const List<String> _recursosSinConfirmar = [
  'recursos_medicinales', 'alimentos', 'materias_primas', 'energias_renovables', 'agua_dulce',
  'calidad_del_aire', 'recursos_ornamentales', 'captura_de_carbono', 'regulacion_del_clima', 'calidad_del_agua',
  'riesgos_naturales', 'control_erosion', 'fertilidad_del_suelo', 'enfermedades_y_plagas', 'polinizacion',
  'habitat', 'diversidad_genetica',
  'ecoturismo', 'recreacion', 'valores_esteticos', 'cultural_y_patrimonio',
  'espirituales_y_religiosos', 'ciencia_y_educacion', 'salud_y_bienestar',
];

String _recursoDeMoneda(int numeroMoneda) {
  return monedaRecursoConfirmado[numeroMoneda] ?? _recursosSinConfirmar[numeroMoneda - 1];
}

List<TesoroMision> _generarMisiones(NivelJuego nivel) {
  final lista = <TesoroMision>[];
  final prefijo = nivel == NivelJuego.primaria ? 'p' : 's';
  final desplazamiento = nivel == NivelJuego.primaria ? 0 : 12;

  for (var i = 0; i < 12; i++) {
    final indiceGlobal = desplazamiento + i; 
    final numeroTesoro = indiceGlobal + 1; 
    final vereda = monedaPorVereda[numeroTesoro]!;
    final recursoId = _recursoDeMoneda(numeroTesoro);
    final categoria = categoriaDeRecurso[recursoId]!;
    final descripcionBase = nivel == NivelJuego.primaria
        ? 'Este tesoro representa un servicio de ${categoria.nombre} que la naturaleza le da a la comunidad de $vereda.'
        : 'En $vereda, este elemento del ecosistema cumple una función de ${categoria.nombre.toLowerCase()}: analiza cómo se relaciona con las actividades de la comunidad.';

    lista.add(TesoroMision(
      id: '${prefijo}_tesoro_$numeroTesoro',
      pista: nivel == NivelJuego.primaria
          ? 'Busca cerca de $vereda, donde la naturaleza da este recurso.'
          : 'Relaciona las pistas del manual con la zona de $vereda antes de explorar.',
      veredaCorrecta: vereda,
      nombreTesoro: 'Tesoro $numeroTesoro de $vereda',
      descripcion: descripcionBase,
      categoria: categoria,
      iconoTesoro: categoria.iconoCategoria,
      recursoId: recursoId,
    ));
  }
  return lista;
}

final List<TesoroMision> misionesPrimaria = _generarMisiones(NivelJuego.primaria);
final List<TesoroMision> misionesSecundaria = _generarMisiones(NivelJuego.secundaria);
List<TesoroMision> misionesDeNivel(NivelJuego nivel) => nivel == NivelJuego.primaria ? misionesPrimaria : misionesSecundaria;
List<TesoroMision> misionesDeVereda(String vereda, NivelJuego nivel) => misionesDeNivel(nivel).where((m) => m.veredaCorrecta == vereda).toList();
