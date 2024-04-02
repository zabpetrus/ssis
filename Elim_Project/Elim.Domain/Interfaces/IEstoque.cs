using Elim.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Interfaces
{
    public interface IEstoque
    {
        void AddProduto(Produto produto, int qte);

        void UpdateProduto(Produto produto, int qte);

        void RemoveProduto(Produto produto);

        int RetornaQuantidades(Produto produto);

        bool VerificarDisponibilidade(Produto produto, int quantidadeRequerida);

        void AtualizarEstoqueAposCompra(Produto produto, int quantidadeVendida);

        // Conexão com api externa - não será implementado

        void AtualizarDadosProdutoAmazon(Produto produto);

        void AtualizarDadosProdutoMercadoLivre(Produto produto);
    }
}
