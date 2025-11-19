using Dominio.Articulos;
using Negocio;
using System;
using System.Web.UI;

namespace Presentacion
{
    public partial class MarcasForm : System.Web.UI.Page
    {
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                if (EsModoEdicion)
                {
                    cargarDatos(int.Parse(Request.QueryString["id"]));
                }
            }
        }

        private void cargarDatos(int id)
        {
            MarcaNegocio negocio = new MarcaNegocio();
            try
            {
                Marca marca = negocio.obtenerPorId(id); // Asegurate que este método exista en tu Negocio
                if (marca != null)
                {
                    txtId.Text = marca.IDMarca.ToString();
                    txtDescripcion.Text = marca.Descripcion;
                }
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error al cargar: " + ex.Message, true);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // 1. Verificar Barrera 1 (Frontend)
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                MarcaNegocio negocio = new MarcaNegocio();
                Marca marca = new Marca();
                marca.Descripcion = txtDescripcion.Text;

                if (EsModoEdicion)
                {
                    marca.IDMarca = int.Parse(txtId.Text);
                    negocio.modificar(marca); // Aquí puede saltar la excepción de "Duplicado"
                    Session["msg"] = "Marca modificada exitosamente.";
                }
                else
                {
                    negocio.agregar(marca); // O aquí
                    Session["msg"] = "Marca agregada exitosamente.";
                }

                Response.Redirect("MarcasListado.aspx", false);
            }
            catch (Exception ex)
            {
                // Si salta la Barrera 2 (Nombre duplicado), cae acá.
                mostrarMensaje("⚠️ " + ex.Message, true);
            }
        }

        private void mostrarMensaje(string mensaje, bool esError)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.Visible = true;
            if (esError)
                lblMensaje.CssClass = "block bg-red-100 text-red-700 border border-red-400 p-3 rounded font-bold";
            else
                lblMensaje.CssClass = "block bg-green-100 text-green-700 border border-green-400 p-3 rounded font-bold";
        }
    }
}