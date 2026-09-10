import 'package:flutter/material.dart';

class PantallaIniciarTurnoWidget extends StatelessWidget {
  final VoidCallback onIniciarTurno;

  const PantallaIniciarTurnoWidget({Key? key, required this.onIniciarTurno}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Turno Cerrado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Para comenzar a vender y registrar transacciones, debes iniciar un turno con tu fondo de caja.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onIniciarTurno,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Turno'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}