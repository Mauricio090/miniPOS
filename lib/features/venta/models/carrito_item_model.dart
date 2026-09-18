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
  double get subtotal => precioVenta * cantidad;
}

// class CarritoItemModel {
//   final int id;
//   final String codigoBarra;
//   final String nombre;
//   final double precioVenta;
//   int cantidad;
//   final double stockMaximoDisponible;
//   final bool esPreparado;

//   CarritoItemModel({
//     required this.id,
//     required this.codigoBarra,
//     required this.nombre,
//     required this.precioVenta,
//     this.cantidad = 1,
//     required this.stockMaximoDisponible,
//     required this.esPreparado,
//   });

//   // Calcula el subtotal de este ítem en la canasta (Precio x Cantidad)
//   double get subtotal => precioVenta * cantidad;

//   // Convertir a Map por si necesitas serializarlo de forma temporal
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'codigo_barra': codigoBarra,
//       'nombre': nombre,
//       'precio_venta': precioVenta,
//       'cantidad': cantidad,
//       'stock_maximo_disponible': stockMaximoDisponible,
//       'es_preparado': esPreparado ? 1 : 0,
//     };
//   }

//   // Fábrica para crearlo directamente desde un registro de la tabla 'productos' de SQLite
//   factory CarritoItemModel.fromMap(Map<String, dynamic> map, {int cantidadInicial = 1}) {
//     return CarritoItemModel(
//       id: map['id'] ?? 0,
//       codigoBarra: map['codigo_barra'] ?? '',
//       nombre: map['nombre'] ?? '',
//       precioVenta: (map['precio_venta'] ?? 0.0).toDouble(),
//       cantidad: cantidadInicial,
//       stockMaximoDisponible: (map['stock'] ?? 0.0).toDouble(),
//       esPreparado: (map['es_preparado'] ?? 0) == 1,
//     );
//   }
// }