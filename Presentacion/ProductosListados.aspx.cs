using Dominio.Articulos;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace Presentacion
{
    public partial class ProductosListados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               // txtBuscar.Attributes.Add("onfocus", "this.value = '';");
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }
    
        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            CargarGrilla();
        }

      
        private void CargarGrilla()
        {
            ArticuloNegocio negocio = new ArticuloNegocio();
            try
            {
                
                string filtro = txtBuscar.Text;

                List<Articulo> lista = negocio.listar(filtro);

                gvProductos.DataSource = lista;
                gvProductos.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar listado: {ex.Message}');</script>");
            }
        }
        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que definimos en el ASPX
            if (e.CommandName == "EliminarProducto")
            {
                try
                {
                    // 1. Obtenemos el ID del artículo (que viene en CommandArgument)
                    int id = Convert.ToInt32(e.CommandArgument);


                    ArticuloNegocio negocio = new ArticuloNegocio();
                    negocio.eliminarLogico(id);

                    // 3. Recargamos la grilla para que el item desaparezca

                    CargarGrilla();
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al eliminar: {ex.Message}');</script>");
                }
            }
        }
    }
}