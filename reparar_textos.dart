import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('Error: Ejecuta este script desde la raíz del proyecto.');
    return;
  }
  
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  int fixed = 0;
  for (var file in files) {
    try {
      String content = file.readAsStringSync();
      String original = content;

      // 1. Curar Mojibake (Ej: Ã³ -> ó)
      final replacements = {
        'Ã¡': 'á', 'Ã©': 'é', 'Ã³': 'ó', 'Ãº': 'ú',
        'Ã±': 'ñ', 'Ã‘': 'Ñ', 'Â¡': '¡', 'Â¿': '¿',
        'Ã“': 'Ó', 'Ã\x81': 'Á', 'Ã\x89': 'É', 'Ã\xAD': 'í',
      };
      
      replacements.forEach((bad, good) {
        content = content.replaceAll(bad, good);
      });
      
      // 2. Curar el símbolo de reemplazo () en el código
      final dict = {
        'clasif\uFFFDcalo': 'clasifícalo',
        'ecosist\uFFFDmico': 'ecosistémico',
        'Provisi\uFFFDn': 'Provisión',
        'Regulaci\uFFFDn': 'Regulación',
        'coraz\uFFFDn': 'corazón',
        'resp\uFFFDndela': 'respóndela',
        'Nari\uFFFDo': 'Nariño',
        'bot\uFFFDn': 'botón',
        'misi\uFFFDn': 'misión',
        'ci\uFFFDn': 'ción',
        'Ci\uFFFDn': 'Ción',
      };

      dict.forEach((bad, good) {
        content = content.replaceAll(bad, good);
      });

      if (content != original) {
        file.writeAsStringSync(content);
        print('Sanando: ${file.path}');
        fixed++;
      }
    } catch (e) {
      // Ignorar archivos no legibles como texto plano
    }
  }
  print('\n¡Proceso terminado! $fixed archivos han sido curados y restaurados.');
}
