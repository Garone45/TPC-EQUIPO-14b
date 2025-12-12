using System;
using System.Drawing;
using Negocio;

namespace Presentacion
{
    public partial class RecuperarPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRecuperar_Click(object sender, EventArgs e)
        {
        
            if (string.IsNullOrEmpty(txtEmail.Text)) return;

            UsuarioNegocio negocio = new UsuarioNegocio();
            EmailService emailService = new EmailService();

            try
            {
             
                if (negocio.BuscarPorEmail(txtEmail.Text))
                {
                    // 2. Si existe, preparamos el correo
                    string mensajeCuerpo = @"
                        <div style='font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4;'>
                            <div style='max-width: 600px; margin: 0 auto; background-color: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);'>
                                <h1 style='color: #1173d4;'>Recuperación de Contraseña</h1>
                                <p style='color: #333;'>Hola,</p>
                                <p style='color: #555;'>Hemos recibido una solicitud para restablecer tu contraseña.</p>
                                <hr style='border: 0; border-top: 1px solid #eee; margin: 20px 0;'>
                                <p style='color: #555;'>Por motivos de seguridad, deberás contactar a un Administrador para que genere una nueva credencial manual.</p>
                                <p style='color: #999; font-size: 12px; margin-top: 30px;'>Si no solicitaste este cambio, ignora este correo.</p>
                            </div>
                        </div>";

                    
                    emailService.ArmarCorreo(txtEmail.Text, "Recupero de Contraseña - TPC", mensajeCuerpo);
                    emailService.enviarEmail();

                
                    lblMensaje.Text = "¡Correo enviado! Revisa tu bandeja de entrada.";
                    lblMensaje.CssClass = "text-center text-sm font-bold p-3 rounded-xl mt-2 bg-green-100 text-green-700 border border-green-200 block";
                    lblMensaje.Visible = true;

                    // Bloqueamos para que no envíe mil veces
                    txtEmail.Enabled = false;
                    btnRecuperar.Enabled = false;
                }
                else
                {
                   
                    lblMensaje.Text = "No encontramos ningún usuario registrado con ese email.";
                    lblMensaje.CssClass = "text-center text-sm font-bold p-3 rounded-xl mt-2 bg-red-100 text-red-700 border border-red-200 block";
                    lblMensaje.Visible = true;
                }
            }
            catch (Exception ex)
            {
               
                lblMensaje.Text = "Hubo un error al enviar el correo. Intenta más tarde.";
                lblMensaje.CssClass = "text-center text-sm font-bold p-3 rounded-xl mt-2 bg-amber-100 text-amber-700 border border-amber-200 block";
                lblMensaje.Visible = true;
            }
        }
    }
}