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
        public List<Marca> listar(string busqueda)
        {
            List<Marca> lista = new List<Marca>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // 1. Armamos la consulta SQL (Siempre trae 'Activo')
                string consulta = "SELECT IDMarca, Descripcion, Activo FROM dbo.Marcas WHERE Activo = 1";

                if (!string.IsNullOrEmpty(busqueda))
                {
                    consulta += " AND Descripcion LIKE @busqueda";
                }
                consulta += " ORDER BY Descripcion";

                // 2. Seteamos consulta ANTES de parámetros
                datos.setearConsulta(consulta);

                // 3. Seteamos parámetros DESPUÉS
                if (!string.IsNullOrEmpty(busqueda))
                {
                    datos.setearParametro("@busqueda", "%" + busqueda + "%");
                }

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Marca aux = new Marca();
                    aux.IDMarca = (int)datos.Lector["IDMarca"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Estado = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar Marcas.", ex);
            }
            finally
            {
                datos.cerrarConexion(); 
            }
        }
        public void agregar(Marca nuevaMarca)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_AgregarMarca");
                datos.setearParametro("@Descripcion", nuevaMarca.Descripcion);
                datos.ejecutarAccion(); 
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar Marca: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void modificar(Marca marca)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarMarca");
                datos.setearParametro("@IdMarca", marca.IDMarca);
                datos.setearParametro("@Descripcion", marca.Descripcion);
                datos.ejecutarAccion(); // Esta línea ya cierra la conexión
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar Marca: " + ex.Message);
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
                datos.setearProcedimiento("SP_EliminarLogicoMarca");
                datos.setearParametro("@IdMarca", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar (lógico) Marca en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public Marca obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ObtenerMarcaPorID");
                datos.setearParametro("@IdMarca", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Marca aux = new Marca();
                    aux.IDMarca = (int)datos.Lector["IDMarca"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Estado = (bool)datos.Lector["Activo"];
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
