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
        private ClienteNegocio negocioCliente = new ClienteNegocio();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gvClientes.Visible = false;
            }
            

        }

        protected void txtBuscarCliente_TextChanged(object sender, EventArgs e)
        {
            string filtro = txtBuscarCliente.Text.Trim();

            if (string.IsNullOrEmpty(filtro))
            {
                gvClientes.Visible = false;
                return;
            }

            try
            {
                // Busca por nombre, apellido o CUIT
                var lista = negocioCliente.listar()
                    .Where(c =>
                        c.Nombre.ToLower().Contains(filtro.ToLower()) ||
                        c.Apellido.ToLower().Contains(filtro.ToLower()) ||
                        c.Dni.ToLower().Contains(filtro.ToLower()) ||
                        c.IDCliente.ToString().Contains(filtro))
                    .Select(c => new
                    {
                        c.IDCliente,
                        NombreCompleto = c.Nombre + " " + c.Apellido,
                        c.Dni
                    })
                    .ToList();

                gvClientes.DataSource = lista;
                gvClientes.DataBind();

                gvClientes.Visible = lista.Any();
            }
            catch (Exception ex)
            {
                // Log o manejo de errores
                gvClientes.Visible = false;
                Console.WriteLine("Error al buscar clientes: " + ex.Message);
            }
        }

        protected void gvClientes_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                GridViewRow fila = gvClientes.SelectedRow;

                string idCliente = fila.Cells[0].Text;
                string nombreCliente = fila.Cells[1].Text;

                // Cargar el cliente seleccionado en el TextBox
                txtBuscarCliente.Text = nombreCliente;

                // Guardarlo en sesión (útil para cuando confirmes la venta)
                Session["ClienteSeleccionado"] = idCliente;

                // Ocultar el grid después de seleccionar
                gvClientes.Visible = false;
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al seleccionar cliente: " + ex.Message);
            }
        }
    }
}