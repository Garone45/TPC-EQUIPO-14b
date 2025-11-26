using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio.Usuario_Persona; // Importante para castear el Usuario

namespace Presentacion
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["error"] != null)
            {
                lblError.Text = Session["error"].ToString();
                pnlError.Visible = true;
                Session.Remove("error");
            }
            // 2. Saludo
            if (Session["usuario"] != null)
            {
                Usuario user = (Usuario)Session["usuario"];
                lblNombreUsuario.Text = user.NombreUsuario;
            }
        }
    }
}