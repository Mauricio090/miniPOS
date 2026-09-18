class VentaModel {
  final int? id;
  final int turnoId;
  final int? clienteId;
  final String fecha;
  final double total;
  final int metodoPago; // 0: Efectivo, 1: Transferencia, 2: Mixto, 3: Crédito/Fiado

  VentaModel({
    this.id,
    required this.turnoId,
    this.clienteId,
    required this.fecha,
    required this.total,
    required this.metodoPago,
  });

  // Convertir a Map para hacer el insert en la tabla 'ventas' de SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'turno_id': turnoId,
      'cliente_id': clienteId,
      'fecha': fecha,
      'total': total,
      'metodo_pago': metodoPago,
    };
  }

  // Crear una VentaModel desde un registro de la base de datos (por si haces consultas históricas)
  factory VentaModel.fromMap(Map<String, dynamic> map) {
    return VentaModel(
      id: map['id'],
      turnoId: map['turno_id'],
      clienteId: map['cliente_id'],
      fecha: map['fecha'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      metodoPago: map['metodo_pago'] ?? 0,
    );
  }
}