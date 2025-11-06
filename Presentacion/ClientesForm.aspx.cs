using Dominio.Usuario_Persona;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class ClientesForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Verificamos si hay un 'id' en la URL
                if (Request.QueryString["id"] != null)
                {
                    // --- MODO EDICIÓN ---
                    int id = int.Parse(Request.QueryString["id"]);

                    ClienteNegocio negocio = new ClienteNegocio();
                    Cliente seleccionado = negocio.listar(id);

                    // Esta lógica SÍ debe estar dentro del !IsPostBack
                    if (seleccionado != null) // Buena práctica: chequear que exista
                    {
                        txtNombre.Text = seleccionado.Nombre;
                        txtApellido.Text = seleccionado.Apellido;
                        txtDni.Text = seleccionado.Dni;
                        txtTelefono.Text = seleccionado.Telefono;
                        txtEmail.Text = seleccionado.Email;
                        txtDireccion.Text = seleccionado.Direccion;
                        txtAltura.Text = seleccionado.Altura;
                        txtLocalidad.Text = seleccionado.Localidad;
                        

                        // lblTitulo.Text = "Modificar Cliente";
                    }
                }
                else
                {
                    // --- MODO NUEVO ---
                    // lblTitulo.Text = "Nuevo Cliente";
                }
            }

        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ClienteNegocio negocio = new ClienteNegocio();
                Cliente cliente = new Cliente();

                // Cargamos el objeto cliente con los datos del formulario
                cliente.Nombre = txtNombre.Text;
                cliente.Apellido = txtApellido.Text;
                cliente.Dni = txtDni.Text;
                cliente.Telefono = txtTelefono.Text;
                cliente.Email = txtEmail.Text;
                cliente.Direccion = txtDireccion.Text;
                cliente.Altura = txtAltura.Text;
                cliente.Localidad = txtLocalidad.Text;

                // Comprobamos si estamos en modo Edición o Nuevo
                if (Request.QueryString["id"] != null)
                {
                    // --- MODO EDICIÓN ---
                    cliente.IDCliente = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(cliente); // Llamamos al nuevo método
                }
                else
                {
                    // --- MODO NUEVO ---
                    negocio.agregar(cliente); // Llamamos al método que ya tenías
                }

                // Redirigimos de vuelta al listado
                Response.Redirect("ClientesListado.aspx");
            }
            catch (Exception ex)
            {
                // Manejar el error (por ejemplo, mostrar un mensaje)
                // Session["error"] = ex.Message;
                // Response.Redirect("Error.aspx");
            }
        }
    }
}