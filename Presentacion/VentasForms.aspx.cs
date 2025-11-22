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
                
                BindGridClientes(null);
                ActualizarDetalleYTotales();
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
            const decimal TasaIVA = 0.16m; // 16%
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
                // --- 1. VALIDACIONES ---

                // 1.1 Validar que se haya seleccionado un cliente
                if (Session["ClienteSeleccionado"] == null)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('ERROR: Debe seleccionar un cliente antes de finalizar la venta.');", true);
                    return;
                }

                // 1.2 Validar que el carrito no esté vacío
                // (Asume que DetalleActual es tu propiedad que lee la Session["DetallePedido"])
                if (DetalleActual == null || DetalleActual.Count == 0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('ERROR: Debe agregar productos al pedido.');", true);
                    return;
                }

                // --- 2. CÁLCULOS ECONÓMICOS ---

                decimal subtotal = DetalleActual.Sum(d => d.TotalParcial);

                // Ajusta estos valores según tu lógica comercial y tu UI
                decimal porcentajeIVA = 0.21m;
                decimal descuentoAplicado = 0.00m; // Monto o porcentaje de descuento (Aquí es 0 para empezar)

                // 2.1 Aplicar Descuento
                // NOTA: Si el descuento es en porcentaje, usa: subtotal * (descuentoAplicado / 100)
                // Aquí asumimos que descuentoAplicado es un monto fijo.
                decimal subtotalConDescuento = subtotal - descuentoAplicado;

                // 2.2 Calcular IVA
                decimal iva = subtotalConDescuento * porcentajeIVA;

                // 2.3 Total Final (el que se guarda en la cabecera Pedidos.Total)
                decimal totalFinal = subtotalConDescuento + iva;


                // --- 3. ARMAR EL OBJETO PEDIDO ---
                Pedido nuevoPedido = new Pedido();

                // 3.1 Mapeo de Identificadores y Fechas
                nuevoPedido.IDCliente = (int)Session["ClienteSeleccionado"];

                // **IMPORTANTE**: Reemplaza este '1' por el ID del usuario LOGUEADO (el vendedor)
                // Ejemplo: nuevoPedido.IDVendedor = ((Dominio.Usuario_Persona.Usuario)Session["usuario"]).IDVendedor;
                nuevoPedido.IDVendedor = 1;

                nuevoPedido.FechaCreacion = DateTime.Now;
                nuevoPedido.FechaEntrega = DateTime.Now.AddDays(7); // Asumimos 7 días para la entrega

                // 3.2 Mapeo de Montos
                nuevoPedido.Subtotal = subtotal; // Subtotal sin descuento (aunque no se guarde en SQL, el objeto lo tiene)
                nuevoPedido.Descuento = descuentoAplicado;
                nuevoPedido.Total = totalFinal;

                // 3.3 Mapeo de Estatus y Detalles
                nuevoPedido.MetodoPago = "Efectivo"; // Reemplazar con DropDownList si lo tienes (ej: ddlMetodoPago.SelectedValue)
                nuevoPedido.Estado = Pedido.EstadoPedido.Pendiente;
                nuevoPedido.Detalles = DetalleActual; // La lista de la Session


                // --- 4. LLAMAR AL NEGOCIO ---
                VentasNegocio negocio = new VentasNegocio();
                negocio.Agregar(nuevoPedido);


                // --- 5. LIMPIEZA Y ÉXITO ---
                // Vaciar la Session y ViewState
                Session["DetallePedido"] = null;
                Session["ClienteSeleccionado"] = null;

                // Limpiar controles visuales (Textboxes de cliente y totales)
                // Llama a una función para limpiar el detalle y poner totales en 0
                ActualizarDetalleYTotales();

                Response.Redirect("VentasListado.aspx", false);
                Context.ApplicationInstance.CompleteRequest();

            }
            catch (Exception ex)
            {
                // Mostrar el error de la base de datos o de la lógica
                ScriptManager.RegisterStartupScript(this, this.GetType(), "error", $"alert('ERROR CRÍTICO AL GUARDAR: {ex.Message}');", true);
            }
        }
    }
}