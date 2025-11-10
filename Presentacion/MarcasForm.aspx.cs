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
    public partial class MarcasForm : System.Web.UI.Page
    {
        public bool EsModoEdicion { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            EsModoEdicion = Request.QueryString["id"] != null;
            if (!IsPostBack)
            {
                // Si estamos en MODO EDICIÓN...
                if (EsModoEdicion)
                {
                    // Cambiamos el título
                    lblTitulo.Text = "Modificar Marca";

                    int id = int.Parse(Request.QueryString["id"]);
                    MarcaNegocio negocio = new MarcaNegocio();

                    // (Asumo que ya implementaste 'obtenerPorId' en MarcaNegocio)
                    Marca seleccionada = negocio.obtenerPorId(id);

                    // Rellenamos el formulario con los datos
                    txtDescripcion.Text = seleccionada.Descripcion;
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
            {
                // Forzamos que el validador muestre su mensaje de error
                rfvDescripcion.IsValid = false;
                return; // Detiene la ejecución si está vacío
            }

            try
            {
                MarcaNegocio negocio = new MarcaNegocio();
                Marca marca = new Marca();

                // 2. Cargamos el objeto
                marca.Descripcion = txtDescripcion.Text;

                // 3. Decidimos si AGREGAR o MODIFICAR
                if (EsModoEdicion)
                {
                    marca.IDMarca = int.Parse(Request.QueryString["id"]);
                    negocio.modificar(marca);
                    Session["msg"] = "Marca modificada correctamente";
                }
                else
                {
                    negocio.agregar(marca);
                    Session["msg"] = "Marca agregada correctamente";
                }

                // 4. Redirigimos al listado
                Response.Redirect("MarcasListado.aspx");
            }
            catch (Exception ex)
            {
                Response.Write($"<script>alert('Error al guardar: {ex.Message}');</script>");
            }
        }
    }
}