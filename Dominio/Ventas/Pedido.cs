using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Ventas
{
    public class Pedido
    {
        public int IDPedido { get; set; }
        public int IDCliente { get; set; }
        public int IDVendedor { get; set; }
        public DateTime Fecha { get; set; }
        public decimal Total { get; set; }
        public string MetodoPago { get; set; }

        // La Venta se compone de sus detalles
        public List<DetallePedido> Detalles { get; set; }

    }
}
