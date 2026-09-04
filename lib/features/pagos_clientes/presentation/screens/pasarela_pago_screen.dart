import 'package:flutter/material.dart';

class PasarelaPagoScreen extends StatefulWidget {
  final double totalAVender;

  const PasarelaPagoScreen({super.key, required this.totalAVender});

  @override
  State<PasarelaPagoScreen> createState() => _PasarelaPagoScreenState();
}

class _PasarelaPagoScreenState extends State<PasarelaPagoScreen> {
  // 'efectivo', 'qr' o 'combinado'
  String _metodoSeleccionado = 'efectivo';

  // Datos simulados del cliente de fiado
  final String _clienteNombre = "Juan Pérez (Cliente de Confianza)";
  final double _creditoLimite = 500.00;
  final double _saldoDeudorActual = 150.00;

  final TextEditingController _efectivoController = TextEditingController();
  final TextEditingController _qrController = TextEditingController();
  
  bool _esVentaAFiado = false;

  @override
  void initState() {
    super.initState();
    _restablecerMontos('efectivo');
  }

  /// Restablece los números dependiendo del botón seleccionado
  void _restablecerMontos(String metodo) {
    _metodoSeleccionado = metodo;
    if (metodo == 'efectivo') {
      _efectivoController.text = widget.totalAVender.toStringAsFixed(2);
      _qrController.text = "0.00";
    } else if (metodo == 'qr') {
      _efectivoController.text = "0.00";
      _qrController.text = widget.totalAVender.toStringAsFixed(2);
    } else {
      // Si es combinado, sugerimos la mitad de inicio
      double mitad = widget.totalAVender / 2;
      _efectivoController.text = mitad.toStringAsFixed(2);
      _qrController.text = mitad.toStringAsFixed(2);
    }
  }

  /// 🧠 MATEMÁTICA INTELIGENTE: Si cambias uno, se calcula el OTRO automáticamente
   void _calcularFaltanteDesdeEfectivo(String valor) {
    double efectivo = double.tryParse(valor) ?? 0.0;
    
    // REGLA DE NEGOCIO: Si el efectivo se pasa del total, lo topamos al límite
    if (efectivo > widget.totalAVender) {
      efectivo = widget.totalAVender;
      _efectivoController.text = widget.totalAVender.toStringAsFixed(2);
      // Opcional: Esto mueve el cursor del teclado al final del texto para que no se trabe
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
    
    // REGLA DE NEGOCIO: Si el QR se pasa del total, lo topamos al límite
    if (qr > widget.totalAVender) {
      qr = widget.totalAVender;
      _qrController.text = widget.totalAVender.toStringAsFixed(2);
      // Opcional: Esto mueve el cursor del teclado al final del texto para que no se trabe
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
    
    // Cálculo automático del saldo restante que se irá a la cuenta fiada
    double montoAFiar = widget.totalAVender - totalPagadoActualmente;
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

            // SELECCIÓN DE MÉTODO DE PAGO
            const Text('Selecciona el Método de Pago:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('💵 Efectivo'),
                    selected: _metodoSeleccionado == 'efectivo',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => setState(() => _restablecerMontos('efectivo')),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('📲 QR / Transf.'),
                    selected: _metodoSeleccionado == 'qr',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => setState(() => _restablecerMontos('qr')),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('🔀 Combinado'),
                    selected: _metodoSeleccionado == 'combinado',
                    selectedColor: Colors.green.shade100,
                    onSelected: (_) => setState(() => _restablecerMontos('combinado')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // CASILLAS DE ENTRADA (Solo aparecen y se editan si eliges 'Combinado' o si activas 'Fiado')
            if (_metodoSeleccionado == 'combinado' || _esVentaAFiado) ...[
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
                // Lógica interactiva: al teclear aquí, el campo de abajo se recalcula solo
                onChanged: _calcularFaltanteDesdeEfectivo,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _qrController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monto por Transferencia / QR',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                // Lógica interactiva: al teclear aquí, el campo de arriba se recalcula solo
                onChanged: _calcularFaltanteDesdeQR,
              ),
              const SizedBox(height: 15),
            ] else ...[
              // Si es pago simple, solo mostramos un texto limpio para no saturar la pantalla
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _metodoSeleccionado == 'efectivo' 
                        ? 'Se liquidará el total (\$${widget.totalAVender.toStringAsFixed(2)}) en Efectivo.'
                        : 'Se liquidará el total (\$${widget.totalAVender.toStringAsFixed(2)}) mediante Código QR.',
                    style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: Colors.blueGrey),
                  ),
                ),
              ),
            ],

            // SECCIÓN DE FIADOS
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('¿Fiar saldo restante a crédito?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Switch(
                  value: _esVentaAFiado,
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      _esVentaAFiado = val;
                      // Si activa fiado, abrimos el desglose mixto para que el cajero manipule los abonos
                      if (_esVentaAFiado && _metodoSeleccionado != 'combinado') {
                        _metodoSeleccionado = 'combinado';
                      }
                    });
                  },
                ),
              ],
            ),

            if (_esVentaAFiado) ...[
              const SizedBox(height: 10),
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

            // BOTÓN FINAL CON REGLAS DE NEGOCIO Y FILTROS DE SEGURIDAD
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                double pagadoTotal = (double.tryParse(_efectivoController.text) ?? 0.0) + 
                                    (double.tryParse(_qrController.text) ?? 0.0);

                // Validación 1: Si no es fiado y el dinero ingresado no cubre el total
                if (!_esVentaAFiado && pagadoTotal < widget.totalAVender) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🛑 Saldo incompleto. Ajusta los montos mixtos o activa el modo Fiado.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                // Validación 2: Requerimiento de tope de crédito excedido
                if (_esVentaAFiado && montoAFiar > creditoDisponible) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('🛑 Crédito Insuficiente'),
                      content: Text('La deuda restante (\$${montoAFiar.toStringAsFixed(2)}) supera el límite disponible de este cliente (\$${creditoDisponible.toStringAsFixed(2)}). Compra bloqueada.'),
                      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Entendido'))],
                    ),
                  );
                  return;
                }

                // Cierra la pantalla devolviendo éxito al carrito
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
