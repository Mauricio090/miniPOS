import 'package:flutter/foundation.dart';
import '../../models/carrito_item_model.dart';
import '../../functions/amount.dart';
import '../../functions/cart_function.dart';

class VentaProvider extends ChangeNotifier {
  // 🛒 Lista privada del carrito
  final List<CarritoItemModel> _carrito = [];

  // 📋 Productos rápidos disponibles para el Panel Manual Superior (datos de prueba)
  final List<Map<String, dynamic>> _productosDisponiblesPanel = [
    {'codigo': '12345', 'nombre': 'Coca Cola 600ml', 'precio': 15.00, 'stock': 5, 'esPreparado': false},
    {'codigo': 'EMP-POLLO', 'nombre': 'Empanada de Pollo', 'precio': 12.00, 'stock': 999, 'esPreparado': true},
    {'codigo': 'CAF-AME', 'nombre': 'Café Americano', 'precio': 20.00, 'stock': 999, 'esPreparado': true},
    {'codigo': 'POST-PAS', 'nombre': 'Rebanada Pastel', 'precio': 30.00, 'stock': 8, 'esPreparado': false},
  ];

  // Getters públicos para que la pantalla lea los datos de forma segura
  List<CarritoItemModel> get carrito => _carrito;
  List<Map<String, dynamic>> get productosDisponiblesPanel => _productosDisponiblesPanel;

  // 🧮 Total de la canasta calculado mediante la función pura
  double get totalCanasta => CalculosVentaFunctions.calcularTotalCanasta(_carrito);

  // ➕ Agregar producto al carrito (usando validaciones de stock de la función pura)
  bool agregarProducto({
    required String codigo,
    required String nombre,
    required double precio,
    required int stockBase,
    bool esPreparado = false,
  }) {
    final index = _carrito.indexWhere((item) => item.codigoBarras == codigo);

    if (index != -1) {
      // Ya existe en la canasta, validamos si podemos sumar uno más
      final itemActual = _carrito[index];
      final puedeSumar = CarritoFunctions.validarStock(
        itemActual.cantidad, 
        itemActual.stockMaximoDisponible, 
        esPreparado,
      );

      if (puedeSumar) {
        itemActual.cantidad++;
        notifyListeners();
        return true;
      } else {
        return false; // Sin stock
      }
    } else {
      // No existe, validamos si el stock inicial permite agregarlo
      final stockEfectivo = esPreparado ? 999 : stockBase;
      if (!esPreparado && stockEfectivo <= 0) {
        return false; // Sin stock
      }

      _carrito.add(
        CarritoItemModel(
          id: DateTime.now().millisecondsSinceEpoch,
          codigoBarras: codigo,
          nombre: nombre,
          precioVenta: precio,
          stockMaximoDisponible: stockEfectivo,
        ),
      );
      notifyListeners();
      return true;
    }
  }

  // ➖ Disminuir cantidad de un producto o eliminarlo si llega a 0
  void decrementarCantidad(int index) {
    if (_carrito[index].cantidad > 1) {
      _carrito[index].cantidad--;
    } else {
      _carrito.removeAt(index);
    }
    notifyListeners();
  }

  // ➕ Aumentar cantidad de un producto existente respetando stock
  bool incrementarCantidad(int index) {
    final item = _carrito[index];
    final puedeSumar = CarritoFunctions.validarStock(
      item.cantidad, 
      item.stockMaximoDisponible, 
      item.stockMaximoDisponible == 999,
    );

    if (puedeSumar) {
      item.cantidad++;
      notifyListeners();
      return true;
    }
    return false;
  }

  // 🗑️ Eliminar renglón completo de la canasta
  void eliminarItem(int index) {
    _carrito.removeAt(index);
    notifyListeners();
  }

  // 🧹 Limpiar toda la canasta (después de cobrar con éxito)
  void limpiarCarrito() {
    _carrito.clear();
    notifyListeners();
  }

  // 🔍 Filtrar productos del panel manual usando la función pura
  List<Map<String, dynamic>> filtrarProductos(String query) {
    return CarritoFunctions.filtrarProductosPanel(_productosDisponiblesPanel, query);
  }
}