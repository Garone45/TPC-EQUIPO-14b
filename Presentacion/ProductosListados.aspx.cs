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
    public partial class ProductosListados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();
            }
        }

        private List<Articulo> Productos
        {
            get
            {
                // Si ViewState "Clientes" existe, devuelve la lista. Si no, devuelve una lista vacía.
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
                // 1. Obtener el texto del filtro
                string filtro = txtBuscar.Text.Trim();

                if (string.IsNullOrEmpty(filtro))
                {
                    // Si el filtro está vacío, cargamos todos los clientes activos.
                    
                    Productos = negocio.listar();
                }
                else
                {
                    // Si hay filtro, usamos el nuevo método de negocio.
                    // *** NOTA: Este método necesita ser implementado en ClienteNegocio.cs (Paso 3) ***
                    Productos = negocio.filtrar(filtro);
                }

                // 2. Vincular la lista (filtrada o completa) a la GridView
                gvProductos.DataSource = Productos;
                gvProductos.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de errores 
                Response.Write($"<script>alert('Error al cargar clientes: {ex.Message}');</script>");
            }
        }
       
        
        
        
        
        //------- EVENTOS ---------//

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvProductos.PageIndex = 0;
            CargarGrilla();
        }
        protected void gvClientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Cambiamos la página actual de la GridView
            gvProductos.PageIndex = e.NewPageIndex;

            // 2. Re-vinculamos la GridView usando la lista guardada en ViewState
            // Esto es crucial para que la paginación funcione sin ir a la BD de nuevo.
            gvProductos.DataSource = Productos;
            gvProductos.DataBind();
        }
        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que definimos en el ASPX
            if (e.CommandName == "EliminarProducto")
            {
                try
                {
                    // 1. Obtenemos el ID del artículo (que viene en CommandArgument)
                    int id = Convert.ToInt32(e.CommandArgument);


                    ArticuloNegocio negocio = new ArticuloNegocio();
                    negocio.eliminarLogico(id);

                    // 3. Recargamos la grilla para que el item desaparezca

                    CargarGrilla();
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al eliminar: {ex.Message}');</script>");
                }
            }
        }
    }
}