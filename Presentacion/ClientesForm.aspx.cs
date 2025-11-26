using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Web.UI;

namespace Presentacion
{
    public partial class ClientesForm : System.Web.UI.Page
    {
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
         
           
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                if (EsModoEdicion)
                {
                    lblTitulo.Text = "Modificar Cliente";
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
                ClienteNegocio negocio = new ClienteNegocio();
                Cliente cliente = negocio.obtenerPorId(id);

                if (cliente != null)
                {
                    txtNombre.Text = cliente.Nombre;
                    txtApellido.Text = cliente.Apellido;
                    txtDni.Text = cliente.Dni;
                    txtTelefono.Text = cliente.Telefono;
                    txtEmail.Text = cliente.Email;
                    txtDireccion.Text = cliente.Direccion;
                    txtAltura.Text = cliente.Altura;
                    txtLocalidad.Text = cliente.Localidad;
                }
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error al cargar cliente: " + ex.Message, true);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // 1. Validar Frontend
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                ClienteNegocio negocio = new ClienteNegocio();
                Cliente cliente = new Cliente();

                cliente.Nombre = txtNombre.Text;
                cliente.Apellido = txtApellido.Text;
                cliente.Dni = txtDni.Text;
                cliente.Telefono = txtTelefono.Text;
                cliente.Email = txtEmail.Text;
                cliente.Direccion = txtDireccion.Text;
                cliente.Altura = txtAltura.Text;
                cliente.Localidad = txtLocalidad.Text;
                cliente.Activo = true;

                if (EsModoEdicion)
                {
                    cliente.IDCliente = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(cliente);
                    Session["msg"] = "Cliente modificado correctamente";
                }
                else
                {
                    negocio.agregar(cliente);
                    Session["msg"] = "Cliente agregado correctamente";
                }

                Response.Redirect("ClientesListado.aspx", false);
            }
            catch (Exception ex)
            {
                // Aquí atrapamos si el DNI está duplicado
                string msg = ex.Message;
                if (ex.Message.Contains("UNIQUE") || ex.Message.Contains("Dni")) 
                    msg = "El DNI ingresado ya existe en el sistema.";

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