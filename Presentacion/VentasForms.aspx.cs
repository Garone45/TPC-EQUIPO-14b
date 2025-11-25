using Dominio.Articulos;
using Dominio.Usuario_Persona;
using Dominio.Ventas;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class VentasForms : System.Web.UI.Page
    {
        // --- PROPIEDADES DE SESIÓN ---
        private List<DetallePedido> DetalleActual
        {
            get
            {
                if (Session["DetallePedido"] == null)
                    Session["DetallePedido"] = new List<DetallePedido>();
                return (List<DetallePedido>)Session["DetallePedido"];
            }
            set { Session["DetallePedido"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string idPedidoStr = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(idPedidoStr) && int.TryParse(idPedidoStr, out int idPedido))
                {
                    CargarDatosPedido(idPedido); // Modo Edición
                }
                else
                {
                    // Modo Nuevo: Limpieza inicial
                    Session["DetallePedido"] = null;
                    Session["ClienteSeleccionado"] = null;
                    ViewState["IDPedidoEditar"] = null;
                    BindGridClientes(null);
                    ActualizarDetalleYTotales();
                }
            }
        }

        // --- MÉTODOS DE BÚSQUEDA Y GRILLAS (Sin cambios mayores) ---

        protected void txtBuscarCliente_TextChanged(object sender, EventArgs e)
        {
            BindGridClientes(txtBuscarCliente.Text.Trim());
        }

        private void BindGridClientes(string filtro)
        {
            ClienteNegocio negocio = new ClienteNegocio();
            List<Cliente> clientes = negocio.listar();

            if (!string.IsNullOrEmpty(filtro))
            {
                clientes = clientes.Where(c =>
                    c.Nombre.ToLower().Contains(filtro.ToLower()) ||
                    c.Dni.Contains(filtro)
                ).ToList();
            }
            gvClientes.DataSource = clientes;
            gvClientes.DataBind();
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedId = (int)gvClientes.SelectedDataKey.Value;
            Session["ClienteSeleccionado"] = selectedId; // Unificamos nombre de sesión

            ClienteNegocio negocio = new ClienteNegocio();
            Cliente cliente = negocio.listar(selectedId); // Asumo que listar(id) devuelve un objeto

            if (cliente != null)
            {
                txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                txtClientAddress.Text = cliente.Direccion;
                txtClientCity.Text = cliente.Localidad;
                txtClientDNI.Text = cliente.Dni;
                txtClientPhone.Text = cliente.Telefono;
            }
            txtBuscarCliente.Text = string.Empty;
            BindGridClientes(null);
        }

        protected void txtBuscarProductos_TextChanged(object sender, EventArgs e)
        {
            string filtro = txtBuscarProductos.Text.Trim();
            if (!string.IsNullOrEmpty(filtro))
            {
                ArticuloNegocio negocio = new ArticuloNegocio();
                gvProductos.DataSource = negocio.filtrar(filtro);
                gvProductos.DataBind();
                upProductos.Update();
            }
        }

        // --- AGREGAR PRODUCTO CON VALIDACIÓN DE STOCK ---

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            // 1. Validar selección
            if (gvProductos.SelectedDataKey == null)
            {
                mostrarMensaje("⚠️ Seleccione un producto de la lista primero.", true);
                return;
            }

            int idArticulo = (int)gvProductos.SelectedDataKey.Value;
            ArticuloNegocio negocio = new ArticuloNegocio();
            Articulo articulo = negocio.obtenerPorId(idArticulo);

            // 2. Validar Stock Inicial
            if (articulo.StockActual <= 0)
            {
                mostrarMensaje($"⚠️ El producto '{articulo.Descripcion}' no tiene stock disponible.", true);
                return;
            }

            // 3. Validar si ya lo tengo en el carrito y si me paso del stock
            var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idArticulo);
            if (detalle != null)
            {
                if (detalle.Cantidad + 1 > articulo.StockActual)
                {
                    mostrarMensaje($"⚠️ No hay suficiente stock para agregar más. (Stock: {articulo.StockActual})", true);
                    return;
                }
                detalle.Cantidad++;
            }
            else
            {
                DetalleActual.Add(new DetallePedido
                {
                    IDArticulo = articulo.IDArticulo,
                    Descripcion = articulo.Descripcion,
                    PrecioUnitario = articulo.PrecioVentaCalculado,
                    Cantidad = 1
                });
            }

            // 4. Limpieza
            DetalleActual = DetalleActual; // Refrescar sesión
            txtBuscarProductos.Text = "";
            gvProductos.DataSource = null;
            gvProductos.DataBind();

            ActualizarDetalleYTotales();
            upProductos.Update();
        }

        // --- GUARDAR VENTA CON VALIDACIONES FINALES ---

        protected void btnFinalizarVenta_Click(object sender, EventArgs e)
        {
            try
            {
                // VALIDACIÓN 1: Cliente
                if (Session["ClienteSeleccionado"] == null)
                {
                    mostrarMensaje("⚠️ Debe seleccionar un CLIENTE.", true);
                    return;
                }

                // VALIDACIÓN 2: Carrito
                if (DetalleActual == null || DetalleActual.Count == 0)
                {
                    mostrarMensaje("⚠️ El carrito está VACÍO.", true);
                    return;
                }

                // VALIDACIÓN 3: Stock Final (Iteramos todo el carrito antes de guardar)
                ArticuloNegocio artNegocio = new ArticuloNegocio();
                foreach (var item in DetalleActual)
                {
                    Articulo artEnBD = artNegocio.obtenerPorId(item.IDArticulo);
                    if (artEnBD.StockActual < item.Cantidad)
                    {
                        mostrarMensaje($"⚠️ Stock insuficiente para '{item.Descripcion}'. Stock actual: {artEnBD.StockActual}", true);
                        return; // Cancelamos todo
                    }
                }

                // --- SI TODO OK, GUARDAMOS ---

                Pedido pedido = new Pedido();
                if (ViewState["IDPedidoEditar"] != null)
                    pedido.IDPedido = (int)ViewState["IDPedidoEditar"];

                pedido.IDCliente = (int)Session["ClienteSeleccionado"];
                pedido.IDVendedor = 1; // TODO: Usar usuario logueado
                pedido.FechaCreacion = DateTime.Now;
                pedido.Estado = Pedido.EstadoPedido.Pendiente;
                pedido.Detalles = DetalleActual;

                // Totales
                pedido.Subtotal = DetalleActual.Sum(d => d.TotalParcial);
                pedido.Total = pedido.Subtotal * 1.21m; // Ejemplo IVA

                VentasNegocio negocio = new VentasNegocio();

                if (pedido.IDPedido != 0)
                    negocio.Modificar(pedido);
                else
                    negocio.Agregar(pedido);

                // ÉXITO
                Session["msg"] = "Venta registrada correctamente.";
                Response.Redirect("VentasListado.aspx", false);
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error al finalizar: " + ex.Message, true);
            }
        }

        // --- MÉTODOS AUXILIARES ---

        private void ActualizarDetalleYTotales()
        {
            gvDetallePedido.DataSource = DetalleActual;
            gvDetallePedido.DataBind();

            decimal sub = DetalleActual.Sum(d => d.TotalParcial);
            decimal total = sub * 1.21m;

            lblSubtotal.Text = sub.ToString("C");
            lblTotalFinal.Text = total.ToString("C");
            upDetalleVenta.Update();
        }

        private void mostrarMensaje(string msg, bool error)
        {
            lblMensaje.Text = msg;
            lblMensaje.Visible = true;
            lblMensaje.CssClass = error ?
                "block p-4 mb-4 text-sm text-red-800 bg-red-50 rounded-lg border border-red-300" :
                "block p-4 mb-4 text-sm text-green-800 bg-green-50 rounded-lg border border-green-300";

            updMensajes.Update(); // Asegúrate de tener este UpdatePanel en el ASPX
        }

        // ... (Tus eventos RowCommand para sumar/restar y CargarDatosPedido siguen igual) ...
        protected void gvDetallePedido_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Copia aquí tu lógica original de Sumar/Restar/Eliminar del carrito
            // ...
            if (int.TryParse(e.CommandArgument.ToString(), out int idProducto))
            {
                var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idProducto);

                if (detalle != null)
                {
                    switch (e.CommandName)
                    {
                        case "Sumar":
                            detalle.Cantidad++;
                            break;
                        case "Restar":
                            if (detalle.Cantidad > 1)
                                detalle.Cantidad--;
                            else
                                DetalleActual.Remove(detalle); // Eliminar si llega a 0 o menos (o a 1 y se resta)
                            break;
                        case "Eliminar":
                            DetalleActual.Remove(detalle);
                            break;
                    }

                    ActualizarDetalleYTotales();
                }
            }
        }

        private void CargarDatosPedido(int idPedido)
        {
            // Copia aquí tu lógica original de cargar pedido
            // ...
            VentasNegocio negocio = new VentasNegocio();
            Pedido pedido = negocio.ObtenerPorId(idPedido);

            if (pedido != null)
            {
                // A. Guardamos el ID que estamos editando en ViewState para saberlo al guardar
                ViewState["IDPedidoEditar"] = pedido.IDPedido;

                // B. Cargar Cliente (Usamos tu lógica existente de ClienteNegocio)
                Session["ClienteSeleccionado"] = pedido.IDCliente;
                ClienteNegocio clienteNegocio = new ClienteNegocio();
                // Aquí asumo que tienes un método que devuelve un objeto Cliente por ID
                // Si tu listar() devuelve lista, usa .FirstOrDefault()
                List<Cliente> lista = clienteNegocio.listar();
                Cliente cliente = lista.FirstOrDefault(c => c.IDCliente == pedido.IDCliente);

                if (cliente != null)
                {
                    txtClientName.Text = cliente.Nombre;
                    txtClientAddress.Text = cliente.Direccion;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = cliente.Dni;
                    txtClientPhone.Text = cliente.Telefono;
                }

                // C. Cargar Detalles en Session
                Session["DetallePedido"] = pedido.Detalles;

                // D. Refrescar Pantalla
                BindGridClientes(null);
                ActualizarDetalleYTotales();
            }
        }

        // Evento SelectionChanged de Grilla Productos (para habilitar el botón añadir)
        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Esto es necesario para que btnAddProduct sepa qué ID agarrar
        }
    }
}