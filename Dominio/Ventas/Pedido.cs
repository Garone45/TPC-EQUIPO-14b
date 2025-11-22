using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Ventas
{
    [Serializable]
    public class Pedido
    {
        public int IDPedido { get; set; }
        public int IDCliente { get; set; }
        public int IDVendedor { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime FechaEntrega { get; set; }
        public decimal Subtotal { get; set; }
        public decimal Total { get; set; }
        public string MetodoPago { get; set; }
        public enum EstadoPedido { Pendiente, Entregado, Cancelado }
        public EstadoPedido Estado { get; set; }
        public decimal Descuento { get; set; }
        // La Venta se compone de sus detalles
        public List<DetallePedido> Detalles { get; set; }

        public string NombreCliente { get; set; }

    }
}
