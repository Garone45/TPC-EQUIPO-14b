using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ArticulosNegocio
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
                    "A.PrecioCostoActual, A.PorcentajeGanancia, A.StockActual, " +
                    "M.IdMarca, M.Descripcion AS MarcaDescripcion, " +
                    "C.IdCategoria, C.Descripcion AS CategoriaDescripcion " + 
                    "FROM dbo.Articulos A " +
                    "INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca " +
                    "INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria " + 
                    "WHERE A.Activo = 1"
                );

                datos.ejecutarLectura();

                // 2. MAPEO (Corregido para incluir Categorías)
                while (datos.Lector.Read())
                {
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria(); 

                    // ... (Mapeo de IdArticulo, Descripcion, Codigo, Stock, Precios...)
                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];
                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    // Mapeo de Marca
                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];

                    // Mapeo de Categoría
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
                datos.setearParametro("@PrecioCostoActual", nuevoArticulo.PrecioCostoActual);
                datos.setearParametro("@PorcentajeGanancia", nuevoArticulo.PorcentajeGanancia);
                datos.setearParametro("@StockActual", nuevoArticulo.StockActual);
                datos.setearParametro("@StockMinimo", nuevoArticulo.StockMinimo);

                
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
