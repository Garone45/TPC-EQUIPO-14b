using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Dominio.Compras
{
    internal class Compra
    {
        public int IDCompra { get; set; }
        public int IDProveedor { get; set; }
        public int IDUsuario { get; set; }
        public OrdenCompra IDOrdenCompra { get; set; }
        public DateTime FechaIngreso { get; set; }
        public string NumeroFacturaProveedor { get; set; } // N° de factura de quien te vende

        // La compra tiene muchas líneas de detalle
        public List<DetalleCompra> Detalles { get; set; }

        public decimal TotalCompra { get; set; }
        public bool Activo { get; set; }

        public Compra()
        {
            Detalles = new List<DetalleCompra>();
        }
    }
}
