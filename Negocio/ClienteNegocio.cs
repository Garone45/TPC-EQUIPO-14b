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
                        Activo 
                    FROM Cliente";

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
                // IMPORTANTE: Los nombres de las columnas deben coincidir con tu BD.
                string consulta = @"
                    INSERT INTO Cliente (
                        Nombre, 
                        Apellido, 
                        Dni, 
                        Telefono, 
                        Email, 
                        Direccion, 
                        Activo
                    ) 
                    VALUES (
                        @Nombre, 
                        @Apellido, 
                        @Dni, 
                        @Telefono, 
                        @Email, 
                        @Direccion, 
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
