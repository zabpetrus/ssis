using Elim.Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class Estoque : IEstoque 
    {
        private Dictionary<Produto, int> _quantidades;

        public Estoque()
        {
            _quantidades = new Dictionary<Produto, int>();  
        }

        public void AddProduto(Produto produto, int qte) {
            if(_quantidades.ContainsKey(produto))
            {
                _quantidades[produto] += qte;
            }
            else
            {
                _quantidades.Add(produto, qte);
            }
        
        }

        public void UpdateProduto(Produto produto, int qte)
        {
            if (_quantidades.ContainsKey(produto))
            {
                _quantidades[produto] += qte;
            }
            else
            {
                throw new Exception("O produto nao consta no estoque");
            }

        }


        public void RemoveProduto(Produto produto)
        {
            if (_quantidades.ContainsKey(produto))
            {
                _quantidades.Remove(produto);
            }
            else
            {
                throw new Exception("O produto nao consta no estoque");
            }
        }


        public int RetornaQuantidades(Produto produto)
        {
            if (_quantidades.ContainsKey(produto))
            {
                return _quantidades[produto];
            }
            else
            {
                return 0;
            }
        }


        public bool VerificarDisponibilidade(Produto produto, int quantidadeRequerida)
        {
            if (_quantidades.ContainsKey(produto))
            {
                return _quantidades[produto] >= quantidadeRequerida;
            }
            else
            {
                return false;
            }
        }

        public void AtualizarEstoqueAposCompra(Produto produto, int quantidadeVendida)
        {
            if (_quantidades.ContainsKey(produto))
            {
                _quantidades[produto] -=  quantidadeVendida;
            }
            else
            {
                throw new Exception("O produto não consta no estoque");
            }
        }

        public void AtualizarDadosProdutoAmazon(Produto produto)
        {
            throw new NotImplementedException();
        }

        public void AtualizarDadosProdutoMercadoLivre(Produto produto)
        {
            throw new NotImplementedException();
        }
    }
}
