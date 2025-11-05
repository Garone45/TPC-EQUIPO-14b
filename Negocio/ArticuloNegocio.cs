using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data; // Para DBNull
using Dominio.Articulos;
using Negocio; // Para AccesoDatos

namespace Negocio
{
    public class ArticuloNegocio
    {
        public List<Articulo> listar()
        {
            List<Articulo> lista = new List<Articulo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {

                datos.setearConsulta(
                "SELECT " +
                "A.IdArticulo, A.Descripcion, A.CodigoArticulo, A.Activo, " +
                "A.PrecioCostoActual, A.PorcentajeGanancia, A.StockActual, A.StockMinimo, " +
                "M.IdMarca, M.Descripcion AS MarcaDescripcion, " +
                "C.IdCategoria, C.Descripcion AS CategoriaDescripcion " +
                "FROM dbo.Articulos A " +
                "LEFT JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca " +
                "LEFT JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria " + 
                "WHERE A.Activo = 1" 
                );

                datos.ejecutarLectura();

                // 2. MAPEO
                while (datos.Lector.Read())
                {
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = datos.Lector["Descripcion"].ToString();

                    aux.CodigoArticulo = datos.Lector["CodigoArticulo"] != DBNull.Value
                        ? datos.Lector["CodigoArticulo"].ToString()
                        : "";

                    aux.StockActual = datos.Lector["StockActual"] != DBNull.Value
                        ? Convert.ToInt32(datos.Lector["StockActual"])
                        : 0;

                    aux.StockMinimo = datos.Lector["StockMinimo"] != DBNull.Value
                        ? Convert.ToInt32(datos.Lector["StockMinimo"])
                        : 0;

                    aux.PrecioCostoActual = datos.Lector["PrecioCostoActual"] != DBNull.Value
                        ? Convert.ToDecimal(datos.Lector["PrecioCostoActual"])
                        : 0;

                    aux.PorcentajeGanancia = datos.Lector["PorcentajeGanancia"] != DBNull.Value
                        ? Convert.ToDecimal(datos.Lector["PorcentajeGanancia"])
                        : 0;

                    aux.Activo = datos.Lector["Activo"] != DBNull.Value && (bool)datos.Lector["Activo"];

                    aux.Marca.IDMarca = datos.Lector["IdMarca"] != DBNull.Value
                        ? Convert.ToInt32(datos.Lector["IdMarca"])
                        : 0;
                    aux.Marca.Descripcion = datos.Lector["MarcaDescripcion"] != DBNull.Value
                        ? datos.Lector["MarcaDescripcion"].ToString()
                        : "Sin marca";

                    aux.Categorias.IDCategoria = datos.Lector["IdCategoria"] != DBNull.Value
                        ? Convert.ToInt32(datos.Lector["IdCategoria"])
                        : 0;
                    aux.Categorias.descripcion = datos.Lector["CategoriaDescripcion"] != DBNull.Value
                        ? datos.Lector["CategoriaDescripcion"].ToString()
                        : "Sin categoría";

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
    }
}