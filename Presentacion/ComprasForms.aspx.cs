using Dominio.Articulos;   // Para Articulo
using Dominio.Compras;     // Asegúrate que aquí esté tu clase Compra y CompraDetalle
using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ComprasForms : System.Web.UI.Page
    {
        public bool EsModoVer { get; set; } = false;

        public List<DetalleCompra> ListaCompraActual
         {
             get
             {
                 if (Session["ListaCompraActual"] == null)
                     Session["ListaCompraActual"] = new List<DetalleCompra>();
                 return (List<DetalleCompra>)Session["ListaCompraActual"];
             }
             set { Session["ListaCompraActual"] = value; }
         }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 1. Cargar listas desplegables SIEMPRE al inicio
                CargarProveedores();
                CargarProductos();

                // 2. Capturar parámetros de la URL
                string idCompraStr = Request.QueryString["id"];
                string modo = Request.QueryString["modo"];

                // 3. Determinar si es modo Lectura
                if (modo == "Ver")
                {
                    EsModoVer = true;
                }

                // 4. Decidir: ¿Cargamos compra existente o preparamos una nueva?
                if (!string.IsNullOrEmpty(idCompraStr) && int.TryParse(idCompraStr, out int idCompra))
                {

                    ViewState["CompraID"] = idCompra;
                    CargarDatosCompra(idCompra);

                    if (EsModoVer)
                    {
                        ConfigurarVistaSoloLectura();
                  
                    }
                    else
                    {
                        btnGuardarCompra.Text = "Guardar Cambios"; 
                    }
                }
                else
                {
                   
                    LimpiarFormulario();
                }
            }
        }

        private void CargarProveedores()
        {
            try
            {
                ProveedorNegocio negocio = new ProveedorNegocio();
                List<Proveedor> lista = negocio.listar();
                ddlProveedor.DataSource = lista;
                ddlProveedor.DataValueField = "ID"; 
                ddlProveedor.DataTextField = "RazonSocial";
                ddlProveedor.DataBind();
                ddlProveedor.Items.Insert(0, new ListItem("Seleccione...", "0"));
            }
            catch (Exception ex) {  }
        }

        private void CargarProductos()
        {
            try
            {
                ArticuloNegocio negocio = new ArticuloNegocio();
                List<Articulo> lista = negocio.listar();
                ddlProductoItem.DataSource = lista;
                ddlProductoItem.DataValueField = "IDArticulo";
                ddlProductoItem.DataTextField = "Descripcion";
                ddlProductoItem.DataBind();
                ddlProductoItem.Items.Insert(0, new ListItem("Seleccione...", "0"));
            }
            catch (Exception ex) {  }
        }


      
        protected void btnGuardarCompra_Click(object sender, EventArgs e)
        {
            try
            {
                Compra nuevaCompra = new Compra();


                nuevaCompra.IDProveedor = int.Parse(ddlProveedor.SelectedValue);
                nuevaCompra.FechaCompra = DateTime.Parse(txtFechaCompra.Text);
                nuevaCompra.Documento = txtFacturaRef.Text.Trim();
                nuevaCompra.Observaciones = txtObservaciones.Text;
                nuevaCompra.UsuarioCreador = "Admin";
                nuevaCompra.EstadoCompra = Compra.Estado.Pendiente;
                nuevaCompra.Detalles = ListaCompraActual;

                if (ListaCompraActual.Count > 0)
                {
                    nuevaCompra.MontoTotal = ListaCompraActual.Sum(x => x.Cantidad * x.PrecioUnitario);
                }
                else
                {
                    nuevaCompra.MontoTotal = 0;
                }


                ComprasNegocio negocio = new ComprasNegocio();
                string idStr = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idStr) && int.TryParse(idStr, out int idCompra))
                {
                    nuevaCompra.IDCompra = (int)ViewState["CompraID"];
             
                    nuevaCompra.UsuarioCreador = "Admin";

                    negocio.Modificar(nuevaCompra);
                }
                else
                {
                    // --- MODO AGREGAR (NUEVO) ---
                    nuevaCompra.UsuarioCreador = "Admin";
                    negocio.Agregar(nuevaCompra);
                }


                LimpiarFormulario();
            }
            catch (Exception ex)
            {
            
            }
           Response.Redirect("ComprasListado.aspx", false);
        }

        protected void btnAnadirProducto_Click(object sender, EventArgs e)
        {
            try
            {

                int idArticulo = int.Parse(ddlProductoItem.SelectedValue);

                DetalleCompra detalle = new DetalleCompra();
                detalle.IDArticulo = idArticulo;
                detalle.NombreProducto = ddlProductoItem.SelectedItem.Text;
                detalle.Cantidad = int.Parse(txtCantidad.Text);
                detalle.PrecioUnitario = decimal.Parse(txtCosto.Text);

                detalle.IDDetalle = new Random().Next(1, 100000);

                List<DetalleCompra> temporal = ListaCompraActual;

                var productoExistente = temporal.Find(x => x.IDArticulo == idArticulo);

                if (productoExistente != null)
                {
                    productoExistente.Cantidad += int.Parse(txtCantidad.Text);

                }
                else
                {

                    temporal.Add(detalle);
                }

                ListaCompraActual = temporal;
                ActualizarGrillaYTotales();

                gvDetalleCompra.DataSource = ListaCompraActual;
                gvDetalleCompra.DataBind();

       
                txtCantidad.Text = "";
                txtCosto.Text = "";
                ddlProductoItem.SelectedIndex = 0;
                ddlProductoItem.Focus();
            }
            catch (Exception ex)
            {

                Response.Write("<script>alert('OCURRIÓ UN ERROR: " + ex.Message + "');</script>");
            }
        }

        protected void gvDetalleCompra_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {

                int idDetalleTemp = Convert.ToInt32(e.CommandArgument);
                List<DetalleCompra> temporal = ListaCompraActual;


                var itemAEliminar = temporal.Find(x => x.IDDetalle == idDetalleTemp);
                if (itemAEliminar != null)
                {
                    temporal.Remove(itemAEliminar);
                    ListaCompraActual = temporal;

                    // Refrescamos
                    ActualizarGrillaYTotales();
                }
            }
        }

        private void ActualizarGrillaYTotales()
        {
            // 1. Llenar la grilla
            gvDetalleCompra.DataSource = ListaCompraActual;
            gvDetalleCompra.DataBind();

            // 2. Calcular Totales
            decimal total = ListaCompraActual.Sum(x => x.Subtotal);

          
            lblSubtotal.Text = total.ToString("C"); 
            lblTotalPagar.Text = total.ToString("C");
        }

       

        private void LimpiarFormulario()
        {
            ddlProveedor.SelectedIndex = 0;
            txtFacturaRef.Text = "";
            txtObservaciones.Text = "";
            txtFechaCompra.Text = DateTime.Now.ToString("yyyy-MM-dd");

            // Limpiar lista de productos y grilla
            Session["ListaCompraActual"] = null;
            gvDetalleCompra.DataSource = null;
            gvDetalleCompra.DataBind();
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Redirige a la lista de compras o al inicio
            Response.Redirect("ComprasListado.aspx");
        }


        private void CargarDatosCompra(int id)
        {
            try
            {
                ComprasNegocio negocio = new ComprasNegocio();
                Compra compraEntidad = negocio.ObtenerPorID(id);

                if (compraEntidad != null)
                {
              
                    try { ddlProveedor.SelectedValue = compraEntidad.IDProveedor.ToString(); } catch { }

                    txtFechaCompra.Text = compraEntidad.FechaCompra.ToString("yyyy-MM-dd");
                    txtFacturaRef.Text = compraEntidad.Documento;
                    txtObservaciones.Text = compraEntidad.Observaciones;

                    // 2. Cargar Detalles en Sesión y Grilla
                    // IMPORTANTE: Asignamos la lista de la BD a la Session para que el Grid la vea
                    ListaCompraActual = compraEntidad.Detalles;

                    // 3. Refrescar Grilla
                    gvDetalleCompra.DataSource = ListaCompraActual;
                    gvDetalleCompra.DataBind();

                    // 4. Actualizar Totales Visuales
                    ActualizarGrillaYTotales();
                }
            }
            catch (Exception ex)
            {
                // Manejo de error si falla la carga
                Response.Write("<script>alert('Error al cargar la compra: " + ex.Message + "');</script>");
            }
        }

        private void ConfigurarVistaSoloLectura()
        {
         
            ddlProveedor.Enabled = false;
            txtFechaCompra.Enabled = false;
            txtFacturaRef.Enabled = false;
            txtObservaciones.Enabled = false;

        
            ddlProductoItem.Enabled = false;
            txtCantidad.Enabled = false;
            txtCosto.Enabled = false;
            btnAnadirProducto.Visible = false;

          
            btnGuardarCompra.Visible = false;
            btnCancelar.Text = "Volver"; 

            if (gvDetalleCompra.Columns.Count > 0)
            {
                // Opción A: Ocultar toda la columna de acciones
                gvDetalleCompra.Columns[4].Visible = false;
            }
            else
            {
              
                foreach (GridViewRow row in gvDetalleCompra.Rows)
                {
                    var btnEliminar = row.FindControl("btnEliminarProducto");
                    if (btnEliminar != null) btnEliminar.Visible = false;
                }
            }
        }
    }
}