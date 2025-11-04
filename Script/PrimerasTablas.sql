
GO
USE TPC_GRUPO_14b;
CREATE PROCEDURE SP_AgregarArticulo
    
    @Descripcion VARCHAR(255),
    @CodigoArticulo VARCHAR(50),
    @IdMarca INT,
    @IdCategoria INT,
    @PrecioCostoActual DECIMAL(10, 2),
    @PorcentajeGanancia DECIMAL(5, 2),
    @StockActual INT,
    @StockMinimo INT
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
        Activo -- Asumimos que siempre se crea como Activo
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
        1 -- Activo = true
    );
END
GO

select * from Articulos
select * from Marcas
SELECT A.IdArticulo, A.Descripcion, A.IdMarca, A.IdCategoria
FROM Articulos A
WHERE NOT EXISTS (SELECT 1 FROM Marcas M WHERE M.IdMarca = A.IdMarca)
   OR NOT EXISTS (SELECT 1 FROM Categorias C WHERE C.IdCategoria = A.IdCategoria);

   SELECT COUNT(*) FROM Articulos; -- total en DB
SELECT COUNT(*) FROM Articulos A
JOIN Marcas M ON M.IdMarca = A.IdMarca
JOIN Categorias C ON C.IdCategoria = A.IdCategoria;



