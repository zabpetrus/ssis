using ElimWebApplication.Application.Interfaces;
using ElimWebApplication.Application.ViewModel;
using ElimWebApplication.Domain.Entities;
using ElimWebApplication.Domain.Interfaces;
using ElimWebApplication.Domain.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.Application.AppService
{
    public class ClienteAppService : IClienteAppService
    {

        private IClienteAppService _clienteAppService;


        public  ClienteAppService(IClienteAppService clienteAppService)
        {
            _clienteAppService = clienteAppService;
        }

        public List<ClienteViewModel> GetAll()
        {
            return _clienteAppService.GetAll();   
        }

    }
}
