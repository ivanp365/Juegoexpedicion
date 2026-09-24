class PreguntaLombri {
  final String categoria;
  final String color;
  final String texto;
  final List<String> opciones;
  final int indiceCorrecto;

  const PreguntaLombri({
    required this.categoria,
    required this.color,
    required this.texto,
    required this.opciones,
    required this.indiceCorrecto,
  });
}
