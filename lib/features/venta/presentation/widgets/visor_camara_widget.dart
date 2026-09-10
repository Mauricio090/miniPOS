import 'package:flutter/material.dart';

class VisorCamaraWidget extends StatelessWidget {
  final Function(String codigo, String nombre, double precio, int stock, bool esPreparado) onProductoEscaneado;

  const VisorCamaraWidget({Key? key, required this.onProductoEscaneado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      color: Colors.black87,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code_scanner, size: 60, color: Colors.white54),
              SizedBox(height: 8),
              Text('Apunta al código de barras...', style: TextStyle(color: Colors.white54)),
            ],
          ),
          Positioned(
            bottom: 10,
            child: ElevatedButton.icon(
              onPressed: () {
                // Simulación de escaneo rápido de Coca Cola
                onProductoEscaneado('12345', 'Coca Cola 600ml', 15.00, 5, false);
              },
              icon: const Icon(Icons.flash_on),
              label: const Text('Simular Escaneo (Coca Cola)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}