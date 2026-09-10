import 'package:flutter/material.dart';

class PanelManualWidget extends StatelessWidget {
  final List<Map<String, dynamic>> productos;
  final Function(String codigo, String nombre, double precio, int stock, bool esPreparado) onSeleccionarProducto;
  final ValueChanged<String> onBuscar;

  const PanelManualWidget({
    Key? key,
    required this.productos,
    required this.onSeleccionarProducto,
    required this.onBuscar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: onBuscar,
            decoration: const InputDecoration(
              hintText: 'Buscar por nombre o código...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: productos.isEmpty
                ? const Center(child: Text('No se encontraron productos'))
                : ListView.builder(
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final p = productos[index];
                      return ListTile(
                        dense: true,
                        title: Text(p['nombre']),
                        subtitle: Text('Stock: ${p['stock']} | \$${p['precio']}'),
                        trailing: const Icon(Icons.add_shopping_cart, size: 20),
                        onTap: () {
                          onSeleccionarProducto(
                            p['codigo'],
                            p['nombre'],
                            p['precio'],
                            p['stock'],
                            p['esPreparado'],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}