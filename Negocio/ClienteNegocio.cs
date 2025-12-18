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

  
                while (datos.Lector.Read())
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

        public void agregar(Cliente nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
    
                
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

                if (datos.Lector.Read()) 
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

                return null; 
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

      
        public void modificar(Cliente cliente)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
      
                string consulta = @"
                    UPDATE Cliente SET
                        Nombre = @Nombre,
                        Apellido = @Apellido,
                        Dni = @Dni,
                        Telefono = @Telefono,
                        Email = @Email,
                        Direccion = @Direccion,
                        Altura = @Altura,
                        Localidad = @Localidad
                    WHERE IDCliente = @IDCliente";

                datos.setearConsulta(consulta);

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

        public List<Cliente> filtrar(string filtro)
        {
            List<Cliente> lista = new List<Cliente>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
                    SELECT IDCliente, Nombre, Apellido, Dni, Telefono, Email, Direccion,Altura,Localidad, Activo 
                    FROM Cliente 
                    WHERE Activo = 1 AND (
                        Nombre LIKE @filtro OR 
                        Apellido LIKE @filtro OR
                        Dni LIKE @filtro OR 
                        Telefono LIKE @filtro
                    )";

                datos.setearConsulta(consulta);
               
                datos.setearParametro("@filtro", "%" + filtro + "%");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Cliente aux = new Cliente();
                    aux.IDCliente = (int)datos.Lector["IDCliente"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Apellido = (string)datos.Lector["Apellido"];
                    aux.Dni = (string)datos.Lector["Dni"];
                    aux.Telefono = datos.Lector["Telefono"] != DBNull.Value ? (string)datos.Lector["Telefono"] : "";
                    aux.Email = datos.Lector["Email"] != DBNull.Value ? (string)datos.Lector["Email"] : "";
                    aux.Direccion = datos.Lector["Direccion"] != DBNull.Value ? (string)datos.Lector["Direccion"] : "";
                    aux.Altura = datos.Lector["Altura"] != DBNull.Value ? (string)datos.Lector["Altura"] : "";
                    aux.Localidad = datos.Lector["Localidad"] != DBNull.Value ? (string)datos.Lector["Localidad"] : "";
                    aux.Activo = (bool)datos.Lector["Activo"];
                    

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

        public Cliente obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ObtenerClientePorID");
                datos.setearParametro("@IdCliente", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Cliente aux = new Cliente();
                    aux.IDCliente = (int)datos.Lector["IDCliente"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Apellido = (string)datos.Lector["Apellido"];
                    aux.Dni = (string)datos.Lector["Dni"];

                 
                    if (!(datos.Lector["Telefono"] is DBNull))
                        aux.Telefono = (string)datos.Lector["Telefono"];

                    if (!(datos.Lector["Email"] is DBNull))
                        aux.Email = (string)datos.Lector["Email"];

                    if (!(datos.Lector["Direccion"] is DBNull))
                        aux.Direccion = (string)datos.Lector["Direccion"];

                    if (!(datos.Lector["Altura"] is DBNull))
                        aux.Altura = (string)datos.Lector["Altura"];

                    if (!(datos.Lector["Localidad"] is DBNull))
                        aux.Localidad = (string)datos.Lector["Localidad"];

                    aux.Activo = (bool)datos.Lector["Activo"];

                    return aux;
                }
                return null;
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
