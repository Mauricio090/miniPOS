import 'package:flutter/material.dart';

class PantallaIniciarTurnoWidget extends StatelessWidget {
  final ValueChanged<double> onIniciarTurno; // Cambiado para recibir el monto

  PantallaIniciarTurnoWidget({Key? key, required this.onIniciarTurno}) : super(key: key);

  final TextEditingController fondoController = TextEditingController(text: "200.00");

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('IniciarTurnoScreen'),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_open, size: 50, color: Colors.green),
                const SizedBox(height: 12),
                const Text('Apertura de Caja / Turno', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa el monto de dinero disponible en efectivo para entregar cambio/vuelto al iniciar el turno:',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: fondoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Fondo Inicial en Efectivo', 
                    prefixText: '\$ ', 
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Turno y Abrir Caja'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, 
                    foregroundColor: Colors.white, 
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    double monto = double.tryParse(fondoController.text) ?? 0.0;
                    onIniciarTurno(monto); // Enviamos el valor capturado
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}