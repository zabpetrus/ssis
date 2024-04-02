using Elim.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Interfaces
{
    public interface IEndereco
    {
        string Logradouro { get; set; }

        string Cidade { get; set; }

        string Cep { get; set; }

        string Complemento { get; set; }

        Cliente cliente { get; set; }
    }
}
