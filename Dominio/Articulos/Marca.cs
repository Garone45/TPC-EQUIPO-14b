using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Articulos
{
    [Serializable]
    public class Marca
    {
        public int IDMarca { get; set; }
        public string Descripcion { get; set; }

        public bool Estado { get; set; }

        public override string ToString()
        {
            return Descripcion;
        }
    }
}
