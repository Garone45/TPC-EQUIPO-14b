using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio.Usuario_Persona; // Asegúrate de que coincida con tu namespace de Usuario

namespace Presentacion
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. CHEQUEO DE SEGURIDAD
            if (Session["usuario"] == null)
            {
                // Si no hay usuario y no estoy en el Login, me manda al Login
                if (!(Page is Login))
                {
                    Response.Redirect("Login.aspx", false);
                    return;
                }
            }
            else
            {
                // 2. SI HAY USUARIO, CARGAMOS EL PERFIL
                Usuario user = (Usuario)Session["usuario"];

                // Validamos que los Labels existan antes de asignar (por seguridad)
                if (lblUser != null && lblRol != null)
                {
                    lblUser.Text = user.NombreUsuario;
                    lblRol.Text = user.TipoUsuario == TipoUsuario.ADMIN ? "Administrador" : "Vendedor";
                }

                // 3. SEGURIDAD POR ROL (Ocultar botones al Vendedor)
                if (user.TipoUsuario == TipoUsuario.VENDEDOR)
                {
                    // Ocultamos las opciones que no puede ver
                    if (lnkCompras != null) lnkCompras.Visible = false;
                    if (lnkProveedores != null) lnkProveedores.Visible = false;
                    if (lnkMarcas != null) lnkMarcas.Visible = false;
                    if (lnkCategorias != null) lnkCategorias.Visible = false;
                   
                }
            }
        }

        // ESTE ES EL MÉTODO QUE TE FALTABA
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();               // Borra al usuario de la memoria
            Response.Redirect("Login.aspx"); // Lo manda a la pantalla de entrada
        }
    }
}