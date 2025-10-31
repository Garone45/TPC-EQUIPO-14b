using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Ventas
{
    public class Factura
    {
        public int IDFactura { get; set; }
        public int IDPedido { get; set; }
        // El número único que pide la consigna
        public string NroComprobante { get; set; } 
        public string TipoComprobante { get; set; } 
        public DateTime Fecha { get; set; }
        public decimal Total { get; set; }
        
    }
}
