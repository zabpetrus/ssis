using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.Application.ViewModel
{
    public class ClienteViewModel
    {
        public string Nome {  get; set; } = string.Empty;

        public string cpf { get; set; } = string.Empty;

        public string email { get; set; } = string.Empty;

        public string uf {  get; set; } = string.Empty;

        public string pais { get; set; } = string.Empty;

        public ClienteViewModel(string nome, string cpf, string email, string uf, string pais)
        {
            Nome = nome;
            this.cpf = cpf;
            this.email = email;
            this.uf = uf;
            this.pais = pais;
        }

        public ClienteViewModel() { }

        public override string? ToString()
        {
            return $"Nome: {Nome}, CPF: {cpf}, Email: {email}, UF: {uf}, País: {pais}";
        }
    }
}
