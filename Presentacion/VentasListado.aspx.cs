using Dominio.Ventas;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class VentasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarVentas();
            }
        }

        // Propiedad para guardar estado (opcional)
        private List<Pedido> ListaPedidos
        {
            get
            {
                if (ViewState["Pedidos"] == null)
                    ViewState["Pedidos"] = new List<Pedido>();
                return (List<Pedido>)ViewState["Pedidos"];
            }
            set { ViewState["Pedidos"] = value; }
        }

        private void CargarVentas()
        {
            VentasNegocio negocio = new VentasNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
                List<Pedido> lista;

                if (string.IsNullOrEmpty(filtro))
                    lista = negocio.ListarPedidos();
                else
                    lista = negocio.Filtrar(filtro);

                gvPedidos.DataSource = lista;
                gvPedidos.DataBind();
                ListaPedidos = lista;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar ventas: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvPedidos.PageIndex = 0;
            CargarVentas();
        }

        protected void gvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPedidos.PageIndex = e.NewPageIndex;
            gvPedidos.DataSource = ListaPedidos;
            gvPedidos.DataBind();
        }

        // --- MÉTODO DE CANCELACIÓN (Llamado por el botón oculto) ---
        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdVenta.Value))
                {
                    int id = int.Parse(hfIdVenta.Value);
                    VentasNegocio negocio = new VentasNegocio();

                    // Llama al método Eliminar que agregamos antes (Update Estado = 'Cancelado')
                    negocio.Eliminar(id);

                    CargarVentas(); // Refrescamos
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cancelar venta: " + ex.Message);
            }
        }

        // Método para colores de estado
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