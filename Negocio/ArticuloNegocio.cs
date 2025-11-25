using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio; // Para AccesoDatos
using System;
using System.Collections.Generic;
using System.Data; // Para DBNull
using System.Data.SqlClient;

namespace Negocio
{
    public class ArticuloNegocio
    {

        // LISTAR, FILTRAR, OBTENER POR ID 
        public List<Articulo> listar() 
        {
            List<Articulo> lista = new List<Articulo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearProcedimiento("SP_ListarArticulos"); // 
                datos.ejecutarLectura();

                 // Mapeo de daots  
                while (datos.Lector.Read())
                {
                    
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];
                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.StockMinimo = (int)datos.Lector["StockMinimo"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];
                    aux.Categorias.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.Categorias.descripcion = (string)datos.Lector["CategoriaDescripcion"];
                    aux.Proveedor = new Proveedor();
                    if (!(datos.Lector["IDProveedor"] is DBNull))
                    {
                        aux.Proveedor.ID = (int)datos.Lector["IDProveedor"];
                        aux.Proveedor.RazonSocial = (string)datos.Lector["RazonSocial"];
                    }
                    else
                    {
                        // Si es NULL en la BD, mostramos un texto por defecto o lo dejamos vacío
                        aux.Proveedor.RazonSocial = "Sin Asignar";
                    }

                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar artículos: ", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public Articulo obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearProcedimiento("SP_ObtenerArticuloPorID");
                datos.setearParametro("@IdArticulo", id);

                datos.ejecutarLectura();


                if (datos.Lector.Read())
                {
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();
                    aux.Proveedor = new Proveedor();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];

                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.StockMinimo = (int)datos.Lector["StockMinimo"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];

                    aux.Categorias.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.Categorias.descripcion = (string)datos.Lector["CategoriaDescripcion"];

                    return aux;
                }

                return null;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener artículo por ID en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        public List<Articulo> filtrar(string filtro)
        {
            List<Articulo> lista = new List<Articulo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                string consulta = @"
                SELECT 
                    A.IdArticulo, A.Descripcion, A.CodigoArticulo, A.Activo,
                    A.PrecioCostoActual, A.PorcentajeGanancia, A.StockActual, A.StockMinimo,
                    M.IdMarca, M.Descripcion AS MarcaDescripcion,
                    C.IdCategoria, C.Descripcion AS CategoriaDescripcion
                FROM dbo.Articulos A
                INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca
                INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria
                WHERE A.Activo = 1
                  AND (
                        A.Descripcion LIKE @filtro
                        OR CAST(A.IdArticulo AS VARCHAR(10)) LIKE @filtro
                )";

                datos.setearConsulta(consulta);
                datos.setearParametro("@filtro", "%" + filtro + "%");
                datos.ejecutarLectura();

                // Mapeo de daots  
                while (datos.Lector.Read())
                {

                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];
                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.StockMinimo = (int)datos.Lector["StockMinimo"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];
                    aux.Categorias.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.Categorias.descripcion = (string)datos.Lector["CategoriaDescripcion"];

                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar artículos: ", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Articulo nuevoArticulo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("SP_AgregarArticulo");

                datos.setearParametro("@Descripcion", nuevoArticulo.Descripcion);
                datos.setearParametro("@CodigoArticulo", nuevoArticulo.CodigoArticulo);
                datos.setearParametro("@IdMarca", nuevoArticulo.Marca.IDMarca);
                datos.setearParametro("@IdCategoria", nuevoArticulo.Categorias.IDCategoria);
                datos.setearParametro("@IdProveedor", nuevoArticulo.Proveedor.ID);
                datos.setearParametro("@PrecioCostoActual", nuevoArticulo.PrecioCostoActual);
                datos.setearParametro("@PorcentajeGanancia", nuevoArticulo.PorcentajeGanancia);
                datos.setearParametro("@StockActual", nuevoArticulo.StockActual);
                datos.setearParametro("@StockMinimo", nuevoArticulo.StockMinimo);
                datos.setearParametro("@Activo", nuevoArticulo.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar artículo en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void modificar(Articulo articuloModificado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarArticulo");

               
                datos.setearParametro("@IdArticulo", articuloModificado.IDArticulo);
                datos.setearParametro("@Descripcion", articuloModificado.Descripcion);
                datos.setearParametro("@CodigoArticulo", articuloModificado.CodigoArticulo);
                datos.setearParametro("@IdMarca", articuloModificado.Marca.IDMarca);
                datos.setearParametro("@IdCategoria", articuloModificado.Categorias.IDCategoria);
                datos.setearParametro("@IDProveedor", articuloModificado.Proveedor.ID);
                datos.setearParametro("@PrecioCostoActual", articuloModificado.PrecioCostoActual);
                datos.setearParametro("@PorcentajeGanancia", articuloModificado.PorcentajeGanancia);
                datos.setearParametro("@StockActual", articuloModificado.StockActual);
                datos.setearParametro("@StockMinimo", articuloModificado.StockMinimo);
                datos.setearParametro("@Activo", articuloModificado.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar artículo en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        
        public void eliminarLogico(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_EliminarLogicoArticulo");
                datos.setearParametro("@IdArticulo", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar (lógico) artículo en Capa de Negocio.", ex);
            }
           
        }

        public int obtenerProximoId()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT ISNULL(MAX(IDArticulo), 0) + 1 AS ProximoID FROM Articulos");
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                    return (int)datos.Lector["ProximoID"];
                else
                    return 1;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener el próximo ID: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

    }
}