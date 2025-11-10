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
    public partial class MarcasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
              
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }
        private void CargarGrilla()
        {
            MarcaNegocio negocio = new MarcaNegocio();
            try
            {
                // 1. Leemos el texto del TextBox
                string filtro = txtBuscar.Text;

                // 2. Llamamos a 'listar' pasándole el filtro
                List<Marca> lista = negocio.listar(filtro);

                // 3. Cargamos la grilla
                gvMarcas.DataSource = lista;
                gvMarcas.DataBind();
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar listado: {ex.Message}');</script>");
            }
        }
        protected void gvMarcas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que definimos en el ASPX
            if (e.CommandName == "EliminarMarca")
            {
                try
                {
                    // 1. Obtenemos el ID de la fila
                    int id = Convert.ToInt32(e.CommandArgument);

                 
                    MarcaNegocio negocio = new MarcaNegocio();
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