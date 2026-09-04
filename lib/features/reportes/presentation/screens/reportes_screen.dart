import 'package:flutter/material.dart';

class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  // 🕒 Caso 1: Datos simulados del Historial de Turnos Cerrados
  final List<Map<String, dynamic>> _historialTurnos = [
    {'fecha': 'Hoy, 02:00 PM', 'cajero': 'Carlos M.', 'fondo': 200.0, 'efectivo': 185.50, 'qr': 120.00, 'fiado': 75.00},
    {'fecha': 'Ayer, 09:00 PM', 'cajero': 'Ana López', 'fondo': 300.0, 'efectivo': 420.00, 'qr': 210.00, 'fiado': 110.00},
    {'fecha': '03 Sep 2026', 'cajero': 'Carlos M.', 'fondo': 200.0, 'efectivo': 310.00, 'qr': 95.00, 'fiado': 40.00},
    {'fecha': '02 Sep 2026', 'cajero': 'Ana López', 'fondo': 300.0, 'efectivo': 550.00, 'qr': 180.00, 'fiado': 150.00},
  ];

  // ☕ Caso 2: Datos simulados de los Productos Más Vendidos (Top Ventas)
  final List<Map<String, dynamic>> _productosMasVendidos = [
    {'nombre': 'Café Americano', 'categoria': 'Cafetería', 'unidades': 42, 'total': 840.0},
    {'nombre': 'Empanada de Pollo', 'categoria': 'Cafetería', 'unidades': 35, 'total': 420.0},
    {'nombre': 'Coca Cola 600ml', 'categoria': 'Abarrotes', 'unidades': 28, 'total': 420.0},
    {'nombre': 'Rebanada Pastel', 'categoria': 'Repostería', 'unidades': 14, 'total': 420.0},
  ];

  @override
  Widget build(BuildContext context) {
    // Usamos DefaultTabController para manejar las 2 pestañas de forma nativa y limpia
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Barra de pestañas superior elegante
          Container(
            color: Colors.blueGrey.shade50,
            child: const TabBar(
              labelColor: Colors.blueGrey,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blueGrey,
              tabs: [
                Tab(icon: Icon(Icons.history), text: 'Historial de Turnos'),
                Tab(icon: Icon(Icons.star), text: 'Lo Más Vendido'),
              ],
            ),
          ),
          
          // Contenido de las pestañas
          Expanded(
            child: TabBarView(
              children: [
                _buildVistaHistorialTurnos(),
                _buildVistaProductosMasVendidos(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🕒 VISTA PESTAÑA 1: Listado de turnos pasados con su desglose financiero
  Widget _buildVistaHistorialTurnos() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _historialTurnos.length,
      itemBuilder: (context, index) {
        final turno = _historialTurnos[index];
        double totalVendido = turno['efectivo'] + turno['qr'] + turno['fiado'];
        double efectivoTotalCaja = turno['fondo'] + turno['efectivo'];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ExpansionTile(
            leading: const Icon(Icons.lock, color: Colors.blueGrey),
            title: Text(turno['fecha'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('Cajero: ${turno['cajero']} | Total Vendido: \$${totalVendido.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    const Divider(),
                    _buildFilaDetalleTurno('💵 Fondo de Caja Inicial:', '\$${turno['fondo'].toStringAsFixed(2)}'),
                    _buildFilaDetalleTurno('➕ Ventas en Efectivo:', '\$${turno['efectivo'].toStringAsFixed(2)}'),
                    _buildFilaDetalleTurno('💰 EFECTIVO ESPERADO EN CAJA:', '\$${efectivoTotalCaja.toStringAsFixed(2)}', esNegrita: true, color: Colors.green.shade700),
                    const SizedBox(height: 6),
                    _buildFilaDetalleTurno('📲 Recaudado por QR:', '\$${turno['qr'].toStringAsFixed(2)}', color: Colors.blue),
                    _buildFilaDetalleTurno('📝 Cargado a Fiados:', '\$${turno['fiado'].toStringAsFixed(2)}', color: Colors.orange.shade800),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilaDetalleTurno(String etiqueta, String valor, {bool esNegrita = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(etiqueta, style: TextStyle(fontSize: 12, fontWeight: esNegrita ? FontWeight.bold : FontWeight.normal)),
          Text(valor, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
  /// ☕ VISTA PESTAÑA 2: Listado ranking del Top de Productos más vendidos
  Widget _buildVistaProductosMasVendidos() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _productosMasVendidos.length,
      itemBuilder: (context, index) {
        final prod = _productosMasVendidos[index];
        
        // Colores estéticos para el podio del ranking (Top 1, 2, 3)
        Color colorMedalla = Colors.grey.shade400;
        if (index == 0) colorMedalla = const Color(0xFFFFD700); // 🥇 Oro
        if (index == 1) colorMedalla = const Color(0xFFC0C0C0); // 🥈 Plata
        if (index == 2) colorMedalla = const Color(0xFFCD7F32); // 🥉 Bronce

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: colorMedalla,
              radius: 18,
              child: Text(
                '${index + 1}', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)
              ),
            ),
            title: Text(prod['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('Cat: ${prod['categoria']} | Total dinero: \$${prod['total'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${prod['unidades']} uds', 
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 12)
              ),
            ),
          ),
        );
      },
    );
  }
}
