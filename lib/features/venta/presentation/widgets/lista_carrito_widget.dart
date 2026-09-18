import 'package:flutter/material.dart';
import '../../models/carrito_item_model.dart';

class ListaCarritoWidget extends StatelessWidget {
  final List<CarritoItemModel> carrito;
  final Function(int index) onIncrementar;
  final Function(int index) onDecrementar;
  final Function(int index) onEliminar;

  const ListaCarritoWidget({
    Key? key,
    required this.carrito,
    required this.onIncrementar,
    required this.onDecrementar,
    required this.onEliminar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (carrito.isEmpty) {
      const expanded = Expanded(
        child: Center(
          child: Text('La canasta está vacía', style: TextStyle(color: Colors.grey)),
        ),
      );
      return expanded;
    }

    return Expanded(
      child: ListView.builder(
        itemCount: carrito.length,
        itemBuilder: (context, index) {
          final item = carrito[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('\$${item.precioVenta.toStringAsFixed(2)} x ${item.cantidad} = \$${item.subtotal.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                    onPressed: () => onDecrementar(index),
                  ),
                  Text('${item.cantidad}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                    onPressed: () => onIncrementar(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => onEliminar(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}