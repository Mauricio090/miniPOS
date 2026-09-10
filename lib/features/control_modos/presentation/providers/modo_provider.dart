import 'package:flutter/foundation.dart';

class ModoProvider extends ChangeNotifier {
  // Índice privado de la pantalla actual (por defecto 0: Punto de Venta)
  int _pantallaActualIndex = 0;

  // Getter público para leer el índice desde las pantallas
  int get pantallaActualIndex => _pantallaActualIndex;

  // Método para cambiar de pantalla y notificar a los oyentes (Widgets)
  void cambiarPantalla(int nuevoIndex) {
    if (_pantallaActualIndex != nuevoIndex) {
      _pantallaActualIndex = nuevoIndex;
      notifyListeners();
    }
  }
}