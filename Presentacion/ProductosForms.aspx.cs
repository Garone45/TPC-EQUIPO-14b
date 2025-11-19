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

                // --- INICIO DE LÓGICA DE MODIFICAR ---
                // 2. Si EsModoEdicion (si la URL trae ?id=...), cargamos los datos
                if (EsModoEdicion)
                {
                    int id = int.Parse(Request.QueryString["id"]);

                    ArticuloNegocio negocio = new ArticuloNegocio();
                    Articulo seleccionado = negocio.obtenerPorId(id);
                    
              
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
                // 1. VALIDAR QUE EL FRONTEND ESTÉ OK
                // Esto verifica todos los RequiredFieldValidator, RangeValidator, etc.
                Page.Validate();
                if (!Page.IsValid)
                    return; // Si hay errores visuales, cortamos la ejecución aquí.

                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo articulo = new Articulo();

                articulo.Descripcion = txtDescripcion.Text;
                articulo.CodigoArticulo = txtSKU.Text;

                // Usamos decimal.Parse. Si el usuario pone algo inválido, el validador del front
                // ya lo debió haber frenado, pero el try-catch es el doble seguro.
                articulo.PrecioCostoActual = decimal.Parse(txtPrecioCostoActual.Text);
                articulo.PorcentajeGanancia = decimal.Parse(txtPorcentajeGanancia.Text);
                articulo.StockActual = int.Parse(txtStockActual.Text);
                articulo.StockMinimo = int.Parse(txtStockMinimo.Text);
                articulo.Activo = true;

                articulo.Marca = new Marca();
                articulo.Marca.IDMarca = int.Parse(ddlMarca.SelectedValue);

                articulo.Categorias = new Categoria();
                articulo.Categorias.IDCategoria = int.Parse(ddlCategoria.SelectedValue);

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
                // MUESTRA EL ERROR EN EL LABEL DENTRO DEL UPDATE PANEL
                lblMensaje.Text = "⚠️ Error: " + ex.Message;
                // Clases de Tailwind para alerta roja (fondo rojo suave, texto rojo oscuro)
                lblMensaje.CssClass = "block bg-red-100 text-red-700 border border-red-400 p-3 rounded font-bold";
                lblMensaje.Visible = true;
            }
        }
    }
}