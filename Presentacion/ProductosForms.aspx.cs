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
    public partial class ProductosForms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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

                    // Cargar DDL de Categorías
                    ddlCategoria.DataSource = categoriaNegocio.listar();
                    ddlCategoria.DataValueField = "IDCategoria";
                    ddlCategoria.DataTextField = "descripcion"; 
                    ddlCategoria.DataBind();
                    ddlCategoria.Items.Insert(0, new ListItem("-- Seleccionar Categoría --", "0"));
                }
                catch (Exception ex)
                {
                    
                    Response.Write($"<script>alert('Error crítico al cargar página: {ex.Message}');</script>");
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones de DropDownList
                if (ddlMarca.SelectedValue == "0")
                {
                    Response.Write("<script>alert('Debe seleccionar una marca');</script>");
                    return;
                }

                if (ddlCategoria.SelectedValue == "0")
                {
                    Response.Write("<script>alert('Debe seleccionar una categoría');</script>");
                    return;
                }

                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo nuevo = new Articulo();

                nuevo.Descripcion = txtDescripcion.Text;

                // Generar código si viene vacío
                if (string.IsNullOrWhiteSpace(txtSKU.Text))
                    nuevo.CodigoArticulo = Guid.NewGuid().ToString().Substring(0, 8).ToUpper();
                else
                    nuevo.CodigoArticulo = txtSKU.Text;

                nuevo.PrecioCostoActual = decimal.Parse(txtPrecioCompra.Text);
                nuevo.PorcentajeGanancia = decimal.Parse(txtPorcentajeGanancia.Text);
                nuevo.StockActual = int.Parse(txtStockActual.Text);
                nuevo.StockMinimo = int.Parse(txtStockMinimo.Text);
                nuevo.Activo = true;

                // Marca
                nuevo.Marca = new Marca();
                nuevo.Marca.IDMarca = int.Parse(ddlMarca.SelectedValue);

                // Categoría
                nuevo.Categorias = new Categoria();
                nuevo.Categorias.IDCategoria = int.Parse(ddlCategoria.SelectedValue);

                negocio.agregar(nuevo);

                Session["msg"] = "Artículo agregado correctamente";
                Response.Redirect("ProductosListados.aspx");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}