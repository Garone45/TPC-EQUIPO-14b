CREATE DATABASE TPC_GRUPO_14b;
GO
USE TPC_GRUPO_14b;
GO

-- ==============================================================================
--  CREACIÓN DE TABLAS MAESTRAS
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
    TipoUser INT  NOT NULL,
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
    IdMarca INT NOT NULL,       
    IdCategoria INT NOT NULL,   
    IdProveedor INT NULL, 
    Descripcion VARCHAR(255) NOT NULL,
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
CREATE TABLE Compras (
    IDCompra INT IDENTITY(1,1) PRIMARY KEY,
    IDProveedor INT NOT NULL,
    Documento INT NOT NULL,
    FechaCompra DATETIME NOT NULL DEFAULT GETDATE(),
    MontoTotal DECIMAL(10,2) NOT NULL,
    Observaciones VARCHAR(200),
    Estado VARCHAR(20) DEFAULT 'Pendiente',

    -- Control
    UsuarioCreador VARCHAR(50),
    FechaRegistro DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (IDProveedor) REFERENCES Proveedores(IDProveedor)
);

GO
CREATE TABLE CompraDetalle (
    IDDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IDCompra INT NOT NULL,
    IDArticulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    Subtotal AS (Cantidad * PrecioUnitario) PERSISTED,

    FOREIGN KEY (IDCompra) REFERENCES Compras(IDCompra),
    FOREIGN KEY (IDArticulo) REFERENCES Articulos(IdArticulo)
    );

-- ==============================================================================
-- 4. CARGA DE DATOS INICIALES
-- ==============================================================================
GO
-- Importante: Seteamos el formato de fecha a Año-Mes-Día para evitar errores
SET DATEFORMAT ymd; 
GO

-- INSERTAMOS USUARIOS CON TIPO USER EN INT 
INSERT INTO Usuario (NombreUser, Contraseña, TipoUser, Activo)
VALUES
('admin', 'admin', 1, 1), -- Admin (ROL = 2)
('vendedor', 'vendedor', 2, 1);    -- Vendedor (ROL = 1)

GO
INSERT INTO Marcas (Descripcion) VALUES ('View Sonic'), ('Tec-x'), ('Hogar Pro'), ('Asus'), ('Lenovo');
GO
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Accesorios'), ('Limpieza'),('Perifericos');
GO
INSERT INTO Proveedores (RazonSocial, CUIT, Telefono, Email, Direccion) VALUES 
('Importadora Global S.A.', '30112233445', '1155556666', 'ventas@global.com', 'Puerto Madero 900'),
('Constudiseño', '30998877662', '1144443333', 'contacto@foschia.com', 'Av. Sobremonte 2020'),
('Distribuidora del Norte', '30998877661', '1144443333', 'contacto@norte.com', 'Av. Cabildo 2020');
GO
INSERT INTO Cliente (Nombre, Apellido, Dni, Telefono, Email, Direccion, Activo) VALUES
('Lucas', 'Perez', '35842123', '1145219874', 'lucas@mail.com', 'Calle 123', 1),
('Martina', 'Gomez', '42781562', '1135871425', 'martina@mail.com', 'Av. Rivadavia 4567', 1),
('Diego', 'Fernandez', '40123548', '1178942563', 'diego@mail.com', 'San Martín 985', 0),
('Sofía', 'Rodriguez', '38965412', '1121473698', 'sofia@mail.com', 'Belgrano 1770', 1),
('Valentina', 'Lopez', '45123987', '1163258741', 'valentina@mail.com', 'Mitre 320', 1);

-- Artículos (Relacionados con Marca 1, Categoria 1 y Proveedor 1, etc.)
INSERT INTO Articulos (Descripcion,IdMarca, IdCategoria, IdProveedor, PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo) VALUES 
('Monitor LED 24"',1, 1, 1, 10000.00, 35, 50, 5), 
('Silla de Oficina', 2, 2, 2, 8500.50, 40, 20, 3), 
('Licuadora 1.5L',3, 3, 1, 3200.00, 30, 100, 10);

-- Pedidos (Usamos los IDs de cliente que acabamos de crear: 1 a 5)
INSERT INTO Pedidos (IDCliente, IDVendedor, FechaCreacion, FechaEntrega, MetodoPago, Estado, Descuento, Total)
VALUES
(1, 1, '2025-10-29', null, 'Efectivo', 'Pendiente', 5.00, 14250.00),
(2, 2, '2025-10-31', null, 'Tarjeta', 'Cancelado', 0.00, 25000.00),
(3, 3, '2025-11-01', null, 'Transferencia', 'Entregado', 10.00, 9000.00),
(4, 4, '2025-11-03', null, 'Efectivo', 'Pendiente', 0.00, 5000.00),
(5, 5, '2025-11-04', null, 'Tarjeta', 'Pendiente', 3.50, 11580.00);
GO

INSERT INTO DetallesPedido (IDPedido,IDArticulo,Cantidad,PrecioUnitario)
VALUES
(1,1,2,5000),
(2,2,3,10000),
(3,3,4,15300),
(4,1,1,14230),
(5,2,1,7250);



  INSERT INTO Compras
    (IDProveedor, Documento, FechaCompra, MontoTotal, Observaciones, Estado, UsuarioCreador, FechaRegistro)
VALUES
    (3, 55445555, GETDATE(), 15000, 'Compra de materiales', 'Pendiente', 'julian', GETDATE());
    GO
    DECLARE @IDCompra1 INT = SCOPE_IDENTITY();
    GO
    INSERT INTO CompraDetalle
    (IDCompra, IDArticulo, Cantidad, PrecioUnitario)
VALUES
    (2, 2, 5, 1000),
    (2, 3, 2, 5000);