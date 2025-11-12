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
    public partial class ProveedoresForm : System.Web.UI.Page
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
           
                    int id = int.Parse(Request.QueryString["id"]);
                    ProveedorNegocio negocio = new ProveedorNegocio();
                    Proveedor seleccionado = negocio.obtenerPorId(id);

                    txtRazonSocial.Text = seleccionado.RazonSocial;
                    txtCUIT.Text = seleccionado.Cuit;
                    txtSeudonimo.Text = seleccionado.Seudonimo;
                    txtTelefono.Text = seleccionado.Telefono;
                    txtEmail.Text = seleccionado.Email;
                    txtDireccion.Text = seleccionado.Direccion;

                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
         
            if (string.IsNullOrWhiteSpace(txtRazonSocial.Text) || string.IsNullOrWhiteSpace(txtCUIT.Text))
            {
                return;
            }

            try
            {
                ProveedorNegocio negocio = new ProveedorNegocio();
                Proveedor proveedor = new Proveedor();

                // 2. Cargamos el objeto con todos los campos
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

           
                Response.Redirect("ProveedoresListados.aspx");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}