using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public enum EstatusPedido
    {
        aguardando_pagamento,
        pedido_autorizado,
        pagamento_aprovado,
        pagamento_recusado,
        pagamento_cancelado,
        produto_em_separacao,
        em_transporte,
        entregue,
        faturado,
        pronto_para_envio,
        excecao_de_entrega
    }
}
