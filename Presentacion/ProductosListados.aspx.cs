using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq; 
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProductosListados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            Usuario user = (Usuario)Session["usuario"];

            if (user.TipoUsuario == TipoUsuario.VENDEDOR)
            {
                // Ocultamos el botón "Agregar Producto"
                btnNuevo.Visible = false;
                // Ocultamos la columna de acciones 
                if (gvProductos.Columns.Count > 7) gvProductos.Columns[7].Visible = false;
            }

            if (!IsPostBack)
            {
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        // --- PROPIEDADES NUEVAS PARA ORDENAMIENTO ---
        private string SortDirection
        {
            get { return ViewState["SortDirection"] as string ?? "ASC"; }
            set { ViewState["SortDirection"] = value; }
        }

        private string SortExpression
        {
            get { return ViewState["SortExpression"] as string ?? ""; }
            set { ViewState["SortExpression"] = value; }
        }
        // ---------------------------------------------

        private List<Articulo> Productos
        {
            get
            {
                if (ViewState["Productos"] == null)
                    ViewState["Productos"] = new List<Articulo>();
                return (List<Articulo>)ViewState["Productos"];
            }
            set
            {
                ViewState["Productos"] = value;
            }
        }

      
        private void CargarGrilla()
        {
            ArticuloNegocio negocio = new ArticuloNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
                List<Articulo> listaTemp;

                // 1. Obtener datos
                if (string.IsNullOrEmpty(filtro))
                    listaTemp = negocio.listar();
                else
                    listaTemp = negocio.filtrar(filtro);

                // 2. Aplicar ordenamiento si existe expresión
                if (!string.IsNullOrEmpty(SortExpression))
                {
                    listaTemp = AplicarOrdenamiento(listaTemp);
                }

                // 3. Guardar en ViewState y Enlazar
                Productos = listaTemp;
                gvProductos.DataSource = Productos;
                gvProductos.DataBind();

                // 4. Agregar flechitas visuales
                AgregarFlechasOrdenamiento();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        // --- NUEVO: Lógica para ordenar la lista según la columna ---
        private List<Articulo> AplicarOrdenamiento(List<Articulo> lista)
        {
       

            bool ascendente = SortDirection == "ASC";

            switch (SortExpression)
            {
                case "IDArticulo":
                    return ascendente ? lista.OrderBy(x => x.IDArticulo).ToList() : lista.OrderByDescending(x => x.IDArticulo).ToList();

                case "Descripcion":
                    return ascendente ? lista.OrderBy(x => x.Descripcion).ToList() : lista.OrderByDescending(x => x.Descripcion).ToList();

                case "Marca": // Ordenar por descripción de la marca
                    return ascendente ? lista.OrderBy(x => x.Marca.Descripcion).ToList() : lista.OrderByDescending(x => x.Marca.Descripcion).ToList();

        
                case "PrecioVentaCalculado": 
                    return ascendente ? lista.OrderBy(x => x.PrecioVentaCalculado).ToList() : lista.OrderByDescending(x => x.PrecioVentaCalculado).ToList();

                default:
                    return lista;
            }
        }

        protected void gvProductos_Sorting(object sender, GridViewSortEventArgs e)
        {
           
            if (SortExpression == e.SortExpression)
            {
                
                SortDirection = (SortDirection == "ASC") ? "DESC" : "ASC";
            }
            else
            {
                // Si es columna nueva, reseteamos a ASC
                SortExpression = e.SortExpression;
                SortDirection = "ASC";
            }

            // Recargar la grilla con el nuevo orden
            CargarGrilla();
        }

      
        private void AgregarFlechasOrdenamiento()
        {
            if (string.IsNullOrEmpty(SortExpression)) return;

            int columnIndex = -1;
            // Buscamos qué columna tiene el SortExpression actual
            foreach (DataControlField col in gvProductos.Columns)
            {
                if (col.SortExpression == SortExpression)
                {
                    columnIndex = gvProductos.Columns.IndexOf(col);
                    break;
                }
            }

            // Si encontramos la columna y el header existe
            if (columnIndex != -1 && gvProductos.HeaderRow != null)
            {
                Label sortIcon = new Label();
                sortIcon.CssClass = "material-symbols-outlined text-sm align-middle ml-1";
                sortIcon.Text = (SortDirection == "ASC") ? "arrow_drop_down" : "arrow_drop_up";
               

                gvProductos.HeaderRow.Cells[columnIndex].Controls.Add(sortIcon);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvProductos.PageIndex = 0;
            CargarGrilla();
        }

        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProductos.PageIndex = e.NewPageIndex;
            // Importante: Al cambiar de página, volvemos a cargar (que ya incluye el orden guardado)
            CargarGrilla();
        }

        /* protected void btnEliminarServer_Click(object sender, EventArgs e)
         {
             try
             {
                 if (!string.IsNullOrEmpty(hfIdProducto.Value))
                 {
                     int id = int.Parse(hfIdProducto.Value);
                     ArticuloNegocio negocio = new ArticuloNegocio();
                     negocio.eliminarLogico(id);
                     CargarGrilla();
                 }
             }
             catch (Exception ex)
             {
                 System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
             }
         }*/

        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            string valorId = hfIdProducto.Value;

            try
            {
                if (!string.IsNullOrEmpty(valorId))
                {
                    int id = int.Parse(valorId);
                    ArticuloNegocio negocio = new ArticuloNegocio();

                    // 1. Ejecutar eliminación
                    negocio.eliminarLogico(id);

                    // 2. Recargar grilla
                    CargarGrilla();
                    upnlGrillaProductos.Update();

                    string script = "mostrarMensaje('¡Eliminado!', 'El producto fue eliminado correctamente.', 'success');";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "MensajeExito", script, true);
                }
            }
            catch (Exception ex)
            {
               

                string mensajeLimpio = ex.Message.Replace("'", "").Replace("\n", " ");
                string script = $"mostrarMensaje('Error', '{mensajeLimpio}', 'error');";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "MensajeError", script, true);
            }
        }
    }
}