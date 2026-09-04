import 'package:flutter/material.dart';

class CatalogoClientesScreen extends StatefulWidget {
  const CatalogoClientesScreen({super.key});

  @override
  State<CatalogoClientesScreen> createState() => _CatalogoClientesScreenState();
}

class _CatalogoClientesScreenState extends State<CatalogoClientesScreen> {
  // Lista simulada de clientes de confianza
  final List<Map<String, dynamic>> _clientesSimulados = [
    {
      'nombre': 'Juan Pérez',
      'telefono': '555-0192',
      'credito_limite': 500.00,
      'saldo_deudor': 120.00,
    },
    {
      'nombre': 'María Chimal',
      'telefono': '555-0483',
      'credito_limite': 300.00,
      'saldo_deudor': 290.00,
    },
    {
      'nombre': 'Carlos Mendoza',
      'telefono': '555-0711',
      'credito_limite': 1000.00,
      'saldo_deudor': 0.00,
    },
  ];

  // Formulario flotante para simular registrar un cliente nuevo
  void _mostrarDialogoNuevoCliente() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add, color: Colors.green),
            SizedBox(width: 10),
            Text('Registrar Cliente'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'Nombre Completo')),
            SizedBox(height: 10),
            TextField(keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: 'Teléfono')),
            SizedBox(height: 10),
            TextField(keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Límite de Crédito Máximo (Tope)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // ✂️ CORREGIDO: Quitamos el Scaffold duplicado y la flecha de volver atrás.
    // Usamos un Stack para que el botón flotante se ubique encima de la lista.
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 80), // Margen inferior para que el botón no tape el texto
          itemCount: _clientesSimulados.length,
          itemBuilder: (context, index) {
            final cliente = _clientesSimulados[index];
            double limite = cliente['credito_limite'];
            double deuda = cliente['saldo_deudor'];
            double disponible = limite - deuda;
            bool creditoPeligro = deuda >= (limite * 0.8);

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cliente['nombre'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.phone, color: Colors.grey), onPressed: () {}),
                      ],
                    ),
                    Text('Tel: ${cliente['telefono']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Límite Asignado', style: TextStyle(fontSize: 11, color: Colors.grey)), 
                            Text('\$${limite.toStringAsFixed(2)}')
                          ]
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Deuda Actual', style: TextStyle(fontSize: 11, color: Colors.grey)), 
                            Text(
                              '\$${deuda.toStringAsFixed(2)}', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: creditoPeligro ? Colors.red : Colors.orange.shade800)
                            )
                          ]
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Disponible', style: TextStyle(fontSize: 11, color: Colors.grey)), 
                            Text(
                              '\$${disponible.toStringAsFixed(2)}', 
                              style: TextStyle(fontWeight: FontWeight.bold, color: disponible > 0 ? Colors.green : Colors.red)
                            )
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        // El botón flotante de agregar se queda en su esquina inferior derecha de forma impecable
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.orange.shade800,
            onPressed: _mostrarDialogoNuevoCliente,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
