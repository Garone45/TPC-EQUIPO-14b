using Dominio.Articulos; 
using System;
using System.Collections.Generic;
using System.Linq; 

namespace Negocio
{
    public class CategoriaNegocio
    {
        public List<Categoria> listar(string busqueda = "")
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {

                string consulta = "SELECT IdCategoria, Descripcion, Activo FROM Categorias WHERE Activo = 1";

        
                if (!string.IsNullOrEmpty(busqueda))
                {
                    consulta += " AND Descripcion LIKE @busqueda";
                }

                datos.setearConsulta(consulta);


                if (!string.IsNullOrEmpty(busqueda))
                {
                    datos.setearParametro("@busqueda", "%" + busqueda + "%");
                }

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
        public void agregar(Categoria nueva)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta("SELECT IdCategoria, Activo FROM Categorias WHERE Descripcion = @desc");
                datos.setearParametro("@desc", nueva.descripcion);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    int id = (int)datos.Lector["IdCategoria"];
                    bool activo = (bool)datos.Lector["Activo"];
                    datos.cerrarConexion();

                    if (activo)
                    {
                        throw new Exception("Ya existe una categoría con ese nombre.");
                    }
                    else
                    {
                        // Existe pero está inactiva -> LA RESTAURAMOS
                        restaurar(id);
                        return;
                    }
                }
                datos.cerrarConexion();

                // 2. Si no existe, creamos nueva
                datos = new AccesoDatos();
                datos.setearProcedimiento("SP_AgregarCategoria");
                datos.setearParametro("@Descripcion", nueva.descripcion);
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

        public void modificar(Categoria categoria)
        {
            // Validación para no renombrar a una que ya existe
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Buscamos si existe OTRA con ese mismo nombre (distinto ID)
                datos.setearConsulta("SELECT IdCategoria FROM Categorias WHERE Descripcion = @desc AND IdCategoria != @id");
                datos.setearParametro("@desc", categoria.descripcion);
                datos.setearParametro("@id", categoria.IDCategoria);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    throw new Exception("El nombre ya está siendo usado por otra categoría.");
                }
                datos.cerrarConexion();

                // Modificamos
                datos = new AccesoDatos();

                datos.setearConsulta("UPDATE Categorias SET Descripcion = @desc WHERE IdCategoria = @id");
                datos.setearParametro("@desc", categoria.descripcion);
                datos.setearParametro("@id", categoria.IDCategoria);
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

        public Categoria obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT IdCategoria, Descripcion FROM Categorias WHERE IdCategoria = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.descripcion = (string)datos.Lector["Descripcion"];
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

        public void eliminarLogico(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
 
                datos.setearConsulta("UPDATE Categorias SET Activo = 0 WHERE IdCategoria = @id");
                datos.setearParametro("@id", id);
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


        private void restaurar(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_RestaurarCategoria");
                datos.setearParametro("@IdCategoria", id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}