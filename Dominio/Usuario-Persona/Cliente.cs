using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    public class Cliente : Entidad
    {
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Dni { get; set; }
        public string NombreCompleto => Apellido + ", " + Nombre;
    }
}
