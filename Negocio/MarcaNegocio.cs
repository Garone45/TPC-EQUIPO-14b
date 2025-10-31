using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class MarcaNegocio
    {
        public List<Marca> listar()
        {
            List<Marca> lista = new List<Marca>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT IdMarca, Descripcion FROM dbo.Marcas WHERE Activo = 1 ORDER BY Descripcion");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Marca aux = new Marca();
                    aux.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
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
