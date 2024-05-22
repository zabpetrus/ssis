using ElimWebApplication.Domain.Entities;
using ElimWebApplication.Domain.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.Domain.Services
{
    public class ClienteService : IClienteService
    {
        private readonly IClienteService _clienteService;

        public ClienteService(IClienteService clienteService)
        {
            _clienteService = clienteService;
        }

        public List<Cliente> GetAllClientes()
        {
            return _clienteService.GetAllClientes();    
        }
    }
}
