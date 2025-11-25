using Dominio.Usuario_Persona;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Dominio.Compras
{
    [Serializable]
    public class Compra
    {
        public int IDCompra { get; set; }
        public int IDProveedor { get; set; }
        public int IDUsuario { get; set; }
        public string Documento { get; set; } // N° de factura de quien te vende
        public DateTime FechaCompra { get; set; }
        public decimal MontoTotal { get; set; }

        public string Observaciones { get; set; }
        public enum Estado
        {
            Pendiente, Entregado, Cancelado
        }
        public Estado EstadoCompra { get; set; }
        public DateTime FechaRegistro { get; set; }
        public List<DetalleCompra> Detalles { get; set; }

        public string RazonSocialProveedor { get; set; }
        
        
        // La compra tiene muchas líneas de detalle


        public Compra()
        {
            Detalles = new List<DetalleCompra>();
        }
    }
}
