using Elim.Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class EnderecoCliente : IEndereco
    {
        string IEndereco.Logradouro { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        string IEndereco.Cidade { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        string IEndereco.Cep { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        string IEndereco.Complemento { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        Cliente IEndereco.cliente { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
    }
}
