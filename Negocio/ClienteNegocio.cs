using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ClienteNegocio
    {
        public List<Cliente> listar()
        {
            List<Cliente> lista = new List<Cliente>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // NOTA: Asumo que tu tabla se llama 'Clientes' y tu PK es 'IDCliente'.
                // ¡Ajusta esta consulta a tu base de datos real!
                string consulta = @"
                    SELECT 
                        IDCliente, 
                        Nombre, 
                        Apellido, 
                        Dni, 
                        Telefono, 
                        Email, 
                        Direccion,
                        Altura,
                        Localidad,
                        Activo 
                    FROM Cliente
                    WHERE Activo = 1";

                datos.setearConsulta(consulta);
                datos.ejecutarLectura();

                // Leemos los resultados
                while (datos.Lector.Read())
                {
                    Cliente aux = new Cliente();

                    // Mapeamos el ID de la BD a la propiedad 'ID' de la clase Entidad
                    aux.IDCliente = (int)datos.Lector["IDCliente"];
                    aux.Nombre = datos.Lector["Nombre"].ToString();
                    aux.Apellido = datos.Lector["Apellido"].ToString();
                    aux.Dni = datos.Lector["Dni"].ToString();
                    aux.Telefono = datos.Lector["Telefono"].ToString();
                    aux.Email = datos.Lector["Email"].ToString();
                    aux.Direccion = datos.Lector["Direccion"].ToString();
                    aux.Altura = datos.Lector["Altura"].ToString();
                    aux.Localidad = datos.Lector["Localidad"].ToString();
                    aux.Activo = (bool)datos.Lector["Activo"];

                    // Agregamos el cliente a la lista
                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                // Relanzamos la excepción para que la capa de presentación la maneje
                throw ex;
            }
            finally
            {
                // Cerramos la conexión y el lector
                datos.cerrarConexion();
            }
        }

        public void agregar(Cliente nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Consulta SQL para el INSERT
                
                string consulta = @"
                    INSERT INTO Cliente (
                        Nombre, 
                        Apellido, 
                        Dni, 
                        Telefono, 
                        Email, 
                        Direccion,
                        Altura,
                        Localidad,
                        Activo
                    ) 
                    VALUES (
                        @Nombre, 
                        @Apellido, 
                        @Dni, 
                        @Telefono, 
                        @Email, 
                        @Direccion,
                        @Altura,
                        @Localidad,
                        1
                    )";

                datos.setearConsulta(consulta);

                // Mapeo de parámetros
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Apellido", nuevo.Apellido);
                datos.setearParametro("@Dni", nuevo.Dni);
                datos.setearParametro("@Telefono", nuevo.Telefono);
                datos.setearParametro("@Email", nuevo.Email);
                datos.setearParametro("@Direccion", nuevo.Direccion);
                datos.setearParametro("@Altura", nuevo.Altura);
                datos.setearParametro("@Localidad", nuevo.Localidad);

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

        public Cliente listar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
                    SELECT 
                        IDCliente, Nombre, Apellido, Dni, 
                        Telefono, Email, Direccion,Altura,Localidad, Activo 
                    FROM Cliente
                    WHERE IDCliente = @IDCliente";

                datos.setearConsulta(consulta);
                datos.setearParametro("@IDCliente", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read()) // Si encontró el cliente
                {
                    Cliente aux = new Cliente();
                    aux.IDCliente = (int)datos.Lector["IDCliente"];
                    aux.Nombre = datos.Lector["Nombre"].ToString();
                    aux.Apellido = datos.Lector["Apellido"].ToString();
                    aux.Dni = datos.Lector["Dni"].ToString();
                    aux.Telefono = datos.Lector["Telefono"].ToString();
                    aux.Email = datos.Lector["Email"].ToString();
                    aux.Direccion = datos.Lector["Direccion"].ToString();
                    aux.Altura = datos.Lector["Altura"].ToString();
                    aux.Localidad = datos.Lector["Localidad"].ToString();
                    aux.Activo = (bool)datos.Lector["Activo"];
                    return aux;
                }

                return null; // Si no lo encontró
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

        // ---- NUEVO MÉTODO ----
        public void modificar(Cliente cliente)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // La consulta UPDATE
                string consulta = @"
                    UPDATE Cliente SET
                        Nombre = @Nombre,
                        Apellido = @Apellido,
                        Dni = @Dni,
                        Telefono = @Telefono,
                        Email = @Email,
                        Direccion = @Direccion
                        Altura = @Altura,
                        Localidad = @Localidad
                    WHERE IDCliente = @IDCliente";

                datos.setearConsulta(consulta);

                // Seteamos todos los parámetros
                datos.setearParametro("@Nombre", cliente.Nombre);
                datos.setearParametro("@Apellido", cliente.Apellido);
                datos.setearParametro("@Dni", cliente.Dni);
                datos.setearParametro("@Telefono", cliente.Telefono);
                datos.setearParametro("@Email", cliente.Email);
                datos.setearParametro("@Direccion", cliente.Direccion);
                datos.setearParametro("@Altura", cliente.Altura);
                datos.setearParametro("@Localidad", cliente.Localidad);
                datos.setearParametro("@IDCliente", cliente.IDCliente); 

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

        // ---- NUEVO MÉTODO ----
        public void eliminarLogico(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                
                string consulta = "UPDATE Cliente SET Activo = 0 WHERE IDCliente = @IDCliente";

                datos.setearConsulta(consulta);
                datos.setearParametro("@IDCliente", id);
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

    }

}
