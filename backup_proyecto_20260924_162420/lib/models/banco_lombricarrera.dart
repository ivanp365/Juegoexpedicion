import 'dart:math';
import 'pregunta_lombricarrera.dart';

/// ============================================================
/// BANCO DE PREGUNTAS - LOMBRICARRERA
/// Nivel 1: 30 preguntas | Nivel 2: 30 preguntas
/// ============================================================

final List<PreguntaLombri> bancoLombricarreraNivel1 = [
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cuál característica describe a la lombriz roja californiana?', opciones: ['Es trabajadora y resistente', 'No tolera ningún cambio', 'No consume materia orgánica', 'Vive únicamente en lugares secos'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué produce la lombriz que enriquece el suelo?', opciones: ['Humus', 'Arena', 'Piedras', 'Plástico'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿De qué se alimenta principalmente la lombriz roja?', opciones: ['Materia orgánica en descomposición', 'Piedras', 'Plástico', 'Metal'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cómo se llama el abono que producen las lombrices?', opciones: ['Humus de lombriz', 'Fertilizante químico', 'Composta seca', 'Tierra árida'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué parte del cuerpo de la lombriz le ayuda a moverse?', opciones: ['Las cerdas', 'Las alas', 'Las patas', 'Las aletas'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cuántas lombrices pueden vivir en un metro cuadrado de compostera?', opciones: ['Cientos', 'Dos', 'Una sola', 'Ninguna'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué significa "lombricultura"?', opciones: ['Crianza de lombrices', 'Cultivo de flores', 'Caza de insectos', 'Pesca de peces'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Por qué es importante la lombriz para el suelo?', opciones: ['Lo airea y enriquece', 'Lo seca', 'Lo contamina', 'Lo endurece'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué herramienta se usa para mantener la humedad de la compostera?', opciones: ['Pala', 'Regadera', 'Tamiz', 'Zaranda'], indiceCorrecto: 1),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué NO debe faltar en una lombricompostera?', opciones: ['Sol directo', 'Humedad y oscuridad', 'Viento fuerte', 'Frío extremo'], indiceCorrecto: 1),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Cada cuánto se recomienda revisar la humedad de la compostera?', opciones: ['Cada semana', 'Nunca', 'Cada año', 'Cada hora'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué temperatura es ideal para las lombrices?', opciones: ['15-25 °C', '0-5 °C', '40-50 °C', '60-70 °C'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué pasa si la compostera está muy seca?', opciones: ['Las lombrices se mueren', 'Se multiplican', 'Nada', 'Se hacen más grandes'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué pasa si la compostera está muy húmeda?', opciones: ['Aparecen malos olores', 'Se seca', 'Se llena de flores', 'Nada'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Dónde se debe colocar la lombricompostera?', opciones: ['En un lugar sombreado', 'Al sol directo', 'En el congelador', 'En la azotea'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué se debe usar para proteger la compostera de la lluvia?', opciones: ['Una tapa', 'Un foco', 'Un ventilador', 'Nada'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Cuál de estos residuos NO debe ir a la lombricompostera?', opciones: ['Cáscaras de frutas', 'Hojas secas', 'Aceite de cocina', 'Pasto cortado'], indiceCorrecto: 2),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué residuo es ideal para la lombricompostera?', opciones: ['Cáscaras de frutas y verduras', 'Vidrio', 'Pilas', 'Metal'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué significa "compostaje"?', opciones: ['Transformar residuos en abono', 'Quemar basura', 'Enterrar plástico', 'Tirar basura al río'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Cuál de estos NO es un residuo orgánico?', opciones: ['Botella de plástico', 'Cáscara de plátano', 'Restos de lechuga', 'Cáscara de huevo'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Por qué es bueno reciclar los residuos orgánicos?', opciones: ['Reduce la basura y produce abono', 'Aumenta la contaminación', 'Gasta más agua', 'No sirve'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué color de caneca se usa para residuos orgánicos?', opciones: ['Verde', 'Azul', 'Rojo', 'Amarillo'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué se debe hacer con los residuos antes de echarlos a la compostera?', opciones: ['Picarlos', 'Mojarlos con aceite', 'Pintarlos', 'Congelarlos'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuántos pares de corazones tiene la lombriz roja californiana?', opciones: ['2', '3', '5', '10'], indiceCorrecto: 2),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuánto tiempo tarda la lombriz en producir humus?', opciones: ['1 día', '1 semana', '2-3 meses', '1 año'], indiceCorrecto: 2),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuál es el nombre científico de la lombriz roja californiana?', opciones: ['Eisenia foetida', 'Lumbricus terrestris', 'Homo sapiens', 'Apis mellifera'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuántas lombrices puede haber en 1 kg de humus?', opciones: ['Cientos', 'Dos', 'Una', 'Ninguna'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿La lombriz tiene pulmones?', opciones: ['No, respira por la piel', 'Sí, dos', 'Sí, uno', 'Sí, cinco'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuánto mide aproximadamente una lombriz roja adulta?', opciones: ['5-10 cm', '1 cm', '50 cm', '1 metro'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿La lombriz pone huevos?', opciones: ['Sí, en cápsulas', 'No, nunca', 'Solo en invierno', 'Solo los machos'], indiceCorrecto: 0),
];

final List<PreguntaLombri> bancoLombricarreraNivel2 = [
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué pH es ideal para el sustrato de la lombriz roja?', opciones: ['6.5 - 7.5', '3.0 - 4.0', '9.0 - 10.0', '1.0 - 2.0'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué significa que la lombriz sea "hermafrodita"?', opciones: ['Tiene ambos sexos', 'Solo es macho', 'Solo es hembra', 'No tiene sexo'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué relación simbiótica tiene la lombriz con las bacterias del suelo?', opciones: ['Descomponen juntas la materia', 'Compiten por comida', 'Se evitan', 'No se relacionan'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cuánto humus produce una lombriz al día aproximadamente?', opciones: ['Su propio peso', '10 veces su peso', 'Nada', '1 kg'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué tipo de suelo prefiere la lombriz roja californiana?', opciones: ['Rico en materia orgánica', 'Arenoso puro', 'Pedregoso', 'Salino'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué es el "clitelo" en la lombriz?', opciones: ['Anillo reproductor', 'Su boca', 'Su cola', 'Su corazón'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Cuál es el principal enemigo natural de la lombriz en la compostera?', opciones: ['Hormigas y planarias', 'Mariposas', 'Abejas', 'Conejos'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Lombricultura', color: 'verde', texto: '¿Qué porcentaje de humedad necesita el sustrato?', opciones: ['70-80%', '10-20%', '30-40%', '100%'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Cada cuánto se debe renovar el sustrato de la compostera?', opciones: ['Cada 3-6 meses', 'Cada día', 'Cada año', 'Nunca'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué se debe hacer si aparecen moscas en la compostera?', opciones: ['Enterrar mejor los residuos', 'Echar insecticida', 'Quemar todo', 'Nada'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué indica un olor fétido en la compostera?', opciones: ['Exceso de humedad o falta de aire', 'Buena salud', 'Exceso de lombrices', 'Falta de sol'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué se debe hacer antes de añadir residuos nuevos?', opciones: ['Picarlos y enterrarlos', 'Echarlos enteros encima', 'Mojarlos con aceite', 'Congelarlos'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Por qué NO se debe echar cítricos en exceso?', opciones: ['Acidifican el medio', 'Son dulces', 'Son grandes', 'Tienen semillas'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué se debe hacer si la compostera huele a podrido?', opciones: ['Airear y añadir material seco', 'Echar agua', 'Tapar más', 'Nada'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué material sirve como "cama" para las lombrices?', opciones: ['Cartón o papel sin tinta', 'Plástico', 'Vidrio', 'Metal'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Cuidado', color: 'azul', texto: '¿Qué se debe hacer al cosechar el humus?', opciones: ['Separar lombrices del humus', 'Tirar todo', 'Quemarlo', 'Congelarlo'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué tipo de residuos NO se deben compostar?', opciones: ['Carnes y lácteos', 'Cáscaras de fruta', 'Hojas secas', 'Pasto'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué relación carbono-nitrógeno es ideal para compostar?', opciones: ['25-30 a 1', '1 a 1', '100 a 1', '5 a 1'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué son los "residuos verdes" en compostaje?', opciones: ['Restos frescos ricos en nitrógeno', 'Plásticos verdes', 'Vidrios', 'Pinturas'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué son los "residuos marrones"?', opciones: ['Secos ricos en carbono', 'Podridos', 'Plásticos', 'Metales'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué se hace con el humus cosechado?', opciones: ['Usarlo como abono', 'Tirarlo', 'Quemarlo', 'Comerlo'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Cuánto tarda el compostaje tradicional vs lombricompostaje?', opciones: ['Lombricompostaje es más rápido', 'Son iguales', 'Tradicional es más rápido', 'Ninguno funciona'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reciclaje', color: 'amarillo', texto: '¿Qué significa "economía circular"?', opciones: ['Reutilizar residuos como recursos', 'Tirar todo', 'Comprar más', 'Quemar basura'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuántas especies de lombrices se conocen aproximadamente?', opciones: ['Más de 3000', 'Solo 10', '100', '5'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿La lombriz tiene ojos?', opciones: ['No, detecta luz por células', 'Sí, dos', 'Sí, cuatro', 'Sí, uno'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuántos anillos puede tener una lombriz adulta?', opciones: ['100-150', '5', '1000', '20'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Qué pasa si cortas una lombriz por la mitad?', opciones: ['Solo sobrevive la parte con el clitelo', 'Se forman dos', 'Muere entera', 'Nada'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Cuál es el depredador natural de la lombriz en el suelo?', opciones: ['Aves y topos', 'Mariposas', 'Abejas', 'Gatos'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿La lombriz es de sangre fría o caliente?', opciones: ['Fría', 'Caliente', 'Ambas', 'Ninguna'], indiceCorrecto: 0),
  const PreguntaLombri(categoria: 'Reto Lombri', color: 'morado', texto: '¿Qué científico estudió por primera vez la lombriz como ingeniera del suelo?', opciones: ['Charles Darwin', 'Einstein', 'Newton', 'Pasteur'], indiceCorrecto: 0),
];

List<PreguntaLombri> obtenerPreguntasAleatorias(int nivel, {int cantidad = 30}) {
  final banco = nivel == 1 ? bancoLombricarreraNivel1 : bancoLombricarreraNivel2;
  final copia = List<PreguntaLombri>.from(banco);
  copia.shuffle(Random());
  return copia.take(cantidad).toList();
}

PreguntaLombri obtenerPreguntaAleatoria(int nivel) {
  final banco = nivel == 1 ? bancoLombricarreraNivel1 : bancoLombricarreraNivel2;
  return banco[Random().nextInt(banco.length)];
}
