using Dominio.Usuario_Persona;
using Dominio.Ventas;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static Dominio.Ventas.Pedido;

namespace Negocio
{
    public class VentasNegocio
    {
        // 
        public List<Pedido> ListarPedidos()
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
                SELECT 
                    P.IDPedido, P.IDCliente, P.IDVendedor, P.FechaCreacion, P.FechaEntrega,
                    P.MetodoPago, P.Estado, P.Total,
                    C.Nombre + ' ' + C.Apellido AS NombreCliente  
                FROM dbo.Pedidos P
                INNER JOIN dbo.Cliente C ON P.IDCliente = C.IDCliente
                ";


                datos.setearConsulta(consulta);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido pedido = new Pedido();
                    // Mapeo de datos
                    pedido.IDPedido = (int)datos.Lector["IDPedido"];
                    pedido.NombreCliente = datos.Lector["NombreCliente"].ToString();
                    pedido.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];

                    if (!(datos.Lector["FechaEntrega"] is DBNull))
                        pedido.FechaEntrega = (DateTime)datos.Lector["FechaEntrega"];

                    if (!(datos.Lector["Total"] is DBNull))
                        pedido.Total = (decimal)datos.Lector["Total"];
                    else
                        pedido.Total = 0;

                    pedido.MetodoPago = datos.Lector["MetodoPago"].ToString();
                    string estadoStr = datos.Lector["Estado"].ToString();
                    pedido.Estado = (Pedido.EstadoPedido)Enum.Parse(typeof(Pedido.EstadoPedido), estadoStr);

                    lista.Add(pedido);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar pedidos.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }




           public List<Pedido> Filtrar(string filtro)
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
            SELECT 
                P.IDPedido, 
                P.IDCliente, 
                P.IDVendedor, 
                P.FechaCreacion, 
                P.FechaEntrega,
                P.MetodoPago, 
                P.Estado, 
                P.Total,
                C.Nombre + ' ' + C.Apellido AS NombreCliente
            FROM dbo.Pedidos P
            INNER JOIN dbo.Cliente C ON P.IDCliente = C.IDCliente
            WHERE 
                (@Filtro IS NULL OR @Filtro = '' OR 
                 CAST(P.IDPedido AS VARCHAR) LIKE '%' + @Filtro + '%' OR 
                 (C.Nombre + ' ' + C.Apellido) LIKE '%' + @Filtro + '%' OR 
                 P.Estado LIKE '%' + @Filtro + '%')
            ORDER BY P.FechaCreacion DESC;";

                datos.setearConsulta(consulta);
                datos.setearParametro("@Filtro", filtro);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.IDPedido = (int)datos.Lector["IDPedido"];
                    aux.IDCliente = (int)datos.Lector["IDCliente"];
                    aux.IDVendedor = (int)datos.Lector["IDVendedor"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    aux.FechaEntrega = (DateTime)datos.Lector["FechaEntrega"];
                    aux.MetodoPago = datos.Lector["MetodoPago"].ToString();
                    string estadoStr = datos.Lector["Estado"].ToString().Trim();
                    EstadoPedido estadoParseado;
                    if (!Enum.TryParse(estadoStr, true, out estadoParseado))
                        estadoParseado = EstadoPedido.Pendiente;
                    aux.Estado = estadoParseado;
                    aux.Total = (decimal)datos.Lector["Total"];
                    aux.NombreCliente = datos.Lector["NombreCliente"].ToString();

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

        public void Agregar(Pedido nuevoPedido)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {

                string consulta = @"
                INSERT INTO Pedidos 
                (IDCliente, IDVendedor, FechaCreacion, FechaEntrega, MetodoPago, Estado, Descuento, Total) 
                OUTPUT INSERTED.IDPedido 
                VALUES 
                (@IDCliente, @IDVendedor, @FechaCreacion, @FechaEntrega, @MetodoPago, @Estado, @Descuento, @Total)";

                datos.setearConsulta(consulta);

                // Parámetros basados en tu clase Pedido
                datos.setearParametro("@IDCliente", nuevoPedido.IDCliente);
                datos.setearParametro("@IDVendedor", nuevoPedido.IDVendedor);
                datos.setearParametro("@FechaCreacion", nuevoPedido.FechaCreacion);
                datos.setearParametro("@FechaEntrega", nuevoPedido.FechaEntrega);
                datos.setearParametro("@MetodoPago", nuevoPedido.MetodoPago);
                datos.setearParametro("@Estado", nuevoPedido.Estado.ToString());

                // Nuevo campo: Descuento
                // Nota: Asumo que agregaste la propiedad 'Descuento' a tu clase Pedido.
                datos.setearParametro("@Descuento", nuevoPedido.Descuento);

                datos.setearParametro("@Total", nuevoPedido.Total); // Este es el total final

                // Ejecutamos y recuperamos el ID generado
                int idPedidoGenerado = datos.ejecutarAccionScalar();

                datos.cerrarConexion();

                // 2. INSERTAR DETALLES (ESTO QUEDA IGUAL)
                // ... (El código de inserción de detalles es el mismo, ya que usa el ID recién generado) ...
                foreach (var item in nuevoPedido.Detalles)
                {
                    AccesoDatos datosDetalle = new AccesoDatos();

                    string consultaDetalle = "INSERT INTO DetallesPedido (IDPedido, IDArticulo, Cantidad, PrecioUnitario) VALUES (@IDPedido, @IDArticulo, @Cantidad, @Precio)";

                    datosDetalle.setearConsulta(consultaDetalle);
                    datosDetalle.setearParametro("@IDPedido", idPedidoGenerado);
                    datosDetalle.setearParametro("@IDArticulo", item.IDArticulo);
                    datosDetalle.setearParametro("@Cantidad", item.Cantidad);
                    datosDetalle.setearParametro("@Precio", item.PrecioUnitario);
                    datosDetalle.setearParametro("@Descuento", 0);

                    datosDetalle.ejecutarAccion();
                    datosDetalle.cerrarConexion();
                }
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





