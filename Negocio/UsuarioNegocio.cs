using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio.Usuario_Persona;
using Negocio;

namespace Negocio
{
    public class UsuarioNegocio
    {
      AccesoDatos datos = new AccesoDatos();
        public bool Loguear(Usuario usuario)
        {
            try
            {
                datos.setearConsulta("SELECT IDUsuario, NombreUser, Contrasena, Activo, CASE WHEN TipoUsuario = 1 THEN 'Admin' ELSE 'Vendedor' END AS TipoUsuario FROM Usuarios WHERE NombreUser = @user AND Contrasena = @pass");
                datos.Comando.Parameters.Clear();
                datos.Comando.Parameters.AddWithValue("@user", usuario.NombreUser);
                datos.Comando.Parameters.AddWithValue("@pass", usuario.Contrasena);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    usuario.IDUsuario = (int)datos.Lector["IDUsuario"];
                    usuario.TipoUsuario =(int)(datos.Lector["Rol"]) == 2 ? TipoUsuario.Admin : TipoUsuario.Vendedor;
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
    }
}
