import 'package:sqflite/sqflite.dart';
// Asegúrate de importar tu servicio global de base de datos según tu ruta en core/
import '../../../../core/database/database_service.dart'; 
import '../models/venta_model.dart';
import '../models/carrito_item_model.dart';

class VentaRepository {
  
  /// Procesa una venta completa de forma atómica (Todo o Nada)
  Future<bool> procesarVenta({
    required VentaModel venta,
    required List<CarritoItemModel> carritoItems,
  }) async {
    final db = await SqliteService.instance.database;

    try {
      // Iniciamos la transacción de SQLite
      await db.transaction((txn) async {
        
        // 1. Insertar la cabecera en la tabla 'ventas'
        final ventaId = await txn.insert('ventas', venta.toMap());

        // 2. Iterar cada ítem del carrito para registrar el detalle y descontar stock
        for (var item in carritoItems) {
          
          // Insertar en la tabla 'venta_items'
          await txn.insert('venta_items', {
            'venta_id': ventaId,
            'producto_id': item.id,
            'cantidad_vendida': item.cantidad,
            'precio_unitario': item.precioVenta,
          });

          // Descontar el stock actual en la tabla 'productos'
          await txn.rawUpdate(
            'UPDATE productos SET stock = stock - ? WHERE id = ?',
            [item.cantidad, item.id],
          );
        }

        // 3. Si el método de pago es Crédito/Fiado (valor 3) y hay un cliente asignado
        if (venta.metodoPago == 3 && venta.clienteId != null) {
          await txn.rawUpdate(
            'UPDATE clientes SET saldo = saldo - ? WHERE id = ?',
            [venta.total, venta.clienteId],
          );
        }
      });

      return true; // Transacción exitosa, cambios guardados en SQLite
    } catch (e) {
      print('❌ Error crítico al procesar la venta en la BD (Rollback ejecutado): $e');
      return false; // Hubo un fallo y la BD revirtió todos los cambios automáticamente
    }
  }

  /// Método auxiliar opcional para buscar productos en el inventario al escribir o escanear
  Future<List<Map<String, dynamic>>> buscarProductos(String query) async {
    final db = await SqliteService.instance.database;
    
    // Búsqueda por nombre o por código de barras exacto/parcial
    return await db.query(
      'productos',
      where: 'nombre LIKE ? OR codigo_barra LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      limit: 20,
    );
  }
}