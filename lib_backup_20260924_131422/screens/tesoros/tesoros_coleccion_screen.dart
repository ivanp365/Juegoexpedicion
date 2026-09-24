import 'package:flutter/material.dart';
import '../../providers/tesoros_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/tesoro_model.dart';
import '../../providers/game_provider.dart';
import '../../widgets/tesoros_theme.dart';
import '../../widgets/tesoros_widgets.dart';
import 'tesoro_detalle_screen.dart';

class TesorosColeccionScreen extends ConsumerWidget {
  const TesorosColeccionScreen({super.key});
  @override Widget build(BuildContext context, WidgetRef ref) {
    final descubiertos = ref.watch(tesorosDescubiertosProvider);
    final misiones = misionesDeNivel(ref.watch(nivelJuegoProvider));
    return Scaffold(
      backgroundColor: TC.woodDeep,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: TC.cream), title: Text('Mis Tesoros — ${misiones.where((m) => descubiertos.contains(m.id)).length}/${misiones.length}', style: const TextStyle(color: TC.cream, fontWeight: FontWeight.w900))),
      body: SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: CategoriaEcosistemica.values.map((categoria) {
        final misionesCategoria = misiones.where((m) => m.categoria == categoria).toList();
        return Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(categoria.iconoCategoria, color: categoria.color, size: 18), const SizedBox(width: 6), Text(categoria.nombre.toUpperCase(), style: TextStyle(color: categoria.color, fontWeight: FontWeight.w900))]), const SizedBox(height: 8), Wrap(spacing: 10, runSpacing: 10, children: misionesCategoria.map((m) {
          final encontrado = descubiertos.contains(m.id);
          return GestureDetector(onTap: encontrado ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TesoroDetalleScreen(mision: m))) : null, child: GemaWidget(size: 52, color: categoria.color, bloqueada: !encontrado));
        }).toList())]));
      }).toList())),
    );
  }
}

