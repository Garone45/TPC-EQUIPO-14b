using Dominio.Articulos;
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
    public partial class ComprasForms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Solo cargamos los datos la primera vez que la página se carga
                CargarProveedores();
                CargarProductos();
            }
        }

        private void CargarProveedores()
        {
            try
            {

                ProveedorNegocio negocio = new ProveedorNegocio();
                List<Proveedor> listaProveedores = negocio.listar();

                ddlProveedor.DataValueField = "ID";
                ddlProveedor.DataTextField = "RazonSocial";

                ddlProveedor.DataSource = listaProveedores;
                ddlProveedor.DataBind();
                ddlProveedor.Items.Insert(0, new ListItem("--- Seleccionar un proveedor ---", ""));

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al cargar proveedores: {ex.Message}");
                ddlProveedor.Items.Clear();
                ddlProveedor.Items.Insert(0, new ListItem($"Error de carga: {ex.InnerException?.Message ?? ex.Message}", ""));
            }
        }
        private void CargarProductos()
        {
            try
            {

                ArticuloNegocio negocio = new ArticuloNegocio();
                List<Articulo> listaArticulos = negocio.listar();

                ddlProductoItem.DataValueField = "IDArticulo";
                ddlProductoItem.DataTextField = "Descripcion";

                ddlProductoItem.DataSource = listaArticulos;
                ddlProductoItem.DataBind();
                ddlProductoItem.Items.Insert(0, new ListItem("--- Seleccionar un producto ---", ""));

            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error al cargar productos: {ex.Message}");
                ddlProductoItem.Items.Clear();
                ddlProductoItem.Items.Insert(0, new ListItem($"Error de carga: {ex.InnerException?.Message ?? ex.Message}", ""));
            }
        }
    }
}