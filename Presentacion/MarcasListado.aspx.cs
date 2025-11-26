using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class MarcasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            // 2. VALIDAR PERMISO (Solo ADMIN ve compras)
            Usuario user = (Usuario)Session["usuario"];
            if (user.TipoUsuario != TipoUsuario.ADMIN)
            {
                Session.Add("error", "No tienes permisos para gestionar Marcas.");
                Response.Redirect("Default.aspx", false);
                return;
            }

  
            if (!IsPostBack)
            {
                ComprasNegocio negocio = new ComprasNegocio();
               
            }
            if (!IsPostBack)
            {
                // Configuración inicial opcional para el buscador
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        private List<Marca> Marcas
        {
            get
            {
                if (ViewState["Marcas"] == null)
                    ViewState["Marcas"] = new List<Marca>();
                return (List<Marca>)ViewState["Marcas"];
            }
            set
            {
                ViewState["Marcas"] = value;
            }
        }

        private void CargarGrilla()
        {
            MarcaNegocio negocio = new MarcaNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
             
                if (string.IsNullOrEmpty(filtro))
                    Marcas = negocio.listar();
                else
                   
                    Marcas = negocio.listar(filtro); 

                gvMarcas.DataSource = Marcas;
                gvMarcas.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvMarcas.PageIndex = 0;
            CargarGrilla();
        }

        protected void gvMarcas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMarcas.PageIndex = e.NewPageIndex;
            gvMarcas.DataSource = Marcas;
            gvMarcas.DataBind();
        }


        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdMarca.Value))
                {
                    int id = int.Parse(hfIdMarca.Value);
                    MarcaNegocio negocio = new MarcaNegocio();
                    negocio.eliminarLogico(id);
                    CargarGrilla();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }

        
        protected void gvMarcas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        }
    }
}