using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProveedoresListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Configuración inicial
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        private void CargarGrilla()
        {
            ProveedorNegocio negocio = new ProveedorNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
                List<Proveedor> lista = negocio.listar(filtro);

                gvProveedores.DataSource = lista;
                gvProveedores.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar listado: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvProveedores.PageIndex = 0;
            CargarGrilla();
        }


        protected void gvProveedores_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProveedores.PageIndex = e.NewPageIndex;
            CargarGrilla();
        }

        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdProveedor.Value))
                {
                    int id = int.Parse(hfIdProveedor.Value);
                    ProveedorNegocio negocio = new ProveedorNegocio();
                    negocio.eliminarLogico(id);

                    CargarGrilla(); // Refrescamos
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }
    }
}