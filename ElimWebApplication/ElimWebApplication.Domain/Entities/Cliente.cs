namespace ElimWebApplication.Domain.Entities
{
    public class Cliente
    {
        public int Cliente_id { get; set; }

        public string Nome { get; set; } = string.Empty;

        public string Cpf { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string Uf { get; set; } = string.Empty;

        public string Pais { get; set; } = string.Empty;

        public Cliente(int cliente_id, string nome, string cpf, string email, string uf, string pais)
        {
            Cliente_id = cliente_id;
            Nome = nome;
            Cpf = cpf;
            Email = email;
            Uf = uf;
            Pais = pais;
        }

        public Cliente() { }

    }
}
