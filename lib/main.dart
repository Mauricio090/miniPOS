import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

// 1. Importamos los administradores de estado
import 'features/control_modos/presentation/providers/modo_provider.dart';
import 'features/venta/presentation/providers/venta_provider.dart'; // <--- ¡Asegúrate de ajustar esta ruta según dónde guardaste tu archivo!

// 2. Importamos la interfaz base
import 'features/control_modos/presentation/screens/main_screen.dart';

void main() {
  runApp(
    // Envolvemos toda la aplicación con los proveedores globales
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModoProvider()),
        ChangeNotifierProvider(create: (_) => VentaProvider()), // <--- ¡AQUÍ ESTABA EL FALTANTE!
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini POS Móvil',
      debugShowCheckedModeBanner: false,
      home: const MainScreen(), 
    );
  }
}