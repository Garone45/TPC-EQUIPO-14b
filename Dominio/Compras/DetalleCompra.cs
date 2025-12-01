using Dominio.Articulos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Compras
{
    [Serializable]
    public class DetalleCompra
    {
        public int IDDetalle { get; set; }
        public int IDCompra { get; set; }
        public int IDArticulo { get; set; }
        public string NombreProducto { get; set; }

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
