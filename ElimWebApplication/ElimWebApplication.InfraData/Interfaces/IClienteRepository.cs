using ElimWebApplication.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ElimWebApplication.InfraData.Interfaces
{
    public interface IClienteRepository
    {
        List<Cliente> listarTodosClientes();

    }
}
