using System;
using System.Data;
using System.Data.SqlClient;

namespace Negocio // (O el namespace de tu capa de datos)
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector => lector;

        public AccesoDatos()
        {
            conexion = new SqlConnection("server=.\\SQLEXPRESS; database=TPC_GRUPO_14b; integrated security=true");
            comando = new SqlCommand();
        }

        public void setearConsulta(string consulta)
        {
            comando.Parameters.Clear();
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        public void setearProcedimiento(string sp)
        {
            comando.Parameters.Clear();
            comando.CommandType = System.Data.CommandType.StoredProcedure;
            comando.CommandText = sp;
        }

        public void setearParametro(string nombre, object valor)
        {
            comando.Parameters.AddWithValue(nombre, valor ?? DBNull.Value);
        }

        public void ejecutarLectura() 
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex; // La excepción viaja a la capa de Negocio
            }
        }

      
        public void ejecutarAccion() 
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                comando.ExecuteNonQuery(); 
            }
            catch (Exception ex)
            {
                throw ex;
            }
           
        }

       
        public void cerrarConexion()
        {
            if (lector != null && !lector.IsClosed)
            {
                lector.Close();
            }
            if (conexion != null && conexion.State == System.Data.ConnectionState.Open)
            {
                conexion.Close();
            }
        }

        public int ejecutarAccionScalar()
        {
            comando.Connection = conexion;
            try
            {
                comando.Connection.Open();

                // ExecuteScalar devuelve el valor de la primera columna de la primera fila
                object resultado = comando.ExecuteScalar();

                if (resultado != null && resultado != DBNull.Value)
                {
                    return Convert.ToInt32(resultado);
                }

                return -1;
            }
            catch (Exception ex)
            {
                comando.Parameters.Clear();
                throw ex;
            }
            finally
            {
                cerrarConexion();
            }
        }
    }
}