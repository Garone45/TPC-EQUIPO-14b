using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    [Serializable]
    public class Proveedor
    {
        public int ID { get; set; } // El IDProveedor

        // Atributos de Proveedor
        public string RazonSocial { get; set; }
        public string Cuit { get; set; }
        public string Seudonimo { get; set; } // (Este estaba en tu DER)

        // Atributos de Entidad (los "heredados")
        public string Telefono { get; set; }
        public string Email { get; set; }
        public string Direccion { get; set; }
        public bool Activo { get; set; }
    }
}
