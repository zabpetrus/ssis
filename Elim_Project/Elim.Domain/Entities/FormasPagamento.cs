using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public enum FormasPagamento
    {
        CartaodeCredito,
        CartaodeDebito,
        Paypal,
        Pix,
        Dinheiro,
        TransferenciaBancaria
    }
}
