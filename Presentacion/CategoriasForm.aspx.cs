using Dominio.Articulos;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class CategoriasForm : System.Web.UI.Page
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
                 
                    lblTitulo.Text = "Modificar Categoría";

                    int id = int.Parse(Request.QueryString["id"]);
                    CategoriaNegocio negocio = new CategoriaNegocio();

                    // (Ya tenés 'obtenerPorId' en CategoriaNegocio)
                    Categoria seleccionada = negocio.obtenerPorId(id);

                    // Rellenamos el formulario con los datos
                    txtDescripcion.Text = seleccionada.descripcion; 
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
    
            if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
            {
                rfvDescripcion.IsValid = false;
                return; // Detiene la ejecución si está vacío
            }

            try
            {
                CategoriaNegocio negocio = new CategoriaNegocio();
                Categoria categoria = new Categoria();

              
                categoria.descripcion = txtDescripcion.Text;

                if (EsModoEdicion)
                {
                    categoria.IDCategoria = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(categoria);
                    Session["msg"] = "Categoría modificada correctamente";
                }
                else
                {
                    negocio.agregar(categoria);
                    Session["msg"] = "Categoría agregada correctamente";
                }

                Response.Redirect("CategoriaListado.aspx");
            }
            catch (Exception ex)
            {
                // Si falla (ej. 'UNIQUE constraint' porque ya existe), muestra la alerta
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}