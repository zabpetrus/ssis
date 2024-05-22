using ElimWebApplication.InfraData.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace ElimWebApplication.Tests.DatabaseTests
{

    public class SqlServerTestConnector
    {
        public SqlServerTestConnector()
        {
        }

        [Fact]
        public void Test1()
        {
            // Arrange
            string connectionString = GetDecoderString.GetClearString();

            var dbOption = new DbContextOptionsBuilder<ApplicationContext>()
            .UseSqlServer(connectionString).Options;


            // Act & Assert
            using (ApplicationContext context = new ApplicationContext(dbOption))
            {
                Assert.True(context.Database.IsSqlServer());
            }
        }


        [Fact]
        public void Test2()
        {
            // Arrange
            string connectionString = GetDecoderString.GetClearString();

            var dbOption = new DbContextOptionsBuilder<ApplicationContext>()
            .UseSqlServer(connectionString).Options;


            // Act & Assert
            using (ApplicationContext context = new ApplicationContext(dbOption))
            {
                Assert.True(context.Database.CanConnect());
            }
        }




    }
}
