    using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Articulos
{
    [Serializable]
    public  class Categoria
    {
        public int IDCategoria { get; set; }
        public string descripcion { get; set; }
        public bool estado { get; set; }
        public override string ToString()
        {
            return descripcion;
        }
    }
}
