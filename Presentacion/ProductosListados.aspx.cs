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
            ArticuloNegocio negocio = new ArticuloNegocio();

            if (!IsPostBack)

            {
                List<Articulo> lista = negocio.listar();
                gvProductos.DataSource = lista;
                gvProductos.DataBind();

                if (Session["msg"] != null)
                {
                    string mensaje = Session["msg"].ToString();
                    Session["msg"] = null;
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                    $"alert('{mensaje}');", true);
                }
            }

        }
     
    }
}