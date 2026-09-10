import '../../core/database/generic_repository.dart';

class TurnoModel extends BaseModel {
  final int usuarioId;
  final String fechaApertura;
  final String? fechaCierre;
  final double montoInicial;
  final double? montoFinal;
  final bool abierto;

  TurnoModel({
    super.id,
    required this.usuarioId,
    required this.fechaApertura,
    this.fechaCierre,
    this.montoInicial = 0.0,
    this.montoFinal,
    this.abierto = true,
  });

  factory TurnoModel.fromMap(Map<String, dynamic> map) {
    return TurnoModel(
      id: map['id'] as int?,
      usuarioId: map['usuario_id'] as int,
      fechaApertura: map['fecha_apertura'] as String,
      fechaCierre: map['fecha_cierre'] as String?,
      montoInicial: (map['monto_inicial'] as num?)?.toDouble() ?? 0.0,
      montoFinal: (map['monto_final'] as num?)?.toDouble(),
      abierto: (map['abierto'] as int) == 1,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'usuario_id': usuarioId,
      'fecha_apertura': fechaApertura,
      'fecha_cierre': fechaCierre,
      'monto_inicial': montoInicial,
      'monto_final': montoFinal,
      'abierto': abierto ? 1 : 0,
    };
  }

  TurnoModel copyWith({
    int? id,
    int? usuarioId,
    String? fechaApertura,
    String? fechaCierre,
    double? montoInicial,
    double? montoFinal,
    bool? abierto,
  }) {
    return TurnoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      fechaApertura: fechaApertura ?? this.fechaApertura,
      fechaCierre: fechaCierre ?? this.fechaCierre,
      montoInicial: montoInicial ?? this.montoInicial,
      montoFinal: montoFinal ?? this.montoFinal,
      abierto: abierto ?? this.abierto,
    );
  }

  @override
  String toString() {
    return 'TurnoModel(id: $id, usuarioId: $usuarioId, abierto: $abierto, montoInicial: $montoInicial)';
  }
}