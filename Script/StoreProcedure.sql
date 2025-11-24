USE TPC_GRUPO_14b;
GO

-- =============================================
--                  ARTICULOS
-- =============================================
CREATE PROCEDURE SP_AgregarArticulo
    @Descripcion VARCHAR(255),
    @CodigoArticulo VARCHAR(50),
    @IdMarca INT,
    @IdCategoria INT,
    @IdProveedor INT, -- Nuevo
    @PrecioCostoActual DECIMAL(10, 2),
    @PorcentajeGanancia DECIMAL(5, 2),
    @StockActual INT,
    @StockMinimo INT,
    @Activo BIT 
AS
BEGIN
    INSERT INTO dbo.Articulos (
        Descripcion, CodigoArticulo, IdMarca, IdCategoria, IdProveedor,
        PrecioCostoActual, PorcentajeGanancia, StockActual, StockMinimo, Activo 
    )
    VALUES (
        @Descripcion, @CodigoArticulo, @IdMarca, @IdCategoria, @IdProveedor,
        @PrecioCostoActual, @PorcentajeGanancia, @StockActual, @StockMinimo, @Activo 
    );
END
GO

CREATE PROCEDURE SP_ModificarArticulo
    @IdArticulo INT, 
    @Descripcion VARCHAR(255),
    @CodigoArticulo VARCHAR(50),
    @IdMarca INT,
    @IdCategoria INT,
    @IdProveedor INT, -- Nuevo
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
        IdProveedor = @IdProveedor,
        PrecioCostoActual = @PrecioCostoActual,
        PorcentajeGanancia = @PorcentajeGanancia,
        StockActual = @StockActual,
        StockMinimo = @StockMinimo,
        Activo = @Activo
    WHERE IdArticulo = @IdArticulo;
END
GO

CREATE PROCEDURE SP_EliminarLogicoArticulo
    @IdArticulo INT
AS
BEGIN
    UPDATE dbo.Articulos SET Activo = 0 WHERE IdArticulo = @IdArticulo;
END
GO

CREATE PROCEDURE SP_ObtenerArticuloPorID
    @IdArticulo INT
AS
BEGIN
    SELECT 
        A.*, 
        M.Descripcion AS MarcaDescripcion,
        C.Descripcion AS CategoriaDescripcion,
        P.RazonSocial -- Traemos nombre proveedor
    FROM dbo.Articulos A
    INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca
    INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria
    LEFT JOIN dbo.Proveedores P ON P.IdProveedor = A.IdProveedor
    WHERE A.IdArticulo = @IdArticulo;
END
GO

CREATE PROCEDURE SP_ListarArticulos
AS
BEGIN
    SELECT 
        A.*, 
        M.Descripcion AS MarcaDescripcion,
        C.Descripcion AS CategoriaDescripcion,
        P.RazonSocial
    FROM dbo.Articulos A
    INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca
    INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria
    LEFT JOIN dbo.Proveedores P ON P.IdProveedor = A.IdProveedor
    WHERE A.Activo = 1
END
GO

CREATE PROCEDURE SP_FiltrarArticulos
    @Filtro VARCHAR(50)
AS
BEGIN
    SELECT 
        A.*, 
        M.Descripcion AS MarcaDescripcion,
        C.Descripcion AS CategoriaDescripcion,
        P.RazonSocial
    FROM dbo.Articulos A
    INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca
    INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria
    LEFT JOIN dbo.Proveedores P ON P.IdProveedor = A.IdProveedor
    WHERE A.Activo = 1
      AND (
            A.Descripcion LIKE '%' + @Filtro + '%' 
            OR A.CodigoArticulo LIKE '%' + @Filtro + '%'
            OR M.Descripcion LIKE '%' + @Filtro + '%'
          )
END
GO

-- =============================================
--                  MARCAS
-- =============================================

CREATE PROCEDURE SP_AgregarMarca
   @Descripcion VARCHAR(100)
AS
BEGIN
    INSERT INTO dbo.Marcas (Descripcion, Activo) VALUES (@Descripcion, 1);
END
GO

CREATE PROCEDURE SP_ModificarMarca
    @IdMarca INT,
    @Descripcion VARCHAR(100)
AS
BEGIN
    UPDATE dbo.Marcas SET Descripcion = @Descripcion WHERE IDMarca = @IdMarca;
END
GO

CREATE PROCEDURE SP_EliminarLogicoMarca
    @IdMarca INT
AS
BEGIN
    UPDATE dbo.Marcas SET Activo = 0 WHERE IDMarca = @IdMarca;
END
GO

CREATE PROCEDURE SP_ObtenerMarcaPorID
    @IdMarca INT
AS
BEGIN
    SELECT * FROM dbo.Marcas WHERE IDMarca = @IdMarca;
END
GO

CREATE PROCEDURE SP_RestaurarMarca
    @IDMarca INT
AS
BEGIN
    UPDATE Marcas SET Activo = 1 WHERE IDMarca = @IDMarca
END
GO



-- =============================================
--                  CATEGORIAS
-- =============================================


CREATE PROCEDURE SP_AgregarCategoria
    @Descripcion VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM Categorias WHERE Descripcion = @Descripcion)
    BEGIN
        RAISERROR('Ya existe una categoría con esa descripción.', 16, 1);
        RETURN;
    END;
    INSERT INTO Categorias (Descripcion) VALUES (@Descripcion);
END
GO

CREATE PROCEDURE SP_RestaurarCategoria
    @IdCategoria INT
AS
BEGIN
    UPDATE Categorias SET Activo = 1 WHERE IdCategoria = @IdCategoria
END
GO




-- =============================================
--                  PROVEEDORES
-- =============================================

CREATE PROCEDURE SP_AgregarProveedor
    @RazonSocial VARCHAR(150), @Seudonimo VARCHAR(100), @CUIT VARCHAR(20),
    @Telefono VARCHAR(50), @Email VARCHAR(100), @Direccion VARCHAR(200)
AS
BEGIN
    INSERT INTO dbo.Proveedores (RazonSocial, Seudonimo, CUIT, Telefono, Email, Direccion, Activo)
    VALUES (@RazonSocial, @Seudonimo, @CUIT, @Telefono, @Email, @Direccion, 1);
END
GO

CREATE PROCEDURE SP_ModificarProveedor
    @IDProveedor INT, @RazonSocial VARCHAR(150), @Seudonimo VARCHAR(100),
    @CUIT VARCHAR(20), @Telefono VARCHAR(50), @Email VARCHAR(100), @Direccion VARCHAR(200)
AS
BEGIN
    UPDATE dbo.Proveedores
    SET RazonSocial = @RazonSocial, Seudonimo = @Seudonimo, CUIT = @CUIT,
        Telefono = @Telefono, Email = @Email, Direccion = @Direccion
    WHERE IDProveedor = @IDProveedor;
END
GO


CREATE PROCEDURE SP_EliminarLogicoProveedor
    @IDProveedor INT
AS
BEGIN
    UPDATE dbo.Proveedores SET Activo = 0 WHERE IDProveedor = @IDProveedor;
END
GO

CREATE PROCEDURE SP_ObtenerProveedorPorID
    @IDProveedor INT
AS
BEGIN
    SELECT * FROM dbo.Proveedores WHERE IDProveedor = @IDProveedor;
END
GO

CREATE PROCEDURE SP_RestaurarProveedor
    @IDProveedor INT
AS
BEGIN
    UPDATE Proveedores SET Activo = 1 WHERE IDProveedor = @IDProveedor
END
GO



-- =============================================
--							CLIENTES
-- =============================================


USE TPC_GRUPO_14b;
GO
CREATE OR ALTER PROCEDURE SP_ObtenerClientePorID
    @IdCliente INT
AS
BEGIN
    SELECT 
        IDCliente, Nombre, Apellido, Dni, Telefono, 
        Email, Direccion, Altura, Localidad, Activo
    FROM Cliente
    WHERE IDCliente = @IdCliente
END
GO

use 