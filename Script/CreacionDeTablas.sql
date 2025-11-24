CREATE DATABASE TPC_GRUPO_14b;
GO
USE TPC_GRUPO_14b;
GO

-- 1. TABLA MARCAS
CREATE TABLE Marcas (
    IdMarca INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 2. TABLA CATEGORIAS
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 3. TABLA PROVEEDORES (La movemos ANTES de Artículos)
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

-- 4. TABLA ARTICULOS (Con IdProveedor incluido desde el inicio)
CREATE TABLE Articulos (
    IdArticulo INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(255) NOT NULL,
    CodigoArticulo VARCHAR(50) NULL, 
   
    -- Claves Foráneas
    IdMarca INT NOT NULL,       
    IdCategoria INT NOT NULL,   
    IdProveedor INT NULL, -- <--- AQUI ESTA LA NUEVA COLUMNA
    
    -- Campos de Lógica de Negocio
    PrecioCostoActual DECIMAL(10, 2) NOT NULL DEFAULT 0,
    PorcentajeGanancia DECIMAL(5, 2) NOT NULL DEFAULT 0,
    StockActual INT NOT NULL DEFAULT 0,
    StockMinimo INT NOT NULL DEFAULT 0,
    Activo BIT NOT NULL DEFAULT 1,

    -- Definición de Relaciones (Constraints)
    CONSTRAINT FK_Articulo_Marca FOREIGN KEY (IdMarca) REFERENCES Marcas(IdMarca),
    CONSTRAINT FK_Articulo_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria),
    CONSTRAINT FK_Articulos_Proveedores FOREIGN KEY (IdProveedor) REFERENCES Proveedores(IDProveedor)
);
GO

-- 5. TABLA CLIENTES
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
GO

-- 6. TABLA USUARIOS 
CREATE TABLE Usuario (
    IDUsuario INT IDENTITY(1,1) PRIMARY KEY,
    NombreUser VARCHAR(100) NOT NULL,
    Contraseña VARCHAR(100) NOT NULL,
    Rol VARCHAR(50) NOT NULL,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 7. TABLA PEDIDOS
CREATE TABLE Pedidos
(
    IDPedido INT IDENTITY(1,1) PRIMARY KEY,
    IDCliente INT NOT NULL,
    IDVendedor INT NOT NULL,
    FechaCreacion DATETIME NOT NULL DEFAULT GETDATE(),
    FechaEntrega DATETIME NULL,
    MetodoPago VARCHAR(50) NOT NULL,
    Estado VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    Subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- Agrego Subtotal si lo usas
    Descuento DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    Total DECIMAL(10,2) NOT NULL DEFAULT 0.00, -- Agrego Total si lo usas
    
    -- FKs (Opcional agregarlas aquí si tienes tabla Vendedores/Usuarios)
    CONSTRAINT FK_Pedidos_Cliente FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente)
);
GO

-- 8. TABLA DETALLES DE PEDIDOS
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

-- --- INSERTS INICIALES (Datos de Prueba) ---

INSERT INTO Usuario (NombreUser, Contraseña, Rol, Activo) VALUES 
('admin', 'admin', 'Administrador', 1),
('vendedor', 'vendedor', 'Vendedor', 1);

INSERT INTO Marcas (Descripcion) VALUES ('View Sonic'), ('Tec-x'), ('Hogar Pro');
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Accesorios'), ('Limpieza');

-- Insertamos Proveedor primero para poder usarlo en Artículos
INSERT INTO Proveedores (RazonSocial, CUIT, Telefono, Email, Direccion) VALUES 
('Importadora Global S.A.', '30-11223344-5', '11-5555-6666', 'ventas@global.com', 'Puerto Madero 900'),
('Distribuidora del Norte', '30-99887766-1', '11-4444-3333', 'contacto@norte.com', 'Av. Cabildo 2020');

-- Artículos con Proveedor (IdProveedor 1 y 2)
INSERT INTO Articulos (Descripcion, CodigoArticulo, IdMarca, IdCategoria, IdProveedor, PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo) VALUES 
('Monitor LED 24"', 'MON-LED-A01', 1, 1, 1, 10000.00, 35, 50, 5), 
('Silla de Oficina', 'SILL-ERG-X02', 2, 2, 2, 8500.50, 40, 20, 3), 
('Licuadora 1.5L', 'LIC-HPRO-03', 3, 3, 1, 3200.00, 30, 100, 10);

INSERT INTO Cliente (Nombre, Apellido, Dni, Telefono, Email, Direccion, Activo) VALUES
('Juan', 'Pérez', '12345678', '11-1111-1111', 'juan@mail.com', 'Calle Falsa 123', 1);
GO