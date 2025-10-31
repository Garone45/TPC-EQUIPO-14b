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
                datos.setearConsulta("SELECT IdCategoria, Descripcion FROM dbo.Categorias WHERE Activo = 1 ORDER BY Descripcion");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.IDCategoria = (int)datos.Lector["IdCategoria"];
                 
                    aux.descripcion = (string)datos.Lector["Descripcion"];
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
    }
}
