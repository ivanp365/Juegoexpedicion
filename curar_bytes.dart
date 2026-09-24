import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  int fixed = 0;

  final replacements = {
    // 1. Errores de doble codificación
    'Ã¡': 'á', 'Ã©': 'é', 'Ã³': 'ó', 'Ãº': 'ú', 'Ã±': 'ñ', 'Ã‘': 'Ñ', 
    'Â¡': '¡', 'Â¿': '¿', 'Ã“': 'Ó', 'Ã\x81': 'Á', 'Ã\x89': 'É', 'Ã\xAD': 'í',
    
    // 2. Errores de rombo negro literal
    'Clasificacin': 'Clasificación',
    'orgnicos': 'orgánicos',
    'respndela': 'respóndela',
    'Tambin': 'También',
    'tambin': 'también',
    'corazn': 'corazón',
    'Cuidado': '¡Cuidado',
    'clasifcalo': 'clasifícalo',
    'ecosistmico': 'ecosistémico',
    'Provisin': 'Provisión',
    'Regulacin': 'Regulación',
    'Tesoro': '¡Tesoro',
    'Has': '¡Has',
    'Aqu': 'Aquí',
    'nada sigue': 'nada... ¡sigue',
    'Qu herramienta': '¿Qué herramienta',
    'Qu': '¿Qué',
    'Qu': 'Qué',
    'qu': 'qué',
    'Nario': 'Nariño',
    'botn': 'botón',
    'misin': 'misión',
    'Misin': 'Misión',
    'coleccin': 'colección',
    'Coleccin': 'Colección',
    'energa': 'energía',
    'elctrica': 'eléctrica',
    'hbitat': 'hábitat',
    'polinizacin': 'polinización',
    'erosin': 'erosión',
    'purificacin': 'purificación',
    'rbol': 'árbol',
    'Ms': 'Más',
    'est': 'está',
    'Da': 'Día',
    'rpido': 'rápido',
    'Felicidades': '¡Felicidades',
    'Excelente': '¡Excelente',
    'Tesoros Ambientales': 'Tesoros Ambientales', // Dummy para forzar trigger
  };

  for (var file in files) {
    try {
      // Leer a nivel de bytes forzando la decodificación de errores
      final bytes = file.readAsBytesSync();
      String content = utf8.decode(bytes, allowMalformed: true);
      String original = content;

      replacements.forEach((bad, good) {
        content = content.replaceAll(bad, good);
      });

      if (content != original) {
        file.writeAsStringSync(content);
        print('-> Curado exitosamente: ${file.path}');
        fixed++;
      }
    } catch (e) {
      print('Error al procesar ${file.path}: $e');
    }
  }
  print('\n¡Misión cumplida! $fixed archivos fueron escaneados y reparados.');
}
