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

                // Carga inicial de productos (si aplica)
                BindProductos(null);

                if (!string.IsNullOrEmpty(idPedidoStr) && int.TryParse(idPedidoStr, out int idPedido))
                {
                    // 1. Cargar la venta existente
                    CargarDatosPedido(idPedido);

           
                   
                    txtBuscarCliente.Enabled = false;
                    txtBuscarCliente.Attributes.Add("placeholder", "Cliente ya asignado");
                    rptClientes.Visible = false;

                    if (EsModoVer)
                    {
                        ConfigurarVistaSoloLectura();
                        mostrarMensaje("Modo Visualización: No se pueden realizar cambios.", false);
                    }
                    else
                    {
                        mostrarMensaje("Modo Edición: Puede modificar productos, pero no el cliente.", false);
                    }
                }
                else
                {
                  
                    Session["DetallePedido"] = null;
                    Session["ClienteSeleccionado"] = null;
                    ViewState["IDPedidoEditar"] = null;


                    BindClientes(null);


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
            string filtro = txtBuscarCliente.Text.Trim();


            if (string.IsNullOrEmpty(filtro) || filtro.Length < 2)
            {
                // Si borra el texto, ocultamos el dropdown
                pnlResultadosClientes.Visible = false;
                pnlSinResultadosClientes.Visible = false;
                rptClientes.DataSource = null;
                rptClientes.DataBind();

            }
            else
            {
                BindClientes(filtro);
            }
            // Importante: Actualizar el UpdatePanel del cliente
            upCliente.Update();
        }

        private void BindClientes(string filtro)
        {
            if (string.IsNullOrEmpty(filtro)) return;

            ClienteNegocio negocio = new ClienteNegocio();
            // Optimización: Usar filtrar directamente en lugar de traer todos y filtrar en memoria si es posible
            List<Cliente> clientes = negocio.listar();

            // Filtrado en memoria (si tu negocio.filtrar no existe, usa esto)
            var listaFiltrada = clientes.Where(c =>
                    c.Nombre.ToLower().Contains(filtro.ToLower()) ||
                    c.Apellido.ToLower().Contains(filtro.ToLower()) ||
                    c.Dni.Contains(filtro)
                ).ToList();

            if (listaFiltrada.Count > 0)
            {
                rptClientes.DataSource = listaFiltrada;
                rptClientes.DataBind();
                pnlResultadosClientes.Visible = true; // Mostrar lista
                pnlSinResultadosClientes.Visible = false;
            }
            else
            {

                rptClientes.DataSource = null;
                rptClientes.DataBind();
                pnlResultadosClientes.Visible = true; // Mostrar panel vacío
                pnlSinResultadosClientes.Visible = true; // Mostrar mensaje "No encontrado"

            }
        }

        protected void rptClientes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Seleccionar")
            {

                int idCliente = Convert.ToInt32(e.CommandArgument);

                Session["ClienteSeleccionado"] = idCliente;

                ClienteNegocio negocio = new ClienteNegocio();
                Cliente cliente = negocio.listar().FirstOrDefault(c => c.IDCliente == idCliente);

                if (cliente != null)
                {
                    // Llenar tarjetas visuales
                    txtClientName.Text = cliente.Nombre + " " + cliente.Apellido;
                    txtClientAddress.Text = cliente.Direccion + " " + cliente.Altura;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = "DNI: " + cliente.Dni; // Agregué prefijo visual
                    txtClientEmail.Text = cliente.Email;
                    txtClientPhone.Text = cliente.Telefono;

                    // mostrarMensaje("Cliente asignado a la venta.", false); // Opcional
                }

                // Limpieza post-selección
                txtBuscarCliente.Text = string.Empty;
                pnlResultadosClientes.Visible = false;
                pnlSinResultadosClientes.Visible = false;

                upCliente.Update();
            }
        }

        private void LimpiarDatosClienteVisual()
        {
            txtClientName.Text = "";
            txtClientAddress.Text = "";
            txtClientCity.Text = "";
            txtClientDNI.Text = "";
            txtClientPhone.Text = "";
            txtClientEmail.Text = "";
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
            string busqueda = txtBuscarProductos.Text.Trim();
            ArticuloNegocio negocio = new ArticuloNegocio();

            if (string.IsNullOrEmpty(busqueda) || busqueda.Length < 2) // Puedes ajustar el mínimo de 2 caracteres
            {
                // 1. Campo vacío o muy corto: Ocultar el dropdown completamente.
                pnlResultadosProductos.Visible = false;
                pnlSinProductos.Visible = false;
                rptProductos.DataSource = null; // Limpiamos el origen de datos por seguridad
                rptProductos.DataBind();
                upProductos.Update();
                return;
            }
            else
            {

                // 2. Buscar productos (asume que esta función devuelve List<Producto>)
                List<Articulo> listaProductos = negocio.filtrar(busqueda);

               
                if (listaProductos != null && listaProductos.Count >= 1)
                {
                    // Hay varios, mostramos la lista para que elija
                    rptProductos.DataSource = listaProductos;
                    rptProductos.DataBind();
                    pnlResultadosProductos.Visible = true;
                    pnlSinProductos.Visible = false;
                    upProductos.Update();
                }
                else
                {
                    // No hay resultados
                    rptProductos.DataSource = null;
                    rptProductos.DataBind();
                    pnlResultadosProductos.Visible = true;
                    pnlSinProductos.Visible = true;
                    upProductos.Update();
                }
            }
            upProductos.Update();
        
            ScriptManager.RegisterStartupScript(this, this.GetType(), "FocusScript",
                $"document.getElementById('{txtBuscarProductos.ClientID}').focus();", true);

        }


        protected void rptProductos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AgregarCarrito")
            {
                int idArticulo = Convert.ToInt32(e.CommandArgument);
                AgregarArticuloAlCarrito(idArticulo);
            }
        }

        private void AgregarArticuloAlCarrito(int idArticulo)
        {
            ArticuloNegocio negocio = new ArticuloNegocio();
            Articulo articulo = negocio.obtenerPorId(idArticulo);

            if (articulo != null)
            {
                // Validar Stock
                if (articulo.StockActual <= 0)
                {
                    
                    return;
                }

                // Buscar si existe en la sesión (Carrito)
                var detalle = DetalleActual.FirstOrDefault(d => d.IDArticulo == idArticulo);

                if (detalle != null)
                {
                    if (detalle.Cantidad + 1 > articulo.StockActual)
                    {
                        
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

               
                DetalleActual = DetalleActual;
                ActualizarDetalleYTotales();

                // Limpieza de buscador
                txtBuscarProductos.Text = string.Empty;
                pnlResultadosProductos.Visible = false;
                pnlSinProductos.Visible = false;

                // Actualizar paneles
                upProductos.Update();

                
                upDetalleVenta.Update(); 

                // Foco de vuelta al buscador (Clave para escaneo continuo)
                ScriptManager.RegisterStartupScript(this, this.GetType(), "FocusProd",
                    $"document.getElementById('{txtBuscarProductos.ClientID}').focus();", true);
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
                           
                            DetalleActual.Remove(detalle);
                            mostrarMensaje("Producto eliminado del pedido.", false);
                            break;

                        case "Sumar":
                          
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
                    txtCantidad.BorderStyle = BorderStyle.None;
                    txtCantidad.BackColor = System.Drawing.Color.Transparent; 
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
            decimal iva = subtotal * 0.21m; 
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

                BindClientes(null);
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
               
                lblMensaje.CssClass = "block w-full p-4 mb-4 text-sm text-red-800 border border-red-300 rounded-lg bg-red-50 dark:bg-gray-800 dark:text-red-400 dark:border-red-800";
            }
            else
            {
              
                lblMensaje.CssClass = "block w-full p-4 mb-4 text-sm text-green-800 border border-green-300 rounded-lg bg-green-50 dark:bg-gray-800 dark:text-green-400 dark:border-green-800";
            }

            // IMPORTANTE: Actualizar el panel para que se vea el mensaje
            updMensajes.Update();
        }
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