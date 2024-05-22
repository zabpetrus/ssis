using ElimWebApplication.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.Domain.Interfaces
{
    public interface IClienteService
    {
        List<Cliente> GetAllClientes();
    }
}
