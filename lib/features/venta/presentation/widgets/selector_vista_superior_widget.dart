import 'package:flutter/material.dart';

class SelectorVistaSuperiorWidget extends StatelessWidget {
  final bool esModoCamara;
  final ValueChanged<bool> onCambiarModo;

  const SelectorVistaSuperiorWidget({
    Key? key,
    required this.esModoCamara,
    required this.onCambiarModo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChip(
            label: const Text('Cámara / Escáner'),
            selected: esModoCamara,
            onSelected: (selected) => onCambiarModo(true),
          ),
          const SizedBox(width: 12),
          ChoiceChip(
            label: const Text('Búsqueda Manual'),
            selected: !esModoCamara,
            onSelected: (selected) => onCambiarModo(false),
          ),
        ],
      ),
    );
  }
}