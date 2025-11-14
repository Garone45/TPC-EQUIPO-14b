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
    public partial class MarcasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();
            }
        }

        private List<Marca> Marcas
        {
            get
            {
                // Si ViewState "Clientes" existe, devuelve la lista. Si no, devuelve una lista vacía.
                if (ViewState["Marcas"] == null)
                    ViewState["Marcas"] = new List<Marca>();
                return (List<Marca>)ViewState["Marcas"];
            }
            set
            {
                ViewState["Marcas"] = value;
            }
        }
        private void CargarGrilla()
        {
            MarcaNegocio negocio = new MarcaNegocio();
            try
            {
                // 1. Obtener el texto del filtro
                string filtro = txtBuscar.Text.Trim();

                if (string.IsNullOrEmpty(filtro))
                {
                    // Si el filtro está vacío, cargamos todos los clientes activos.

                    Marcas = negocio.listar();
                }
                else
                {
                    // Si hay filtro, usamos el nuevo método de negocio.
                    // *** NOTA: Este método necesita ser implementado en ClienteNegocio.cs (Paso 3) ***
                    Marcas = negocio.listar(filtro);
                }

                // 2. Vincular la lista (filtrada o completa) a la GridView
                gvMarcas.DataSource = Marcas;
                gvMarcas.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de errores 
                Response.Write($"<script>alert('Error al cargar clientes: {ex.Message}');</script>");
            }
        }
        protected void gvMarcas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que definimos en el ASPX
            if (e.CommandName == "EliminarMarca")
            {
                try
                {
                    // 1. Obtenemos el ID de la fila
                    int id = Convert.ToInt32(e.CommandArgument);

                 
                    MarcaNegocio negocio = new MarcaNegocio();
                    negocio.eliminarLogico(id); 

                   
                    CargarGrilla();
                }
                catch (Exception ex)
                {
                    Response.Write($"<script>alert('Error al eliminar: {ex.Message}');</script>");
                }
            }
        }
        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvMarcas.PageIndex = 0;
            CargarGrilla();
        }
        protected void gvMarcas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Cambiamos la página actual de la GridView
            gvMarcas.PageIndex = e.NewPageIndex;

            // 2. Re-vinculamos la GridView usando la lista guardada en ViewState
            // Esto es crucial para que la paginación funcione sin ir a la BD de nuevo.
            gvMarcas.DataSource = Marcas;
            gvMarcas.DataBind();
        }
    }
}