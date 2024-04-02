using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class NotaFiscal
    {
        public int Id { get; set; }

        public Pedido pedido { get; set; }

        public DateTime dataExpedicao { get; set; }


    }
}
