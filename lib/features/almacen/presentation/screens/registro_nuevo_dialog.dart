import 'package:flutter/material.dart';

class RegistroNuevoDialog extends StatelessWidget {
  final String codigoBarras;
  const RegistroNuevoDialog({super.key, required this.codigoBarras});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.add_shopping_cart, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(child: Text('Nuevo: $codigoBarras', style: const TextStyle(fontSize: 18))),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              decoration: InputDecoration(labelText: 'Nombre del Producto', hintText: 'Ej. Papas Fritas 45g'),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Precio de Compra', prefixText: '\$ '),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: 'Precio de Venta', prefixText: '\$ '),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Stock Inicial', hintText: 'Ej. 10'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () {
            // Aquí en el futuro tomarás los datos de los controladores e insertarás en SQLite
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Producto registrado en el Almacén'), backgroundColor: Colors.blue),
            );
          },
          child: const Text('Registrar'),
        ),
      ],
    );
  }
}
