import 'package:flutter/material.dart';

class PasarelaPagoScreen extends StatefulWidget {
  final double totalAVender;

  const PasarelaPagoScreen({super.key, required this.totalAVender});

  @override
  State<PasarelaPagoScreen> createState() => _PasarelaPagoScreenState();
}

class _PasarelaPagoScreenState extends State<PasarelaPagoScreen> {
  // 💳 Ahora soportamos los 4 métodos: 'Efectivo', 'QR', 'Mixto', 'Crédito'
  String _metodoSeleccionado = 'Efectivo';

  // Datos simulados del cliente de fiado / crédito
  final String _clienteNombre = "Juan Pérez (Cliente de Confianza)";
  final double _creditoLimite = 500.00;
  final double _saldoDeudorActual = 150.00;

  final TextEditingController _efectivoController = TextEditingController();
  final TextEditingController _qrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restablecerMontos('Efectivo');
  }

  /// Restablece los números de los campos según el método elegido
  void _restablecerMontos(String metodo) {
    setState(() {
      _metodoSeleccionado = metodo;

      if (metodo == 'Efectivo') {
        _efectivoController.text = widget.totalAVender.toStringAsFixed(2);
        _qrController.text = "0.00";
      } else if (metodo == 'QR') {
        _efectivoController.text = "0.00";
        _qrController.text = widget.totalAVender.toStringAsFixed(2);
      } else if (metodo == 'Mixto') {
        // Si es mixto, sugerimos la mitad de inicio para cada uno
        double mitad = widget.totalAVender / 2;
        _efectivoController.text = mitad.toStringAsFixed(2);
        _qrController.text = mitad.toStringAsFixed(2);
      } else if (metodo == 'Crédito') {
        // Si es crédito puro, el pago en caja es 0, todo va a fiado
        _efectivoController.text = "0.00";
        _qrController.text = "0.00";
      }
    });
  }

  /// 🧠 MATEMÁTICA INTELIGENTE: Si cambias efectivo, se calcula el QR automáticamente (para Mixto)
  void _calcularFaltanteDesdeEfectivo(String valor) {
    double efectivo = double.tryParse(valor) ?? 0.0;
    
    if (efectivo > widget.totalAVender) {
      efectivo = widget.totalAVender;
      _efectivoController.text = widget.totalAVender.toStringAsFixed(2);
      _efectivoController.selection = TextSelection.fromPosition(
        TextPosition(offset: _efectivoController.text.length)
      );
    }
    
    double qrFaltante = widget.totalAVender - efectivo;
    
    setState(() {
      _qrController.text = qrFaltante.toStringAsFixed(2);
    });
  }

  void _calcularFaltanteDesdeQR(String valor) {
    double qr = double.tryParse(valor) ?? 0.0;
    
    if (qr > widget.totalAVender) {
      qr = widget.totalAVender;
      _qrController.text = widget.totalAVender.toStringAsFixed(2);
      _qrController.selection = TextSelection.fromPosition(
        TextPosition(offset: _qrController.text.length)
      );
    }
    
    double efectivoFaltante = widget.totalAVender - qr;
    
    setState(() {
      _efectivoController.text = efectivoFaltante.toStringAsFixed(2);
    });
  }

  @override
  void dispose() {
    _efectivoController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double efectivo = double.tryParse(_efectivoController.text) ?? 0.0;
    double qr = double.tryParse(_qrController.text) ?? 0.0;
    double totalPagadoActualmente = efectivo + qr;
    
    // Si elige Crédito puro, el monto a fiar es el total. Si es Mixto, es lo que falte por cubrir.
    double montoAFiar = (_metodoSeleccionado == 'Crédito') 
        ? widget.totalAVender 
        : (widget.totalAVender - totalPagadoActualmente);
        
    if (montoAFiar < 0) montoAFiar = 0;

    double creditoDisponible = _creditoLimite - _saldoDeudorActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💳 Procesar Pago', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen del costo total
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total a Cobrar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      '\$${widget.totalAVender.toStringAsFixed(2)}', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // SELECCIÓN DE LOS 4 MÉTODOS DE PAGO
            const Text('Selecciona el Método de Pago:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('💵 Efectivo'),
                    selected: _metodoSeleccionado == 'Efectivo',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => _restablecerMontos('Efectivo'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('📲 QR'),
                    selected: _metodoSeleccionado == 'QR',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => _restablecerMontos('QR'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('🔀 Mixto'),
                    selected: _metodoSeleccionado == 'Mixto',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => _restablecerMontos('Mixto'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('📋 Crédito'),
                    selected: _metodoSeleccionado == 'Crédito',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => _restablecerMontos('Crédito'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // CASILLAS DE ENTRADA (Solo si se selecciona 'Mixto')
            if (_metodoSeleccionado == 'Mixto') ...[
              const Text('Desglose del Pago Mixto:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                controller: _efectivoController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto en Efectivo',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: _calcularFaltanteDesdeEfectivo,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _qrController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto por QR / Transferencia',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                onChanged: _calcularFaltanteDesdeQR,
              ),
              const SizedBox(height: 15),
            ] else if (_metodoSeleccionado == 'Efectivo' || _metodoSeleccionado == 'QR') ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _metodoSeleccionado == 'Efectivo' 
                        ? 'Se liquidará el total (\$${widget.totalAVender.toStringAsFixed(2)}) en Efectivo.'
                        : 'Se liquidará el total (\$${widget.totalAVender.toStringAsFixed(2)}) mediante QR.',
                    style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.blueGrey),
                  ),
                ),
              ),
            ],

            // SECCIÓN DE CRÉDITO (Aparece automáticamente si se selecciona 'Crédito' o 'Mixto')
            if (_metodoSeleccionado == 'Crédito' || _metodoSeleccionado == 'Mixto') ...[
              const Divider(height: 40),
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_clienteNombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 6),
                      Text('Crédito Máximo del Cliente: \$${_creditoLimite.toStringAsFixed(2)}'),
                      Text('Deuda Anterior Acumulada: \$${_saldoDeudorActual.toStringAsFixed(2)}'),
                      Text(
                        'Crédito Libre Disponible: \$${creditoDisponible.toStringAsFixed(2)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
                      ),
                      const Divider(),
                      Text(
                        'Monto que se sumará a Deuda: \$${montoAFiar.toStringAsFixed(2)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // BOTÓN FINAL CON REGLAS DE NEGOCIO Y VALIDACIONES
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Validación 1: Si es pago simple o mixto y el dinero ingresado no cubre el total (y no es crédito puro)
                if (_metodoSeleccionado != 'Crédito' && totalPagadoActualmente < widget.totalAVender && _metodoSeleccionado != 'Mixto') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🛑 Saldo incompleto. Revisa los montos ingresados.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Validación 2: Si involucra crédito (Crédito puro o Mixto con saldo a fiar) y excede el límite
                if ((_metodoSeleccionado == 'Crédito' || _metodoSeleccionado == 'Mixto') && montoAFiar > creditoDisponible) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('🛑 Crédito Insuficiente'),
                      content: Text('La deuda a fiar (\$${montoAFiar.toStringAsFixed(2)}) supera el límite disponible de este cliente (\$${creditoDisponible.toStringAsFixed(2)}). Compra bloqueada.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))],
                    ),
                  );
                  return;
                }

                // Todo correcto: Cierra la pantalla devolviendo éxito al carrito
                Navigator.pop(context, true); 
              },
              child: const Text('Confirmar y Registrar Pago 💾', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}