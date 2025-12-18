using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class CategoriasListado : System.Web.UI.Page
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
                Session.Add("error", "No tienes permisos para gestionar Categorias.");
                Response.Redirect("Default.aspx", false);
                return;
            }

            // Carga normal...
            if (!IsPostBack)
            {
                ComprasNegocio negocio = new ComprasNegocio();
                
            }
            if (!IsPostBack)
            {
                // Configuración inicial
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        private void CargarGrilla()
        {
            CategoriaNegocio negocio = new CategoriaNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
             
                List<Categoria> lista = negocio.listar(filtro);

                gvCategorias.DataSource = lista;
                gvCategorias.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar listado: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvCategorias.PageIndex = 0;
            CargarGrilla();
        }

  
        protected void gvCategorias_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCategorias.PageIndex = e.NewPageIndex;
            CargarGrilla();
        }

        // --- NUEVO MÉTODO DE ELIMINACIÓN (Botón Oculto) ---
        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdCategoria.Value))
                {
                    int id = int.Parse(hfIdCategoria.Value);
                    CategoriaNegocio negocio = new CategoriaNegocio();
                    negocio.eliminarLogico(id);

                    CargarGrilla();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }
    }
}