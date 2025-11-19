using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ProveedoresForms : System.Web.UI.Page // Asegurate que coincida el nombre de la clase
    {
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Verificamos si la URL trae un ID
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                if (EsModoEdicion)
                {
                    // Cambiamos título si es edición
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
            // 1. VALIDACIÓN DEL SERVIDOR
            // Esto verifica que se cumplan los RequiredFieldValidator y RegularExpressionValidator
            Page.Validate();
            if (!Page.IsValid)
                return;

            try
            {
                ProveedorNegocio negocio = new ProveedorNegocio();
                Proveedor proveedor = new Proveedor();

                // 2. Cargamos el objeto
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

                // Redirigimos solo si todo salió bien
                Response.Redirect("ProveedoresListados.aspx", false);
            }
            catch (Exception ex)
            {
                // Si hay un error (ej: CUIT duplicado en BD), lo mostramos aquí
                mostrarMensaje("⚠️ Error: " + ex.Message, true);
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