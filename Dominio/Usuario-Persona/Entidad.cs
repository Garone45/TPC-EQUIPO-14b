using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    public class Entidad
    {
        public int ID { get; set; } // ID genérico (IdCliente o IdProveedor)
        public string Telefono { get; set; }
        public string Email { get; set; }
        public string Direccion { get; set; }
        public bool Activo { get; set; }
    }
}
