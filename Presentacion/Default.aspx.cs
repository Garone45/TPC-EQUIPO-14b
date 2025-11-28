using Dominio.Usuario_Persona; // Importante para castear el Usuario
using Negocio;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
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


        protected void btnDescargarVentas_Click(object sender, EventArgs e)
        {
            try
            {
                DashboardNegocio negocio = new DashboardNegocio();
                DataTable dt = negocio.ObtenerReporteVentas();
                DescargarExcel(dt, "Reporte_Ventas_" + DateTime.Now.ToString("yyyyMMdd"));
            }
            catch (Exception ex)
            {
                // Manejo de error simple
                pnlError.Visible = true;
                lblError.Text = "Error al descargar: " + ex.Message;
            }
        }

        protected void btnDescargarCompras_Click(object sender, EventArgs e)
        {
            try
            {
                DashboardNegocio negocio = new DashboardNegocio();
                DataTable dt = negocio.ObtenerReporteCompras(); // O el reporte que quieras
                DescargarExcel(dt, "Reporte_Stock_Proveedores_" + DateTime.Now.ToString("yyyyMMdd"));
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                lblError.Text = "Error al descargar: " + ex.Message;
            }
        }

        // Método Mágico que convierte cualquier Tabla a un archivo CSV descargable
        private void DescargarExcel(DataTable dt, string nombreArchivo)
        {
            // 1. Configurar la respuesta del navegador
            string attachment = "attachment; filename=" + nombreArchivo + ".csv";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "text/csv; charset=utf-8";
            Response.ContentEncoding = Encoding.UTF8;

            // 2. Construir el contenido del CSV
            StringBuilder sb = new StringBuilder();

            // Agregar los encabezados de columna
            foreach (DataColumn col in dt.Columns)
            {
                sb.Append(col.ColumnName + ";"); // Usamos punto y coma que es estándar en Excel latinos
            }
            sb.AppendLine();

            // Agregar las filas de datos
            foreach (DataRow row in dt.Rows)
            {
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    // Reemplazamos posibles puntos y comas en los datos para no romper el formato
                    string dato = row[i].ToString().Replace(";", ",");
                    sb.Append(dato + ";");
                }
                sb.AppendLine();
            }

            // 3. Escribir el archivo y terminar la respuesta
            // El BOM (Byte Order Mark) ayuda a Excel a entender que es UTF-8 (tildes y ñ)
            Response.BinaryWrite(Encoding.UTF8.GetPreamble());
            Response.Write(sb.ToString());
            Response.End();
        }
    }
}