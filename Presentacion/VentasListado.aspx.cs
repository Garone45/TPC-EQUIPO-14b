using Dominio.Usuario_Persona;
using Dominio.Ventas; // Para usar tu clase Pedido
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class VentasListado : Page
    {
        // Propiedad para guardar la lista en ViewState (opcional pero bueno para mantener el estado)
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
               
                CargarVentas();
            }
        }
        private List<Pedido> ListaPedidos
        {
            get
            {
                if (ViewState["Pedidos"] == null)
                    ViewState["Pedidos"] = new List<Pedido>();
                return (List<Pedido>)ViewState["Pedidos"];
            }
            set
            {
                ViewState["Pedidos"] = value;
            }
        }


        private void CargarVentas()
        {
            VentasNegocio negocio = new VentasNegocio();
            List<Pedido> listaPedidos = null;

            // 1. OBTENER EL FILTRO: Si es la búsqueda, tendrá texto.
            string filtroTexto = txtBuscar.Text.Trim();

            try
            {
                if (string.IsNullOrEmpty(filtroTexto))
                {
                    // Si el filtro está vacío, listar todo (Lógica de Clientes)
                    listaPedidos = negocio.ListarPedidos();
                }
                else
                {
                    // Si hay filtro, usamos el método de filtro (Lógica de Clientes)
                    listaPedidos = negocio.Filtrar(filtroTexto);
                }

                // Guardamos la lista en la propiedad (ViewState) para uso futuro (ej: paginación)
                gvPedidos.DataSource = listaPedidos;
                gvPedidos.DataBind();
                ListaPedidos = listaPedidos;

            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al cargar Pedidos: {ex.Message}');</script>");
            }

        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            // Al cambiar el texto, volvemos a llamar a CargarVentas, que ahora usa el nuevo texto.
            gvPedidos.PageIndex = 0;
            CargarVentas();

          
        }

        protected void gvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // 1. Cambiamos la página actual de la GridView
            gvPedidos.PageIndex = e.NewPageIndex;

            // 2. Re-vinculamos la GridView usando la lista guardada en ViewState
            // Esto es crucial para que la paginación funcione sin ir a la BD de nuevo.
            gvPedidos.DataSource = ListaPedidos;
            gvPedidos.DataBind();
        }
        protected void gvPedidos_RowCommand(object sender, GridViewCommandEventArgs e)
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
                    int idPedido = Convert.ToInt32(gvPedidos.DataKeys[rowIndex].Value);

                    // 3. Llamamos al método de negocio para el borrado lógico
                    ClienteNegocio negocio = new ClienteNegocio();
                    negocio.eliminarLogico(idPedido);

                    // 4. Volvemos a cargar la grilla para que refleje el cambio
                    // (Necesitarás tener un método para cargar la grilla,
                    // probablemente el mismo que usas en el Page_Load)
                    CargarVentas();
                }
                catch (Exception ex)
                {
                    // Manejar el error
                }
            }
        }

        protected string GetEstadoClass(string estado)
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