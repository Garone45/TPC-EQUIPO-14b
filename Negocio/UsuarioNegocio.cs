using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio.Usuario_Persona;

namespace Negocio
{
    public class UsuarioNegocio
    {
        AccesoDatos datos = new AccesoDatos();

        public bool Loguear(Usuario usuario)
        {
            try
            {
               
                datos.setearConsulta("SELECT IDUsuario, NombreUser, TipoUser, Activo FROM Usuario WHERE NombreUser = @user AND Contraseña = @pass AND Activo = 1");

                datos.Comando.Parameters.Clear();

                datos.Comando.Parameters.AddWithValue("@user", usuario.NombreUsuario);
                datos.Comando.Parameters.AddWithValue("@pass", usuario.Contraseña);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    
                    usuario.IDUsuario = (int)datos.Lector["IDUsuario"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUser"];

                    usuario.TipoUsuario = (TipoUsuario)(int)datos.Lector["TipoUser"];

                    usuario.Activo = (bool)datos.Lector["Activo"];

                    return true;
                }
                return false;
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
        public bool BuscarPorEmail(string email)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Contamos cuántos usuarios tienen ese mail
                datos.setearConsulta("SELECT COUNT(*) FROM Usuario WHERE Email = @email AND Activo = 1");
                datos.setearParametro("@email", email);

                int cantidad = datos.ejecutarAccionScalar();

                return cantidad > 0; // Si es mayor a 0, devuelve TRUE (Existe)
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