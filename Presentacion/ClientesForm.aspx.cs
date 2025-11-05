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

        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // 1. Creamos el objeto Cliente
                Cliente nuevoCliente = new Cliente();

                // 2. Mapeamos los datos de los TextBox al objeto
                nuevoCliente.Nombre = txtNombre.Text;
                nuevoCliente.Apellido = txtApellido.Text;
                nuevoCliente.Dni = txtDni.Text;
                nuevoCliente.Telefono = txtTelefono.Text;
                nuevoCliente.Email = txtEmail.Text;
                nuevoCliente.Direccion = txtDireccion.Text;

                // 3. Llamamos al método de negocio
                ClienteNegocio negocio = new ClienteNegocio();
                negocio.agregar(nuevoCliente);

                // 4. Redirigimos al listado
                // Podrías usar Session["Mensaje"] para mostrar un aviso de éxito en el listado
                Response.Redirect("ClientesListado.aspx");
            }
            catch (Exception ex)
            {
                // Manejo de errores
                Response.Write($"<script>alert('Error al guardar el cliente: {ex.Message}');</script>");
            }
        }
    }
}