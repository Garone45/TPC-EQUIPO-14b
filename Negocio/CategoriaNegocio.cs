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
            return listar(""); 
        }
        public List<Categoria> listar(string busqueda)
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = "SELECT IDCategoria, Descripcion, Activo FROM dbo.Categorias WHERE Activo = 1";
                if (!string.IsNullOrEmpty(busqueda))
                {
                    consulta += " AND Descripcion LIKE @busqueda";
                }
                consulta += " ORDER BY Descripcion";

                datos.setearConsulta(consulta);

                if (!string.IsNullOrEmpty(busqueda))
                {
                    datos.setearParametro("@busqueda", "%" + busqueda + "%");
                }

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.IDCategoria = (int)datos.Lector["IDCategoria"];
                    aux.descripcion = (string)datos.Lector["Descripcion"]; // 'd' minúscula
                    aux.estado = (bool)datos.Lector["Activo"]; // 'e' minúscula
                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar Categorías.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Categoria nuevaCategoria)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_AgregarCategoria");
                datos.setearParametro("@Descripcion", nuevaCategoria.descripcion); 
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar Categoría.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

       
        public void modificar(Categoria categoria)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarCategoria");
                datos.setearParametro("@IdCategoria", categoria.IDCategoria);
                datos.setearParametro("@Descripcion", categoria.descripcion); 
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar Categoría.", ex);
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
                datos.setearProcedimiento("SP_EliminarLogicoCategoria");
                datos.setearParametro("@IdCategoria", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar (lógico) Categoría.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Categoria obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ObtenerCategoriaPorID");
                datos.setearParametro("@IdCategoria", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.IDCategoria = (int)datos.Lector["IDCategoria"];
                    aux.descripcion = (string)datos.Lector["Descripcion"]; // 'd' minúscula
                    aux.estado = (bool)datos.Lector["Activo"]; // 'e' minúscula
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