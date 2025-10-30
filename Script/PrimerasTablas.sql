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