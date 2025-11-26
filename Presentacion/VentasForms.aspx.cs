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

                    // Limpiar campos visuales
                    txtClientName.Text = "";
                    txtClientAddress.Text = "";
                    txtClientCity.Text = "";
                    txtClientDNI.Text = "";
                    txtClientPhone.Text = "";

                    ActualizarDetalleYTotales();
                }
            }
        }

        // --- MÉTODOS DE BÚSQUEDA ---

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
                    c.Apellido.ToLower().Contains(filtro.ToLower()) ||
                    c.Dni.Contains(filtro)
                ).ToList();
            }
            gvClientes.DataSource = clientes;
            gvClientes.DataBind();
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedId = (int)gvClientes.SelectedDataKey.Value;
            Session["ClienteSeleccionado"] = selectedId;

            ClienteNegocio negocio = new ClienteNegocio();
            // Asumiendo que listar() devuelve todos, buscamos el seleccionado en memoria
            // O idealmente usa negocio.obtenerPorId(selectedId) si lo tienes implementado
            Cliente cliente = negocio.listar().FirstOrDefault(c => c.IDCliente == selectedId);

            if (cliente != null)
            {
                txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                txtClientAddress.Text = cliente.Direccion + " " + cliente.Altura;
                txtClientCity.Text = cliente.Localidad;
                txtClientDNI.Text = cliente.Dni;
                txtClientPhone.Text = cliente.Telefono;

                mostrarMensaje("Cliente seleccionado correctamente.", false);
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

        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Evento necesario para que el botón Select funcione, aunque la lógica la hacemos en btnAddProduct
        }

        // --- AGREGAR PRODUCTO AL CARRITO (CON VALIDACIONES) ---
        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            // VALIDACIÓN 1: ¿Seleccionó algo en la grilla?
            if (gvProductos.SelectedDataKey == null)
            {
                mostrarMensaje("⚠️ Debe buscar y SELECCIONAR un producto de la lista antes de añadir.", true);
                return;
            }

            int idArticulo = (int)gvProductos.SelectedDataKey.Value;

            ArticuloNegocio negocio = new ArticuloNegocio();
            Articulo articulo = negocio.obtenerPorId(idArticulo);

            if (articulo == null) return;

            // VALIDACIÓN 2: Stock disponible
            if (articulo.StockActual <= 0)
            {
                mostrarMensaje($"⚠️ El producto '{articulo.Descripcion}' no tiene stock disponible.", true);
                return;
            }

            // VALIDACIÓN 3: Stock suficiente (si ya tengo en el carrito)
            var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idArticulo);
            if (detalle != null)
            {
                if (detalle.Cantidad + 1 > articulo.StockActual)
                {
                    mostrarMensaje($"⚠️ Stock insuficiente. Solo quedan {articulo.StockActual} unidades.", true);
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

            // Limpieza y actualización
            DetalleActual = DetalleActual; // Guardar cambios en Session

            txtBuscarProductos.Text = "";
            gvProductos.DataSource = null;
            gvProductos.DataBind();
            gvProductos.SelectedIndex = -1; // Deseleccionar

            ActualizarDetalleYTotales();
            upProductos.Update();
            mostrarMensaje("Producto añadido al carrito.", false);
        }

        // --- GESTIÓN DE GRILLA CARRITO (SUMAR/RESTAR) ---
        protected void gvDetallePedido_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (int.TryParse(e.CommandArgument.ToString(), out int idProducto))
            {
                var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idProducto);

                if (detalle != null)
                {
                    switch (e.CommandName)
                    {
                        case "Sumar":
                            // Aquí también podrías validar stock máximo contra la BD si quisieras ser muy estricto
                            detalle.Cantidad++;
                            break;
                        case "Restar":
                            if (detalle.Cantidad > 1)
                                detalle.Cantidad--;
                            else
                                DetalleActual.Remove(detalle);
                            break;
                        case "Eliminar":
                            DetalleActual.Remove(detalle);
                            break;
                    }
                    ActualizarDetalleYTotales();
                }
            }
        }

        private void ActualizarDetalleYTotales()
        {
            gvDetallePedido.DataSource = DetalleActual;
            gvDetallePedido.DataBind();

            decimal subtotal = DetalleActual.Sum(d => d.TotalParcial);
            decimal iva = subtotal * 0.21m; // Ejemplo IVA 21%
            decimal total = subtotal + iva;

            lblSubtotal.Text = subtotal.ToString("C");
            lblIVA.Text = iva.ToString("C");
            lblTotalFinal.Text = total.ToString("C");

            upDetalleVenta.Update();
        }

        // --- FINALIZAR VENTA (GUARDAR) ---
        protected void btnFinalizarVenta_Click(object sender, EventArgs e)
        {
            try
            {
                // VALIDACIÓN 4: Cliente
                if (Session["ClienteSeleccionado"] == null)
                {
                    mostrarMensaje("⚠️ Error: Debe seleccionar un cliente para facturar.", true);
                    return;
                }

                // VALIDACIÓN 5: Carrito vacío
                if (DetalleActual == null || DetalleActual.Count == 0)
                {
                    mostrarMensaje("⚠️ Error: No se puede generar una venta sin productos.", true);
                    return;
                }

                // VALIDACIÓN 6: Re-chequeo final de Stock (Crucial en entornos multi-usuario)
                ArticuloNegocio artNegocio = new ArticuloNegocio();
                foreach (var item in DetalleActual)
                {
                    Articulo artBD = artNegocio.obtenerPorId(item.IDArticulo);
                    if (artBD.StockActual < item.Cantidad)
                    {
                        mostrarMensaje($"⚠️ Error de Stock: '{item.Descripcion}' tiene solo {artBD.StockActual} disponibles.", true);
                        return;
                    }
                }

                // --- Armado del Pedido ---
                Pedido pedido = new Pedido();

                // Si es edición, recuperamos ID. Si no, queda en 0.
                if (ViewState["IDPedidoEditar"] != null)
                    pedido.IDPedido = (int)ViewState["IDPedidoEditar"];

                pedido.IDCliente = (int)Session["ClienteSeleccionado"];
                pedido.IDVendedor = 1; // TODO: Sacar del Login actual
                pedido.FechaCreacion = DateTime.Now;
                pedido.Estado = Pedido.EstadoPedido.Pendiente;
                pedido.MetodoPago = "Efectivo"; // Opcional: Podrías poner un DropDown de pago
                pedido.Detalles = DetalleActual;

                // Totales
                decimal sub = DetalleActual.Sum(d => d.TotalParcial);
                pedido.Subtotal = sub;
                pedido.Total = sub * 1.21m; // +IVA

                // Guardar
                VentasNegocio negocio = new VentasNegocio();
                if (pedido.IDPedido != 0)
                    negocio.Modificar(pedido);
                else
                    negocio.Agregar(pedido);

                // Limpieza
                Session["DetallePedido"] = null;
                Session["ClienteSeleccionado"] = null;
                ViewState["IDPedidoEditar"] = null;

                // Redirigir
                Response.Redirect("VentasListado.aspx", false);
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error crítico al guardar: " + ex.Message, true);
            }
        }

        // --- Cargar Datos para Edición ---
        private void CargarDatosPedido(int idPedido)
        {
            VentasNegocio negocio = new VentasNegocio();
            Pedido pedido = negocio.ObtenerPorId(idPedido);

            if (pedido != null)
            {
                ViewState["IDPedidoEditar"] = pedido.IDPedido;
                Session["ClienteSeleccionado"] = pedido.IDCliente;
                Session["DetallePedido"] = pedido.Detalles;

                // Cargar datos visuales del cliente
                ClienteNegocio cliNegocio = new ClienteNegocio();
                Cliente cliente = cliNegocio.listar().FirstOrDefault(c => c.IDCliente == pedido.IDCliente);

                if (cliente != null)
                {
                    txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                    txtClientAddress.Text = cliente.Direccion;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = cliente.Dni;
                    txtClientPhone.Text = cliente.Telefono;
                }

                BindGridClientes(null);
                ActualizarDetalleYTotales();
            }
        }

        // --- MÉTODO PARA MOSTRAR MENSAJES EN EL UPDATE PANEL ---
        private void mostrarMensaje(string mensaje, bool esError)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;

            if (esError)
            {
                // Estilo Rojo (Error)
                lblMensaje.CssClass = "block w-full p-4 mb-4 text-sm text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800";
            }
            else
            {
                // Estilo Verde (Éxito)
                lblMensaje.CssClass = "block w-full p-4 mb-4 text-sm text-green-800 border border-green-300 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400 dark:border-green-800";
            }

            // IMPORTANTE: Actualizar el panel para que se vea el mensaje
            updMensajes.Update();
        }
    }
}