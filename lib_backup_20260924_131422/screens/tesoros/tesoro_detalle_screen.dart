import 'package:flutter/material.dart';
import '../../models/tesoro_model.dart';
import '../../widgets/tesoros_theme.dart';
import '../../widgets/tesoros_widgets.dart';

class TesoroDetalleScreen extends StatelessWidget {
  final TesoroMision mision;
  const TesoroDetalleScreen({super.key, required this.mision});
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TC.woodDeep,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: TC.cream), title: const Text('Tesoro ambiental', style: TextStyle(color: TC.cream))),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: GemaWidget(size: 120, color: mision.categoria.color)), const SizedBox(height: 20), Text(mision.nombreTesoro, textAlign: TextAlign.center, style: const TextStyle(color: TC.cream, fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 16), Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [const Icon(Icons.location_on_rounded, color: TC.goldBright, size: 18), const SizedBox(width: 8), Text('Ubicación: ${mision.veredaCorrecta}', style: const TextStyle(color: TC.cream, fontSize: 14))])), Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [Icon(mision.categoria.iconoCategoria, color: TC.goldBright, size: 18), const SizedBox(width: 8), Text('Servicio: ${mision.categoria.nombre}', style: const TextStyle(color: TC.cream, fontSize: 14))])), const SizedBox(height: 16), Text(mision.descripcion, style: const TextStyle(color: TC.creamDark, fontSize: 14, height: 1.5))]))),
    );
  }
}
