import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/modo_provider.dart';
import '../../../almacen/presentation/screens/almacen_screen.dart';
import '../../../venta/presentation/screens/venta_screen.dart';
import '../../../pagos_clientes/presentation/screens/catalogo_clientes_screen.dart';
import '../../../reportes/presentation/screens/reportes_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modoProvider = context.watch<ModoProvider>();
    final indexActual = modoProvider.pantallaActualIndex;

    // Título y color dinámico de la barra superior según la pestaña activa en el menú lateral
    String tituloAppBar = '🛒 Punto de Venta / Caja';
    Color colorFondoAppBar = Colors.green;

    if (indexActual == 1) {
      tituloAppBar = '🏭 Almacén / Inventario';
      colorFondoAppBar = Colors.blue;
    } else if (indexActual == 2) {
      tituloAppBar = '👥 Clientes de Confianza';
      colorFondoAppBar = Colors.orange.shade800;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tituloAppBar,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: colorFondoAppBar,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Mantiene el botón de las 3 líneas blanco
      ),
      // 🚪 MENÚ DESPLEGABLE LATERAL (Drawer con tus opciones de negocio)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: indexActual == 0
                    ? Colors.green
                    : (indexActual == 1 ? Colors.blue : Colors.orange.shade800),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.storefront, size: 36, color: Colors.blueGrey),
              ),
              accountName: const Text(
                'Micromercado & Café',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text(
                'Administrador de Turno',
                style: TextStyle(color: Colors.white70),
              ),
            ),

            // Opción 1: Punto de Venta
            ListTile(
              leading: Icon(
                Icons.shopping_cart,
                color: indexActual == 0 ? Colors.green : Colors.grey,
              ),
              title: Text(
                'Punto de Venta / Caja',
                style: TextStyle(
                  fontWeight: indexActual == 0
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: indexActual == 0,
              selectedColor: Colors.green,
              onTap: () {
                Navigator.pop(context);
                modoProvider.cambiarPantalla(0);
              },
            ),

            // Opción 2: Almacén
            ListTile(
              leading: Icon(
                Icons.inventory,
                color: indexActual == 1 ? Colors.blue : Colors.grey,
              ),
              title: Text(
                'Almacén / Inventario',
                style: TextStyle(
                  fontWeight: indexActual == 1
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: indexActual == 1,
              selectedColor: Colors.blue,
              onTap: () {
                Navigator.pop(context);
                modoProvider.cambiarPantalla(1);
              },
            ),

            // Opción 3: Clientes Fiados
            ListTile(
              leading: Icon(
                Icons.people,
                color: indexActual == 2 ? Colors.orange.shade800 : Colors.grey,
              ),
              title: Text(
                'Clientes Fiados / Carteras',
                style: TextStyle(
                  fontWeight: indexActual == 2
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: indexActual == 2,
              selectedColor: Colors.orange.shade800,
              onTap: () {
                Navigator.pop(context);
                modoProvider.cambiarPantalla(2);
              },
            ),

            // Opción 4: Reportes (Solo visual / Alerta provisional)
            // 📊 Opción 4: Reportes (¡AHORA CONECTADO DE FORMA REAL!)
            ListTile(
              leading: Icon(
                Icons.analytics,
                color: indexActual == 3 ? Colors.blueGrey : Colors.grey,
              ),
              title: Text(
                'Reportes Financieros',
                style: TextStyle(
                  fontWeight: indexActual == 3
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: indexActual == 3,
              selectedColor: Colors.blueGrey,
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                modoProvider.cambiarPantalla(
                  3,
                ); // Cambia el índice para cargar las pestañas de reportes
              },
            ),
          ],
        ),
      ),

      // Cuerpo dinámico: Intercambia las tres pantallas principales de tu micromercado
      // Cuerpo dinámico: Intercambia las tres pantallas principales de tu micromercado
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: indexActual == 0
            ? const VentaScreen()
            : (indexActual == 1
                  ? const AlmacenScreen()
                  : (indexActual == 2
                        ? const CatalogoClientesScreen()
                        : const ReportesScreen())), // 📊 ¡CONECTADO REAL CON TUS PESTAÑAS!
      ),
    );
  }
}
