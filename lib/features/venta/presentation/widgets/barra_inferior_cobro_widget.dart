import 'package:flutter/material.dart';

class BarraInferiorCobroWidget extends StatelessWidget {
  final double total;
  final VoidCallback onCobrarPressed;
  final VoidCallback onLimpiarPressed;

  const BarraInferiorCobroWidget({
    Key? key,
    required this.total,
    required this.onCobrarPressed,
    required this.onLimpiarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('TOTAL A PAGAR:', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.cleaning_services, color: Colors.red),
                tooltip: 'Limpiar Canasta',
                onPressed: onLimpiarPressed,
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: total > 0 ? onCobrarPressed : null,
                icon: const Icon(Icons.payment),
                label: const Text('COBRAR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}