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
                // 1. CAMBIO EN LA CONSULTA:
                // Buscamos 'TipoUser' (INT) en lugar de 'Rol'.
                // La tabla ahora pide 'NombreUser' y 'Contraseña'.
                datos.setearConsulta("SELECT IDUsuario, NombreUser, TipoUser, Activo FROM Usuario WHERE NombreUser = @user AND Contraseña = @pass AND Activo = 1");

                datos.Comando.Parameters.Clear();

                // 2. PARÁMETROS:
                // Asignamos las propiedades de tu objeto a los parámetros de SQL
                datos.Comando.Parameters.AddWithValue("@user", usuario.NombreUsuario);
                datos.Comando.Parameters.AddWithValue("@pass", usuario.Contraseña);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    // 3. MAPEO DE DATOS:
                    usuario.IDUsuario = (int)datos.Lector["IDUsuario"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUser"];

                    // 4. MAGIA DEL ENUM:
                    // Como en la BD es 1 o 2, y tu Enum es ADMIN=1, VENDEDOR=2,
                    // hacemos un cast directo de int a TipoUsuario.
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

                // ejecutarAccionScalar devuelve un entero (la cantidad encontrada)
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