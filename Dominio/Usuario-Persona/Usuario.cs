using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Usuario_Persona
{
    public class Usuario
    {
        public int IDUsuario { get; set; }
        public string NombreUser { get; set; }
        public string Contrasena { get; set; }
        public bool Activo { get; set; }

        // El Rol es la propiedad clave. 
        // Usamos 'protected set' para que solo las clases hijas (Admin, Vendedor)
        // puedan establecer este valor.
        public string Rol { get; protected set; }

    }
}
