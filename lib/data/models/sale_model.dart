import '../../core/database/generic_repository.dart';

class VentaModel extends BaseModel {
  final int turnoId;
  final int? clienteId;
  final String fecha;
  final double total;
  final String metodoPago; // 'efectivo', 'tarjeta', 'credito'
  final String estadoPago; // 'pagado', 'pendiente', 'parcial'

  VentaModel({
    super.id,
    required this.turnoId,
    this.clienteId,
    required this.fecha,
    required this.total,
    required this.metodoPago,
    required this.estadoPago,
  });

  factory VentaModel.fromMap(Map<String, dynamic> map) {
    return VentaModel(
      id: map['id'] as int?,
      turnoId: map['turno_id'] as int,
      clienteId: map['cliente_id'] as int?,
      fecha: map['fecha'] as String,
      total: (map['total'] as num).toDouble(),
      metodoPago: map['metodo_pago'] as String,
      estadoPago: map['estado_pago'] as String,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'turno_id': turnoId,
      'cliente_id': clienteId,
      'fecha': fecha,
      'total': total,
      'metodo_pago': metodoPago,
      'estado_pago': estadoPago,
    };
  }

  VentaModel copyWith({
    int? id,
    int? turnoId,
    int? clienteId,
    String? fecha,
    double? total,
    String? metodoPago,
    String? estadoPago,
  }) {
    return VentaModel(
      id: id ?? this.id,
      turnoId: turnoId ?? this.turnoId,
      clienteId: clienteId ?? this.clienteId,
      fecha: fecha ?? this.fecha,
      total: total ?? this.total,
      metodoPago: metodoPago ?? this.metodoPago,
      estadoPago: estadoPago ?? this.estadoPago,
    );
  }

  @override
  String toString() {
    return 'VentaModel(id: $id, total: $total, metodoPago: "$metodoPago", estadoPago: "$estadoPago")';
  }
}