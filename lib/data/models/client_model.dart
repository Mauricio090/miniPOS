import '../../core/database/generic_repository.dart';

class ClienteModel extends BaseModel {
  final String nombre;
  final String? telefono;

  ClienteModel({
    super.id,
    required this.nombre,
    this.telefono,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      telefono: map['telefono'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'telefono': telefono,
    };
  }

  ClienteModel copyWith({
    int? id,
    String? nombre,
    String? telefono,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
    );
  }

  @override
  String toString() {
    return 'ClienteModel(id: $id, nombre: "$nombre", telefono: "$telefono")';
  }
}