using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class CategoriaNegocio
    {
        public List<Categoria> listar()
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Trae solo las activas, ordenadas
                datos.setearConsulta("SELECT IDCategoria, Descripcion, Activo FROM dbo.Categorias WHERE Activo = 1 ORDER BY Descripcion");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.IDCategoria = (int)datos.Lector["IDCategoria"];

                    // (Tu clase Categoria usa 'descripcion' minúscula)
                    aux.descripcion = (string)datos.Lector["Descripcion"];

                    // (Tu clase Categoria usa 'estado' minúscula)
                    aux.estado = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar Categorías en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
