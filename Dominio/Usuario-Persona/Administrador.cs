using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    public class Administrador : Usuario
    {
        // Constructor: define el Rol automáticamente
        public Administrador()
        {
            this.Rol = "Administrador";
        }
    }
}
