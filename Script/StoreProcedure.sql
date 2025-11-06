USE TPC_GRUPO_14b;
GO
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
    
    -- El resto de los parámetros (igual que el SP_AgregarArticulo)
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
