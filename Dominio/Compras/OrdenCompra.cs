using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio.Articulos; // Para Articulo
using Dominio.Usuario_Persona;  // Para Proveedor

namespace Dominio.Compras
{
    public class OrdenCompra
    {
        public int IDOrdenCompra { get; set; }
        public DateTime Fecha { get; set; }

        // Relación con el Proveedor-Usuario
        public int IDProveedor { get; set; }
        public int IDUsuario { get; set; }

        // Una orden de compra tiene muchas líneas de detalle
        public List<DetalleCompra> Detalles { get; set; }

        public decimal Total { get; set; }
        public string Estado { get; set; } // Ej: "Pendiente", "Aprobada", "Comprada"
        public string MetodoDePago { get; set; }

        public OrdenCompra()
        {
            Detalles = new List<DetalleCompra>();
        }
    }
}
