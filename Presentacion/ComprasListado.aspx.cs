using Dominio.Compras;
using Dominio.Ventas;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ComprasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                CargarCompras();
            }
        }
        private List<Compra> ListaCompras
        {
            get
            {
                if (ViewState["Compras"] == null)
                    ViewState["Compras"] = new List<Compra>();
                return (List<Compra>)ViewState["Compras"];
            }
            set
            {
                ViewState["Compras"] = value;
            }
        }


        private void CargarCompras()
        {
            ComprasNegocio negocio = new ComprasNegocio();
            List<Compra> listaCompras = null;

            // 1. OBTENER EL FILTRO: Si es la búsqueda, tendrá texto.
            string filtroTexto = txtBuscar.Text.Trim();

            try
            {
                if (string.IsNullOrEmpty(filtroTexto))
                {

                    listaCompras = negocio.ListarCompras();
                }
                else
                {

                    listaCompras = negocio.Filtrar(filtroTexto);
                }


                gvCompras.DataSource = listaCompras;
                gvCompras.DataBind();
                ListaCompras = listaCompras;

            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar Compras: {ex.Message}');</script>");
            }

        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            // Al cambiar el texto, volvemos a llamar a CargarVentas, que ahora usa el nuevo texto.
            gvCompras.PageIndex = 0;
            CargarCompras();


        }

        protected void gvCompras_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Cambiamos la página actual de la GridView
            gvCompras.PageIndex = e.NewPageIndex;

            // 2. Re-vinculamos la GridView usando la lista guardada en ViewState
            // Esto es crucial para que la paginación funcione sin ir a la BD de nuevo.
            gvCompras.DataSource = ListaCompras;
            gvCompras.DataBind();
        }
        protected void gvCompras_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Verificamos que el comando sea el que llamamos "Eliminar"
            if (e.CommandName == "Eliminar")
            {
                try
                {
                    // 1. Obtenemos el índice de la fila desde el CommandArgument
                    int rowIndex = Convert.ToInt32(e.CommandArgument);

                    // 2. Obtenemos el IDCliente de esa fila usando los DataKeys del GridView
                    // (¡Asegúrate de que 'IDCliente' esté en DataKeyNames en tu ASPX!)
                    // <asp:GridView ... DataKeyNames="IDCliente" ... > (Ya lo tienes bien)
                    int idCompras = Convert.ToInt32(gvCompras.DataKeys[rowIndex].Value);

                    // 3. Llamamos al método de negocio para el borrado lógico
                    ClienteNegocio negocio = new ClienteNegocio();
                    negocio.eliminarLogico(idCompras);

                    // 4. Volvemos a cargar la grilla para que refleje el cambio
                    // (Necesitarás tener un método para cargar la grilla,
                    // probablemente el mismo que usas en el Page_Load)
                    CargarCompras();
                }
                catch (Exception ex)
                {
                    // Manejar el error
                }
            }
        }
        public string GetEstadoClass(string estado)
        {
            switch (estado)
            {
                case "Entregado":
                    return "inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800 dark:bg-green-800/30 dark:text-green-300";
                case "Pendiente":
                    return "inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-yellow-100 text-yellow-800 dark:bg-yellow-800/30 dark:text-yellow-300";
                case "Cancelado":
                    return "inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-red-100 text-red-800 dark:bg-red-800/30 dark:text-red-300";
                default:
                    return "inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-gray-100 text-gray-800 dark:bg-gray-700/50 dark:text-gray-300";
            }
        }
    }
}