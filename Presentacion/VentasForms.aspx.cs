using Dominio.Articulos;
using Dominio.Usuario_Persona;
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
    public partial class VentasForms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Verificar si estamos editando (Viene un ID en la URL, ej: VentasForms.aspx?id=10)
                string idPedidoStr = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idPedidoStr) && int.TryParse(idPedidoStr, out int idPedido))
                {
                    // --- MODO EDICIÓN ---
                    CargarDatosPedido(idPedido);
                }
                else
                {
                    // --- MODO NUEVA VENTA ---
                    // Limpiamos la sesión para no arrastrar datos viejos
                    Session["DetallePedido"] = null;
                    Session["ClienteSeleccionado"] = null;
                    BindGridClientes(null);
                    ActualizarDetalleYTotales();
                }
            }
        }
        protected void txtBuscarCliente_TextChanged(object sender, EventArgs e)
        {
            string filtro = txtBuscarCliente.Text.Trim();
            BindGridClientes(filtro);
            
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
         
            int selectedId = (int)gvClientes.SelectedDataKey.Value;
            Session["clienteSeleccionado"] = selectedId;
            ClienteNegocio negocio = new ClienteNegocio();

           
            Cliente clienteSeleccionado = negocio.listar(selectedId);

            if (clienteSeleccionado != null)
            {
                txtClientName.Text = clienteSeleccionado.Nombre;
                txtClientAddress.Text = clienteSeleccionado.Direccion;
                txtClientCity.Text = clienteSeleccionado.Localidad;
                txtClientDNI.Text = clienteSeleccionado.Dni;
                txtClientPhone.Text = clienteSeleccionado.Telefono;
            }

            
            txtBuscarCliente.Text = string.Empty;
            BindGridClientes(null);
        }

        private void BindGridClientes(string filtro)
        {
            
            ClienteNegocio negocio = new ClienteNegocio();
            List<Cliente> clientes = negocio.listar(); // 

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

        private List<DetallePedido> DetalleActual
        {
            get
            {
                if (Session["DetallePedido"] == null)
                {
                    Session["DetallePedido"] = new List<DetallePedido>();
                }
                return (List<DetallePedido>)Session["DetallePedido"];
            }
            set
            {
                Session["DetallePedido"] = value;
            }
        }

        protected void txtBuscarProductos_TextChanged(object sender, EventArgs e)
        {
            // 1. Lógica para buscar productos en la base de datos
            string BuscarText = txtBuscarProductos.Text.Trim();
            List<Articulo> resultados = new List<Articulo>();
            ArticuloNegocio negocio = new ArticuloNegocio();

            if (!string.IsNullOrEmpty(BuscarText))
            {
             
                List<Articulo> articulosEncontrados = negocio.filtrar(BuscarText);
                resultados = articulosEncontrados;

            }

            gvProductos.DataSource = resultados;
            gvProductos.DataBind();
            upProductos.Update(); // Actualiza el UpdatePanel para mostrar los resultados
        }

        protected void gvProductos_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvProductos.SelectedDataKey != null)
            {
                int idArticulo = Convert.ToInt32(gvProductos.SelectedDataKey.Value);

                // 1. Busca el Artículo completo (idealmente en la DB, o si la lista 'resultados' está disponible, búscala allí)
                // Usaremos una búsqueda directa por ID a la base de datos para asegurar el artículo más reciente.
                ArticuloNegocio negocio = new ArticuloNegocio();
                Articulo articuloSeleccionado = negocio.obtenerPorId(idArticulo); // Necesitas una función obtenerPorId()

                if (articuloSeleccionado != null)
                {
                    // 2. Calcula el precio de venta final.
                    decimal precioVenta = articuloSeleccionado.PrecioVentaCalculado; // Si usas la propiedad calculada
                                                                            // O: decimal precioVenta = articuloSeleccionado.PrecioCostoActual * (1 + articuloSeleccionado.PorcentajeGanancia / 100m);

                    // 3. Agregar o incrementar cantidad en el detalle de la venta
                    AgregarProductoAlDetalle(
                        articuloSeleccionado.IDArticulo,
                        articuloSeleccionado.Descripcion,
                        articuloSeleccionado.CodigoArticulo,
                        precioVenta, // Usa el precio de venta
                        1
                    );

                    // 4. Limpiar la búsqueda y GridView de resultados de productos
                    txtBuscarProductos.Text = string.Empty;
                    gvProductos.DataSource = null; // Limpia el GridView
                    gvProductos.DataBind();

                    // 5. Actualizar ambos UpdatePanels
                    ActualizarDetalleYTotales();
                    upProductos.Update(); // Para limpiar el GridView
                }
            }
        }

        protected void btnAddProduct_Click(object sender, EventArgs e)
        {
            string BuscarText = txtBuscarProductos.Text.Trim();
            ArticuloNegocio negocio = new ArticuloNegocio();

            if (string.IsNullOrWhiteSpace(BuscarText)) return;

            // 1. Llama a tu función de filtro.
            // Esto buscará artículos cuya ID o Descripción contengan el texto ingresado.
            List<Articulo> articulosEncontrados = negocio.filtrar(BuscarText);

            Articulo articuloSeleccionado = null;

            // 2. Intentamos determinar si se buscó por ID exacto.
            if (int.TryParse(BuscarText, out int idIngresado))
            {
                // El usuario ingresó un número. Buscamos el match EXACTO por ID.
                articuloSeleccionado = articulosEncontrados
                    .FirstOrDefault(a => a.IDArticulo == idIngresado);
            }

            // 3. Si no encontramos un match por ID exacto, y solo hay un resultado (es la mejor opción)
            if (articuloSeleccionado == null && articulosEncontrados.Count == 1)
            {
                articuloSeleccionado = articulosEncontrados.First();
            }

            if (articuloSeleccionado != null)
            {
                // 4. Cálculo y agregación 
                decimal precioVenta = articuloSeleccionado.PrecioCostoActual * (1 + articuloSeleccionado.PorcentajeGanancia / 100m);

                AgregarProductoAlDetalle(
                    articuloSeleccionado.IDArticulo,
                    articuloSeleccionado.Descripcion,
                    articuloSeleccionado.CodigoArticulo,
                    precioVenta,
                    1
                );

                // 5. Limpieza y Actualización
                txtBuscarProductos.Text = string.Empty;
                gvProductos.DataSource = null;
                gvProductos.DataBind();

                ActualizarDetalleYTotales();
                upProductos.Update();
            }
            else if (articulosEncontrados.Count > 1)
            {
                // Si hay varios resultados, se muestran en el GridView
                // Aquí no hace nada y deja que el usuario haga clic en el GridView
            }
            // Si no se encontró nada, se podría mostrar un m
        }

        private void AgregarProductoAlDetalle(int id, string nombre, string codigo, decimal precio, int cantidad)
        {
            var detalleExistente = DetalleActual.FirstOrDefault(d => d.IDArticulo == id);

            if (detalleExistente != null)
            {
                detalleExistente.Cantidad += cantidad;
            }
            else
            {
                DetalleActual.Add(new DetallePedido
                {
                    IDArticulo = id,
                    Descripcion = nombre,
                    PrecioUnitario = precio,
                    Cantidad = cantidad
                });
            }
        }
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

        private void ActualizarDetalleYTotales()
        {
            gvDetallePedido.DataSource = DetalleActual;
            gvDetallePedido.DataBind();

            decimal subtotal = DetalleActual.Sum(d => d.TotalParcial);
            const decimal TasaIVA = 0.21m; // 16%
            decimal iva = subtotal * TasaIVA;
            decimal totalFinal = subtotal + iva;

            lblSubtotal.Text = subtotal.ToString("C");
            lblIVA.Text = iva.ToString("C");
            lblTotalFinal.Text = totalFinal.ToString("C");

            upDetalleVenta.Update(); // Actualiza el UpdatePanel de los totales y el detalle
        }


        protected void btnFinalizarVenta_Click(object sender, EventArgs e)
        {
            try
            {
                // --- 1. VALIDACIONES --- (IGUAL QUE ANTES)
                if (Session["ClienteSeleccionado"] == null)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('ERROR: Debe seleccionar un cliente antes de finalizar la venta.');", true);
                    return;
                }

                if (DetalleActual == null || DetalleActual.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('ERROR: Debe agregar productos al pedido.');", true);
                    return;
                }

                // --- 2. CÁLCULOS ECONÓMICOS --- (IGUAL QUE ANTES)
                decimal subtotal = DetalleActual.Sum(d => d.TotalParcial);
                decimal porcentajeIVA = 0.21m;
                decimal descuentoAplicado = 0.00m;
                decimal subtotalConDescuento = subtotal - descuentoAplicado;
                decimal iva = subtotalConDescuento * porcentajeIVA;
                decimal totalFinal = subtotalConDescuento + iva;

                // --- 3. ARMAR EL OBJETO PEDIDO ---
                Pedido nuevoPedido = new Pedido();

                // 🟢 CAMBIO 1: DETECTAR SI ES EDICIÓN
                // Si tenemos un ID guardado en ViewState (desde el Page_Load), se lo asignamos.
                if (ViewState["IDPedidoEditar"] != null)
                {
                    nuevoPedido.IDPedido = Convert.ToInt32(ViewState["IDPedidoEditar"]);
                }
                // Si no hay nada, IDPedido queda en 0 (por defecto), lo que significa "Nuevo".

                nuevoPedido.IDCliente = (int)Session["ClienteSeleccionado"];
                nuevoPedido.IDVendedor = 1;
                nuevoPedido.FechaCreacion = DateTime.Now; // Ojo: Al editar, quizás quieras mantener la fecha original. 
                nuevoPedido.FechaEntrega = DateTime.Now.AddDays(7);

                nuevoPedido.Subtotal = subtotal;
                nuevoPedido.Descuento = descuentoAplicado;
                nuevoPedido.Total = totalFinal;

                nuevoPedido.MetodoPago = "Efectivo";
                nuevoPedido.Estado = Pedido.EstadoPedido.Pendiente;
                nuevoPedido.Detalles = DetalleActual;


                // --- 4. LLAMAR AL NEGOCIO ---
                VentasNegocio negocio = new VentasNegocio();

                // 🟢 CAMBIO 2: DECIDIR SI AGREGAR O MODIFICAR
                if (nuevoPedido.IDPedido != 0)
                {
                    // Si tiene ID, es una modificación
                    negocio.Modificar(nuevoPedido);
                }
                else
                {
                    // Si el ID es 0, es nuevo
                    negocio.Agregar(nuevoPedido);
                }

                // --- 5. LIMPIEZA Y ÉXITO --- (IGUAL QUE ANTES)
                Session["DetallePedido"] = null;
                Session["ClienteSeleccionado"] = null;
                ViewState["IDPedidoEditar"] = null; // 🟢 Limpiamos también el ID de edición

                ActualizarDetalleYTotales();

                Response.Redirect("VentasListado.aspx", false);
                Context.ApplicationInstance.CompleteRequest();

            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "error", $"alert('ERROR CRÍTICO: {ex.Message}');", true);
            }
        }

        private void CargarDatosPedido(int idPedido)
        {
            VentasNegocio negocio = new VentasNegocio();
            Pedido pedido = negocio.ObtenerPorId(idPedido);

            if (pedido != null)
            {
                // A. Guardamos el ID que estamos editando en ViewState para saberlo al guardar
                ViewState["IDPedidoEditar"] = pedido.IDPedido;

                // B. Cargar Cliente (Usamos tu lógica existente de ClienteNegocio)
                Session["ClienteSeleccionado"] = pedido.IDCliente;
                ClienteNegocio clienteNegocio = new ClienteNegocio();
                Cliente cliente = clienteNegocio.listar(pedido.IDCliente);

                if (cliente != null)
                {
                    txtClientName.Text = cliente.Nombre;
                    txtClientAddress.Text = cliente.Direccion;
                    txtClientCity.Text = cliente.Localidad;
                    txtClientDNI.Text = cliente.Dni;
                    txtClientPhone.Text = cliente.Telefono;

                    // Opcional: Ocultar panel de búsqueda de clientes si ya está cargado
                }

                // C. Cargar Detalles en Session
                Session["DetallePedido"] = pedido.Detalles;

                // D. Refrescar Pantalla
                BindGridClientes(null);
                ActualizarDetalleYTotales();
            }
        }

    }
}