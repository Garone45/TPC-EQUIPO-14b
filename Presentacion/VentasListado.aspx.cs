using Dominio.Ventas;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class VentasListado : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            if (!IsPostBack)
            {
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
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
                gvPedidos.DataSource = null;
                gvPedidos.DataBind();
                ViewState["Pedidos"] = value; 
            }
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

                ListaPedidos = lista;
                gvPedidos.DataSource = lista;
                gvPedidos.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al cargar ventas: " + ex.Message);
            }
        }

        protected void btnBuscarTrigger_Click(object sender, EventArgs e)
        {
            // Reseteamos la paginación para que al buscar no quedes en la página 5 sin resultados
            gvPedidos.PageIndex = 0;

            // Cargamos la grilla
            CargarVentas();

            // Ponemos el foco de nuevo en el buscador (aunque tu JS ya hace esto, es un refuerzo)
            txtBuscar.Focus();
        }

        protected void gvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPedidos.PageIndex = e.NewPageIndex;

            // Si la lista está vacía por algún motivo, la recargamos.
            if (ListaPedidos == null || ListaPedidos.Count == 0)
            {
                CargarVentas();
            }
            else
            {
                // Si no está vacía, usamos el ViewState.
                gvPedidos.DataSource = ListaPedidos;
                gvPedidos.DataBind();
            }
        }
        protected void btnEntregarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdPedidoEntregar.Value))
                {
                    int idPedido = int.Parse(hfIdPedidoEntregar.Value);
                    VentasNegocio negocio = new VentasNegocio();

                    // ⭐ CAMBIO: Usamos el nuevo método transaccional
                    if (negocio.ConfirmarEntrega(idPedido))
                    {
                        // Éxito
                        CargarVentas(); // Recargar la grilla para ver el estado "Entregado"
                        updVentas.Update();

                        // Opcional: Mostrar mensaje de éxito
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alertSuccess", "alert('Pedido entregado y stock actualizado.');", true);
                    }
                    else
                    {
                        // Fallo (probablemente el pedido ya no estaba pendiente)
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alertError", "alert('No se pudo entregar el pedido. Verifique que esté Pendiente.');", true);
                    }
                }
            }
            catch (Exception ex)
            {
                // Error grave (Base de datos, stock negativo si tienes constraints, etc.)
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alertCrash", $"alert('Error: {ex.Message}');", true);
            }
        }



        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(IdVenta.Value))
                {
                    int id = int.Parse(IdVenta.Value);
                    VentasNegocio negocio = new VentasNegocio();

                    negocio.Eliminar(id);

                    CargarVentas();
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