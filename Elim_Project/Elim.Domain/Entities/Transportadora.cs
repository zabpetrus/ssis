using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Elim.Domain.Entities
{
    public class Transportadora
    {
        public int Id { get; set; }

        public string NomeTransportadora { get; set; }

        public string CNPJ_Transportadora { get; set; }

        public string Email_Transportadora { get; set; }
        
    }
}
