import '../../core/database/generic_repository.dart';

class VentaItemModel extends BaseModel {
  final int ventaId;
  final int productoId;
  final double cantidadVendida;
  final double precioUnitario;

  VentaItemModel({
    super.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidadVendida,
    required this.precioUnitario,
  });

  double get subtotal => cantidadVendida * precioUnitario;

  factory VentaItemModel.fromMap(Map<String, dynamic> map) {
    return VentaItemModel(
      id: map['id'] as int?,
      ventaId: map['venta_id'] as int,
      productoId: map['producto_id'] as int,
      cantidadVendida: (map['cantidad_vendida'] as num).toDouble(),
      precioUnitario: (map['precio_unitario'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'venta_id': ventaId,
      'producto_id': productoId,
      'cantidad_vendida': cantidadVendida,
      'precio_unitario': precioUnitario,
    };
  }

  VentaItemModel copyWith({
    int? id,
    int? ventaId,
    int? productoId,
    double? cantidadVendida,
    double? precioUnitario,
  }) {
    return VentaItemModel(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidadVendida: cantidadVendida ?? this.cantidadVendida,
      precioUnitario: precioUnitario ?? this.precioUnitario,
    );
  }

  @override
  String toString() {
    return 'VentaItemModel(id: $id, ventaId: $ventaId, productoId: $productoId, cantidad: $cantidadVendida, subtotal: $subtotal)';
  }
}