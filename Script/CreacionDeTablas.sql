CREATE DATABASE TPC_GRUPO_14b;
GO
USE TPC_GRUPO_14b;
GO

-- ==============================================================================
-- 2. CREACIÓN DE TABLAS MAESTRAS
-- ==============================================================================
CREATE TABLE Marcas (
    IdMarca INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Usuario (
    IDUsuario INT IDENTITY(1,1) PRIMARY KEY,
    NombreUser VARCHAR(100) NOT NULL,
    Contraseña VARCHAR(100) NOT NULL,
    Rol VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Cliente (
    IDCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Dni NVARCHAR(20) NOT NULL UNIQUE,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200),
    Altura NVARCHAR(10) NOT NULL DEFAULT '0',
    Localidad NVARCHAR(100) NOT NULL DEFAULT 'Desconocida',
    Activo BIT NOT NULL DEFAULT 1
);

CREATE TABLE Proveedores (
    IDProveedor INT IDENTITY(1,1) PRIMARY KEY,
    RazonSocial VARCHAR(150) NOT NULL,
    Seudonimo VARCHAR(100) NULL,
    CUIT VARCHAR(20) UNIQUE NOT NULL,
    Telefono VARCHAR(50) NULL,
    Email VARCHAR(100) NULL,
    Direccion VARCHAR(200) NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- ==============================================================================
-- 3. TABLAS PRINCIPALES (Con Relaciones)
-- ==============================================================================
-- ARTICULOS (Con relación a Proveedor, Marca y Categoría)
CREATE TABLE Articulos (
    IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(255) NOT NULL,
    CodigoArticulo VARCHAR(50) NULL, 
    IdMarca INT NOT NULL,       
    IdCategoria INT NOT NULL,   
    IdProveedor INT NULL, 
    PrecioCostoActual DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PorcentajeGanancia DECIMAL(5, 2) NOT NULL DEFAULT 0,
    StockActual INT NOT NULL DEFAULT 0,
    StockMinimo INT NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,
    
    CONSTRAINT FK_Articulo_Marca FOREIGN KEY (IdMarca) REFERENCES Marcas(IdMarca),
    CONSTRAINT FK_Articulo_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_Articulos_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IDProveedor)
);

-- PEDIDOS (Sin Subtotal, solo Total y Descuento)
CREATE TABLE Pedidos
(
    IDPedido INT IDENTITY(1,1) PRIMARY KEY,
    IDCliente INT NOT NULL,
    IDVendedor INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaEntrega DATETIME NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    Descuento DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    Total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    CONSTRAINT FK_Pedidos_Cliente FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);

-- DETALLES DE PEDIDO
CREATE TABLE DetallesPedido
(
    IDDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IDPedido INT NOT NULL,
    IDArticulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,  
    PorcentajeDescuento DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    
    CONSTRAINT FK_Detalles_Pedidos FOREIGN KEY (IDPedido) REFERENCES Pedidos (IDPedido),
    CONSTRAINT FK_Detalles_Articulos FOREIGN KEY (IDArticulo) REFERENCES Articulos (IdArticulo)
);
GO

-- ==============================================================================
-- 4. CARGA DE DATOS INICIALES
-- ==============================================================================

-- Importante: Seteamos el formato de fecha a Año-Mes-Día para evitar errores
SET DATEFORMAT ymd; 
GO

INSERT INTO Usuario (NombreUser, Contraseña, Rol, Activo) VALUES 
('admin', 'admin', 'Administrador', 1),
('vendedor', 'vendedor', 'Vendedor', 1);

INSERT INTO Marcas (Descripcion) VALUES ('View Sonic'), ('Tec-x'), ('Hogar Pro');
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Accesorios'), ('Limpieza');

INSERT INTO Proveedores (RazonSocial, CUIT, Telefono, Email, Direccion) VALUES 
('Importadora Global S.A.', '30-11223344-5', '11-5555-6666', 'ventas@global.com', 'Puerto Madero 900'),
('Distribuidora del Norte', '30-99887766-1', '11-4444-3333', 'contacto@norte.com', 'Av. Cabildo 2020');

INSERT INTO Cliente (Nombre, Apellido, Dni, Telefono, Email, Direccion, Activo) VALUES
('Lucas', 'Pérez', '35842123', '11-4521-9874', 'lucas@mail.com', 'Calle 123', 1),
('Martina', 'Gómez', '42781562', '11-3587-1425', 'martina@mail.com', 'Av. Rivadavia 4567', 1),
('Diego', 'Fernández', '40123548', '11-7894-2563', 'diego@mail.com', 'San Martín 985', 0),
('Sofía', 'Rodríguez', '38965412', '11-2147-3698', 'sofia@mail.com', 'Belgrano 1770', 1),
('Valentina', 'López', '45123987', '11-6325-8741', 'valentina@mail.com', 'Mitre 320', 1);

-- Artículos (Relacionados con Marca 1, Categoria 1 y Proveedor 1, etc.)
INSERT INTO Articulos (Descripcion, CodigoArticulo, IdMarca, IdCategoria, IdProveedor, PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo) VALUES 
('Monitor LED 24"', 'MON-LED-A01', 1, 1, 1, 10000.00, 35, 50, 5), 
('Silla de Oficina', 'SILL-ERG-X02', 2, 2, 2, 8500.50, 40, 20, 3), 
('Licuadora 1.5L', 'LIC-HPRO-03', 3, 3, 1, 3200.00, 30, 100, 10);

-- Pedidos (Usamos los IDs de cliente que acabamos de crear: 1 a 5)
INSERT INTO Pedidos (IDCliente, IDVendedor, FechaCreacion, FechaEntrega, MetodoPago, Estado, Descuento, Total)
VALUES
(1, 1, '2025-10-29', '2025-11-13', 'Efectivo', 'Pendiente', 5.00, 14250.00),
(2, 2, '2025-10-31', '2025-11-14', 'Tarjeta', 'En preparación', 0.00, 25000.00),
(3, 3, '2025-11-01', '2025-11-15', 'Transferencia', 'Entregado', 10.00, 9000.00),
(4, 4, '2025-11-03', '2025-11-17', 'Efectivo', 'Pendiente', 0.00, 5000.00),
(5, 5, '2025-11-04', '2025-11-18', 'Tarjeta', 'En preparación', 3.50, 11580.00);
GO
	