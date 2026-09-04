import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
// Importamos el administrador del estado (el interruptor global)
import 'features/control_modos/presentation/providers/modo_provider.dart';
// Importamos la interfaz base (donde se dibuja la barra superior con el Switch)
import 'features/control_modos/presentation/screens/main_screen.dart';

void main() {
  runApp(
    // 1. Envolvemos toda la aplicación con el proveedor de estado
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModoProvider()),
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
      // 2. Definimos que la primera pantalla visible sea la MainScreen
      home: const MainScreen(), 
    );
  }
}
