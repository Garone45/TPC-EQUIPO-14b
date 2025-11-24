CREATE DATABASE TPC_GRUPO_14b;
GO
USE TPC_GRUPO_14b;

GO
-- TABLA MARCAS (Maestra 1)
CREATE TABLE Marcas (
    IdMarca INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- TABLA CATEGORIAS (Maestra 2)
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

--  TABLA ARTICULOS (La tabla principal)
CREATE TABLE Articulos (
    
    IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(255) NOT NULL,
    CodigoArticulo VARCHAR(50) NULL, 
   
    -- Claves Foráneas
    IdMarca INT NOT NULL,       
    IdCategoria INT NOT NULL,   
    
    -- Campos de Lógica de Negocio
    PrecioCostoActual DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PorcentajeGanancia DECIMAL(5, 2) NOT NULL DEFAULT 0,
    StockActual INT NOT NULL DEFAULT 0,
    StockMinimo INT NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1
);
GO
---ALTER TABLE ARTICULOS---
USE TPC_GRUPO_14b;
GO

-- Agregamos la columna si no existe
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IdProveedor' AND Object_ID = Object_ID(N'Articulos'))
BEGIN
    ALTER TABLE Articulos ADD IdProveedor INT NULL;
    
    ALTER TABLE Articulos 
    ADD CONSTRAINT FK_Articulos_Proveedores 
    FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IDProveedor);
END
GO


-- TABLA PEDIDOS
CREATE TABLE dbo.Pedidos
(
    IDPedido INT IDENTITY(1,1) PRIMARY KEY,
    IDCliente INT NOT NULL,
    IDVendedor INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaEntrega DATETIME NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    Descuento DECIMAL(5,2) NOT NULL DEFAULT 0.00
);

GO
INSERT INTO dbo.Pedidos (IDCliente, IDVendedor, FechaCreacion, FechaEntrega, MetodoPago, Estado, Descuento)
VALUES
(3, 1, '2025-10-29', '2025-11-13', 'Efectivo', 'Pendiente', 5.00),
(7, 2, '2025-10-31', '2025-11-14', 'Tarjeta', 'En preparación', 0.00),
(5, 3, '2025-11-01', '2025-11-15', 'Transferencia', 'Entregado', 10.00),
(11, 4, '2025-11-03', '2025-11-17', 'Efectivo', 'Pendiente', 0.00),
(2, 5, '2025-11-04', '2025-11-18', 'Tarjeta', 'En preparación', 3.50),
(9, 2, '2025-11-06', '2025-11-20', 'Transferencia', 'Pendiente', 7.00),
(1, 4, '2025-11-08', '2025-11-22', 'Efectivo', 'Pendiente', 0.00);

GO
-- TABLA DETALLES DE PEDIDOS
CREATE TABLE dbo.DetallesPedido
(
    IDDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IDPedido INT NOT NULL,
    IDArticulo INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,  
    PorcentajeDescuento DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_Detalles_Pedidos FOREIGN KEY (IDPedido) REFERENCES dbo.Pedidos (IDPedido)
);

GO
-- TABLA USUARIOS 
CREATE TABLE Usuario (
    IDUsuario INT IDENTITY(1,1) PRIMARY KEY,
    NombreUser VARCHAR(100) NOT NULL,
    Contraseña VARCHAR(100) NOT NULL,
    Rol VARCHAR(50) NOT NULL,  -- 'Administrador', 'Vendedor', 'Cliente'
    Activo BIT NOT NULL DEFAULT 1
);

INSERT INTO Usuario (NombreUser, Contraseña, Rol, Activo)
VALUES 
('mramirez', '1234', 'Vendedor', 1),
('jperez', 'abcd', 'Vendedor', 1),
('lfernandez', 'pass123', 'Vendedor', 1),
('cgomez', 'test567', 'Vendedor', 1),
('arodriguez', 'qwerty', 'Vendedor', 1),
('jtato', 'admin123', 'Administrador', 1),
('fgarone', 'root321', 'Administrador', 1);

-- ESTABLECER RELACIONES (Foreign Keys)
ALTER TABLE Articulos
ADD CONSTRAINT FK_Articulo_Marca FOREIGN KEY (IdMarca) REFERENCES Marcas(IdMarca);

ALTER TABLE Articulos
ADD CONSTRAINT FK_Articulo_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria);
GO

--  INSERCIÓN DE DATOS DE PRUEBA
INSERT INTO Marcas (Descripcion) VALUES ('View Sonic'), ('Tec-x'), ('Hogar Pro');
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Accesorios'), ('Limpieza');
-- Insertar Artículos (IdMarca=2, IdCategoria=1, etc. según el orden de arriba)
INSERT INTO Articulos (Descripcion, CodigoArticulo, IdMarca, IdCategoria, PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo)
VALUES 
    ('Monitor LED 24"', 'MON-LED-A01', 2, 1, 10000.00, 0.35, 50, 5), 
    ('Silla de Oficina Ergonómica', 'SILL-ERG-X02', 3, 3, 8500.50, 0.40, 20, 3), 
    ('Licuadora 1.5L', 'LIC-HPRO-03', 1, 2, 3200.00, 0.30, 100, 10);
GO

-- TABLA CLIENTES 
CREATE TABLE Cliente (
    IDCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL,
    Dni NVARCHAR(20) NOT NULL UNIQUE,
    Telefono NVARCHAR(20),
    Email NVARCHAR(100),
    Direccion NVARCHAR(200),
    Activo BIT NOT NULL DEFAULT 1
);

INSERT INTO Cliente (Nombre, Apellido, Dni, Telefono, Email, Direccion, Activo)
VALUES
('Lucas', 'Pérez', '35842123', '11-4521-9874', 'lucas.perez@mail.com', 'Calle 123', 1),
('Martina', 'Gómez', '42781562', '11-3587-1425', 'martina.gomez@mail.com', 'Av. Rivadavia 4567', 1),
('Diego', 'Fernández', '40123548', '11-7894-2563', 'diego.fernandez@mail.com', 'San Martín 985', 0),
('Sofía', 'Rodríguez', '38965412', '11-2147-3698', 'sofia.rodriguez@mail.com', 'Belgrano 1770', 1),
('Valentina', 'López', '45123987', '11-6325-8741', 'valentina.lopez@mail.com', 'Mitre 320', 1);

ALTER TABLE Cliente
ADD Altura NVARCHAR(10) NOT NULL DEFAULT '0',
    Localidad NVARCHAR(100) NOT NULL DEFAULT 'Desconocida';

-- TABLA PROVEEDORES 
GO
CREATE TABLE dbo.Proveedores (
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
-- Insertar un proveedor de prueba
INSERT INTO dbo.Proveedores (RazonSocial, CUIT, Telefono, Email, Direccion)
VALUES ('Proveedor de Prueba S.A.', '30-12345678-9', '11-4444-5555', 'contacto@proveedor.com', 'Calle Falsa 123');
GO