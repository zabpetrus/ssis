using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class ItemPedido
    {
        public int Id { get; set; }

        public Produto produto { get; set; } = new Produto();

        public int Quantidade { get; set; } = 0;

        public decimal PrecoUnitario { get; set; } = decimal.Zero;

        public decimal Desconto { get; set; }


    }
}
