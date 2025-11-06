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
                cargarGrilla();

            }

        }
        private List<Cliente> Clientes
        {
            get
            {
                // Si ViewState "Clientes" existe, devuelve la lista. Si no, devuelve una lista vacía.
                if (ViewState["Clientes"] == null)
                    ViewState["Clientes"] = new List<Cliente>();
                return (List<Cliente>)ViewState["Clientes"];
            }
            set
            {
                ViewState["Clientes"] = value;
            }
        }
        private void cargarGrilla()
        {
            ClienteNegocio negocio = new ClienteNegocio();

            try
            {
                // 1. Obtener el texto del filtro
                string filtro = txtBuscar.Text.Trim();

                if (string.IsNullOrEmpty(filtro))
                {
                    // Si el filtro está vacío, cargamos todos los clientes activos.
                    Clientes = negocio.listar();
                }
                else
                {
                    // Si hay filtro, usamos el nuevo método de negocio.
                    // *** NOTA: Este método necesita ser implementado en ClienteNegocio.cs (Paso 3) ***
                    Clientes = negocio.filtrar(filtro);
                }

                // 2. Vincular la lista (filtrada o completa) a la GridView
                gvClientes.DataSource = Clientes;
                gvClientes.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de errores 
                Response.Write($"<script>alert('Error al cargar clientes: {ex.Message}');</script>");
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            // Recargamos la grilla aplicando el filtro ingresado.
            // Esto también reseteará el índice de la paginación si hubiera uno.
            gvClientes.PageIndex = 0;
            cargarGrilla();
        }

        protected void gvClientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Cambiamos la página actual de la GridView
            gvClientes.PageIndex = e.NewPageIndex;

            // 2. Re-vinculamos la GridView usando la lista guardada en ViewState
            // Esto es crucial para que la paginación funcione sin ir a la BD de nuevo.
            gvClientes.DataSource = Clientes;
            gvClientes.DataBind();
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
                    cargarGrilla();
                }
                catch (Exception ex)
                {
                    // Manejar el error
                }
            }
        }

       
    }
}