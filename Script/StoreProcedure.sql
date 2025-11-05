
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