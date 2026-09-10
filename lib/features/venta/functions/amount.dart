import '../models/carrito_item_model.dart';

class CalculosVentaFunctions {
  /// Calcula el total acumulado de la canasta sumando el subtotal de cada ítem
  static double calcularTotalCanasta(List<CarritoItemModel> carrito) {
    return carrito.fold(0.0, (suma, item) => suma + item.totalPorProducto);
  }
}