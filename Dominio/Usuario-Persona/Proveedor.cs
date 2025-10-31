using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    public class Proveedor : Entidad
    {
        public string Seudonimo { get; set; } // O RazonSocial
        public string Cuit { get; set; }
    }
}
