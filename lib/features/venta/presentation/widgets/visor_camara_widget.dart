import 'package:flutter/material.dart';

class VisorCamaraWidget extends StatelessWidget {
  final Function(String codigo, String nombre, double precio, int stock, bool esPreparado) onProductoEscaneado;

  const VisorCamaraWidget({Key? key, required this.onProductoEscaneado}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      onProductoEscaneado('12345', 'Coca Cola 600ml', 15.00, 5, false);
                    },
                    icon: const Icon(Icons.flash_on, size: 16),
                    label: const Text('Simular Con Stock', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      onProductoEscaneado('99991', 'Papas Sabritas 45g', 18.50, 0, false);
                    },
                    icon: const Icon(Icons.block, size: 16),
                    label: const Text('Simular Sin Stock', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}