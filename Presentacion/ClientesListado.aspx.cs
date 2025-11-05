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
    }
}