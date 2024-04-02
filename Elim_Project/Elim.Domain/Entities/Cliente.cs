using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{

    //Dados do cliente a fazer a compra
    public class Cliente
    {
        public int ID { get; set; }

        public string Nome { get; set; }

        public string Email { get; set; }

        public string Cpf { get; set; }

    }
}
