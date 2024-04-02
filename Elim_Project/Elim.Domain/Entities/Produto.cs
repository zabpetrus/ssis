using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class Produto
    {
        public int Id { get; set; }

        public string Titulo { get; set; }

        public string Descricao { get; set; }

        public int CategoriaId { get; set; }

        public decimal PrecoProduto { get; set; }

        public decimal PrecoBase { get; set; }

    }
}
