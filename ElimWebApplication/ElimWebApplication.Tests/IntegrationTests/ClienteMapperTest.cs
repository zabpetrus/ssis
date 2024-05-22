using AutoMapper;
using ElimWebApplication.Application.ViewModel;
using ElimWebApplication.Domain.Entities;
using ElimWebApplication.InfraData.Mapping;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace ElimWebApplication.Tests.IntegrationTests
{
    public class ClienteMapperTest
    {
        private readonly IMapper _mapper;

        public ClienteMapperTest()
        {
            var config = new MapperConfiguration(cfg =>
            {
                cfg.AddProfile<ClienteProfile>();
            });

            _mapper = config.CreateMapper();

        }


        [Fact]
        public void Test1()
        {
            // Arrange
            var cliente = new Cliente(1, "nome", "cpf", "email", "uf", "pais");

            // Act
            var clienteDto = _mapper.Map<ClienteViewModel>(cliente);

            // Assert
            Assert.NotNull(clienteDto);
            Assert.Equal(cliente.Nome, clienteDto.Nome);
            Assert.Equal(cliente.Cpf, clienteDto.cpf);
            Assert.Equal(cliente.Email, clienteDto.email);
            Assert.Equal(cliente.Uf, clienteDto.uf);
            Assert.Equal(cliente.Pais, clienteDto.pais);
        }
    }
}
