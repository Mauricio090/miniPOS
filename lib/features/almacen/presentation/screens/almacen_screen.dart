import 'package:flutter/material.dart';
import 'registro_nuevo_dialog.dart';
import 'reabastecimiento_dialog.dart';

class AlmacenScreen extends StatefulWidget {
  const AlmacenScreen({super.key});

  @override
  State<AlmacenScreen> createState() => _AlmacenScreenState();
}

class _AlmacenScreenState extends State<AlmacenScreen> {
  // Variable para controlar si el usuario está viendo el Menú Principal o el Inventario
  bool _verInventarioCompleto = false;
  String _categoriaSeleccionada = 'Todos';
  String _busquedaTexto = '';

  // Lista simulada de productos para la sección de Inventario / Catálogo (CRUD)
  final List<Map<String, dynamic>> _inventarioSimulado = [
    {'codigo': '12345', 'nombre': 'Coca Cola 600ml', 'precio_venta': 15.00, 'stock': 5, 'categoria': 'Abarrotes'},
    {'codigo': 'EMP-POLLO', 'nombre': 'Empanada de Pollo', 'precio_venta': 12.00, 'stock': 15, 'categoria': 'Cafetería'},
    {'codigo': 'CAF-AME', 'nombre': 'Café Americano', 'precio_venta': 20.00, 'stock': 99, 'categoria': 'Cafetería'},
    {'codigo': 'POST-PAS', 'nombre': 'Rebanada Pastel', 'precio_venta': 30.00, 'stock': 8, 'categoria': 'Repostería'},
  ];

  // 📷 1. BOTÓN ESCANEAR CÓDIGO: Abre directo el formulario de añadir para ver el diseño visual
  void _simularEscaneoCodigo(String codigo) {
    // Comentamos la lógica automática para priorizar tu simulación visual completa
    /*
    final existe = _inventarioSimulado.any((p) => p['codigo'] == codigo);
    if (existe) {
      showDialog(
        context: context,
        builder: (context) => const ReabastecimientoDialog(nombreProducto: "Coca Cola 600ml (Encontrado)"),
      );
      return;
    }
    */
    
    // Abre directo el formulario estético con todos los campos (Nombre, Precios, etc.)
    showDialog(
      context: context,
      builder: (context) => RegistroNuevoDialog(codigoBarras: codigo),
    );
  }

  // ✍️ 2. BOTÓN AÑADIR MANUAL: Abre también el formulario completo ignorando si se duplica
  void _simularAniadirManual(String codigoNuevo, String nombre) {
    // Comentamos el bloqueo de duplicados por criterio de pruebas estéticas visuales
    /*
    final existe = _inventarioSimulado.any((p) => p['codigo'] == codigoNuevo);
    if (existe) { ... }
    */
    
    // Salta directo al formulario de registro en blanco listo para rellenar en pantalla
    showDialog(
      context: context,
      builder: (context) => RegistroNuevoDialog(codigoBarras: codigoNuevo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('AlmacenScreen'),
      body: _verInventarioCompleto ? _buildPantallaInventario() : _buildMenuAccesosRapidos(),
    );
  }
  /// 📦 INTERFAZ DEL MENÚ PRINCIPAL: Los 3 botones grandes de acceso directo
  Widget _buildMenuAccesosRapidos() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BOTÓN 1: Escanear con Cámara
            _buildBotonMenu(
              titulo: 'Escanear Código de Barras',
              subtitulo: 'Vía rápida para simular el alta de un nuevo producto con la cámara.',
              icono: Icons.qr_code_scanner,
              color: Colors.blue.shade700,
              onPressed: () => _simularEscaneoCodigo("750105531"), // Simula un nuevo código
            ),
            const SizedBox(height: 16),
            
            // BOTÓN 2: Añadir Manualmente
            _buildBotonMenu(
              titulo: 'Añadir Producto Manual',
              subtitulo: 'Abrir formulario directo para registrar empanadas, cafés o postres.',
              icono: Icons.border_color,
              color: Colors.orange.shade700,
              onPressed: () => _simularAniadirManual("CAF-EXPRE", "Café Expreso"), 
            ),
            const SizedBox(height: 16),
            
            // BOTÓN 3: Ver Catálogo Completo
            _buildBotonMenu(
              titulo: 'Ver Inventario Completo',
              subtitulo: 'Listar todo tu negocio, buscar por teclado, filtrar categorías y abastecer stock.',
              icono: Icons.inventory_2,
              color: Colors.blueGrey.shade700,
              onPressed: () => setState(() => _verInventarioCompleto = true),
            ),
          ],
        ),
      ),
    );
  }

  /// 📋 INTERFAZ DEL INVENTARIO: Catálogo CRUD con buscador y categorías por chips
  Widget _buildPantallaInventario() {
    final listaFiltrada = _inventarioSimulado.where((p) {
      final cumpleCategoria = _categoriaSeleccionada == 'Todos' || p['categoria'] == _categoriaSeleccionada;
      final cumpleBusqueda = p['nombre'].toString().toLowerCase().contains(_busquedaTexto.toLowerCase()) ||
                             p['codigo'].toString().toLowerCase().contains(_busquedaTexto.toLowerCase());
      return cumpleCategoria && cumpleBusqueda;
    }).toList();

    return Column(
      children: [
        // Cabecera superior con botón de regreso
        Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          color: Colors.blueGrey.shade50,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
                onPressed: () => setState(() => _verInventarioCompleto = false),
              ),
              const Text('Inventario General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            ],
          ),
        ),

        // BUSCADOR POR TECLADO
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar producto manual por nombre o código...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => setState(() => _busquedaTexto = text),
          ),
        ),

        // FILTROS DE CATEGORÍAS (Chips deslizables)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            children: ['Todos', 'Abarrotes', 'Cafetería', 'Repostería'].map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: _categoriaSeleccionada == cat,
                  selectedColor: Colors.blue.shade100,
                  onSelected: (_) => setState(() => _categoriaSeleccionada = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 10),

        // LISTADO GENERAL DE TARJETAS CRUD
        Expanded(
          child: listaFiltrada.isEmpty
              ? const Center(child: Text('No se encontraron productos en esta sección.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final prod = listaFiltrada[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(prod['nombre'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('Stock: ${prod['stock']}', style: TextStyle(fontWeight: FontWeight.bold, color: prod['stock'] < 10 ? Colors.red : Colors.green)),
                              ],
                            ),
                            Text('Código: ${prod['codigo']} | Cat: ${prod['categoria']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text('Precio Venta: \$${prod['precio_venta'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            const Divider(),
                            
                            // BOTONES CRUD INDIVIDUALES DE LA TARJETA
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.add_circle_outline, size: 18),
                                  label: const Text('Abastecer Stock', style: TextStyle(fontSize: 12)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => ReabastecimientoDialog(nombreProducto: prod['nombre']),
                                    );
                                  },
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.edit, size: 18, color: Colors.orange),
                                  label: const Text('Editar', style: TextStyle(fontSize: 12, color: Colors.orange)),
                                  onPressed: () {},
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                                  label: const Text('Eliminar', style: TextStyle(fontSize: 12, color: Colors.red)),
                                  onPressed: () {},
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Widget constructor para estilizar los botones del menú de forma profesional
  Widget _buildBotonMenu({
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: color.withOpacity(0.1), radius: 26, child: Icon(icono, color: color, size: 28)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(subtitulo, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
