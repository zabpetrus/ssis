CREATE DATABASE [ElimDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ElimDB', FILENAME = N'ElimDB.mdf' , SIZE =  512000KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ElimDB_log', FILENAME = N'ElimDB_log.ldf' , SIZE =  512000KB , FILEGROWTH = 65536KB )
 WITH LEDGER = OFF
GO
ALTER DATABASE [ElimDB] SET COMPATIBILITY_LEVEL = 160
GO
ALTER DATABASE [ElimDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ElimDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ElimDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ElimDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ElimDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [ElimDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ElimDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ElimDB] SET AUTO_CREATE_STATISTICS ON(INCREMENTAL = OFF)
GO
ALTER DATABASE [ElimDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ElimDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ElimDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ElimDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ElimDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ElimDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ElimDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ElimDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ElimDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ElimDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ElimDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ElimDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ElimDB] SET  READ_WRITE 
GO
ALTER DATABASE [ElimDB] SET RECOVERY FULL 
GO
ALTER DATABASE [ElimDB] SET  MULTI_USER 
GO
ALTER DATABASE [ElimDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ElimDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ElimDB] SET DELAYED_DURABILITY = DISABLED 
GO
USE [ElimDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = On;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = Primary;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = Off;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = Primary;
GO
USE [ElimDB]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [ElimDB] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
