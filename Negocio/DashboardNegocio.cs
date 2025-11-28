using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class DashboardNegocio
    {
        public decimal TotalVentasHoy()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT ISNULL(SUM(Total), 0) FROM Pedidos WHERE CAST(FechaCreacion AS DATE) = CAST(GETDATE() AS DATE) AND Estado != 'Cancelado'");
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return (decimal)datos.Lector[0]; 
                }
                return 0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

     
        public decimal TotalVentasAyer()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT ISNULL(SUM(Total), 0) FROM Pedidos WHERE CAST(FechaCreacion AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE) AND Estado != 'Cancelado'");
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return (decimal)datos.Lector[0];
                }
                return 0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

      
        public int CantidadPedidosPendientes()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM Pedidos WHERE Estado = 'Pendiente'");
                return datos.ejecutarAccionScalar(); 
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public int CantidadAlertasStock()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM Articulos WHERE StockActual <= StockMinimo AND Activo = 1");
                return datos.ejecutarAccionScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

     
        public int CantidadClientesActivos()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM Cliente WHERE Activo = 1");
                return datos.ejecutarAccionScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }


        // Reportes

        public DataTable ObtenerReporteVentas()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                string consulta = @"
                    SELECT 
                        P.IDPedido AS [Nro Factura],
                        P.FechaCreacion AS [Fecha Alta],
                        ISNULL(CONVERT(VARCHAR, P.FechaEntrega, 103), '0') AS [Fecha Entrega],
                        C.Apellido + ', ' + C.Nombre AS [Cliente],
                        P.Estado,
                        P.MetodoPago,
                        P.Descuento, 
                        P.Total
                    FROM Pedidos P
                    INNER JOIN Cliente C ON P.IDCliente = C.IDCliente
                    ORDER BY P.FechaCreacion DESC";

                datos.setearConsulta(consulta);
                datos.ejecutarLectura();

              
                DataTable tabla = new DataTable();
                tabla.Load(datos.Lector);
                return tabla;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

       
        public DataTable ObtenerReporteCompras()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                string consulta = @"
                    SELECT 
                        A.CodigoArticulo,
                        A.Descripcion,
                        M.Descripcion AS Marca,
                        Cat.Descripcion AS Categoria,
                        Pr.RazonSocial AS Proveedor,
                        A.PrecioCostoActual AS [Costo Unitario],
                        A.PorcentajeGanancia AS [% Ganancia], 
                        A.StockActual,
                        A.StockMinimo,
                        (A.PrecioCostoActual * A.StockActual) AS [Valor Total Inventario]
                    FROM Articulos A
                    INNER JOIN Marcas M ON A.IdMarca = M.IdMarca
                    INNER JOIN Categorias Cat ON A.IdCategoria = Cat.IdCategoria
                    LEFT JOIN Proveedores Pr ON A.IdProveedor = Pr.IDProveedor
                    WHERE A.Activo = 1";

                datos.setearConsulta(consulta);
                datos.ejecutarLectura();

                DataTable tabla = new DataTable();
                tabla.Load(datos.Lector);
                return tabla;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
