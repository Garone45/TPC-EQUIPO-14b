using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio.Articulos
{
    public class Articulo
    {
    
        public int IDArticulo { get; set; }           // Clave Primaria (PK)
        public string CodigoArticulo { get; set; }    // Agregado por UPDATE
        public string Descripcion { get; set; }       // Nombre/Descripción del artículo
        public bool Activo { get; set; }

        public string MarcaNombre => Marca?.Descripcion ?? "Sin marca";
        public string CategoriaNombre => Categorias?.descripcion ?? "Sin categoría";

        public decimal PrecioCostoActual { get; set; } // Último costo de compra (insumo para el cálculo)
        public decimal PorcentajeGanancia { get; set; } // Margen para calcular Precio Venta
        public int StockActual { get; set; }          // Cantidad disponible (para la validación)
        public int StockMinimo { get; set; }          // Umbral de alerta

        //  COMPOSICIÓN 
        public Marca Marca { get; set; }
        public Categoria Categorias { get; set; }

        public decimal PrecioVenta
        {
       
            get { return PrecioCostoActual * (1 + PorcentajeGanancia); }
        }

    }
}
