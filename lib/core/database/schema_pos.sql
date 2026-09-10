PRAGMA foreign_keys = ON;

-- 1. USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre          TEXT NOT NULL,
    pin_password    TEXT,
    activo          INTEGER NOT NULL DEFAULT 1
);

-- 2. TURNOS
CREATE TABLE IF NOT EXISTS turnos (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id      INTEGER NOT NULL,
    fecha_apertura  TEXT NOT NULL,
    fecha_cierre    TEXT,
    monto_inicial   REAL NOT NULL DEFAULT 0.0,
    monto_final     REAL,
    abierto         INTEGER NOT NULL DEFAULT 1,

    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE INDEX IF NOT EXISTS idx_turnos_abierto ON turnos(abierto);

-- 3. PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    codigo_barra    TEXT UNIQUE,
    nombre          TEXT NOT NULL,
    precio_compra   REAL NOT NULL DEFAULT 0,
    precio_venta    REAL NOT NULL,
    stock           REAL NOT NULL DEFAULT 0,
    stock_minimo    REAL NOT NULL DEFAULT 5,
    unidad          TEXT NOT NULL DEFAULT 'ud',
    es_preparado    INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_productos_codigo_barra ON productos(codigo_barra);

-- 4. CLIENTES
CREATE TABLE IF NOT EXISTS clientes (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre          TEXT NOT NULL,
    telefono        TEXT
);

-- 5. VENTAS
CREATE TABLE IF NOT EXISTS ventas (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    turno_id        INTEGER NOT NULL,
    cliente_id      INTEGER,
    fecha           TEXT NOT NULL,
    total           REAL NOT NULL,
    metodo_pago     TEXT NOT NULL CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'credito')),
    estado_pago     TEXT NOT NULL CHECK (estado_pago IN ('pagado', 'pendiente', 'parcial')),

    FOREIGN KEY (turno_id) REFERENCES turnos(id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE INDEX IF NOT EXISTS idx_ventas_turno ON ventas(turno_id);
CREATE INDEX IF NOT EXISTS idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX IF NOT EXISTS idx_ventas_estado_pago ON ventas(estado_pago);

-- 6. VENTA_ITEMS
CREATE TABLE IF NOT EXISTS venta_items (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    venta_id        INTEGER NOT NULL,
    producto_id     INTEGER NOT NULL,
    cantidad_vendida REAL NOT NULL,
    precio_unitario REAL NOT NULL,

    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE INDEX IF NOT EXISTS idx_venta_items_venta ON venta_items(venta_id);
CREATE INDEX IF NOT EXISTS idx_venta_items_producto ON venta_items(producto_id);

-- 7. PAGOS_CREDITO
CREATE TABLE IF NOT EXISTS pagos_credito (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    venta_id        INTEGER NOT NULL,
    turno_id        INTEGER NOT NULL,
    monto_pagado    REAL NOT NULL,
    fecha_pago      TEXT NOT NULL,

    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (turno_id) REFERENCES turnos(id)
);

CREATE INDEX IF NOT EXISTS idx_pagos_credito_venta ON pagos_credito(venta_id);
CREATE INDEX IF NOT EXISTS idx_pagos_credito_turno ON pagos_credito(turno_id);