using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data; // Para DBNull
using Dominio.Articulos;
using Negocio; // Para AccesoDatos

namespace Negocio
{
    public class ArticuloNegocio
    {
        public List<Articulo> listar(string busqueda = "") // Parámetro opcional
        {
            List<Articulo> lista = new List<Articulo>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // 1. Consulta SQL base (la que ya tenías)
                string consulta = "SELECT " +
                    "A.IdArticulo, A.Descripcion, A.CodigoArticulo, A.Activo, " +
                    "A.PrecioCostoActual, A.PorcentajeGanancia, A.StockActual, A.StockMinimo, " +
                    "M.IdMarca, M.Descripcion AS MarcaDescripcion, " +
                    "C.IdCategoria, C.Descripcion AS CategoriaDescripcion " +
                    "FROM dbo.Articulos A " +
                    "INNER JOIN dbo.Marcas M ON M.IdMarca = A.IdMarca " +
                    "INNER JOIN dbo.Categorias C ON C.IdCategoria = A.IdCategoria " +
                    "WHERE A.Activo = 1";

                // 2. ✅ LÓGICA DE BÚSQUEDA (El AND se agrega si 'busqueda' no está vacía)
                if (!string.IsNullOrEmpty(busqueda))
                {
                    // Busca en Descripción O en CodigoArticulo
                    consulta += " AND (A.Descripcion LIKE @busqueda OR A.CodigoArticulo LIKE @busqueda)";
                }

                datos.setearConsulta(consulta);

                // 3. Seteamos el parámetro (si es necesario)
                if (!string.IsNullOrEmpty(busqueda))
                {
                    // Usamos '%' para que busque coincidencias parciales (ej: "Moni" trae "Monitor")
                    datos.setearParametro("@busqueda", "%" + busqueda + "%");
                }

                datos.ejecutarLectura();

                // 4. Mapeo (es el mismo que ya tenías)
                while (datos.Lector.Read())
                {
                    // ... (Tu código de mapeo va aquí)
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];
                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.StockMinimo = (int)datos.Lector["StockMinimo"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];
                    aux.Categorias.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.Categorias.descripcion = (string)datos.Lector["CategoriaDescripcion"];

                    lista.Add(aux);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar artículos: ", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void agregar(Articulo nuevoArticulo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("SP_AgregarArticulo");

                datos.setearParametro("@Descripcion", nuevoArticulo.Descripcion);
                datos.setearParametro("@CodigoArticulo", nuevoArticulo.CodigoArticulo);
                datos.setearParametro("@IdMarca", nuevoArticulo.Marca.IDMarca);
                datos.setearParametro("@IdCategoria", nuevoArticulo.Categorias.IDCategoria);
                datos.setearParametro("@PrecioCostoActual", nuevoArticulo.PrecioCostoActual);
                datos.setearParametro("@PorcentajeGanancia", nuevoArticulo.PorcentajeGanancia);
                datos.setearParametro("@StockActual", nuevoArticulo.StockActual);
                datos.setearParametro("@StockMinimo", nuevoArticulo.StockMinimo);
                datos.setearParametro("@Activo", nuevoArticulo.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar artículo en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void modificar(Articulo articuloModificado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarArticulo");

                // Seteamos TODOS los parámetros, incluyendo el ID
                datos.setearParametro("@IdArticulo", articuloModificado.IDArticulo);
                datos.setearParametro("@Descripcion", articuloModificado.Descripcion);
                datos.setearParametro("@CodigoArticulo", articuloModificado.CodigoArticulo);
                datos.setearParametro("@IdMarca", articuloModificado.Marca.IDMarca);
                datos.setearParametro("@IdCategoria", articuloModificado.Categorias.IDCategoria);
                datos.setearParametro("@PrecioCostoActual", articuloModificado.PrecioCostoActual);
                datos.setearParametro("@PorcentajeGanancia", articuloModificado.PorcentajeGanancia);
                datos.setearParametro("@StockActual", articuloModificado.StockActual);
                datos.setearParametro("@StockMinimo", articuloModificado.StockMinimo);
                datos.setearParametro("@Activo", articuloModificado.Activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar artículo en Capa de Negocio.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public Articulo obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // 1. Seteamos el SP y el parámetro de entrada
                datos.setearProcedimiento("SP_ObtenerArticuloPorID");
                datos.setearParametro("@IdArticulo", id);

                // 2. Ejecutamos la lectura
                datos.ejecutarLectura();

                // 3. Mapeamos el resultado (solo esperamos una fila)
                if (datos.Lector.Read())
                {
                    Articulo aux = new Articulo();
                    aux.Marca = new Marca();
                    aux.Categorias = new Categoria();

                    aux.IDArticulo = (int)datos.Lector["IdArticulo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    if (datos.Lector["CodigoArticulo"] != DBNull.Value)
                        aux.CodigoArticulo = (string)datos.Lector["CodigoArticulo"];

                    aux.StockActual = (int)datos.Lector["StockActual"];
                    aux.StockMinimo = (int)datos.Lector["StockMinimo"];
                    aux.PrecioCostoActual = (decimal)datos.Lector["PrecioCostoActual"];
                    aux.PorcentajeGanancia = (decimal)datos.Lector["PorcentajeGanancia"];
                    aux.Activo = (bool)datos.Lector["Activo"];

                    aux.Marca.IDMarca = (int)datos.Lector["IdMarca"];
                    aux.Marca.Descripcion = (string)datos.Lector["MarcaDescripcion"];

                    aux.Categorias.IDCategoria = (int)datos.Lector["IdCategoria"];
                    aux.Categorias.descripcion = (string)datos.Lector["CategoriaDescripcion"]; // 'd' minúscula

                    return aux; // Devuelve el artículo encontrado
                }

                return null; // Si el 'if' no se cumple, no lo encontró
            }
            catch (Exception ex)
            {
                throw new Exception("Error al obtener artículo por ID en Capa de Negocio.", ex);
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
                datos.setearProcedimiento("SP_EliminarLogicoArticulo");
                datos.setearParametro("@IdArticulo", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar (lógico) artículo en Capa de Negocio.", ex);
            }
           
        }

    }
}