using ElimWebApplication.InfraData.Interfaces;
using ElimWebApplication.Domain.Entities;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using ElimWebApplication.InfraData.Repository;

namespace ElimWebApplication.Tests.RepositoryTests
{
    public class ClienteRepositoryTest
    { 
        [Fact]
        public void Test1()
        {
            //Arrange
            List<Cliente> anedota = new List<Cliente>();
            anedota.Add(new Cliente(1, "nome", "cpf", "email", "uf", "pais"));

            Mock<IClienteRepository> mock = new Mock<IClienteRepository>();
            mock.Setup(o => o.listarTodosClientes()).Returns(anedota);

            //Act
            ClienteRepository clienteRepository = new ClienteRepository(mock.Object);
            var result = clienteRepository.listarTodosClientes();

            //Assert
            Assert.Equal(anedota, result);

        }
        
    }
}
