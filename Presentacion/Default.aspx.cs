using Dominio.Usuario_Persona; // Importante para castear el Usuario
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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

            if (!IsPostBack)
            {
                CargarMetricas();
            }
        }

      

        private void CargarMetricas()
        {
            DashboardNegocio negocio = new DashboardNegocio();

            try
            {
                // 1. VENTAS
                decimal ventasHoy = negocio.TotalVentasHoy();
                decimal ventasAyer = negocio.TotalVentasAyer();

                lblVentasHoy.Text = ventasHoy.ToString("C"); // Formato Moneda ($)

                // Lógica del porcentaje
                decimal porcentaje = 0;
                if (ventasAyer > 0)
                    porcentaje = ((ventasHoy - ventasAyer) / ventasAyer) * 100;
                else if (ventasHoy > 0)
                    porcentaje = 100;

                lblPorcentaje.Text = (porcentaje > 0 ? "+" : "") + porcentaje.ToString("0") + "%";

                // Color dinámico (Opcional: Verde si sube, Rojo si baja)
                if (porcentaje >= 0) lblPorcentaje.ForeColor = System.Drawing.Color.Green;
                else lblPorcentaje.ForeColor = System.Drawing.Color.Red;


                // 2. PEDIDOS PENDIENTES
                lblPedidosPendientes.Text = negocio.CantidadPedidosPendientes().ToString();

                // 3. ALERTAS DE STOCK
                lblAlertasStock.Text = negocio.CantidadAlertasStock().ToString();

                // 4. CLIENTES ACTIVOS
                lblClientesActivos.Text = negocio.CantidadClientesActivos().ToString();

            }
            catch (Exception ex)
            {
                // Manejo de errores visual
                if (pnlError != null)
                {
                    pnlError.Visible = true;
                    lblError.Text = "No se pudieron cargar los datos: " + ex.Message;
                }
            }
        }
    }
}