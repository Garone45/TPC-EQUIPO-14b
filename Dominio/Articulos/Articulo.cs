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
        public string CodigoArticulo { get; set; }    
        public string Descripcion { get; set; }       
        public bool Activo { get; set; }


        public decimal PrecioCostoActual { get; set; } // Último costo de compra (insumo para el cálculo)
        public decimal PorcentajeGanancia { get; set; } // Margen para calcular Precio Venta
        public int StockActual { get; set; }          // Cantidad disponible (para la validación)
        public int StockMinimo { get; set; }          
        //  COMPOSICIÓN 
        public Marca Marca { get; set; }
        public Categoria Categorias { get; set; }

        public decimal PrecioVentaCalculado
        {
            get
            {
                // Nos aseguramos de no dividir por cero o calcular sobre nada.
                if (PrecioCostoActual > 0 && PorcentajeGanancia > 0)
                {
                    // Fórmula: Venta = Costo * (1 + (Porcentaje / 100))
                    return PrecioCostoActual * (1 + (PorcentajeGanancia / 100));
                }
                // Si no hay costo o ganancia, el precio de venta es el costo.
                return PrecioCostoActual;
            }
            // No tiene 'set' porque no queremos que se pueda asignar.
            // Solo se calcula.
        }

    }
}
