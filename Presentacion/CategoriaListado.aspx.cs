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
    public partial class CategoriasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //txtBuscar.Attributes.Add("onfocus", "this.value = '';");
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");

                CargarGrilla();
            }
        }

        
        private void CargarGrilla()
        {
            CategoriaNegocio negocio = new CategoriaNegocio();
            try
            {
              
                string filtro = txtBuscar.Text;
                List<Categoria> lista = negocio.listar(filtro);
           
                gvCategorias.DataSource = lista;
                gvCategorias.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar listado: {ex.Message}');</script>");
            }
        }

        protected void gvCategorias_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que sea nuestro comando "Eliminar"
            if (e.CommandName == "EliminarCategoria")
            {
                try
                {
                    
                    int id = Convert.ToInt32(e.CommandArgument);

                    
                    CategoriaNegocio negocio = new CategoriaNegocio();
                    negocio.eliminarLogico(id);

                   
                    CargarGrilla();
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al eliminar: {ex.Message}');</script>");
                }
            }
        }

       
        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
   
            CargarGrilla();
        }
    }
}