using Dominio.Ventas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class VentasNegocio
    {
        // Método para obtener la lista de todos los pedidos (sin filtros por ahora)
        public List<Pedido> ListarTodos()
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos(); // Usamos tu clase de acceso a datos

            try
            {
                // Consulta SQL que obtiene todos los campos necesarios para el listado
                string consulta = @"
                SELECT 
                    P.IDPedido,
                    C.Nombre + ' ' + C.Apellido AS Cliente,
                    P.IDCliente, 
                    P.IDVendedor,
                    P.FechaCreacion,
                    P.FechaEntrega,
                    P.MetodoPago,
                    P.Estado,
                    P.Total
                FROM dbo.Pedidos P
                INNER JOIN dbo.Cliente C ON P.IDCliente = C.IDCliente
                ORDER BY P.FechaCreacion DESC";

                datos.setearConsulta(consulta);
                datos.ejecutarLectura(); // Abre la conexión y ejecuta la consulta

                while (datos.Lector.Read())
                {
                    Pedido pedido = new Pedido();

                    // Mapeo de datos del lector al objeto Pedido
                    pedido.IDPedido = (int)datos.Lector["IDPedido"];
                    pedido.IDCliente = (int)datos.Lector["IDCliente"];
                    pedido.IDVendedor = (int)datos.Lector["IDVendedor"];

                    pedido.NombreCliente = datos.Lector["Cliente"].ToString();

                    // Conversión segura de tipos
                    pedido.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    pedido.FechaEntrega = (DateTime)datos.Lector["FechaEntrega"];
                    pedido.Total = (decimal)datos.Lector["Total"];
                    pedido.MetodoPago = datos.Lector["MetodoPago"].ToString();

                    // Convertir la columna 'Estado' de la DB (string) a tu Enum de Dominio
                    string estadoStr = datos.Lector["Estado"].ToString();
                    pedido.Estado = (Pedido.EstadoPedido)Enum.Parse(typeof(Pedido.EstadoPedido), estadoStr);

                    pedido.Detalles = new List<DetallePedido>(); // Inicializar lista de detalles (vacía para el listado)

                    lista.Add(pedido);
                }

                return lista;
            }
            catch (Exception ex)
            {
                // Propagar la excepción o manejarla (log)
                throw new Exception("Error en la capa de datos al listar pedidos.", ex);
            }
            finally
            {
                // Usamos tu método para cerrar la conexión y el lector
                datos.cerrarConexion();
            }
        }
    }
}
