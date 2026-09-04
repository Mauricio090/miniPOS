import 'package:flutter/material.dart';

class ReabastecimientoDialog extends StatelessWidget {
  final String nombreProducto;
  const ReabastecimientoDialog({super.key, required this.nombreProducto});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.autorenew, color: Colors.blue),
          SizedBox(width: 10),
          Text('Abastecimiento de Stock'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nombreProducto, 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          const Text('El producto ya existe. Ingresa cuántas piezas nuevas están entrando:', style: TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 16),
          const TextField(
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Cantidad de piezas nuevas',
              hintText: 'Ej. 24',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: () {
            // Aquí en el futuro harás el UPDATE productos SET stock_actual = stock_actual + nuevas_piezas WHERE id = ...
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🔄 Inventario actualizado con éxito'), backgroundColor: Colors.blue),
            );
          },
          child: const Text('Sumar Stock'),
        ),
      ],
    );
  }
}
