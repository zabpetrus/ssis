using Elim.Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class Carrinho 
    {

        public Carrinho() { Itens = new List<ItemPedido>(); }

        public int ID { get; set; }

        public List<ItemPedido> Itens { get; set; }

        public Cliente cliente { get; set; }

        public DateTime dataCompra { get; set; }

        public decimal CarrinhoTotal
        {

            get
            {
                decimal total = 0;

                foreach (ItemPedido item in Itens)
                {
                    decimal descontoDecimal = item.Desconto / 100;
                    decimal precoComDesconto = item.PrecoUnitario * (1 - descontoDecimal);
                    decimal totalItem = precoComDesconto * item.Quantidade;
                    total += totalItem;
                }
                return total;
            }

        }


        public Pedido ConcluirPedido()
        {
            Pedido pedido = new Pedido(Itens);
            return pedido;

        }


        private bool AtualizarEstoque()
        {
            throw new NotImplementedException();
        }


        private bool ConfirmarPedido()
        {
            throw new NotImplementedException();
        }

        private bool EfetuarPagamento()
        {
            throw new NotImplementedException();
        }

        private bool GeraNotaFiscal(Pedido pedido)
        {
            throw new NotImplementedException();
        }

        private bool ValidaCarrinho()
        {
            throw new NotImplementedException();
        }
    }
}
