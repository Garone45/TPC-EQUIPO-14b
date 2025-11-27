using System;
using System.Collections.Generic;
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

    }
}
