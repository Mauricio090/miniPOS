import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Escucha si el turno está abierto
import '../../models/carrito_item_model.dart';
import '../../../control_modos/presentation/providers/modo_provider.dart';
import '../../../pagos_clientes/presentation/screens/pasarela_pago_screen.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  // Controla qué se muestra en la mitad superior: 'camara' o 'manual'
  String _vistaSuperior = 'camara'; 
  String _busquedaPanelSuperior = '';

  // Lista local simulando el carrito de compras actual en pantalla (Mitad inferior)
  final List<CarritoItemModel> _carrito = [];

  // Lista de productos rápidos disponibles para el Panel Manual Superior
  final List<Map<String, dynamic>> _productosDisponiblesPanel = [
    {'codigo': '12345', 'nombre': 'Coca Cola 600ml', 'precio': 15.00, 'stock': 5, 'esPreparado': false},
    {'codigo': 'EMP-POLLO', 'nombre': 'Empanada de Pollo', 'precio': 12.00, 'stock': 999, 'esPreparado': true},
    {'codigo': 'CAF-AME', 'nombre': 'Café Americano', 'precio': 20.00, 'stock': 999, 'esPreparado': true},
    {'codigo': 'POST-PAS', 'nombre': 'Rebanada Pastel', 'precio': 30.00, 'stock': 8, 'esPreparado': false},
  ];

  // Cálculo automático de la canasta en tiempo real
  double get _totalCanasta {
    return _carrito.fold(0, (suma, item) => suma + item.totalPorProducto);
  }
  // Función unificada para meter artículos (por escáner o botones rápidos)
  void _agregarProductoAlCarrito({
    required String codigo, 
    required String nombre, 
    required double precio, 
    required int stockBase,
    bool esPreparado = false,
  }) {
    if (!esPreparado && stockBase <= 0) {
      _mostrarAlertaSinStock(nombre);
      return;
    }

    setState(() {
      final index = _carrito.indexWhere((item) => item.codigoBarras == codigo);

      if (index != -1) {
        if (esPreparado || _carrito[index].cantidad < stockBase) {
          _carrito[index].cantidad++;
        } else {
          _mostrarAlertaSinStock(nombre);
        }
      } else {
        _carrito.add(
          CarritoItemModel(
            id: DateTime.now().millisecondsSinceEpoch,
            codigoBarras: codigo,
            nombre: nombre,
            precioVenta: precio,
            stockMaximoDisponible: esPreparado ? 999 : stockBase,
          ),
        );
      }
    });
  }

  void _mostrarAlertaSinStock(String nombreProducto) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛑 ¡Bloqueado! No hay stock disponible para: $nombreProducto'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final modoProvider = context.watch<ModoProvider>();

    if (!modoProvider.turnoAbierto) {
      return _buildPantallaIniciarTurno(context, modoProvider);
    }

    return Column(
      children: [
        // 🕹️ DOS BOTONES DE INTERCAMBIO SUPERIOR
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          color: Colors.grey,
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  avatar: const Icon(Icons.qr_code_scanner, size: 16),
                  label: const Text('📷 Escáner / Cámara'),
                  selected: _vistaSuperior == 'camara',
                  selectedColor: Colors.green.shade100,
                  onSelected: (val) {
                    if (val) setState(() => _vistaSuperior = 'camara');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  avatar: const Icon(Icons.keyboard, size: 16),
                  label: const Text('✍️ Buscar Manual'),
                  selected: _vistaSuperior == 'manual',
                  selectedColor: Colors.green.shade100,
                  onSelected: (val) {
                    if (val) setState(() => _vistaSuperior = 'manual');
                  },
                ),
              ),
            ],
          ),
        ),

        // 🔲 MITAD SUPERIOR REAL (Espacio amplio para operar)
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: _vistaSuperior == 'camara' ? Colors.black87 : Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 2)),
            ),
            child: _vistaSuperior == 'camara'
                ? _buildVisorCamaraGrande()
                : _buildPanelManualConBuscador(),
          ),
        ),
        // 🛒 MITAD INFERIOR: Lista clásica con botones de control para regular la canasta
        Expanded(
          flex: 1, // Toma la otra mitad exacta para el carrito de compras
          child: _carrito.isEmpty
              ? const Center(
                  child: Text(
                    'Canasta vacía.\nUsa el escáner o panel manual de arriba.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: _carrito.length,
                  itemBuilder: (context, index) {
                    final item = _carrito[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            // ➖ Botón Menos: si llega a 1 y restas, se elimina solo de la lista
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.orange, size: 20),
                              onPressed: () {
                                setState(() {
                                  if (_carrito[index].cantidad > 1) {
                                    _carrito[index].cantidad--;
                                  } else {
                                    _carrito.removeAt(index);
                                  }
                                });
                              },
                            ),
                            Text('${item.cantidad}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            // ➕ Botón Más: suma piezas respetando el tope de existencias simuladas
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green, size: 20),
                              onPressed: () {
                                setState(() {
                                  if (_carrito[index].stockMaximoDisponible == 999 || 
                                      _carrito[index].cantidad < _carrito[index].stockMaximoDisponible) {
                                    _carrito[index].cantidad++;
                                  } else {
                                    _mostrarAlertaSinStock(_carrito[index].nombre);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${item.totalPorProducto.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            // 🗑️ Botón Eliminar: Quita por completo el renglón del carrito
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                              tooltip: 'Quitar de la canasta',
                              onPressed: () {
                                setState(() {
                                  _carrito.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // 💵 BARRA INFERIOR DE TOTAL ACUMULADO Y COBRO
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total Acumulado', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text(
                      '\$${_totalCanasta.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _carrito.isEmpty
                      ? null // Deshabilitado si no hay productos
                      : () async {
                          final ventaConfirmada = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasarelaPagoScreen(totalAVender: _totalCanasta),
                            ),
                          );

                          if (ventaConfirmada == true) {
                            setState(() {
                              _carrito.clear(); // Limpia la canasta tras cobrar con éxito
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ ¡Venta Guardada con Éxito!'), backgroundColor: Colors.green),
                            );
                          }
                        },
                  child: const Text('Cobrar 💳', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  /// 🎥 GENERADOR 1: Visor de cámara grande (Simulación superior ocupando la mitad real)
  Widget _buildVisorCamaraGrande() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.center_focus_strong, color: Colors.green, size: 50),
            const SizedBox(height: 8),
            const Text('[ Visor de Cámara de Barras Activo ]', style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart, size: 14),
                  label: const Text('Simular Con Stock', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () => _agregarProductoAlCarrito(codigo: "12345", nombre: "Coca Cola 600ml", precio: 15.00, stockBase: 5),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.block, size: 14),
                  label: const Text('Simular Sin Stock', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400, foregroundColor: Colors.white),
                  onPressed: () => _agregarProductoAlCarrito(codigo: "99991", nombre: "Papas Sabritas 45g", precio: 18.50, stockBase: 0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// ✍️ GENERADOR 2: Panel manual amplio con buscador y lista de productos para tocar
  Widget _buildPanelManualConBuscador() {
    final listaFiltradaSuperior = _productosDisponiblesPanel.where((p) {
      final nombre = p['nombre'].toString().toLowerCase();
      final codigo = p['codigo'].toString().toLowerCase();
      final consulta = _busquedaPanelSuperior.toLowerCase();
      return nombre.contains(consulta) || codigo.contains(consulta);
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
          child: SizedBox(
            height: 40,
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search, size: 18),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(),
              ),
              onChanged: (text) => setState(() => _busquedaPanelSuperior = text),
            ),
          ),
        ),
        Expanded(
          child: listaFiltradaSuperior.isEmpty
              ? const Center(child: Text('No hay productos que coincidan.', style: TextStyle(color: Colors.grey, fontSize: 13)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  itemCount: listaFiltradaSuperior.length,
                  itemBuilder: (context, index) {
                    final prod = listaFiltradaSuperior[index];
                    return Card(
                      color: Colors.grey.shade50,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        dense: true,
                        title: Text(prod['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('Precio: \$${prod['precio'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 11)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 28),
                          ),
                          onPressed: () => _agregarProductoAlCarrito(
                            codigo: prod['codigo'],
                            nombre: prod['nombre'],
                            precio: prod['precio'],
                            stockBase: prod['stock'],
                            esPreparado: prod['esPreparado'] ?? false, // 🛠️ CORREGIDO AQUÍ
                          ),
                          child: const Text('Añadir ➕', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// 🔓 INTERFAZ DE APERTURA: Bloqueo integrado exclusivo de la pestaña de ventas
  Widget _buildPantallaIniciarTurno(BuildContext context, ModoProvider modoProvider) {
    final TextEditingController fondoController = TextEditingController(text: "200.00");

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
                  decoration: const InputDecoration(labelText: 'Fondo Inicial en Efectivo', prefixText: '\$ ', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Iniciar Turno y Abrir Caja'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 48)),
                  onPressed: () {
                    double monto = double.tryParse(fondoController.text) ?? 0.0;
                    modoProvider.abrirTurno(monto);
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
