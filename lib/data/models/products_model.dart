import '../../core/database/generic_repository.dart';

class ProductoModel extends BaseModel {
  final String? codigoBarra;
  final String nombre;
  final double precioCompra;
  final double precioVenta;
  final double stock;
  final double stockMinimo;
  final String unidad;
  final bool esPreparado;

  ProductoModel({
    super.id,
    this.codigoBarra,
    required this.nombre,
    this.precioCompra = 0.0,
    required this.precioVenta,
    this.stock = 0.0,
    this.stockMinimo = 5.0,
    this.unidad = 'ud',
    this.esPreparado = false,
  });

  factory ProductoModel.fromMap(Map<String, dynamic> map) {
    return ProductoModel(
      id: map['id'] as int?,
      codigoBarra: map['codigo_barra'] as String?,
      nombre: map['nombre'] as String,
      precioCompra: (map['precio_compra'] as num?)?.toDouble() ?? 0.0,
      precioVenta: (map['precio_venta'] as num).toDouble(),
      stock: (map['stock'] as num?)?.toDouble() ?? 0.0,
      stockMinimo: (map['stock_minimo'] as num?)?.toDouble() ?? 5.0,
      unidad: map['unidad'] as String? ?? 'ud',
      esPreparado: (map['es_preparado'] as int) == 1,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'codigo_barra': codigoBarra,
      'nombre': nombre,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'stock': stock,
      'stock_minimo': stockMinimo,
      'unidad': unidad,
      'es_preparado': esPreparado ? 1 : 0,
    };
  }

  ProductoModel copyWith({
    int? id,
    String? codigoBarra,
    String? nombre,
    double? precioCompra,
    double? precioVenta,
    double? stock,
    double? stockMinimo,
    String? unidad,
    bool? esPreparado,
  }) {
    return ProductoModel(
      id: id ?? this.id,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      nombre: nombre ?? this.nombre,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      unidad: unidad ?? this.unidad,
      esPreparado: esPreparado ?? this.esPreparado,
    );
  }

  @override
  String toString() {
    return 'ProductoModel(id: $id, codigoBarra: "$codigoBarra", nombre: "$nombre", precioVenta: $precioVenta, stock: $stock)';
  }
}