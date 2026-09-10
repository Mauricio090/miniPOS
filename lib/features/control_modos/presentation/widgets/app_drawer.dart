import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/modo_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final modoProvider = context.watch<ModoProvider>();
    final indexActual = modoProvider.pantallaActualIndex;

    Color headerColor = Colors.green;
    if (indexActual == 1) headerColor = Colors.blue;
    if (indexActual == 2) headerColor = Colors.orange.shade800;
    if (indexActual == 3) headerColor = Colors.blueGrey;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: headerColor),
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
                fontWeight: indexActual == 0 ? FontWeight.bold : FontWeight.normal,
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
                fontWeight: indexActual == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: indexActual == 1,
            selectedColor: Colors.blue,
            onTap: () {
              Navigator.pop(context);
              modoProvider.cambiarPantalla(1);
            },
          ),

          // Opción 3: Clientes Crédito
          ListTile(
            leading: Icon(
              Icons.people,
              color: indexActual == 2 ? Colors.orange.shade800 : Colors.grey,
            ),
            title: Text(
              'Clientes / Créditos',
              style: TextStyle(
                fontWeight: indexActual == 2 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: indexActual == 2,
            selectedColor: Colors.orange.shade800,
            onTap: () {
              Navigator.pop(context);
              modoProvider.cambiarPantalla(2);
            },
          ),

          // Opción 4: Reportes
          ListTile(
            leading: Icon(
              Icons.analytics,
              color: indexActual == 3 ? Colors.blueGrey : Colors.grey,
            ),
            title: Text(
              'Reportes Financieros',
              style: TextStyle(
                fontWeight: indexActual == 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: indexActual == 3,
            selectedColor: Colors.blueGrey,
            onTap: () {
              Navigator.pop(context);
              modoProvider.cambiarPantalla(3);
            },
          ),
        ],
      ),
    );
  }
}