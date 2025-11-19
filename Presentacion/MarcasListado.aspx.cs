using Dominio.Articulos;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Presentacion
{
    public partial class MarcasListado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Configuración inicial opcional para el buscador
                txtBuscar.Attributes.Add("style", "padding-left: 2.5rem;");
                CargarGrilla();
            }
        }

        private List<Marca> Marcas
        {
            get
            {
                if (ViewState["Marcas"] == null)
                    ViewState["Marcas"] = new List<Marca>();
                return (List<Marca>)ViewState["Marcas"];
            }
            set
            {
                ViewState["Marcas"] = value;
            }
        }

        private void CargarGrilla()
        {
            MarcaNegocio negocio = new MarcaNegocio();
            try
            {
                string filtro = txtBuscar.Text.Trim();
                // Revisa si tu método listar soporta el filtro opcional
                // Si no, usa la lógica de if/else que tenías antes
                if (string.IsNullOrEmpty(filtro))
                    Marcas = negocio.listar(); // Asegúrate que listar() sin parámetros exista
                else
                    // Si tu negocio no tiene listar(string), usa filtrar(string) o adáptalo
                    // Por ahora asumo que tienes el método listar(string) como corregimos antes
                    Marcas = negocio.listar(filtro); // OJO AQUÍ: Chequea tu Negocio

                gvMarcas.DataSource = Marcas;
                gvMarcas.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error: " + ex.Message);
            }
        }

        protected void txtBuscar_TextChanged(object sender, EventArgs e)
        {
            gvMarcas.PageIndex = 0;
            CargarGrilla();
        }

        protected void gvMarcas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvMarcas.PageIndex = e.NewPageIndex;
            gvMarcas.DataSource = Marcas;
            gvMarcas.DataBind();
        }

        // --- NUEVO MÉTODO DE BORRADO ---
        protected void btnEliminarServer_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(hfIdMarca.Value))
                {
                    int id = int.Parse(hfIdMarca.Value);
                    MarcaNegocio negocio = new MarcaNegocio();
                    negocio.eliminarLogico(id);
                    CargarGrilla();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al eliminar: " + ex.Message);
            }
        }

        // El RowCommand ya no se usa para eliminar, pero puedes dejarlo vacío o borrarlo
        protected void gvMarcas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
        }
    }
}