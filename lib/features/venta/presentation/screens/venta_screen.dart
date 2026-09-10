import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers y Widgets que hemos separado
import '../providers/venta_provider.dart';
import '../widgets/pantalla_iniciar_turno_widget.dart';
import '../widgets/selector_vista_superior_widget.dart';
import '../widgets/visor_camara_widget.dart';
import '../widgets/panel_manual_widget.dart';
import '../widgets/lista_carrito_widget.dart';
import '../widgets/barra_inferior_cobro_widget.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({Key? key}) : super(key: key);

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  // Estado local para alternar entre Vista Cámara (true) y Vista Manual (false)
  bool _esModoCamara = true;

  // Consulta de búsqueda para el panel manual
  String _queryBusqueda = '';

  // Control local temporal del turno (true = Abierto, false = Cerrado)
  bool _turnoAbierto = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_turnoAbierto
          ? PantallaIniciarTurnoWidget(
              onIniciarTurno: () {
                setState(() {
                  _turnoAbierto = true; // Abre el turno de forma local
                });
              },
            )
          : Consumer<VentaProvider>(
              builder: (context, ventaProvider, child) {
                // Filtrar los productos del panel manual según el texto ingresado
                final productosFiltrados = ventaProvider.filtrarProductos(
                  _queryBusqueda,
                );

                return Column(
                  children: [
                    // 1. Selector superior (Chips: Cámara vs Manual)
                    SelectorVistaSuperiorWidget(
                      esModoCamara: _esModoCamara,
                      onCambiarModo: (esCamara) {
                        setState(() {
                          _esModoCamara = esCamara;
                        });
                      },
                    ),

                    // 2. Vista Superior Dinámica (Visor de Cámara o Buscador Manual)
                    if (_esModoCamara)
                      VisorCamaraWidget(
                        onProductoEscaneado:
                            (codigo, nombre, precio, stock, esPreparado) {
                              final agregado = ventaProvider.agregarProducto(
                                codigo: codigo,
                                nombre: nombre,
                                precio: precio,
                                stockBase: stock,
                                esPreparado: esPreparado,
                              );

                              if (!agregado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      '¡Stock agotado o límite alcanzado!',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      )
                    else
                      PanelManualWidget(
                        productos: productosFiltrados,
                        onBuscar: (query) {
                          setState(() {
                            _queryBusqueda = query;
                          });
                        },
                        onSeleccionarProducto:
                            (codigo, nombre, precio, stock, esPreparado) {
                              final agregado = ventaProvider.agregarProducto(
                                codigo: codigo,
                                nombre: nombre,
                                precio: precio,
                                stockBase: stock,
                                esPreparado: esPreparado,
                              );

                              if (!agregado) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      '¡Stock agotado o límite alcanzado!',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      ),

                    const Divider(height: 1, thickness: 2),

                    // 3. Lista de la Canasta / Carrito envuelta en Expanded
                    // Esto es vital en teléfonos chicos para que la lista se comprima
                    // y no empuje los elementos hacia afuera de la pantalla.
                    Expanded(
                      child: ListaCarritoWidget(
                        carrito: ventaProvider.carrito,
                        onIncrementar: (index) {
                          final exito = ventaProvider.incrementarCantidad(
                            index,
                          );
                          if (!exito) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No hay más stock disponible'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        onDecrementar: (index) {
                          ventaProvider.decrementarCantidad(index);
                        },
                        onEliminar: (index) {
                          ventaProvider.eliminarItem(index);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),

      // 4. Barra Inferior colocada como bottomNavigationBar nativa del Scaffold.
      // En dispositivos de gama baja o con botones físicos/virtuales inferiores,
      // esto le indica al sistema que debe flotar exactamente por encima de ellos.
      // 4. Barra Inferior protegida con SafeArea
      bottomNavigationBar: Consumer<VentaProvider>(
        builder: (context, ventaProvider, child) {
          if (!_turnoAbierto) return const SizedBox.shrink();

          // Envolvemos con SafeArea para que respete los botones/gestos del sistema
          return SafeArea(
            child: BarraInferiorCobroWidget(
              total: ventaProvider.totalCanasta,
              onLimpiarPressed: () {
                if (ventaProvider.carrito.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Limpiar canasta'),
                      content: const Text(
                        '¿Estás seguro de vaciar todos los productos?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            ventaProvider.limpiarCarrito();
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Sí, limpiar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              onCobrarPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Procesando pago por \$${ventaProvider.totalCanasta.toStringAsFixed(2)}...',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
