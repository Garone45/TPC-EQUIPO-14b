using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio.Compras;
using Dominio.Usuario_Persona;
using Negocio;

namespace Presentacion
{
    public partial class ComprasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. VALIDAR LOGIN
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            // 2. VALIDAR PERMISO (Solo ADMIN ve compras)
            Usuario user = (Usuario)Session["usuario"];
            if (user.TipoUsuario != TipoUsuario.ADMIN)
            {
                Session.Add("error", "No tienes permisos para gestionar Compras.");
                Response.Redirect("Default.aspx", false);
                return;
            }

            // 3. CARGA INICIAL
            if (!IsPostBack)
            {
                // Configuramos el estilo del buscador si es necesario
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarCompras();
            }
        }

        // --- PROPIEDAD PARA MANTENER LA LISTA EN MEMORIA (ViewState) ---
        private List<Compra> ListaCompras
        {
            get
            {
                if (ViewState["Compras"] == null)
                    ViewState["Compras"] = new List<Compra>();
                return (List<Compra>)ViewState["Compras"];
            }
            set
            {
                ViewState["Compras"] = value;
            }
        }

        // --- MÉTODO CENTRAL DE CARGA ---
        private void CargarCompras()
        {
            ComprasNegocio negocio = new ComprasNegocio();
            List<Compra> listaCompras = null;
            string filtroTexto = txtBuscar.Text.Trim();

            try
            {
                if (string.IsNullOrEmpty(filtroTexto))
                {
                    // Si no hay filtro, trae todo (asegurate que exista ListarCompras en Negocio)
                    // Si tu método se llama 'listar', cámbialo aquí.
                    listaCompras = negocio.ListarCompras();
                }
                else
                {
                    // Si hay filtro, usa el método de filtrar
                    listaCompras = negocio.Filtrar(filtroTexto);
                }

                // Guardamos en ViewState y enlazamos
                ListaCompras = listaCompras;
                gvCompras.DataSource = listaCompras;
                gvCompras.DataBind();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                // Response.Redirect("Error.aspx", false); // Opcional
            }
        }

        // --- MANEJO DE ESTILOS (COLORES DE ESTADO) ---
        public string GetEstadoClass(string estado)
        {
            switch (estado)
            {
                case "Entregado":
                case "Aprobada":
                    return "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800";

                case "Pendiente":
                    return "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800";

                case "Cancelado":
                case "Anulada":
                    return "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800";

                default:
                    return "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800";
            }
        }

        // --- EVENTOS DE LA PÁGINA ---

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvCompras.PageIndex = 0;
            CargarCompras();
        }

        protected void gvCompras_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCompras.PageIndex = e.NewPageIndex;
            gvCompras.DataSource = ListaCompras; // Usamos la lista del ViewState
            gvCompras.DataBind();
        }

        protected void gvCompras_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            // Dejamos esto vacío intencionalmente porque ahora usamos el Modal + Botón Oculto
            // pero el evento debe existir para que no falle la compilación del ASPX
        }

        // --- MÉTODO DEL BOTÓN OCULTO (ELIMINACIÓN REAL) ---
        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdCompra.Value))
                {
                    int id = int.Parse(hfIdCompra.Value);

                    ComprasNegocio negocio = new ComprasNegocio();

                    
                    negocio.eliminarLogico(id);

               
                    CargarCompras();

                    // Actualizamos el panel visualmente
                    updCompras.Update();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }
        protected void btnConfirmarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdCompra.Value))
                {
                    int id = int.Parse(hfIdCompra.Value);
                    ComprasNegocio negocio = new ComprasNegocio();

               
                    negocio.ConfirmarEntrega(id);

                
                    CargarCompras();
                    updCompras.Update();
                }
            }
            catch (Exception ex)
            {
          
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }
    }
}