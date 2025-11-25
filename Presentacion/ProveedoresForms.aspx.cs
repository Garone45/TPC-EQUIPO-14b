using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Web.UI;

namespace Presentacion
{
    public partial class ProveedoresForms : System.Web.UI.Page
    {
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                if (EsModoEdicion)
                {
                    lblTitulo.Text = "Modificar Proveedor";
                    int id;
                    if (int.TryParse(Request.QueryString["id"], out id))
                    {
                        cargarDatos(id);
                    }
                }
            }
        }

        private void cargarDatos(int id)
        {
            try
            {
                ProveedorNegocio negocio = new ProveedorNegocio();
                Proveedor seleccionado = negocio.obtenerPorId(id);

                if (seleccionado != null)
                {
                    txtRazonSocial.Text = seleccionado.RazonSocial;
                    txtCUIT.Text = seleccionado.Cuit;
                    txtSeudonimo.Text = seleccionado.Seudonimo;
                    txtTelefono.Text = seleccionado.Telefono;
                    txtEmail.Text = seleccionado.Email;
                    txtDireccion.Text = seleccionado.Direccion;
                }
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error al cargar datos: " + ex.Message, true);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // VALIDACIÓN DE SERVIDOR: Si falta algo, no avanza
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                ProveedorNegocio negocio = new ProveedorNegocio();
                Proveedor proveedor = new Proveedor();

                // Llenamos el objeto
                proveedor.RazonSocial = txtRazonSocial.Text;
                proveedor.Cuit = txtCUIT.Text;
                proveedor.Seudonimo = txtSeudonimo.Text;
                proveedor.Telefono = txtTelefono.Text;
                proveedor.Email = txtEmail.Text;
                proveedor.Direccion = txtDireccion.Text;
                proveedor.Activo = true;

                if (EsModoEdicion)
                {
                    proveedor.ID = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(proveedor);
                    Session["msg"] = "Proveedor modificado correctamente";
                }
                else
                {
                    negocio.agregar(proveedor);
                    Session["msg"] = "Proveedor agregado correctamente";
                }

                Response.Redirect("ProveedoresListados.aspx", false);
            }
            catch (Exception ex)
            {
                // Manejo de errores de BD (ej: CUIT duplicado)
                string msg = ex.Message;
                if (ex.Message.Contains("UNIQUE") || ex.Message.Contains("CUIT"))
                    msg = "El CUIT ingresado ya existe en el sistema.";

                mostrarMensaje("⚠️ Error: " + msg, true);
            }
        }

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
        }
    }
}