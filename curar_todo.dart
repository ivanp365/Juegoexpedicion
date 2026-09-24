import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  int fixed = 0;

  final replacements = {
    // 1. Errores de doble codificación (Ej: Ã³)
    'Ã¡': 'á', 'Ã©': 'é', 'Ã³': 'ó', 'Ãº': 'ú', 'Ã±': 'ñ', 'Ã‘': 'Ñ', 
    'Â¡': '¡', 'Â¿': '¿', 'Ã“': 'Ó', 'Ã\x81': 'Á', 'Ã\x89': 'É', 'Ã\xAD': 'í',
    
    // 2. Errores del rombo negro (\uFFFD)
    'Clasificaci\uFFFDn': 'Clasificación',
    'org\uFFFDnicos': 'orgánicos',
    'resp\uFFFDndela': 'respóndela',
    'Tambi\uFFFDn': 'También',
    'tambi\uFFFDn': 'también',
    'coraz\uFFFDn': 'corazón',
    '\uFFFDCuidado': '¡Cuidado',
    'clasif\uFFFDcalo': 'clasifícalo',
    'ecosist\uFFFDmico': 'ecosistémico',
    'Provisi\uFFFDn': 'Provisión',
    'Regulaci\uFFFDn': 'Regulación',
    '\uFFFDTesoro': '¡Tesoro',
    '\uFFFDHas': '¡Has',
    'Aqu\uFFFD': 'Aquí',
    '\uFFFDQu\uFFFD': '¿Qué',
    'Qu\uFFFD': 'Qué',
    'qu\uFFFD': 'qué',
    'Nari\uFFFDo': 'Nariño',
    'bot\uFFFDn': 'botón',
    'misi\uFFFDn': 'misión',
    'Misi\uFFFDn': 'Misión',
    'colecci\uFFFDn': 'colección',
    'Colecci\uFFFDn': 'Colección',
    'energ\uFFFDa': 'energía',
    'el\uFFFDctrica': 'eléctrica',
    'h\uFFFDbitat': 'hábitat',
    'polinizaci\uFFFDn': 'polinización',
    'erosi\uFFFDn': 'erosión',
    'purificaci\uFFFDn': 'purificación',
    '\uFFFDrbol': 'árbol',
    'M\uFFFDs': 'Más',
    'est\uFFFD': 'está',
    'D\uFFFDa': 'Día',
    'r\uFFFDpido': 'rápido',
    '\uFFFDFelicidades': '¡Felicidades',
    '\uFFFDExcelente': '¡Excelente',
    
    // 3. Frases específicas dañadas en tus pantallas
    'nada\uFFFD \uFFFDsigue': 'nada... ¡sigue',
    '\uFFFDQu\uFFFD herramienta': '¿Qué herramienta',
  };

  for (var file in files) {
    try {
      String content = file.readAsStringSync();
      String original = content;

      replacements.forEach((bad, good) {
        content = content.replaceAll(bad, good);
      });

      if (content != original) {
        file.writeAsStringSync(content);
        print('-> Limpiado y curado: ${file.path}');
        fixed++;
      }
    } catch (e) {
      // Ignorar archivos que no sean de texto
    }
  }
  print('\n¡Misión cumplida! $fixed archivos fueron escaneados y reparados automáticamente.');
}
