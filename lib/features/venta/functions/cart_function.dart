class CarritoFunctions {
  /// Valida si se puede agregar o sumar más cantidad de un producto según su stock
  /// (Si es preparado, el stock máximo es ilimitado, simulado como 999)
  static bool validarStock(int cantidadActual, int stockMaximoDisponible, bool esPreparado) {
    if (esPreparado || stockMaximoDisponible == 999) {
      return true;
    }
    return cantidadActual < stockMaximoDisponible;
  }

  /// Filtra la lista de productos rápidos según el texto ingresado en el buscador manual
  static List<Map<String, dynamic>> filtrarProductosPanel(
    List<Map<String, dynamic>> productosBase, 
    String consultaBusqueda,
  ) {
    if (consultaBusqueda.trim().isEmpty) {
      return productosBase;
    }

    final query = consultaBusqueda.toLowerCase();
    return productosBase.where((p) {
      final nombre = p['nombre'].toString().toLowerCase();
      final codigo = p['codigo'].toString().toLowerCase();
      return nombre.contains(query) || codigo.contains(query);
    }).toList();
  }
}