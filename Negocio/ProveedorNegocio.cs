using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ProveedorNegocio
    {
    
        /// <param name="busqueda">Filtra por RazonSocial o CUIT (opcional)</param>
        public List<Proveedor> listar(string busqueda = "")
        {
            List<Proveedor> lista = new List<Proveedor>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                
                string consulta = "SELECT IDProveedor, RazonSocial, Seudonimo, CUIT, Telefono, Email, Direccion, Activo " +
                                  "FROM dbo.Proveedores WHERE Activo = 1";

                if (!string.IsNullOrEmpty(busqueda))
                {
                    consulta += " AND (RazonSocial LIKE @busqueda OR CUIT LIKE @busqueda)";
                }
                consulta += " ORDER BY RazonSocial";

                
                datos.setearConsulta(consulta);

                
                if (!string.IsNullOrEmpty(busqueda))
                {
                    datos.setearParametro("@busqueda", "%" + busqueda + "%");
                }

                // 4. Ejecutar y Mapear
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Proveedor aux = new Proveedor();
                    aux.ID = (int)datos.Lector["IDProveedor"]; 
                    aux.RazonSocial = (string)datos.Lector["RazonSocial"];

                    // Manejo de Nulos 
                    aux.Seudonimo = datos.Lector["Seudonimo"] != DBNull.Value ? (string)datos.Lector["Seudonimo"] : null;
                    aux.Cuit = (string)datos.Lector["CUIT"];
                    aux.Telefono = datos.Lector["Telefono"] != DBNull.Value ? (string)datos.Lector["Telefono"] : null;
                    aux.Email = datos.Lector["Email"] != DBNull.Value ? (string)datos.Lector["Email"] : null;
                    aux.Direccion = datos.Lector["Direccion"] != DBNull.Value ? (string)datos.Lector["Direccion"] : null;
                    aux.Activo = (bool)datos.Lector["Activo"];

                    lista.Add(aux);
                }
                return lista;
            }
            catch (Exception ex)
            {
                throw new Exception("Error al listar Proveedores.", ex);
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

       
        public void agregar(Proveedor nuevoProveedor)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_AgregarProveedor");
                // Mapeo de parámetros
                datos.setearParametro("@RazonSocial", nuevoProveedor.RazonSocial);
                datos.setearParametro("@Seudonimo", nuevoProveedor.Seudonimo);
                datos.setearParametro("@CUIT", nuevoProveedor.Cuit);
                datos.setearParametro("@Telefono", nuevoProveedor.Telefono);
                datos.setearParametro("@Email", nuevoProveedor.Email);
                datos.setearParametro("@Direccion", nuevoProveedor.Direccion);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al agregar Proveedor.", ex);
            }
            finally
            {
                
            }
        }

    
        public void modificar(Proveedor proveedor)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ModificarProveedor");
                // Mapeo de parámetros (incluyendo el ID)
                datos.setearParametro("@IDProveedor", proveedor.ID);
                datos.setearParametro("@RazonSocial", proveedor.RazonSocial);
                datos.setearParametro("@Seudonimo", proveedor.Seudonimo);
                datos.setearParametro("@CUIT", proveedor.Cuit);
                datos.setearParametro("@Telefono", proveedor.Telefono);
                datos.setearParametro("@Email", proveedor.Email);
                datos.setearParametro("@Direccion", proveedor.Direccion);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al modificar Proveedor.", ex);
            }
            finally
            {
                
            }
        }

     
        public void eliminarLogico(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_EliminarLogicoProveedor");
                datos.setearParametro("@IDProveedor", id);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw new Exception("Error al eliminar Proveedor.", ex);
            }
            finally
            {
                
            }
        }

       
        public Proveedor obtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("SP_ObtenerProveedorPorID");
                datos.setearParametro("@IDProveedor", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Proveedor aux = new Proveedor();
                    aux.ID = (int)datos.Lector["IDProveedor"];
                    aux.RazonSocial = (string)datos.Lector["RazonSocial"];
                    aux.Seudonimo = datos.Lector["Seudonimo"] != DBNull.Value ? (string)datos.Lector["Seudonimo"] : null;
                    aux.Cuit = (string)datos.Lector["CUIT"];
                    aux.Telefono = datos.Lector["Telefono"] != DBNull.Value ? (string)datos.Lector["Telefono"] : null;
                    aux.Email = datos.Lector["Email"] != DBNull.Value ? (string)datos.Lector["Email"] : null;
                    aux.Direccion = datos.Lector["Direccion"] != DBNull.Value ? (string)datos.Lector["Direccion"] : null;
                    aux.Activo = (bool)datos.Lector["Activo"];
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
