using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class Pedido
    {
        public int Id { get; set; }

        public List<ItemPedido> ItensPedido { get; set; }

        public DateTime DataPedido { get; set; }

        public Cliente Cliente { get; set; }    

        public FormasPagamento FormasPagamento { get; set; }


        public decimal Total {

            get
            {
                decimal total = 0;

                foreach(ItemPedido item in ItensPedido)
                {
                    decimal descontoDecimal = item.Desconto / 100; 
                    decimal precoComDesconto = item.PrecoUnitario * (1 - descontoDecimal); 
                    decimal totalItem = precoComDesconto * item.Quantidade;
                    total += totalItem; 
                }
                return total;
            }
        
        }


        public Pedido(List<ItemPedido> _itensPedido)
        {
            ItensPedido = new List<ItemPedido>();
        }

        public Pedido() { }

        public Pedido(List<ItemPedido> itensPedido, DateTime dataPedido, Cliente cliente, FormasPagamento formasPagamento)
        { 
            ItensPedido = itensPedido;
            DataPedido = dataPedido;
            Cliente = cliente;
            FormasPagamento = formasPagamento;
        }

        public Pedido(int id)
        {
            Id = id;
        }
    }
}
