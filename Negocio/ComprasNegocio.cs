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
                ORDER BY C.IDCompra ASC;
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
        public Compra ObtenerPorID(int idCompra)
        {
            AccesoDatos datos = new AccesoDatos();
            Compra compra = null;

            try
            {
          
                datos.setearConsulta("SELECT IDCompra, IDProveedor, Documento, FechaCompra, MontoTotal, Observaciones, Estado, UsuarioCreador FROM Compras WHERE IDCompra = @id");
                datos.setearParametro("@id", idCompra);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    compra = new Compra();

                    compra.IDCompra = (int)datos.Lector["IDCompra"];
                    compra.IDProveedor = (int)datos.Lector["IDProveedor"];
                    compra.Documento = datos.Lector["Documento"].ToString();
                    compra.FechaCompra = (DateTime)datos.Lector["FechaCompra"];
                    
                    if (!(datos.Lector["MontoTotal"] is DBNull))
                        compra.MontoTotal = Convert.ToDecimal(datos.Lector["MontoTotal"]);


                    if (!(datos.Lector["Observaciones"] is DBNull))
                        compra.Observaciones = datos.Lector["Observaciones"].ToString();

                    if (!(datos.Lector["UsuarioCreador"] is DBNull))
                        compra.UsuarioCreador = datos.Lector["UsuarioCreador"].ToString();


                    if (!(datos.Lector["Estado"] is DBNull))
                    {
                        string estadoTexto = datos.Lector["Estado"].ToString();
                        compra.EstadoCompra = (Compra.Estado)Enum.Parse(typeof(Compra.Estado), estadoTexto, true);
                    }
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

            if (compra == null) return null;

            try
            {
             
                string consultaDetalle = @"
                    SELECT C.IDDetalle, C.IDArticulo, C.Cantidad, C.PrecioUnitario, A.Descripcion as NombreProducto
                    FROM CompraDetalle C
                    INNER JOIN Articulos A ON C.IDArticulo = A.IDArticulo
                    WHERE C.IDCompra = @idCompra";

                datos = new AccesoDatos();
                datos.setearConsulta(consultaDetalle);
                datos.setearParametro("@idCompra", idCompra);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    DetalleCompra detalle = new DetalleCompra();

                    detalle.IDDetalle = Convert.ToInt32(datos.Lector["IDDetalle"]);
                    detalle.IDArticulo = Convert.ToInt32(datos.Lector["IDArticulo"]);
                    detalle.Cantidad = Convert.ToInt32(datos.Lector["Cantidad"]);
                    detalle.PrecioUnitario = Convert.ToDecimal(datos.Lector["PrecioUnitario"]);


                    if (!(datos.Lector["NombreProducto"] is DBNull))
                        detalle.NombreProducto = datos.Lector["NombreProducto"].ToString();

         
                    compra.Detalles.Add(detalle);
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

            return compra;
        }

        public void Agregar(Compra compra)
        {
            AccesoDatos datos = new AccesoDatos();

            // Usaremos una transacción porque son múltiples inserts
            System.Data.SqlClient.SqlTransaction transaccion = null;

            try
            {
                datos.Conexion.Open();
                transaccion = datos.Conexion.BeginTransaction();
                datos.Comando.Transaction = transaccion;

              
                string consultaCabecera = @"
                INSERT INTO Compras 
                (IDProveedor, Documento, FechaCompra, MontoTotal, Observaciones, Estado, UsuarioCreador, FechaRegistro) 
                VALUES 
                (@IDProveedor, @Documento, @FechaCompra, @MontoTotal, @Observaciones, 'Pendiente', @Usuario, GETDATE());
                SELECT SCOPE_IDENTITY();"; 

                datos.setearConsulta(consultaCabecera);

                datos.setearParametro("@IDProveedor", compra.IDProveedor);
                datos.setearParametro("@Documento", compra.Documento);
                datos.setearParametro("@FechaCompra", compra.FechaCompra);
                datos.setearParametro("@MontoTotal", compra.MontoTotal);

                // Manejo de nulos para observaciones
                if (string.IsNullOrEmpty(compra.Observaciones))
                    datos.setearParametro("@Observaciones", DBNull.Value);
                else
                    datos.setearParametro("@Observaciones", compra.Observaciones);

                datos.setearParametro("@Usuario", compra.UsuarioCreador ?? "Sistema"); 

      
                int idCompraGenerada = Convert.ToInt32(datos.Comando.ExecuteScalar());

               
                string consultaDetalle = @"
                INSERT INTO CompraDetalle (IDCompra, IDArticulo, Cantidad, PrecioUnitario) 
                VALUES (@IDCompra, @IDArticulo, @Cantidad, @PrecioUnitario)";

                foreach (var item in compra.Detalles)
                {
                    datos.Comando.Parameters.Clear();
                    datos.Comando.CommandText = consultaDetalle;

                    datos.setearParametro("@IDCompra", idCompraGenerada);
                    datos.setearParametro("@IDArticulo", item.IDArticulo);
                    datos.setearParametro("@Cantidad", item.Cantidad);
                    datos.setearParametro("@PrecioUnitario", item.PrecioUnitario);

                    datos.Comando.ExecuteNonQuery();
                }

           
                transaccion.Commit();
            }
            catch (Exception ex)
            {
                if (transaccion != null)
                    transaccion.Rollback();

                throw new Exception("Error al registrar la compra: " + ex.Message, ex);
            }
            finally
            {
                if (datos.Conexion.State == System.Data.ConnectionState.Open)
                    datos.Conexion.Close();
            }
        }

        public void Modificar(Compra compra)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // 1. ACTUALIZAR CABECERA (Tabla Compras)
                // Nota: No actualizamos UsuarioCreador ni FechaRegistro porque esos son datos de origen.
                datos.setearConsulta("UPDATE Compras SET IDProveedor = @idProv, Documento = @doc, FechaCompra = @fecha, MontoTotal = @monto, Observaciones = @obs, Estado = @estado WHERE IDCompra = @id");

                datos.setearParametro("@idProv", compra.IDProveedor);
                datos.setearParametro("@doc", compra.Documento);
                datos.setearParametro("@fecha", compra.FechaCompra);
                datos.setearParametro("@monto", compra.MontoTotal);
                datos.setearParametro("@obs", (object)compra.Observaciones ?? DBNull.Value);
                datos.setearParametro("@estado", compra.EstadoCompra.ToString());
                datos.setearParametro("@id", compra.IDCompra);

                datos.ejecutarAccion();
                datos.cerrarConexion();

                // 2. BORRAR DETALLES VIEJOS
                // Eliminamos todo lo que había para esa compra
                datos = new AccesoDatos();
                datos.setearConsulta("DELETE FROM CompraDetalle WHERE IDCompra = @id");
                datos.setearParametro("@id", compra.IDCompra);
                datos.ejecutarAccion();
                datos.cerrarConexion();

                // 3. INSERTAR DETALLES NUEVOS (Los que quedaron en la Session)
                // Esto es igual que en el método Agregar, pero usando el IDCompra que ya existe
                foreach (var item in compra.Detalles)
                {
                    datos = new AccesoDatos();
                    datos.setearConsulta("INSERT INTO CompraDetalle (IDCompra, IDArticulo, Cantidad, PrecioUnitario) VALUES (@idCompra, @idArt, @cant, @precio)");

                    datos.setearParametro("@idCompra", compra.IDCompra);
                    datos.setearParametro("@idArt", item.IDArticulo);
                    datos.setearParametro("@cant", item.Cantidad);
                    datos.setearParametro("@precio", item.PrecioUnitario);

                    datos.ejecutarAccion();
                    datos.cerrarConexion();
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

        public void eliminarLogico(int id)
        {
            try
            {
                AccesoDatos datos = new AccesoDatos();

                // ADAPTAR SEGÚN TU BASE DE DATOS:
                // Opción A: Si usas un estado de texto (ej: 'Anulada', 'Inactiva')
                datos.setearConsulta("UPDATE COMPRAS SET Estado = 'Cancelado' WHERE IDCompra = @id");

                // Opción B: Si usas un bit/booleano (ej: Activo = 0)
                // datos.setearConsulta("UPDATE COMPRAS SET Activo = 0 WHERE ID = @id");

                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void ConfirmarEntrega(int id)
        {
            try
            {
                AccesoDatos datos = new AccesoDatos();
                // Asegúrate que 'Entregado' coincide con tu Enum y BD
                datos.setearConsulta("UPDATE Compras SET Estado = 'Entregado' WHERE IDCompra = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();

                // OPCIONAL PERO RECOMENDADO:
                // Aquí deberías llamar a la lógica para sumar el stock de los artículos comprados.
                // actualizarStock(id); 
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }
}
