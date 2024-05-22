using ElimWebApplication.Application.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.Application.Interfaces
{
    public interface IClienteAppService
    {
        List<ClienteViewModel> GetAll();
    }
}
