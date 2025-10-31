using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Ventas
{
    public class DetallePedido
    {
        public int IDDetallePedido { get; set; }
        // Relación con el Artículo que se vendió
        public int IDArticulo { get; set; }
        public int Cantidad { get; set; }
        // CRÍTICO: Este es el precio de venta calculado en ese momento.
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal
        {
            get { return Cantidad * PrecioUnitario; }
        }
    }
}
