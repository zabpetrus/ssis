using ElimWebApplication.Application.AppService;
using ElimWebApplication.Application.Interfaces;
using ElimWebApplication.Application.ViewModel;
using Moq;

namespace ElimWebApplication.Tests.UniTests
{
    public class ClienteAppServiceTest
    {
        [Fact]
        public void Test1()
        {
            //Arrange

            List<ClienteViewModel> lista = new List<ClienteViewModel>();
            lista.Add(new ClienteViewModel("Nome", "cpf", "email", "uf", "pais"));

            Mock<IClienteAppService> mock = new Mock<IClienteAppService>();
            mock.Setup(o => o.GetAll()).Returns(lista);

            //Act

            ClienteAppService clienteViewModel = new ClienteAppService(mock.Object);
            var result = clienteViewModel.GetAll();

            //Assert
            Assert.Equal(result, lista);
        }



    }
}