using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProductosForms : System.Web.UI.Page
    {
     
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }
            Usuario user = (Usuario)Session["usuario"];

            if (user.TipoUsuario != TipoUsuario.ADMIN) // caso para alguien disinto a admin 
            {
               
                Session.Add("error", "No tienes permisos para acceder a esta pantalla.");
                Response.Redirect("ProductosListados.aspx", false);
                return;
            }
          
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
              
                MarcaNegocio marcaNegocio = new MarcaNegocio();
                CategoriaNegocio categoriaNegocio = new CategoriaNegocio();
                try
                {
                    ddlMarca.DataSource = marcaNegocio.listar();
                    ddlMarca.DataValueField = "IDMarca";
                    ddlMarca.DataTextField = "Descripcion";
                    ddlMarca.DataBind();
                    ddlMarca.Items.Insert(0, new ListItem("-- Seleccionar Marca --", "0"));

                    ddlCategoria.DataSource = categoriaNegocio.listar();
                    ddlCategoria.DataValueField = "IDCategoria";
                    ddlCategoria.DataTextField = "descripcion";
                    ddlCategoria.DataBind();
                    ddlCategoria.Items.Insert(0, new ListItem("-- Seleccionar Categoría --", "0"));

                    ProveedorNegocio proveedorNegocio = new ProveedorNegocio();
                    ddlProveedor.DataSource = proveedorNegocio.listar();
                    ddlProveedor.DataValueField = "ID"; // o 
                    ddlProveedor.DataTextField = "RazonSocial";
                    ddlProveedor.DataBind();
                    ddlProveedor.Items.Insert(0, new ListItem("-- Seleccionar Proveedor --", "0"));

                    if (!EsModoEdicion)
                    {
                        ArticuloNegocio negocio = new ArticuloNegocio();
                        int proximoId = negocio.obtenerProximoId();
                        txtSKU.Text = proximoId.ToString();
                        txtSKU.ReadOnly = true;

                       
                    }
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error crítico al cargar página: {ex.Message}');</script>");
                    return;
                }

            
                if (EsModoEdicion)
                {
                    int id = int.Parse(Request.QueryString["id"]);

                    ArticuloNegocio negocio = new ArticuloNegocio();
                    Articulo seleccionado = negocio.obtenerPorId(id);

                    if (seleccionado.Proveedor != null)
                        ddlProveedor.SelectedValue = seleccionado.Proveedor.ID.ToString();

                    txtSKU.Text = seleccionado.IDArticulo.ToString();
                    txtSKU.ReadOnly = true;
                    txtDescripcion.Text = seleccionado.Descripcion;
                    txtPrecioCostoActual.Text = seleccionado.PrecioCostoActual.ToString("F0");
                    txtPorcentajeGanancia.Text = seleccionado.PorcentajeGanancia.ToString("F0");
                    txtPrecioVenta.Text = seleccionado.PrecioVentaCalculado.ToString("C0");
                    txtStockActual.Text = seleccionado.StockActual.ToString();
                    txtStockMinimo.Text = seleccionado.StockMinimo.ToString();

                    // Seleccionamos los DropDownLists
                    ddlMarca.SelectedValue = seleccionado.Marca.IDMarca.ToString();
                    ddlCategoria.SelectedValue = seleccionado.Categorias.IDCategoria.ToString();
                }
                // --- FIN LÓGICA DE MODIFICAR ---
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
            
                Page.Validate();
                if (!Page.IsValid)
                    return; // Si hay errores visuales, cortamos la ejecución aquí.

                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo articulo = new Articulo();

                articulo.Descripcion = txtDescripcion.Text;
                articulo.CodigoArticulo = txtSKU.Text;

 
                articulo.PrecioCostoActual = decimal.Parse(txtPrecioCostoActual.Text);
                articulo.PorcentajeGanancia = decimal.Parse(txtPorcentajeGanancia.Text);
                articulo.StockActual = int.Parse(txtStockActual.Text);
                articulo.StockMinimo = int.Parse(txtStockMinimo.Text);
                articulo.Activo = true;

                articulo.Marca = new Marca();
                articulo.Marca.IDMarca = int.Parse(ddlMarca.SelectedValue);

                articulo.Categorias = new Categoria();
                articulo.Categorias.IDCategoria = int.Parse(ddlCategoria.SelectedValue);

                articulo.Proveedor = new Proveedor();
                articulo.Proveedor.ID = int.Parse(ddlProveedor.SelectedValue);

                // 2. LOGICA DE NEGOCIO (Agregar o Modificar)
                if (EsModoEdicion)
                {
                    articulo.IDArticulo = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(articulo);
                }
                else
                {
                    negocio.agregar(articulo);
                }

                // 3. ÉXITO
                Response.Redirect("ProductosListados.aspx", false);
            }
            catch (Exception ex)
            {
            
                lblMensaje.Text = "⚠️ Error: " + ex.Message;
              
                lblMensaje.CssClass = "block bg-red-100 text-red-700 border border-red-400 p-3 rounded font-bold";
                lblMensaje.Visible = true;
            }
        }
    }
}