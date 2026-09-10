class CarritoItemModel {
  final int id;
  final String codigoBarras;
  final String nombre;
  final double precioVenta;
  int cantidad;
  final int stockMaximoDisponible; // Para no vender más de lo que hay

  CarritoItemModel({
    required this.id,
    required this.codigoBarras,
    required this.nombre,
    required this.precioVenta,
    this.cantidad = 1,
    required this.stockMaximoDisponible,
  });

  // Calcula el costo total de esta partida (Precio x Cantidad)
  double get totalPorProducto => precioVenta * cantidad;
}