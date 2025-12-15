using Dominio.Usuario_Persona;
using Dominio.Ventas;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
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
                ORDER BY P.IDPedido DESC;
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
                    if (!(datos.Lector["FechaCreacion"] is DBNull))
                        aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    if (!(datos.Lector["FechaEntrega"] is DBNull))
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
                datos.setearParametro("@FechaCreacion", DateTime.Now);
                if (nuevoPedido.FechaEntrega == DateTime.MinValue)
                {
                    datos.setearParametro("@FechaEntrega", DBNull.Value);
                }
                else
                {
                    datos.setearParametro("@FechaEntrega", nuevoPedido.FechaEntrega);
                }
                datos.setearParametro("@MetodoPago", nuevoPedido.MetodoPago);
                datos.setearParametro("@Estado", nuevoPedido.Estado.ToString());

                datos.setearParametro("@Descuento", nuevoPedido.Descuento);

                datos.setearParametro("@Total", nuevoPedido.Total);


                int idPedidoGenerado = datos.ejecutarAccionScalar();

                datos.cerrarConexion();


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

        public Pedido ObtenerPorId(int idPedido)
        {
            AccesoDatos datos = new AccesoDatos();
            Pedido pedido = new Pedido();

            // Inicializamos la lista para evitar NullReferenceException
            if (pedido.Detalles == null)
                pedido.Detalles = new List<DetallePedido>();

            try
            {


                // --- 1. TRAER CABECERA DEL PEDIDO ---
                datos.setearConsulta("SELECT * FROM Pedidos WHERE IDPedido = @id");
                datos.setearParametro("@id", idPedido);

                // Al ejecutar esto, tu clase AccesoDatos abrirá la conexión internamente
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    pedido.IDPedido = (int)datos.Lector["IDPedido"];
                    // ... (resto de tus mapeos) ...
                    pedido.IDCliente = (int)datos.Lector["IDCliente"];

                    pedido.IDVendedor = (int)datos.Lector["IDVendedor"];

                    if (!(datos.Lector["FechaCreacion"] is DBNull))
                        pedido.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];

                    if (!(datos.Lector["FechaEntrega"] is DBNull))
                        pedido.FechaEntrega = (DateTime)datos.Lector["FechaEntrega"];

                    pedido.Total = (decimal)datos.Lector["Total"];
                }


                if (datos.Lector != null)
                    datos.Lector.Close();
                if (datos.Conexion.State == System.Data.ConnectionState.Open)
                    datos.Conexion.Close();


                datos.Comando.Parameters.Clear();


                string consultaDetalles = @"
            SELECT D.IDArticulo, D.Cantidad, D.PrecioUnitario, 
                   A.Descripcion 
            FROM DetallesPedido D 
            LEFT JOIN Articulos A ON D.IDArticulo = A.IDArticulo 
            WHERE D.IDPedido = @idPedidoDetalle";

                datos.setearConsulta(consultaDetalles);
                datos.setearParametro("@idPedidoDetalle", idPedido);

                // Aquí 'ejecutarLectura' vuelve a abrir la conexión limpiamente
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    DetallePedido detalle = new DetallePedido();
                    detalle.IDPedido = idPedido;

                    if (!(datos.Lector["IDArticulo"] is DBNull))
                        detalle.IDArticulo = (int)datos.Lector["IDArticulo"];

                    if (!(datos.Lector["Descripcion"] is DBNull))
                        detalle.Descripcion = (string)datos.Lector["Descripcion"];

                    if (!(datos.Lector["Cantidad"] is DBNull))
                        detalle.Cantidad = (int)datos.Lector["Cantidad"];

                    if (!(datos.Lector["PrecioUnitario"] is DBNull))
                        detalle.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];

                    pedido.Detalles.Add(detalle);
                }

                // Cerramos el segundo lector
                if (datos.Lector != null)
                    datos.Lector.Close();

                return pedido;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {

                if (datos.Conexion != null && datos.Conexion.State == System.Data.ConnectionState.Open)
                    datos.Conexion.Close();
            }
        }
        public void Modificar(Pedido pedido)
        {
            AccesoDatos datos = new AccesoDatos();
            SqlTransaction transaccion = null;

            try
            {

                datos.Conexion.Open();
                transaccion = datos.Conexion.BeginTransaction();
                datos.Comando.Transaction = transaccion;

                 
                string consultaCabecera = @"
                    UPDATE Pedidos SET 
                        IDCliente = @IDCliente,
                        IDVendedor = @IDVendedor,
                        FechaEntrega = @FechaEntrega,
                        MetodoPago = @MetodoPago,
                        Estado = @Estado,
                        Descuento = @Descuento,
                        Total = @Total
                    WHERE IDPedido = @IDPedido";

                datos.setearConsulta(consultaCabecera);

                // Parámetros de la Cabecera
                datos.setearParametro("@IDPedido", pedido.IDPedido);
                datos.setearParametro("@IDCliente", pedido.IDCliente);
                datos.setearParametro("@IDVendedor", pedido.IDVendedor);
                if (pedido.FechaEntrega == DateTime.MinValue)
                {
                    datos.setearParametro("@FechaEntrega", DBNull.Value);
                }
                else
                {
                    datos.setearParametro("@FechaEntrega", pedido.FechaEntrega);
                }
                datos.setearParametro("@MetodoPago", pedido.MetodoPago);
                datos.setearParametro("@Estado", pedido.Estado.ToString());
                datos.setearParametro("@Descuento", pedido.Descuento);
                datos.setearParametro("@Total", pedido.Total);


                datos.Comando.ExecuteNonQuery(); // Ejecuta el UPDATE usando el comando ya vinculado

                // --- 3. REEMPLAZAR DETALLES ---

                // 3.1 ELIMINAR detalles antiguos asociados a este IDPedido
                string consultaDeleteDetalle = "DELETE FROM DetallesPedido WHERE IDPedido = @IDPedidoDetalle";
                datos.setearConsulta(consultaDeleteDetalle);


                datos.Comando.Connection = datos.Conexion;
                datos.Comando.Transaction = transaccion;

                datos.setearParametro("@IDPedidoDetalle", pedido.IDPedido);
                datos.Comando.ExecuteNonQuery();

                // 3.2 INSERTAR los nuevos detalles
                string consultaInsertDetalle = @"
                    INSERT INTO DetallesPedido (IDPedido, IDArticulo, PrecioUnitario, Cantidad) 
                    VALUES (@IDPedidoD, @IDArticulo, @PrecioUnitario, @Cantidad)";

                foreach (DetallePedido detalle in pedido.Detalles)
                {
                    // Preparamos el comando para la inserción
                    datos.Comando.Parameters.Clear();
                    datos.Comando.CommandText = consultaInsertDetalle;

                    datos.setearParametro("@IDPedidoD", pedido.IDPedido);
                    datos.setearParametro("@IDArticulo", detalle.IDArticulo);
                    datos.setearParametro("@PrecioUnitario", detalle.PrecioUnitario);
                    datos.setearParametro("@Cantidad", detalle.Cantidad);

                    // Ejecutamos el INSERT por cada detalle
                    datos.Comando.ExecuteNonQuery();
                }

                // 4. CONFIRMAR
                transaccion.Commit();
            }
            catch (Exception ex)
            {
                // 5. CANCELAR
                if (transaccion != null)
                {
                    transaccion.Rollback();
                }
                throw new Exception("Error al modificar el pedido. Se ha deshecho la operación.", ex);
            }
            finally
            {
                // 6. CERRAR CONEXIÓN

                if (datos.Conexion.State == System.Data.ConnectionState.Open)
                    datos.Conexion.Close();
            }
        }
        public void Eliminar(int idPedido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta("UPDATE Pedidos SET Estado = 'Cancelado' WHERE IDPedido = @id");
                datos.setearParametro("@id", idPedido);
                datos.ejecutarAccion();
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

        public bool ActualizarEstado(int idPedido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "UPDATE Pedidos SET Estado = @EstadoNew WHERE IDPedido = @IDPedido AND Estado = @EstadoOld";

                datos.setearConsulta(consulta);
                datos.setearParametro("@EstadoNew", "Entregado");
                datos.setearParametro("@IDPedido", idPedido);
                datos.setearParametro("@EstadoOld", "Pendiente"); // <--- VALIDACIÓN


                datos.ejecutarAccion();

                // Si filasAfectadas es 1, se actualizó. Si es 0, significa que el estado no era PENDIENTE.
                return true;
            }
            catch (Exception ex)
            {
                // Manejo de excepción
                Console.WriteLine("Error al marcar pedido como ENTREGADO: " + ex.ToString());
                return false;
            }
            finally
            {
                datos.cerrarConexion();
            }

        }



        public bool ConfirmarEntrega(int idPedido)
        {
            AccesoDatos datos = new AccesoDatos();
            SqlTransaction transaccion = null;

            try
            {
                datos.Conexion.Open();
                transaccion = datos.Conexion.BeginTransaction();
                datos.Comando.Transaction = transaccion;

   
                string consultaDetalles = "SELECT IDArticulo, Cantidad FROM DetallesPedido WHERE IDPedido = @IDPedido";
                datos.setearConsulta(consultaDetalles);
                datos.setearParametro("@IDPedido", idPedido);

                List<DetallePedido> itemsDelPedido = new List<DetallePedido>();

                using (SqlDataReader lector = datos.Comando.ExecuteReader())
                {
                    while (lector.Read())
                    {
                        DetallePedido item = new DetallePedido();
                        item.IDArticulo = (int)lector["IDArticulo"];
                        item.Cantidad = (int)lector["Cantidad"];
                        itemsDelPedido.Add(item);
                    }
                }

         
                // aca revisamos uno por uno. Si a alguno le falta stock, 
                // CANCELAMOS TODO inmediatamente.
                foreach (var item in itemsDelPedido)
                {
                    datos.Comando.Parameters.Clear();
                    // Consultamos cuánto hay REALMENTE en la base ahora mismo
                    datos.Comando.CommandText = "SELECT StockActual FROM Articulos WHERE IdArticulo = @IDArt";
                    datos.setearParametro("@IDArt", item.IDArticulo);

                    object resultado = datos.Comando.ExecuteScalar();
                    int stockEnBase = (resultado != DBNull.Value) ? Convert.ToInt32(resultado) : 0;

                    if (stockEnBase < item.Cantidad)
                    {
                       
                        // Al lanzar esta excepción, el código salta directo al 'catch'.
                        // NUNCA llega al paso de cambiar el estado a 'Entregado'.
                        throw new Exception("No hay stock suficiente para el artículo ID: " + item.IDArticulo + ". Tienes " + stockEnBase + " y necesitas " + item.Cantidad);
                    }
                }

                // -------------------------------------------------------
                // PASO 3: SI PASÓ EL GUARDIA, DESCONTAMOS EL STOCK
                // -------------------------------------------------------
                string consultaDescuento = "UPDATE Articulos SET StockActual = StockActual - @Cant WHERE IdArticulo = @IDArt";

                foreach (var item in itemsDelPedido)
                {
                    datos.Comando.Parameters.Clear();
                    datos.Comando.CommandText = consultaDescuento;
                    datos.setearParametro("@Cant", item.Cantidad);
                    datos.setearParametro("@IDArt", item.IDArticulo);
                    datos.Comando.ExecuteNonQuery();
                }

            
                // Recién ahora, que sabemos que todo está bien, cambiamos el estado.
                string consultaEstado = "UPDATE Pedidos SET Estado = 'Entregado', FechaEntrega = GETDATE() WHERE IDPedido = @IDPedido";

                datos.Comando.Parameters.Clear();
                datos.Comando.CommandText = consultaEstado;
                datos.setearParametro("@IDPedido", idPedido);

                datos.Comando.ExecuteNonQuery();

             
                transaccion.Commit();
                return true;
            }
            catch (Exception ex)
            {
                // Si algo falló (incluyendo la validación de stock), deshacemos todo.
                if (transaccion != null) transaccion.Rollback();

                // Relanzamos el error para que la pantalla (el ASPX) se entere y muestre el cartel rojo.
                throw ex;
            }
            finally
            {
                if (datos.Conexion.State == System.Data.ConnectionState.Open)
                    datos.Conexion.Close();
            }
        }


    }
}





