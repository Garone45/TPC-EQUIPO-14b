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
    public partial class ProveedoresListado  : System.Web.UI.Page
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
            ProveedorNegocio negocio = new ProveedorNegocio();
            try
            {
            
                string filtro = txtBuscar.Text;     
                List<Proveedor> lista = negocio.listar(filtro);
                gvProveedores.DataSource = lista;
                gvProveedores.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar listado: {ex.Message}');</script>");
            }
        }

       
        protected void gvProveedores_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que sea nuestro comando "Eliminar"
            if (e.CommandName == "EliminarProveedor")
            {
                try
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    ProveedorNegocio negocio = new ProveedorNegocio();
                    negocio.eliminarLogico(id);
                    CargarGrilla(); // Recargamos la grilla
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al eliminar: {ex.Message}');</script>");
                }
            }
        }

   
        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            // Recargamos la grilla usando el filtro
            CargarGrilla();
        }
    }
}