import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  int fixed = 0;

  final safeReplacements = {
    // 1. Errores de Mojibake puro
    'Ã¡': 'á', 'Ã©': 'é', 'Ã³': 'ó', 'Ãº': 'ú', 'Ã±': 'ñ', 'Ã‘': 'Ñ', 
    'Â¡': '¡', 'Â¿': '¿', 'Ã“': 'Ó', 'Ã\x81': 'Á', 'Ã\x89': 'É', 'Ã\xAD': 'í',
    
    // 2. Errores con el rombo negro de reemplazo (\uFFFD)
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
    '\uFFFDQu\uFFFD herramienta': '¿Qué herramienta',
    'qu\uFFFD servicio': 'qué servicio',
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
    'est\uFFFD ': 'está ',
    'D\uFFFDa': 'Día',
    'r\uFFFDpido': 'rápido',
    '\uFFFDFelicidades': '¡Felicidades',
    '\uFFFDExcelente': '¡Excelente',
    'nada\uFFFD \uFFFDsigue': 'nada... ¡sigue',
  };

  for (var file in files) {
    try {
      final bytes = file.readAsBytesSync();
      String content = utf8.decode(bytes, allowMalformed: true);
      String original = content;

      safeReplacements.forEach((bad, good) {
        content = content.replaceAll(bad, good);
      });

      if (content != original) {
        file.writeAsStringSync(content);
        print('-> Textos curados con seguridad en: ${file.path}');
        fixed++;
      }
    } catch (e) {
      // Ignorar archivos que no sean de texto
    }
  }
  print('\n¡Proceso terminado! $fixed archivos fueron reparados sin afectar el código.');
}
