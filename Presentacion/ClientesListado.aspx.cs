using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ClientesListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. CHEQUEO LOGIN
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario user = (Usuario)Session["usuario"];

            if (user.TipoUsuario == TipoUsuario.VENDEDOR)
            {
             
            }
            if (!IsPostBack)
            {
                cargarGrilla();
            }
        }

        private List<Cliente> Clientes
        {
            get
            {
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
                string filtro = txtBuscar.Text.Trim();

                if (string.IsNullOrEmpty(filtro))
                {
                    Clientes = negocio.listar();
                }
                else
                {
                    Clientes = negocio.filtrar(filtro);
                }

                gvClientes.DataSource = Clientes;
                gvClientes.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        // --- EVENTOS ---

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvClientes.PageIndex = 0;
            cargarGrilla();
        }

        protected void gvClientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvClientes.PageIndex = e.NewPageIndex;
            gvClientes.DataSource = Clientes;
            gvClientes.DataBind();
        }

        // --- NUEVO MÉTODO DE ELIMINACIÓN (Llamado por el botón oculto) ---
        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdCliente.Value))
                {
                    int id = int.Parse(hfIdCliente.Value);
                    ClienteNegocio negocio = new ClienteNegocio();
                    negocio.eliminarLogico(id);

                    cargarGrilla(); // Refrescamos la tabla
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }
        public bool EsAdmin()
        {
            if (Session["usuario"] != null)
            {
                Dominio.Usuario_Persona.Usuario user = (Dominio.Usuario_Persona.Usuario)Session["usuario"];
                return user.TipoUsuario == Dominio.Usuario_Persona.TipoUsuario.ADMIN;
            }
            return false;
        }
    }
}