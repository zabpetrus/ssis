using ElimWebApplication.Domain.Entities;
using ElimWebApplication.InfraData.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.InfraData.Repository
{
    public class ClienteRepository : IClienteRepository
    {

        private readonly IClienteRepository _clienteRepository;

         public ClienteRepository(IClienteRepository clienteRepository)
         {
            _clienteRepository = clienteRepository;
         }


        public List<Cliente> listarTodosClientes()
        {
            return _clienteRepository.listarTodosClientes();
        }
    }
}
