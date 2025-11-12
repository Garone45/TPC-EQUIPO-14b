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
    public partial class VentasForms : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // La primera vez que carga la página, mostramos todos los clientes
                BindGridClientes(null);
            }
        }
        protected void txtBuscarCliente_TextChanged(object sender, EventArgs e)
        {
            string filtro = txtBuscarCliente.Text.Trim();
            BindGridClientes(filtro);
            
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            // 1. Obtenemos el ID del cliente seleccionado
            // (DataKeyNames="ID" que definimos en el GridView es crucial aquí)
            int selectedId = (int)gvClientes.SelectedDataKey.Value;

            // 2. Buscamos el cliente completo usando tu capa de negocio
            ClienteNegocio negocio = new ClienteNegocio();

            // Asumo que tienes un método para buscar por ID.
            // Si tu método de "buscarCliente" puede recibir un ID, úsalo.
            // Por ejemplo: Cliente clienteSeleccionado = negocio.buscarCliente(selectedId);
            // O si tienes uno específico:
            Cliente clienteSeleccionado = negocio.listar(selectedId); // <-- ¡CAMBIADO!

            // 3. ¡PRECARGAMOS LOS DATOS! (Esta es la magia)
            if (clienteSeleccionado != null)
            {
                txtClientName.Text = clienteSeleccionado.Nombre;
                txtClientAddress.Text = clienteSeleccionado.Direccion;
                txtClientCity.Text = clienteSeleccionado.Localidad;
                txtClientDNI.Text = clienteSeleccionado.Dni;
                txtClientPhone.Text = clienteSeleccionado.Telefono;
            }

            // 4. Limpiamos la búsqueda y el grid para que no molesten
            txtBuscarCliente.Text = string.Empty;
            BindGridClientes(null);
        }

        private void BindGridClientes(string filtro)
        {
            // 1. Obtenemos TODOS los clientes de tu capa de negocio
            ClienteNegocio negocio = new ClienteNegocio();
            List<Cliente> clientes = negocio.listar(); // 

            if (!string.IsNullOrEmpty(filtro))
            {
                // Filtramos la lista si hay un texto de búsqueda
                // (Compara en minúsculas para que no sea sensible)
                clientes = clientes.Where(c =>
                    c.Nombre.ToLower().Contains(filtro.ToLower()) ||
                    c.Dni.Contains(filtro)
                ).ToList();
            }

            gvClientes.DataSource = clientes;
            gvClientes.DataBind();
        }

    }
}