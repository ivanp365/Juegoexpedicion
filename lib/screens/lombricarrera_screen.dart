import 'package:flutter/material.dart';

class LombricarreraScreen extends StatelessWidget {
  const LombricarreraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LombriCarrera'),
        backgroundColor: Colors.brown,
      ),
      body: const Center(
        child: Text('Módulo LombriCarrera (Integración pendiente)', 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
