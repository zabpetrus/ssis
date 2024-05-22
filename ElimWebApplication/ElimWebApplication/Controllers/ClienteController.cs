using AutoMapper;
using ElimWebApplication.Application.AppService;
using ElimWebApplication.Application.Interfaces;
using ElimWebApplication.Application.ViewModel;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace ElimWebApplication.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class ClienteController : ControllerBase
    {

        private IClienteAppService _clienteAppService;


        public ClienteController( IClienteAppService clienteAppService )
        {
           _clienteAppService = clienteAppService;
        }

       [HttpGet]
        public string Get()
        {
           List<ClienteViewModel> lista = _clienteAppService.GetAll();
            var mc = "";
           for(var i = 0; i < lista.Count; i++ )
            {
                mc = mc + lista[i];
            }

            return "DANESE " + mc;
        }  
    }
}
