CREATE DATABASE TPC_GRUPO_14b;
GO
USE TPC_GRUPO_14b;

GO
-- 2. TABLA MARCAS (Maestra 1)
CREATE TABLE Marcas (
    IdMarca INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 3. TABLA CATEGORIAS (Maestra 2)
CREATE TABLE Categorias (
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL UNIQUE,
    Activo BIT NOT NULL DEFAULT 1
);
GO

-- 4. TABLA ARTICULOS (La tabla principal)
CREATE TABLE Articulos (
    -- Renombramos a IdArticulo para consistencia con C#
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

-- 5. ESTABLECER RELACIONES (Foreign Keys)
ALTER TABLE Articulos
ADD CONSTRAINT FK_Articulo_Marca FOREIGN KEY (IdMarca) REFERENCES Marcas(IdMarca);

ALTER TABLE Articulos
ADD CONSTRAINT FK_Articulo_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categorias(IdCategoria);
GO

-- 6. INSERCIÓN DE DATOS DE PRUEBA
INSERT INTO Marcas (Descripcion) VALUES ('View Sonic'), ('Tec-x'), ('Hogar Pro');
INSERT INTO Categorias (Descripcion) VALUES ('Electrónica'), ('Accesorios'), ('Limpieza');

-- Insertar Artículos (IdMarca=2, IdCategoria=1, etc. según el orden de arriba)
INSERT INTO Articulos (Descripcion, CodigoArticulo, IdMarca, IdCategoria, PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo)
VALUES 
    ('Monitor LED 24"', 'MON-LED-A01', 2, 1, 10000.00, 0.35, 50, 5), 
    ('Silla de Oficina Ergonómica', 'SILL-ERG-X02', 3, 3, 8500.50, 0.40, 20, 3), 
    ('Licuadora 1.5L', 'LIC-HPRO-03', 1, 2, 3200.00, 0.30, 100, 10);
GO

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
USE TPC_GRUPO_14b;
GO

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
