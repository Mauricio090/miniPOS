import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Providers y Modelos
import '../providers/venta_provider.dart';
import '../../../control_modos/presentation/providers/modo_provider.dart';
// Widgets modularizados
import '../widgets/pantalla_iniciar_turno_widget.dart';
import '../widgets/selector_vista_superior_widget.dart';
import '../widgets/visor_camara_widget.dart';
import '../widgets/panel_manual_widget.dart';
import '../widgets/lista_carrito_widget.dart';
import '../widgets/barra_inferior_cobro_widget.dart';
import '../widgets/pasarela_pago_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    // Escuchamos el proveedor de modo para saber si el turno está abierto
    final modoProvider = context.watch<ModoProvider>();

    // Si el turno está cerrado, mostramos la pantalla de inicio de turno modularizada
    if (!modoProvider.turnoAbierto) {
      return PantallaIniciarTurnoWidget(
        onIniciarTurno: (montoFondo) {
          modoProvider.abrirTurno(montoFondo);
        },
      );
    }

    return Scaffold(
      body: Consumer<VentaProvider>(
        builder: (context, ventaProvider, child) {
          // Filtrar los productos del panel manual según el texto ingresado
          final productosFiltrados = ventaProvider.filtrarProductos(_queryBusqueda);

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
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: _esModoCamara ? Colors.black87 : Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 2)),
                  ),
                  child: _esModoCamara
                      ? VisorCamaraWidget(
                          onProductoEscaneado: (codigo, nombre, precio, stock, esPreparado) {
                            final agregado = ventaProvider.agregarProducto(
                              codigo: codigo,
                              nombre: nombre,
                              precio: precio,
                              stockBase: stock,
                              esPreparado: esPreparado,
                            );

                            if (!agregado) {
                              _mostrarAlertaStock(context, '¡Stock agotado o límite alcanzado!', Colors.red);
                            }
                          },
                        )
                      : PanelManualWidget(
                          productos: productosFiltrados,
                          onBuscar: (query) {
                            setState(() {
                              _queryBusqueda = query;
                            });
                          },
                          onSeleccionarProducto: (codigo, nombre, precio, stock, esPreparado) {
                            final agregado = ventaProvider.agregarProducto(
                              codigo: codigo,
                              nombre: nombre,
                              precio: precio,
                              stockBase: stock,
                              esPreparado: esPreparado,
                            );

                            if (!agregado) {
                              _mostrarAlertaStock(context, '¡Stock agotado o límite alcanzado!', Colors.red);
                            }
                          },
                        ),
                ),
              ),

              const Divider(height: 1, thickness: 2),

              // 3. Lista de la Canasta / Carrito envuelta en Expanded
              Expanded(
                flex: 1,
                child: ListaCarritoWidget(
                  carrito: ventaProvider.carrito,
                  onIncrementar: (index) {
                    final exito = ventaProvider.incrementarCantidad(index);
                    if (!exito) {
                      _mostrarAlertaStock(context, 'No hay más stock disponible', Colors.orange);
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

      // 4. Barra Inferior conectada a la pasarela de pagos y protegida con SafeArea
      bottomNavigationBar: Consumer<VentaProvider>(
        builder: (context, ventaProvider, child) {
          if (!modoProvider.turnoAbierto) return const SizedBox.shrink();

          return SafeArea(
            child: BarraInferiorCobroWidget(
              total: ventaProvider.totalCanasta,
              onLimpiarPressed: () {
                if (ventaProvider.carrito.isNotEmpty) {
                  _mostrarDialogoLimpiar(context, ventaProvider);
                }
              },
              onCobrarPressed: ventaProvider.carrito.isEmpty
                  ? () {} // Deshabilitado visualmente o sin acción si está vacío
                  : () async {
                      // Integración de la pasarela de pagos que te gusta
                      final ventaConfirmada = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasarelaPagoScreen(totalAVender: ventaProvider.totalCanasta),
                        ),
                      );

                      if (ventaConfirmada == true) {
                        ventaProvider.limpiarCarrito();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✅ ¡Venta Guardada con Éxito!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
            ),
          );
        },
      ),
    );
  }

  void _mostrarAlertaStock(BuildContext context, String mensaje, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _mostrarDialogoLimpiar(BuildContext context, VentaProvider ventaProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpiar canasta'),
        content: const Text('¿Estás seguro de vaciar todos los productos?'),
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
}