using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProductosListados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario user = (Usuario)Session["usuario"];

        
            if (user.TipoUsuario == TipoUsuario.VENDEDOR)
            {
                // Ocultamos el botón "Agregar Producto"
                btnNuevo.Visible = false;
                gvProductos.Columns[7].Visible = false;
            }

     


            if (!IsPostBack)
            {
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        private List<Articulo> Productos
        {
            get
            {
                if (ViewState["Productos"] == null)
                    ViewState["Productos"] = new List<Articulo>();
                return (List<Articulo>)ViewState["Productos"];
            }
            set
            {
                ViewState["Productos"] = value;
            }
        }

        private void CargarGrilla()
        {
            ArticuloNegocio negocio = new ArticuloNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
                if (string.IsNullOrEmpty(filtro))
                    Productos = negocio.listar();
                else
                    Productos = negocio.filtrar(filtro);

                gvProductos.DataSource = Productos;
                gvProductos.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvProductos.PageIndex = 0;
            CargarGrilla();
        }

        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProductos.PageIndex = e.NewPageIndex;
            gvProductos.DataSource = Productos;
            gvProductos.DataBind();
        }

        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdProducto.Value))
                {
                    int id = int.Parse(hfIdProducto.Value);
                    ArticuloNegocio negocio = new ArticuloNegocio();
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