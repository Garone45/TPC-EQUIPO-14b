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
         
            int selectedId = (int)gvClientes.SelectedDataKey.Value;

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

    }
}