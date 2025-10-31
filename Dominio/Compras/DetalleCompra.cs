using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Compras
{
    public class DetalleCompra
    {
        public int IDDetalleCompra { get; set; }
        public int IDOrdenCompra { get; set; }
        public int IDArticulo { get; set; }

        // Relación con el Artículo que se compró

        public int Cantidad { get; set; }

        // CRÍTICO: Este es el precio de costo de ESE momento.
        public decimal PrecioUnitario { get; set; }

        public decimal Subtotal
        {
            get { return Cantidad * PrecioUnitario; }
        }
    }
}
