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
    public partial class ProductosListados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ArticulosNegocio negocio = new ArticulosNegocio();

                try
                {              
                    List<Articulo> lista = negocio.listar();
   
                    gvProductos.DataSource = lista;

                    // 3. Enlazar los datos
                    gvProductos.DataBind();
                }
                catch (Exception ex)
                {
                    // Manejo básico de error si falla la conexión/consulta a BD
                    // Muestra el error en una alerta para fines de prueba
                    Response.Write($"<script>alert('Error al cargar listado: {ex.Message}');</script>");
                }
            }
        }
    }
}