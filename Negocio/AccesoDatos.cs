using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic; 

namespace Negocio 
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector 
        {
            get { return lector; }
        }

        public AccesoDatos() // Constructor
        {
            
            conexion = new SqlConnection("server=.\\SQLEXPRESS; database=TPC_GRUPO_14b; integrated security=true");
            comando = new SqlCommand();
        }

        public void setearConsulta(string consulta) // Para SELECT
        {
            comando.Parameters.Clear();
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        public void setearParametro(string nombre, object valor) // Para agregar parámetros (@nombre)
        {
            // Usamos ?? DBNull.Value para manejar valores nulos en C#
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
                throw ex;
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
            finally
            {
                
                if (conexion.State == System.Data.ConnectionState.Open)
                    conexion.Close();
            }
        }

        public void cerrarConexion() 
        {
            // Asegurar que el lector se cierre si fue abierto
            if (lector != null && !lector.IsClosed)
                lector.Close();

            // Asegurar que la conexión se cierre
            if (conexion != null && conexion.State == System.Data.ConnectionState.Open)
                conexion.Close();
        }
    }
}