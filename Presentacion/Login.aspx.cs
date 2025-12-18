using System;
using System.Web.UI;
using Dominio.Usuario_Persona;
using Negocio;

namespace Presentacion
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Si ya hay un usuario en sesión, redirigimos al inicio
            if (Session["usuario"] != null)
            {
                Response.Redirect("Default.aspx", false);
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            UsuarioNegocio negocio = new UsuarioNegocio();

            try
            {
                // ASIGNAMOS LOS VALORES DE LAS CAJAS DE TEXTO A TUS PROPIEDADES
                usuario.NombreUsuario = txtUsuario.Text;   
                usuario.Contraseña = txtPassword.Text;     

                // Intentamos loguear
                if (negocio.Loguear(usuario))
                {
                   
                    Session.Add("usuario", usuario);
                    Response.Redirect("Default.aspx", false);
                }
                else
                {
                    lblError.Text = "Usuario o contraseña incorrectos.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                lblError.Text = "Error al intentar ingresar. Revisa la conexión.";
                lblError.Visible = true;
            }
        }
    }
}