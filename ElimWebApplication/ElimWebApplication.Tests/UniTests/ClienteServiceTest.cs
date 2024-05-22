using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ElimWebApplication.Domain.Entities;
using ElimWebApplication.Domain.Interfaces;
using ElimWebApplication.Domain.Services;
using Moq;

namespace ElimWebApplication.Tests.UniTests
{
    public class ClienteServiceTest
    {
        [Fact]
        public void Test1()
        {
            //Arrange

            List<Cliente> clientes = new List<Cliente>();
            clientes.Add(new Cliente(1, "nome","cpf","email","uf","pais"));

             Mock<IClienteService>  mock = new Mock<IClienteService> ();
            mock.Setup(o => o.GetAllClientes()).Returns(clientes);

            //Act
            ClienteService clienteService = new ClienteService (mock.Object);
            var result = clienteService.GetAllClientes();

            //Assert
            Assert.Equal(clientes, result);


        }
    }
}
