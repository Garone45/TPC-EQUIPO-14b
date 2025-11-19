using Dominio.Articulos;
using Negocio;
using System;
using System.Web.UI;

namespace Presentacion
{
    public partial class CategoriasForm : System.Web.UI.Page
    {
        public bool EsModoEdicion { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            EsModoEdicion = Request.QueryString["id"] != null;

            if (!IsPostBack)
            {
                if (EsModoEdicion)
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    cargarDatos(id);
                    divId.Visible = true; // Mostramos el ID solo si estamos editando
                }
            }
        }

        private void cargarDatos(int id)
        {
            CategoriaNegocio negocio = new CategoriaNegocio();
            try
            {
                Categoria cat = negocio.obtenerPorId(id);
                if (cat != null)
                {
                    txtId.Text = cat.IDCategoria.ToString();
                    txtDescripcion.Text = cat.descripcion;
                }
            }
            catch (Exception ex)
            {
                mostrarMensaje("Error al cargar: " + ex.Message, true);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // 1. Barrera Frontend
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                CategoriaNegocio negocio = new CategoriaNegocio();
                Categoria cat = new Categoria();
                cat.descripcion = txtDescripcion.Text;

                if (EsModoEdicion)
                {
                    cat.IDCategoria = int.Parse(txtId.Text);
                    negocio.modificar(cat);
                    Session["msg"] = "Categoría modificada exitosamente.";
                }
                else
                {
                    negocio.agregar(cat);
                    Session["msg"] = "Categoría agregada exitosamente.";
                }

                Response.Redirect("CategoriaListado.aspx", false);
            }
            catch (Exception ex)
            {
                // Aquí caen los errores de Negocio (Duplicados) o BD
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