import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/modo_provider.dart';
import '../widgets/app_drawer.dart';
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

    String tituloAppBar = '🛒 Punto de Venta / Caja';
    Color colorFondoAppBar = Colors.green;

    if (indexActual == 1) {
      tituloAppBar = '🏭 Almacén / Inventario';
      colorFondoAppBar = Colors.blue;
    } else if (indexActual == 2) {
      tituloAppBar = '👥 Clientes / Créditos';
      colorFondoAppBar = Colors.orange.shade800;
    } else if (indexActual == 3) {
      tituloAppBar = '📊 Reportes Financieros';
      colorFondoAppBar = Colors.blueGrey;
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
        ),
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: indexActual,
        children: const [
          VentaScreen(),
          AlmacenScreen(),
          CatalogoClientesScreen(),
          ReportesScreen(),
        ],
      ),
    );
  }
}