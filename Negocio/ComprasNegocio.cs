using Dominio.Compras;
using Dominio.Ventas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Dominio.Ventas.Pedido;

namespace Negocio
{
    public class ComprasNegocio
    {
        public List<Compra> ListarCompras()
        {
            List<Compra> lista = new List<Compra>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
                SELECT 
                C.IDCompra,
                P.RazonSocial AS NombreProveedor,
                C.FechaCompra,
                C.Estado,
                C.MontoTotal AS MontoTotal,
                C.Documento,
                C.Observaciones
                FROM Compras C
                INNER JOIN Proveedores P ON C.IDProveedor = P.IDProveedor
                ORDER BY C.IDCompra DESC;
                ";


                datos.setearConsulta(consulta);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Compra compra = new Compra();
                    
                    // Mapeo de datos
                    compra.IDCompra = (int)datos.Lector["IDCompra"];
                    compra.RazonSocialProveedor = datos.Lector["NombreProveedor"].ToString();
                   
                   /* if (!(datos.Lector["IDUsuario"] is DBNull))
                        compra.IDUsuario = (int)datos.Lector["IDUsuario"];
                    else compra.IDUsuario = 0;*/
                    

                    if (!(datos.Lector["FechaCompra"] is DBNull))
                        compra.FechaCompra = (DateTime)datos.Lector["FechaCompra"];
                
                    if (!(datos.Lector["MontoTotal"] is DBNull))
                        compra.MontoTotal = (decimal)datos.Lector["MontoTotal"];
                    else compra.MontoTotal = 0;

                    compra.Documento = datos.Lector["Documento"].ToString();
                    compra.Observaciones = datos.Lector["Observaciones"].ToString();
                    string estadoStr = datos.Lector["Estado"].ToString();
                    compra.EstadoCompra = (Compra.Estado)Enum.Parse(typeof(Compra.Estado), estadoStr);

                    lista.Add(compra);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar compras.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public List<Compra> Filtrar(string filtro)
        {
            List<Compra> lista = new List<Compra>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
                SELECT 
                C.IDCompra AS IDCompras,
                P.RazonSocial AS NombreProveedor,
                C.FechaCompra,
                C.Estado,
                C.MontoTotal,
                C.Documento,
                C.Observaciones
                FROM Compras C
                INNER JOIN Proveedores P ON C.IDProveedor = P.IDProveedor
                WHERE
                    (@filtro = '' 
                        OR C.IDCompra LIKE '%' + @filtro + '%' 
                        OR P.RazonSocial LIKE '%' + @filtro + '%'
                        OR C.Estado LIKE '%' + @filtro + '%')
                ORDER BY C.IDCompra DESC;";

                datos.setearConsulta(consulta);
                datos.setearParametro("@Filtro", filtro);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Compra aux = new Compra();
                    aux.IDCompra = (int)datos.Lector["IDCompra"];
                    aux.RazonSocialProveedor = datos.Lector["NombreProveedor"].ToString();
                    aux.FechaCompra = (DateTime)datos.Lector["FechaCompra"];
                    aux.Documento = datos.Lector["Documento"].ToString();
                    aux.MontoTotal = (int)datos.Lector["MontoTotal"];
                    aux.Observaciones = datos.Lector["Observaciones"].ToString();
                    string estadoStr = datos.Lector["Estado"].ToString();
                    aux.EstadoCompra = (Compra.Estado)Enum.Parse(typeof(Compra.Estado), estadoStr);

                    lista.Add(aux);
                }

                return lista;
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
