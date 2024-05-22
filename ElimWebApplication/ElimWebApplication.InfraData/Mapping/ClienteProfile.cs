using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using ElimWebApplication.Application.ViewModel;
using ElimWebApplication.Domain.Entities;

namespace ElimWebApplication.InfraData.Mapping
{
    public class ClienteProfile : Profile
    {
       public ClienteProfile() {

            CreateMap<Cliente, ClienteViewModel>();
            CreateMap<ClienteViewModel,Cliente>();

        }
    }
}
