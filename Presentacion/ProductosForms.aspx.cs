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
                    // Cargar DDL de Marcas
                    ddlMarca.DataSource = marcaNegocio.listar();
                    ddlMarca.DataValueField = "IdMarca";     // El 'Value' del ListItem (el ID)
                    ddlMarca.DataTextField = "Descripcion"; 
                    ddlMarca.DataBind();
                    
                    ddlMarca.Items.Insert(0, new ListItem("-- Seleccionar Marca --", "0"));

                    // Cargar DDL de Categorías
                    ddlCategoria.DataSource = categoriaNegocio.listar();
                    ddlCategoria.DataValueField = "IdCategoria";
                    ddlCategoria.DataTextField = "Descripcion";
                    ddlCategoria.DataBind();
                    ddlCategoria.Items.Insert(0, new ListItem("-- Seleccionar Categoría --", "0"));
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al cargar desplegables: {ex.Message}');</script>");
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
               
                ArticulosNegocio negocio = new ArticulosNegocio();
                Articulo nuevo = new Articulo();

                //  Cargamos el objeto 'nuevo' con los datos del formulario 

                
                nuevo.Descripcion = txtDescripcion.Text;
                nuevo.CodigoArticulo = txtSKU.Text; // Asumimos que vas a habilitar este campo
                nuevo.PrecioCostoActual = decimal.Parse(txtPrecioCompra.Text);
                nuevo.PorcentajeGanancia = decimal.Parse(txtPorcentajeGanancia.Text); 
                nuevo.StockActual = int.Parse(txtStockActual.Text);
                nuevo.StockMinimo = int.Parse(txtStockMinimo.Text);
                nuevo.Activo = true;

                // DropDownLists
                nuevo.Marca = new Marca();
                nuevo.Marca.IDMarca = int.Parse(ddlMarca.SelectedValue);

                nuevo.Categorias = new Categoria();
                nuevo.Categorias.IDCategoria = int.Parse(ddlCategoria.SelectedValue);

                
                negocio.agregar(nuevo);

                //  Redirigimos de vuelta al listado
                Response.Redirect("ProductosListados.aspx", false);
            }
            catch (Exception ex)
            {
           
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}