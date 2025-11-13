using Dominio.Articulos;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;

namespace Presentacion
{
    public partial class GestionStock : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Verificar que tengamos un ID en la URL
                if (Request.QueryString["id"] == null)
                {
                    // Si no hay ID, no hay nada que gestionar. Lo mandamos de vuelta.
                    Response.Redirect("ProductosListados.aspx", false);
                    return;
                }
                
                // 2. Cargar datos del producto
                try
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    ArticuloNegocio negocio = new ArticuloNegocio();
                    Articulo seleccionado = negocio.obtenerPorId(id);

                    if (seleccionado == null)
                    {
                        Response.Redirect("ProductosListados.aspx", false);
                        return;
                    }

                    // 3. Rellenar los campos bloqueados del formulario
                    txtSKU.Text = seleccionado.IDArticulo.ToString();
                    txtDescripcion.Text = seleccionado.Descripcion;
                    txtStockActual.Text = seleccionado.StockActual.ToString();
                    txtMarca.Text = seleccionado.Marca.Descripcion;           // si tu clase Articulo tiene una relación con Marca
                    txtCategoria.Text = seleccionado.Categorias.descripcion;   // igual para Categoría
                    txtPrecioCostoActual.Text = seleccionado.PrecioCostoActual.ToString("C0");
                    txtPorcentajeGanancia.Text = seleccionado.PorcentajeGanancia.ToString("F0") + " %";


                    ViewState["IDArticulo"] = id;
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al cargar datos del producto: {ex.Message}');</script>");
                }

                // 4. (Futuro) Cargar la grilla gvMovimientos
                // gvMovimientos.DataSource = ...
                // gvMovimientos.DataBind();
            }
        }

        // --- Paso 2: Programar el botón "Editar Atributos" ---
        protected void btnEditarAtributos_Click(object sender, EventArgs e)
        {
            // Tomamos el ID que guardamos en el ViewState (o lo leemos de la URL)
            string id = Request.QueryString["id"];

            // Redirigimos al formulario, pero pasándole el ID
            Response.Redirect($"ProductosForms.aspx?id={id}");
        }

        // --- Paso 3: (Aún no implementado) ---
        // protected void btnGuardarAjuste_Click(object sender, EventArgs e)
        // {
        //     // Lógica para sumar o restar stock manualmente
        // }
    }
}