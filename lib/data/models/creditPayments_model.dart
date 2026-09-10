import '../../core/database/generic_repository.dart';

class PagoCreditoModel extends BaseModel {
  final int ventaId;
  final int turnoId;
  final double montoPagado;
  final String fechaPago;

  PagoCreditoModel({
    super.id,
    required this.ventaId,
    required this.turnoId,
    required this.montoPagado,
    required this.fechaPago,
  });

  factory PagoCreditoModel.fromMap(Map<String, dynamic> map) {
    return PagoCreditoModel(
      id: map['id'] as int?,
      ventaId: map['venta_id'] as int,
      turnoId: map['turno_id'] as int,
      montoPagado: (map['monto_pagado'] as num).toDouble(),
      fechaPago: map['fecha_pago'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'venta_id': ventaId,
      'turno_id': turnoId,
      'monto_pagado': montoPagado,
      'fecha_pago': fechaPago,
    };
  }

  PagoCreditoModel copyWith({
    int? id,
    int? ventaId,
    int? turnoId,
    double? montoPagado,
    String? fechaPago,
  }) {
    return PagoCreditoModel(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      turnoId: turnoId ?? this.turnoId,
      montoPagado: montoPagado ?? this.montoPagado,
      fechaPago: fechaPago ?? this.fechaPago,
    );
  }

  @override
  String toString() {
    return 'PagoCreditoModel(id: $id, ventaId: $ventaId, montoPagado: $montoPagado, fechaPago: "$fechaPago")';
  }
}