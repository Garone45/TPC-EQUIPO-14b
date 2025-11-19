USE TPC_GRUPO_14b;
GO
--ARTICULOS
CREATE PROCEDURE SP_AgregarArticulo
    @Descripcion VARCHAR(255),
    @CodigoArticulo VARCHAR(50),
    @IdMarca INT,
    @IdCategoria INT,
    @PrecioCostoActual DECIMAL(10, 2),
    @PorcentajeGanancia DECIMAL(5, 2),
    @StockActual INT,
    @StockMinimo INT,
    @Activo BIT 
AS
BEGIN
    INSERT INTO dbo.Articulos (
        Descripcion, 
        CodigoArticulo, 
        IdMarca, 
        IdCategoria, 
        PrecioCostoActual, 
        PorcentajeGanancia, 
        StockActual, 
        StockMinimo,
        Activo 
    )
    VALUES (
        @Descripcion, 
        @CodigoArticulo, 
        @IdMarca, 
        @IdCategoria, 
        @PrecioCostoActual, 
        @PorcentajeGanancia, 
        @StockActual, 
        @StockMinimo,
        @Activo 
    );
END
GO

CREATE PROCEDURE SP_ModificarArticulo
-- ID para saber cuál modificar
@IdArticulo INT, 
@Descripcion VARCHAR(255),
@CodigoArticulo VARCHAR(50),
@IdMarca INT,
@IdCategoria INT,
@PrecioCostoActual DECIMAL(10, 2),
@PorcentajeGanancia DECIMAL(5, 2),
@StockActual INT,
@StockMinimo INT,
@Activo BIT
AS
BEGIN
UPDATE dbo.Articulos
SET 
    Descripcion = @Descripcion,
    CodigoArticulo = @CodigoArticulo,
    IdMarca = @IdMarca,
    IdCategoria = @IdCategoria,
    PrecioCostoActual = @PrecioCostoActual,
    PorcentajeGanancia = @PorcentajeGanancia,
    StockActual = @StockActual,
    StockMinimo = @StockMinimo,
    Activo = @Activo
WHERE 
    IdArticulo = @IdArticulo; -- La condición clave
END
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'SP_ObtenerArticuloPorID')
DROP PROCEDURE SP_ObtenerArticuloPorID;
GO

CREATE PROCEDURE SP_ObtenerArticuloPorID
@IdArticulo INT
AS
BEGIN
SELECT 
    A.IdArticulo, A.Descripcion, A.CodigoArticulo, A.Activo, 
    A.PrecioCostoActual, A.PorcentajeGanancia, A.StockActual, A.StockMinimo,
        
    -- Datos de las tablas unidas
    M.IdMarca, M.Descripcion AS MarcaDescripcion,
    C.IdCategoria, C.Descripcion AS CategoriaDescripcion
FROM 
    dbo.Articulos A
INNER JOIN 
    dbo.Marcas M ON M.IdMarca = A.IdMarca
INNER JOIN 
    dbo.Categorias C ON C.IdCategoria = A.IdCategoria
WHERE 
    A.IdArticulo = @IdArticulo; -- El filtro clave
END
GO

CREATE PROCEDURE SP_EliminarLogicoArticulo
    @IdArticulo INT
AS
BEGIN
    UPDATE dbo.Articulos
    SET 
        Activo = 0 -- Seteamos Activo a 0 (Baja Lógica)
    WHERE 
        IdArticulo = @IdArticulo;
END


-- MARCAS
go

CREATE PROCEDURE SP_AgregarMarca
   @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO dbo.Marcas (Descripcion, Activo)
    VALUES (@Descripcion, 1);
	END
	GO
	CREATE PROCEDURE SP_ModificarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(100)
AS
BEGIN
    UPDATE dbo.Marcas
    SET Descripcion = @Descripcion
    WHERE IDMarca = @IdMarca;
END
GO

CREATE PROCEDURE SP_EliminarLogicoMarca
    @IdMarca INT
AS
BEGIN
    UPDATE dbo.Marcas
    SET 
        Activo = 0 -- Baja Lógica
    WHERE 
        IDMarca = @IdMarca;
END
GO

CREATE PROCEDURE SP_ObtenerMarcaPorID
    @IdMarca INT
AS
BEGIN
    SELECT 
        IDMarca, 
        Descripcion, 
        Activo
    FROM 
        dbo.Marcas
    WHERE 
        IDMarca = @IdMarca;
END
GO

-- CATEGORIAS

GO

-- 1. SP para Agregar (CREATE)

CREATE PROCEDURE SP_AgregarProveedor
    @RazonSocial VARCHAR(150),
    @Seudonimo VARCHAR(100),
    @CUIT VARCHAR(20),
    @Telefono VARCHAR(50),
    @Email VARCHAR(100),
    @Direccion VARCHAR(200)
AS
BEGIN
    INSERT INTO dbo.Proveedores (
        RazonSocial, Seudonimo, CUIT, Telefono, Email, Direccion, Activo
    )
    VALUES (
        @RazonSocial, @Seudonimo, @CUIT, @Telefono, @Email, @Direccion, 1
    );
END
GO

-- 2. SP para Modificar (UPDATE)
IF OBJECT_ID('SP_ModificarProveedor', 'P') IS NOT NULL
    DROP PROCEDURE SP_ModificarProveedor;
GO

CREATE PROCEDURE SP_ModificarProveedor
    @IDProveedor INT,
    @RazonSocial VARCHAR(150),
    @Seudonimo VARCHAR(100),
    @CUIT VARCHAR(20),
    @Telefono VARCHAR(50),
    @Email VARCHAR(100),
    @Direccion VARCHAR(200)
AS
BEGIN
    UPDATE dbo.Proveedores
    SET 
        RazonSocial = @RazonSocial,
        Seudonimo = @Seudonimo,
        CUIT = @CUIT,
        Telefono = @Telefono,
        Email = @Email,
        Direccion = @Direccion
    WHERE 
        IDProveedor = @IDProveedor;
END
GO

-- 3. SP para Eliminar (DELETE Lógico)
IF OBJECT_ID('SP_EliminarLogicoProveedor', 'P') IS NOT NULL
    DROP PROCEDURE SP_EliminarLogicoProveedor;
GO

CREATE PROCEDURE SP_EliminarLogicoProveedor
    @IDProveedor INT
AS
BEGIN
    UPDATE dbo.Proveedores
    SET 
        Activo = 0 -- Baja Lógica
    WHERE 
        IDProveedor = @IDProveedor;
END
GO

-- 4. SP para Obtener por ID (Para el Modificar)
IF OBJECT_ID('SP_ObtenerProveedorPorID', 'P') IS NOT NULL
    DROP PROCEDURE SP_ObtenerProveedorPorID;
GO

CREATE PROCEDURE SP_ObtenerProveedorPorID
    @IDProveedor INT
AS
BEGIN
    SELECT 
        IDProveedor, 
        RazonSocial, 
        Seudonimo, 
        CUIT, 
        Telefono, 
        Email, 
        Direccion, 
        Activo
    FROM 
        dbo.Proveedores
    WHERE 
        IDProveedor = @IDProveedor;
END
GO

CREATE PROCEDURE SP_AgregarCategoria
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validamos que no exista una categoría con la misma descripción (opcional pero recomendable)
    IF EXISTS (SELECT 1 FROM Categorias WHERE Descripcion = @Descripcion)
    BEGIN
        RAISERROR('Ya existe una categoría con esa descripción.', 16, 1);
        RETURN;
    END;

    -- Insertamos la nueva categoría
    INSERT INTO Categorias (Descripcion)
    VALUES (@Descripcion);
END;

CREATE PROCEDURE SP_RestaurarMarca
    @IDMarca INT
AS
BEGIN
    UPDATE Marcas
    SET Activo = 1
    WHERE IDMarca = @IDMarca
END

CREATE PROCEDURE SP_RestaurarCategoria
    @IdCategoria INT
AS
BEGIN
    UPDATE Categorias
    SET Activo = 1
    WHERE IdCategoria = @IdCategoria
END