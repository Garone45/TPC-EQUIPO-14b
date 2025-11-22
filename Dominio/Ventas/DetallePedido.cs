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
        public int IDDetalle { get; set; }
        public int IDPedido { get; set; }      // Relación con Pedido
        public int IDArticulo { get; set; }    // Relación con Producto

        public string Descripcion { get; set; }
        public int Cantidad { get; set; }
        // CRÍTICO: Este es el precio de venta calculado en ese momento.
        public decimal PrecioUnitario { get; set; }
        public decimal TotalParcial
        {
            get { return Cantidad * PrecioUnitario; }
        }

        public decimal Descuento { get; set; }
    }
}
