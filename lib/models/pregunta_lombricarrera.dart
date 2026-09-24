class PreguntaLombri {
  final String categoria; // 'lombricultura', 'cuidado', 'reciclaje', 'reto'
  final String color; // 'verde', 'azul', 'amarillo', 'morado'
  final String texto;
  final List<String> opciones;
  final int indiceCorrecto;

  PreguntaLombri({required this.categoria, required this.color, required this.texto, required this.opciones, required this.indiceCorrecto});
}

final List<PreguntaLombri> bancoLombricarreraNivel1 = [
  // 🟢 LOMBRICULTURA (Verde)
  PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cuál característica describe a la lombriz roja californiana?', opciones: ['Es trabajadora y resistente', 'No tolera ningún cambio', 'No consume materia orgánica', 'Vive únicamente en lugares secos'], indiceCorrecto: 0),
  
  // 🔵 CUIDADO (Azul)
  PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué herramienta se usa para mantener la humedad de la compostera?', opciones: ['Pala', 'Regadera', 'Tamiz', 'Zaranda'], indiceCorrecto: 1),
  
  // 🟡 RECICLAJE (Amarillo)
  PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Cuál de estos residuos NO debe ir a la lombricompostera?', opciones: ['Cáscaras de frutas', 'Hojas secas', 'Aceite de cocina', 'Pasto cortado'], indiceCorrecto: 2),
  
  // 🟣 RETO LOMBRI (Morado)
  PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuántos pares de corazones tiene la lombriz roja californiana?', opciones: ['2', '3', '5', '10'], indiceCorrecto: 2),
];
