using Dominio.Ventas; // Para usar tu clase Pedido
using System;
using System.Collections.Generic;
using System.Web.UI;
using Negocio;

namespace Presentacion
{
    // Asegúrate de que esta clase herede de Page y coincida con el atributo Inherits del ASPX
    public partial class VentasListado : Page
    {
     
    


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarVentas();
            }
        }

        private void CargarVentas()
        {
            // La Capa de Presentación solo llama a la Capa de Negocio
            VentasNegocio negocio = new VentasNegocio();
            List<Pedido> listaPedidos = null;

            try
            {
                // Asumo que tu clase VentasNegocio tiene un método ListarTodos()
                listaPedidos = negocio.ListarTodos();
            }
            catch (Exception ex)
            {
                // Manejo de errores de la BLL/DAO
                // Aquí deberías mostrar un mensaje de error visible al usuario (e.g., usando un Label)
                // Console.WriteLine("Error de DB: " + ex.Message); // Para depuración
                listaPedidos = new List<Pedido>(); // Asignamos lista vacía para no fallar
            }

            if (listaPedidos != null && listaPedidos.Count > 0)
            {
                // Enlazar datos al Repeater
                rptVentas.DataSource = listaPedidos;
                rptVentas.DataBind();

                // --- CORRECCIÓN DE IDs ---
                // Controlar visibilidad
                pnlVacio.Visible = false;      // ANTES: Panel1
                pnlTablaVentas.Visible = true;
                pnlPaginacion.Visible = true;  // ANTES: Panel2
            }
            else
            {
                // --- CORRECCIÓN DE IDs ---
                // Mostrar panel de vacío si no hay datos
                pnlVacio.Visible = true;       // ANTES: Panel1
                pnlTablaVentas.Visible = false;
                pnlPaginacion.Visible = false; // ANTES: Panel2
            }
        }
        // *** MÉTODO CRÍTICO PARA EL REPEATER Y LA CLASE CSS DEL ESTADO ***
        // Este método debe ser 'protected' o 'public' para ser llamado desde el ASPX.
        protected string GetEstadoClass(string estado)
        {
            // El 'estado' que llega es la cadena del Enum (e.g., "Entregado")
            switch (estado)
            {
                case "Entregado":
                    return "bg-success/20 text-success";
                case "Pendiente":
                    return "bg-warning/20 text-warning";
                case "Cancelado":
                    return "bg-danger/20 text-danger";
                default:
                    return "bg-gray-200 dark:bg-gray-600 text-gray-700 dark:text-gray-300";
            }
        }
    }
}