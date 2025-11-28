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
        public void agregar(Marca nueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                
                datos.setearConsulta("SELECT IDMarca, Activo FROM Marcas WHERE Descripcion = @desc");
                datos.setearParametro("@desc", nueva.Descripcion);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
               
                    int id = (int)datos.Lector["IDMarca"];
                    bool activo = (bool)datos.Lector["Activo"];

                    datos.cerrarConexion();

                    if (activo)
                    {
                       
                        throw new Exception("La marca ya existe en el sistema.");
                    }
                    else
                    {
                        
                        restaurar(id);
                        return; 
                    }
                }

                
                datos.cerrarConexion(); 
                datos = new AccesoDatos(); 

                datos.setearProcedimiento("SP_AgregarMarca");
                datos.setearParametro("@Descripcion", nueva.Descripcion);
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

        // Método auxiliar para reactivar
        public void restaurar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_RestaurarMarca");
                datos.setearParametro("@IDMarca", id);
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

       
        public void modificar(Marca marca)
        {
            List<Marca> listado = listar();
            // Validamos que exista otra marca CON EL MISMO NOMBRE pero DISTINTO ID
            if (listado.Any(m => m.Descripcion.ToUpper() == marca.Descripcion.ToUpper() && m.IDMarca != marca.IDMarca))
            {
                throw new Exception("Ya existe otra marca con ese nombre.");
            }

            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarMarca");
                datos.setearParametro("@IdMarca", marca.IDMarca);
                datos.setearParametro("@Descripcion", marca.Descripcion);
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
        public int obtenerProximoId()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT ISNULL(MAX(IdMarca), 0) + 1 AS ProximoID FROM Marcas");
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                    return (int)datos.Lector["ProximoID"];
                else
                    return 1;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener el próximo ID: " + ex.Message);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
