import 'package:flutter/material.dart';

class ModoProvider extends ChangeNotifier {
  // 🔄 INDEX DE PANTALLA: 0 = Venta, 1 = Almacén, 2 = Clientes
  int _pantallaActualIndex = 0;
  
  // 🔑 CONTROL DE CAJA Y TURNOS
  bool _turnoAbierto = false;
  double _fondoInicial = 0.0;

  // Datos simulados de ventas para rendir cuentas al final del día
  final double _totalEfectivoVendido = 185.50;
  final double _totalQRVendido = 120.00;
  final double _totalFiadoVendido = 75.00;

  // GETTERS DE NAVEGACIÓN Y TURNO
  int get pantallaActualIndex => _pantallaActualIndex;
  bool get turnoAbierto => _turnoAbierto;
  double get fondoInicial => _fondoInicial;

  double get totalEfectivoVendido => _totalEfectivoVendido;
  double get totalQRVendido => _totalQRVendido;
  double get totalFiadoVendido => _totalFiadoVendido;
  
  // Sumas matemáticas sencillas
  double get efectivoTotalExpected => _fondoInicial + _totalEfectivoVendido;
  double get granTotalDelDia => _totalEfectivoVendido + _totalQRVendido + _totalFiadoVendido;

  /// Cambia la pantalla actual desde el menú desplegable (Drawer)
  void cambiarPantalla(int nuevoIndex) {
    _pantallaActualIndex = nuevoIndex;
    notifyListeners(); // Redibuja la interfaz completa
  }

  /// 🔓 Guarda el fondo para vueltos y abre la caja de ventas
  void abrirTurno(double monto) {
    _fondoInicial = monto;
    _turnoAbierto = true;
    notifyListeners(); 
  }

  /// 🔒 Cierra la caja, vacía el fondo y regresa por seguridad a la pantalla de ventas
  void cerrarTurno() {
    _turnoAbierto = false;
    _fondoInicial = 0.0;
    _pantallaActualIndex = 0; 
    notifyListeners();
  }
}
