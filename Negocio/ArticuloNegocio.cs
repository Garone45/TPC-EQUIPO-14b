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
            SqlDataReader lector = null;

            try
            {
               
                datos.setearConsulta(
                  "SELECT " +
                    "A.IdArticulo, A.Descripcion, A.CodigoArticulo, A.StockActual, " +
                    "A.PrecioCostoActual, A.PorcentajeGanancia, " + // Necesarios para calcular PrecioVenta
                    "M.IdMarca, M.Descripcion AS MarcaDescripcion " +
                    "FROM dbo.Articulos A " + // Incluye dbo. para evitar error de objeto no válido
                    "INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca " +
                    "WHERE A.Activo = 1"
                );

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();

                    // Mapeo de campos solicitados
                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.StockActual = (int)datos.Lector["StockActual"];

                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];

                    // Mapeo de Lógica (Insumos para PrecioVenta)
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];

                    // Mapeo de la Marca
                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];

                    // El PrecioVenta se calcula automáticamente en la propiedad de la clase Articulo

                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                string errorSQL = ex.InnerException != null ? ex.InnerException.Message : ex.Message;

                // Cambia el mensaje para que la alerta muestre la causa REAL en la web
                throw new Exception("ERROR CRÍTICO SQL: " + errorSQL);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
