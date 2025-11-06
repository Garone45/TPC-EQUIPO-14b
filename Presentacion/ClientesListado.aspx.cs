using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ClientesListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();

            }

        }
        private void CargarGrilla()
        {
            try
            {
                // 1. Instanciamos la capa de negocio
                ClienteNegocio negocio = new ClienteNegocio();

                // 2. Obtenemos la lista
                List<Cliente> listaClientes = negocio.listar();

                // 3. Asignamos la lista al DataSource del GridView
                gvClientes.DataSource = listaClientes;

                // 4. Ejecutamos el enlace de datos
                gvClientes.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de errores
                Response.Write($"<script>alert('Error al cargar los clientes: {ex.Message}');</script>");
            }
        }

        protected void gvClientes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que llamamos "Eliminar"
            if (e.CommandName == "Eliminar")
            {
                try
                {
                    // 1. Obtenemos el índice de la fila desde el CommandArgument
                    int rowIndex = Convert.ToInt32(e.CommandArgument);

                    // 2. Obtenemos el IDCliente de esa fila usando los DataKeys del GridView
                    // (¡Asegúrate de que 'IDCliente' esté en DataKeyNames en tu ASPX!)
                    // <asp:GridView ... DataKeyNames="IDCliente" ... > (Ya lo tienes bien)
                    int idCliente = Convert.ToInt32(gvClientes.DataKeys[rowIndex].Value);

                    // 3. Llamamos al método de negocio para el borrado lógico
                    ClienteNegocio negocio = new ClienteNegocio();
                    negocio.eliminarLogico(idCliente);

                    // 4. Volvemos a cargar la grilla para que refleje el cambio
                    // (Necesitarás tener un método para cargar la grilla,
                    // probablemente el mismo que usas en el Page_Load)
                    CargarGrilla();
                }
                catch (Exception ex)
                {
                    // Manejar el error
                }
            }
        }
    }
}