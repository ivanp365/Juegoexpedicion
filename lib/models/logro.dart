enum TipoMetrica { residuos, preguntas, monedas, meta }

class Logro {
  final String id;
  final String titulo;
  final String descripcion;
  final String imagen;
  final TipoMetrica tipo;
  final int meta;

  const Logro({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.imagen,
    required this.tipo,
    required this.meta,
  });
}

const List<Logro> listaDeLogros = [
  Logro(
    id: 'reciclador_novato',
    titulo: 'Reciclador Novato',
    descripcion: 'Clasifica correctamente 5 residuos',
    imagen: 'assets/images/insignias/recicladornovato.png',
    tipo: TipoMetrica.residuos,
    meta: 5,
  ),
  Logro(
    id: 'clasificador_experto',
    titulo: 'Clasificador Experto',
    descripcion: 'Clasifica correctamente 15 residuos',
    imagen: 'assets/images/insignias/clasificadorexperto.png',
    tipo: TipoMetrica.residuos,
    meta: 15,
  ),
  Logro(
    id: 'maestro_del_reciclaje',
    titulo: 'Maestro del Reciclaje',
    descripcion: 'Clasifica correctamente 30 residuos en Clasificatón',
    imagen: 'assets/images/insignias/maestrodelreciclaje.png',
    tipo: TipoMetrica.residuos,
    meta: 30,
  ),
  Logro(
    id: 'guerrero_antiplastico',
    titulo: 'Guerrero Antiplástico',
    descripcion: 'Clasifica correctamente 50 residuos',
    imagen: 'assets/images/insignias/guerreroantiplastico.png',
    tipo: TipoMetrica.residuos,
    meta: 50,
  ),
  Logro(
    id: 'mente_ecologica',
    titulo: 'Mente Ecológica',
    descripcion: 'Responde bien 7 preguntas salvavidas',
    imagen: 'assets/images/insignias/menteecologica.png',
    tipo: TipoMetrica.preguntas,
    meta: 7,
  ),
  Logro(
    id: 'sabio_de_la_naturaleza',
    titulo: 'Sabio de la Naturaleza',
    descripcion: 'Responde bien 20 preguntas salvavidas',
    imagen: 'assets/images/insignias/sabiodelanaturaleza.png',
    tipo: TipoMetrica.preguntas,
    meta: 20,
  ),
  Logro(
    id: 'heroe_ambiental',
    titulo: 'Héroe Ambiental',
    descripcion: 'Llega a 5.000 hojas doradas',
    imagen: 'assets/images/insignias/heroeambiental.png',
    tipo: TipoMetrica.monedas,
    meta: 5000,
  ),
  Logro(
    id: 'campeon_ambiental',
    titulo: 'Campeón Ambiental',
    descripcion: 'Llega a 15.000 hojas doradas',
    imagen: 'assets/images/insignias/campeonambiental.png',
    tipo: TipoMetrica.monedas,
    meta: 15000,
  ),
  Logro(
    id: 'leyenda_verde',
    titulo: 'Leyenda Verde',
    descripcion: 'Desbloquea todos los demás logros',
    imagen: 'assets/images/insignias/leyendaverde.png',
    tipo: TipoMetrica.meta,
    meta: 8,
  ),
];
