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
        private bool EsModoVer { get; set; } = false;
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
                string modo = Request.QueryString["modo"];

                if (modo == "Ver")
                {
                    EsModoVer = true;
                }
                BindProductos(null);

                if (!string.IsNullOrEmpty(idPedidoStr) && int.TryParse(idPedidoStr, out int idPedido))
                {
                    CargarDatosPedido(idPedido); 
                   
                    if (EsModoVer)
                    {
                        // Si el modo es ver, bloqueamos todo
                        ConfigurarVistaSoloLectura();
                        mostrarMensaje("Modo Visualización: No se pueden realizar cambios.", false);
                    }
                    else
                    {
                        // Modo Edición (Modificar)
                        mostrarMensaje("Modo Edición: Puede modificar el pedido.", false);
                    }
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

        // --- MÉTODOS DE CLIENTES ---

        protected void txtBuscarCliente_TextChanged(object sender, EventArgs e)
        {
            // 1. Obtener el texto limpiando espacios
            string filtro = txtBuscarCliente.Text.Trim();

            // 2. Lógica de Decisión
            if (string.IsNullOrEmpty(filtro))
            {
              
                BindGridClientes(null);

              
            }
            else
            {
                // Si hay texto, filtramos.
                BindGridClientes(filtro);
            }
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

            // Lógica para mostrar/ocultar mensaje de "Sin resultados"
            if (clientes.Count > 0)
            {
                rptClientes.DataSource = clientes;
                rptClientes.DataBind();
                rptClientes.Visible = true;
                pnlSinResultados.Visible = false;
            }
            else
            {
               
                rptClientes.Visible = false;
                pnlSinResultados.Visible = true; // Mostramos el mensaje (ocupa el espacio vacío)

                // Opcional: Cambiar el texto dinámicamente
                if (string.IsNullOrEmpty(filtro))
                    ((Label)pnlSinResultados.Controls[0]).Text = "Empieza a escribir para buscar..."; // Si tuvieras un label dentro
            }
        }

        protected void rptClientes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Seleccionar")
            {
                // Obtenemos el ID del CommandArgument
                int idCliente = Convert.ToInt32(e.CommandArgument);

                // --- TU LÓGICA DE SELECCIÓN (Es la misma que tenías antes) ---
                Session["ClienteSeleccionado"] = idCliente;

                ClienteNegocio negocio = new ClienteNegocio();
                Cliente cliente = negocio.listar().FirstOrDefault(c => c.IDCliente == idCliente);

                if (cliente != null)
                {
                    txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                    txtClientAddress.Text = cliente.Direccion + " " + cliente.Altura;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = cliente.Dni;
                    txtClientEmail.Text = cliente.Email;
                    txtClientPhone.Text = cliente.Telefono;

                    mostrarMensaje("Cliente seleccionado correctamente.", false);
                }

                // Limpiamos el buscador y ocultamos la lista para que quede limpio
                txtBuscarCliente.Text = string.Empty;
             
                pnlSinResultados.Visible = false;
            }
        }


        /// METODO DE PRODUCTOS

        private void BindProductos(string filtro)
        {
            ArticuloNegocio negocio = new ArticuloNegocio();
            List<Articulo> lista;

            if (string.IsNullOrEmpty(filtro))
            {
                lista = negocio.listar();
            }
            else
            {
                lista = negocio.filtrar(filtro);
            }

            if (lista != null && lista.Count > 0)
            {
                rptProductos.DataSource = lista;
                rptProductos.DataBind();
                rptProductos.Visible = true;
                pnlSinProductos.Visible = false;
            }
            else
            {
                rptProductos.Visible = false;
                pnlSinProductos.Visible = true;
            }
        }

        // Evento del TextBox
        protected void txtBuscarProductos_TextChanged(object sender, EventArgs e)
        {
            BindProductos(txtBuscarProductos.Text.Trim());

            // Foco de vuelta al input para seguir escribiendo o buscando otro
            ScriptManager.RegisterStartupScript(this, this.GetType(), "FocusScript",
                $"document.getElementById('{txtBuscarProductos.ClientID}').focus();", true);
        }


        protected void rptProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AgregarCarrito")
            {
                int idArticulo = Convert.ToInt32(e.CommandArgument);

                // 1. Obtener el artículo desde la BD
                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo articulo = negocio.obtenerPorId(idArticulo);

                if (articulo != null)
                {
                    // 2. Validar Stock (Tu lógica existente)
                    if (articulo.StockActual <= 0)
                    {
                        mostrarMensaje($"⚠️ El producto '{articulo.Descripcion}' no tiene stock.", true);
                        return;
                    }

                    // 3. Buscar si ya existe en el carrito
                    var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idArticulo);

                    if (detalle != null)
                    {
                        // Ya existe: Sumamos 1 si hay stock
                        if (detalle.Cantidad + 1 > articulo.StockActual)
                        {
                            mostrarMensaje($"⚠️ Stock insuficiente. Máximo {articulo.StockActual}.", true);
                            return;
                        }
                        detalle.Cantidad++;
                    }
                    else
                    {
                        // No existe: Lo creamos
                        DetalleActual.Add(new DetallePedido
                        {
                            IDArticulo = articulo.IDArticulo,
                            Descripcion = articulo.Descripcion,
                            PrecioUnitario = articulo.PrecioVentaCalculado,
                            Cantidad = 1
                        });
                    }

                    // 4. Guardar en Session y Actualizar Interfaz
                    DetalleActual = DetalleActual; // Setter de sesión
                    ActualizarDetalleYTotales();   // Refresca la grilla de abajo y los montos

                    // Opcional: Feedback visual de éxito
                    // mostrarMensaje($"Se añadió: {articulo.Descripcion}", false);

                    // 5. Limpiar buscador para la siguiente venta (Opcional, estilo POS rápido)
                    txtBuscarProductos.Text = string.Empty;
                    BindProductos(null);

                    // Foco de vuelta al buscador para escanear el siguiente producto rápido
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "FocusProd",
                        $"document.getElementById('{txtBuscarProductos.ClientID}').focus();", true);
                }
            }
        }



        /// METODO DE DETALLES


        // --- GESTIÓN DE GRILLA CARRITO (SUMAR/RESTAR) ---
        protected void gvDetallePedido_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (int.TryParse(e.CommandArgument.ToString(), out int idArticulo))
            {
                // Buscamos el ítem en la lista de sesión
                var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idArticulo);

                if (detalle != null)
                {
                    // Verificamos qué botón se apretó (CommandName viene del ASPX)
                    switch (e.CommandName)
                    {
                        case "Eliminar":
                            // 🗑️ Lógica de Eliminar
                            DetalleActual.Remove(detalle);
                            mostrarMensaje("Producto eliminado del pedido.", false);
                            break;

                        case "Sumar":
                            // ➕ Lógica de Sumar (Validando Stock)
                            ArticuloNegocio negocio = new ArticuloNegocio();
                            Articulo art = negocio.obtenerPorId(idArticulo);

                            if (art != null && detalle.Cantidad + 1 <= art.StockActual)
                            {
                                detalle.Cantidad++;
                            }
                            else
                            {
                                mostrarMensaje($"⚠️ Stock insuficiente. Máximo {art.StockActual} unidades.", true);
                            }
                            break;

                        case "Restar":
                            // ➖ Lógica de Restar
                            if (detalle.Cantidad > 1)
                            {
                                detalle.Cantidad--;
                            }
                            else
                            {
                                // Si la cantidad es 1 y resta, lo eliminamos
                                DetalleActual.Remove(detalle);
                            }
                            break;
                    }

                    // ⭐ IMPORTANTE: Guardar cambios y refrescar la pantalla
                    DetalleActual = DetalleActual; // Actualiza la Session
                    ActualizarDetalleYTotales();   // Recalcula subtotales y repinta la grilla
                }
            }
        }

        protected void gvDetallePedido_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Solo actuamos si estamos en MODO VER y es una fila de datos
            if (EsModoVer && e.Row.RowType == DataControlRowType.DataRow)
            {
                // 1. Ocultar botón RESTAR (-)
                LinkButton btnRestar = (LinkButton)e.Row.FindControl("btnDecreaseQty");
                if (btnRestar != null) btnRestar.Visible = false;

                // 2. Ocultar botón SUMAR (+)
                LinkButton btnSumar = (LinkButton)e.Row.FindControl("btnIncreaseQty");
                if (btnSumar != null) btnSumar.Visible = false;

                // 3. Estilizar el TextBox de cantidad para que parezca texto normal
                TextBox txtCantidad = (TextBox)e.Row.FindControl("txtQuantity");
                if (txtCantidad != null)
                {
                    txtCantidad.BorderStyle = BorderStyle.None; // Sin bordes
                    txtCantidad.BackColor = System.Drawing.Color.Transparent; // Fondo transparente
                    txtCantidad.ReadOnly = true;
                    // Opcional: Centrarlo visualmente
                    txtCantidad.Style.Add("text-align", "center");
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
                Cliente cliente = cliNegocio.listar(pedido.IDCliente);

                if (cliente != null)
                {
                    txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                    txtClientAddress.Text = cliente.Direccion;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = cliente.Dni;
                    txtClientPhone.Text = cliente.Telefono;
                    txtClientEmail.Text = cliente.Email;
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

        /// METODOS
        /// 

        private void ConfigurarVistaSoloLectura()
        {
      
            columnaBusqueda.Visible = false;
            columnaDetalle.Attributes["class"] = "md:col-span-12 grid grid-cols-1 gap-6";
            txtBuscarProductos.Enabled = false;
            upProductos.Visible = false;
            btnFinalizarVenta.Visible = false;
            gvDetallePedido.Enabled = false;

            // Ocultar la columna de "Eliminar" en la grilla de detalles
            if (gvDetallePedido.Columns.Count > 0)
            {
                int ultimaColumna = gvDetallePedido.Columns.Count - 1;
                gvDetallePedido.Columns[ultimaColumna].Visible = false;
            }
        }
    }
}