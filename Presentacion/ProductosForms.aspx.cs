using Dominio.Articulos;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProductosForms : System.Web.UI.Page
    {
        // Propiedad para saber si estamos en modo Edición
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificamos si la URL trae un ID ANTES del IsPostBack
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                // 1. Cargar DropDownLists (Esto ya lo tenías)
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
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error crítico al cargar página: {ex.Message}');</script>");
                    return;
                }

                // --- INICIO DE LÓGICA DE MODIFICAR ---
                // 2. Si EsModoEdicion (si la URL trae ?id=...), cargamos los datos
                if (EsModoEdicion)
                {
                    // Cambiamos el título
                    // (Si tu h1 tiene runat="server" e ID="tituloPagina")
                    // tituloPagina.InnerText = "Modificar Producto"; 

                    int id = int.Parse(Request.QueryString["id"]);

                    // Necesitamos un método para traer UN solo artículo
                    ArticuloNegocio negocio = new ArticuloNegocio();
                    // ¡OJO! Asumo que ya agregaste 'obtenerPorId' a ArticuloNegocio
                    Articulo seleccionado = negocio.obtenerPorId(id);

                    // Rellenamos el formulario con los datos
                    txtSKU.Text = seleccionado.CodigoArticulo;
                    txtSKU.ReadOnly = true; // El SKU no debería cambiarse al editar
                    txtDescripcion.Text = seleccionado.Descripcion;
                    txtPrecioCompra.Text = seleccionado.PrecioCostoActual.ToString("F2");
                    txtPorcentajeGanancia.Text = seleccionado.PorcentajeGanancia.ToString("F2");
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
                // (Validaciones de DDLs - Ya las tenías)
                if (ddlMarca.SelectedValue == "0" || ddlCategoria.SelectedValue == "0")
                {
                    Response.Write("<script>alert('Debe seleccionar marca y categoría');</script>");
                    return;
                }

                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo articulo = new Articulo();

                // 1. Cargar el objeto (igual que antes)
                articulo.Descripcion = txtDescripcion.Text;
                articulo.CodigoArticulo = txtSKU.Text;
                articulo.PrecioCostoActual = decimal.Parse(txtPrecioCompra.Text);
                articulo.PorcentajeGanancia = decimal.Parse(txtPorcentajeGanancia.Text);
                articulo.StockActual = int.Parse(txtStockActual.Text);
                articulo.StockMinimo = int.Parse(txtStockMinimo.Text);
                articulo.Activo = true;

                articulo.Marca = new Marca();
                articulo.Marca.IDMarca = int.Parse(ddlMarca.SelectedValue);

                articulo.Categorias = new Categoria();
                articulo.Categorias.IDCategoria = int.Parse(ddlCategoria.SelectedValue);

                // 2. Decidir si AGREGAR o MODIFICAR
                if (EsModoEdicion) // Si la página cargó con un ID...
                {
                    // Obtenemos el ID de la URL
                    articulo.IDArticulo = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(articulo); // ¡Llamamos al método MODIFICAR!
                    Session["msg"] = "Artículo modificado correctamente";
                }
                else // Si la página cargó sin ID...
                {
                    negocio.agregar(articulo); // ¡Llamamos al método AGREGAR!
                    Session["msg"] = "Artículo agregado correctamente";
                }

                // 3. Redirigir al listado
                Response.Redirect("ProductosListados.aspx");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}