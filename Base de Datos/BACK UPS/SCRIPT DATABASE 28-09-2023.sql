/****** Object:  Database [SIMEXPRO]    Script Date: 28/9/2023 13:14:48 ******/
CREATE DATABASE [SIMEXPRO]  (EDITION = 'GeneralPurpose', SERVICE_OBJECTIVE = 'GP_Gen5_2', MAXSIZE = 32 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS, LEDGER = OFF;
GO
ALTER DATABASE [SIMEXPRO] SET COMPATIBILITY_LEVEL = 150
GO
ALTER DATABASE [SIMEXPRO] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [SIMEXPRO] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [SIMEXPRO] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [SIMEXPRO] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [SIMEXPRO] SET ARITHABORT OFF 
GO
ALTER DATABASE [SIMEXPRO] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [SIMEXPRO] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [SIMEXPRO] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [SIMEXPRO] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [SIMEXPRO] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [SIMEXPRO] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [SIMEXPRO] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [SIMEXPRO] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [SIMEXPRO] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [SIMEXPRO] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [SIMEXPRO] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [SIMEXPRO] SET  MULTI_USER 
GO
ALTER DATABASE [SIMEXPRO] SET ENCRYPTION ON
GO
ALTER DATABASE [SIMEXPRO] SET QUERY_STORE = ON
GO
ALTER DATABASE [SIMEXPRO] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
/*** The scripts of database scoped configurations in Azure should be executed inside the target database connection. ***/
GO
-- ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 8;
GO
/****** Object:  Schema [Acce]    Script Date: 28/9/2023 13:14:49 ******/
CREATE SCHEMA [Acce]
GO
/****** Object:  Schema [Adua]    Script Date: 28/9/2023 13:14:49 ******/
CREATE SCHEMA [Adua]
GO
/****** Object:  Schema [Gral]    Script Date: 28/9/2023 13:14:49 ******/
CREATE SCHEMA [Gral]
GO
/****** Object:  Schema [Prod]    Script Date: 28/9/2023 13:14:49 ******/
CREATE SCHEMA [Prod]
GO
/****** Object:  UserDefinedFunction [Gral].[ProperCase]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*** CONVERTIR MAYUSUCULAS A 'PROPER CASE' O 'PROPER TITLE' --***
CREATE   FUNCTION [Gral].[ProperCase](@Text as varchar(8000))
returns varchar(8000)
as
BEGIN
  DECLARE @Reset bit;
  DECLARE @Ret varchar(8000);
  DECLARE @i int;
  DECLARE @c char(1);

  if @Text is null
    return null;

  select @Reset = 1, @i = 1, @Ret = '';

  while (@i <= len(@Text))
    select @c = substring(@Text, @i, 1),
      @Ret = @Ret + case when @Reset = 1 then UPPER(@c) else LOWER(@c) end,
      @Reset = case when @c like '[a-zA-Z]' then 0 else 1 end,
      @i = @i + 1
  return @Ret
END

-----------------PROCEDIMIENTOS ALMACENADOS Y VISTAS ACCESO
--************USUARIOS******************--

/*Vista usuarios*/
--CREATE OR ALTER VIEW acce.VW_tbUsuarios
--AS
--	SELECT usua.usua_Id AS usuarioId, 
--		   usua.usua_Nombre AS usuarioNombre, 
--		   usua.usua_Contrasenia AS usuarioContrasenia, 
--		   usua.usua_Correo AS usuarioCorreo, 
--		   usua.role_Id AS rolId,
--		   rol.role_Descripcion AS rolDescripcion, 
--		   usua.usua_EsAdmin,
--		   usua.empl_Id AS empleadoId,
--		   (empl_Nombres + ' ' + empl_Apellidos) AS empleadoNombreCompleto, 
--		   usua.usua_UsuarioCreacion AS usuarioCreacion, 
--		   usuaCrea.usua_Nombre AS usuarioCreacionNombre,
--		   usua.usua_FechaCreacion AS usuarioFechaCreacion, 
--	       usua.usua_UsuarioModificacion AS usuarioModificacion, 
--		   usuaModifica.usua_Nombre AS usuarioModificacionNombre, 
--		   usua.usua_FechaModificacion AS usuarioFechaModificacion,
--		   usuaElimina.usua_Nombre AS usuarioEliminacionNombre, 
--		   usua.usua_FechaEliminacion AS usuarioFechaEliminacion,
--		   usua.usua_Estado AS usuarioEstado,
--		   empl.empl_CorreoElectronico AS empleadoCorreoElectronico	
--		   FROM Acce.tbUsuarios usua LEFT JOIN Acce.tbRoles rol
--		   ON usua.role_Id = rol.role_Id
--		   LEFT JOIN Gral.tbEmpleados empl
--		   ON empl.empl_Id = usua.empl_Id 
--		   LEFT JOIN acce.tbUsuarios usuaCrea
--		   ON usua.usua_UsuarioCreacion = usuaCrea.usua_Id
--		   LEFT JOIN acce.tbUsuarios usuaModifica
--		   ON usua.usua_UsuarioModificacion = usuaModifica.usua_Id LEFT JOIN acce.tbUsuarios usuaElimina
--		   ON usua.usua_UsuarioEliminacion = usuaElimina.usua_Id
		   
GO
/****** Object:  Table [Adua].[tbIncoterm]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbIncoterm](
	[inco_Id] [int] IDENTITY(1,1) NOT NULL,
	[inco_Codigo] [char](3) NULL,
	[inco_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[inco_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[inco_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[inco_FechaEliminacion] [datetime] NULL,
	[inco_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbIncoterm_inco_Id] PRIMARY KEY CLUSTERED 
(
	[inco_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbIncoterm_inco_Codigo] UNIQUE NONCLUSTERED 
(
	[inco_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbIncoterm_inco_Descripcion] UNIQUE NONCLUSTERED 
(
	[inco_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbAduanas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbAduanas](
	[adua_Id] [int] IDENTITY(1,1) NOT NULL,
	[adua_Codigo] [char](4) NOT NULL,
	[adua_Nombre] [nvarchar](500) NOT NULL,
	[ciud_Id] [int] NULL,
	[adua_Direccion_Exacta] [nvarchar](800) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[adua_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[adua_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[adua_FechaEliminacion] [datetime] NULL,
	[adua_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbAduanas_adua_Id] PRIMARY KEY CLUSTERED 
(
	[adua_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbAduanas_adua_Codigo] UNIQUE NONCLUSTERED 
(
	[adua_Codigo] ASC,
	[adua_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbAduanas_adua_Codigo1] UNIQUE NONCLUSTERED 
(
	[adua_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbPaises]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbPaises](
	[pais_Id] [int] IDENTITY(1,1) NOT NULL,
	[pais_Codigo] [char](2) NOT NULL,
	[pais_Nombre] [nvarchar](150) NOT NULL,
	[pais_EsAduana] [bit] NOT NULL,
	[pais_prefijo] [nvarchar](4) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pais_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pais_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[pais_FechaEliminacion] [datetime] NULL,
	[pais_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbPaises_pais_Id] PRIMARY KEY CLUSTERED 
(
	[pais_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbPaises_pais_Codigo] UNIQUE NONCLUSTERED 
(
	[pais_Codigo] ASC,
	[pais_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbPaises_pais_Nombre] UNIQUE NONCLUSTERED 
(
	[pais_Nombre] ASC,
	[pais_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbCondiciones]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbCondiciones](
	[codi_Id] [int] IDENTITY(1,1) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[codi_Restricciones_Utilizacion] [bit] NOT NULL,
	[codi_Indicar_Restricciones_Utilizacion] [nvarchar](500) NULL,
	[codi_Depende_Precio_Condicion] [bit] NOT NULL,
	[codi_Indicar_Existe_Condicion] [nvarchar](500) NULL,
	[codi_Condicionada_Revertir] [bit] NOT NULL,
	[codi_Vinculacion_Comprador_Vendedor] [bit] NOT NULL,
	[codi_Tipo_Vinculacion] [nvarchar](500) NULL,
	[codi_Vinculacion_Influye_Precio] [bit] NOT NULL,
	[codi_Pagos_Descuentos_Indirectos] [bit] NOT NULL,
	[codi_Concepto_Monto_Declarado] [nvarchar](500) NULL,
	[codi_Existen_Canones] [bit] NOT NULL,
	[codi_Indicar_Canones] [nvarchar](500) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[codi_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[codi_FechaModificacion] [datetime] NULL,
	[codi_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbCondiciones_codi_Id] PRIMARY KEY CLUSTERED 
(
	[codi_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbNivelesComerciales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbNivelesComerciales](
	[nico_Id] [int] IDENTITY(1,1) NOT NULL,
	[nico_Codigo] [char](3) NOT NULL,
	[nico_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[nico_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[nico_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[nico_FechaEliminacion] [datetime] NULL,
	[nico_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbNivelesComerciales_nico_Id] PRIMARY KEY CLUSTERED 
(
	[nico_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Adua_tbNivelesComerciales_nico_Codigo] UNIQUE NONCLUSTERED 
(
	[nico_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbNivelesComerciales_nico_Descripcion] UNIQUE NONCLUSTERED 
(
	[nico_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbFormas_Envio]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbFormas_Envio](
	[foen_Id] [int] IDENTITY(1,1) NOT NULL,
	[foen_Codigo] [char](2) NULL,
	[foen_Descripcion] [nvarchar](500) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[foen_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[foen_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[foen_FechaEliminacion] [datetime] NULL,
	[foen_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Gral_tbFormas_Envio_foen_Id] PRIMARY KEY CLUSTERED 
(
	[foen_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbFormas_Envio_foen_Codigo] UNIQUE NONCLUSTERED 
(
	[foen_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbFormas_Envio_foen_Descripcion] UNIQUE NONCLUSTERED 
(
	[foen_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbBaseCalculos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbBaseCalculos](
	[base_Id] [int] IDENTITY(1,1) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[base_PrecioFactura] [decimal](18, 2) NOT NULL,
	[base_PagosIndirectos] [decimal](18, 2) NOT NULL,
	[base_PrecioReal] [decimal](18, 2) NOT NULL,
	[base_MontCondicion] [decimal](18, 2) NOT NULL,
	[base_MontoReversion] [decimal](18, 2) NOT NULL,
	[base_ComisionCorrelaje] [decimal](18, 2) NOT NULL,
	[base_Gasto_Envase_Embalaje] [decimal](18, 2) NOT NULL,
	[base_ValoresMateriales_Incorporado] [decimal](18, 2) NOT NULL,
	[base_Valor_Materiales_Utilizados] [decimal](18, 2) NOT NULL,
	[base_Valor_Materiales_Consumidos] [decimal](18, 2) NOT NULL,
	[base_Valor_Ingenieria_Importado] [decimal](18, 2) NOT NULL,
	[base_Valor_Canones] [decimal](18, 2) NOT NULL,
	[base_Gasto_TransporteM_Importada] [decimal](18, 2) NOT NULL,
	[base_Gastos_Carga_Importada] [decimal](18, 2) NOT NULL,
	[base_Costos_Seguro] [decimal](18, 2) NOT NULL,
	[base_Total_Ajustes_Precio_Pagado] [decimal](18, 2) NOT NULL,
	[base_Gastos_Asistencia_Tecnica] [decimal](18, 2) NOT NULL,
	[base_Gastos_Transporte_Posterior] [decimal](18, 2) NOT NULL,
	[base_Derechos_Impuestos] [decimal](18, 2) NOT NULL,
	[base_Monto_Intereses] [decimal](18, 2) NOT NULL,
	[base_Deducciones_Legales] [decimal](18, 2) NOT NULL,
	[base_Total_Deducciones_Precio] [decimal](18, 2) NOT NULL,
	[base_Valor_Aduana] [decimal](18, 2) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[base_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[base_FechaModificacion] [datetime] NULL,
	[base_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbBaseCalculos_base_Id] PRIMARY KEY CLUSTERED 
(
	[base_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbCondicionesComerciales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbCondicionesComerciales](
	[coco_Id] [int] IDENTITY(1,1) NOT NULL,
	[coco_Codigo] [char](2) NOT NULL,
	[coco_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[coco_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[coco_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[coco_FechaEliminacion] [datetime] NULL,
	[coco_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbCondicionesComerciales_coco_Id] PRIMARY KEY CLUSTERED 
(
	[coco_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbFormasdePago]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbFormasdePago](
	[fopa_Id] [int] IDENTITY(1,1) NOT NULL,
	[fopa_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[fopa_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[fopa_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[fopa_FechaEliminacion] [datetime] NULL,
	[fopa_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbFormasdePago_fopa_Id] PRIMARY KEY CLUSTERED 
(
	[fopa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbFormasdePago_fopa_Descripcion] UNIQUE NONCLUSTERED 
(
	[fopa_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbMonedas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbMonedas](
	[mone_Id] [int] IDENTITY(1,1) NOT NULL,
	[mone_Codigo] [char](3) NULL,
	[mone_Descripcion] [nvarchar](500) NULL,
	[mone_EsAduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[mone_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[mone_FechaModificacion] [datetime] NULL,
	[mone_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Gral_tbMonedas_mone_Id] PRIMARY KEY CLUSTERED 
(
	[mone_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbMonedas_mone_Codigo] UNIQUE NONCLUSTERED 
(
	[mone_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbMonedas_mone_Descripcion] UNIQUE NONCLUSTERED 
(
	[mone_Descripcion] ASC,
	[mone_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDeclarantes]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDeclarantes](
	[decl_Id] [int] IDENTITY(1,1) NOT NULL,
	[decl_NumeroIdentificacion] [nvarchar](50) NULL,
	[decl_Nombre_Raso] [nvarchar](250) NOT NULL,
	[decl_Direccion_Exacta] [nvarchar](250) NOT NULL,
	[ciud_Id] [int] NOT NULL,
	[decl_Correo_Electronico] [nvarchar](150) NOT NULL,
	[decl_Telefono] [nvarchar](50) NOT NULL,
	[decl_Fax] [nvarchar](50) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[decl_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[decl_FechaModificacion] [datetime] NULL,
	[decl_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbDeclarantes_decl_Id] PRIMARY KEY CLUSTERED 
(
	[decl_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbProvincias]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbProvincias](
	[pvin_Id] [int] IDENTITY(1,1) NOT NULL,
	[pvin_Nombre] [nvarchar](150) NOT NULL,
	[pvin_Codigo] [nvarchar](20) NOT NULL,
	[pais_Id] [int] NOT NULL,
	[pvin_EsAduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pvin_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pvin_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[pvin_FechaEliminacion] [datetime] NULL,
	[pvin_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbProvincias_pvin_Id] PRIMARY KEY CLUSTERED 
(
	[pvin_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbProvincias_pvin_Codigo] UNIQUE NONCLUSTERED 
(
	[pvin_Codigo] ASC,
	[pvin_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_tbProvincias_pvin_Nombre_pvin_Codigo] UNIQUE NONCLUSTERED 
(
	[pvin_Codigo] ASC,
	[pvin_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImportadores]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImportadores](
	[impo_Id] [int] IDENTITY(1,1) NOT NULL,
	[nico_Id] [int] NULL,
	[decl_Id] [int] NOT NULL,
	[impo_NivelComercial_Otro] [nvarchar](300) NULL,
	[impo_RTN] [nvarchar](40) NOT NULL,
	[impo_NumRegistro] [nvarchar](40) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[impo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[impo_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[impo_FechaEliminacion] [datetime] NULL,
	[impo_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbImportadores_impo_Id] PRIMARY KEY CLUSTERED 
(
	[impo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTipoIntermediario]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTipoIntermediario](
	[tite_Id] [int] IDENTITY(1,1) NOT NULL,
	[tite_Codigo] [char](2) NOT NULL,
	[tite_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tite_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tite_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[tite_FechaEliminacion] [datetime] NULL,
	[tite_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbNivelesComerciales] PRIMARY KEY CLUSTERED 
(
	[tite_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTipoIntermediario] UNIQUE NONCLUSTERED 
(
	[tite_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTipoItermediario_tite_Codigo] UNIQUE NONCLUSTERED 
(
	[tite_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbIntermediarios]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbIntermediarios](
	[inte_Id] [int] IDENTITY(1,1) NOT NULL,
	[tite_Id] [int] NULL,
	[inte_Tipo_Otro] [nvarchar](30) NULL,
	[decl_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[inte_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[inte_FechaModificacion] [datetime] NULL,
	[inte_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbIntermediarios_inte_Id] PRIMARY KEY CLUSTERED 
(
	[inte_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbProveedoresDeclaracion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbProveedoresDeclaracion](
	[pvde_Id] [int] IDENTITY(1,1) NOT NULL,
	[coco_Id] [int] NULL,
	[pvde_Condicion_Otra] [nvarchar](300) NULL,
	[decl_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pvde_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pvde_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[pvde_FechaEliminacion] [datetime] NULL,
	[pvde_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbProveedoresDeclaracion_pvde_Id] PRIMARY KEY CLUSTERED 
(
	[pvde_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Acce].[tbUsuarios]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Acce].[tbUsuarios](
	[usua_Id] [int] IDENTITY(1,1) NOT NULL,
	[usua_Nombre] [nvarchar](100) NOT NULL,
	[usua_Contrasenia] [nvarchar](max) NOT NULL,
	[empl_Id] [int] NOT NULL,
	[usua_esAduana] [bit] NOT NULL,
	[usua_Image] [nvarchar](500) NULL,
	[role_Id] [int] NOT NULL,
	[usua_EsAdmin] [bit] NOT NULL,
	[pant_subCategoria] [nvarchar](150) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[usua_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[usua_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[usua_FechaEliminacion] [datetime] NULL,
	[usua_UsuarioActivacion] [int] NULL,
	[usua_FechaActivacion] [datetime] NULL,
	[usua_Estado] [bit] NULL,
 CONSTRAINT [PK_Acce_tbUsuarios_usua_Id] PRIMARY KEY CLUSTERED 
(
	[usua_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_acce_tbUsuarios_usua_Nombre_esAduana] UNIQUE NONCLUSTERED 
(
	[usua_Nombre] ASC,
	[usua_esAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbLugaresEmbarque]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbLugaresEmbarque](
	[emba_Id] [int] IDENTITY(1,1) NOT NULL,
	[emba_Codigo] [char](5) NULL,
	[emba_Descripcion] [nvarchar](200) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[emba_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[emba_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[emba_FechaEliminacion] [datetime] NULL,
	[emba_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbLugaresEmbarque_emba_Id] PRIMARY KEY CLUSTERED 
(
	[emba_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbLugaresEmbarque_prov_emba_Codigo] UNIQUE NONCLUSTERED 
(
	[emba_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbRegimenesAduaneros]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbRegimenesAduaneros](
	[regi_Id] [int] IDENTITY(1,1) NOT NULL,
	[regi_Codigo] [varchar](10) NULL,
	[regi_Descripcion] [nvarchar](500) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[regi_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[regi_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[regi_FechaEliminacion] [datetime] NULL,
	[regi_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbRegimenesAduaneros_regi_Id] PRIMARY KEY CLUSTERED 
(
	[regi_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbRegimenesAduaneros_regi_Codigo] UNIQUE NONCLUSTERED 
(
	[regi_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbRegimenesAduaneros_regi_Descripcion] UNIQUE NONCLUSTERED 
(
	[regi_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDeclaraciones_Valor]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDeclaraciones_Valor](
	[deva_Id] [int] IDENTITY(1,1) NOT NULL,
	[deva_AduanaIngresoId] [int] NOT NULL,
	[deva_AduanaDespachoId] [int] NOT NULL,
	[deva_DeclaracionMercancia] [nvarchar](500) NULL,
	[regi_Id] [int] NOT NULL,
	[deva_FechaAceptacion] [datetime] NULL,
	[impo_Id] [int] NULL,
	[pvde_Id] [int] NULL,
	[inte_Id] [int] NULL,
	[deva_LugarEntrega] [nvarchar](800) NULL,
	[pais_EntregaId] [int] NULL,
	[inco_Id] [int] NULL,
	[inco_Version] [nvarchar](10) NULL,
	[deva_NumeroContrato] [nvarchar](200) NULL,
	[deva_FechaContrato] [date] NULL,
	[foen_Id] [int] NULL,
	[deva_FormaEnvioOtra] [nvarchar](500) NULL,
	[deva_PagoEfectuado] [bit] NULL,
	[fopa_Id] [int] NULL,
	[deva_FormaPagoOtra] [nvarchar](200) NULL,
	[emba_Id] [int] NULL,
	[pais_ExportacionId] [int] NULL,
	[deva_FechaExportacion] [date] NULL,
	[mone_Id] [int] NULL,
	[mone_Otra] [nvarchar](200) NULL,
	[deva_ConversionDolares] [decimal](18, 2) NULL,
	[deva_Finalizacion] [bit] NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[deva_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[deva_FechaModificacion] [datetime] NULL,
	[deva_Estado] [bit] NOT NULL,
 CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_Id] PRIMARY KEY CLUSTERED 
(
	[deva_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [Adua].[VW_tbDeclaraciones_ValorCompleto]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************** DECLARACIÓN DE VALOR ******************************************--
/*Vista que trae todos los campos de la parte  1 del formulario de la declaración de valor, incluso los que están en 
  otras tablas conectadas a tbDeclaraciones_Valor (no se incluyen las facturas ni las condiciones)*/

CREATE     VIEW [Adua].[VW_tbDeclaraciones_ValorCompleto]
AS
SELECT		deva.deva_Id, 
			deva.deva_AduanaIngresoId, 
			aduaIngreso.adua_Codigo				AS adua_IngresoCodigo,
			aduaIngreso.adua_Nombre				AS adua_IngresoNombre,
			deva.deva_AduanaDespachoId, 
			aduaDespacho.adua_Codigo			AS adua_DespachoCodigo,
			aduaDespacho.adua_Nombre			AS adua_DespachoNombre,
			deva.deva_DeclaracionMercancia, 
			deva.deva_FechaAceptacion, 
			deva.deva_Finalizacion,
			deva.deva_PagoEfectuado, 
			deva.pais_ExportacionId, 
			paix.pais_Codigo + ' - ' + paix.pais_Nombre as pais_ExportacionNombre,
			deva.deva_FechaExportacion, 
			deva.mone_Id, 
			mone.mone_Codigo + ' - ' + mone.mone_Descripcion as monedaNombre,
			deva.mone_Otra, 
			deva.deva_ConversionDolares, 

			--Regimen Aduanero
			deva.regi_Id,
			regi.regi_Codigo,
			regi.regi_Descripcion,

			--Lugares de embarque
			deva.emba_Id,
			emba.emba_Codigo,
			emba.emba_Codigo +' - '+ emba.emba_Descripcion as LugarEmbarque,

			--Nivel comercial del importador
			impo.nico_Id,
			nico.nico_Descripcion,

			--datos del importador de la tabla de importador
			impo.impo_Id, 
			impo.impo_NumRegistro,
			impo.impo_RTN				        AS impo_RTN,
			impo.impo_NivelComercial_Otro,

			--Datos del importador pero de la tabla de declarantes
			declaImpo.decl_Nombre_Raso			AS impo_Nombre_Raso,
			declaImpo.decl_Direccion_Exacta		AS impo_Direccion_Exacta,
			declaImpo.decl_Correo_Electronico	AS impo_Correo_Electronico,
			declaImpo.decl_Telefono				AS impo_Telefono,
			declaImpo.decl_Fax					AS impo_Fax,			
			provimpo.pvin_Id					AS impo_ciudId,
			provimpo.pvin_Codigo + ' - ' + provimpo.pvin_Nombre AS impo_CiudadNombre,
			provimpo.pais_Id					AS impo_paisId,
			impoPais.pais_Codigo + ' - ' + impoPais.pais_Nombre AS impo_PaisNombre,
			

			--Condiciones comerciales del proveedor
			prov.coco_Id,			
			coco.coco_Descripcion,

			--Proveedor 		
			deva.pvde_Id,		
			declaProv.decl_NumeroIdentificacion AS prov_NumeroIdentificacion,
			declaProv.decl_Nombre_Raso			AS prov_Nombre_Raso,
			declaProv.decl_Direccion_Exacta		AS prov_Direccion_Exacta,
			declaProv.decl_Correo_Electronico	AS prov_Correo_Electronico,
			declaProv.decl_Telefono				AS prov_Telefono,
			declaProv.decl_Fax					AS prov_Fax,
			prov.pvde_Condicion_Otra,
			provprove.pvin_Id					AS prov_ciudId,
			provprove.pvin_Codigo + ' - ' + provprove.pvin_Nombre AS prov_CiudadNombre,
			provprove.pais_Id					AS prov_paisId,
			provPais.pais_Codigo + ' - ' + provPais.pais_Nombre AS prov_PaisNombre,
			
					
			--Tipo intermediario 
			inte.tite_Id,
			tite.tite_Codigo +' - '+ tite.tite_Descripcion as TipoIntermediario,
			 
			  --Datos intermediario tabla intermediario
			inte.inte_Id, 
			provInte.pvin_Id					AS inte_ciudId,
			provInte.pvin_Codigo + ' - ' + provInte.pvin_Nombre AS inte_CiudadNombre,
			provInte.pais_Id					AS inte_paisId,
			intePais.pais_Codigo + ' - ' + intePais.pais_Nombre AS inte_PaisNombre,
			inte.inte_Tipo_Otro,

			 --Datos intermediario tabla declarante
			declaInte.decl_NumeroIdentificacion AS inte_NumeroIdentificacion,
			declaInte.decl_Nombre_Raso			AS inte_Nombre_Raso,
			declaInte.decl_Direccion_Exacta		AS inte_Direccion_Exacta,
			declaInte.decl_Correo_Electronico	AS inte_Correo_Electronico,
			declaInte.decl_Telefono				AS inte_Telefono,
			declaInte.decl_Fax					AS inte_Fax,			
			


			deva.deva_LugarEntrega, 
			deva.pais_EntregaId, 
			pais.pais_Codigo + ' - ' + pais.pais_Nombre as pais_EntregaNombre,
			inco.inco_Id, 
			inco.inco_Descripcion,
			inco.inco_Codigo,
			deva.inco_Version, 
			deva.deva_NumeroContrato, 
			deva.deva_FechaContrato, 

			--Datos forma de envio
			foen.foen_Id, 
			foen.foen_Descripcion,
			deva.deva_FormaEnvioOtra, 

			--Datos forma de pago
			deva.fopa_Id, 
			fopa.fopa_Descripcion,
			deva.deva_FormaPagoOtra,  			
			
			
			----deva_Condiciones, 
            condi.codi_Id,
			condi.codi_Restricciones_Utilizacion, 
			condi.codi_Indicar_Restricciones_Utilizacion, 
			condi.codi_Depende_Precio_Condicion, 
			condi.codi_Indicar_Existe_Condicion, 
			condi.codi_Condicionada_Revertir, 
			condi.codi_Vinculacion_Comprador_Vendedor, 
			condi.codi_Tipo_Vinculacion, 
			condi.codi_Vinculacion_Influye_Precio, 
			condi.codi_Pagos_Descuentos_Indirectos, 
			condi.codi_Concepto_Monto_Declarado, 
			condi.codi_Existen_Canones, 
			condi.codi_Indicar_Canones, 

			----deva_Base Calculo, 
            bacu.base_Id,  
			bacu.base_PrecioFactura, 
			bacu.base_PagosIndirectos, 
			bacu.base_PrecioReal, 
			bacu.base_MontCondicion, 
			bacu.base_MontoReversion, 
			bacu.base_ComisionCorrelaje, 
			bacu.base_Gasto_Envase_Embalaje, 
			bacu.base_ValoresMateriales_Incorporado, 
			bacu.base_Valor_Materiales_Utilizados, 
			bacu.base_Valor_Materiales_Consumidos, 
			bacu.base_Valor_Ingenieria_Importado, 
			bacu.base_Valor_Canones, 
			bacu.base_Gasto_TransporteM_Importada, 
			bacu.base_Gastos_Carga_Importada, 
			bacu.base_Costos_Seguro, 
			bacu.base_Total_Ajustes_Precio_Pagado, 
			bacu.base_Gastos_Asistencia_Tecnica, 
			bacu.base_Gastos_Transporte_Posterior, 
			bacu.base_Derechos_Impuestos, 
			bacu.base_Monto_Intereses, 
			bacu.base_Deducciones_Legales, 
			bacu.base_Total_Deducciones_Precio, 
			bacu.base_Valor_Aduana,

			deva.usua_UsuarioCreacion, 
			usuaCrea.usua_Nombre				AS usua_CreacionNombre,
			deva.deva_FechaCreacion, 
			deva.usua_UsuarioModificacion		AS usua_ModificacionNombre,
			deva.deva_FechaModificacion, 
			deva.deva_Estado 
	FROM	Adua.tbDeclaraciones_Valor deva 
			LEFT JOIN Adua.tbAduanas aduaIngreso			ON deva.deva_AduanaIngresoId = aduaIngreso.adua_Id
			LEFT JOIN Adua.tbAduanas aduaDespacho			ON deva.deva_AduanaDespachoId = aduaDespacho.adua_Id
			LEFT JOIN Adua.tbImportadores impo				ON deva.impo_Id = impo.impo_Id
			LEFT JOIN Adua.tbDeclarantes declaImpo			ON impo.decl_Id = declaImpo.decl_Id
			LEFT JOIN Gral.tbProvincias provimpo            ON declaImpo.ciud_Id = provimpo.pvin_Id
			LEFT JOIN Gral.tbPaises impoPais                ON provimpo.pais_Id = impoPais.pais_Id
			LEFT JOIN Gral.tbMonedas mone                   ON deva.mone_Id = mone.mone_Id
			LEFT JOIN Adua.tbRegimenesAduaneros regi		ON deva.regi_Id = regi.regi_Id
			
			LEFT JOIN Adua.tbNivelesComerciales nico		ON impo.nico_Id = nico.nico_Id
			LEFT JOIN Adua.tbProveedoresDeclaracion prov	ON prov.pvde_Id = deva.pvde_Id
			LEFT JOIN Adua.tbDeclarantes declaProv			ON prov.decl_Id = declaProv.decl_Id
			LEFT JOIN Gral.tbProvincias provprove           ON declaProv.ciud_Id = provprove.pvin_Id
			LEFT JOIN Gral.tbPaises provPais                ON provprove.pais_Id = provPais.pais_Id


			LEFT JOIN Adua.tbCondicionesComerciales coco	ON prov.coco_Id = coco.coco_Id
			LEFT JOIN Adua.tbIntermediarios inte			ON inte.inte_Id = deva.inte_Id
			LEFT JOIN Adua.tbTipoIntermediario tite			ON inte.tite_Id = tite.tite_Id
			LEFT JOIN Adua.tbDeclarantes declaInte			ON declaInte.decl_Id = inte.decl_Id
			LEFT JOIN Gral.tbProvincias provInte            ON declaInte.ciud_Id = provInte.pvin_Id
			LEFT JOIN Gral.tbPaises intePais                ON provInte.pais_Id = intePais.pais_Id

			LEFT JOIN Adua.tbIncoterm inco					ON deva.inco_Id = inco.inco_Id
			LEFT JOIN Gral.tbFormas_Envio foen				ON deva.foen_Id = foen.foen_Id 
			LEFT JOIN Adua.tbFormasdePago fopa				ON deva.fopa_Id = fopa.fopa_Id
			LEFT JOIN Gral.tbPaises	pais					ON deva.pais_EntregaId = pais.pais_Id
			LEFT JOIN Gral.tbPaises	paix					ON deva.pais_ExportacionId	 = paix.pais_Id
			LEFT JOIN Adua.tbLugaresEmbarque emba			ON deva.emba_Id = emba.emba_Id 

			LEFT JOIN Adua.tbCondiciones condi              ON deva.deva_Id = condi.deva_Id
			LEFT JOIN Adua.tbBaseCalculos bacu               ON deva.deva_Id = bacu.deva_Id
			
			LEFT JOIN Acce.tbUsuarios usuaCrea				ON deva.usua_UsuarioCreacion = usuaCrea.usua_Id
			LEFT JOIN Acce.tbUsuarios usuaModifica			ON deva.usua_UsuarioModificacion = usuaModifica.usua_Id
GO
/****** Object:  Table [Acce].[tbPantallas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Acce].[tbPantallas](
	[pant_Id] [int] IDENTITY(1,1) NOT NULL,
	[pant_Nombre] [nvarchar](100) NULL,
	[pant_URL] [nvarchar](100) NULL,
	[pant_Identificador] [nvarchar](500) NULL,
	[pant_Icono] [nvarchar](50) NULL,
	[pant_Subcategoria] [nvarchar](500) NULL,
	[pant_Esquema] [nvarchar](100) NULL,
	[pant_EsAduana] [bit] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pant_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pant_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[pant_FechaEliminacion] [datetime] NULL,
	[pant_Estado] [bit] NULL,
 CONSTRAINT [PK_Acce_tbPantallas_pant_Id] PRIMARY KEY CLUSTERED 
(
	[pant_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_pant_Identificador] UNIQUE NONCLUSTERED 
(
	[pant_Identificador] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Acce].[tbRoles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Acce].[tbRoles](
	[role_Id] [int] IDENTITY(1,1) NOT NULL,
	[role_Descripcion] [nvarchar](500) NULL,
	[role_Aduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[role_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[role_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[role_FechaEliminacion] [datetime] NULL,
	[role_Estado] [bit] NULL,
 CONSTRAINT [PK_Acce_tbRoles_role_Id] PRIMARY KEY CLUSTERED 
(
	[role_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_acce_tbRoles_role_Descripcion] UNIQUE NONCLUSTERED 
(
	[role_Descripcion] ASC,
	[role_Aduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Acce].[tbRolesXPantallas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Acce].[tbRolesXPantallas](
	[ropa_Id] [int] IDENTITY(1,1) NOT NULL,
	[pant_Id] [int] NULL,
	[role_Id] [int] NULL,
	[pant_Identificador] [nvarchar](max) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ropa_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ropa_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[ropa_FechaEliminacion] [datetime] NULL,
	[ropa_Estado] [bit] NULL,
 CONSTRAINT [PK_Acce_tbRolesXPantallas_ropa_Id] PRIMARY KEY CLUSTERED 
(
	[ropa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Acce_tbRolesXPantallas_pant_Id_role_Id] UNIQUE NONCLUSTERED 
(
	[role_Id] ASC,
	[pant_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Acce].[tbUsuariosHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Acce].[tbUsuariosHistorial](
	[hist_Id] [int] IDENTITY(1,1) NOT NULL,
	[usua_Id] [int] NULL,
	[usua_Nombre] [nvarchar](100) NULL,
	[usua_Contrasenia] [nvarchar](max) NULL,
	[empl_Id] [int] NULL,
	[usua_esAduana] [bit] NULL,
	[usua_Image] [nvarchar](500) NULL,
	[role_Id] [int] NULL,
	[usua_EsAdmin] [bit] NOT NULL,
	[hist_UsuarioAccion] [int] NULL,
	[hist_FechaAccion] [datetime] NOT NULL,
	[hist_Accion] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbAranceles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbAranceles](
	[aran_Id] [int] IDENTITY(1,1) NOT NULL,
	[aran_Codigo] [nvarchar](100) NOT NULL,
	[aran_Descripcion] [nvarchar](max) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[aran_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[aran_FechaModificacion] [datetime] NULL,
	[aram_Estado] [bit] NOT NULL,
	[aran_DAI] [decimal](18, 2) NULL,
	[aran_SEL] [decimal](18, 2) NULL,
	[aran_ISV] [decimal](18, 2) NULL,
	[aran_ProdCons] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Adua_tbAranceles_aran_Id] PRIMARY KEY CLUSTERED 
(
	[aran_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbAranceles_aran_Codigo] UNIQUE NONCLUSTERED 
(
	[aran_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbArancelesPorTratados]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbArancelesPorTratados](
	[axtl_Id] [int] IDENTITY(1,1) NOT NULL,
	[aran_Id] [int] NOT NULL,
	[trli_Id] [int] NOT NULL,
	[axtl_TasaActual] [decimal](18, 4) NOT NULL,
	[usua_usuarioCreacion] [int] NOT NULL,
	[axtl_FechaCreacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbArancelesPorTratados_axtl_Id] PRIMARY KEY CLUSTERED 
(
	[axtl_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbBaseCalculosHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbBaseCalculosHistorial](
	[hbas_Id] [int] IDENTITY(1,1) NOT NULL,
	[base_Id] [int] NULL,
	[deva_Id] [int] NOT NULL,
	[base_PrecioFactura] [decimal](18, 2) NOT NULL,
	[base_PagosIndirectos] [decimal](18, 2) NOT NULL,
	[base_PrecioReal] [decimal](18, 2) NOT NULL,
	[base_MontCondicion] [decimal](18, 2) NOT NULL,
	[base_MontoReversion] [decimal](18, 2) NOT NULL,
	[base_ComisionCorrelaje] [decimal](18, 2) NOT NULL,
	[base_Gasto_Envase_Embalaje] [decimal](18, 2) NOT NULL,
	[base_ValoresMateriales_Incorporado] [decimal](18, 2) NOT NULL,
	[base_Valor_Materiales_Utilizados] [decimal](18, 2) NOT NULL,
	[base_Valor_Materiales_Consumidos] [decimal](18, 2) NOT NULL,
	[base_Valor_Ingenieria_Importado] [decimal](18, 2) NOT NULL,
	[base_Valor_Canones] [decimal](18, 2) NOT NULL,
	[base_Gasto_TransporteM_Importada] [decimal](18, 2) NOT NULL,
	[base_Gastos_Carga_Importada] [decimal](18, 2) NOT NULL,
	[base_Costos_Seguro] [decimal](18, 2) NOT NULL,
	[base_Total_Ajustes_Precio_Pagado] [decimal](18, 2) NOT NULL,
	[base_Gastos_Asistencia_Tecnica] [decimal](18, 2) NOT NULL,
	[base_Gastos_Transporte_Posterior] [decimal](18, 2) NOT NULL,
	[base_Derechos_Impuestos] [decimal](18, 2) NOT NULL,
	[base_Monto_Intereses] [decimal](18, 2) NOT NULL,
	[base_Deducciones_Legales] [decimal](18, 2) NOT NULL,
	[base_Total_Deducciones_Precio] [decimal](18, 2) NOT NULL,
	[base_Valor_Aduana] [decimal](18, 2) NOT NULL,
	[hbas_UsuarioAccion] [int] NULL,
	[hbas_FechaAccion] [datetime] NULL,
	[hbas_Accion] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbBoletinPago]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbBoletinPago](
	[boen_Id] [int] IDENTITY(1,1) NOT NULL,
	[liqu_Id] [int] NOT NULL,
	[duca_No_Duca] [nvarchar](100) NULL,
	[tipl_Id] [int] NOT NULL,
	[boen_FechaEmision] [date] NOT NULL,
	[esbo_Id] [int] NOT NULL,
	[boen_Observaciones] [nvarchar](200) NOT NULL,
	[boen_NDeclaracion] [nvarchar](200) NOT NULL,
	[boen_Preimpreso] [nvarchar](max) NOT NULL,
	[boen_TotalPagar] [decimal](18, 2) NULL,
	[boen_TotalGarantizar] [decimal](18, 2) NULL,
	[coim_Id] [int] NOT NULL,
	[copa_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[boen_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[boen_FechaModificacion] [datetime] NULL,
	[boen_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbBoletinPago_boen_Id] PRIMARY KEY CLUSTERED 
(
	[boen_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbBoletinPagoDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbBoletinPagoDetalles](
	[bode_Id] [int] IDENTITY(1,1) NOT NULL,
	[boen_Id] [int] NOT NULL,
	[lige_Id] [int] NOT NULL,
	[bode_Concepto] [varchar](50) NOT NULL,
	[bode_TipoObligacion] [varchar](50) NOT NULL,
	[bode_CuentaPA01] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[bode_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[bode_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Adua_tbBoletinPagoDetalles_bode_Id] PRIMARY KEY CLUSTERED 
(
	[bode_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbCodigoImpuesto]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbCodigoImpuesto](
	[coim_Id] [int] IDENTITY(1,1) NOT NULL,
	[coim_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[coim_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[coim_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[coim_FechaEliminacion] [datetime] NULL,
	[coim_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbCodigoImpuesto_coim_Id] PRIMARY KEY CLUSTERED 
(
	[coim_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbCodigoImpuesto_coim_Descripcion] UNIQUE NONCLUSTERED 
(
	[coim_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbComercianteIndividual]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbComercianteIndividual](
	[coin_Id] [int] IDENTITY(1,1) NOT NULL,
	[pers_Id] [int] NOT NULL,
	[pers_FormaRepresentacion] [bit] NOT NULL,
	[ciud_Id] [int] NULL,
	[alde_Id] [int] NULL,
	[colo_Id] [int] NULL,
	[coin_NumeroLocalApart] [nvarchar](150) NULL,
	[coin_coloniaIdRepresentante] [int] NULL,
	[coin_NumeroLocaDepartRepresentante] [nvarchar](150) NULL,
	[coin_PuntoReferencia] [nvarchar](200) NULL,
	[coin_CiudadRepresentante] [int] NULL,
	[coin_AldeaRepresentante] [int] NULL,
	[coin_PuntoReferenciaReprentante] [nvarchar](200) NULL,
	[coin_TelefonoCelular] [nvarchar](20) NULL,
	[coin_TelefonoFijo] [nvarchar](20) NULL,
	[coin_CorreoElectronico] [nvarchar](30) NULL,
	[coin_CorreoElectronicoAlternativo] [nvarchar](30) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[coin_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[coin_FechaModificacion] [datetime] NULL,
	[coin_Estado] [bit] NULL,
	[coin_Finalizacion] [bit] NULL,
 CONSTRAINT [PK_Adua_tbComercianteIndividual_coin_Id] PRIMARY KEY CLUSTERED 
(
	[coin_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbConceptoPago]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbConceptoPago](
	[copa_Id] [int] IDENTITY(1,1) NOT NULL,
	[copa_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[copa_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[copa_FechaModificacion] [datetime] NULL,
	[copa_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbConceptoPago_copa_Id] PRIMARY KEY CLUSTERED 
(
	[copa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbConceptoPago_copa_Descripcion] UNIQUE NONCLUSTERED 
(
	[copa_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbCondicionesHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbCondicionesHistorial](
	[hcod_Id] [int] IDENTITY(1,1) NOT NULL,
	[codi_Id] [int] NULL,
	[deva_Id] [int] NULL,
	[codi_Restricciones_Utilizacion] [bit] NULL,
	[codi_Indicar_Restricciones_Utilizacion] [nvarchar](500) NULL,
	[codi_Depende_Precio_Condicion] [bit] NULL,
	[codi_Indicar_Existe_Condicion] [nvarchar](500) NULL,
	[codi_Condicionada_Revertir] [bit] NULL,
	[codi_Vinculacion_Comprador_Vendedor] [bit] NULL,
	[codi_Tipo_Vinculacion] [nvarchar](500) NULL,
	[codi_Vinculacion_Influye_Precio] [bit] NULL,
	[codi_Pagos_Descuentos_Indirectos] [bit] NULL,
	[codi_Concepto_Monto_Declarado] [nvarchar](500) NULL,
	[codi_Existen_Canones] [bit] NULL,
	[codi_Indicar_Canones] [nvarchar](500) NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[codi_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[codi_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[codi_FechaEliminacion] [datetime] NULL,
	[codi_Estado] [bit] NULL,
	[hcod_UsuarioAccion] [int] NULL,
	[hcod_FechaAccion] [datetime] NULL,
	[hcod_Accion] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbConductor]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbConductor](
	[cont_Id] [int] IDENTITY(1,1) NOT NULL,
	[cont_NoIdentificacion] [varchar](50) NOT NULL,
	[cont_Nombre] [nvarchar](200) NOT NULL,
	[cont_Apellido] [nvarchar](200) NOT NULL,
	[cont_Licencia] [nvarchar](50) NOT NULL,
	[pais_IdExpedicion] [int] NULL,
	[tran_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[cont_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[cont_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[cont_FechaEliminacion] [datetime] NULL,
	[cont_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbConductor_cont_Id] PRIMARY KEY CLUSTERED 
(
	[cont_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDeclaraciones_ValorHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDeclaraciones_ValorHistorial](
	[hdev_Id] [int] IDENTITY(1,1) NOT NULL,
	[deva_Id] [int] NULL,
	[deva_AduanaIngresoId] [int] NOT NULL,
	[deva_AduanaDespachoId] [int] NOT NULL,
	[deva_DeclaracionMercancia] [nvarchar](500) NULL,
	[deva_FechaAceptacion] [datetime] NULL,
	[impo_Id] [int] NULL,
	[pvde_Id] [int] NULL,
	[inte_Id] [int] NULL,
	[deva_LugarEntrega] [nvarchar](800) NULL,
	[pais_EntregaId] [int] NULL,
	[inco_Id] [int] NULL,
	[inco_Version] [nvarchar](10) NULL,
	[deva_NumeroContrato] [nvarchar](200) NULL,
	[deva_FechaContrato] [date] NULL,
	[foen_Id] [int] NULL,
	[deva_FormaEnvioOtra] [nvarchar](500) NULL,
	[deva_PagoEfectuado] [bit] NULL,
	[fopa_Id] [int] NULL,
	[deva_FormaPagoOtra] [nvarchar](200) NULL,
	[emba_Id] [int] NULL,
	[pais_ExportacionId] [int] NULL,
	[deva_FechaExportacion] [date] NULL,
	[mone_Id] [int] NULL,
	[mone_Otra] [nvarchar](200) NULL,
	[deva_ConversionDolares] [decimal](18, 2) NULL,
	[deva_Condiciones] [nvarchar](max) NULL,
	[hdev_UsuarioAccion] [int] NULL,
	[hdev_FechaAccion] [datetime] NULL,
	[hdev_Accion] [nvarchar](100) NULL,
 CONSTRAINT [PK_Adua_tbDeclaraciones_ValorHistorial_hdev_Id] PRIMARY KEY CLUSTERED 
(
	[hdev_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDeclarantesHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDeclarantesHistorial](
	[hdec_Id] [int] IDENTITY(1,1) NOT NULL,
	[decl_Id] [int] NULL,
	[decl_NumeroIdentificacion] [nvarchar](50) NULL,
	[decl_Nombre_Raso] [nvarchar](250) NOT NULL,
	[decl_Direccion_Exacta] [nvarchar](250) NOT NULL,
	[ciud_Id] [int] NOT NULL,
	[decl_Correo_Electronico] [nvarchar](150) NOT NULL,
	[decl_Telefono] [nvarchar](50) NOT NULL,
	[decl_Fax] [nvarchar](50) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[decl_FechaCreacion] [datetime] NOT NULL,
	[hdec_UsuarioModificacion] [int] NOT NULL,
	[hdec_FechaModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbDeclarantesHistorial_hdec_Id] PRIMARY KEY CLUSTERED 
(
	[hdec_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDocumentosContratos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDocumentosContratos](
	[doco_Id] [int] IDENTITY(1,1) NOT NULL,
	[coin_Id] [int] NULL,
	[peju_Id] [int] NULL,
	[doco_Numero_O_Referencia] [nvarchar](50) NOT NULL,
	[doco_TipoDocumento] [nvarchar](7) NULL,
	[doco_URLImagen] [nvarchar](max) NULL,
	[doco_NombreImagen] [nvarchar](350) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[doco_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[doco_FechaModificacion] [datetime] NULL,
	[doco_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbDocumentosContratos_doco_Id] PRIMARY KEY CLUSTERED 
(
	[doco_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDocumentosDeSoporte]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDocumentosDeSoporte](
	[doso_Id] [int] IDENTITY(1,1) NOT NULL,
	[tido_Id] [int] NOT NULL,
	[duca_Id] [int] NOT NULL,
	[doso_NumeroDocumento] [nvarchar](15) NOT NULL,
	[doso_FechaEmision] [date] NULL,
	[doso_FechaVencimiento] [date] NULL,
	[doso_PaisEmision] [int] NULL,
	[doso_LineaAplica] [char](4) NULL,
	[doso_EntidadEmitioDocumento] [nvarchar](75) NULL,
	[doso_Monto] [nvarchar](50) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[doso_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[doso_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[doso_FechaEliminacion] [datetime] NULL,
	[doso_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbDocumentosDeSoporte_doso_Id] PRIMARY KEY CLUSTERED 
(
	[doso_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDocumentosPDF]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDocumentosPDF](
	[dpdf_Id] [int] IDENTITY(1,1) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[dpdf_CA] [nvarchar](200) NOT NULL,
	[dpdf_DVA] [nvarchar](200) NOT NULL,
	[dpdf_DUCA] [nvarchar](200) NOT NULL,
	[dpdf_Boletin] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[dpdf_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[dpdf_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[dpdf_FechaEliminacion] [datetime] NULL,
	[dpdf_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbDocumentosPDF_dpdf_Id] PRIMARY KEY CLUSTERED 
(
	[dpdf_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDocumentosPDFHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDocumentosPDFHistorial](
	[hpdf_Id] [int] IDENTITY(1,1) NOT NULL,
	[dpdf_Id] [int] NULL,
	[deva_Id] [int] NOT NULL,
	[dpdf_CA] [nvarchar](200) NOT NULL,
	[dpdf_DVA] [nvarchar](200) NOT NULL,
	[dpdf_DUCA] [nvarchar](200) NOT NULL,
	[dpdf_Boletin] [nvarchar](200) NOT NULL,
	[hpdf_UsuarioAccion] [int] NULL,
	[hpdf_FechaAccion] [datetime] NULL,
	[hpdf_Accion] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDocumentosSanciones]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDocumentosSanciones](
	[dosa_Id] [int] IDENTITY(1,1) NOT NULL,
	[dosa_NombreDocumento] [nvarchar](150) NOT NULL,
	[dosa_UrlDocumento] [nvarchar](250) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[dosa_FechaCreacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbDocumentosSanciones_dosa_Id] PRIMARY KEY CLUSTERED 
(
	[dosa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDuca]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDuca](
	[duca_Id] [int] IDENTITY(1,1) NOT NULL,
	[duca_No_Duca] [nvarchar](100) NULL,
	[duca_No_Correlativo_Referencia] [nvarchar](max) NULL,
	[deva_Id] [int] NULL,
	[duca_AduanaRegistro] [int] NULL,
	[duca_AduanaDestino] [int] NULL,
	[duca_DomicilioFiscal_Exportador] [nvarchar](max) NULL,
	[duca_Tipo_Iden_Exportador] [int] NULL,
	[duca_Pais_Emision_Exportador] [int] NULL,
	[duca_Numero_Id_Importador] [nvarchar](100) NULL,
	[duca_Pais_Emision_Importador] [int] NULL,
	[duca_DomicilioFiscal_Importador] [nvarchar](max) NULL,
	[duca_Regimen_Aduanero] [int] NULL,
	[duca_Modalidad] [nvarchar](max) NULL,
	[duca_Clase] [nvarchar](max) NULL,
	[duca_Codigo_Declarante] [nvarchar](200) NULL,
	[duca_Numero_Id_Declarante] [nvarchar](200) NULL,
	[duca_NombreSocial_Declarante] [nvarchar](max) NULL,
	[duca_DomicilioFiscal_Declarante] [nvarchar](max) NULL,
	[duca_Pais_Procedencia] [int] NULL,
	[duca_Pais_Exportacion] [int] NULL,
	[duca_Pais_Destino] [int] NULL,
	[duca_Deposito_Aduanero] [nvarchar](max) NULL,
	[duca_Lugar_Desembarque] [int] NULL,
	[duca_Manifiesto] [nvarchar](max) NULL,
	[duca_Titulo] [nvarchar](max) NULL,
	[duca_Codigo_Transportista] [nvarchar](200) NULL,
	[duca_PesoBrutoTotal] [decimal](20, 8) NULL,
	[duca_PesoNetoTotal] [decimal](20, 8) NULL,
	[motr_Id] [int] NULL,
	[duca_Transportista_Nombre] [nvarchar](max) NULL,
	[duca_Conductor_Id] [int] NULL,
	[duca_Codigo_Tipo_Documento] [char](3) NULL,
	[duca_FechaVencimiento] [date] NULL,
	[duca_CanalAsignado] [char](1) NULL,
	[duca_Ventaja] [nvarchar](100) NULL,
	[duca_Finalizado] [bit] NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[duca_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[duca_FechaModificacion] [datetime] NULL,
	[duca_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbDuca_duca_No_Duca] PRIMARY KEY CLUSTERED 
(
	[duca_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbDucaHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbDucaHistorial](
	[hduc_Id] [int] IDENTITY(1,1) NOT NULL,
	[duca_No_Duca] [nvarchar](100) NULL,
	[duca_No_Correlativo_Referencia] [nvarchar](max) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[duca_AduanaRegistro] [int] NOT NULL,
	[duca_AduanaSalida] [int] NOT NULL,
	[duca_DomicilioFiscal_Exportador] [nvarchar](max) NOT NULL,
	[duca_Tipo_Iden_Exportador] [nvarchar](100) NOT NULL,
	[duca_Pais_Emision_Exportador] [int] NOT NULL,
	[duca_Numero_Id_Importador] [nvarchar](100) NOT NULL,
	[duca_Pais_Emision_Importador] [int] NOT NULL,
	[duca_DomicilioFiscal_Importador] [nvarchar](max) NOT NULL,
	[duca_Regimen_Aduanero] [nvarchar](max) NOT NULL,
	[duca_Modalidad] [nvarchar](max) NOT NULL,
	[duca_Clase] [nvarchar](max) NOT NULL,
	[duca_Codigo_Declarante] [nvarchar](200) NOT NULL,
	[duca_Numero_Id_Declarante] [nvarchar](200) NOT NULL,
	[duca_NombreSocial_Declarante] [nvarchar](max) NOT NULL,
	[duca_DomicilioFiscal_Declarante] [nvarchar](max) NOT NULL,
	[duca_Pais_Procedencia] [int] NOT NULL,
	[duca_Pais_Exportacion] [int] NOT NULL,
	[duca_Pais_Destino] [int] NOT NULL,
	[duca_Deposito_Aduanero] [nvarchar](max) NOT NULL,
	[duca_Lugar_Embarque] [nvarchar](max) NOT NULL,
	[duca_Lugar_Desembarque] [nvarchar](max) NOT NULL,
	[duca_Manifiesto] [nvarchar](max) NOT NULL,
	[duca_Titulo] [nvarchar](max) NOT NULL,
	[duca_Codigo_Transportista] [nvarchar](200) NULL,
	[motr_id] [int] NULL,
	[duca_Transportista_Nombre] [nvarchar](max) NULL,
	[duca_Conductor_Id] [int] NULL,
	[duca_Codigo_Tipo_Documento] [char](3) NOT NULL,
	[hduc_UsuarioAccion] [int] NULL,
	[hduc_FechaAccion] [datetime] NOT NULL,
	[hduc_Accion] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbEstadoBoletin]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbEstadoBoletin](
	[esbo_Id] [int] IDENTITY(1,1) NOT NULL,
	[esbo_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[esbo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[esbo_FechaModificacion] [datetime] NULL,
	[esbo_Estadoo] [bit] NULL,
 CONSTRAINT [PK_Adua_tbEstadoBoletin_esbo_Id] PRIMARY KEY CLUSTERED 
(
	[esbo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbEstadoBoletin_esbo_Descripcion] UNIQUE NONCLUSTERED 
(
	[esbo_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbEstadoMercancias]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbEstadoMercancias](
	[merc_Id] [int] IDENTITY(1,1) NOT NULL,
	[merc_Codigo] [char](2) NULL,
	[merc_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[merc_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[merc_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[merc_FechaEliminacion] [datetime] NULL,
	[merc_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbEstadoMercancias_merc_Id] PRIMARY KEY CLUSTERED 
(
	[merc_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbEstadoMercancias_merc_Codigo] UNIQUE NONCLUSTERED 
(
	[merc_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbEstadoMercancias_merc_Descripcion] UNIQUE NONCLUSTERED 
(
	[merc_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbFacturas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbFacturas](
	[fact_Id] [int] IDENTITY(1,1) NOT NULL,
	[fact_Numero] [nvarchar](4000) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[fact_Fecha] [date] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[fact_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[fact_FechaModificacion] [datetime] NULL,
	[fact_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbFactura_fact_Id] PRIMARY KEY CLUSTERED 
(
	[fact_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbFacturasHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbFacturasHistorial](
	[hfact_Id] [int] IDENTITY(1,1) NOT NULL,
	[fact_Id] [int] NOT NULL,
	[fact_Numero] [nvarchar](4000) NOT NULL,
	[deva_Id] [int] NOT NULL,
	[fect_Fecha] [datetime] NOT NULL,
	[hfact_UsuarioAccion] [int] NULL,
	[hfact_FechaAccion] [datetime] NULL,
	[hfact_Accion] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImportadoresHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImportadoresHistorial](
	[himp_Id] [int] IDENTITY(1,1) NOT NULL,
	[impo_Id] [int] NOT NULL,
	[nico_Id] [int] NOT NULL,
	[decl_Id] [int] NOT NULL,
	[impo_NivelComercial_Otro] [nvarchar](300) NULL,
	[impo_RTN] [nvarchar](40) NOT NULL,
	[impo_NumRegistro] [nvarchar](40) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[impo_FechaCreacion] [datetime] NOT NULL,
	[himp_UsuarioModificacion] [int] NOT NULL,
	[himp_FechaModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbImportadoresHistorial_himp_Id] PRIMARY KEY CLUSTERED 
(
	[himp_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImpuestoProduccionComsumoCondiciones]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones](
	[ipcc_Id] [int] IDENTITY(1,1) NOT NULL,
	[aran_Id] [int] NULL,
	[ipcc_Impuesto] [decimal](18, 2) NULL,
	[ipcc_Unidad] [decimal](18, 2) NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[ipcc_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ipcc_FechaModificacion] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImpuestos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImpuestos](
	[impu_Id] [int] IDENTITY(1,1) NOT NULL,
	[impu_Descripcion] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[impu_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[impu_FechaModificacion] [datetime] NULL,
	[impu_Estado] [bit] NOT NULL,
	[impu_Cantidad] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Adua_tbImpuestos_impu_Id] PRIMARY KEY CLUSTERED 
(
	[impu_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbImpuestos_impu_Descripcion] UNIQUE NONCLUSTERED 
(
	[impu_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos](
	[selh_Id] [int] IDENTITY(1,1) NOT NULL,
	[aran_Id] [int] NULL,
	[selh_EsNuevo] [bit] NULL,
	[selh_EsHibrido] [bit] NULL,
	[selh_RangoInicio] [decimal](18, 2) NULL,
	[selh_RangoFin] [decimal](18, 2) NULL,
	[selh_ImpuestoCobrar] [decimal](18, 2) NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[selh_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[selh_FechaModificacion] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbImpuestosPorArancel]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbImpuestosPorArancel](
	[imar_Id] [int] IDENTITY(1,1) NOT NULL,
	[impu_Id] [int] NOT NULL,
	[aran_Id] [int] NOT NULL,
	[imar_PorcentajeImpuesto] [decimal](18, 2) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[imar_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[imar_FechaModificacion] [datetime] NULL,
	[imar_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbImpuestosPorArancel_imar_Id] PRIMARY KEY CLUSTERED 
(
	[imar_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbIntermediariosHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbIntermediariosHistorial](
	[hint_Id] [int] IDENTITY(1,1) NOT NULL,
	[inte_Id] [int] NOT NULL,
	[tite_Id] [int] NOT NULL,
	[inte_Tipo_Otro] [nvarchar](30) NULL,
	[decl_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[inte_FechaCreacion] [datetime] NOT NULL,
	[himp_UsuarioModificacion] [int] NOT NULL,
	[himp_FechaModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbIntermediariosHistorial_hint_Id] PRIMARY KEY CLUSTERED 
(
	[hint_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbItems]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbItems](
	[item_Id] [int] IDENTITY(1,1) NOT NULL,
	[fact_Id] [int] NOT NULL,
	[item_Cantidad] [int] NOT NULL,
	[item_PesoNeto] [decimal](18, 2) NULL,
	[item_PesoBruto] [decimal](18, 2) NULL,
	[unme_Id] [int] NOT NULL,
	[item_IdentificacionComercialMercancias] [nvarchar](300) NOT NULL,
	[item_CaracteristicasMercancias] [nvarchar](400) NOT NULL,
	[item_Marca] [nvarchar](50) NOT NULL,
	[item_Modelo] [nvarchar](100) NOT NULL,
	[merc_Id] [int] NOT NULL,
	[pais_IdOrigenMercancia] [int] NULL,
	[item_Cantidad_Bultos] [int] NULL,
	[item_ClaseBulto] [nvarchar](100) NULL,
	[item_Acuerdo] [nvarchar](100) NULL,
	[item_ClasificacionArancelaria] [char](16) NULL,
	[item_ValorUnitario] [decimal](18, 2) NULL,
	[item_GastosDeTransporte] [decimal](18, 2) NULL,
	[item_ValorTransaccion] [decimal](18, 2) NULL,
	[item_Seguro] [decimal](18, 2) NULL,
	[item_OtrosGastos] [decimal](18, 2) NULL,
	[item_ValorAduana] [decimal](18, 2) NULL,
	[aran_Id] [int] NULL,
	[item_CuotaContingente] [decimal](18, 2) NULL,
	[item_ReglasAccesorias] [nvarchar](max) NULL,
	[item_CriterioCertificarOrigen] [nvarchar](max) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[item_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[item_FechaModificacion] [datetime] NULL,
	[item_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbItems_item_Id] PRIMARY KEY CLUSTERED 
(
	[item_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbItemsDEVAPorDuca]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbItemsDEVAPorDuca](
	[dedu_Id] [int] IDENTITY(1,1) NOT NULL,
	[duca_Id] [int] NULL,
	[deva_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[dedu_FechaCreacion] [datetime] NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[dedu_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Adua_tbItemsDEVAPorDuca_dedu_Id] PRIMARY KEY CLUSTERED 
(
	[dedu_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbItemsHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbItemsHistorial](
	[hite_Id] [int] IDENTITY(1,1) NOT NULL,
	[item_Id] [int] NULL,
	[fact_Id] [int] NULL,
	[item_Cantidad] [int] NULL,
	[item_PesoNeto] [decimal](18, 2) NULL,
	[item_PesoBruto] [decimal](18, 2) NULL,
	[unme_Id] [int] NULL,
	[item_IdentificacionComercialMercancias] [nvarchar](300) NULL,
	[item_CaracteristicasMercancias] [nvarchar](400) NULL,
	[item_Marca] [nvarchar](50) NULL,
	[item_Modelo] [nvarchar](100) NULL,
	[merc_Id] [int] NULL,
	[pais_IdOrigenMercancia] [int] NULL,
	[item_ClasificacionArancelaria] [char](16) NULL,
	[item_ValorUnitario] [decimal](18, 2) NULL,
	[item_GastosDeTransporte] [decimal](18, 2) NULL,
	[item_ValorTransaccion] [decimal](18, 2) NULL,
	[item_Seguro] [decimal](18, 2) NULL,
	[item_OtrosGastos] [decimal](18, 2) NULL,
	[item_ValorAduana] [decimal](18, 2) NULL,
	[item_CuotaContingente] [decimal](18, 2) NULL,
	[item_ReglasAccesorias] [nvarchar](max) NULL,
	[item_CriterioCertificarOrigen] [nvarchar](max) NULL,
	[hduc_UsuarioAccion] [int] NULL,
	[hduc_FechaAccion] [datetime] NULL,
	[hduc_Accion] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbLiquidacionGeneral]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbLiquidacionGeneral](
	[lige_Id] [int] IDENTITY(1,1) NOT NULL,
	[lige_TipoTributo] [nvarchar](50) NOT NULL,
	[lige_TotalPorTributo] [nvarchar](25) NOT NULL,
	[lige_ModalidadPago] [nvarchar](55) NOT NULL,
	[lige_TotalGral] [nvarchar](50) NULL,
	[duca_Id] [int] NOT NULL,
 CONSTRAINT [PK_Adua_tbLiquidacionGeneral_lige_Id] PRIMARY KEY CLUSTERED 
(
	[lige_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbLiquidacionGeneralHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbLiquidacionGeneralHistorial](
	[hlig_Id] [int] IDENTITY(1,1) NOT NULL,
	[lige_Id] [int] NULL,
	[lige_TipoTributo] [decimal](18, 2) NULL,
	[lige_TotalPorTributo] [nvarchar](25) NULL,
	[lige_ModalidadPago] [nvarchar](55) NULL,
	[lige_TotalGral] [decimal](18, 2) NULL,
	[duca_Id] [nvarchar](100) NULL,
	[hlig_UsuarioAccion] [int] NULL,
	[hlig_FechaAccion] [datetime] NOT NULL,
	[hlig_Accion] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbLiquidacionPorLinea]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbLiquidacionPorLinea](
	[lili_Id] [int] IDENTITY(1,1) NOT NULL,
	[lili_Tipo] [nvarchar](100) NULL,
	[lili_Alicuota] [decimal](18, 2) NULL,
	[lili_Total] [decimal](18, 2) NULL,
	[lili_ModalidadPago] [nvarchar](150) NULL,
	[lili_TotalGral] [decimal](18, 2) NULL,
	[item_Id] [int] NOT NULL,
 CONSTRAINT [PK_Adua_tbLiquidacionPorLinea_lili_Id] PRIMARY KEY CLUSTERED 
(
	[lili_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbMarcas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbMarcas](
	[marc_Id] [int] IDENTITY(1,1) NOT NULL,
	[marc_Descripcion] [nvarchar](20) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[marc_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[marc_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[marc_FechaEliminacion] [datetime] NULL,
	[marc_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbMarcas_marc_Id] PRIMARY KEY CLUSTERED 
(
	[marc_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbMarcas_marc_Descripcion] UNIQUE NONCLUSTERED 
(
	[marc_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbModoTransporte]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbModoTransporte](
	[motr_Id] [int] IDENTITY(1,1) NOT NULL,
	[motr_Descripcion] [nvarchar](75) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[motr_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[motr_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[motr_FechaEliminacion] [datetime] NULL,
	[motr_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbModoTransporte_motr_Id] PRIMARY KEY CLUSTERED 
(
	[motr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbModoTransporte_iden_Descripcion] UNIQUE NONCLUSTERED 
(
	[motr_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbPaisesEstanTratadosConHonduras]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbPaisesEstanTratadosConHonduras](
	[patr_Id] [int] IDENTITY(1,1) NOT NULL,
	[trli_Id] [int] NULL,
	[pais_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[patr_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[patr_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Adua_tbPaisesEstanTratadoConHonduras_patr_Id] PRIMARY KEY CLUSTERED 
(
	[patr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbPersonaJuridica]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbPersonaJuridica](
	[peju_Id] [int] IDENTITY(1,1) NOT NULL,
	[pers_Id] [int] NOT NULL,
	[colo_Id] [int] NULL,
	[ciud_Id] [int] NULL,
	[alde_Id] [int] NULL,
	[peju_PuntoReferencia] [nvarchar](200) NULL,
	[peju_NumeroLocalApart] [nvarchar](150) NULL,
	[peju_CiudadIdRepresentante] [int] NULL,
	[peju_ColoniaRepresentante] [int] NULL,
	[peju_AldeaIdRepresentante] [int] NULL,
	[peju_NumeroLocalRepresentante] [nvarchar](200) NULL,
	[peju_PuntoReferenciaRepresentante] [nvarchar](200) NULL,
	[peju_TelefonoEmpresa] [nvarchar](200) NULL,
	[peju_TelefonoFijoRepresentanteLegal] [nvarchar](200) NULL,
	[peju_TelefonoRepresentanteLegal] [nvarchar](200) NULL,
	[peju_CorreoElectronico] [nvarchar](200) NULL,
	[peju_CorreoElectronicoAlternativo] [nvarchar](200) NULL,
	[peju_ContratoFinalizado] [bit] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[peju_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[peju_FechaModificacion] [datetime] NULL,
	[peju_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbPersonaJuridica_peju_Id] PRIMARY KEY CLUSTERED 
(
	[peju_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbPersonaNatural]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbPersonaNatural](
	[pena_Id] [int] IDENTITY(1,1) NOT NULL,
	[pers_Id] [int] NOT NULL,
	[pena_DireccionExacta] [nvarchar](200) NOT NULL,
	[ciud_Id] [int] NOT NULL,
	[pena_TelefonoFijo] [nvarchar](20) NULL,
	[pena_TelefonoCelular] [nvarchar](20) NULL,
	[pena_CorreoElectronico] [nvarchar](50) NOT NULL,
	[pena_CorreoAlternativo] [nvarchar](50) NULL,
	[pena_RTN] [nvarchar](40) NOT NULL,
	[pena_ArchivoRTN] [nvarchar](max) NOT NULL,
	[pena_DNI] [nvarchar](40) NOT NULL,
	[pena_ArchivoDNI] [nvarchar](max) NOT NULL,
	[pena_NumeroRecibo] [varchar](100) NOT NULL,
	[pena_ArchivoNumeroRecibo] [nvarchar](max) NOT NULL,
	[pena_NombreArchDNI] [nvarchar](200) NULL,
	[pena_NombreArchRTN] [nvarchar](200) NULL,
	[pena_NombreArchRecibo] [nvarchar](200) NULL,
	[pena_Finalizado] [bit] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pena_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pena_FechaModificacion] [datetime] NULL,
	[pena_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbPersonaNatural_pena_Id] PRIMARY KEY CLUSTERED 
(
	[pena_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbPersonas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbPersonas](
	[pers_Id] [int] IDENTITY(1,1) NOT NULL,
	[pers_RTN] [nvarchar](40) NOT NULL,
	[pers_Nombre] [nvarchar](150) NULL,
	[ofic_Id] [int] NOT NULL,
	[escv_Id] [int] NOT NULL,
	[ofpr_Id] [int] NOT NULL,
	[pers_escvRepresentante] [int] NULL,
	[pers_OfprRepresentante] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pers_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[pers_FechaModificacion] [datetime] NULL,
	[pers_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbPersonas_pers_Id] PRIMARY KEY CLUSTERED 
(
	[pers_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbPersonas_pers_RTN] UNIQUE NONCLUSTERED 
(
	[pers_RTN] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbProveedoresDeclaracionHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbProveedoresDeclaracionHistorial](
	[hpvd_Id] [int] IDENTITY(1,1) NOT NULL,
	[pvde_Id] [int] NOT NULL,
	[coco_Id] [int] NOT NULL,
	[pvde_Condicion_Otra] [nvarchar](300) NULL,
	[decl_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[pvde_FechaCreacion] [datetime] NOT NULL,
	[hpvd_UsuarioModificacion] [int] NOT NULL,
	[hpvd_FechaModificacion] [datetime] NOT NULL,
 CONSTRAINT [PK_Adua_tbProveedoresDeclaracionHistorial_hpvd_Id] PRIMARY KEY CLUSTERED 
(
	[hpvd_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTipoDocumento]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTipoDocumento](
	[tido_Id] [int] IDENTITY(1,1) NOT NULL,
	[tido_Codigo] [char](4) NOT NULL,
	[tido_Descripcion] [nvarchar](50) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tido_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tido_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[tido_FechaEliminacion] [datetime] NULL,
	[tido_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbTipoDocumento_tido_Id] PRIMARY KEY CLUSTERED 
(
	[tido_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTipoDocumento_tido_Codigo] UNIQUE NONCLUSTERED 
(
	[tido_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTipoDocumento_tido_Descripcion] UNIQUE NONCLUSTERED 
(
	[tido_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTipoLiquidacion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTipoLiquidacion](
	[tipl_Id] [int] IDENTITY(1,1) NOT NULL,
	[tipl_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tipl_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tipl_FechaModificacion] [datetime] NULL,
	[tipl_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbTipoLiquidacion_tipl_Id] PRIMARY KEY CLUSTERED 
(
	[tipl_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTipoLiquidacion_tipl_Descripcion] UNIQUE NONCLUSTERED 
(
	[tipl_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTiposIdentificacion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTiposIdentificacion](
	[iden_Id] [int] IDENTITY(1,1) NOT NULL,
	[iden_Descripcion] [nvarchar](75) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[iden_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[iden_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[iden_FechaEliminacion] [datetime] NULL,
	[iden_Estado] [bit] NULL,
 CONSTRAINT [PK_Adua_tbTiposIdentificacion_iden_Id] PRIMARY KEY CLUSTERED 
(
	[iden_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Adua_tbTiposIdentificacion_iden_Descripcion] UNIQUE NONCLUSTERED 
(
	[iden_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTransporte]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTransporte](
	[tran_Id] [int] IDENTITY(1,1) NOT NULL,
	[tran_IdUnidadTransporte] [varchar](50) NOT NULL,
	[pais_Id] [int] NULL,
	[tran_Chasis] [nvarchar](100) NOT NULL,
	[marca_Id] [int] NOT NULL,
	[tran_Remolque] [nvarchar](50) NULL,
	[tran_CantCarga] [int] NOT NULL,
	[tran_NumDispositivoSeguridad] [int] NULL,
	[tran_Equipamiento] [nvarchar](200) NULL,
	[tran_TamanioEquipamiento] [varchar](50) NOT NULL,
	[tran_TipoCarga] [nvarchar](200) NOT NULL,
	[tran_IdContenedor] [nvarchar](100) NOT NULL,
	[usua_UsuarioCreacio] [int] NOT NULL,
	[tran_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tran_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[trant_FechaEliminacion] [datetime] NULL,
	[tran_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbTransporte_tran_Id] PRIMARY KEY CLUSTERED 
(
	[tran_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Adua].[tbTratadosLibreComercio]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Adua].[tbTratadosLibreComercio](
	[trli_Id] [int] IDENTITY(1,1) NOT NULL,
	[trli_NombreTratado] [nvarchar](500) NOT NULL,
	[trli_FechaInicio] [date] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[trli_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[trli_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Adua_tbTratadosLibreComercio_trli_Id] PRIMARY KEY CLUSTERED 
(
	[trli_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbAldeas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbAldeas](
	[alde_Id] [int] IDENTITY(1,1) NOT NULL,
	[alde_Nombre] [nvarchar](150) NOT NULL,
	[ciud_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[alde_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[alde_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[alde_FechaEliminacion] [datetime] NULL,
	[alde_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbAldeas_alde_Id] PRIMARY KEY CLUSTERED 
(
	[alde_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_tbAldeas_alde_Nombre_ciud_Id] UNIQUE NONCLUSTERED 
(
	[alde_Nombre] ASC,
	[ciud_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbCargos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbCargos](
	[carg_Id] [int] IDENTITY(1,1) NOT NULL,
	[carg_Nombre] [nvarchar](150) NOT NULL,
	[carg_Aduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[carg_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[carg_FechaModificacion] [datetime] NULL,
	[carg_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbCargos_carg_Id] PRIMARY KEY CLUSTERED 
(
	[carg_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbCargos__carg_Nombre] UNIQUE NONCLUSTERED 
(
	[carg_Nombre] ASC,
	[carg_Aduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbCiudades]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbCiudades](
	[ciud_Id] [int] IDENTITY(1,1) NOT NULL,
	[ciud_Nombre] [nvarchar](150) NOT NULL,
	[pvin_Id] [int] NOT NULL,
	[ciud_EsAduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ciud_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ciud_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[ciud_FechaEliminacion] [datetime] NULL,
	[ciud_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbCiudades_ciud_Id] PRIMARY KEY CLUSTERED 
(
	[ciud_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbCiudades_ciud_Nombre_pvin_Id] UNIQUE NONCLUSTERED 
(
	[pvin_Id] ASC,
	[ciud_Nombre] ASC,
	[ciud_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbColonias]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbColonias](
	[colo_Id] [int] IDENTITY(1,1) NOT NULL,
	[colo_Nombre] [nvarchar](150) NULL,
	[alde_Id] [int] NULL,
	[ciud_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[colo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[colo_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[colo_FechaEliminacion] [datetime] NULL,
	[colo_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbColonias_colo_Id] PRIMARY KEY CLUSTERED 
(
	[colo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbAldeas_colo_Nombre_alde_Id_ciud_Id] UNIQUE NONCLUSTERED 
(
	[colo_Nombre] ASC,
	[alde_Id] ASC,
	[ciud_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbEmpleados]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbEmpleados](
	[empl_Id] [int] IDENTITY(1,1) NOT NULL,
	[empl_Nombres] [nvarchar](150) NOT NULL,
	[empl_Apellidos] [nvarchar](150) NOT NULL,
	[empl_DNI] [nvarchar](20) NOT NULL,
	[escv_Id] [int] NOT NULL,
	[empl_Sexo] [char](1) NOT NULL,
	[empl_FechaNacimiento] [date] NOT NULL,
	[empl_Telefono] [nvarchar](20) NOT NULL,
	[empl_DireccionExacta] [nvarchar](500) NOT NULL,
	[pvin_Id] [int] NOT NULL,
	[empl_CorreoElectronico] [nvarchar](150) NOT NULL,
	[carg_Id] [int] NOT NULL,
	[empl_EsAduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[empl_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[empl_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[empl_FechaEliminacion] [datetime] NULL,
	[usua_UsuarioActivacion] [int] NULL,
	[empl_FechaActivacion] [datetime] NULL,
	[empl_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Adua_tbEmpleados_emad_Id] PRIMARY KEY CLUSTERED 
(
	[empl_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbEmpleados_empl_DNI] UNIQUE NONCLUSTERED 
(
	[empl_DNI] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbEstadosCiviles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbEstadosCiviles](
	[escv_Id] [int] IDENTITY(1,1) NOT NULL,
	[escv_Nombre] [nvarchar](150) NOT NULL,
	[escv_EsAduana] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[escv_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[escv_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[escv_FechaEliminacion] [datetime] NULL,
	[escv_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbEstadosCiviles_escv_Id] PRIMARY KEY CLUSTERED 
(
	[escv_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbEstadosCiviles_escv_Nombre] UNIQUE NONCLUSTERED 
(
	[escv_Nombre] ASC,
	[escv_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbOficinas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbOficinas](
	[ofic_Id] [int] IDENTITY(1,1) NOT NULL,
	[ofic_Nombre] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ofic_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ofic_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[ofic_FechaEliminacion] [datetime] NULL,
	[ofic_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbOficinas_ofic_Id] PRIMARY KEY CLUSTERED 
(
	[ofic_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbOficinas_ofic_Nombre] UNIQUE NONCLUSTERED 
(
	[ofic_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbOficio_Profesiones]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbOficio_Profesiones](
	[ofpr_Id] [int] IDENTITY(1,1) NOT NULL,
	[ofpr_Nombre] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ofpr_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ofpr_FechaModificacion] [datetime] NULL,
	[ofpr_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbOficinasProfesiones_ofpr_Id] PRIMARY KEY CLUSTERED 
(
	[ofpr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbOficinasProfesiones_ofpr_Nombre] UNIQUE NONCLUSTERED 
(
	[ofpr_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbProveedores]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbProveedores](
	[prov_Id] [int] IDENTITY(1,1) NOT NULL,
	[prov_NombreCompania] [nvarchar](200) NOT NULL,
	[prov_NombreContacto] [nvarchar](200) NOT NULL,
	[prov_Telefono] [nvarchar](20) NOT NULL,
	[prov_CodigoPostal] [varchar](5) NOT NULL,
	[prov_Ciudad] [int] NOT NULL,
	[prov_DireccionExacta] [nvarchar](350) NULL,
	[prov_CorreoElectronico] [nvarchar](250) NOT NULL,
	[prov_Fax] [nvarchar](20) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[prov_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[prov_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[prov_FechaEliminacion] [datetime] NULL,
	[prov_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbProveedores_prov_Id] PRIMARY KEY CLUSTERED 
(
	[prov_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbProveedores_prov_NombreCompania] UNIQUE NONCLUSTERED 
(
	[prov_NombreCompania] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Gral].[tbUnidadMedidas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Gral].[tbUnidadMedidas](
	[unme_Id] [int] IDENTITY(1,1) NOT NULL,
	[unme_Descripcion] [nvarchar](500) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[unme_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[unme_FechaModificacion] [datetime] NULL,
	[unme_EsAduana] [bit] NOT NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[unme_FechaEliminacion] [datetime] NULL,
	[unme_Estado] [bit] NULL,
 CONSTRAINT [PK_Gral_tbUnidadMedida_unme_Id] PRIMARY KEY CLUSTERED 
(
	[unme_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Gral_tbUnidadMedida_unme_Descripcion] UNIQUE NONCLUSTERED 
(
	[unme_Descripcion] ASC,
	[unme_EsAduana] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbArea]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbArea](
	[tipa_Id] [int] IDENTITY(1,1) NOT NULL,
	[tipa_area] [nvarchar](200) NOT NULL,
	[proc_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tipa_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tipa_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[tipa_FechaEliminacion] [datetime] NULL,
	[tipa_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbArea_tipa_Id] PRIMARY KEY CLUSTERED 
(
	[tipa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbArea_tipa_area] UNIQUE NONCLUSTERED 
(
	[tipa_area] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbAsignacionesOrden]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbAsignacionesOrden](
	[asor_Id] [int] IDENTITY(1,1) NOT NULL,
	[asor_OrdenDetId] [int] NOT NULL,
	[asor_FechaInicio] [date] NOT NULL,
	[asor_FechaLimite] [date] NOT NULL,
	[asor_Cantidad] [int] NOT NULL,
	[proc_Id] [int] NOT NULL,
	[empl_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[asor_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[asor_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Prod_tbAsignacionesOrden_asor_Id] PRIMARY KEY CLUSTERED 
(
	[asor_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbAsignacionesOrdenDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbAsignacionesOrdenDetalle](
	[adet_Id] [int] IDENTITY(1,1) NOT NULL,
	[lote_Id] [int] NOT NULL,
	[adet_Cantidad] [int] NOT NULL,
	[asor_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[adet_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[adet_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Prod_tbAsignacionesModuloDetalle_adet_Id] PRIMARY KEY CLUSTERED 
(
	[adet_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbCategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbCategoria](
	[cate_Id] [int] IDENTITY(1,1) NOT NULL,
	[cate_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[cate_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[cate_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[cate_FechaEliminacion] [datetime] NULL,
	[cate_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbCategoria_cate_Id] PRIMARY KEY CLUSTERED 
(
	[cate_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbCategoria_cate_Descripcion] UNIQUE NONCLUSTERED 
(
	[cate_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbClientes]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbClientes](
	[clie_Id] [int] IDENTITY(1,1) NOT NULL,
	[clie_Nombre_O_Razon_Social] [nvarchar](200) NOT NULL,
	[clie_Direccion] [nvarchar](250) NOT NULL,
	[clie_RTN] [nvarchar](40) NOT NULL,
	[clie_Nombre_Contacto] [nvarchar](200) NOT NULL,
	[clie_Numero_Contacto] [varchar](15) NOT NULL,
	[clie_Correo_Electronico] [nvarchar](200) NOT NULL,
	[clie_FAX] [nvarchar](50) NULL,
	[pvin_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[clie_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[clie_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[clie_FechaEliminacion] [datetime] NULL,
	[clie_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbClientes_clie_Id] PRIMARY KEY CLUSTERED 
(
	[clie_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbClientes_clie_Correo_Electronico] UNIQUE NONCLUSTERED 
(
	[clie_Correo_Electronico] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbClientes_clie_FAX] UNIQUE NONCLUSTERED 
(
	[clie_FAX] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbClientes_clie_Numero_Contacto] UNIQUE NONCLUSTERED 
(
	[clie_Numero_Contacto] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbClientes_clie_RTN] UNIQUE NONCLUSTERED 
(
	[clie_RTN] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbColores]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbColores](
	[colr_Id] [int] IDENTITY(1,1) NOT NULL,
	[colr_Nombre] [nvarchar](200) NOT NULL,
	[colr_Codigo] [nvarchar](50) NULL,
	[colr_CodigoHtml] [nvarchar](50) NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[colr_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[colr_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[colr_FechaEliminacion] [datetime] NULL,
	[colr_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbColores_colr_Id] PRIMARY KEY CLUSTERED 
(
	[colr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbColores_colr_Nombre] UNIQUE NONCLUSTERED 
(
	[colr_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbDocumentosOrdenCompraDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbDocumentosOrdenCompraDetalles](
	[dopo_Id] [int] IDENTITY(1,1) NOT NULL,
	[code_Id] [int] NOT NULL,
	[dopo_NombreArchivo] [nvarchar](max) NOT NULL,
	[dopo_Archivo] [nvarchar](max) NOT NULL,
	[dopo_TipoArchivo] [nvarchar](40) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[dopo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[dopo_FechaModificacion] [datetime] NULL,
	[code_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbDocumentosOrdenCompraDetalles_dopo_Id] PRIMARY KEY CLUSTERED 
(
	[dopo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbEstilos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbEstilos](
	[esti_Id] [int] IDENTITY(1,1) NOT NULL,
	[esti_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[esti_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[esti_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[esti_FechaEliminacion] [datetime] NULL,
	[esti_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbEstilos_esti_Id] PRIMARY KEY CLUSTERED 
(
	[esti_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbEstilos_esti_Descripcion] UNIQUE NONCLUSTERED 
(
	[esti_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbFacturasExportacion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbFacturasExportacion](
	[faex_Id] [int] IDENTITY(1,1) NOT NULL,
	[duca_Id] [int] NULL,
	[faex_Fecha] [datetime] NOT NULL,
	[orco_Id] [int] NOT NULL,
	[faex_Total] [decimal](18, 0) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[faex_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[faex_FechaModificacion] [datetime] NULL,
	[faex_Finalizado] [bit] NULL,
	[faex_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbFacturasExportacion_faex_Id] PRIMARY KEY CLUSTERED 
(
	[faex_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbFacturasExportacionDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbFacturasExportacionDetalles](
	[fede_Id] [int] IDENTITY(1,1) NOT NULL,
	[faex_Id] [int] NOT NULL,
	[code_Id] [int] NOT NULL,
	[fede_Cajas] [int] NOT NULL,
	[fede_Cantidad] [decimal](18, 2) NOT NULL,
	[fede_PrecioUnitario] [decimal](18, 2) NOT NULL,
	[fede_TotalDetalle] [decimal](18, 2) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[fede_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[fede_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Prod_tbFacturasExportacionDetalles_fede_Id] PRIMARY KEY CLUSTERED 
(
	[fede_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbFuncionesMaquina]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbFuncionesMaquina](
	[func_Id] [int] IDENTITY(1,1) NOT NULL,
	[func_Nombre] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[func_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[func_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[func_FechaEliminacion] [datetime] NULL,
	[func_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbFuncionesMaquina_func_Id] PRIMARY KEY CLUSTERED 
(
	[func_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbFuncionesMaquina_func_Nombre] UNIQUE NONCLUSTERED 
(
	[func_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbImpuestosProd]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbImpuestosProd](
	[impr_Id] [int] IDENTITY(1,1) NOT NULL,
	[impr_Descripcion] [nvarchar](max) NULL,
	[impr_Valor] [decimal](18, 4) NULL,
 CONSTRAINT [PK_Prod_tbImpuestosProd_impr_Id] PRIMARY KEY CLUSTERED 
(
	[impr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbLotes]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbLotes](
	[lote_Id] [int] IDENTITY(1,1) NOT NULL,
	[lote_CodigoLote] [nvarchar](150) NOT NULL,
	[mate_Id] [int] NOT NULL,
	[unme_Id] [int] NOT NULL,
	[prod_Id] [int] NULL,
	[lote_Stock] [decimal](18, 2) NOT NULL,
	[lote_CantIngresada] [decimal](18, 2) NOT NULL,
	[lote_Observaciones] [nvarchar](500) NULL,
	[tipa_Id] [int] NOT NULL,
	[colr_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[lote_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[lote_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[lote_FechaEliminacion] [datetime] NULL,
	[lote_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbLotes_lote_Id] PRIMARY KEY CLUSTERED 
(
	[lote_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbLotes_lote_CodigoLote] UNIQUE NONCLUSTERED 
(
	[lote_CodigoLote] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbMaquinaHistorial]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbMaquinaHistorial](
	[mahi_Id] [int] IDENTITY(1,1) NOT NULL,
	[maqu_Id] [int] NOT NULL,
	[mahi_FechaInicio] [datetime] NOT NULL,
	[mahi_FechaFin] [datetime] NOT NULL,
	[mahi_Observaciones] [nvarchar](250) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[mahi_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[mahi_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[mahi_FechaEliminacion] [datetime] NULL,
	[mahi_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbMaquinaHistorial_mahi_Id] PRIMARY KEY CLUSTERED 
(
	[mahi_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbMaquinas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbMaquinas](
	[maqu_Id] [int] IDENTITY(1,1) NOT NULL,
	[maqu_NumeroSerie] [nvarchar](100) NULL,
	[mmaq_Id] [int] NOT NULL,
	[modu_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[maqu_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[maqu_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[maqu_FechaEliminacion] [datetime] NULL,
	[maqu_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbMaquinas_maqu_Id] PRIMARY KEY CLUSTERED 
(
	[maqu_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prdo_tbMaquinas_maqu_NumeroSerie] UNIQUE NONCLUSTERED 
(
	[maqu_NumeroSerie] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbMarcasMaquina]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbMarcasMaquina](
	[marq_Id] [int] IDENTITY(1,1) NOT NULL,
	[marq_Nombre] [nvarchar](250) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[marq_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[marq_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[marq_FechaEliminacion] [datetime] NULL,
	[marq_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbMarcasMaquina_marq_Id] PRIMARY KEY CLUSTERED 
(
	[marq_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbMarcasMaquina_marq_Nombre] UNIQUE NONCLUSTERED 
(
	[marq_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbMateriales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbMateriales](
	[mate_Id] [int] IDENTITY(1,1) NOT NULL,
	[mate_Descripcion] [nvarchar](200) NULL,
	[subc_Id] [int] NULL,
	[colr_Id] [int] NULL,
	[mate_Imagen] [nvarchar](max) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[mate_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[mate_FechaModificacion] [datetime] NULL,
	[mate_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbMateriales_mate_Id] PRIMARY KEY CLUSTERED 
(
	[mate_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbMateriales_mate_Descripcion] UNIQUE NONCLUSTERED 
(
	[mate_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbMaterialesBrindar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbMaterialesBrindar](
	[mabr_Id] [int] IDENTITY(1,1) NOT NULL,
	[code_Id] [int] NOT NULL,
	[mate_Id] [int] NOT NULL,
	[mabr_Cantidad] [int] NOT NULL,
	[unme_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[mabr_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[mabr_FechaModificacion] [datetime] NULL,
	[mabr_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbMaterialesBrindar_mabr_Id] PRIMARY KEY CLUSTERED 
(
	[mabr_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbModelosMaquina]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbModelosMaquina](
	[mmaq_Id] [int] IDENTITY(1,1) NOT NULL,
	[mmaq_Nombre] [nvarchar](250) NOT NULL,
	[marq_Id] [int] NOT NULL,
	[func_Id] [int] NOT NULL,
	[mmaq_Imagen] [nvarchar](max) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[mmaq_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[mmaq_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[mmaq_FechaEliminacion] [datetime] NULL,
	[mmaq_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbModelosMaquina_mmaq_Id] PRIMARY KEY CLUSTERED 
(
	[mmaq_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbModulos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbModulos](
	[modu_Id] [int] IDENTITY(1,1) NOT NULL,
	[modu_Nombre] [nvarchar](150) NOT NULL,
	[proc_Id] [int] NOT NULL,
	[empr_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[modu_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[modu_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[modu_FechaEliminacion] [datetime] NULL,
	[modu_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbModulos_modu_Id] PRIMARY KEY CLUSTERED 
(
	[modu_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbModulos_modu_Nombre] UNIQUE NONCLUSTERED 
(
	[modu_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbOrde_Ensa_Acab_Etiq]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbOrde_Ensa_Acab_Etiq](
	[ensa_Id] [int] IDENTITY(1,1) NOT NULL,
	[ensa_Cantidad] [int] NOT NULL,
	[empl_Id] [int] NOT NULL,
	[code_Id] [int] NOT NULL,
	[ensa_FechaInicio] [date] NOT NULL,
	[ensa_FechaLimite] [date] NOT NULL,
	[ppro_Id] [int] NOT NULL,
	[modu_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ensa_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ensa_FechaModificacion] [datetime] NULL,
	[ensa_Estado] [bit] NULL,
	[ensa_Terminado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_orde_Id] PRIMARY KEY CLUSTERED 
(
	[ensa_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbOrdenCompra]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbOrdenCompra](
	[orco_Id] [int] IDENTITY(1,1) NOT NULL,
	[orco_IdCliente] [int] NOT NULL,
	[orco_Codigo] [nvarchar](100) NOT NULL,
	[orco_FechaEmision] [datetime] NOT NULL,
	[orco_FechaLimite] [datetime] NOT NULL,
	[orco_MetodoPago] [int] NOT NULL,
	[orco_Materiales] [bit] NOT NULL,
	[orco_IdEmbalaje] [int] NOT NULL,
	[orco_EstadoOrdenCompra] [char](1) NOT NULL,
	[orco_DireccionEntrega] [nvarchar](250) NOT NULL,
	[orco_EstadoFinalizado] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[orco_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[orco_FechaModificacion] [datetime] NULL,
	[orco_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbOrdenCompra_orco_Id] PRIMARY KEY CLUSTERED 
(
	[orco_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbOrdenCompraDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbOrdenCompraDetalles](
	[code_Id] [int] IDENTITY(1,1) NOT NULL,
	[orco_Id] [int] NOT NULL,
	[code_CantidadPrenda] [int] NOT NULL,
	[esti_Id] [int] NOT NULL,
	[tall_Id] [int] NOT NULL,
	[code_Sexo] [char](1) NOT NULL,
	[colr_Id] [int] NOT NULL,
	[proc_IdComienza] [int] NOT NULL,
	[proc_IdActual] [int] NOT NULL,
	[code_Unidad] [decimal](18, 2) NOT NULL,
	[code_Valor] [decimal](18, 2) NOT NULL,
	[code_Impuesto] [decimal](18, 2) NOT NULL,
	[code_EspecificacionEmbalaje] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[code_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[code_FechaModificacion] [datetime] NULL,
	[code_FechaProcActual] [datetime] NULL,
	[code_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbOrdenCompraDetalles_code_Id] PRIMARY KEY CLUSTERED 
(
	[code_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbPedidosOrden]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbPedidosOrden](
	[peor_Id] [int] IDENTITY(1,1) NOT NULL,
	[peor_Codigo] [nvarchar](100) NOT NULL,
	[prov_Id] [int] NULL,
	[duca_Id] [int] NULL,
	[ciud_Id] [int] NULL,
	[peor_DireccionExacta] [nvarchar](500) NULL,
	[peor_FechaEntrada] [datetime] NULL,
	[peor_Obsevaciones] [nvarchar](400) NULL,
	[peor_finalizacion] [bit] NOT NULL,
	[peor_DadoCliente] [bit] NULL,
	[peor_Est] [bit] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[peor_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[peor_FechaModificacion] [datetime] NULL,
	[peor_Estado] [bit] NULL,
	[peor_Impuestos] [nvarchar](max) NULL,
 CONSTRAINT [PK_Prod_tbPedidosOrden_peor_Id] PRIMARY KEY CLUSTERED 
(
	[peor_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbPedidosOrden_peor_Codigo] UNIQUE NONCLUSTERED 
(
	[peor_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbPedidosOrdenDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbPedidosOrdenDetalle](
	[prod_Id] [int] IDENTITY(1,1) NOT NULL,
	[pedi_Id] [int] NOT NULL,
	[mate_Id] [int] NOT NULL,
	[prod_Cantidad] [int] NOT NULL,
	[prod_Precio] [decimal](18, 2) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[prod_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[prod_FechaModificacion] [datetime] NULL,
	[prod_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbPedidosOrdenDetalle_prod_Id] PRIMARY KEY CLUSTERED 
(
	[prod_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbPedidosProduccion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbPedidosProduccion](
	[ppro_Id] [int] IDENTITY(1,1) NOT NULL,
	[empl_Id] [int] NOT NULL,
	[ppro_Fecha] [datetime] NOT NULL,
	[ppro_Estados] [nvarchar](150) NOT NULL,
	[ppro_Observaciones] [nvarchar](max) NOT NULL,
	[ppro_Finalizado] [bit] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ppro_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ppro_FechaModificacion] [datetime] NULL,
	[ppro_Estado] [bit] NULL,
 CONSTRAINT [PK_prod_tbPedidosProduccion] PRIMARY KEY CLUSTERED 
(
	[ppro_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbPedidosProduccionDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbPedidosProduccionDetalles](
	[ppde_Id] [int] IDENTITY(1,1) NOT NULL,
	[ppro_Id] [int] NOT NULL,
	[lote_Id] [int] NOT NULL,
	[ppde_Cantidad] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ppde_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ppde_FechaModificacion] [datetime] NULL,
	[ppde_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbPedidosProduccionDetalle] PRIMARY KEY CLUSTERED 
(
	[ppde_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbPODetallePorPedidoOrdenDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle](
	[ocpo_Id] [int] IDENTITY(1,1) NOT NULL,
	[prod_Id] [int] NOT NULL,
	[code_Id] [int] NULL,
	[orco_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[ocpo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[ocpo_FechaModificacion] [datetime] NULL,
 CONSTRAINT [PK_Prod_tbPODetallePorPedidoOrdenDetalle_ocpo_Id] PRIMARY KEY CLUSTERED 
(
	[ocpo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbProcesoPorOrdenCompraDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbProcesoPorOrdenCompraDetalle](
	[poco_Id] [int] IDENTITY(1,1) NOT NULL,
	[code_Id] [int] NOT NULL,
	[proc_Id] [int] NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[poco_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[poco_FechaModificacion] [datetime] NULL,
	[code_Estado] [bit] NULL,
	[poco_Completado] [int] NULL,
 CONSTRAINT [PK_Prod_tbProcesoPorOrdenCompraDetalle_poco_Id] PRIMARY KEY CLUSTERED 
(
	[poco_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbProcesos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbProcesos](
	[proc_Id] [int] IDENTITY(1,1) NOT NULL,
	[proc_Descripcion] [nvarchar](200) NOT NULL,
	[proc_CodigoHtml] [nvarchar](50) NOT NULL,
	[usua_UsuarioCreacion] [int] NULL,
	[proc_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[proc_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[proc_FechaEliminacion] [datetime] NULL,
	[proc_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbProcesos_proc_Id] PRIMARY KEY CLUSTERED 
(
	[proc_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbProcesos_proc_Descripcion] UNIQUE NONCLUSTERED 
(
	[proc_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbReporteModuloDia]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbReporteModuloDia](
	[remo_Id] [int] IDENTITY(1,1) NOT NULL,
	[modu_Id] [int] NOT NULL,
	[remo_Fecha] [date] NOT NULL,
	[remo_TotalDia] [int] NOT NULL,
	[remo_TotalDanado] [int] NOT NULL,
	[remo_Finalizado] [bit] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[remo_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[remo_FechaModificacion] [datetime] NULL,
	[remo_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbReporteModuloDia_remo_Id] PRIMARY KEY CLUSTERED 
(
	[remo_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbReporteModuloDiaDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbReporteModuloDiaDetalle](
	[rdet_Id] [int] IDENTITY(1,1) NOT NULL,
	[remo_Id] [int] NOT NULL,
	[rdet_TotalDia] [int] NOT NULL,
	[rdet_TotalDanado] [int] NOT NULL,
	[code_Id] [int] NOT NULL,
	[ensa_Id] [int] NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[rdet_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[rdet_FechaModificacion] [datetime] NULL,
	[rdet_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbReporteModuloDiaDetalle_rdet_Id] PRIMARY KEY CLUSTERED 
(
	[rdet_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbRevisionDeCalidad]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbRevisionDeCalidad](
	[reca_Id] [int] IDENTITY(1,1) NOT NULL,
	[ensa_Id] [int] NOT NULL,
	[reca_Descripcion] [nvarchar](200) NOT NULL,
	[reca_Cantidad] [int] NOT NULL,
	[reca_Scrap] [bit] NOT NULL,
	[reca_FechaRevision] [datetime] NOT NULL,
	[reca_Imagen] [nvarchar](max) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[reca_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[reca_FechaModificacion] [datetime] NULL,
	[reca_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbRevisiondeCalidad_reca_Id] PRIMARY KEY CLUSTERED 
(
	[reca_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbRevisionDeCalidadErrores]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbRevisionDeCalidadErrores](
	[rcer_Id] [int] IDENTITY(1,1) NOT NULL,
	[rcer_Nombre] [nvarchar](150) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[rcer_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[rcer_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[rcer_FechaEliminacion] [datetime] NULL,
	[rcer_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbRevisionDeCalidadErros_rcer_Id] PRIMARY KEY CLUSTERED 
(
	[rcer_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbSubcategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbSubcategoria](
	[subc_Id] [int] IDENTITY(1,1) NOT NULL,
	[cate_Id] [int] NULL,
	[subc_Descripcion] [nvarchar](200) NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[subc_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[subc_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[subc_FechaEliminacion] [datetime] NULL,
	[subc_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbSubcategoria_subc_Id] PRIMARY KEY CLUSTERED 
(
	[subc_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [FK_Prod_tbSubcategoria_cate_Id_subc_Descripcion] UNIQUE NONCLUSTERED 
(
	[subc_Descripcion] ASC,
	[cate_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbTallas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbTallas](
	[tall_Id] [int] IDENTITY(1,1) NOT NULL,
	[tall_Codigo] [char](5) NULL,
	[tall_Nombre] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tall_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tall_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[tall_FechaEliminacion] [datetime] NULL,
	[tall_Estado] [bit] NULL,
 CONSTRAINT [PK_Prod_tbTalla_tall_Id] PRIMARY KEY CLUSTERED 
(
	[tall_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbTallas_tall_Codigo] UNIQUE NONCLUSTERED 
(
	[tall_Codigo] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbTallas_tall_Nombre] UNIQUE NONCLUSTERED 
(
	[tall_Nombre] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Prod].[tbTipoEmbalaje]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Prod].[tbTipoEmbalaje](
	[tiem_Id] [int] IDENTITY(1,1) NOT NULL,
	[tiem_Descripcion] [nvarchar](200) NOT NULL,
	[usua_UsuarioCreacion] [int] NOT NULL,
	[tiem_FechaCreacion] [datetime] NOT NULL,
	[usua_UsuarioModificacion] [int] NULL,
	[tiem_FechaModificacion] [datetime] NULL,
	[usua_UsuarioEliminacion] [int] NULL,
	[tiem_FechaEliminacion] [datetime] NULL,
	[tiem_Estado] [bit] NOT NULL,
 CONSTRAINT [PK_Prod_tbTipoEmbalaje_tiem_Id] PRIMARY KEY CLUSTERED 
(
	[tiem_Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Prod_tbTipoEmbalaje_tiem_Descripcion] UNIQUE NONCLUSTERED 
(
	[tiem_Descripcion] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Acce].[tbPantallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Acce].[tbPantallas] ADD  DEFAULT (NULL) FOR [pant_FechaModificacion]
GO
ALTER TABLE [Acce].[tbPantallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Acce].[tbPantallas] ADD  DEFAULT (NULL) FOR [pant_FechaEliminacion]
GO
ALTER TABLE [Acce].[tbPantallas] ADD  DEFAULT ((1)) FOR [pant_Estado]
GO
ALTER TABLE [Acce].[tbRoles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Acce].[tbRoles] ADD  DEFAULT (NULL) FOR [role_FechaModificacion]
GO
ALTER TABLE [Acce].[tbRoles] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Acce].[tbRoles] ADD  DEFAULT (NULL) FOR [role_FechaEliminacion]
GO
ALTER TABLE [Acce].[tbRoles] ADD  DEFAULT ((1)) FOR [role_Estado]
GO
ALTER TABLE [Acce].[tbRolesXPantallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Acce].[tbRolesXPantallas] ADD  DEFAULT (NULL) FOR [ropa_FechaModificacion]
GO
ALTER TABLE [Acce].[tbRolesXPantallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Acce].[tbRolesXPantallas] ADD  DEFAULT (NULL) FOR [ropa_FechaEliminacion]
GO
ALTER TABLE [Acce].[tbRolesXPantallas] ADD  DEFAULT ((1)) FOR [ropa_Estado]
GO
ALTER TABLE [Acce].[tbUsuarios] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Acce].[tbUsuarios] ADD  DEFAULT (NULL) FOR [usua_FechaModificacion]
GO
ALTER TABLE [Acce].[tbUsuarios] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Acce].[tbUsuarios] ADD  DEFAULT (NULL) FOR [usua_FechaEliminacion]
GO
ALTER TABLE [Acce].[tbUsuarios] ADD  DEFAULT ((1)) FOR [usua_Estado]
GO
ALTER TABLE [Adua].[tbAduanas] ADD  DEFAULT (NULL) FOR [adua_FechaModificacion]
GO
ALTER TABLE [Adua].[tbAduanas] ADD  DEFAULT (NULL) FOR [adua_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbAduanas] ADD  DEFAULT ((1)) FOR [adua_Estado]
GO
ALTER TABLE [Adua].[tbAranceles] ADD  DEFAULT (NULL) FOR [aran_FechaModificacion]
GO
ALTER TABLE [Adua].[tbAranceles] ADD  DEFAULT ((1)) FOR [aram_Estado]
GO
ALTER TABLE [Adua].[tbBaseCalculos] ADD  DEFAULT ((1)) FOR [base_Estado]
GO
ALTER TABLE [Adua].[tbBoletinPago] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbBoletinPago] ADD  DEFAULT (NULL) FOR [boen_FechaModificacion]
GO
ALTER TABLE [Adua].[tbBoletinPago] ADD  DEFAULT ((1)) FOR [boen_Estado]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] ADD  DEFAULT (NULL) FOR [bode_FechaModificacion]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] ADD  DEFAULT (NULL) FOR [coim_FechaModificacion]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] ADD  DEFAULT (NULL) FOR [coim_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] ADD  DEFAULT ((1)) FOR [coim_Estado]
GO
ALTER TABLE [Adua].[tbComercianteIndividual] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbComercianteIndividual] ADD  DEFAULT (NULL) FOR [coin_FechaModificacion]
GO
ALTER TABLE [Adua].[tbComercianteIndividual] ADD  DEFAULT ((1)) FOR [coin_Estado]
GO
ALTER TABLE [Adua].[tbComercianteIndividual] ADD  DEFAULT ((0)) FOR [coin_Finalizacion]
GO
ALTER TABLE [Adua].[tbConceptoPago] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbConceptoPago] ADD  DEFAULT (NULL) FOR [copa_FechaModificacion]
GO
ALTER TABLE [Adua].[tbConceptoPago] ADD  DEFAULT ((1)) FOR [copa_Estado]
GO
ALTER TABLE [Adua].[tbCondiciones] ADD  DEFAULT ((1)) FOR [codi_Estado]
GO
ALTER TABLE [Adua].[tbCondicionesComerciales] ADD  DEFAULT ((1)) FOR [coco_Estado]
GO
ALTER TABLE [Adua].[tbCondicionesHistorial] ADD  DEFAULT ((1)) FOR [codi_Estado]
GO
ALTER TABLE [Adua].[tbConductor] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbConductor] ADD  DEFAULT (NULL) FOR [cont_FechaModificacion]
GO
ALTER TABLE [Adua].[tbConductor] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbConductor] ADD  DEFAULT (NULL) FOR [cont_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbConductor] ADD  DEFAULT ((1)) FOR [cont_Estado]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] ADD  DEFAULT ((0)) FOR [deva_Finalizacion]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] ADD  DEFAULT ((1)) FOR [deva_Estado]
GO
ALTER TABLE [Adua].[tbDeclarantes] ADD  DEFAULT ((1)) FOR [decl_Estado]
GO
ALTER TABLE [Adua].[tbDocumentosContratos] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosContratos] ADD  DEFAULT (NULL) FOR [doco_FechaModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosContratos] ADD  DEFAULT ((1)) FOR [doco_Estado]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] ADD  DEFAULT (NULL) FOR [doso_FechaModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] ADD  DEFAULT (NULL) FOR [doso_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] ADD  DEFAULT ((1)) FOR [doso_Estado]
GO
ALTER TABLE [Adua].[tbDocumentosPDF] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF] ADD  DEFAULT (NULL) FOR [dpdf_FechaModificacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF] ADD  DEFAULT (NULL) FOR [dpdf_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF] ADD  DEFAULT ((1)) FOR [dpdf_Estado]
GO
ALTER TABLE [Adua].[tbDuca] ADD  DEFAULT ((0)) FOR [duca_Finalizado]
GO
ALTER TABLE [Adua].[tbDuca] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbDuca] ADD  DEFAULT (NULL) FOR [duca_FechaModificacion]
GO
ALTER TABLE [Adua].[tbDuca] ADD  DEFAULT ((1)) FOR [duca_Estado]
GO
ALTER TABLE [Adua].[tbEstadoBoletin] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbEstadoBoletin] ADD  DEFAULT (NULL) FOR [esbo_FechaModificacion]
GO
ALTER TABLE [Adua].[tbEstadoBoletin] ADD  DEFAULT ((1)) FOR [esbo_Estadoo]
GO
ALTER TABLE [Adua].[tbEstadoMercancias] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbEstadoMercancias] ADD  DEFAULT (NULL) FOR [merc_FechaModificacion]
GO
ALTER TABLE [Adua].[tbEstadoMercancias] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbEstadoMercancias] ADD  DEFAULT (NULL) FOR [merc_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbEstadoMercancias] ADD  DEFAULT ((1)) FOR [merc_Estado]
GO
ALTER TABLE [Adua].[tbFacturas] ADD  DEFAULT ((1)) FOR [fact_Estado]
GO
ALTER TABLE [Adua].[tbFormasdePago] ADD  DEFAULT ((1)) FOR [fopa_Estado]
GO
ALTER TABLE [Adua].[tbImportadores] ADD  DEFAULT ((1)) FOR [impo_Estado]
GO
ALTER TABLE [Adua].[tbImpuestos] ADD  DEFAULT ((1)) FOR [impu_Estado]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] ADD  DEFAULT (NULL) FOR [imar_FechaModificacion]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] ADD  DEFAULT ((1)) FOR [imar_Estado]
GO
ALTER TABLE [Adua].[tbIncoterm] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbIncoterm] ADD  DEFAULT (NULL) FOR [inco_FechaModificacion]
GO
ALTER TABLE [Adua].[tbIncoterm] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbIncoterm] ADD  DEFAULT (NULL) FOR [inco_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbIncoterm] ADD  DEFAULT ((1)) FOR [inco_Estado]
GO
ALTER TABLE [Adua].[tbIntermediarios] ADD  DEFAULT ((1)) FOR [inte_Estado]
GO
ALTER TABLE [Adua].[tbItems] ADD  DEFAULT ((1)) FOR [item_Estado]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] ADD  DEFAULT (NULL) FOR [emba_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] ADD  DEFAULT ((1)) FOR [emba_Estado]
GO
ALTER TABLE [Adua].[tbMarcas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbMarcas] ADD  DEFAULT (NULL) FOR [marc_FechaModificacion]
GO
ALTER TABLE [Adua].[tbMarcas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbMarcas] ADD  DEFAULT (NULL) FOR [marc_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbMarcas] ADD  DEFAULT ((1)) FOR [marc_Estado]
GO
ALTER TABLE [Adua].[tbModoTransporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbModoTransporte] ADD  DEFAULT (NULL) FOR [motr_FechaModificacion]
GO
ALTER TABLE [Adua].[tbModoTransporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbModoTransporte] ADD  DEFAULT (NULL) FOR [motr_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbModoTransporte] ADD  DEFAULT ((1)) FOR [motr_Estado]
GO
ALTER TABLE [Adua].[tbNivelesComerciales] ADD  DEFAULT ((1)) FOR [nico_Estado]
GO
ALTER TABLE [Adua].[tbPersonaJuridica] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbPersonaJuridica] ADD  DEFAULT (NULL) FOR [peju_FechaModificacion]
GO
ALTER TABLE [Adua].[tbPersonaJuridica] ADD  DEFAULT ((1)) FOR [peju_Estado]
GO
ALTER TABLE [Adua].[tbPersonaNatural] ADD  DEFAULT ((0)) FOR [pena_Finalizado]
GO
ALTER TABLE [Adua].[tbPersonaNatural] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbPersonaNatural] ADD  DEFAULT (NULL) FOR [pena_FechaModificacion]
GO
ALTER TABLE [Adua].[tbPersonaNatural] ADD  DEFAULT ((1)) FOR [pena_Estado]
GO
ALTER TABLE [Adua].[tbPersonas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbPersonas] ADD  DEFAULT (NULL) FOR [pers_FechaModificacion]
GO
ALTER TABLE [Adua].[tbPersonas] ADD  DEFAULT ((1)) FOR [pers_Estado]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] ADD  DEFAULT (NULL) FOR [pvde_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] ADD  DEFAULT ((1)) FOR [pvde_Estado]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] ADD  DEFAULT (NULL) FOR [regi_FechaModificacion]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] ADD  DEFAULT (NULL) FOR [regi_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] ADD  DEFAULT ((1)) FOR [regi_Estado]
GO
ALTER TABLE [Adua].[tbTipoDocumento] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTipoDocumento] ADD  DEFAULT (NULL) FOR [tido_FechaModificacion]
GO
ALTER TABLE [Adua].[tbTipoDocumento] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbTipoDocumento] ADD  DEFAULT (NULL) FOR [tido_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbTipoDocumento] ADD  DEFAULT ((1)) FOR [tido_Estado]
GO
ALTER TABLE [Adua].[tbTipoIntermediario] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbTipoIntermediario] ADD  DEFAULT (NULL) FOR [tite_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbTipoIntermediario] ADD  DEFAULT ((1)) FOR [tite_Estado]
GO
ALTER TABLE [Adua].[tbTipoLiquidacion] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTipoLiquidacion] ADD  DEFAULT (NULL) FOR [tipl_FechaModificacion]
GO
ALTER TABLE [Adua].[tbTipoLiquidacion] ADD  DEFAULT ((1)) FOR [tipl_Estado]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] ADD  DEFAULT (NULL) FOR [iden_FechaModificacion]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] ADD  DEFAULT (NULL) FOR [iden_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] ADD  DEFAULT ((1)) FOR [iden_Estado]
GO
ALTER TABLE [Adua].[tbTransporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTransporte] ADD  DEFAULT (NULL) FOR [tran_FechaModificacion]
GO
ALTER TABLE [Adua].[tbTransporte] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbTransporte] ADD  DEFAULT (NULL) FOR [trant_FechaEliminacion]
GO
ALTER TABLE [Adua].[tbTransporte] ADD  DEFAULT ((1)) FOR [tran_Estado]
GO
ALTER TABLE [Gral].[tbAldeas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbAldeas] ADD  DEFAULT (NULL) FOR [alde_FechaModificacion]
GO
ALTER TABLE [Gral].[tbAldeas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbAldeas] ADD  DEFAULT (NULL) FOR [alde_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbAldeas] ADD  DEFAULT ((1)) FOR [alde_Estado]
GO
ALTER TABLE [Gral].[tbCargos] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbCargos] ADD  DEFAULT (NULL) FOR [carg_FechaModificacion]
GO
ALTER TABLE [Gral].[tbCargos] ADD  DEFAULT ((1)) FOR [carg_Estado]
GO
ALTER TABLE [Gral].[tbCiudades] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbCiudades] ADD  DEFAULT (NULL) FOR [ciud_FechaModificacion]
GO
ALTER TABLE [Gral].[tbCiudades] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbCiudades] ADD  DEFAULT (NULL) FOR [ciud_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbCiudades] ADD  DEFAULT ((1)) FOR [ciud_Estado]
GO
ALTER TABLE [Gral].[tbColonias] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbColonias] ADD  DEFAULT (NULL) FOR [colo_FechaModificacion]
GO
ALTER TABLE [Gral].[tbColonias] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbColonias] ADD  DEFAULT (NULL) FOR [colo_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbColonias] ADD  DEFAULT ((1)) FOR [colo_Estado]
GO
ALTER TABLE [Gral].[tbEmpleados] ADD  DEFAULT ((1)) FOR [empl_Estado]
GO
ALTER TABLE [Gral].[tbEstadosCiviles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbEstadosCiviles] ADD  DEFAULT (NULL) FOR [escv_FechaModificacion]
GO
ALTER TABLE [Gral].[tbEstadosCiviles] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbEstadosCiviles] ADD  DEFAULT (NULL) FOR [escv_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbEstadosCiviles] ADD  DEFAULT ((1)) FOR [escv_Estado]
GO
ALTER TABLE [Gral].[tbFormas_Envio] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbFormas_Envio] ADD  DEFAULT (NULL) FOR [foen_FechaModificacion]
GO
ALTER TABLE [Gral].[tbFormas_Envio] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbFormas_Envio] ADD  DEFAULT (NULL) FOR [foen_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbFormas_Envio] ADD  DEFAULT ((1)) FOR [foen_Estado]
GO
ALTER TABLE [Gral].[tbMonedas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbMonedas] ADD  DEFAULT (NULL) FOR [mone_FechaModificacion]
GO
ALTER TABLE [Gral].[tbMonedas] ADD  DEFAULT ((1)) FOR [mone_Estado]
GO
ALTER TABLE [Gral].[tbOficinas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbOficinas] ADD  DEFAULT (NULL) FOR [ofic_FechaModificacion]
GO
ALTER TABLE [Gral].[tbOficinas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbOficinas] ADD  DEFAULT (NULL) FOR [ofic_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbOficinas] ADD  DEFAULT ((1)) FOR [ofic_Estado]
GO
ALTER TABLE [Gral].[tbOficio_Profesiones] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbOficio_Profesiones] ADD  DEFAULT (NULL) FOR [ofpr_FechaModificacion]
GO
ALTER TABLE [Gral].[tbOficio_Profesiones] ADD  DEFAULT ((1)) FOR [ofpr_Estado]
GO
ALTER TABLE [Gral].[tbPaises] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbPaises] ADD  DEFAULT (NULL) FOR [pais_FechaModificacion]
GO
ALTER TABLE [Gral].[tbPaises] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbPaises] ADD  DEFAULT (NULL) FOR [pais_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbPaises] ADD  DEFAULT ((1)) FOR [pais_Estado]
GO
ALTER TABLE [Gral].[tbProveedores] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbProveedores] ADD  DEFAULT (NULL) FOR [prov_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbProveedores] ADD  DEFAULT ((1)) FOR [prov_Estado]
GO
ALTER TABLE [Gral].[tbProvincias] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbProvincias] ADD  DEFAULT (NULL) FOR [pvin_FechaModificacion]
GO
ALTER TABLE [Gral].[tbProvincias] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbProvincias] ADD  DEFAULT (NULL) FOR [pvin_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbProvincias] ADD  DEFAULT ((1)) FOR [pvin_Estado]
GO
ALTER TABLE [Gral].[tbUnidadMedidas] ADD  DEFAULT (NULL) FOR [unme_FechaModificacion]
GO
ALTER TABLE [Gral].[tbUnidadMedidas] ADD  DEFAULT (NULL) FOR [unme_FechaEliminacion]
GO
ALTER TABLE [Gral].[tbUnidadMedidas] ADD  DEFAULT ((1)) FOR [unme_Estado]
GO
ALTER TABLE [Prod].[tbArea] ADD  DEFAULT (NULL) FOR [tipa_FechaModificacion]
GO
ALTER TABLE [Prod].[tbArea] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbArea] ADD  DEFAULT (NULL) FOR [tipa_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbArea] ADD  DEFAULT ((1)) FOR [tipa_Estado]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] ADD  DEFAULT (NULL) FOR [asor_FechaModificacion]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] ADD  DEFAULT (NULL) FOR [adet_FechaModificacion]
GO
ALTER TABLE [Prod].[tbCategoria] ADD  DEFAULT (NULL) FOR [cate_FechaModificacion]
GO
ALTER TABLE [Prod].[tbCategoria] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbCategoria] ADD  DEFAULT (NULL) FOR [cate_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbCategoria] ADD  DEFAULT ((1)) FOR [cate_Estado]
GO
ALTER TABLE [Prod].[tbClientes] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbClientes] ADD  DEFAULT (NULL) FOR [clie_FechaModificacion]
GO
ALTER TABLE [Prod].[tbClientes] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbClientes] ADD  DEFAULT (NULL) FOR [clie_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbClientes] ADD  DEFAULT ((1)) FOR [clie_Estado]
GO
ALTER TABLE [Prod].[tbColores] ADD  DEFAULT (NULL) FOR [colr_FechaModificacion]
GO
ALTER TABLE [Prod].[tbColores] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbColores] ADD  DEFAULT (NULL) FOR [colr_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbColores] ADD  DEFAULT ((1)) FOR [colr_Estado]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] ADD  DEFAULT (NULL) FOR [dopo_FechaModificacion]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] ADD  DEFAULT ((1)) FOR [code_Estado]
GO
ALTER TABLE [Prod].[tbEstilos] ADD  DEFAULT (NULL) FOR [esti_FechaModificacion]
GO
ALTER TABLE [Prod].[tbEstilos] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbEstilos] ADD  DEFAULT (NULL) FOR [esti_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbEstilos] ADD  DEFAULT ((1)) FOR [esti_Estado]
GO
ALTER TABLE [Prod].[tbFacturasExportacion] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacion] ADD  DEFAULT (NULL) FOR [faex_FechaModificacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacion] ADD  DEFAULT ((0)) FOR [faex_Finalizado]
GO
ALTER TABLE [Prod].[tbFacturasExportacion] ADD  DEFAULT ((1)) FOR [faex_Estado]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] ADD  DEFAULT (NULL) FOR [fede_FechaModificacion]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] ADD  DEFAULT (NULL) FOR [func_FechaModificacion]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] ADD  DEFAULT (NULL) FOR [func_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] ADD  DEFAULT ((1)) FOR [func_Estado]
GO
ALTER TABLE [Prod].[tbLotes] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbLotes] ADD  DEFAULT (NULL) FOR [lote_FechaModificacion]
GO
ALTER TABLE [Prod].[tbLotes] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbLotes] ADD  DEFAULT (NULL) FOR [lote_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbLotes] ADD  DEFAULT ((1)) FOR [lote_Estado]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] ADD  DEFAULT (NULL) FOR [mahi_FechaModificacion]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] ADD  DEFAULT (NULL) FOR [mahi_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] ADD  DEFAULT ((1)) FOR [mahi_Estado]
GO
ALTER TABLE [Prod].[tbMaquinas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbMaquinas] ADD  DEFAULT (NULL) FOR [maqu_FechaModificacion]
GO
ALTER TABLE [Prod].[tbMaquinas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbMaquinas] ADD  DEFAULT (NULL) FOR [maqu_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbMaquinas] ADD  DEFAULT ((1)) FOR [maqu_Estado]
GO
ALTER TABLE [Prod].[tbMarcasMaquina] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbMarcasMaquina] ADD  DEFAULT (NULL) FOR [marq_FechaModificacion]
GO
ALTER TABLE [Prod].[tbMarcasMaquina] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbMarcasMaquina] ADD  DEFAULT (NULL) FOR [marq_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbMarcasMaquina] ADD  DEFAULT ((1)) FOR [marq_Estado]
GO
ALTER TABLE [Prod].[tbMateriales] ADD  DEFAULT (NULL) FOR [mate_FechaModificacion]
GO
ALTER TABLE [Prod].[tbMateriales] ADD  DEFAULT ((1)) FOR [mate_Estado]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] ADD  DEFAULT (NULL) FOR [mabr_FechaModificacion]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] ADD  DEFAULT ((1)) FOR [mabr_Estado]
GO
ALTER TABLE [Prod].[tbModelosMaquina] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbModelosMaquina] ADD  DEFAULT (NULL) FOR [mmaq_FechaModificacion]
GO
ALTER TABLE [Prod].[tbModelosMaquina] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbModelosMaquina] ADD  DEFAULT (NULL) FOR [mmaq_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbModelosMaquina] ADD  DEFAULT ((1)) FOR [mmaq_Estado]
GO
ALTER TABLE [Prod].[tbModulos] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbModulos] ADD  DEFAULT (NULL) FOR [modu_FechaModificacion]
GO
ALTER TABLE [Prod].[tbModulos] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbModulos] ADD  DEFAULT (NULL) FOR [modu_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbModulos] ADD  DEFAULT ((1)) FOR [modu_Estado]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] ADD  DEFAULT (NULL) FOR [ensa_FechaModificacion]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] ADD  DEFAULT ((1)) FOR [ensa_Estado]
GO
ALTER TABLE [Prod].[tbOrdenCompra] ADD  DEFAULT ((0)) FOR [orco_EstadoFinalizado]
GO
ALTER TABLE [Prod].[tbOrdenCompra] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbOrdenCompra] ADD  DEFAULT (NULL) FOR [orco_FechaModificacion]
GO
ALTER TABLE [Prod].[tbOrdenCompra] ADD  DEFAULT ((1)) FOR [orco_Estado]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] ADD  DEFAULT (NULL) FOR [code_FechaModificacion]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] ADD  DEFAULT ((1)) FOR [code_Estado]
GO
ALTER TABLE [Prod].[tbPedidosOrden] ADD  DEFAULT ((0)) FOR [peor_finalizacion]
GO
ALTER TABLE [Prod].[tbPedidosOrden] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosOrden] ADD  DEFAULT (NULL) FOR [peor_FechaModificacion]
GO
ALTER TABLE [Prod].[tbPedidosOrden] ADD  DEFAULT ((1)) FOR [peor_Estado]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] ADD  DEFAULT (NULL) FOR [prod_FechaModificacion]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] ADD  DEFAULT ((1)) FOR [prod_Estado]
GO
ALTER TABLE [Prod].[tbPedidosProduccion] ADD  DEFAULT ((0)) FOR [ppro_Finalizado]
GO
ALTER TABLE [Prod].[tbPedidosProduccion] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosProduccion] ADD  DEFAULT (NULL) FOR [ppro_FechaModificacion]
GO
ALTER TABLE [Prod].[tbPedidosProduccion] ADD  DEFAULT ((1)) FOR [ppro_Estado]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] ADD  DEFAULT (NULL) FOR [ppde_FechaModificacion]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] ADD  DEFAULT ((1)) FOR [ppde_Estado]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] ADD  DEFAULT (NULL) FOR [ocpo_FechaModificacion]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] ADD  DEFAULT (NULL) FOR [poco_FechaModificacion]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] ADD  DEFAULT ((1)) FOR [code_Estado]
GO
ALTER TABLE [Prod].[tbProcesos] ADD  DEFAULT (NULL) FOR [proc_FechaModificacion]
GO
ALTER TABLE [Prod].[tbProcesos] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbProcesos] ADD  DEFAULT (NULL) FOR [proc_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbProcesos] ADD  DEFAULT ((1)) FOR [proc_Estado]
GO
ALTER TABLE [Prod].[tbReporteModuloDia] ADD  DEFAULT ((0)) FOR [remo_Finalizado]
GO
ALTER TABLE [Prod].[tbReporteModuloDia] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbReporteModuloDia] ADD  DEFAULT (NULL) FOR [remo_FechaModificacion]
GO
ALTER TABLE [Prod].[tbReporteModuloDia] ADD  DEFAULT ((1)) FOR [remo_Estado]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] ADD  DEFAULT (NULL) FOR [rdet_FechaModificacion]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] ADD  DEFAULT ((1)) FOR [rdet_Estado]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] ADD  DEFAULT (NULL) FOR [reca_FechaModificacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] ADD  DEFAULT ((1)) FOR [reca_Estado]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] ADD  DEFAULT (NULL) FOR [rcer_FechaModificacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] ADD  DEFAULT (NULL) FOR [rcer_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] ADD  DEFAULT ((1)) FOR [rcer_Estado]
GO
ALTER TABLE [Prod].[tbSubcategoria] ADD  DEFAULT (NULL) FOR [subc_FechaModificacion]
GO
ALTER TABLE [Prod].[tbSubcategoria] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbSubcategoria] ADD  DEFAULT (NULL) FOR [subc_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbSubcategoria] ADD  DEFAULT ((1)) FOR [subc_Estado]
GO
ALTER TABLE [Prod].[tbTallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbTallas] ADD  DEFAULT (NULL) FOR [tall_FechaModificacion]
GO
ALTER TABLE [Prod].[tbTallas] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbTallas] ADD  DEFAULT (NULL) FOR [tall_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbTallas] ADD  DEFAULT ((1)) FOR [tall_Estado]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] ADD  DEFAULT (NULL) FOR [tiem_FechaModificacion]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] ADD  DEFAULT (NULL) FOR [usua_UsuarioEliminacion]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] ADD  DEFAULT (NULL) FOR [tiem_FechaEliminacion]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] ADD  DEFAULT ((1)) FOR [tiem_Estado]
GO
ALTER TABLE [Acce].[tbPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbPantallas_pant_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbPantallas] CHECK CONSTRAINT [FK_Acce_tbPantallas_pant_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Acce].[tbPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbPantallas_pant_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbPantallas] CHECK CONSTRAINT [FK_Acce_tbPantallas_pant_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Acce].[tbRoles]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioCreacion_Acce_tbRoles_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRoles] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioCreacion_Acce_tbRoles_usua_Id]
GO
ALTER TABLE [Acce].[tbRoles]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioEliminacion_Acce_tbRoles_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRoles] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioEliminacion_Acce_tbRoles_usua_Id]
GO
ALTER TABLE [Acce].[tbRoles]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioModificacion_Acce_tbRoles_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRoles] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioModificacion_Acce_tbRoles_usua_Id]
GO
ALTER TABLE [Acce].[tbRolesXPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbRolesXPantallas_pant_Id_Acce_tbPantallas_pant_Id] FOREIGN KEY([pant_Id])
REFERENCES [Acce].[tbPantallas] ([pant_Id])
GO
ALTER TABLE [Acce].[tbRolesXPantallas] CHECK CONSTRAINT [FK_Acce_tbRolesXPantallas_pant_Id_Acce_tbPantallas_pant_Id]
GO
ALTER TABLE [Acce].[tbRolesXPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbRolesXPantallas_role_Id_Acce_tbRoles_role_Id] FOREIGN KEY([role_Id])
REFERENCES [Acce].[tbRoles] ([role_Id])
GO
ALTER TABLE [Acce].[tbRolesXPantallas] CHECK CONSTRAINT [FK_Acce_tbRolesXPantallas_role_Id_Acce_tbRoles_role_Id]
GO
ALTER TABLE [Acce].[tbRolesXPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRolesXPantallas] CHECK CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Acce].[tbRolesXPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRolesXPantallas] CHECK CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Acce].[tbRolesXPantallas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbRolesXPantallas] CHECK CONSTRAINT [FK_Acce_tbRolesXPantallas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Acce].[tbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioActivacion] FOREIGN KEY([usua_UsuarioActivacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbUsuarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioActivacion]
GO
ALTER TABLE [Acce].[tbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbUsuarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioCreacion]
GO
ALTER TABLE [Acce].[tbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbUsuarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioEliminacion]
GO
ALTER TABLE [Acce].[tbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Acce].[tbUsuarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbAduanas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAduanas_Gral_tbCiudades_Adua_ciud_Id] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbAduanas] CHECK CONSTRAINT [FK_Adua_tbAduanas_Gral_tbCiudades_Adua_ciud_Id]
GO
ALTER TABLE [Adua].[tbAduanas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbAduanas] CHECK CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbAduanas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbAduanas] CHECK CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbAduanas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_UsucCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbAduanas] CHECK CONSTRAINT [FK_Adua_tbAduanas_tbUsuarios_adua_UsucCrea]
GO
ALTER TABLE [Adua].[tbAranceles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAranceles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbAranceles] CHECK CONSTRAINT [FK_Adua_tbAranceles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbAranceles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbAranceles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbAranceles] CHECK CONSTRAINT [FK_Adua_tbAranceles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbArancelesPorTratados]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbArancelesPorTratados_usua_UsuarioCreacion] FOREIGN KEY([usua_usuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbArancelesPorTratados] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbArancelesPorTratados_usua_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbBaseCalculos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_Adua_tbBaseCalculos_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbBaseCalculos] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_Adua_tbBaseCalculos_deva_Id]
GO
ALTER TABLE [Adua].[tbBaseCalculos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbBaseCalculos_tbUsuarios_base_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBaseCalculos] CHECK CONSTRAINT [FK_Prod_tbBaseCalculos_tbUsuarios_base_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbBaseCalculos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbBaseCalculos_tbUsuarios_base_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBaseCalculos] CHECK CONSTRAINT [FK_Prod_tbBaseCalculos_tbUsuarios_base_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_Acce_tbUsuarios_usua_UsuModificacion_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_Acce_tbUsuarios_usua_UsuModificacion_usua_Id]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_coim_Id_Adua_tbCodigoImpuesto_coim_Id] FOREIGN KEY([coim_Id])
REFERENCES [Adua].[tbCodigoImpuesto] ([coim_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_coim_Id_Adua_tbCodigoImpuesto_coim_Id]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_esbo_Id_Adua_tbEstadoBoletin_esbo_Id] FOREIGN KEY([esbo_Id])
REFERENCES [Adua].[tbEstadoBoletin] ([esbo_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_esbo_Id_Adua_tbEstadoBoletin_esbo_Id]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_lige_Id_Adua_tbLiquidacionGeneral_lige_Id] FOREIGN KEY([liqu_Id])
REFERENCES [Adua].[tbLiquidacionGeneral] ([lige_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_lige_Id_Adua_tbLiquidacionGeneral_lige_Id]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_tipl_Id_Adua_tbTipoLiquidacion_tipl_Id] FOREIGN KEY([tipl_Id])
REFERENCES [Adua].[tbTipoLiquidacion] ([tipl_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_tipl_Id_Adua_tbTipoLiquidacion_tipl_Id]
GO
ALTER TABLE [Adua].[tbBoletinPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPago_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBoletinPago] CHECK CONSTRAINT [FK_Adua_tbBoletinPago_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_boen_Id_Adua_tbBoletinPago_boen_Id] FOREIGN KEY([boen_Id])
REFERENCES [Adua].[tbBoletinPago] ([boen_Id])
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] CHECK CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_boen_Id_Adua_tbBoletinPago_boen_Id]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_lige_Id_Adua_tbLiquidacionGeneral_lige_Id] FOREIGN KEY([lige_Id])
REFERENCES [Adua].[tbLiquidacionGeneral] ([lige_Id])
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] CHECK CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_lige_Id_Adua_tbLiquidacionGeneral_lige_Id]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] CHECK CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbBoletinPagoDetalles] CHECK CONSTRAINT [FK_Adua_tbBoletinPagoDetalles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbCodigoImpuesto_coim_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] CHECK CONSTRAINT [FK_Adua_tbCodigoImpuesto_coim_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbCodigoImpuesto_coim_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] CHECK CONSTRAINT [FK_Adua_tbCodigoImpuesto_coim_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbCodigoImpuesto]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbCodigoImpuesto_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCodigoImpuesto] CHECK CONSTRAINT [FK_Adua_tbCodigoImpuesto_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_Adua_ComercianteIndividual_coin_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_Adua_ComercianteIndividual_coin_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_Adua_ComercianteIndividual_coin_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_Adua_ComercianteIndividual_coin_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_alde_Id_Gral_tbAldeas] FOREIGN KEY([alde_Id])
REFERENCES [Gral].[tbAldeas] ([alde_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_alde_Id_Gral_tbAldeas]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_ciud_Id_Gral_tbCiudades] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_ciud_Id_Gral_tbCiudades]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_coin_AldeaRepresentante_Gral_tbAldeas] FOREIGN KEY([coin_AldeaRepresentante])
REFERENCES [Gral].[tbAldeas] ([alde_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_coin_AldeaRepresentante_Gral_tbAldeas]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_coin_CiudadRepresentante_Gral_tbCiudades] FOREIGN KEY([coin_CiudadRepresentante])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_coin_CiudadRepresentante_Gral_tbCiudades]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_coin_coloniaIdRepresentante_Gral_tbColonias] FOREIGN KEY([coin_coloniaIdRepresentante])
REFERENCES [Gral].[tbColonias] ([colo_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_coin_coloniaIdRepresentante_Gral_tbColonias]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_colo_Id_Gral_tbColonia] FOREIGN KEY([colo_Id])
REFERENCES [Gral].[tbColonias] ([colo_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_colo_Id_Gral_tbColonia]
GO
ALTER TABLE [Adua].[tbComercianteIndividual]  WITH CHECK ADD  CONSTRAINT [FK_ComercianteIndividual_pers_Id_Adua_Personas_pers_Id] FOREIGN KEY([pers_Id])
REFERENCES [Adua].[tbPersonas] ([pers_Id])
GO
ALTER TABLE [Adua].[tbComercianteIndividual] CHECK CONSTRAINT [FK_ComercianteIndividual_pers_Id_Adua_Personas_pers_Id]
GO
ALTER TABLE [Adua].[tbConceptoPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbConceptoPago_copa_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbConceptoPago] CHECK CONSTRAINT [FK_Adua_tbConceptoPago_copa_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbConceptoPago]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbConceptoPago_copa_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbConceptoPago] CHECK CONSTRAINT [FK_Adua_tbConceptoPago_copa_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_Adua_tbCondiciones_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbCondiciones] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_Adua_tbCondiciones_deva_Id]
GO
ALTER TABLE [Adua].[tbCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbCondiciones_tbUsuarios_base_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCondiciones] CHECK CONSTRAINT [FK_Prod_tbCondiciones_tbUsuarios_base_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbCondiciones_tbUsuarios_base_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCondiciones] CHECK CONSTRAINT [FK_Prod_tbCondiciones_tbUsuarios_base_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbCondicionesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCondicionesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbCondicionesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCondicionesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbCondicionesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbCondicionesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbCondicionesComerciales_coco_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbConductor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTransporte_tran_Id_Adua_tbConductor_tran_Id] FOREIGN KEY([tran_Id])
REFERENCES [Adua].[tbTransporte] ([tran_Id])
GO
ALTER TABLE [Adua].[tbConductor] CHECK CONSTRAINT [FK_Adua_tbTransporte_tran_Id_Adua_tbConductor_tran_Id]
GO
ALTER TABLE [Adua].[tbConductor]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_pais_Id_Adua_tbConductor_pais_IdExpedicion] FOREIGN KEY([pais_IdExpedicion])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbConductor] CHECK CONSTRAINT [FK_Gral_tbPaises_pais_Id_Adua_tbConductor_pais_IdExpedicion]
GO
ALTER TABLE [Adua].[tbConductor]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbConductor_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbConductor] CHECK CONSTRAINT [FK_Prod_tbConductor_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbConductor]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbConductor_tbUsuarios_cont_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbConductor] CHECK CONSTRAINT [FK_Prod_tbConductor_tbUsuarios_cont_UsuCrea]
GO
ALTER TABLE [Adua].[tbConductor]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbConductor_tbUsuarios_cont_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbConductor] CHECK CONSTRAINT [FK_Prod_tbConductor_tbUsuarios_cont_UsuModifica]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_AduanaDespachoId_Adua_tbAduanas] FOREIGN KEY([deva_AduanaDespachoId])
REFERENCES [Adua].[tbAduanas] ([adua_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_AduanaDespachoId_Adua_tbAduanas]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_AduanaIngresoId_Adua_tbAduanas] FOREIGN KEY([deva_AduanaIngresoId])
REFERENCES [Adua].[tbAduanas] ([adua_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_AduanaIngresoId_Adua_tbAduanas]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_emba_Id_Adua_tbLugaresEmbarque_emba_Id] FOREIGN KEY([emba_Id])
REFERENCES [Adua].[tbLugaresEmbarque] ([emba_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_emba_Id_Adua_tbLugaresEmbarque_emba_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_foen_Id_Gral_tbFormas_Envio_foen_Id] FOREIGN KEY([foen_Id])
REFERENCES [Gral].[tbFormas_Envio] ([foen_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_foen_Id_Gral_tbFormas_Envio_foen_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_fopa_Id_Adua_tbFormasdePago_fopa_Id] FOREIGN KEY([fopa_Id])
REFERENCES [Adua].[tbFormasdePago] ([fopa_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_fopa_Id_Adua_tbFormasdePago_fopa_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_impo_Id_Adua_tbImportadores] FOREIGN KEY([impo_Id])
REFERENCES [Adua].[tbImportadores] ([impo_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_impo_Id_Adua_tbImportadores]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_inco_Id_Adua_tbIncoterm] FOREIGN KEY([inco_Id])
REFERENCES [Adua].[tbIncoterm] ([inco_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_inco_Id_Adua_tbIncoterm]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_inte_Id_Adua_tbIntermediarios] FOREIGN KEY([inte_Id])
REFERENCES [Adua].[tbIntermediarios] ([inte_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_inte_Id_Adua_tbIntermediarios]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_mone_Id_Gral_tbMonedas_mone_Id] FOREIGN KEY([mone_Id])
REFERENCES [Gral].[tbMonedas] ([mone_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_mone_Id_Gral_tbMonedas_mone_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pais_EntregaId_Gral_tbPaises_pais_Id] FOREIGN KEY([pais_EntregaId])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pais_EntregaId_Gral_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pais_Exportacion_Id_Gral_tbPaises_pais_Exportacion_Id] FOREIGN KEY([pais_ExportacionId])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pais_Exportacion_Id_Gral_tbPaises_pais_Exportacion_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pvde_Id_Adua_tbProveedoresDeclaracion] FOREIGN KEY([pvde_Id])
REFERENCES [Adua].[tbProveedoresDeclaracion] ([pvde_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_pvde_Id_Adua_tbProveedoresDeclaracion]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_regi_Id_Adua_tbRegimenesAduaneros] FOREIGN KEY([regi_Id])
REFERENCES [Adua].[tbRegimenesAduaneros] ([regi_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_regi_Id_Adua_tbRegimenesAduaneros]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDeclaraciones_Valor] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDeclarantes]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbDeclarantes_Adua_tbIncoterm_Valor_fopa_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDeclarantes] CHECK CONSTRAINT [FK_Acce_tbDeclarantes_Adua_tbIncoterm_Valor_fopa_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbDeclarantes]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbDeclarantes_Adua_tbIncoterm_Valor_fopa_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDeclarantes] CHECK CONSTRAINT [FK_Acce_tbDeclarantes_Adua_tbIncoterm_Valor_fopa_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbDeclarantes]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclarantes_esta_Id_Adua_tbCiudades_ciud_Id] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbDeclarantes] CHECK CONSTRAINT [FK_Adua_tbDeclarantes_esta_Id_Adua_tbCiudades_ciud_Id]
GO
ALTER TABLE [Adua].[tbDeclarantesHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclarantesHistorial_tbDeclarantes_decl_Id] FOREIGN KEY([decl_Id])
REFERENCES [Adua].[tbDeclarantes] ([decl_Id])
GO
ALTER TABLE [Adua].[tbDeclarantesHistorial] CHECK CONSTRAINT [FK_Adua_tbDeclarantesHistorial_tbDeclarantes_decl_Id]
GO
ALTER TABLE [Adua].[tbDocumentosContratos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosContratos_coin_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosContratos] CHECK CONSTRAINT [FK_Adua_tbDocumentosContratos_coin_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosContratos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosContratos_coin_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosContratos] CHECK CONSTRAINT [FK_Adua_tbDocumentosContratos_coin_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosContratos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosContratos_tbComercianteIndividual_coin_Id] FOREIGN KEY([coin_Id])
REFERENCES [Adua].[tbComercianteIndividual] ([coin_Id])
GO
ALTER TABLE [Adua].[tbDocumentosContratos] CHECK CONSTRAINT [FK_Adua_tbDocumentosContratos_tbComercianteIndividual_coin_Id]
GO
ALTER TABLE [Adua].[tbDocumentosContratos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosContratos_tbPersonaJuridica_peju_Id] FOREIGN KEY([peju_Id])
REFERENCES [Adua].[tbPersonaJuridica] ([peju_Id])
GO
ALTER TABLE [Adua].[tbDocumentosContratos] CHECK CONSTRAINT [FK_Adua_tbDocumentosContratos_tbPersonaJuridica_peju_Id]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_Adua_tbDuca_duca_Id] FOREIGN KEY([duca_Id])
REFERENCES [Adua].[tbDuca] ([duca_Id])
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] CHECK CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_Adua_tbDuca_duca_Id]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] CHECK CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] CHECK CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] CHECK CONSTRAINT [FK_Adua_tbDocumentosDeSoporte_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte]  WITH CHECK ADD  CONSTRAINT [FK_tbDocumentosDeSoporte_Adua_tbTipoDocumento_tido_Id] FOREIGN KEY([tido_Id])
REFERENCES [Adua].[tbTipoDocumento] ([tido_Id])
GO
ALTER TABLE [Adua].[tbDocumentosDeSoporte] CHECK CONSTRAINT [FK_tbDocumentosDeSoporte_Adua_tbTipoDocumento_tido_Id]
GO
ALTER TABLE [Adua].[tbDocumentosPDF]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_Id_Gral_tbDocumentosPDF_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosPDF] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_Id_Gral_tbDocumentosPDF_usua_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_usua_Id_Gral_tbDocumentosPDF_usua_UsuarioModicacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosPDF] CHECK CONSTRAINT [FK_Acce_tbUsuarios_usua_Id_Gral_tbDocumentosPDF_usua_UsuarioModicacion]
GO
ALTER TABLE [Adua].[tbDocumentosPDF]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosPDF_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosPDF] CHECK CONSTRAINT [FK_Adua_tbDocumentosPDF_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosPDF]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosPDF_Adua_tbDeclaraciones_Valor_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbDocumentosPDF] CHECK CONSTRAINT [FK_Adua_tbDocumentosPDF_Adua_tbDeclaraciones_Valor_deva_Id]
GO
ALTER TABLE [Adua].[tbDocumentosSanciones]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDocumentosSanciones_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDocumentosSanciones] CHECK CONSTRAINT [FK_Adua_tbDocumentosSanciones_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbConductor_cont_Id_Adua_tbDuca_duca_Conductor_Id] FOREIGN KEY([duca_Conductor_Id])
REFERENCES [Adua].[tbConductor] ([cont_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbConductor_cont_Id_Adua_tbDuca_duca_Conductor_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_Id_Adua_tbDuca_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDeclaraciones_Valor_deva_Id_Adua_tbDuca_deva_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_AduanaDestino_tbAduana_adua_Id] FOREIGN KEY([duca_AduanaDestino])
REFERENCES [Adua].[tbAduanas] ([adua_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_AduanaDestino_tbAduana_adua_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_AduanaRegistro_tbAduana_adua_Id] FOREIGN KEY([duca_AduanaRegistro])
REFERENCES [Adua].[tbAduanas] ([adua_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_AduanaRegistro_tbAduana_adua_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Lugar_Desembarque_tbLugaresEmbarque_emba_Id] FOREIGN KEY([duca_Lugar_Desembarque])
REFERENCES [Adua].[tbLugaresEmbarque] ([emba_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Lugar_Desembarque_tbLugaresEmbarque_emba_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Destino_tbPaises_pais_Id] FOREIGN KEY([duca_Pais_Destino])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Destino_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Emision_Exportador_tbPaises_pais_Id] FOREIGN KEY([duca_Pais_Emision_Exportador])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Emision_Exportador_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Emision_Importador_tbPaises_pais_Id] FOREIGN KEY([duca_Pais_Emision_Importador])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Emision_Importador_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Exportacion_tbPaises_pais_Id] FOREIGN KEY([duca_Pais_Exportacion])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Exportacion_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Procedencia_tbPaises_pais_Id] FOREIGN KEY([duca_Pais_Procedencia])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Pais_Procedencia_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Regimen_Aduanero_tbRegimenesAduaneros_regi_Id] FOREIGN KEY([duca_Regimen_Aduanero])
REFERENCES [Adua].[tbRegimenesAduaneros] ([regi_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Regimen_Aduanero_tbRegimenesAduaneros_regi_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Tipo_Iden_Exportador_tbTiposIdentificacion] FOREIGN KEY([duca_Tipo_Iden_Exportador])
REFERENCES [Adua].[tbTiposIdentificacion] ([iden_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Tipo_Iden_Exportador_tbTiposIdentificacion]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_motr_id_tbModoTransporte_motr_Id] FOREIGN KEY([motr_Id])
REFERENCES [Adua].[tbModoTransporte] ([motr_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_motr_id_tbModoTransporte_motr_Id]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_tbUsuarios_duca_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Adua_tbDuca_tbUsuarios_duca_UsuCrea]
GO
ALTER TABLE [Adua].[tbDuca]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbDuca_tbUsuarios_duca_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbDuca] CHECK CONSTRAINT [FK_Prod_tbDuca_tbUsuarios_duca_UsuModifica]
GO
ALTER TABLE [Adua].[tbEstadoBoletin]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbEstadoBoletin_esbo_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbEstadoBoletin] CHECK CONSTRAINT [FK_Adua_tbEstadoBoletin_esbo_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbEstadoBoletin]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbEstadoBoletin_esbo_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbEstadoBoletin] CHECK CONSTRAINT [FK_Adua_tbEstadoBoletin_esbo_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbEstadoMercancias]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbEstadoMercancias] CHECK CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbEstadoMercancias]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbEstadoMercancias] CHECK CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbEstadoMercancias]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbEstadoMercancias] CHECK CONSTRAINT [FK_Adua_tbEstadoMercancias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbFacturas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbFacturas_tbDeclaraciones_Valor_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbFacturas] CHECK CONSTRAINT [FK_Adua_tbFacturas_tbDeclaraciones_Valor_deva_Id]
GO
ALTER TABLE [Adua].[tbFacturas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbFacturas_tbUsuarios_fact_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbFacturas] CHECK CONSTRAINT [FK_Adua_tbFacturas_tbUsuarios_fact_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbFacturas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbFacturas_tbUsuarios_fact_UsucCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbFacturas] CHECK CONSTRAINT [FK_Adua_tbFacturas_tbUsuarios_fact_UsucCrea]
GO
ALTER TABLE [Adua].[tbFormasdePago]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbFormasdePago] CHECK CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbFormasdePago]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbFormasdePago] CHECK CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbFormasdePago]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbFormasdePago] CHECK CONSTRAINT [FK_Acce_tbFormasdePago_Adua_tbIncoterm_Valor_fopa_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbImportadores]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImportadores] CHECK CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbImportadores]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImportadores] CHECK CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbImportadores]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImportadores] CHECK CONSTRAINT [FK_Acce_tbImportadores_Adua_tbIncoterm_Valor_impo_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbImportadores]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImportadores_decl_Id_Adua_tbDeclarantes_decl_Id] FOREIGN KEY([decl_Id])
REFERENCES [Adua].[tbDeclarantes] ([decl_Id])
GO
ALTER TABLE [Adua].[tbImportadores] CHECK CONSTRAINT [FK_Adua_tbImportadores_decl_Id_Adua_tbDeclarantes_decl_Id]
GO
ALTER TABLE [Adua].[tbImportadores]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImportadores_nico_Id_Adua_tbNivelesComerciales_nico_Id] FOREIGN KEY([nico_Id])
REFERENCES [Adua].[tbNivelesComerciales] ([nico_Id])
GO
ALTER TABLE [Adua].[tbImportadores] CHECK CONSTRAINT [FK_Adua_tbImportadores_nico_Id_Adua_tbNivelesComerciales_nico_Id]
GO
ALTER TABLE [Adua].[tbImportadoresHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImportadoresHistorial_tbImportadores_impo_Id] FOREIGN KEY([impo_Id])
REFERENCES [Adua].[tbImportadores] ([impo_Id])
GO
ALTER TABLE [Adua].[tbImportadoresHistorial] CHECK CONSTRAINT [FK_Adua_tbImportadoresHistorial_tbImportadores_impo_Id]
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_Adua_tbAranceles_aran_Id] FOREIGN KEY([aran_Id])
REFERENCES [Adua].[tbAranceles] ([aran_Id])
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones] CHECK CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_Adua_tbAranceles_aran_Id]
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones] CHECK CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestoProduccionComsumoCondiciones] CHECK CONSTRAINT [FK_tbImpuestoProduccionComsumoCondiciones_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestos] CHECK CONSTRAINT [FK_Adua_tbImpuestos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestos]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestos] CHECK CONSTRAINT [FK_Adua_tbImpuestos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_Adua_tbAranceles_aran_Id] FOREIGN KEY([aran_Id])
REFERENCES [Adua].[tbAranceles] ([aran_Id])
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos] CHECK CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_Adua_tbAranceles_aran_Id]
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos] CHECK CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos]  WITH CHECK ADD  CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestoSelectivoConsumoCondicionesVehiculgos] CHECK CONSTRAINT [FK_tbImpuestoSelectivoConsumoCondicionesVehiculgos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestoPorArancel_aran_Id_Adua_tbAranceles_aran_Id] FOREIGN KEY([aran_Id])
REFERENCES [Adua].[tbAranceles] ([aran_Id])
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] CHECK CONSTRAINT [FK_Adua_tbImpuestoPorArancel_aran_Id_Adua_tbAranceles_aran_Id]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestoPorArancel_imar_Id_Adua_tbImpuesto_impu_Id] FOREIGN KEY([impu_Id])
REFERENCES [Adua].[tbImpuestos] ([impu_Id])
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] CHECK CONSTRAINT [FK_Adua_tbImpuestoPorArancel_imar_Id_Adua_tbImpuesto_impu_Id]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestosPorArancel_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] CHECK CONSTRAINT [FK_Adua_tbImpuestosPorArancel_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbImpuestosPorArancel_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbImpuestosPorArancel] CHECK CONSTRAINT [FK_Adua_tbImpuestosPorArancel_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbIncoterm]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbIncoterm] CHECK CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbIncoterm]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbIncoterm] CHECK CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbIncoterm]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbIncoterm] CHECK CONSTRAINT [FK_Adua_tbIncoterm_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbIntermediarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbIntermediarios_inte_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbIntermediarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbIntermediarios_inte_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbIntermediarios]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbIntermediarios_inte_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbIntermediarios] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbIntermediarios_inte_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbIntermediarios]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIntermediarios_decl_Id_Adua_tbDeclarantes_decl_Id] FOREIGN KEY([decl_Id])
REFERENCES [Adua].[tbDeclarantes] ([decl_Id])
GO
ALTER TABLE [Adua].[tbIntermediarios] CHECK CONSTRAINT [FK_Adua_tbIntermediarios_decl_Id_Adua_tbDeclarantes_decl_Id]
GO
ALTER TABLE [Adua].[tbIntermediarios]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIntermediarios_tite_Id_Adua_tbTipoIntermediario_tite_Id] FOREIGN KEY([tite_Id])
REFERENCES [Adua].[tbTipoIntermediario] ([tite_Id])
GO
ALTER TABLE [Adua].[tbIntermediarios] CHECK CONSTRAINT [FK_Adua_tbIntermediarios_tite_Id_Adua_tbTipoIntermediario_tite_Id]
GO
ALTER TABLE [Adua].[tbIntermediariosHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbIntermediariosHistorial_tbIntermediarios_inte_Id] FOREIGN KEY([inte_Id])
REFERENCES [Adua].[tbIntermediarios] ([inte_Id])
GO
ALTER TABLE [Adua].[tbIntermediariosHistorial] CHECK CONSTRAINT [FK_Adua_tbIntermediariosHistorial_tbIntermediarios_inte_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_Adua_tbAranceles_aran_Id] FOREIGN KEY([aran_Id])
REFERENCES [Adua].[tbAranceles] ([aran_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_Adua_tbAranceles_aran_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_merc_Id_Adua_tbMercancias_merc_Id] FOREIGN KEY([merc_Id])
REFERENCES [Adua].[tbEstadoMercancias] ([merc_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_merc_Id_Adua_tbMercancias_merc_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_pais_IdOrigenMercancia_Adua_tbPais_pais_Id] FOREIGN KEY([pais_IdOrigenMercancia])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_pais_IdOrigenMercancia_Adua_tbPais_pais_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_unme_Id_Adua_tbUnidadesdeMedida_unme_Id] FOREIGN KEY([unme_Id])
REFERENCES [Gral].[tbUnidadMedidas] ([unme_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_unme_Id_Adua_tbUnidadesdeMedida_unme_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [FK_Adua_tbItems_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbItems]  WITH CHECK ADD  CONSTRAINT [PK_Adua_tbItems_Adua_tbFactura_fact_Id] FOREIGN KEY([fact_Id])
REFERENCES [Adua].[tbFacturas] ([fact_Id])
GO
ALTER TABLE [Adua].[tbItems] CHECK CONSTRAINT [PK_Adua_tbItems_Adua_tbFactura_fact_Id]
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbItemsDEVAPorDuca_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbItemsDEVAPorDuca_usua_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbItemsDEVAPorDuca_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbItemsDEVAPorDuca_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItemsDEVAPorDuca_deva_Id_Adua_tbDeclaraciones_Valor_deva_Id] FOREIGN KEY([deva_Id])
REFERENCES [Adua].[tbDeclaraciones_Valor] ([deva_Id])
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca] CHECK CONSTRAINT [FK_Adua_tbItemsDEVAPorDuca_deva_Id_Adua_tbDeclaraciones_Valor_deva_Id]
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItemsDEVAPorDuca_duca_Id_Adua_tbDuca_duca_Id] FOREIGN KEY([duca_Id])
REFERENCES [Adua].[tbDuca] ([duca_Id])
GO
ALTER TABLE [Adua].[tbItemsDEVAPorDuca] CHECK CONSTRAINT [FK_Adua_tbItemsDEVAPorDuca_duca_Id_Adua_tbDuca_duca_Id]
GO
ALTER TABLE [Adua].[tbLiquidacionGeneral]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbDuca_duca_Id_Adua_tbLiquidacionGeneral_duca_Id] FOREIGN KEY([duca_Id])
REFERENCES [Adua].[tbDuca] ([duca_Id])
GO
ALTER TABLE [Adua].[tbLiquidacionGeneral] CHECK CONSTRAINT [FK_Adua_tbDuca_duca_Id_Adua_tbLiquidacionGeneral_duca_Id]
GO
ALTER TABLE [Adua].[tbLiquidacionPorLinea]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbItems_item_Id_tbLiquidacionPorLinea_item_Id] FOREIGN KEY([item_Id])
REFERENCES [Adua].[tbItems] ([item_Id])
GO
ALTER TABLE [Adua].[tbLiquidacionPorLinea] CHECK CONSTRAINT [FK_Adua_tbItems_item_Id_tbLiquidacionPorLinea_item_Id]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] CHECK CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] CHECK CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbLugaresEmbarque]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbLugaresEmbarque] CHECK CONSTRAINT [FK_Adua_tbLugaresEmbarque_tbUsuarios_prov_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbMarcas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcas_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbMarcas] CHECK CONSTRAINT [FK_Prod_tbMarcas_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbMarcas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcas_tbUsuarios_marc_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbMarcas] CHECK CONSTRAINT [FK_Prod_tbMarcas_tbUsuarios_marc_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbMarcas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcas_tbUsuarios_marc_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbMarcas] CHECK CONSTRAINT [FK_Prod_tbMarcas_tbUsuarios_marc_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbModoTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModoTransporte__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbModoTransporte] CHECK CONSTRAINT [FK_Prod_tbModoTransporte__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbModoTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModoTransporte_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbModoTransporte] CHECK CONSTRAINT [FK_Prod_tbModoTransporte_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbModoTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModoTransporte_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbModoTransporte] CHECK CONSTRAINT [FK_Prod_tbModoTransporte_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbNivelesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbNivelesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbNivelesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbNivelesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbNivelesComerciales]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbNivelesComerciales] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbNivelesComerciales_nico_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbPaisesEstanTratadoConHonduras_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbPaisesEstanTratadoConHonduras_usua_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbPaisesEstanTratadoConHonduras_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbPaisesEstanTratadoConHonduras_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPaisesEstanTratadoConHonduras_Adua_tbTratadosLibreComercio_trli_Id] FOREIGN KEY([trli_Id])
REFERENCES [Adua].[tbTratadosLibreComercio] ([trli_Id])
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras] CHECK CONSTRAINT [FK_Adua_tbPaisesEstanTratadoConHonduras_Adua_tbTratadosLibreComercio_trli_Id]
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPaisesEstanTratadoConHonduras_Gral_tbPaises_pais_Id] FOREIGN KEY([pais_Id])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbPaisesEstanTratadosConHonduras] CHECK CONSTRAINT [FK_Adua_tbPaisesEstanTratadoConHonduras_Gral_tbPaises_pais_Id]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaJuridica_peju_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_PersonaJuridica_peju_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaJuridica_peju_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_PersonaJuridica_peju_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_alde_Id_tbAldeas] FOREIGN KEY([alde_Id])
REFERENCES [Gral].[tbAldeas] ([alde_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_alde_Id_tbAldeas]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_AldeaIdRepresentante_tbAldea] FOREIGN KEY([peju_AldeaIdRepresentante])
REFERENCES [Gral].[tbAldeas] ([alde_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_AldeaIdRepresentante_tbAldea]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_Ciudad_Id_tbCiudad] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_Ciudad_Id_tbCiudad]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_CiudadIdRepresentante_tbCiudad] FOREIGN KEY([peju_CiudadIdRepresentante])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_CiudadIdRepresentante_tbCiudad]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_colo_Id_Gral_tbColonias_colo_Id] FOREIGN KEY([colo_Id])
REFERENCES [Gral].[tbColonias] ([colo_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_colo_Id_Gral_tbColonias_colo_Id]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_peju_ColoniaRepresentante_Gral_ColoniaRepresentante_colo_Id] FOREIGN KEY([peju_ColoniaRepresentante])
REFERENCES [Gral].[tbColonias] ([colo_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_peju_ColoniaRepresentante_Gral_ColoniaRepresentante_colo_Id]
GO
ALTER TABLE [Adua].[tbPersonaJuridica]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbPersonaJuridica_pers_Id_Adua_Personas_pers_Id] FOREIGN KEY([pers_Id])
REFERENCES [Adua].[tbPersonas] ([pers_Id])
GO
ALTER TABLE [Adua].[tbPersonaJuridica] CHECK CONSTRAINT [FK_Adua_tbPersonaJuridica_pers_Id_Adua_Personas_pers_Id]
GO
ALTER TABLE [Adua].[tbPersonaNatural]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaNatural_ciud_Id_Gral_Ciudades] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Adua].[tbPersonaNatural] CHECK CONSTRAINT [FK_Adua_PersonaNatural_ciud_Id_Gral_Ciudades]
GO
ALTER TABLE [Adua].[tbPersonaNatural]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaNatural_pena_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonaNatural] CHECK CONSTRAINT [FK_Adua_PersonaNatural_pena_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbPersonaNatural]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaNatural_pena_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonaNatural] CHECK CONSTRAINT [FK_Adua_PersonaNatural_pena_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbPersonaNatural]  WITH CHECK ADD  CONSTRAINT [FK_Adua_PersonaNatural_pers_Id_Adua_Persona_pers_Id] FOREIGN KEY([pers_Id])
REFERENCES [Adua].[tbPersonas] ([pers_Id])
GO
ALTER TABLE [Adua].[tbPersonaNatural] CHECK CONSTRAINT [FK_Adua_PersonaNatural_pers_Id_Adua_Persona_pers_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_escv_Id_Gral_EstadoCivil_escv_Id] FOREIGN KEY([escv_Id])
REFERENCES [Gral].[tbEstadosCiviles] ([escv_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_escv_Id_Gral_EstadoCivil_escv_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_ofic_Id_Gral_Oficina_ofic_Id] FOREIGN KEY([ofic_Id])
REFERENCES [Gral].[tbOficinas] ([ofic_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_ofic_Id_Gral_Oficina_ofic_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_ofpr_Id_Gral_OficioProfesion_ofpr_Id] FOREIGN KEY([ofpr_Id])
REFERENCES [Gral].[tbOficio_Profesiones] ([ofpr_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_ofpr_Id_Gral_OficioProfesion_ofpr_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_pers_escvRepresentante_EstadoCivilRepresentante_escv_Id] FOREIGN KEY([pers_escvRepresentante])
REFERENCES [Gral].[tbEstadosCiviles] ([escv_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_pers_escvRepresentante_EstadoCivilRepresentante_escv_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_pers_OfprRepresentante_OficioProfesionRepresentante_escv_Id] FOREIGN KEY([pers_OfprRepresentante])
REFERENCES [Gral].[tbOficio_Profesiones] ([ofpr_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_pers_OfprRepresentante_OficioProfesionRepresentante_escv_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_pers_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_pers_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbPersonas]  WITH CHECK ADD  CONSTRAINT [FK_Adua_Personas_pers_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbPersonas] CHECK CONSTRAINT [FK_Adua_Personas_pers_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbProveedoresDeclaracion_pvde_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbProveedoresDeclaracion_decl_Id_Adua_tbDeclarantes_decl_Id] FOREIGN KEY([decl_Id])
REFERENCES [Adua].[tbDeclarantes] ([decl_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] CHECK CONSTRAINT [FK_Adua_tbProveedoresDeclaracion_decl_Id_Adua_tbDeclarantes_decl_Id]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbProveedoresDeclaracion_tbCondicionesComerciales_coco_Id] FOREIGN KEY([coco_Id])
REFERENCES [Adua].[tbCondicionesComerciales] ([coco_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracion] CHECK CONSTRAINT [FK_Adua_tbProveedoresDeclaracion_tbCondicionesComerciales_coco_Id]
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracionHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Adua__tbProveedoresDeclaracionHistorial_tbProveedoresDeclaracion_pvde_Id] FOREIGN KEY([pvde_Id])
REFERENCES [Adua].[tbProveedoresDeclaracion] ([pvde_Id])
GO
ALTER TABLE [Adua].[tbProveedoresDeclaracionHistorial] CHECK CONSTRAINT [FK_Adua__tbProveedoresDeclaracionHistorial_tbProveedoresDeclaracion_pvde_Id]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] CHECK CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] CHECK CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbRegimenesAduaneros] CHECK CONSTRAINT [FK_Adua_tbRegimenesAduaneros_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbTipoDocumento]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTipoDocumento__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoDocumento] CHECK CONSTRAINT [FK_Adua_tbTipoDocumento__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbTipoDocumento]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTipoDocumento_Acce_tbUsuarios_usua_UsuarioCreacion_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoDocumento] CHECK CONSTRAINT [FK_Adua_tbTipoDocumento_Acce_tbUsuarios_usua_UsuarioCreacion_usua_Id]
GO
ALTER TABLE [Adua].[tbTipoDocumento]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTipoDocumento_Acce_tbUsuarios_usua_UsuarioModificacion_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoDocumento] CHECK CONSTRAINT [FK_Adua_tbTipoDocumento_Acce_tbUsuarios_usua_UsuarioModificacion_usua_Id]
GO
ALTER TABLE [Adua].[tbTipoIntermediario]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoIntermediario] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_usua_UsuarioEliminacion]
GO
ALTER TABLE [Adua].[tbTipoIntermediario]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoIntermediario] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_usua_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTipoIntermediario]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoIntermediario] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTipoIntermediario_inte_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbTipoLiquidacion]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTipoLiquidacion_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoLiquidacion] CHECK CONSTRAINT [FK_Adua_tbTipoLiquidacion_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbTipoLiquidacion]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTipoLiquidacion_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTipoLiquidacion] CHECK CONSTRAINT [FK_Adua_tbTipoLiquidacion_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTiposIdentificacion_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] CHECK CONSTRAINT [FK_Prod_tbTiposIdentificacion_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTiposIdentificacion_tbUsuarios_iden_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] CHECK CONSTRAINT [FK_Prod_tbTiposIdentificacion_tbUsuarios_iden_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbTiposIdentificacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTiposIdentificacion_tbUsuarios_iden_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTiposIdentificacion] CHECK CONSTRAINT [FK_Prod_tbTiposIdentificacion_tbUsuarios_iden_UsuarioModificacion]
GO
ALTER TABLE [Adua].[tbTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Adua_tbTransporte_tbMarca_marca_id] FOREIGN KEY([marca_Id])
REFERENCES [Adua].[tbMarcas] ([marc_Id])
GO
ALTER TABLE [Adua].[tbTransporte] CHECK CONSTRAINT [FK_Adua_tbTransporte_tbMarca_marca_id]
GO
ALTER TABLE [Adua].[tbTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_pais_Id_Adua_tbTransporte_pais_Id] FOREIGN KEY([pais_Id])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Adua].[tbTransporte] CHECK CONSTRAINT [FK_Gral_tbPaises_pais_Id_Adua_tbTransporte_pais_Id]
GO
ALTER TABLE [Adua].[tbTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTransporte_tbUsuarios_tran_UsuCrea] FOREIGN KEY([usua_UsuarioCreacio])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTransporte] CHECK CONSTRAINT [FK_Prod_tbTransporte_tbUsuarios_tran_UsuCrea]
GO
ALTER TABLE [Adua].[tbTransporte]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTransporte_tbUsuarios_tran_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTransporte] CHECK CONSTRAINT [FK_Prod_tbTransporte_tbUsuarios_tran_UsuModifica]
GO
ALTER TABLE [Adua].[tbTransporte]  WITH CHECK ADD  CONSTRAINT [PK_Adua_tbTransporte_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTransporte] CHECK CONSTRAINT [PK_Adua_tbTransporte_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Adua].[tbTratadosLibreComercio]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTratadosLibreComercio_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTratadosLibreComercio] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTratadosLibreComercio_usua_UsuarioCreacion]
GO
ALTER TABLE [Adua].[tbTratadosLibreComercio]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTratadosLibreComercio_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Adua].[tbTratadosLibreComercio] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Adua_tbTratadosLibreComercio_usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbAldeas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbAldeas] CHECK CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbAldeas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbAldeas] CHECK CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbAldeas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbAldeas] CHECK CONSTRAINT [FK_Gral_tbAldeas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbAldeas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCiudades_Gral_tbAldeas_ciud_Id] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Gral].[tbAldeas] CHECK CONSTRAINT [FK_Gral_tbCiudades_Gral_tbAldeas_ciud_Id]
GO
ALTER TABLE [Gral].[tbCargos]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCargos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbCargos] CHECK CONSTRAINT [FK_Gral_tbCargos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbCargos]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCargos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbCargos] CHECK CONSTRAINT [FK_Gral_tbCargos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbCiudades]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbCiudades] CHECK CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbCiudades]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbCiudades] CHECK CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbCiudades]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbCiudades] CHECK CONSTRAINT [FK_Gral_tbCiudades_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbCiudades]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbProvincias_Gral_tbCiudades_pvin_Id] FOREIGN KEY([pvin_Id])
REFERENCES [Gral].[tbProvincias] ([pvin_Id])
GO
ALTER TABLE [Gral].[tbCiudades] CHECK CONSTRAINT [FK_Gral_tbProvincias_Gral_tbCiudades_pvin_Id]
GO
ALTER TABLE [Gral].[tbColonias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbAldeas_Gral_tbColonias_alde_Id] FOREIGN KEY([alde_Id])
REFERENCES [Gral].[tbAldeas] ([alde_Id])
GO
ALTER TABLE [Gral].[tbColonias] CHECK CONSTRAINT [FK_Gral_tbAldeas_Gral_tbColonias_alde_Id]
GO
ALTER TABLE [Gral].[tbColonias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCiudades_Gral_tbColonias_ciud_Id] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Gral].[tbColonias] CHECK CONSTRAINT [FK_Gral_tbCiudades_Gral_tbColonias_ciud_Id]
GO
ALTER TABLE [Gral].[tbColonias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbColonias] CHECK CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbColonias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbColonias] CHECK CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbColonias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbColonias] CHECK CONSTRAINT [FK_Gral_tbColonias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioCreacion]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbEmpleados_empl_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbCargos_Adua_tbasEmpleados_carg_Id] FOREIGN KEY([carg_Id])
REFERENCES [Gral].[tbCargos] ([carg_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Gral_tbCargos_Adua_tbasEmpleados_carg_Id]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbEmpleados_usua_UsuarioActivacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioActivacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Gral_tbEmpleados_usua_UsuarioActivacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbEstadosCiviles_Adua_tbEmpleados_escv_Id] FOREIGN KEY([escv_Id])
REFERENCES [Gral].[tbEstadosCiviles] ([escv_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Gral_tbEstadosCiviles_Adua_tbEmpleados_escv_Id]
GO
ALTER TABLE [Gral].[tbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbProvincias_Adua_tbEmpleados_pvin_Id] FOREIGN KEY([pvin_Id])
REFERENCES [Gral].[tbProvincias] ([pvin_Id])
GO
ALTER TABLE [Gral].[tbEmpleados] CHECK CONSTRAINT [FK_Gral_tbProvincias_Adua_tbEmpleados_pvin_Id]
GO
ALTER TABLE [Gral].[tbEstadosCiviles]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEstadosCiviles] CHECK CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbEstadosCiviles]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEstadosCiviles] CHECK CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbEstadosCiviles]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbEstadosCiviles] CHECK CONSTRAINT [FK_Gral_tbEstadosCiviles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbFormas_Envio]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbFormas_Envio] CHECK CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbFormas_Envio]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbFormas_Envio] CHECK CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbFormas_Envio]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbFormas_Envio] CHECK CONSTRAINT [FK_Gral_tbFormas_Envio_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbMonedas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbMonedas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbMonedas] CHECK CONSTRAINT [FK_Gral_tbMonedas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbMonedas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbMonedas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbMonedas] CHECK CONSTRAINT [FK_Gral_tbMonedas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbOficinas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbOficinas] CHECK CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbOficinas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbOficinas] CHECK CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbOficinas]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbOficinas] CHECK CONSTRAINT [FK_Gral_tbOficinas_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbOficio_Profesiones]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbOficio_Profesiones_ofpr_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbOficio_Profesiones] CHECK CONSTRAINT [FK_Gral_tbOficio_Profesiones_ofpr_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbOficio_Profesiones]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbOficio_Profesiones_ofpr_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbOficio_Profesiones] CHECK CONSTRAINT [FK_Gral_tbOficio_Profesiones_ofpr_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbPaises]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbPaises] CHECK CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbPaises]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbPaises] CHECK CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbPaises]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbPaises] CHECK CONSTRAINT [FK_Gral_tbPaises_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbProveedores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProveedores_prov_Ciudad] FOREIGN KEY([prov_Ciudad])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Gral].[tbProveedores] CHECK CONSTRAINT [FK_Prod_tbProveedores_prov_Ciudad]
GO
ALTER TABLE [Gral].[tbProveedores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_usua_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProveedores] CHECK CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_usua_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbProveedores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProveedores] CHECK CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_usua_UsuarioModificacion]
GO
ALTER TABLE [Gral].[tbProveedores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProveedores] CHECK CONSTRAINT [FK_Prod_tbProveedores_tbUsuarios_prov_UsuarioCreacion]
GO
ALTER TABLE [Gral].[tbProvincias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbPaises_Gral_tbProvincias_pais_Id] FOREIGN KEY([pais_Id])
REFERENCES [Gral].[tbPaises] ([pais_Id])
GO
ALTER TABLE [Gral].[tbProvincias] CHECK CONSTRAINT [FK_Gral_tbPaises_Gral_tbProvincias_pais_Id]
GO
ALTER TABLE [Gral].[tbProvincias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProvincias] CHECK CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbProvincias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProvincias] CHECK CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbProvincias]  WITH CHECK ADD  CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbProvincias] CHECK CONSTRAINT [FK_Gral_tbProvincias_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Gral].[tbUnidadMedidas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbUnidadMedidas] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioCreacion]
GO
ALTER TABLE [Gral].[tbUnidadMedidas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioEliminacion] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbUnidadMedidas] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioEliminacion]
GO
ALTER TABLE [Gral].[tbUnidadMedidas]  WITH CHECK ADD  CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Gral].[tbUnidadMedidas] CHECK CONSTRAINT [FK_Acce_tbUsuarios_Gral_tbUnidadesMedidas_unme_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbArea]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbArea_proc_Id_Prod_tbProcesos_proc_Id] FOREIGN KEY([proc_Id])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbArea] CHECK CONSTRAINT [FK_Prod_tbArea_proc_Id_Prod_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbArea]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbArea_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbArea] CHECK CONSTRAINT [FK_Prod_tbArea_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbArea]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbArea_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbArea] CHECK CONSTRAINT [FK_Prod_tbArea_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbArea]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbArea_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbArea] CHECK CONSTRAINT [FK_Prod_tbArea_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesOrden_Gral_tbEmpleados_empl_Id] FOREIGN KEY([empl_Id])
REFERENCES [Gral].[tbEmpleados] ([empl_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] CHECK CONSTRAINT [FK_Prod_tbAsignacionesOrden_Gral_tbEmpleados_empl_Id]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbOrdenCompraDetalles_asor_OrdenDetId] FOREIGN KEY([asor_OrdenDetId])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] CHECK CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbOrdenCompraDetalles_asor_OrdenDetId]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbProcesos_proc_Id] FOREIGN KEY([proc_Id])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] CHECK CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbUsuarios_asor_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] CHECK CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbUsuarios_asor_UsuCrea]
GO
ALTER TABLE [Prod].[tbAsignacionesOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbUsuarios_asor_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrden] CHECK CONSTRAINT [FK_Prod_tbAsignacionesOrden_tbUsuarios_asor_UsuModifica]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbLotes_lote_Id] FOREIGN KEY([lote_Id])
REFERENCES [Prod].[tbLotes] ([lote_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbLotes_lote_Id]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbtbAsignacionesOrden_asor_Id] FOREIGN KEY([asor_Id])
REFERENCES [Prod].[tbAsignacionesOrden] ([asor_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbtbAsignacionesOrden_asor_Id]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbUsuarios_amod_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbUsuarios_amod_UsuCrea]
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbUsuarios_amod_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbAsignacionesOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbAsignacionesModuloDetalle_tbUsuarios_amod_UsuModifica]
GO
ALTER TABLE [Prod].[tbCategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbCategoria] CHECK CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbCategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbCategoria] CHECK CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbCategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbCategoria] CHECK CONSTRAINT [FK_Prod_tbCategoria_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbClientes_clie_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbClientes] CHECK CONSTRAINT [FK_Prod_tbClientes_clie_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbClientes_clie_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbClientes] CHECK CONSTRAINT [FK_Prod_tbClientes_clie_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbClientes_pvin_Id_Gral_tbProvincias_pvin_Id] FOREIGN KEY([pvin_Id])
REFERENCES [Gral].[tbProvincias] ([pvin_Id])
GO
ALTER TABLE [Prod].[tbClientes] CHECK CONSTRAINT [FK_Prod_tbClientes_pvin_Id_Gral_tbProvincias_pvin_Id]
GO
ALTER TABLE [Prod].[tbClientes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbClientes_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbClientes] CHECK CONSTRAINT [FK_Prod_tbClientes_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbColores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbColores_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbColores] CHECK CONSTRAINT [FK_Prod_tbColores_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbColores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbColores_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbColores] CHECK CONSTRAINT [FK_Prod_tbColores_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbColores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbColores_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbColores] CHECK CONSTRAINT [FK_Prod_tbColores_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_tbOrdenCompraDetalles_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_tbOrdenCompraDetalles_code_Id]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbDocumentosOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbDocumentosOrdenCompraDetalles_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbEstilos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbEstilos] CHECK CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbEstilos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbEstilos] CHECK CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbEstilos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbEstilos] CHECK CONSTRAINT [FK_Prod_tbEstilos_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbFacturasExportacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacion_Acce_tbUsuarios_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacion] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacion_Acce_tbUsuarios_usua_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacion_Acce_tbUsuarios_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacion] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacion_Acce_tbUsuarios_usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacion_Adua_tbDuca_duca_Id] FOREIGN KEY([duca_Id])
REFERENCES [Adua].[tbDuca] ([duca_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacion] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacion_Adua_tbDuca_duca_Id]
GO
ALTER TABLE [Prod].[tbFacturasExportacion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacion_tbOrdenCompra_orco_Id] FOREIGN KEY([orco_Id])
REFERENCES [Prod].[tbOrdenCompra] ([orco_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacion] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacion_tbOrdenCompra_orco_Id]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_Acce_tbUsuarios_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_Acce_tbUsuarios_usua_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_Acce_tbUsuarios_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_Acce_tbUsuarios_usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_tbFacturasExportacion_faex_Id] FOREIGN KEY([faex_Id])
REFERENCES [Prod].[tbFacturasExportacion] ([faex_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_tbFacturasExportacion_faex_Id]
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_tbOrdenCompraDetalles_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbFacturasExportacionDetalles] CHECK CONSTRAINT [FK_Prod_tbFacturasExportacionDetalles_tbOrdenCompraDetalles_code_Id]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] CHECK CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] CHECK CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbFuncionesMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbFuncionesMaquina] CHECK CONSTRAINT [FK_Prod_tbFuncionesMaquina_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_colr_Id_Prod_tbColores_colr_Id] FOREIGN KEY([colr_Id])
REFERENCES [Prod].[tbColores] ([colr_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_colr_Id_Prod_tbColores_colr_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_mate_Id_Prod_tbMateriales_mate_Id] FOREIGN KEY([mate_Id])
REFERENCES [Prod].[tbMateriales] ([mate_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_mate_Id_Prod_tbMateriales_mate_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_Prod_tbPedidosOrdenDetalle_prod_Id] FOREIGN KEY([prod_Id])
REFERENCES [Prod].[tbPedidosOrdenDetalle] ([prod_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_Prod_tbPedidosOrdenDetalle_prod_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_tbUsuarios_lote_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_tbUsuarios_lote_UsuCrea]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_tbUsuarios_lote_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_tbUsuarios_lote_UsuModifica]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_tipa_Id_Prod_tbTipoArea_tipa_Id] FOREIGN KEY([tipa_Id])
REFERENCES [Prod].[tbArea] ([tipa_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_tipa_Id_Prod_tbTipoArea_tipa_Id]
GO
ALTER TABLE [Prod].[tbLotes]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbLotes_unme_Id_Gral_tbUnidadMedidas_unme_Id] FOREIGN KEY([unme_Id])
REFERENCES [Gral].[tbUnidadMedidas] ([unme_Id])
GO
ALTER TABLE [Prod].[tbLotes] CHECK CONSTRAINT [FK_Prod_tbLotes_unme_Id_Gral_tbUnidadMedidas_unme_Id]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinaHistorial_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] CHECK CONSTRAINT [FK_Prod_tbMaquinaHistorial_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinaHistorial_Prod_tbMaquinas_maqu_Id] FOREIGN KEY([maqu_Id])
REFERENCES [Prod].[tbMaquinas] ([maqu_Id])
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] CHECK CONSTRAINT [FK_Prod_tbMaquinaHistorial_Prod_tbMaquinas_maqu_Id]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinaHistorial_tbUsuarios_mahi_UsuaCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] CHECK CONSTRAINT [FK_Prod_tbMaquinaHistorial_tbUsuarios_mahi_UsuaCrea]
GO
ALTER TABLE [Prod].[tbMaquinaHistorial]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinaHistorial_tbUsuarios_mahi_UsuModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinaHistorial] CHECK CONSTRAINT [FK_Prod_tbMaquinaHistorial_tbUsuarios_mahi_UsuModificacion]
GO
ALTER TABLE [Prod].[tbMaquinas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinas_Prod_tbModelosMaquina_mmaq_Id] FOREIGN KEY([mmaq_Id])
REFERENCES [Prod].[tbModelosMaquina] ([mmaq_Id])
GO
ALTER TABLE [Prod].[tbMaquinas] CHECK CONSTRAINT [FK_Prod_tbMaquinas_Prod_tbModelosMaquina_mmaq_Id]
GO
ALTER TABLE [Prod].[tbMaquinas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinas_Prod_tbModulos_modu_Id] FOREIGN KEY([modu_Id])
REFERENCES [Prod].[tbModulos] ([modu_Id])
GO
ALTER TABLE [Prod].[tbMaquinas] CHECK CONSTRAINT [FK_Prod_tbMaquinas_Prod_tbModulos_modu_Id]
GO
ALTER TABLE [Prod].[tbMaquinas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioCreacion_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinas] CHECK CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioCreacion_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMaquinas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinas] CHECK CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMaquinas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioModificacion_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaquinas] CHECK CONSTRAINT [FK_Prod_tbMaquinas_usua_UsuarioModificacion_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMarcasMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioCreacion_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMarcasMaquina] CHECK CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioCreacion_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMarcasMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMarcasMaquina] CHECK CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMarcasMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioModificacion_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMarcasMaquina] CHECK CONSTRAINT [FK_Prod_tbMarcasMaquina_usua_UsuarioModificacion_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMateriales]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMateriales_colr_Id_Prod_tbColores_colr_Id] FOREIGN KEY([colr_Id])
REFERENCES [Prod].[tbColores] ([colr_Id])
GO
ALTER TABLE [Prod].[tbMateriales] CHECK CONSTRAINT [FK_Prod_tbMateriales_colr_Id_Prod_tbColores_colr_Id]
GO
ALTER TABLE [Prod].[tbMateriales]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMateriales_subc_Id_Prod_tbSubcategoria_subc_Id] FOREIGN KEY([subc_Id])
REFERENCES [Prod].[tbSubcategoria] ([subc_Id])
GO
ALTER TABLE [Prod].[tbMateriales] CHECK CONSTRAINT [FK_Prod_tbMateriales_subc_Id_Prod_tbSubcategoria_subc_Id]
GO
ALTER TABLE [Prod].[tbMateriales]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMateriales_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMateriales] CHECK CONSTRAINT [FK_Prod_tbMateriales_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMateriales]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMateriales_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMateriales] CHECK CONSTRAINT [FK_Prod_tbMateriales_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaterialesBrindar_mabr_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] CHECK CONSTRAINT [FK_Prod_tbMaterialesBrindar_mabr_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbMaterialesBrindar_mabr_UsuarioModificacion_Acce_tbUsuarios_code_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] CHECK CONSTRAINT [FK_Prod_tbMaterialesBrindar_mabr_UsuarioModificacion_Acce_tbUsuarios_code_usua_Id]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_mate_Id_Prod_tbMateriales_mate_Id] FOREIGN KEY([mate_Id])
REFERENCES [Prod].[tbMateriales] ([mate_Id])
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_mate_Id_Prod_tbMateriales_mate_Id]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_unme_Id_Gral_tbUnidadMedidas] FOREIGN KEY([unme_Id])
REFERENCES [Gral].[tbUnidadMedidas] ([unme_Id])
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_unme_Id_Gral_tbUnidadMedidas]
GO
ALTER TABLE [Prod].[tbMaterialesBrindar]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbtbMaterialesBrindar_code_Id_Prod_tbOrdenCompraDetalles_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbMaterialesBrindar] CHECK CONSTRAINT [FK_Prod_tbtbMaterialesBrindar_code_Id_Prod_tbOrdenCompraDetalles_code_Id]
GO
ALTER TABLE [Prod].[tbModelosMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModelosMaquina_func_Id_Prod_tbFunciones_func_Id] FOREIGN KEY([func_Id])
REFERENCES [Prod].[tbFuncionesMaquina] ([func_Id])
GO
ALTER TABLE [Prod].[tbModelosMaquina] CHECK CONSTRAINT [FK_Prod_tbModelosMaquina_func_Id_Prod_tbFunciones_func_Id]
GO
ALTER TABLE [Prod].[tbModelosMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModelosMaquina_marq_Id_Prod_tbMarcasMaquina_marq_Id] FOREIGN KEY([marq_Id])
REFERENCES [Prod].[tbMarcasMaquina] ([marq_Id])
GO
ALTER TABLE [Prod].[tbModelosMaquina] CHECK CONSTRAINT [FK_Prod_tbModelosMaquina_marq_Id_Prod_tbMarcasMaquina_marq_Id]
GO
ALTER TABLE [Prod].[tbModelosMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuaCreaciaon_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModelosMaquina] CHECK CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuaCreaciaon_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbModelosMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuaModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModelosMaquina] CHECK CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuaModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbModelosMaquina]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModelosMaquina] CHECK CONSTRAINT [FK_Prod_tbModelosMaquina_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbModulos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModulos_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModulos] CHECK CONSTRAINT [FK_Prod_tbModulos_Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Prod].[tbModulos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModulos_empr_Id_Gral_tbEmpleados_empe_IdSupervisor] FOREIGN KEY([empr_Id])
REFERENCES [Gral].[tbEmpleados] ([empl_Id])
GO
ALTER TABLE [Prod].[tbModulos] CHECK CONSTRAINT [FK_Prod_tbModulos_empr_Id_Gral_tbEmpleados_empe_IdSupervisor]
GO
ALTER TABLE [Prod].[tbModulos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModulos_modu_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModulos] CHECK CONSTRAINT [FK_Prod_tbModulos_modu_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbModulos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModulos_modu_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbModulos] CHECK CONSTRAINT [FK_Prod_tbModulos_modu_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbModulos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbModulos_proc_Id_Prod_tbProcesos_proc_Id] FOREIGN KEY([proc_Id])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbModulos] CHECK CONSTRAINT [FK_Prod_tbModulos_proc_Id_Prod_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_code_Id_Prod_tbOrdenCompraDetalle_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_code_Id_Prod_tbOrdenCompraDetalle_code_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_empl_Id_Gral_tbEmpleados_empl_Id] FOREIGN KEY([empl_Id])
REFERENCES [Gral].[tbEmpleados] ([empl_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_empl_Id_Gral_tbEmpleados_empl_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_ppro_Id_Prod_tbPedidoProduccion_ppro_Id] FOREIGN KEY([ppro_Id])
REFERENCES [Prod].[tbPedidosProduccion] ([ppro_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_ppro_Id_Prod_tbPedidoProduccion_ppro_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_Prod_tbModulos_modu_Id] FOREIGN KEY([modu_Id])
REFERENCES [Prod].[tbModulos] ([modu_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_Prod_tbModulos_modu_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_usua_UsuarioCreacion_Acce_tbUsuario_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_usua_UsuarioCreacion_Acce_tbUsuario_usua_Id]
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_usua_UsuarioModificacion_Acce_tbUsuario_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrde_Ensa_Acab_Etiq] CHECK CONSTRAINT [FK_Prod_tbOrdenCorte_Ensamblado_Acabado_Etiquetado_usua_UsuarioModificacion_Acce_tbUsuario_usua_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_orco_IdCliente_Prod_tbClientes_clie_Id] FOREIGN KEY([orco_IdCliente])
REFERENCES [Prod].[tbClientes] ([clie_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompra] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_orco_IdCliente_Prod_tbClientes_clie_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_orco_IdEmbalaje_Prod_tbTipoEmbalaje_emba_Id] FOREIGN KEY([orco_IdEmbalaje])
REFERENCES [Prod].[tbTipoEmbalaje] ([tiem_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompra] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_orco_IdEmbalaje_Prod_tbTipoEmbalaje_emba_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_orco_MetodoPago_Gral_tbFormasPago_mepa_Id] FOREIGN KEY([orco_MetodoPago])
REFERENCES [Adua].[tbFormasdePago] ([fopa_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompra] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_orco_MetodoPago_Gral_tbFormasPago_mepa_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_orco_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompra] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_orco_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompra]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_orco_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompra] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_orco_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_code_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_code_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_code_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_code_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_colr_Id_Prod_tbColores_colr_Id] FOREIGN KEY([colr_Id])
REFERENCES [Prod].[tbColores] ([colr_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_colr_Id_Prod_tbColores_colr_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_esti_Id_Prod_tbEstilos_esti_Id] FOREIGN KEY([esti_Id])
REFERENCES [Prod].[tbEstilos] ([esti_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_esti_Id_Prod_tbEstilos_esti_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_orco_Id_Prod_tbOrdenCompra_orco_Id] FOREIGN KEY([orco_Id])
REFERENCES [Prod].[tbOrdenCompra] ([orco_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_orco_Id_Prod_tbOrdenCompra_orco_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_proc_IdActual_Prod_tbProcesos_proc_Id] FOREIGN KEY([proc_IdActual])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_proc_IdActual_Prod_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_proc_IdComienza_Prod_tbProcesos_proc_Id] FOREIGN KEY([proc_IdComienza])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_proc_IdComienza_Prod_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_tall_Id_Prod_tbTalla_tall_Id] FOREIGN KEY([tall_Id])
REFERENCES [Prod].[tbTallas] ([tall_Id])
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [FK_Prod_tbOrdenCompraDetalles_tall_Id_Prod_tbTalla_tall_Id]
GO
ALTER TABLE [Prod].[tbPedidosOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrden_Gral_tbCiudades_ciud_Id] FOREIGN KEY([ciud_Id])
REFERENCES [Gral].[tbCiudades] ([ciud_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrden] CHECK CONSTRAINT [FK_Prod_tbPedidosOrden_Gral_tbCiudades_ciud_Id]
GO
ALTER TABLE [Prod].[tbPedidosOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrden_prov_Id_Prod_tbProveedores_prov_Id] FOREIGN KEY([prov_Id])
REFERENCES [Gral].[tbProveedores] ([prov_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrden] CHECK CONSTRAINT [FK_Prod_tbPedidosOrden_prov_Id_Prod_tbProveedores_prov_Id]
GO
ALTER TABLE [Prod].[tbPedidosOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrden_tbDuca_Duca_Id] FOREIGN KEY([duca_Id])
REFERENCES [Adua].[tbDuca] ([duca_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrden] CHECK CONSTRAINT [FK_Prod_tbPedidosOrden_tbDuca_Duca_Id]
GO
ALTER TABLE [Prod].[tbPedidosOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrden_tbUsuarios_peor_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrden] CHECK CONSTRAINT [FK_Prod_tbPedidosOrden_tbUsuarios_peor_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbPedidosOrden]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrden_tbUsuarios_peor_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrden] CHECK CONSTRAINT [FK_Prod_tbPedidosOrden_tbUsuarios_peor_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_mate_Id_Pro_tbMateriales] FOREIGN KEY([mate_Id])
REFERENCES [Prod].[tbMateriales] ([mate_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_mate_Id_Pro_tbMateriales]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_pedi_Id_Pro_tbPedidos] FOREIGN KEY([pedi_Id])
REFERENCES [Prod].[tbPedidosOrden] ([peor_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_pedi_Id_Pro_tbPedidos]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_tbUsuarios_prod_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_tbUsuarios_prod_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_tbUsuarios_prod_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPedidosOrdenDetalle_tbUsuarios_prod_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPedidosProduccion]  WITH CHECK ADD  CONSTRAINT [FK_prod_tbPedidosProduccion_Prod_tbEmpleadosProduccion_empl_Id] FOREIGN KEY([empl_Id])
REFERENCES [Gral].[tbEmpleados] ([empl_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccion] CHECK CONSTRAINT [FK_prod_tbPedidosProduccion_Prod_tbEmpleadosProduccion_empl_Id]
GO
ALTER TABLE [Prod].[tbPedidosProduccion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccion_tbUsuarios_ppro_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccion] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccion_tbUsuarios_ppro_UsuCrea]
GO
ALTER TABLE [Prod].[tbPedidosProduccion]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccion_tbUsuarios_ppro_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccion] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccion_tbUsuarios_ppro_UsuModifica]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_lote_Id_Prod_tbLotes] FOREIGN KEY([lote_Id])
REFERENCES [Prod].[tbLotes] ([lote_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_lote_Id_Prod_tbLotes]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_ppro_Id_Prod_tbPedidosProduccion] FOREIGN KEY([ppro_Id])
REFERENCES [Prod].[tbPedidosProduccion] ([ppro_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_ppro_Id_Prod_tbPedidosProduccion]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_tbUsuarios_ppde_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_tbUsuarios_ppde_UsuCrea]
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_tbUsuarios_ppde_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPedidosProduccionDetalles] CHECK CONSTRAINT [FK_Prod_tbPedidosProduccionDetalle_tbUsuarios_ppde_UsuModifica]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_Acce_tbUsuarios_usua_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_Acce_tbUsuarios_usua_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_Acce_tbUsuarios_usua_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_Acce_tbUsuarios_usua_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbOrdenCompra_orco_Id] FOREIGN KEY([orco_Id])
REFERENCES [Prod].[tbOrdenCompra] ([orco_Id])
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbOrdenCompra_orco_Id]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbOrdenCompraDetalle_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbOrdenCompraDetalle_code_Id]
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbPedidosOrdenDetalle_prod_Id] FOREIGN KEY([prod_Id])
REFERENCES [Prod].[tbPedidosOrdenDetalle] ([prod_Id])
GO
ALTER TABLE [Prod].[tbPODetallePorPedidoOrdenDetalle] CHECK CONSTRAINT [FK_Prod_tbPODetallePorPedidoOrdenDetalle_tbPedidosOrdenDetalle_prod_Id]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_code_Id_Prod_tbOrdenCompraDetalles_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] CHECK CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_code_Id_Prod_tbOrdenCompraDetalles_code_Id]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_proc_Id_Prod_tbProcesos_proc_Id] FOREIGN KEY([proc_Id])
REFERENCES [Prod].[tbProcesos] ([proc_Id])
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] CHECK CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_proc_Id_Prod_tbProcesos_proc_Id]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] CHECK CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbProcesoPorOrdenCompraDetalle] CHECK CONSTRAINT [FK_Prod_tbProcesoPorOrdenCompraDetalle_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbProcesos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesos_Acce_tbUsuarios_proce_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbProcesos] CHECK CONSTRAINT [FK_Prod_tbProcesos_Acce_tbUsuarios_proce_UsuModifica]
GO
ALTER TABLE [Prod].[tbProcesos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbProcesos] CHECK CONSTRAINT [FK_Prod_tbProcesos_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbProcesos]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbProcesos_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbProcesos] CHECK CONSTRAINT [FK_Prod_tbProcesos_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbReporteModuloDia]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDia_tbModulos_modu_Id] FOREIGN KEY([modu_Id])
REFERENCES [Prod].[tbModulos] ([modu_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDia] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDia_tbModulos_modu_Id]
GO
ALTER TABLE [Prod].[tbReporteModuloDia]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDia_tbUsuarios_remo_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDia] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDia_tbUsuarios_remo_UsuCrea]
GO
ALTER TABLE [Prod].[tbReporteModuloDia]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDia_tbUsuarios_remo_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDia] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDia_tbUsuarios_remo_UsuModifica]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_ReporteModuloDiaDetalle_OrdenDeProceso_ensa_Id] FOREIGN KEY([ensa_Id])
REFERENCES [Prod].[tbOrde_Ensa_Acab_Etiq] ([ensa_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] CHECK CONSTRAINT [FK_Prod_ReporteModuloDiaDetalle_OrdenDeProceso_ensa_Id]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbOrdenCompraDetalle_code_Id] FOREIGN KEY([code_Id])
REFERENCES [Prod].[tbOrdenCompraDetalles] ([code_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbOrdenCompraDetalle_code_Id]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbReporteModuloDia_remo_Id] FOREIGN KEY([remo_Id])
REFERENCES [Prod].[tbReporteModuloDia] ([remo_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbReporteModuloDia_remo_Id]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbUsuarios_rdet_UsuCrea] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbUsuarios_rdet_UsuCrea]
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbUsuarios_rdet_UsuModifica] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbReporteModuloDiaDetalle] CHECK CONSTRAINT [FK_Prod_tbReporteModuloDiaDetalle_tbUsuarios_rdet_UsuModifica]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidad_reca_Orden] FOREIGN KEY([ensa_Id])
REFERENCES [Prod].[tbOrde_Ensa_Acab_Etiq] ([ensa_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidad_reca_Orden]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidad_tbUsuarios_reca_UsuarioCreacion] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidad_tbUsuarios_reca_UsuarioCreacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidad_tbUsuarios_reca_UsuarioModificacion] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidad] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidad_tbUsuarios_reca_UsuarioModificacion]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbRevisionDeCalidadErrores] CHECK CONSTRAINT [FK_Prod_tbRevisionDeCalidadErros_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbSubcategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbSubcategoria_cate_Id_Prod_tbCategoria_cate_Id] FOREIGN KEY([cate_Id])
REFERENCES [Prod].[tbCategoria] ([cate_Id])
GO
ALTER TABLE [Prod].[tbSubcategoria] CHECK CONSTRAINT [FK_Prod_tbSubcategoria_cate_Id_Prod_tbCategoria_cate_Id]
GO
ALTER TABLE [Prod].[tbSubcategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbSubCategoria_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbSubcategoria] CHECK CONSTRAINT [FK_Prod_tbSubCategoria_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbSubcategoria]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbSubCategoria_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbSubcategoria] CHECK CONSTRAINT [FK_Prod_tbSubCategoria_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbTallas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_tall__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTallas] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_tall__Acce_tbUsuarios_usua_UsuarioEliminacion_usua_Id]
GO
ALTER TABLE [Prod].[tbTallas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_tall_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTallas] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_tall_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbTallas]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbOrdenCompra_tall_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTallas] CHECK CONSTRAINT [FK_Prod_tbOrdenCompra_tall_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTipoEmbajale_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioEliminacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] CHECK CONSTRAINT [FK_Prod_tbTipoEmbajale_usua_UsuarioEliminacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTipoEmbajale_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioModificacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] CHECK CONSTRAINT [FK_Prod_tbTipoEmbajale_usua_UsuarioModificacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Prod].[tbTipoEmbalaje]  WITH CHECK ADD  CONSTRAINT [FK_Prod_tbTipoEmbalaje_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id] FOREIGN KEY([usua_UsuarioCreacion])
REFERENCES [Acce].[tbUsuarios] ([usua_Id])
GO
ALTER TABLE [Prod].[tbTipoEmbalaje] CHECK CONSTRAINT [FK_Prod_tbTipoEmbalaje_usua_UsuarioCreacion_Acce_tbUsuarios_usua_Id]
GO
ALTER TABLE [Adua].[tbDocumentosContratos]  WITH CHECK ADD  CONSTRAINT [CK_Adua_tbDocumentosContratos_doco_TipoDocumento] CHECK  (([doco_TipoDocumento]='EPC-SM' OR [doco_TipoDocumento]='RTN-SM' OR [doco_TipoDocumento]='DECL-CI' OR [doco_TipoDocumento]='DNI-RL' OR [doco_TipoDocumento]='RTN-RL' OR [doco_TipoDocumento]='DNI-CI' OR [doco_TipoDocumento]='RTN-CI'))
GO
ALTER TABLE [Adua].[tbDocumentosContratos] CHECK CONSTRAINT [CK_Adua_tbDocumentosContratos_doco_TipoDocumento]
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles]  WITH CHECK ADD  CONSTRAINT [CK_Prod_tbOrdenCompraDetalles_code_Sexo] CHECK  (([code_Sexo]='U' OR [code_Sexo]='M' OR [code_Sexo]='F'))
GO
ALTER TABLE [Prod].[tbOrdenCompraDetalles] CHECK CONSTRAINT [CK_Prod_tbOrdenCompraDetalles_code_Sexo]
GO
/****** Object:  StoredProcedure [Acce].[UDP_CambiarContrasena]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*************   Cambiar Contraseña  ****************
CREATE   PROCEDURE [Acce].[UDP_CambiarContrasena] /*'juan', 'awsd' */
	@usua_Nombre			NVARCHAR(150),
	@usua_Contrasenia		NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		DECLARE @NuevaContrasenaEncriptada NVARCHAR(MAX)=(SELECT HASHBYTES('SHA2_512', @usua_Contrasenia));

		UPDATE Acce.tbUsuarios
		SET usua_Contrasenia = @NuevaContrasenaEncriptada
		WHERE usua_Nombre = @usua_Nombre 

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_CorreoUsuario]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*************   Correo según usuario  ****************--
CREATE   PROCEDURE [Acce].[UDP_CorreoUsuario] 
	@usua_Nombre		NVARCHAR(100)
AS
BEGIN
	SELECT empl_CorreoElectronico 
	FROM (VALUES(NULL))V(N)
	LEFT JOIN Gral.tbEmpleados empl
	INNER JOIN Acce.tbUsuarios usua	ON empl.empl_Id = usua.empl_Id
	ON usua_Nombre = @usua_Nombre
	AND usua_Estado = 1
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_IniciarSesion]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*************   Iniciar Sesion  ****************

CREATE   PROCEDURE [Acce].[UDP_IniciarSesion] /*'juan', '123'*/
	@usua_Nombre			NVARCHAR(150),
	@usua_Contrasenia		NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		DECLARE @contrasenaEncriptada NVARCHAR(MAX)=(SELECT HASHBYTES('SHA2_512', @usua_Contrasenia));

		IF EXISTS (SELECT * 
				   FROM Acce.tbUsuarios 
				   WHERE usua_Nombre = @usua_Nombre 
				   AND usua_Contrasenia = @contrasenaEncriptada
				   AND usua_Estado = 1)
			BEGIN
			SELECT usua_Id,
					   usua_Nombre,
					   usua.empl_Id,
					   CONCAT(empl.empl_Nombres, ' ', empl.empl_Apellidos) AS emplNombreCompleto,
					   empl_CorreoElectronico,
					   empl_EsAduana,
					   usua_Image,
					   usua.role_Id,
					   rol.role_Descripcion,
					   usua_EsAdmin,
			CASE
				WHEN usua_EsAdmin = 1 
					THEN (select TOP(1) pant_URL from acce.tbPantallas tpl WHERE tpl.pant_EsAduana = empl_EsAduana AND (tpl.pant_Identificador = 'InicioProduccion' OR tpl.pant_Identificador = 'InicioAduana'))
				ELSE ISNULL((select TOP(1) pant_URL from acce.tbRolesXPantallas trp INNER JOIN acce.tbPantallas tpl ON tpl.pant_Id = trp.pant_Id WHERE trp.role_Id = usua.role_Id AND (tpl.pant_Identificador = 'InicioProduccion' OR tpl.pant_Identificador = 'InicioAduana')),'/inicio/Blank')
			END as usua_URLInicial
			FROM Acce.tbUsuarios usua
				LEFT JOIN Acce.tbRoles rol				ON usua.role_Id = rol.role_Id
				LEFT JOIN Gral.tbEmpleados empl			ON usua.empl_Id = empl.empl_Id
			WHERE usua_Nombre = @usua_Nombre 
				AND usua_Contrasenia = @contrasenaEncriptada
			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_RolesPorPantalla_DibujadoMenu]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Acce].[UDP_RolesPorPantalla_DibujadoMenu] 
    @role_ID INT
AS
BEGIN
    SELECT 
        rxp.ropa_Id, 
        pnt.pant_Id, 
        pant_Nombre,
        pant_URL,
        pant_Icono,
        pant_Esquema,
		pant_Subcategoria,
		pant_EsAduana,
        CASE 
            WHEN pnt.pant_Id = rxp.pant_Id THEN 'Asignada'
            ELSE 'No asignada' 
        END AS Asignada,
        pnt.usua_UsuarioCreacion, 
        ropa_FechaCreacion,
		pnt.pant_Identificador
    FROM Acce.tbPantallas pnt
    LEFT JOIN Acce.tbRolesXPantallas rxp 
	ON pnt.pant_Id = rxp.pant_Id 
	AND rxp.role_Id = @role_ID;
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_RolesPorPantalla_DibujarMenu]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ESTE ES EL PROCEDIMIENTO QUE HIZO JAVIER SI ESTA MALO PATEENLO
CREATE   PROCEDURE [Acce].[UDP_RolesPorPantalla_DibujarMenu] 
AS
BEGIN

	SELECT	pant.pant_Id, 
			pant.pant_Nombre, 
			pant.pant_URL, 
			pant.pant_Icono, 
			pant.pant_Esquema, 
			pant.pant_EsAduana, 
			pant.pant_Subcategoria,
			pant.pant_Identificador,
			CASE
    WHEN pant.pant_Identificador = 'InicioGeneral' THEN (SELECT role_Descripcion FROM acce.tbRoles FOR JSON PATH)
    ELSE (select	innerrols.role_Descripcion 
			from Acce.tbRolesXPantallas inerropa INNER JOIN Acce.tbPantallas innerpant  
			ON inerropa.pant_Id = innerpant.pant_Id INNER JOIN Acce.tbRoles innerrols 
			ON inerropa.role_Id = innerrols.role_Id
			WHERE innerpant.pant_Nombre = pant.pant_Nombre
			ORDER BY innerpant.pant_Nombre  
			FOR JSON PATH )
END AS Detalles
	FROM	Acce.tbPantallas pant 

END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbPantallas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*************   Tabla pantallas  ****************

/* Listar pantallas*/
CREATE   PROCEDURE [Acce].[UDP_tbPantallas_Listar]
	@pant_EsAduana  BIT
AS
BEGIN
	SELECT pant_Id, 
		   pant_Nombre, 
		   pant_URL, 
		   pant_Icono, 
		   pant_Esquema,
		   pant_EsAduana,
		   usua_UsuarioCreacion,
		   pant_FechaCreacion,
		   usua_UsuarioModificacion,
		   pant_FechaModificacion,
		   usua_UsuarioEliminacion,
		   pant_FechaEliminacion,
		   pant_Identificador
	  FROM Acce.tbPantallas
	 WHERE pant_Estado = 1
	 AND (pant_EsAduana = @pant_EsAduana 
	 OR pant_EsAduana IS NULL)
	 OR @pant_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRoles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Editar Roles*/
CREATE   PROCEDURE [Acce].[UDP_tbRoles_Editar]
	@role_Id					INT,
	@role_Descripcion			NVARCHAR(500),
	@pant_Ids					NVARCHAR(MAX),
	@usua_UsuarioModificacion	INT,
	@roleFechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @role_IdEliminar INT = (SELECT role_Id
										FROM Acce.tbRoles
										WHERE role_Descripcion = @role_Descripcion
										AND role_Estado = 0)

		IF (@role_IdEliminar IS NOT NULL)
			BEGIN
				DELETE FROM Acce.tbRolesXPantallas
				WHERE role_Id = @role_IdEliminar

				DELETE FROM Acce.tbRoles
				WHERE role_Id = @role_IdEliminar
			END
        
        UPDATE Acce.tbRoles
           SET role_Descripcion = @role_Descripcion             
              ,usua_UsuarioModificacion = @usua_UsuarioModificacion
              ,role_FechaModificacion = @roleFechaModificacion          
         WHERE role_Id = @role_Id

        -- Elimina las asignaciones existentes de pantallas para el rol
        DELETE FROM Acce.tbRolesXPantallas
        WHERE role_Id = @role_Id

        -- Inserta nuevas asignaciones de pantallas
        INSERT INTO Acce.tbRolesXPantallas (pant_Id, 
                                                role_Id, 
                                                usua_UsuarioCreacion, 
                                                ropa_FechaCreacion)
        SELECT DISTINCT
                pant.pant_Id,
                @role_Id,
                @usua_UsuarioModificacion,
                @roleFechaModificacion
        FROM OPENJSON(@pant_Ids, '$.pantallas') WITH (pant_Id INT) pant
        WHERE NOT EXISTS (
            SELECT 1
            FROM Acce.tbRolesXPantallas
            WHERE role_Id = @role_Id
            AND pant_Id = pant.pant_Id
        )

        SELECT 1

    END TRY
    BEGIN CATCH
        SELECT 'Error Message: ' + ERROR_MESSAGE()
    END CATCH
END

GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRoles_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Eliminar Roles*/
CREATE   PROCEDURE [Acce].[UDP_tbRoles_Eliminar]
	@role_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@role_FechaEliminacion		DATETIME
AS
BEGIN
	SET @role_FechaEliminacion = GETDATE();
	BEGIN TRY
		IF NOT EXISTS (SELECT * 
				   FROM Acce.tbUsuarios
				   WHERE role_Id = @role_Id)
			BEGIN
				
				DELETE FROM Acce.tbRolesXPantallas
				WHERE role_Id = @role_Id

				SELECT 1

				UPDATE	Acce.tbRoles
				SET		role_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						role_FechaEliminacion = @role_FechaEliminacion
				WHERE role_Id = @role_Id
			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRoles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Insertar Roles*/
CREATE   PROCEDURE [Acce].[UDP_tbRoles_Insertar] 
	@role_Descripcion			NVARCHAR(500),
	@role_Aduana				BIT,
	@pant_Ids					NVARCHAR(MAX),
	@usua_UsuarioCreacion		INT,
	@role_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
				INSERT INTO Acce.tbRoles(role_Descripcion, 
										 role_Aduana,
										 usua_UsuarioCreacion, 
										 role_FechaCreacion)
				VALUES (@role_Descripcion,
						@role_Aduana,
					    @usua_UsuarioCreacion,
						@role_FechaCreacion);

				DECLARE @role_Id INT = SCOPE_IDENTITY();

				INSERT INTO Acce.tbRolesXPantallas (pant_Id, 
													    role_Id, 
													    usua_UsuarioCreacion, 
													    ropa_FechaCreacion )
				SELECT *,
				      @role_Id,
					  @usua_UsuarioCreacion,
					  @role_FechaCreacion 
				FROM OPENJSON(@pant_Ids, '$.pantallas')
				WITH (
					pant_Id INT
				) 

				SELECT 1
	COMMIT TRAN
	END TRY
	BEGIN CATCH
		 ROLLBACK TRAN
		 SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRoles_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*********** Tabla Roles *****************
/* listar Roles*/
CREATE   PROCEDURE [Acce].[UDP_tbRoles_Listar]
	@role_Aduana	BIT
AS
BEGIN
	SELECT tbroles.role_Id, 
		   role_Descripcion,
		   tbroles.role_Aduana, 
		   CASE role_Aduana
		   WHEN 1 THEN 'Sí'
		   ELSE 'No' END AS Aduanero,
		   tbroles.usua_UsuarioCreacion,
		   usuCrea.usua_Nombre as UsuarioCreacionNombre,
		   role_FechaCreacion, 
		   tbroles.usua_UsuarioModificacion,
		   usuModi.usua_Nombre as UsuarioModificadorNombre,
		   role_FechaModificacion, 
		   tbroles.usua_UsuarioEliminacion, 
		   role_FechaEliminacion,
		   role_Estado,
		   (SELECT ropa_Id,
				   tbropa.pant_Id,
				   pant_Nombre
   FROM Acce.tbRolesXPantallas tbropa
   INNER JOIN Acce.tbPantallas tbpa
   ON tbropa.pant_Id = tbpa.pant_Id
   WHERE tbroles.role_Id = tbropa.role_Id

   FOR JSON PATH) 
   AS Detalles

	FROM Acce.tbRoles tbroles
	LEFT JOIN Acce.tbUsuarios usuModi
    ON tbroles.usua_UsuarioModificacion = usuModi.usua_Id
    INNER JOIN Acce.tbUsuarios usuCrea
    ON tbroles.usua_UsuarioCreacion = usuCrea.usua_Id
	WHERE role_Estado = 1
	AND role_Aduana = @role_Aduana
	OR @role_Aduana IS NULL
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRolesXPantallas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Editar RolesXPantallas*/
CREATE   PROCEDURE [Acce].[UDP_tbRolesXPantallas_Editar]
	@pant_Id					INT,
	@role_Id					INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO Acce.tbRolesXPantallas (pant_Id, role_Id, usua_UsuarioCreacion, ropa_FechaCreacion, usua_UsuarioModificacion, ropa_FechaModificacion, usua_UsuarioEliminacion, ropa_FechaEliminacion, ropa_Estado)
		VALUES(@pant_Id,@role_Id,NULL, NULL,NULL,NULL,NULL,NULL,1);
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRolesXPantallas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Eliminar RolesXPantallas*/
CREATE   PROCEDURE [Acce].[UDP_tbRolesXPantallas_Eliminar]
	@role_Id					INT
AS
BEGIN
	BEGIN TRY
		DELETE FROM Acce.tbRolesXPantallas WHERE role_Id = @role_Id
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRolesXPantallas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Insertar RolesXPantallas*/
CREATE   PROCEDURE [Acce].[UDP_tbRolesXPantallas_Insertar]
	@pant_Id				INT,
	@role_Id				INT,
	@usua_UsuarioCreacion	INT,
	@ropa_FechaCreacion		DATETIME
AS
BEGIN
	SET @ropa_FechaCreacion = GETDATE();
	BEGIN TRY
		INSERT INTO Acce.tbRolesXPantallas (pant_Id, role_Id, usua_UsuarioCreacion, ropa_FechaCreacion, usua_UsuarioModificacion, ropa_FechaModificacion, usua_UsuarioEliminacion, ropa_FechaEliminacion, ropa_Estado)
		VALUES(@pant_Id,@role_Id,@usua_UsuarioCreacion, @ropa_FechaCreacion,NULL,NULL,NULL,NULL,1);
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbRolesXPantallas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*************   Tabla Roles por pantallas  ****************

/* Listar Pantallas por id de rol*/
CREATE   PROCEDURE [Acce].[UDP_tbRolesXPantallas_Listar]
	@role_Id		INT
AS
BEGIN
	SELECT		T2.pant_Id,
				T2.pant_Nombre,
				T2.pant_URL,
				T2.pant_Icono
	FROM		Acce.tbRolesXPantallas T1 
	INNER JOIN	Acce.tbPantallas T2
	ON			T1.pant_Id = T2.pant_Id
	WHERE		T1.role_Id = @role_Id
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_Activar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Activar Usuarios*/
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_Activar]
	@usua_Id					INT,
	@usua_UsuarioActivacion		INT,
	@usua_FechaActivacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
			 UPDATE Acce.tbUsuarios
			    SET usua_Estado             = 1,
					usua_UsuarioActivacion  = @usua_UsuarioActivacion,
					usua_FechaActivacion    = @usua_FechaActivacion
			  WHERE usua_Id                 = @usua_Id
			  
			  SELECT 1

			  INSERT INTO acce.tbUsuariosHistorial (	usua_Id,
												usua_Nombre, 
												usua_Contrasenia, 
												empl_Id, 
												usua_Image, 
												role_Id, 
												usua_EsAdmin,
												hist_UsuarioAccion, 
												hist_FechaAccion,
												hist_Accion)
			SELECT usua_Id,
				   usua_Nombre, 
				   usua_Contrasenia, 
				   empl_Id, 
				   usua_Image, 
				   role_Id, 
				   usua_EsAdmin,
				   @usua_UsuarioActivacion, 
				   @usua_FechaActivacion,
				   'Activar'
			FROM acce.tbUsuarios
			WHERE usua_Id = @usua_Id

		END
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_CambiarFoto]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_CambiarFoto]
	@usua_Id					INT,
	@usua_Image					NVARCHAR(MAX),
	@usua_UsuarioModificacion	INT,
	@usua_FechaModificacion		DATE
AS
BEGIN
	BEGIN TRY
		UPDATE  acce.tbUsuarios
		SET		usua_Image = @usua_Image,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				usua_FechaModificacion = @usua_FechaModificacion 
		WHERE	usua_Id = @usua_Id
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar usuarios*/
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_Editar]
	@usua_Id					INT,
	@usua_Contrasenia			NVARCHAR(MAX),
	@empl_Id					INT,
	@usua_Image					NVARCHAR(500),
	@role_Id					INT, 
	@usua_EsAdmin				INT,
	@usua_UsuarioModificacion	INT,
	@usua_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  acce.tbUsuarios
		SET		empl_Id = @empl_Id,
				usua_Image = @usua_Image,
				role_Id = @role_Id,
				usua_EsAdmin = @usua_EsAdmin,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				usua_FechaModificacion = @usua_FechaModificacion 
		WHERE	usua_Id = @usua_Id

		INSERT INTO acce.tbUsuariosHistorial (	usua_Id,
												usua_Nombre, 
												usua_Contrasenia, 
												empl_Id, 
												usua_Image, 
												role_Id, 
												usua_EsAdmin,
												hist_UsuarioAccion, 
												hist_FechaAccion,
												hist_Accion)
			SELECT usua_Id,
				   usua_Nombre, 
				   usua_Contrasenia, 
				   @empl_Id, 
				   @usua_Image, 
				   @role_Id, 
				   @usua_EsAdmin,
				   @usua_UsuarioModificacion, 
				   @usua_FechaModificacion,
				   'Editar'
			FROM acce.tbUsuarios
			WHERE usua_Id = @usua_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Eliminar usuarios*/
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_Eliminar]
	@usua_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@usua_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE	acce.tbUsuarios
		SET		usua_Estado = 0,
				usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				usua_FechaEliminacion = @usua_FechaEliminacion
		WHERE	usua_Id = @usua_Id

		INSERT INTO acce.tbUsuariosHistorial (	usua_Id,
												usua_Nombre, 
												usua_Contrasenia, 
												empl_Id, 
												usua_Image, 
												role_Id, 
												usua_EsAdmin,
												hist_UsuarioAccion, 
												hist_FechaAccion,
												hist_Accion)
			SELECT usua_Id,
				   usua_Nombre, 
				   usua_Contrasenia, 
				   empl_Id, 
				   usua_Image, 
				   role_Id, 
				   usua_EsAdmin,
				   @usua_UsuarioEliminacion, 
				   @usua_FechaEliminacion,
				   'Eliminar'
			FROM acce.tbUsuarios
			WHERE usua_Id = @usua_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_Insertar] 
	@usua_Nombre			NVARCHAR(150),
	@usua_Contrasenia		NVARCHAR(MAX),
	@empl_Id				INT,
	@usua_esAduana			BIT,
	@usua_Image				NVARCHAR(500),
	@role_Id				INT, 
	@usua_EsAdmin			BIT,
	@usua_UsuarioCreacion	INT,
	@usua_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
		
		DECLARE @password NVARCHAR(MAX)=(SELECT HASHBYTES('Sha2_512', @usua_Contrasenia));
		DECLARE @usua_Id INT;


		IF EXISTS (SELECT * FROM acce.tbUsuarios
						WHERE @usua_Nombre = usua_Nombre
						AND usua_Estado = 0)
		BEGIN
			UPDATE acce.tbUsuarios
			SET	   usua_Estado = 1,
				   usua_Contrasenia = @password,
				   empl_Id = @empl_Id,
				   usua_esAduana = @usua_esAduana,
				   usua_Image = @usua_Image,
				   role_Id = @role_Id,
				   usua_EsAdmin = @usua_EsAdmin
			WHERE  usua_Nombre = @usua_Nombre

			SET @usua_Id = (SELECT usua_Id FROM acce.tbUsuarios WHERE  usua_Nombre = @usua_Nombre)
			SELECT 1
		END
		ELSE 
			BEGIN
				INSERT INTO acce.tbUsuarios (usua_Nombre, 
											 usua_Contrasenia, 
											 empl_Id,	
											 usua_esAduana,
											 usua_Image, 
											 role_Id, 
											 usua_EsAdmin,
											 usua_UsuarioCreacion, 
											 usua_FechaCreacion)
			VALUES(@usua_Nombre,
					@password,
					@empl_Id,
					@usua_esAduana,
					@usua_Image,
					@role_Id,
					@usua_EsAdmin,
					@usua_UsuarioCreacion,
					@usua_FechaCreacion)

			SET @usua_Id = SCOPE_IDENTITY();

			SELECT 1
		END

			INSERT INTO acce.tbUsuariosHistorial (usua_Id,
												  usua_Nombre, 
												  usua_Contrasenia, 
												  empl_Id, 
												  usua_esAduana,
												  usua_Image, 
												  role_Id, 
												  usua_EsAdmin,
												  hist_UsuarioAccion, 
												  hist_FechaAccion,
												  hist_Accion)
			VALUES( @usua_Id,
					@usua_Nombre,
					@password,
					@empl_Id,
					@usua_esAduana,
					@usua_Image,
					@role_Id,
					@usua_EsAdmin,
					@usua_UsuarioCreacion,
					@usua_FechaCreacion,
					'Insertar')
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Acce].[UDP_tbUsuarios_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Acce].[UDP_tbUsuarios_Listar] 
	@empl_EsAduana		BIT
AS
BEGIN
	SELECT usua.usua_Id, 
		   usua.usua_Nombre, 
		   usua.usua_Contrasenia, 
		   usua.role_Id,
		   rol.role_Descripcion, 
		   usua.usua_EsAdmin,
		   usua.empl_Id,
		   usua.usua_esAduana,
		   usua.usua_Image,
		   (empl_Nombres + ' ' + empl_Apellidos) AS emplNombreCompleto, 
		   empl_EsAduana,
		   empl_CorreoElectronico,
		   usua.usua_UsuarioCreacion, 
		   usuaCrea.usua_Nombre AS usuarioCreacionNombre,
		   usua.usua_FechaCreacion, 
	       usua.usua_UsuarioModificacion, 
		   usuaModifica.usua_Nombre AS usuarioModificacionNombre, 
		   usua.usua_FechaModificacion,
		   usuaElimina.usua_Nombre AS usuarioEliminacionNombre, 
		   usua.usua_FechaEliminacion,
		   usua.usua_UsuarioActivacion,
		   usuaActiva.usua_Nombre	AS usuarioActivacionNombre,
		   usua.usua_FechaActivacion,
		   usua.usua_Estado,
		   empl.empl_CorreoElectronico
	FROM Acce.tbUsuarios usua LEFT JOIN Acce.tbRoles rol
	ON usua.role_Id = rol.role_Id
	LEFT JOIN Gral.tbEmpleados empl
	ON empl.empl_Id = usua.empl_Id 
	LEFT JOIN acce.tbUsuarios usuaCrea
	ON usua.usua_UsuarioCreacion = usuaCrea.usua_Id
	LEFT JOIN acce.tbUsuarios usuaModifica
	ON usua.usua_UsuarioModificacion = usuaModifica.usua_Id 
	LEFT JOIN acce.tbUsuarios usuaElimina
	ON usua.usua_UsuarioEliminacion = usuaElimina.usua_Id
	LEFT JOIN acce.tbUsuarios usuaActiva
	ON usua.usua_UsuarioActivacion = usuaActiva.usua_Id
WHERE usua.usua_esAduana = @empl_EsAduana
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_AduanasIngreso_CantidadPorcentaje]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Aduanas con mas importaciones 
CREATE   PROCEDURE [Adua].[UDP_AduanasIngreso_CantidadPorcentaje]
AS 
	BEGIN
		DECLARE @totaldevas INT = (SELECT COUNT(deva_AduanaIngresoId) FROM Adua.tbDeclaraciones_Valor )

		SELECT
			adua.adua_Nombre,
			SUM(deva.deva_AduanaIngresoId) AS Cantidad,
			(CAST(COUNT(deva.deva_AduanaIngresoId) AS decimal(18, 2)) / @totaldevas * 100) AS Porcentaje
			FROM Adua.tbDeclaraciones_Valor deva
			INNER JOIN Adua.tbAduanas adua ON deva.deva_AduanaIngresoId = adua.adua_Id
			GROUP BY adua.adua_Nombre
	END
GO
/****** Object:  StoredProcedure [Adua].[UDP_EstadosMercancias_CantidadPorcentaje]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Estados Mercancias mas Frecuentes
CREATE   PROCEDURE [Adua].[UDP_EstadosMercancias_CantidadPorcentaje]
AS
	BEGIN
		SELECT   mercancias.merc_Descripcion,
		SUM(item_Cantidad) AS Cantidad,
		((CAST(SUM(item_Cantidad) AS DECIMAL(18,2)) / CAST((SELECT SUM(item_Cantidad) FROM Adua.tbItems) AS DECIMAL(18,2))) * 100) AS Porcentaje
		FROM Adua.tbItems items INNER JOIN Adua.tbEstadoMercancias mercancias
		ON items.merc_Id = mercancias.merc_Id
		GROUP BY mercancias.merc_Descripcion
	END
GO
/****** Object:  StoredProcedure [Adua].[UDP_ExportadoresPorPais_CantidadPorcentaje]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Pasies de Origen de exportadores
CREATE   PROCEDURE [Adua].[UDP_ExportadoresPorPais_CantidadPorcentaje]                                           
AS
		BEGIN
			SELECT		pais.pais_Nombre,
						COUNT(duca.duca_Pais_Emision_Exportador) AS duca_Pais_Emision_Exportador,
						CAST((SELECT CAST(COUNT(duca.duca_Pais_Emision_Exportador) AS DECIMAL(18,2)) / CAST((SELECT COUNT(duca_Pais_Emision_Exportador) FROM Adua.tbDuca) AS DECIMAL(18,2)) * 100) AS decimal(18,2)) as Porcentaje
			FROM		Adua.tbDuca duca INNER JOIN Gral.tbPaises pais ON duca.duca_Pais_Emision_Exportador = pais.pais_Id
			GROUP BY	duca_Pais_Emision_Exportador,pais.pais_Nombre
	END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAduanas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Aduanas Editar*/
CREATE   PROCEDURE [Adua].[UDP_tbAduanas_Editar] 
	@adua_Id                   INT,
	@adua_Codigo				char(4), 
	@adua_Nombre               NVARCHAR(MAX), 
	@ciud_Id				   INT,
	@adua_Direccion_Exacta     NVARCHAR(MAX),   
	@usua_UsuarioModificacion  INT, 
	@adua_FechaModificacion    DATETIME
AS
BEGIN 
	BEGIN TRY   
     
		IF EXISTS (SELECT adua_Id
				   FROM Adua.tbAduanas
				   WHERE adua_Codigo = @adua_Codigo
				   AND adua_Estado = 0)
			BEGIN
				DELETE FROM Adua.tbAduanas
				WHERE adua_Codigo = @adua_Codigo
				AND adua_Estado = 0
			END

		UPDATE  Adua.tbAduanas 
		SET    adua_Nombre = @adua_Nombre,
			    adua_Codigo = @adua_Codigo,
				ciud_Id = @ciud_Id,
			    adua_Direccion_Exacta = @adua_Direccion_Exacta, 		   
			    usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			    adua_FechaModificacion = @adua_FechaModificacion
		WHERE  adua_Id = @adua_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAduanas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Aduana Eliminar*/
CREATE   PROCEDURE [Adua].[UDP_tbAduanas_Eliminar] 
	 @adua_Id					INT,
	 @usua_UsuarioEliminacion	INT,
	 @adua_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
		   
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'adua_Id',  @adua_Id, 'Adua.tbAduanas', @respuesta OUTPUT

			IF(@respuesta) = 1
				BEGIN
					UPDATE Adua.tbAduanas
					SET adua_Estado = 0,
					    usua_UsuarioEliminacion=@usua_UsuarioEliminacion,
                        adua_FechaEliminacion=@adua_FechaEliminacion
					WHERE adua_Id = @adua_Id
				END

			SELECT @respuesta AS Resultado
		END
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAduanas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbAduanas_Insertar] 
   @adua_Codigo				   char(4),
   @adua_Nombre                NVARCHAR(MAX),
   @ciud_Id						INT,
   @adua_Direccion_Exacta      NVARCHAR(MAX), 
   @usua_UsuarioCreacion       INT,  
   @adua_FechaCreacion         DATETIME
AS 
BEGIN 
     BEGIN TRY 
		
		IF EXISTS (SELECT * FROM Adua.tbAduanas  
		  WHERE @adua_Codigo = adua_Codigo
			AND adua_Estado = 0)
			BEGIN 
			   UPDATE Adua.tbAduanas
			   SET    adua_Estado = 1,
					  adua_Nombre = @adua_Nombre,
					  ciud_Id = @ciud_Id,
			          adua_Direccion_Exacta = @adua_Direccion_Exacta, 
			          usua_UsuarioModificacion=@usua_UsuarioCreacion
				WHERE @adua_Codigo = adua_Codigo

			   SELECT 1	    
		   END 
	     ELSE 
		   BEGIN 
		     INSERT INTO Adua.tbAduanas
			 (adua_Nombre, 
			  adua_Codigo,
			  ciud_Id,
			  adua_Direccion_Exacta, 
			  usua_UsuarioCreacion, 
			  adua_FechaCreacion			  
			 )
			 VALUES 
			 ( 
			 @adua_Nombre,     
			 @adua_Codigo,  
			 @ciud_Id,
			 @adua_Direccion_Exacta,
			 @usua_UsuarioCreacion, 
			 @adua_FechaCreacion   
			 )			
			  SELECT 1			
			END
	     END TRY
	 BEGIN CATCH 
	    SELECT 'Error Message: ' + ERROR_MESSAGE()
	 END CATCH 
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAduanas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbAduanas_Listar]
AS
BEGIN
SELECT    adu.adua_Id                            ,
        adu.adua_Codigo                        ,
        gral.ProperCase(adu.adua_Nombre)   AS adua_Nombre,
        adu.adua_Direccion_Exacta            ,
        adu.ciud_Id,
        ciud.ciud_Nombre                    ,
        prov.pvin_Id                         ,
        prov.pvin_Nombre                    ,
        usu.usua_Nombre                        AS usarioCreacion,
        adu.adua_FechaCreacion                ,
        usu2.usua_Nombre                    AS usuarioModificacion,
        adu.adua_FechaModificacion            ,
        adu.adua_Estado
FROM    Adua.tbAduanas adu 
        INNER JOIN Acce.tbUsuarios usu        ON adu.usua_UsuarioCreacion = usu.usua_Id 
        LEFT JOIN Acce.tbUsuarios usu2        ON usu2.usua_Id = adu.usua_UsuarioModificacion 
        LEFT JOIN Gral.tbCiudades ciud      ON ciud.ciud_Id = adu.ciud_Id
        LEFT JOIN Gral.tbProvincias prov   ON prov.pvin_Id = ciud.pvin_Id
 WHERE    adu.adua_Estado = 1
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAduanas_Listar_ById]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Listar aduanas ById*/
CREATE   PROCEDURE [Adua].[UDP_tbAduanas_Listar_ById]
@adua_Id INT
AS
BEGIN
SELECT    adu.adua_Id                            ,
        adu.adua_Codigo                        ,
        gral.ProperCase(adu.adua_Nombre)   AS adua_Nombre,
        adu.adua_Direccion_Exacta            ,
        adu.ciud_Id,
        ciud.ciud_Nombre                    ,
        prov.pvin_Id                         ,
        prov.pvin_Nombre                    ,
        usu.usua_Nombre                        AS usarioCreacion,
        adu.adua_FechaCreacion                ,
        usu2.usua_Nombre                    AS usuarioModificacion,
        adu.adua_FechaModificacion            ,
        adu.adua_Estado
FROM    Adua.tbAduanas adu 
        INNER JOIN Acce.tbUsuarios usu        ON adu.usua_UsuarioCreacion = usu.usua_Id 
        LEFT JOIN Acce.tbUsuarios usu2        ON usu2.usua_Id = adu.usua_UsuarioModificacion 
        LEFT JOIN Gral.tbCiudades ciud      ON ciud.ciud_Id = adu.ciud_Id
        LEFT JOIN Gral.tbProvincias prov   ON prov.pvin_Id = ciud.pvin_Id
 WHERE  adu.adua_Estado = 1 AND adu.adua_Id = @adua_Id
 ORDER BY adua_FechaCreacion DESC
END

/*Aduanas Crear */
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Aranceles*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_Editar] 
	@aran_Id					INT,
	@aran_Codigo				NVARCHAR(100),
	@aran_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@aran_FechaModificacion		DATETIME
AS
BEGIN
	SET @aran_FechaModificacion = GETDATE();
	BEGIN TRY
		UPDATE Adua.tbAranceles
		   SET aran_Codigo = @aran_Codigo
			  ,aran_Descripcion = @aran_Descripcion
			  ,usua_UsuarioModificacion = @usua_UsuarioModificacion
			  ,aran_FechaModificacion = @aran_FechaModificacion
		 WHERE aran_Id = @aran_Id
		 SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END


/*******************************Condiciones comerciales *******************************/ 

/*Listar Condiciones comerciales*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Insertar Aranceles*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_Insertar] 
	@aran_Codigo				NVARCHAR(100),
	@aran_Descripcion			NVARCHAR(150),
	@usua_UsuarioCreacion		INT,
	@aran_FechaCreacion			DATETIME
AS
BEGIN
	SET @aran_FechaCreacion = GETDATE();
	BEGIN TRY
		INSERT INTO Adua.tbAranceles (aran_Codigo, 
									  aran_Descripcion, 
									  usua_UsuarioCreacion, 
									  aran_FechaCreacion)
		VALUES	(@aran_Codigo,
				 @aran_Descripcion,
				 @usua_UsuarioCreacion,
				 @aran_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************ARCELES******************--
/*Listar Aranceles Todos*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_Listar]
AS
BEGIN
	SELECT	50 aran_Id,
			aran_Codigo,
			DATALENGTH(aran_Codigo) AS tamaño, 
			CASE 
				WHEN DATALENGTH(aran_Codigo) = 10 THEN 'Categoria'
				WHEN DATALENGTH(aran_Codigo) = 12 THEN 'Subcategoria'
				ELSE 'Arancel' 
			END AS aran_Tipo,
			aran_Descripcion,
		
			ara.usua_UsuarioCreacion,
			usu.usua_Nombre           AS UsuarioCreacion,		
			ara.aran_FechaCreacion, 
		
		
		ara.usua_UsuarioModificacion,
		usu1.usua_Nombre              AS UsuarioModificacion,
		ara.aran_FechaModificacion	
		
 
   FROM	Adua.tbAranceles ara
   INNER JOIN Acce.tbUsuarios usu ON ara.usua_UsuarioCreacion = usu.usua_Id
   LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = ara.usua_UsuarioModificacion 
   WHERE aram_Estado = 1
   ORDER BY DATALENGTH(aran_Codigo) 

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_ListarAranceles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Listar Aranceles Solo Aranceles*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_ListarAranceles]
AS
BEGIN
	SELECT	aran_Id,
			aran_Codigo,
			aran_Descripcion,
			DATALENGTH(aran_Codigo)  AS lenght,
		
			ara.usua_UsuarioCreacion,
			usu.usua_Nombre           AS UsuarioCreacion,		
			ara.aran_FechaCreacion, 
		
		
		ara.usua_UsuarioModificacion,
		usu1.usua_Nombre              AS UsuarioModificacion,
		ara.aran_FechaModificacion	
		
 
   FROM	Adua.tbAranceles ara
   INNER JOIN Acce.tbUsuarios usu ON ara.usua_UsuarioCreacion = usu.usua_Id
   LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = ara.usua_UsuarioModificacion 
   WHERE aram_Estado = 1 AND DATALENGTH(aran_Codigo) > 15

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_ListarByCodigo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbAranceles_ListarByCodigo]
	@aran_Codigo	NVARCHAR(20)
AS
BEGIN
	SELECT	aran_Id,
			aran_Codigo,
			DATALENGTH(aran_Codigo) AS tamaño, 
			CASE 
				WHEN DATALENGTH(aran_Codigo) = 10 THEN 'Categoria'
				WHEN DATALENGTH(aran_Codigo) = 12 THEN 'Subcategoria'
				ELSE 'Arancel' 
			END AS aran_Tipo,
			aran_Descripcion,
		
			ara.usua_UsuarioCreacion,
			usu.usua_Nombre           AS UsuarioCreacion,		
			ara.aran_FechaCreacion, 
		
		
		ara.usua_UsuarioModificacion,
		usu1.usua_Nombre              AS UsuarioModificacion,
		ara.aran_FechaModificacion	
		
 
   FROM	Adua.tbAranceles ara
   INNER JOIN Acce.tbUsuarios usu ON ara.usua_UsuarioCreacion = usu.usua_Id
   LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = ara.usua_UsuarioModificacion 
   WHERE ara.aran_Codigo LIKE '%'+ @aran_Codigo + '%' AND aram_Estado = 1
   ORDER BY DATALENGTH(aran_Codigo) 

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_ListarCategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Listar Aranceles Categoria*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_ListarCategoria]
AS
BEGIN
	SELECT	aran_Id,
			aran_Codigo,
			aran_Descripcion,
		
			ara.usua_UsuarioCreacion,
			usu.usua_Nombre           AS UsuarioCreacion,		
			ara.aran_FechaCreacion, 
		
		
		ara.usua_UsuarioModificacion,
		usu1.usua_Nombre              AS UsuarioModificacion,
		ara.aran_FechaModificacion	
		
 
   FROM	Adua.tbAranceles ara
   INNER JOIN Acce.tbUsuarios usu ON ara.usua_UsuarioCreacion = usu.usua_Id
   LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = ara.usua_UsuarioModificacion 
   WHERE DATALENGTH(aran_Codigo) = 10 AND aram_Estado = 1

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbAranceles_ListarSubcategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Listar Aranceles Subcategoria*/
CREATE   PROCEDURE [Adua].[UDP_tbAranceles_ListarSubcategoria]
AS
BEGIN
	SELECT	aran_Id,
			aran_Codigo,
			aran_Descripcion,
		
			ara.usua_UsuarioCreacion,
			usu.usua_Nombre           AS UsuarioCreacion,		
			ara.aran_FechaCreacion, 
		
		
		ara.usua_UsuarioModificacion,
		usu1.usua_Nombre              AS UsuarioModificacion,
		ara.aran_FechaModificacion	
		
 
   FROM	Adua.tbAranceles ara
   INNER JOIN Acce.tbUsuarios usu ON ara.usua_UsuarioCreacion = usu.usua_Id
   LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = ara.usua_UsuarioModificacion 
   WHERE DATALENGTH(aran_Codigo) = 12  AND aram_Estado = 1

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbArancelesBuscarCategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Buscar la categoria del arancel con un codigo de 4 digitos*/
CREATE   PROCEDURE [Adua].[UDP_tbArancelesBuscarCategoria] 
@aran_Codigo NVARCHAR(4)
AS
BEGIN
SELECT aran_Codigo, [aran_Descripcion] FROM Adua.tbAranceles
WHERE REPLACE(aran_Codigo, '.', '') = @aran_Codigo
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbBaseCalculos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbBaseCalculos_Editar] 
	@base_Id								INT,
	@deva_Id								INT, 
	@base_PrecioFactura						DECIMAL(18,2), 
	@base_PagosIndirectos					DECIMAL(18,2), 
	@base_PrecioReal						DECIMAL(18,2), 
	@base_MontCondicion						DECIMAL(18,2), 
	@base_MontoReversion					DECIMAL(18,2), 
	@base_ComisionCorrelaje					DECIMAL(18,2),
	@base_Gasto_Envase_Embalaje				DECIMAL(18,2), 
	@base_ValoresMateriales_Incorporado		DECIMAL(18,2), 
	@base_Valor_Materiales_Utilizados		DECIMAL(18,2), 
	@base_Valor_Materiales_Consumidos		DECIMAL(18,2), 
	@base_Valor_Ingenieria_Importado		DECIMAL(18,2), 
	@base_Valor_Canones						DECIMAL(18,2), 
	@base_Gasto_TransporteM_Importada		DECIMAL(18,2), 
	@base_Gastos_Carga_Importada			DECIMAL(18,2), 
	@base_Costos_Seguro						DECIMAL(18,2), 
	@base_Total_Ajustes_Precio_Pagado		DECIMAL(18,2), 
	@base_Gastos_Asistencia_Tecnica			DECIMAL(18,2),
	@base_Gastos_Transporte_Posterior		DECIMAL(18,2),
	@base_Derechos_Impuestos				DECIMAL(18,2), 
	@base_Monto_Intereses					DECIMAL(18,2), 
	@base_Deducciones_Legales				DECIMAL(18,2), 
	@base_Total_Deducciones_Precio			DECIMAL(18,2), 
	@base_Valor_Aduana						DECIMAL(18,2), 
	@usua_UsuarioModificacion				INT, 
	@base_FechaModificacion					DATE
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	IF(@base_Id <> 0 )
		BEGIN
			UPDATE Adua.tbBaseCalculos
			SET		deva_Id = @deva_Id, 
					base_PrecioFactura = @base_PrecioFactura, 
					base_PagosIndirectos = @base_PagosIndirectos, 
					base_PrecioReal = @base_PrecioReal, 
					base_MontCondicion = @base_MontCondicion, 
					base_MontoReversion = @base_MontoReversion, 
					base_ComisionCorrelaje = @base_ComisionCorrelaje, 
					base_Gasto_Envase_Embalaje = @base_Gasto_Envase_Embalaje, 
					base_ValoresMateriales_Incorporado = @base_ValoresMateriales_Incorporado, 
					base_Valor_Materiales_Utilizados = @base_Valor_Materiales_Utilizados, 
					base_Valor_Materiales_Consumidos = @base_Valor_Materiales_Consumidos, 
					base_Valor_Ingenieria_Importado = @base_Valor_Ingenieria_Importado, 
					base_Valor_Canones = @base_Valor_Canones, 
					base_Gasto_TransporteM_Importada = @base_Gasto_TransporteM_Importada, 
					base_Gastos_Carga_Importada = @base_Gastos_Carga_Importada, 
					base_Costos_Seguro = @base_Costos_Seguro, 
					base_Total_Ajustes_Precio_Pagado = @base_Total_Ajustes_Precio_Pagado, 
					base_Gastos_Asistencia_Tecnica = @base_Gastos_Asistencia_Tecnica, 
					base_Gastos_Transporte_Posterior = @base_Gastos_Transporte_Posterior, 
					base_Derechos_Impuestos = @base_Derechos_Impuestos, 
					base_Monto_Intereses = @base_Monto_Intereses, 
					base_Deducciones_Legales = @base_Deducciones_Legales, 
					base_Total_Deducciones_Precio = @base_Total_Deducciones_Precio, 
					base_Valor_Aduana = @base_Valor_Aduana, 
					usua_UsuarioModificacion = @usua_UsuarioModificacion, 
					base_FechaModificacion = @base_FechaModificacion
			WHERE base_Id = @base_Id

			INSERT INTO Adua.tbBaseCalculosHistorial(base_Id,
														 deva_Id, 
														 base_PrecioFactura, 
														 base_PagosIndirectos, 
														 base_PrecioReal, 
														 base_MontCondicion, 
														 base_MontoReversion, 
														 base_ComisionCorrelaje, 
														 base_Gasto_Envase_Embalaje, 
														 base_ValoresMateriales_Incorporado, 
														 base_Valor_Materiales_Utilizados, 
														 base_Valor_Materiales_Consumidos, 
														 base_Valor_Ingenieria_Importado, 
														 base_Valor_Canones, 
														 base_Gasto_TransporteM_Importada, 
														 base_Gastos_Carga_Importada, 
														 base_Costos_Seguro, 
														 base_Total_Ajustes_Precio_Pagado, 
														 base_Gastos_Asistencia_Tecnica, 
														 base_Gastos_Transporte_Posterior, 
														 base_Derechos_Impuestos, 
														 base_Monto_Intereses, 
														 base_Deducciones_Legales, 
														 base_Total_Deducciones_Precio, 
														 base_Valor_Aduana, 
														 hbas_UsuarioAccion,
														 hbas_FechaAccion,
														 hbas_Accion)
			VALUES (@base_Id,
					@deva_Id, 
					@base_PrecioFactura, 
					@base_PagosIndirectos, 
					@base_PrecioReal, 
					@base_MontCondicion, 
					@base_MontoReversion, 
					@base_ComisionCorrelaje, 
					@base_Gasto_Envase_Embalaje, 
					@base_ValoresMateriales_Incorporado, 
					@base_Valor_Materiales_Utilizados, 
					@base_Valor_Materiales_Consumidos, 
					@base_Valor_Ingenieria_Importado, 
					@base_Valor_Canones, 
					@base_Gasto_TransporteM_Importada, 
					@base_Gastos_Carga_Importada, 
					@base_Costos_Seguro, 
					@base_Total_Ajustes_Precio_Pagado, 
					@base_Gastos_Asistencia_Tecnica, 
					@base_Gastos_Transporte_Posterior, 
					@base_Derechos_Impuestos, 
					@base_Monto_Intereses, 
					@base_Deducciones_Legales, 
					@base_Total_Deducciones_Precio, 
					@base_Valor_Aduana, 
					@usua_UsuarioModificacion, 
					@base_FechaModificacion,
					'Editar')

			SELECT 1
		END
	ELSE
		BEGIN
			DECLARE @base_IDInsertar INT;

			INSERT INTO Adua.tbBaseCalculos(deva_Id, 
												base_PrecioFactura, 
												base_PagosIndirectos, 
												base_PrecioReal, 
												base_MontCondicion, 
												base_MontoReversion, 
												base_ComisionCorrelaje, 
												base_Gasto_Envase_Embalaje, 
												base_ValoresMateriales_Incorporado, 
												base_Valor_Materiales_Utilizados, 
												base_Valor_Materiales_Consumidos, 
												base_Valor_Ingenieria_Importado, 
												base_Valor_Canones, 
												base_Gasto_TransporteM_Importada, 
												base_Gastos_Carga_Importada, 
												base_Costos_Seguro, 
												base_Total_Ajustes_Precio_Pagado, 
												base_Gastos_Asistencia_Tecnica, 
												base_Gastos_Transporte_Posterior, 
												base_Derechos_Impuestos, 
												base_Monto_Intereses, 
												base_Deducciones_Legales, 
												base_Total_Deducciones_Precio, 
												base_Valor_Aduana, 
												usua_UsuarioCreacion, 
												base_FechaCreacion)
			VALUES (@deva_Id, 
					@base_PrecioFactura, 
					@base_PagosIndirectos, 
					@base_PrecioReal, 
					@base_MontCondicion, 
					@base_MontoReversion, 
					@base_ComisionCorrelaje, 
					@base_Gasto_Envase_Embalaje, 
					@base_ValoresMateriales_Incorporado, 
					@base_Valor_Materiales_Utilizados, 
					@base_Valor_Materiales_Consumidos, 
					@base_Valor_Ingenieria_Importado, 
					@base_Valor_Canones, 
					@base_Gasto_TransporteM_Importada, 
					@base_Gastos_Carga_Importada, 
					@base_Costos_Seguro, 
					@base_Total_Ajustes_Precio_Pagado, 
					@base_Gastos_Asistencia_Tecnica, 
					@base_Gastos_Transporte_Posterior, 
					@base_Derechos_Impuestos, 
					@base_Monto_Intereses, 
					@base_Deducciones_Legales, 
					@base_Total_Deducciones_Precio, 
					@base_Valor_Aduana, 
					@usua_UsuarioModificacion, 
					@base_FechaModificacion)

			SET @base_IDInsertar = SCOPE_IDENTITY();

			INSERT INTO Adua.tbBaseCalculosHistorial(base_Id,
														 deva_Id, 
														 base_PrecioFactura, 
														 base_PagosIndirectos, 
														 base_PrecioReal, 
														 base_MontCondicion, 
														 base_MontoReversion, 
														 base_ComisionCorrelaje, 
														 base_Gasto_Envase_Embalaje, 
														 base_ValoresMateriales_Incorporado, 
														 base_Valor_Materiales_Utilizados, 
														 base_Valor_Materiales_Consumidos, 
														 base_Valor_Ingenieria_Importado, 
														 base_Valor_Canones, 
														 base_Gasto_TransporteM_Importada, 
														 base_Gastos_Carga_Importada, 
														 base_Costos_Seguro, 
														 base_Total_Ajustes_Precio_Pagado, 
														 base_Gastos_Asistencia_Tecnica, 
														 base_Gastos_Transporte_Posterior, 
														 base_Derechos_Impuestos, 
														 base_Monto_Intereses, 
														 base_Deducciones_Legales, 
														 base_Total_Deducciones_Precio, 
														 base_Valor_Aduana, 
														 hbas_UsuarioAccion,
														 hbas_FechaAccion,
														 hbas_Accion)
			VALUES (SCOPE_IDENTITY(),
					@deva_Id, 
					@base_PrecioFactura, 
					@base_PagosIndirectos, 
					@base_PrecioReal, 
					@base_MontCondicion, 
					@base_MontoReversion, 
					@base_ComisionCorrelaje, 
					@base_Gasto_Envase_Embalaje, 
					@base_ValoresMateriales_Incorporado, 
					@base_Valor_Materiales_Utilizados, 
					@base_Valor_Materiales_Consumidos, 
					@base_Valor_Ingenieria_Importado, 
					@base_Valor_Canones, 
					@base_Gasto_TransporteM_Importada, 
					@base_Gastos_Carga_Importada, 
					@base_Costos_Seguro, 
					@base_Total_Ajustes_Precio_Pagado, 
					@base_Gastos_Asistencia_Tecnica, 
					@base_Gastos_Transporte_Posterior, 
					@base_Derechos_Impuestos, 
					@base_Monto_Intereses, 
					@base_Deducciones_Legales, 
					@base_Total_Deducciones_Precio, 
					@base_Valor_Aduana, 
					@usua_UsuarioModificacion, 
					@base_FechaModificacion,
					'Insertar')

			SELECT @base_IDInsertar

		END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbBaseCalculos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbBaseCalculos_Insertar] 
	@deva_Id								INT, 
	@base_PrecioFactura						DECIMAL(18,2), 
	@base_PagosIndirectos					DECIMAL(18,2), 
	@base_PrecioReal						DECIMAL(18,2), 
	@base_MontCondicion						DECIMAL(18,2), 
	@base_MontoReversion					DECIMAL(18,2), 
	@base_ComisionCorrelaje					DECIMAL(18,2),
	@base_Gasto_Envase_Embalaje				DECIMAL(18,2), 
	@base_ValoresMateriales_Incorporado		DECIMAL(18,2), 
	@base_Valor_Materiales_Utilizados		DECIMAL(18,2), 
	@base_Valor_Materiales_Consumidos		DECIMAL(18,2), 
	@base_Valor_Ingenieria_Importado		DECIMAL(18,2), 
	@base_Valor_Canones						DECIMAL(18,2), 
	@base_Gasto_TransporteM_Importada		DECIMAL(18,2), 
	@base_Gastos_Carga_Importada			DECIMAL(18,2), 
	@base_Costos_Seguro						DECIMAL(18,2), 
	@base_Total_Ajustes_Precio_Pagado		DECIMAL(18,2), 
	@base_Gastos_Asistencia_Tecnica			DECIMAL(18,2),
	@base_Gastos_Transporte_Posterior		DECIMAL(18,2),
	@base_Derechos_Impuestos				DECIMAL(18,2), 
	@base_Monto_Intereses					DECIMAL(18,2), 
	@base_Deducciones_Legales				DECIMAL(18,2), 
	@base_Total_Deducciones_Precio			DECIMAL(18,2), 
	@base_Valor_Aduana						DECIMAL(18,2), 
	@usua_UsuarioCreacion					INT, 
	@base_FechaCreacion						DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

	DECLARE @base_ID INT;

		INSERT INTO Adua.tbBaseCalculos(deva_Id, 
											base_PrecioFactura, 
											base_PagosIndirectos, 
											base_PrecioReal, 
											base_MontCondicion, 
											base_MontoReversion, 
											base_ComisionCorrelaje, 
											base_Gasto_Envase_Embalaje, 
											base_ValoresMateriales_Incorporado, 
											base_Valor_Materiales_Utilizados, 
											base_Valor_Materiales_Consumidos, 
											base_Valor_Ingenieria_Importado, 
											base_Valor_Canones, 
											base_Gasto_TransporteM_Importada, 
											base_Gastos_Carga_Importada, 
											base_Costos_Seguro, 
											base_Total_Ajustes_Precio_Pagado, 
											base_Gastos_Asistencia_Tecnica, 
											base_Gastos_Transporte_Posterior, 
											base_Derechos_Impuestos, 
											base_Monto_Intereses, 
											base_Deducciones_Legales, 
											base_Total_Deducciones_Precio, 
											base_Valor_Aduana, 
											usua_UsuarioCreacion, 
											base_FechaCreacion)
		VALUES (@deva_Id, 
				@base_PrecioFactura, 
				@base_PagosIndirectos, 
				@base_PrecioReal, 
				@base_MontCondicion, 
				@base_MontoReversion, 
				@base_ComisionCorrelaje, 
				@base_Gasto_Envase_Embalaje, 
				@base_ValoresMateriales_Incorporado, 
				@base_Valor_Materiales_Utilizados, 
				@base_Valor_Materiales_Consumidos, 
				@base_Valor_Ingenieria_Importado, 
				@base_Valor_Canones, 
				@base_Gasto_TransporteM_Importada, 
				@base_Gastos_Carga_Importada, 
				@base_Costos_Seguro, 
				@base_Total_Ajustes_Precio_Pagado, 
				@base_Gastos_Asistencia_Tecnica, 
				@base_Gastos_Transporte_Posterior, 
				@base_Derechos_Impuestos, 
				@base_Monto_Intereses, 
				@base_Deducciones_Legales, 
				@base_Total_Deducciones_Precio, 
				@base_Valor_Aduana, 
				@usua_UsuarioCreacion, 
				@base_FechaCreacion)

		SET @base_ID = SCOPE_IDENTITY();

		INSERT INTO Adua.tbBaseCalculosHistorial(base_Id,
													 deva_Id, 
													 base_PrecioFactura, 
													 base_PagosIndirectos, 
													 base_PrecioReal, 
													 base_MontCondicion, 
													 base_MontoReversion, 
													 base_ComisionCorrelaje, 
													 base_Gasto_Envase_Embalaje, 
													 base_ValoresMateriales_Incorporado, 
													 base_Valor_Materiales_Utilizados, 
													 base_Valor_Materiales_Consumidos, 
													 base_Valor_Ingenieria_Importado, 
													 base_Valor_Canones, 
													 base_Gasto_TransporteM_Importada, 
													 base_Gastos_Carga_Importada, 
													 base_Costos_Seguro, 
													 base_Total_Ajustes_Precio_Pagado, 
													 base_Gastos_Asistencia_Tecnica, 
													 base_Gastos_Transporte_Posterior, 
													 base_Derechos_Impuestos, 
													 base_Monto_Intereses, 
													 base_Deducciones_Legales, 
													 base_Total_Deducciones_Precio, 
													 base_Valor_Aduana, 
													 hbas_UsuarioAccion,
													 hbas_FechaAccion,
													 hbas_Accion)
		VALUES (SCOPE_IDENTITY(),
				@deva_Id, 
				@base_PrecioFactura, 
				@base_PagosIndirectos, 
				@base_PrecioReal, 
				@base_MontCondicion, 
				@base_MontoReversion, 
				@base_ComisionCorrelaje, 
				@base_Gasto_Envase_Embalaje, 
				@base_ValoresMateriales_Incorporado, 
				@base_Valor_Materiales_Utilizados, 
				@base_Valor_Materiales_Consumidos, 
				@base_Valor_Ingenieria_Importado, 
				@base_Valor_Canones, 
				@base_Gasto_TransporteM_Importada, 
				@base_Gastos_Carga_Importada, 
				@base_Costos_Seguro, 
				@base_Total_Ajustes_Precio_Pagado, 
				@base_Gastos_Asistencia_Tecnica, 
				@base_Gastos_Transporte_Posterior, 
				@base_Derechos_Impuestos, 
				@base_Monto_Intereses, 
				@base_Deducciones_Legales, 
				@base_Total_Deducciones_Precio, 
				@base_Valor_Aduana, 
				@usua_UsuarioCreacion, 
				@base_FechaCreacion,
				'Insertar')

		SELECT @base_ID

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END


GO
/****** Object:  StoredProcedure [Adua].[UDP_tbBaseCalculos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbBaseCalculos_Listar]
	@deva_Id			INT
AS
BEGIN
	SELECT base_Id, 
		   deva_Id, 
		   base_PrecioFactura, 
		   base_PagosIndirectos, 
		   base_PrecioReal, 
		   base_MontCondicion, 
		   base_MontoReversion, 
		   base_ComisionCorrelaje,
		   base_Gasto_Envase_Embalaje, 
		   base_ValoresMateriales_Incorporado, 
		   base_Valor_Materiales_Utilizados, 
		   base_Valor_Materiales_Consumidos, 
		   base_Valor_Ingenieria_Importado, 
		   base_Valor_Canones, 
		   base_Gasto_TransporteM_Importada, 
		   base_Gastos_Carga_Importada, 
		   base_Costos_Seguro, 
		   base_Total_Ajustes_Precio_Pagado, 
		   base_Gastos_Asistencia_Tecnica, 
		   base_Gastos_Transporte_Posterior,
		   base_Derechos_Impuestos, 
		   base_Monto_Intereses, 
		   base_Deducciones_Legales, 
		   base_Total_Deducciones_Precio, 
		   base_Valor_Aduana, 
		   usua_UsuarioCreacion, 
		   base_FechaCreacion, 
		   usua_UsuarioModificacion, 
		   base_FechaModificacion
	FROM Adua.tbBaseCalculos
	WHERE deva_Id = @deva_Id
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCodigoImpuesto_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EDITAR
CREATE   PROCEDURE [Adua].[UDP_tbCodigoImpuesto_Editar] 
	@coim_Id					INT,
	@coim_Descripcion			NVARCHAR(200),
	@usua_UsuarioModificacion	INT,
	@coim_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT coim_Id  FROM Adua.tbCodigoImpuesto WHERE coim_Descripcion = @coim_Descripcion)
			BEGIN
			--BEGIN
			--	DELETE FROM Adua.tbCodigoImpuesto
			--	WHERE coim_Descripcion = @coim_Descripcion
			--END
				UPDATE  Adua.tbCodigoImpuesto
				SET		coim_Descripcion = @coim_Descripcion,
						usua_UsuarioModificacion = @usua_UsuarioModificacion,
						coim_FechaModificacion = @coim_FechaModificacion
				WHERE	coim_Id = @coim_Id

				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCodigoImpuesto_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--ELIMINAR
CREATE   PROCEDURE [Adua].[UDP_tbCodigoImpuesto_Eliminar] 
	@coim_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@coim_FechaEliminacion	DATETIME
AS
BEGIN

	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'coim_Id', @coim_Id, 'Adua.tbCodigoImpuesto', @respuesta OUTPUT

		IF(@respuesta = 1)
			BEGIN
				UPDATE	Adua.tbCodigoImpuesto
				SET		coim_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						coim_FechaEliminacion = @coim_FechaEliminacion
				WHERE	coim_Id = @coim_Id
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()		
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCodigoImpuesto_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--INSERT
CREATE   PROCEDURE [Adua].[UDP_tbCodigoImpuesto_Insertar] 
	@coim_Descripcion		NVARCHAR(200),
	@usua_UsuarioCreacion	INT,
	@coim_FechaCreacion     DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT coim_Id FROM Adua.tbCodigoImpuesto WHERE coim_Descripcion = @coim_Descripcion  AND coim_Estado = 0)
			BEGIN
				UPDATE Adua.tbCodigoImpuesto
				SET	   coim_Estado = 1
				WHERE  coim_Descripcion = @coim_Descripcion 
				SELECT 1
			END
		ELSE
			BEGIN 
				INSERT INTO Adua.tbCodigoImpuesto (coim_Descripcion, 
											   usua_UsuarioCreacion, 
											   coim_FechaCreacion)
			VALUES(@coim_Descripcion,	
				   @usua_UsuarioCreacion,
				   @coim_FechaCreacion)
				SELECT 1
			END
	END TRY
	BEGIN CATCH
				SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCodigoImpuesto_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*********************** UDPS codigo impuesto ***********************

--LISTAR
CREATE   PROCEDURE [Adua].[UDP_tbCodigoImpuesto_Listar]
AS
BEGIN
	SELECT codi.coim_Id,							
		   codi.coim_Descripcion,						
	       codi.usua_UsuarioCreacion,		
	       usuaCrea.usua_Nombre				AS usuarioCreacionNombre,
	       coim_FechaCreacion,				
	       codi.usua_UsuarioModificacion,	
	       usuaModifica.usua_Nombre			AS usuarioModificacionNombre,
	       coim_FechaModificacion,			
	       codi.usua_UsuarioEliminacion	,
	       usuaElimina.usua_Nombre			AS usuarioEliminacionNombre,
	       coim_FechaEliminacion,			
	       coim_Estado				
    FROM  Adua.tbCodigoImpuesto codi 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON codi.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica	ON codi.usua_UsuarioModificacion = usuaModifica.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaElimina	ON codi.usua_UsuarioEliminacion = usuaElimina.usua_Id
	WHERE coim_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--/Editar Comersiante Individual/
CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_Editar]
(
	@coin_Id							INT,
  	@pers_Id                           	INT,
	@pers_RTN							NVARCHAR(40),
	@pers_Nombre						NVARCHAR(150),
  	@ofpr_Id                           	INT,
	@ofic_Id							INT,
	@escv_Id							INT,
	@pers_escvRepresentante				INT,
	@pers_OfprRepresentante				INT,
	@pers_FormaRepresentacion			BIT,
  	@usua_UsuarioModificacion   		INT,
  	@coin_FechaModificacion     		DATETIME 
)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @estadoCivilRep INT;
	DECLARE @oficioRep	INT;

	DECLARE @ciudadRep	INT = NULL;
	DECLARE @coloniaRep	INT = NULL;
	DECLARE @aldeaRep	INT = NULL;
	DECLARE @coin_NumeroLocaDepartRepresentante NVARCHAR(150) = NULL;
	DECLARE @coin_PuntoReferenciaReprentante	NVARCHAR(200) = NULL;


		IF(@pers_escvRepresentante = 0 AND @pers_OfprRepresentante = 0 )
	BEGIN
		SET @estadoCivilRep = NULL;
		SET @oficioRep = NULL
	END
	ELSE
	BEGIN
	SET @estadoCivilRep = @pers_escvRepresentante;
	SET @oficioRep = @pers_OfprRepresentante;
	END

	IF(@pers_FormaRepresentacion = 0)
   BEGIN
		SET @estadoCivilRep = NULL;
		SET @oficioRep = NULL;

		UPDATE Adua.tbComercianteIndividual
		SET [coin_CiudadRepresentante] = @ciudadRep,
			[coin_AldeaRepresentante] = @aldeaRep,
			[coin_coloniaIdRepresentante] = @coloniaRep,
			[coin_NumeroLocaDepartRepresentante] = @coin_NumeroLocaDepartRepresentante,
			[coin_PuntoReferenciaReprentante] = @coin_PuntoReferenciaReprentante
		WHERE [coin_Id] = @coin_Id

   END

		 UPDATE Adua.tbComercianteIndividual 
			SET [pers_FormaRepresentacion] = @pers_FormaRepresentacion,
				[usua_UsuarioModificacion] = @usua_UsuarioModificacion,
				[coin_FechaModificacion] = @coin_FechaModificacion
		  WHERE coin_Id = @coin_Id AND [coin_Estado] = 1

		 UPDATE Adua.tbPersonas
			SET [pers_RTN] = @pers_RTN,
				pers_Nombre = @pers_Nombre,
				[ofic_Id] = @ofic_Id, 
				[escv_Id] = @escv_Id,
				[ofpr_Id] = @ofpr_Id, 
				[pers_escvRepresentante] = @estadoCivilRep,
				[pers_OfprRepresentante] = @oficioRep,
				[usua_UsuarioModificacion] = @usua_UsuarioModificacion,
				[pers_FechaModificacion] = @coin_FechaModificacion
			WHERE [pers_Id] = @pers_Id 

			SELECT 1

	COMMIT TRAN	
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_Eliminar] 
@coin_Id	INT,
@pers_Id    INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM Adua.tbComercianteIndividual WHERE coin_Id = @coin_Id
		DELETE FROM Adua.tbPersonas WHERE pers_Id = @pers_Id
		SELECT 1
	
	COMMIT TRAN	
END TRY
BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_FinalizarContrato]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_FinalizarContrato]
@coin_Id		INT
AS
BEGIN
BEGIN TRY
			UPDATE Adua.tbComercianteIndividual 
			SET coin_Finalizacion = 1
			WHERE coin_Id = @coin_Id
			SELECT 1
END TRY
BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_InsertarTap1]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--/Insertar Comersiante Individual/
CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_InsertarTap1] 
(
	@pers_RTN							NVARCHAR(40),
	@pers_Nombre						NVARCHAR(150),
	@ofic_Id							INT,
	@escv_Id							INT,
	@ofpr_Id							INT,
	@pers_FormaRepresentacion			BIT,
	@pers_escvRepresentante				INT,
	@pers_OfprRepresentante				INT,
  	@usua_UsuarioCreacion       		INT,
	@coin_FechaCreacion         		DATETIME 
)
AS
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		DECLARE @pers_FechaCreacion DATETIME = @coin_FechaCreacion;
		DECLARE @pers_Id INT;
		DECLARE @coin_Id INT;
		DECLARE @estadoCivilRep INT;
		DECLARE @oficioRep	INT;

	IF(@pers_escvRepresentante = 0 AND @pers_OfprRepresentante = 0 )
	BEGIN
		SET @estadoCivilRep = NULL;
		SET @oficioRep = NULL
	END
	ELSE
	BEGIN
	SET @estadoCivilRep = @pers_escvRepresentante;
	SET @oficioRep = @pers_OfprRepresentante;
	END


		INSERT INTO Adua.tbPersonas ([pers_RTN], 
									 pers_Nombre,
									 [ofic_Id],
									 [escv_Id],
									 [ofpr_Id],
									 [pers_escvRepresentante],
									 [pers_OfprRepresentante],
									 [usua_UsuarioCreacion], 
									 [pers_FechaCreacion])
		VALUES(@pers_RTN,
			   @pers_Nombre,
			   @ofic_Id,
			   @escv_Id,
			   @ofpr_Id,
			   @estadoCivilRep,
			   @oficioRep,
			   @usua_UsuarioCreacion,
			   @pers_FechaCreacion )

		SET @pers_Id = SCOPE_IDENTITY() 


		INSERT INTO Adua.tbComercianteIndividual 
					(  pers_Id,                           	
					   pers_FormaRepresentacion,
					   usua_UsuarioCreacion,
					   coin_FechaCreacion)
			 VALUES (@pers_Id,                           	
					 @pers_FormaRepresentacion, 	
					 @usua_UsuarioCreacion,       		
					 @coin_FechaCreacion)

			SET @coin_Id =  SCOPE_IDENTITY()

		SELECT CONCAT(@coin_Id, '.',@pers_Id) AS coin_Id
	COMMIT TRAN
	END TRY
	BEGIN CATCH
	ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_InsertarTap2]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_InsertarTap2]  
	@coin_Id					INT,
	@ciud_Id					INT,
	@alde_Id					INT,
	@colo_Id					INT,
	@coin_NumeroLocalApart		NVARCHAR(150),
	@coin_PuntoReferencia		NVARCHAR(200),
	@usua_UsuarioModificacion	INT,
	@coin_FechaModificacion		DATETIME

AS
BEGIN
	BEGIN TRY
	DECLARE  @aldea INT;
	IF(@alde_Id = 0 )
	BEGIN
		SET @aldea = NULL;
	END
	ELSE
	 BEGIN
	 	SET @aldea = @alde_Id;
	 END
		UPDATE Adua.tbComercianteIndividual
		SET ciud_Id = @ciud_Id, alde_Id = @aldea, coin_PuntoReferencia = @coin_PuntoReferencia,
		    colo_Id = @colo_Id, coin_NumeroLocalApart = @coin_NumeroLocalApart,
			usua_UsuarioModificacion = @usua_UsuarioModificacion,
			coin_FechaModificacion = @coin_FechaModificacion
		WHERE coin_Id = @coin_Id 
		SELECT 1
END TRY
BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_InsertarTap3]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_InsertarTap3] 
	@coin_Id							INT,
	@coin_CiudadRepresentante			INT,
	@coin_AldeaRepresentante			INT,
	@coin_coloniaIdRepresentante		INT,
	@coin_NumeroLocaDepartRepresentante NVARCHAR(150),
	@coin_PuntoReferenciaReprentante	NVARCHAR(200),
	@usua_UsuarioModificacion			INT,
	@coin_FechaModificacion				DATETIME
AS
BEGIN
	BEGIN TRY
	DECLARE  @aldea INT;
	IF(@coin_AldeaRepresentante = 0 )
	BEGIN
		SET @aldea = NULL;
	END
	ELSE
	 BEGIN
	 	SET @aldea = @coin_AldeaRepresentante;
	 END

		UPDATE Adua.tbComercianteIndividual
		SET coin_CiudadRepresentante = @coin_CiudadRepresentante, 
		coin_AldeaRepresentante = @aldea,
		coin_PuntoReferenciaReprentante = @coin_PuntoReferenciaReprentante,
		coin_coloniaIdRepresentante = @coin_coloniaIdRepresentante,
		coin_NumeroLocaDepartRepresentante = @coin_NumeroLocaDepartRepresentante,
		usua_UsuarioModificacion = @usua_UsuarioModificacion,
		coin_FechaModificacion = @coin_FechaModificacion
		WHERE coin_Id = @coin_Id AND [coin_Estado] = 1
		SELECT 1
END TRY
BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_InsertarTap4]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_InsertarTap4]
	@coin_Id							INT,
	@coin_TelefonoCelular				NVARCHAR(20),
	@coin_TelefonoFijo					NVARCHAR(20),
	@coin_CorreoElectronico				NVARCHAR(30),
	@coin_CorreoElectronicoAlternativo  NVARCHAR(30),
	@usua_UsuarioModificacion			INT,
	@coin_FechaModificacion				DATETIME
AS
	BEGIN
	BEGIN TRY
		UPDATE Adua.tbComercianteIndividual
		SET coin_TelefonoCelular = @coin_TelefonoCelular,
			coin_TelefonoFijo = @coin_TelefonoFijo,
			coin_CorreoElectronico = @coin_CorreoElectronico,
			coin_CorreoElectronicoAlternativo = @coin_CorreoElectronicoAlternativo,
			usua_UsuarioModificacion = @usua_UsuarioModificacion,
			coin_FechaModificacion = @coin_FechaModificacion
		WHERE coin_Id = @coin_Id AND [coin_Estado] = 1
		SELECT 1
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbComercianteIndividual_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--***** UDPS Para Tabla Comersiante Individual ****--

CREATE   PROCEDURE [Adua].[UDP_tbComercianteIndividual_Listar]
AS
BEGIN
	SELECT	
			coin.coin_Id, 
			coin.pers_Id,
			pers.pers_RTN,
			pers.pers_Nombre,
			pers.escv_Id,
			civi.escv_Nombre,
			pers.ofic_Id,
			ofic.ofic_Nombre,
			pers.ofpr_Id,
			ofpr.ofpr_Nombre,
			pers.pers_escvRepresentante,
			civiR.escv_Nombre		AS estadoCivilRepresentante, 
			pers.pers_OfprRepresentante, 
			ofprR.ofpr_Nombre		AS oficioProfesRepresentante,  
			coin.pers_FormaRepresentacion, 
			CASE 
			WHEN coin.pers_FormaRepresentacion = 'True' THEN 'Representante Legal'
			ELSE 'Condicion Propia'
			END											AS formaRepresentacionDesc,


			coin.alde_Id, --nuevo
			alde.alde_Nombre, --nuevo
			ciud.ciud_Id,
			ciud.ciud_Nombre,
			ciud.pvin_Id,
			pvin.pvin_Codigo,
			pvin.pvin_Nombre,


			coin.coin_AldeaRepresentante, --nuevo
			aldeR.alde_Nombre	AS aldeaNombreRepresentante,--nuevo
			coin.coin_CiudadRepresentante, --nuevo
			ciudR.ciud_Nombre	AS ciudadNrepresentante, --nuevo
			ciudR.pvin_Id	AS pvin_IdRepresentante,  --nuevo
			pvinR.pvin_Codigo  AS pvin_CodigoRepresentante,--nuevo
			pvinR.pvin_Nombre	AS pvin_NombreRepresentante, --nuevo

			coin.colo_Id, --nuevo
			colo.colo_Nombre, --nuevo
			coin.coin_coloniaIdRepresentante, --nuevo
			colo2.colo_Nombre		AS coloniaNombreRepresentante, --nuevo




			coin.coin_PuntoReferencia,
			coin.coin_TelefonoCelular, 
			coin.coin_TelefonoFijo, 
			coin.coin_CorreoElectronico, 
			coin.coin_CorreoElectronicoAlternativo, 

			coin.coin_NumeroLocalApart, --nuevo
			coin.coin_NumeroLocaDepartRepresentante,  --nuevo
			coin.coin_PuntoReferenciaReprentante, 

			coin.usua_UsuarioCreacion, 
			crea.usua_Nombre				AS usuarioCreacionNombre,
			coin.coin_FechaCreacion, 
			coin.usua_UsuarioModificacion, 
			modi.usua_Nombre				AS usuarioModificacionNombre,
			coin.coin_FechaModificacion, 
			coin.coin_Estado,
			coin.coin_Finalizacion
	FROM Adua.tbComercianteIndividual		AS coin
	LEFT  JOIN Adua.tbPersonas				AS pers		ON coin.pers_Id =	pers.pers_Id

	LEFT  JOIN Gral.tbEstadosCiviles		AS civi		ON pers.escv_Id =	civi.escv_Id

	LEFT  JOIN Gral.tbEstadosCiviles		AS civiR	ON pers.pers_escvRepresentante = civiR.escv_Id

	LEFT  JOIN Gral.tbOficinas				AS ofic		ON pers.ofic_Id =	ofic.ofic_Id

	LEFT  JOIN Gral.tbOficio_Profesiones	AS ofpr		ON pers.ofpr_Id =	ofpr.ofpr_Id

	LEFT  JOIN Gral.tbOficio_Profesiones	AS ofprR	ON pers.pers_OfprRepresentante = ofprR.ofpr_Id 
	 
	LEFT  JOIN Gral.tbAldeas				AS alde		ON coin.alde_Id =	alde.alde_Id 

	LEFT JOIN  Gral.tbCiudades				AS ciud		ON coin.ciud_Id =	ciud.ciud_Id

		 
	LEFT  JOIN Gral.tbAldeas				AS aldeR	ON coin.coin_AldeaRepresentante =	aldeR.alde_Id 

	LEFT  JOIN  Gral.tbCiudades				AS ciudR	ON coin.coin_CiudadRepresentante =	ciudR.ciud_Id

	LEFT JOIN Gral.tbColonias				AS colo		ON coin.colo_Id = colo.colo_Id
	LEFT JOIN Gral.tbColonias				AS colo2	ON coin.coin_coloniaIdRepresentante = colo2.colo_Id

	LEFT JOIN Gral.tbProvincias				AS pvin		ON ciud.pvin_Id =	pvin.pvin_Id
	LEFT JOIN Gral.tbProvincias				AS pvinR	ON ciudR.pvin_Id =	pvinR.pvin_Id

	LEFT JOIN Acce.tbUsuarios				AS crea		ON coin.usua_UsuarioCreacion = crea.usua_Id
	LEFT JOIN Acce.tbUsuarios				AS modi		ON coin.usua_UsuarioModificacion = modi.usua_Id
	--WHERE coin.coin_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConceptoPago_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Editar
CREATE   PROC [Adua].[UDP_tbConceptoPago_Editar]
@copa_Id						INT,
@copa_Descripcion				NVARCHAR(200),
@usua_UsuarioModificacion		INT,
@copa_FechaModificacion			DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE	Adua.tbConceptoPago
					SET		copa_Descripcion			=	@copa_Descripcion,
							usua_UsuarioModificacion	=	@usua_UsuarioModificacion,
							copa_FechaModificacion		=	@copa_FechaModificacion
					WHERE	copa_Id						=	@copa_Id
				
					SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConceptoPago_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Insertar
CREATE   PROC [Adua].[UDP_tbConceptoPago_Insertar] 
@copa_Descripcion			NVARCHAR(200),
@usua_UsuarioCreacion		INT,
@copa_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * FROM Adua.tbConceptoPago
							WHERE copa_Descripcion = @copa_Descripcion
							AND copa_Estado = 0)
			BEGIN
					UPDATE	Adua.tbConceptoPago
					SET		copa_Estado			= 1
					WHERE	copa_Descripcion	= @copa_Descripcion
				
					SELECT 1

			END
		ELSE
			BEGIN

					INSERT INTO Adua.tbConceptoPago
					(copa_Descripcion, 
					 usua_UsuarioCreacion, 
					 copa_FechaCreacion)
					VALUES
					(@copa_Descripcion,
					 @usua_UsuarioCreacion,
					 @copa_FechaCreacion)

					SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConceptoPago_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--******************* UDPS Concepto de Pago ***************************

--Listar
CREATE   PROC [Adua].[UDP_tbConceptoPago_Listar]
AS
BEGIN
		SELECT	tbcp.copa_Id, 
				tbcp.copa_Descripcion, 
				tbcp.usua_UsuarioCreacion, 
				usu.usua_Nombre						AS usuaCreacion,
				tbcp.copa_FechaCreacion, 
				tbcp.usua_UsuarioModificacion, 
				usu2.usua_Nombre					AS usuaModificacion,
				tbcp.copa_FechaModificacion, 
				tbcp.copa_Estado
		FROM	Adua.tbConceptoPago	   tbcp
				INNER JOIN Acce.tbUsuarios usu			ON 	tbcp.usua_UsuarioCreacion		= usu.usua_Id 
				LEFT  JOIN Acce.tbUsuarios usu2			ON	tbcp.usua_UsuarioModificacion	= usu2.usua_Id
		WHERE	tbcp.copa_Estado = 1  
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondiciones_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbCondiciones_Editar] 
	@codi_Id									INT,
	@deva_Id									INT, 
	@codi_Restricciones_Utilizacion				BIT, 
	@codi_Indicar_Restricciones_Utilizacion		NVARCHAR(500), 
	@codi_Depende_Precio_Condicion				BIT, 
	@codi_Indicar_Existe_Condicion				NVARCHAR(500),
	@codi_Condicionada_Revertir					BIT, 
	@codi_Vinculacion_Comprador_Vendedor		BIT, 
	@codi_Tipo_Vinculacion						NVARCHAR(500), 
	@codi_Vinculacion_Influye_Precio			BIT, 
	@codi_Pagos_Descuentos_Indirectos			BIT, 
	@codi_Concepto_Monto_Declarado				NVARCHAR(500), 
	@codi_Existen_Canones						BIT, 
	@codi_Indicar_Canones						NVARCHAR(500), 
	@usua_UsuarioModificacion					INT, 
	@codi_FechaModificacion						DATE
AS
BEGIN
	BEGIN TRY
		IF(@codi_Id <> 0)
			BEGIN
						UPDATE Adua.tbCondiciones
					SET		deva_Id = @deva_Id, 
							codi_Restricciones_Utilizacion = @codi_Restricciones_Utilizacion, 
							codi_Indicar_Restricciones_Utilizacion = @codi_Indicar_Restricciones_Utilizacion, 
							codi_Depende_Precio_Condicion = @codi_Depende_Precio_Condicion, 
							codi_Indicar_Existe_Condicion = @codi_Indicar_Existe_Condicion, 
							codi_Condicionada_Revertir = @codi_Condicionada_Revertir, 
							codi_Vinculacion_Comprador_Vendedor = @codi_Vinculacion_Comprador_Vendedor, 
							codi_Tipo_Vinculacion = @codi_Tipo_Vinculacion, 
							codi_Vinculacion_Influye_Precio = @codi_Vinculacion_Influye_Precio, 
							codi_Pagos_Descuentos_Indirectos = @codi_Pagos_Descuentos_Indirectos, 
							codi_Concepto_Monto_Declarado = @codi_Concepto_Monto_Declarado, 
							codi_Existen_Canones = @codi_Existen_Canones, 
							codi_Indicar_Canones = @codi_Indicar_Canones, 
							usua_UsuarioModificacion = @usua_UsuarioModificacion, 
							codi_FechaModificacion = @codi_FechaModificacion
					WHERE codi_Id = @codi_Id

					INSERT INTO Adua.tbCondicionesHistorial(codi_Id,
																deva_Id, 
																codi_Restricciones_Utilizacion, 
																codi_Indicar_Restricciones_Utilizacion, 
																codi_Depende_Precio_Condicion, 
																codi_Indicar_Existe_Condicion, 
																codi_Condicionada_Revertir, 
																codi_Vinculacion_Comprador_Vendedor, 
																codi_Tipo_Vinculacion, 
																codi_Vinculacion_Influye_Precio, 
																codi_Pagos_Descuentos_Indirectos, 
																codi_Concepto_Monto_Declarado, 
																codi_Existen_Canones, 
																codi_Indicar_Canones, 
																hcod_UsuarioAccion,
																hcod_FechaAccion,
																hcod_Accion)
					VALUES (@codi_Id,
							@deva_Id, 
							@codi_Restricciones_Utilizacion, 
							@codi_Indicar_Restricciones_Utilizacion, 
							@codi_Depende_Precio_Condicion, 
							@codi_Indicar_Existe_Condicion, 
							@codi_Condicionada_Revertir, 
							@codi_Vinculacion_Comprador_Vendedor, 
							@codi_Tipo_Vinculacion, 
							@codi_Vinculacion_Influye_Precio, 
							@codi_Pagos_Descuentos_Indirectos, 
							@codi_Concepto_Monto_Declarado, 
							@codi_Existen_Canones, 
							@codi_Indicar_Canones, 
							@usua_UsuarioModificacion, 
							@codi_FechaModificacion,
							'Editar')							

					SELECT 1
			END
		ELSE
			BEGIN
			DECLARE @codi_IdInsert INT;

					INSERT INTO Adua.tbCondiciones(deva_Id, 
													   codi_Restricciones_Utilizacion, 
													   codi_Indicar_Restricciones_Utilizacion, 
													   codi_Depende_Precio_Condicion, 
													   codi_Indicar_Existe_Condicion, 
													   codi_Condicionada_Revertir, 
													   codi_Vinculacion_Comprador_Vendedor, 
													   codi_Tipo_Vinculacion, 
													   codi_Vinculacion_Influye_Precio, 
													   codi_Pagos_Descuentos_Indirectos, 
													   codi_Concepto_Monto_Declarado, 
													   codi_Existen_Canones, 
													   codi_Indicar_Canones, 
													   usua_UsuarioCreacion, 
													   codi_FechaCreacion)
					VALUES (@deva_Id, 
							@codi_Restricciones_Utilizacion, 
							@codi_Indicar_Restricciones_Utilizacion, 
							@codi_Depende_Precio_Condicion, 
							@codi_Indicar_Existe_Condicion, 
							@codi_Condicionada_Revertir, 
							@codi_Vinculacion_Comprador_Vendedor, 
							@codi_Tipo_Vinculacion, 
							@codi_Vinculacion_Influye_Precio, 
							@codi_Pagos_Descuentos_Indirectos, 
							@codi_Concepto_Monto_Declarado, 
							@codi_Existen_Canones, 
							@codi_Indicar_Canones, 
							@usua_UsuarioModificacion, 
							@codi_FechaModificacion)

					SET @codi_IdInsert = SCOPE_IDENTITY()

					INSERT INTO Adua.tbCondicionesHistorial(codi_Id,
																deva_Id, 
																codi_Restricciones_Utilizacion, 
																codi_Indicar_Restricciones_Utilizacion, 
																codi_Depende_Precio_Condicion, 
																codi_Indicar_Existe_Condicion, 
																codi_Condicionada_Revertir, 
																codi_Vinculacion_Comprador_Vendedor, 
																codi_Tipo_Vinculacion, 
																codi_Vinculacion_Influye_Precio, 
																codi_Pagos_Descuentos_Indirectos, 
																codi_Concepto_Monto_Declarado, 
																codi_Existen_Canones, 
																codi_Indicar_Canones, 
																hcod_UsuarioAccion,
																hcod_FechaAccion,
																hcod_Accion)
					VALUES (SCOPE_IDENTITY(),
							@deva_Id, 
							@codi_Restricciones_Utilizacion, 
							@codi_Indicar_Restricciones_Utilizacion, 
							@codi_Depende_Precio_Condicion, 
							@codi_Indicar_Existe_Condicion, 
							@codi_Condicionada_Revertir, 
							@codi_Vinculacion_Comprador_Vendedor, 
							@codi_Tipo_Vinculacion, 
							@codi_Vinculacion_Influye_Precio, 
							@codi_Pagos_Descuentos_Indirectos, 
							@codi_Concepto_Monto_Declarado, 
							@codi_Existen_Canones, 
							@codi_Indicar_Canones, 
							@usua_UsuarioModificacion, 
							@codi_FechaModificacion,
							'Insertar')

					SELECT @codi_IdInsert
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondiciones_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbCondiciones_Insertar] 
	@deva_Id									INT, 
	@codi_Restricciones_Utilizacion				BIT, 
	@codi_Indicar_Restricciones_Utilizacion		NVARCHAR(500), 
	@codi_Depende_Precio_Condicion				BIT, 
	@codi_Indicar_Existe_Condicion				NVARCHAR(500),
	@codi_Condicionada_Revertir					BIT, 
	@codi_Vinculacion_Comprador_Vendedor		BIT, 
	@codi_Tipo_Vinculacion						NVARCHAR(500), 
	@codi_Vinculacion_Influye_Precio			BIT, 
	@codi_Pagos_Descuentos_Indirectos			BIT, 
	@codi_Concepto_Monto_Declarado				NVARCHAR(500), 
	@codi_Existen_Canones						BIT, 
	@codi_Indicar_Canones						NVARCHAR(500), 
	@usua_UsuarioCreacion						INT, 
	@codi_FechaCreacion							DATE
AS
BEGIN
	BEGIN TRY
		DECLARE @codi_Id INT;

		INSERT INTO Adua.tbCondiciones(deva_Id, 
										   codi_Restricciones_Utilizacion, 
										   codi_Indicar_Restricciones_Utilizacion, 
										   codi_Depende_Precio_Condicion, 
										   codi_Indicar_Existe_Condicion, 
										   codi_Condicionada_Revertir, 
										   codi_Vinculacion_Comprador_Vendedor, 
										   codi_Tipo_Vinculacion, 
										   codi_Vinculacion_Influye_Precio, 
										   codi_Pagos_Descuentos_Indirectos, 
										   codi_Concepto_Monto_Declarado, 
										   codi_Existen_Canones, 
										   codi_Indicar_Canones, 
										   usua_UsuarioCreacion, 
										   codi_FechaCreacion)
		VALUES (@deva_Id, 
				@codi_Restricciones_Utilizacion, 
				@codi_Indicar_Restricciones_Utilizacion, 
				@codi_Depende_Precio_Condicion, 
				@codi_Indicar_Existe_Condicion, 
				@codi_Condicionada_Revertir, 
				@codi_Vinculacion_Comprador_Vendedor, 
				@codi_Tipo_Vinculacion, 
				@codi_Vinculacion_Influye_Precio, 
				@codi_Pagos_Descuentos_Indirectos, 
				@codi_Concepto_Monto_Declarado, 
				@codi_Existen_Canones, 
				@codi_Indicar_Canones, 
				@usua_UsuarioCreacion, 
				@codi_FechaCreacion)

		SET @codi_Id = SCOPE_IDENTITY()

		INSERT INTO Adua.tbCondicionesHistorial(codi_Id,
													deva_Id, 
													codi_Restricciones_Utilizacion, 
													codi_Indicar_Restricciones_Utilizacion, 
													codi_Depende_Precio_Condicion, 
													codi_Indicar_Existe_Condicion, 
													codi_Condicionada_Revertir, 
													codi_Vinculacion_Comprador_Vendedor, 
													codi_Tipo_Vinculacion, 
													codi_Vinculacion_Influye_Precio, 
													codi_Pagos_Descuentos_Indirectos, 
													codi_Concepto_Monto_Declarado, 
													codi_Existen_Canones, 
													codi_Indicar_Canones, 
													hcod_UsuarioAccion,
													hcod_FechaAccion,
													hcod_Accion)
		VALUES (SCOPE_IDENTITY(),
				@deva_Id, 
				@codi_Restricciones_Utilizacion, 
				@codi_Indicar_Restricciones_Utilizacion, 
				@codi_Depende_Precio_Condicion, 
				@codi_Indicar_Existe_Condicion, 
				@codi_Condicionada_Revertir, 
				@codi_Vinculacion_Comprador_Vendedor, 
				@codi_Tipo_Vinculacion, 
				@codi_Vinculacion_Influye_Precio, 
				@codi_Pagos_Descuentos_Indirectos, 
				@codi_Concepto_Monto_Declarado, 
				@codi_Existen_Canones, 
				@codi_Indicar_Canones, 
				@usua_UsuarioCreacion, 
				@codi_FechaCreacion,
				'Insertar')

		SELECT @codi_Id
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


/*Editar condiciones*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondiciones_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************CONDICIONES******************--
/*Listar CONDICIONES*/
CREATE   PROCEDURE [Adua].[UDP_tbCondiciones_Listar]
	@deva_Id			INT
AS
BEGIN
	SELECT codi_Id, 
		   deva_Id, 
		   codi_Restricciones_Utilizacion, 
		   codi_Indicar_Restricciones_Utilizacion, 
		   codi_Depende_Precio_Condicion, 
		   codi_Indicar_Existe_Condicion, 
		   codi_Condicionada_Revertir, 
		   codi_Vinculacion_Comprador_Vendedor, 
		   codi_Tipo_Vinculacion, 
		   codi_Vinculacion_Influye_Precio, 
		   codi_Pagos_Descuentos_Indirectos, 
		   codi_Concepto_Monto_Declarado, 
		   codi_Existen_Canones, 
		   codi_Indicar_Canones, 
		   usua_UsuarioCreacion, 
		   codi_FechaCreacion, 
		   usua_UsuarioModificacion, 
		   codi_FechaModificacion, 
		   codi_Estado
	FROM Adua.tbCondiciones
	WHERE deva_Id = @deva_Id
END

/*Insertar condiciones*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondicionesComerciales_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbCondicionesComerciales_Editar] 
   @coco_Id						INT,
   @coco_Codigo					CHAR(2),
   @coco_Descripcion			NVARCHAR(150),
   @coco_UsuarioModificacion	INT,
   @coco_FechaModi				DATETIME
AS
BEGIN 
      BEGIN TRY
			
		  IF EXISTS (SELECT coco_Id
					 FROM Adua.tbCondicionesComerciales
					 WHERE coco_Descripcion = @coco_Descripcion
					 AND coco_Estado = 0)
			BEGIN
				DELETE FROM Adua.tbCondicionesComerciales
				WHERE coco_Descripcion = @coco_Descripcion
				AND coco_Estado = 0
			END

	      UPDATE Adua.tbCondicionesComerciales
		  SET	coco_Codigo = @coco_Codigo,
				coco_Descripcion = @coco_Descripcion, 
				usua_UsuarioModificacion = @coco_UsuarioModificacion,
				coco_FechaModificacion = @coco_FechaModi
		  WHERE coco_Id = @coco_Id
		  SELECT 1
	   END TRY 
	   BEGIN CATCH 
	       SELECT 'Error Message: ' + ERROR_MESSAGE()
	   END CATCH
END
 
 /*Eliminar Condiciones Comerciales */
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondicionesComerciales_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbCondicionesComerciales_Eliminar]
	@coco_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@coco_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'coco_Id', @coco_Id,'Adua.tbCondicionesComerciales',@respuesta OUTPUT

			IF(@respuesta = 1)
				BEGIN
					 UPDATE Adua.tbCondicionesComerciales
						SET coco_Estado = 0,
						    usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
							coco_FechaEliminacion = @coco_FechaEliminacion
						WHERE coco_Id = @coco_Id
			
		 END

		SELECT @respuesta AS Resultado
	END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondicionesComerciales_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbCondicionesComerciales_Insertar] 
 @coco_Codigo			CHAR(2),
 @coco_Descripcion		NVARCHAR(350), 
 @coco_UsuCreacion		INT, 
 @coco_FechaCreacion    DATETIME
AS    
BEGIN 
    BEGIN TRY 
	  IF EXISTS(SELECT * FROM Adua.tbCondicionesComerciales 
	        WHERE coco_Descripcion = @coco_Descripcion AND coco_Estado=0)
			BEGIN 
			   UPDATE Adua.tbCondicionesComerciales
			   SET coco_Estado = 1
			   WHERE coco_Descripcion =@coco_Descripcion
			   SELECT 1
			END
			ELSE 
			  BEGIN 
			     INSERT INTO Adua.tbCondicionesComerciales
				 ( coco_Codigo,
				   coco_Descripcion, 
				   usua_UsuarioCreacion, 
				   coco_FechaCreacion				     				 
				 )
				 VALUES(
				  @coco_Codigo,
                  @coco_Descripcion,
				  @coco_UsuCreacion,   
				  @coco_FechaCreacion 					 
				 )			  
			  SELECT 1
			 END 
	   END TRY
	BEGIN CATCH
	    SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH  
END 


/*Editar Condiciones comerciales*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbCondicionesComerciales_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbCondicionesComerciales_Listar]
AS
BEGIN
SELECT	condi.coco_Id					,
		condi.coco_Codigo				,
        condi.coco_Descripcion			,
		condi.usua_UsuarioCreacion		,
		usu.usua_Nombre					AS UsuarioNombreCreacion,
		coco_FechaCreacion				,
		condi.usua_UsuarioModificacion	,
		usu1.usua_Nombre				AS UsuarioNombreModificacion,
		coco_FechaModificacion			,
		condi.usua_UsuarioEliminacion	,
		elim.usua_Nombre				AS UsuarioNombreEliminacion,
		condi.coco_FechaEliminacion		,	
		condi.coco_Estado				
FROM	Adua.tbCondicionesComerciales condi 
		INNER JOIN Acce.tbUsuarios usu	ON condi.usua_UsuarioCreacion = usu.usua_Id 
		LEFT JOIN Acce.tbUsuarios usu1	ON usu1.usua_Id = condi.usua_UsuarioModificacion
		LEFT JOIN Acce.tbUsuarios elim ON elim.usua_Id = condi.usua_UsuarioEliminacion
WHERE	coco_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConductor_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar conductor*/
CREATE   PROCEDURE [Adua].[UDP_tbConductor_Editar]  
	@cont_Id                   INT,
	@cont_Nombre               NVARCHAR(200), 
	@cont_Apellido             NVARCHAR(200), 
	@cont_Licencia             NVARCHAR(50), 
	@pais_IdExpedicion         INT, 
	@tran_Id                   INT, 
	@usua_UsuarioModificacion  INT, 
	@cont_FechaModificacion    DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Adua.tbConductor
		SET cont_Licencia             = @cont_Licencia,
			cont_Nombre               = @cont_Nombre, 
			cont_Apellido             = @cont_Apellido, 
			pais_IdExpedicion         = @pais_IdExpedicion, 
			tran_Id                   = @tran_Id, 
			usua_UsuarioModificacion  = @usua_UsuarioModificacion, 
			cont_FechaModificacion    = @cont_FechaModificacion
		WHERE cont_Id                 = @cont_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConductor_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--/*Eliminar  Conductor*/
CREATE   PROCEDURE [Adua].[UDP_tbConductor_Eliminar] 
	@cont_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@cont_FechaEliminacion	    DATETIME
AS
BEGIN
	BEGIN TRY

		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'cont_Id', @cont_Id, 'Adua.tbConductor', @respuesta OUTPUT

		IF(@respuesta) = 1
			BEGIN
					UPDATE Adua.tbConductor
				SET		cont_Estado = 0, 
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						cont_FechaEliminacion   = @cont_FechaEliminacion
				WHERE cont_Id = @cont_Id
				SELECT 1
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConductor_Insert]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Insertar Conductor*/
CREATE   PROCEDURE [Adua].[UDP_tbConductor_Insert] 
	@cont_Nombre           NVARCHAR(200), 
	@cont_Apellido         NVARCHAR(200), 
	@cont_Licencia         NVARCHAR(50), 
	@pais_IdExpedicion     INT, 
	@tran_Id               INT, 
	@usua_UsuarioCreacion  INT, 
	@cont_FechaCreacion    DATETIME	
AS 
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbConductor(cont_Nombre,cont_Apellido, cont_Licencia, 
		  pais_IdExpedicion, tran_Id, usua_UsuarioCreacion, cont_FechaCreacion)
		VALUES(
		  @cont_Nombre, 
		  @cont_Apellido, 
		  @cont_Licencia, 
		  @pais_IdExpedicion, 
		  @tran_Id, 
		  @usua_UsuarioCreacion, 
		  @cont_FechaCreacion
		);
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbConductor_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************CONDUCTOR******************--
/*Listar Conductor*/
CREATE   PROCEDURE [Adua].[UDP_tbConductor_Listar]
AS
BEGIN
	SELECT conduc.cont_Id,
	       conduc.cont_Nombre, 
		   conduc.cont_Apellido, 
		   conduc.cont_Licencia, 
		   conduc.pais_IdExpedicion, 
		   pais.pais_Nombre,
		   conduc.tran_Id, 
		   trans.marca_Id,
		   marc.marc_Descripcion,
		   conduc.usua_UsuarioCreacion, 
		   usuCrea.usua_Nombre               AS usuarioCreacionNombre,
		   cont_FechaCreacion, 
		   conduc.usua_UsuarioModificacion, 
		   usuModi.usua_Nombre               AS usuarioModificacionNombre,
		   cont_FechaModificacion, 
		   conduc.usua_UsuarioEliminacion,
		   usuElim.usua_Nombre				 AS usuarioEliminacionNombre,
		   conduc.cont_FechaEliminacion,
		   cont_Estado
	FROM   Adua.tbConductor conduc 
		   LEFT JOIN acce.tbUsuarios usuCrea ON conduc.usua_UsuarioCreacion = usuCrea.usua_Id
		   LEFT JOIN acce.tbUsuarios usuModi ON conduc.usua_UsuarioModificacion = usuModi.usua_Id
		   LEFT JOIN Acce.tbUsuarios usuElim ON conduc.usua_UsuarioEliminacion = usuElim.usua_Id
		   LEFT JOIN Adua.tbTransporte trans ON conduc.tran_Id = trans.tran_Id
		   LEFT JOIN Adua.tbMarcas		marc ON trans.marca_Id = marc.marc_Id
		   LEFT JOIN Gral.tbPaises		pais ON conduc.pais_IdExpedicion = pais.pais_Id
	WHERE  cont_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbdeclaracion_Valor_Finalizar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbdeclaracion_Valor_Finalizar]
	@deva_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Adua].[tbDeclaraciones_Valor]
		SET [deva_Finalizacion] = 1
		WHERE deva_Id = @deva_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH

END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaraciones_Valor_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbDeclaraciones_Valor_Eliminar]
	@deva_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@deva_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
	BEGIN TRAN 
		INSERT INTO Adua.tbBaseCalculosHistorial(base_Id, 
													 deva_Id, 
													 base_PrecioFactura, 
													 base_PagosIndirectos, 
													 base_PrecioReal, 
													 base_MontCondicion, 
													 base_MontoReversion, 
													 base_ComisionCorrelaje, 
													 base_Gasto_Envase_Embalaje, 
													 base_ValoresMateriales_Incorporado, 
													 base_Valor_Materiales_Utilizados, 
													 base_Valor_Materiales_Consumidos, 
													 base_Valor_Ingenieria_Importado, 
													 base_Valor_Canones, 
													 base_Gasto_TransporteM_Importada, 
													 base_Gastos_Carga_Importada, 
													 base_Costos_Seguro, 
													 base_Total_Ajustes_Precio_Pagado, 
													 base_Gastos_Asistencia_Tecnica, 
													 base_Gastos_Transporte_Posterior, 
													 base_Derechos_Impuestos, 
													 base_Monto_Intereses, 
													 base_Deducciones_Legales, 
													 base_Total_Deducciones_Precio, 
													 base_Valor_Aduana, 
													 hbas_UsuarioAccion, 
													 hbas_FechaAccion, 
													 hbas_Accion)
			SELECT base_Id, 
				   deva_Id, 
				   base_PrecioFactura, 
				   base_PagosIndirectos, 
				   base_PrecioReal, 
				   base_MontCondicion, 
				   base_MontoReversion, 
				   base_ComisionCorrelaje, 
				   base_Gasto_Envase_Embalaje, 
				   base_ValoresMateriales_Incorporado, 
				   base_Valor_Materiales_Utilizados, 
				   base_Valor_Materiales_Consumidos, 
				   base_Valor_Ingenieria_Importado, 
				   base_Valor_Canones, 
				   base_Gasto_TransporteM_Importada, 
				   base_Gastos_Carga_Importada, 
				   base_Costos_Seguro, 
				   base_Total_Ajustes_Precio_Pagado, 
				   base_Gastos_Asistencia_Tecnica, 
				   base_Gastos_Transporte_Posterior, 
				   base_Derechos_Impuestos, 
				   base_Monto_Intereses, 
				   base_Deducciones_Legales, 
				   base_Total_Deducciones_Precio, 
				   base_Valor_Aduana,
				   @usua_UsuarioEliminacion,
				   @deva_FechaEliminacion,
				   'Eliminar'
			FROM Adua.tbBaseCalculos
			WHERE deva_Id = @deva_Id

		DELETE Adua.tbBaseCalculos
		WHERE deva_Id =  @deva_Id
		
-------------------------------------------------------------------------------------	
		INSERT INTO Adua.tbCondicionesHistorial(codi_Id, 
													deva_Id, 
													codi_Restricciones_Utilizacion, 
													codi_Indicar_Restricciones_Utilizacion, 
													codi_Depende_Precio_Condicion, 
													codi_Indicar_Existe_Condicion, 
													codi_Condicionada_Revertir, 
													codi_Vinculacion_Comprador_Vendedor, 
													codi_Tipo_Vinculacion, 
													codi_Vinculacion_Influye_Precio, 
													codi_Pagos_Descuentos_Indirectos, 
													codi_Concepto_Monto_Declarado, 
													codi_Existen_Canones, 
													codi_Indicar_Canones,
													hcod_UsuarioAccion, 
													hcod_FechaAccion, 
													hcod_Accion)
		SELECT codi_Id, 
			   deva_Id, 
			   codi_Restricciones_Utilizacion, 
			   codi_Indicar_Restricciones_Utilizacion, 
			   codi_Depende_Precio_Condicion, 
			   codi_Indicar_Existe_Condicion, 
			   codi_Condicionada_Revertir, 
			   codi_Vinculacion_Comprador_Vendedor, 
			   codi_Tipo_Vinculacion, 
			   codi_Vinculacion_Influye_Precio, 
			   codi_Pagos_Descuentos_Indirectos, 
			   codi_Concepto_Monto_Declarado, 
			   codi_Existen_Canones, 
			   codi_Indicar_Canones, 
			   @usua_UsuarioEliminacion,
			   @deva_FechaEliminacion,
			   'Eliminar'
		FROM Adua.tbCondiciones
		WHERE deva_Id = @deva_Id

		DELETE Adua.tbCondiciones
		WHERE deva_Id = @deva_Id
		
-------------------------------------------------------------------------------------	
		DECLARE @fact_Id INT = (SELECT fact_Id
								FROM Adua.tbFacturas
								WHERE deva_Id = @deva_Id)

		INSERT INTO Adua.tbItemsHistorial(item_Id, 
											  fact_Id, 
											  item_Cantidad, 
											  item_PesoNeto, 
											  item_PesoBruto, 
											  unme_Id, 
											  item_IdentificacionComercialMercancias, 
											  item_CaracteristicasMercancias, 
											  item_Marca, 
											  item_Modelo, 
											  merc_Id, 
											  pais_IdOrigenMercancia, 
											  item_ClasificacionArancelaria, 
											  item_ValorUnitario, 
											  item_GastosDeTransporte, 
											  item_ValorTransaccion, 
											  item_Seguro, 
											  item_OtrosGastos, 
											  item_ValorAduana, 
											  item_CuotaContingente, 
											  item_ReglasAccesorias, 
											  item_CriterioCertificarOrigen, 
											  hduc_UsuarioAccion, 
											  hduc_FechaAccion, 
											  hduc_Accion)
		SELECT item_Id, 
			   fact_Id, 
			   item_Cantidad, 
			   item_PesoNeto, 
			   item_PesoBruto, 
			   unme_Id, 
			   item_IdentificacionComercialMercancias, 
			   item_CaracteristicasMercancias, 
			   item_Marca, 
			   item_Modelo, 
			   merc_Id, 
			   pais_IdOrigenMercancia, 
			   item_ClasificacionArancelaria, 
			   item_ValorUnitario, 
			   item_GastosDeTransporte, 
			   item_ValorTransaccion, 
			   item_Seguro, 
			   item_OtrosGastos, 
			   item_ValorAduana, 
			   item_CuotaContingente, 
			   item_ReglasAccesorias, 
			   item_CriterioCertificarOrigen, 
			   @usua_UsuarioEliminacion,
			   @deva_FechaEliminacion,
			   'Eliminar'
		FROM Adua.tbItems
		WHERE fact_Id = @fact_Id


		DELETE Adua.tbItems
		WHERE fact_Id = @fact_Id

-------------------------------------------------------------------------------------		
		INSERT INTO Adua.tbFacturasHistorial(fact_Id, 
												 deva_Id, 
												 fect_Fecha, 
												 hfact_UsuarioAccion, 
												 hfact_FechaAccion, 
												 hfact_Accion)
		SELECT fact_Id, 
			   deva_Id, 
			   fact_Fecha, 
			   @usua_UsuarioEliminacion,
			   @deva_FechaEliminacion,
			   'Eliminar'
		FROM Adua.tbFacturas
		WHERE deva_Id = @deva_Id

		DELETE Adua.tbFacturas
		WHERE deva_Id = @deva_Id
		
-------------------------------------------------------------------------------------	
		INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
															deva_AduanaIngresoId, 
															deva_AduanaDespachoId, 
															deva_DeclaracionMercancia, 
															deva_FechaAceptacion, 
															impo_Id, 
															pvde_Id, 
															inte_Id, 
															deva_LugarEntrega, 
															inco_Id, 
															deva_NumeroContrato, 
															deva_FechaContrato, 
															foen_Id, 
															deva_FormaEnvioOtra, 
															deva_PagoEfectuado, 
															fopa_Id, 
															deva_FormaPagoOtra, 
															emba_Id, 
															pais_ExportacionId, 
															deva_FechaExportacion, 
															mone_Id, 
															mone_Otra, 
															deva_ConversionDolares, 
															--deva_Condiciones, 
															hdev_UsuarioAccion, 
															hdev_FechaAccion, 
															hdev_Accion)
		SELECT deva_Id, 
			   deva_AduanaIngresoId, 
			   deva_AduanaDespachoId, 
			   deva_DeclaracionMercancia, 
			   deva_FechaAceptacion, 
			   impo_Id, 
			   pvde_Id, 
			   inte_Id, 
			   deva_LugarEntrega, 
			   inco_Id, 
			   deva_NumeroContrato, 
			   deva_FechaContrato, 
			   foen_Id, 
			   deva_FormaEnvioOtra, 
			   deva_PagoEfectuado, 
			   fopa_Id, 
			   deva_FormaPagoOtra, 
			   emba_Id, 
			   pais_ExportacionId, 
			   deva_FechaExportacion, 
			   mone_Id, 
			   mone_Otra, 
			   deva_ConversionDolares, 
			   --deva_Condiciones,
			   @usua_UsuarioEliminacion,
			   @deva_FechaEliminacion,
			   'Eliminar'
		FROM Adua.tbDeclaraciones_Valor
		WHERE deva_Id = @deva_Id

		DELETE Adua.tbDeclaraciones_Valor
		WHERE deva_Id = @deva_Id

		SELECT 1
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaraciones_Valor_Tab1_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclaraciones_Valor_Tab1_Editar] 
	@deva_Id							INT,
	@deva_AduanaIngresoId				INT,
	@deva_AduanaDespachoId				INT,
	@deva_FechaAceptacion				DATETIME,
	@regi_Id							INT,
	@decl_Nombre_Raso					NVARCHAR(250),
	@impo_RTN							NVARCHAR(40),
	@impo_NumRegistro					NVARCHAR(40),
	@decl_Direccion_Exacta				NVARCHAR(250),
	@ciud_Id							INT,
	@decl_Correo_Electronico			NVARCHAR(150),
	@decl_Telefono						NVARCHAR(50),
	@decl_Fax							NVARCHAR(50),
	@nico_Id							INT,
	@impo_NivelComercial_Otro			NVARCHAR(300),
	@usua_UsuarioModificacion			INT,
	@deva_FechaModificacion				DATETIME
AS
BEGIN
	BEGIN TRANSACTION 
	BEGIN TRY
		
		DECLARE @decl_Id INT;
		DECLARE @impo_Id INT

		--SET @decl_Id = (SELECT decl_Id
		--				FROM Adua.tbImportadores
		--				WHERE impo_Id = (SELECT impo_Id 
		--								 FROM Adua.tbDeclaraciones_Valor
		--								 WHERE deva_Id = @deva_Id))

		-- SI NO EXISTE UN REGISTRO CON ESE RTN, SE INSERTA
		IF NOT EXISTS (SELECT decl_NumeroIdentificacion 
					   FROM Adua.tbDeclarantes 
					   WHERE decl_NumeroIdentificacion = @impo_RTN)
			BEGIN
				EXEC adua.UDP_tbDeclarantes_Insertar @decl_Nombre_Raso,
													 @decl_Direccion_Exacta,
													 @ciud_Id,
													 @decl_Correo_Electronico,
													 @decl_Telefono,
													 @decl_Fax,
													 @usua_UsuarioModificacion,
													 @deva_FechaModificacion,
													 @impo_RTN,
													 @decl_Id OUTPUT

			   INSERT INTO Adua.tbImportadores(nico_Id, 
												decl_Id, 
												impo_NivelComercial_Otro, 
												impo_RTN, 
												impo_NumRegistro, 
												usua_UsuarioCreacion, 
												impo_FechaCreacion)
										VALUES(@nico_Id, 
											   @decl_Id,
											   @impo_NivelComercial_Otro,
											   @impo_RTN,
											   @impo_NumRegistro,
											   @usua_UsuarioModificacion,
											   @deva_FechaModificacion)

				SET @impo_Id = SCOPE_IDENTITY()
			END
		ELSE
			BEGIN
				--SACAMOS EL ID DEL DECLARANTE 
				SET @decl_Id = (SELECT decl_Id 
								FROM Adua.tbDeclarantes
								WHERE decl_NumeroIdentificacion = @impo_RTN)

				--VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
				IF  EXISTS 	(SELECT decl_Id 
							FROM tbDeclarantes
							WHERE	(decl_Nombre_Raso = @decl_Nombre_Raso
							AND		decl_Direccion_Exacta = @decl_Direccion_Exacta
							AND		ciud_Id = @ciud_Id
							AND		decl_Correo_Electronico = @decl_Correo_Electronico
							AND		decl_Telefono = @decl_Telefono
							AND		ISNULL(decl_Fax, '') = ISNULL(@decl_Fax, '')
							AND		decl_NumeroIdentificacion = @impo_RTN))
					BEGIN
						SET @impo_Id = (SELECT impo_Id 
										FROM Adua.tbImportadores
										WHERE decl_Id = @decl_Id)
					END
				ELSE --SI NO SON IGUALES, SE EDITA LA NUEVA INFORMACIÓN
					BEGIN
						UPDATE Adua.tbDeclarantes
						SET decl_Nombre_Raso			= @decl_Nombre_Raso, 
							decl_Direccion_Exacta		= @decl_Direccion_Exacta, 
							ciud_Id						= @ciud_Id, 
							decl_Correo_Electronico		= @decl_Correo_Electronico, 
							decl_Telefono				= @decl_Telefono, 
							decl_Fax					= @decl_Fax, 
							usua_UsuarioModificacion	= @usua_UsuarioModificacion, 
							decl_FechaModificacion		= @deva_FechaModificacion
						WHERE decl_Id = @decl_Id

						SET @impo_Id = (SELECT impo_Id 
										FROM Adua.tbImportadores
										WHERE decl_Id = 17)
					END

					--REVISAMOS SI EL DECLARANTE YA ESTÁ PRESENTE EN LA TABLA DE IMPORTADORES
					IF (@impo_Id > 0)
						BEGIN
							--Revisamos si hubo cambios en la tabla de importadores
							IF EXISTS(SELECT nico_Id,
											 impo_NivelComercial_Otro,
											 impo_RTN,
											 impo_NumRegistro
									  FROM Adua.tbImportadores
									  WHERE impo_Id = @impo_Id
									  EXCEPT 
									  SELECT @nico_Id					AS nico_Id,
											 @impo_NivelComercial_Otro	AS impo_NivelComercial_Otro,
											 @impo_RTN				    AS impo_RTN,
											 @impo_NumRegistro			AS impo_NumRegistro)
							BEGIN
								UPDATE Adua.tbImportadores
								SET    nico_Id = @nico_Id,
									   impo_NivelComercial_Otro = @impo_NivelComercial_Otro,
									   impo_RTN = @impo_RTN,
									   impo_NumRegistro = @impo_NumRegistro,
									   usua_UsuarioModificacion = @usua_UsuarioModificacion,
									   impo_FechaModificacion = @deva_FechaModificacion
								WHERE  impo_Id = @impo_Id
							END
							
						END
					ELSE
						BEGIN
							INSERT INTO Adua.tbImportadores(nico_Id, 
												decl_Id, 
												impo_NivelComercial_Otro, 
												impo_RTN, 
												impo_NumRegistro, 
												usua_UsuarioCreacion, 
												impo_FechaCreacion)
										VALUES(@nico_Id, 
											   @decl_Id,
											   @impo_NivelComercial_Otro,
											   @impo_RTN,
											   @impo_NumRegistro,
											   @usua_UsuarioModificacion,
											   @deva_FechaModificacion)

							SET @impo_Id = SCOPE_IDENTITY()
						END
			END

		UPDATE Adua.tbDeclaraciones_Valor
		SET deva_AduanaIngresoId = @deva_AduanaIngresoId, 
			deva_AduanaDespachoId = @deva_AduanaDespachoId, 
			deva_FechaAceptacion = @deva_FechaAceptacion,
			regi_Id = @regi_Id,
			impo_Id = @impo_Id,
			usua_UsuarioModificacion = @usua_UsuarioModificacion,
			deva_FechaModificacion = @deva_FechaModificacion
		WHERE deva_Id = @deva_Id


		INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
															deva_AduanaIngresoId, 
															deva_AduanaDespachoId, 
															deva_DeclaracionMercancia, 
															deva_FechaAceptacion, 
															impo_Id, 
															pvde_Id, 
															inte_Id, 
															deva_LugarEntrega, 
															inco_Id, 
															deva_NumeroContrato, 
															deva_FechaContrato, 
															foen_Id, 
															deva_FormaEnvioOtra, 
															deva_PagoEfectuado, 
															fopa_Id, 
															deva_FormaPagoOtra, 
															emba_Id, 
															pais_ExportacionId, 
															deva_FechaExportacion, 
															mone_Id, 
															mone_Otra, 
															deva_ConversionDolares, 
															----deva_Condiciones,
															hdev_UsuarioAccion, 
															hdev_FechaAccion, 
															hdev_Accion)
		SELECT deva_Id, 
			   deva_AduanaIngresoId, 
			   deva_AduanaDespachoId, 
			   deva_DeclaracionMercancia, 
			   deva_FechaAceptacion, 
			   impo_Id, 
			   pvde_Id, 
			   inte_Id, 
			   deva_LugarEntrega, 
			   inco_Id, 
			   deva_NumeroContrato, 
			   deva_FechaContrato, 
			   foen_Id, 
			   deva_FormaEnvioOtra, 
			   deva_PagoEfectuado, 
			   fopa_Id, 
			   deva_FormaPagoOtra, 
			   emba_Id, 
			   pais_ExportacionId, 
			   deva_FechaExportacion, 
			   mone_Id, 
			   mone_Otra, 
			   deva_ConversionDolares, 
			   --deva_Condiciones,
			   @usua_UsuarioModificacion,
			   @deva_FechaModificacion,
			   'Editar tab1'
		FROM Adua.tbDeclaraciones_Valor
		WHERE deva_Id = @deva_Id

		SELECT 1

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaraciones_Valor_Tab1_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* Eliminar Declarantes*/
--CREATE OR ALTER PROCEDURE Adua.UDP_tbDeclarantes_Eliminar 
--	@decl_Id					INT,
--	@usua_UsuarioEliminacion	INT,
--	@decl_FechaEliminacion		DATETIME
--AS
--BEGIN
--	SET @decl_FechaEliminacion = GETDATE()
--	BEGIN TRY
--		DECLARE @respuesta INT
--		EXEC dbo.UDP_ValidarReferencias 'decl_Id', @decl_Id, 'Adua.tbDeclarantes', @respuesta OUTPUT

--		SELECT @respuesta AS Resultado
--		IF(@respuesta = 1)
--		BEGIN
--			UPDATE	Adua.tbDeclarantes
--			SET		decl_Estado = 0,
--					usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
--					decl_FechaEliminacion = @decl_FechaEliminacion
--			WHERE decl_Id = @decl_Id
--		END
--	END TRY
--	BEGIN CATCH
--		SELECT 0
--	END CATCH
--END
--GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclaraciones_Valor_Tab1_Insertar] 
	@deva_AduanaIngresoId				INT,
	@deva_AduanaDespachoId				INT,
	@deva_DeclaracionMercancia			NVARCHAR(500),
	@deva_FechaAceptacion				DATETIME,
	@regi_Id							INT,
	@decl_Nombre_Raso					NVARCHAR(250),
	@impo_RTN							NVARCHAR(40),
	@impo_NumRegistro					NVARCHAR(40),
	@decl_Direccion_Exacta				NVARCHAR(250),
	@ciud_Id							INT,
	@decl_Correo_Electronico			NVARCHAR(150),
	@decl_Telefono						NVARCHAR(50),
	@decl_Fax							NVARCHAR(50),
	@nico_Id							INT,
	@impo_NivelComercial_Otro			NVARCHAR(300),
	@usua_UsuarioCreacion				INT,
	@deva_FechaCreacion					DATETIME
AS
BEGIN
	BEGIN TRANSACTION 
	BEGIN TRY
		
		DECLARE @decl_Id INT;
		DECLARE @impo_Id INT;

		-- SI NO EXISTE UN REGISTRO CON ESE RTN SE INSERTA
		IF NOT EXISTS (SELECT decl_NumeroIdentificacion FROM Adua.tbDeclarantes WHERE decl_NumeroIdentificacion = @impo_RTN)
		BEGIN
			EXEC adua.UDP_tbDeclarantes_Insertar @decl_Nombre_Raso,
											     @decl_Direccion_Exacta,
											     @ciud_Id,
											     @decl_Correo_Electronico,
											     @decl_Telefono,
											     @decl_Fax,
											     @usua_UsuarioCreacion,
											     @deva_FechaCreacion,
											     @impo_RTN,
											     @decl_Id OUTPUT
			

			INSERT INTO Adua.tbImportadores(nico_Id, 
												decl_Id, 
												impo_NivelComercial_Otro, 
												impo_RTN, 
												impo_NumRegistro, 
												usua_UsuarioCreacion, 
												impo_FechaCreacion)
										VALUES(@nico_Id, 
											   @decl_Id,
											   @impo_NivelComercial_Otro,
											   @impo_RTN,
											   @impo_NumRegistro,
											   @usua_UsuarioCreacion,
											   @deva_FechaCreacion)

			SET @impo_Id = SCOPE_IDENTITY()
		END
		ELSE
			BEGIN
				--SACAMOS EL ID DEL DECLARANTE 
				SET @decl_Id = (SELECT decl_Id 
								FROM Adua.tbDeclarantes
								WHERE decl_NumeroIdentificacion = @impo_RTN)


				--VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
				IF  EXISTS 	(SELECT decl_Id 
							FROM tbDeclarantes
							WHERE	(decl_Nombre_Raso = @decl_Nombre_Raso
							AND		decl_Direccion_Exacta = @decl_Direccion_Exacta
							AND		ciud_Id = @ciud_Id
							AND		decl_Correo_Electronico = @decl_Correo_Electronico
							AND		decl_Telefono = @decl_Telefono
							AND		ISNULL(decl_Fax, '') = ISNULL(@decl_Fax, '')
							AND		decl_NumeroIdentificacion = @impo_RTN))

					BEGIN --SI SON IGUALES NO PASA NADA SOLO GUARDAMOS EL ID
						PRINT 'Sí son iguales'

						SET @impo_Id = (SELECT impo_Id 
										FROM Adua.tbImportadores
										WHERE decl_Id = @decl_Id)
					END 
				ELSE --SO NO SON IGUALES SE EDITA LA NUEVA INFORMACION
					BEGIN
						
						UPDATE Adua.tbDeclarantes
						SET decl_Nombre_Raso			= @decl_Nombre_Raso, 
							decl_Direccion_Exacta		= @decl_Direccion_Exacta, 
							ciud_Id						= @ciud_Id, 
							decl_Correo_Electronico		= @decl_Correo_Electronico, 
							decl_Telefono				= @decl_Telefono, 
							decl_Fax					= @decl_Fax, 
							usua_UsuarioModificacion	= @usua_UsuarioCreacion, 
							decl_FechaModificacion		= @deva_FechaCreacion
						WHERE decl_Id = @decl_Id
							
						

						SET @impo_Id = (SELECT impo_Id 
										FROM Adua.tbImportadores
										WHERE decl_Id = @decl_Id)
					END

				--REVISAMOS SI EL DECLARANTE YA ESTÁ PRESENTE EN LA TABLA DE IMPORTADORES
					IF (@impo_Id > 0)
						BEGIN
							--Revisamos si hubo cambios en la tabla de importadores
							IF EXISTS(SELECT nico_Id,
											 impo_NivelComercial_Otro,
											 impo_RTN,
											 impo_NumRegistro
									  FROM Adua.tbImportadores
									  WHERE impo_Id = @impo_Id
									  EXCEPT 
									  SELECT @nico_Id					AS nico_Id,
											 @impo_NivelComercial_Otro	AS impo_NivelComercial_Otro,
											 @impo_RTN				    AS impo_RTN,
											 @impo_NumRegistro			AS impo_NumRegistro)
							BEGIN
								UPDATE Adua.tbImportadores
								SET    nico_Id = @nico_Id,
									   impo_NivelComercial_Otro = @impo_NivelComercial_Otro,
									   impo_RTN = @impo_RTN,
									   impo_NumRegistro = @impo_NumRegistro,
									   usua_UsuarioModificacion = @usua_UsuarioCreacion,
									   impo_FechaModificacion = @deva_FechaCreacion
								WHERE  impo_Id = @impo_Id
							END
						END
					ELSE
						BEGIN
							INSERT INTO Adua.tbImportadores(nico_Id, 
												decl_Id, 
												impo_NivelComercial_Otro, 
												impo_RTN, 
												impo_NumRegistro, 
												usua_UsuarioCreacion, 
												impo_FechaCreacion)
										VALUES(@nico_Id, 
											   @decl_Id,
											   @impo_NivelComercial_Otro,
											   @impo_RTN,
											   @impo_NumRegistro,
											   @usua_UsuarioCreacion,
											   @deva_FechaCreacion)

							SET @impo_Id = SCOPE_IDENTITY()
						END
			END	

		
	
		INSERT INTO Adua.tbDeclaraciones_Valor(deva_AduanaIngresoId, 
											   deva_AduanaDespachoId, 
											   deva_DeclaracionMercancia,
											   deva_FechaAceptacion, 
											   regi_Id,
											   impo_Id, 
											   usua_UsuarioCreacion, 
											   deva_FechaCreacion)
										VALUES(@deva_AduanaIngresoId,
												@deva_AduanaDespachoId,
												@deva_DeclaracionMercancia,
												@deva_FechaAceptacion,
												@regi_Id,
												@impo_Id,
												@usua_UsuarioCreacion,
												@deva_FechaCreacion)


		DECLARE @deva_Id INT = SCOPE_IDENTITY()

		INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
															deva_AduanaIngresoId, 
															deva_AduanaDespachoId,  
															deva_FechaAceptacion,
															deva_DeclaracionMercancia,
															impo_Id,
															hdev_UsuarioAccion, 
															hdev_FechaAccion, 
															hdev_Accion)
													VALUES (@deva_Id,
															@deva_AduanaIngresoId,
															@deva_AduanaDespachoId,
															@deva_FechaAceptacion,
															@deva_DeclaracionMercancia,
															@impo_Id,
															@usua_UsuarioCreacion,
															@deva_FechaCreacion,
															'Insertar tab1')

		SELECT @deva_Id

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaraciones_Valor_Tab2_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclaraciones_Valor_Tab2_Insertar]
	@deva_Id						INT,
	@prov_decl_Nombre_Raso			NVARCHAR(250),
	@prov_decl_Direccion_Exacta		NVARCHAR(250),
	@prov_ciud_Id					INT,
	@prov_decl_Correo_Electronico	NVARCHAR(150),
	@prov_decl_Telefono				NVARCHAR(50),
	@prov_decl_Fax					NVARCHAR(50),
	@prov_RTN						NVARCHAR(50),
	@coco_Id						INT,
	@pvde_Condicion_Otra			NVARCHAR(30),
	@inte_decl_Nombre_Raso			NVARCHAR(250),
	@inte_decl_Direccion_Exacta		NVARCHAR(250),
	@inte_ciud_Id					INT,
	@inte_decl_Correo_Electronico	NVARCHAR(150),
	@inte_decl_Telefono				NVARCHAR(50),
	@inte_decl_Fax					NVARCHAR(50),
	@inte_RTN						NVARCHAR(50),
	@tite_Id						INT,
	@inte_Tipo_Otro					NVARCHAR(30),
	@usua_UsuarioCreacion			INT,
	@usua_UsuarioModificacion		INT,
	@deva_FechaCreacion				DATETIME
AS
BEGIN
	BEGIN TRANSACTION 
	BEGIN TRY

		/*IMPORTANTE: Ya que el insertar y editar de tab2 eran exactamente lo mismo, se usará el insertar para ambas funciones*/

		DECLARE @prov_decl_Id INT;
		DECLARE @inte_decl_Id INT;
		DECLARE @inte_Id INT;
		DECLARE @prov_Id INT;
		DECLARE @accion NVARCHAR(15) = 'Insertar tab2';

		--Si se envía usuario modificación es porque se edita (la variable @usua_UsuarioCreacion toma el valor simple y sencillamente porque me dio pereza cambiarla XD)
		IF @usua_UsuarioModificacion IS NOT NULL
			BEGIN
				SET @usua_UsuarioCreacion = @usua_UsuarioModificacion
				SET @accion = 'Editar tab2'
			END
		
		/*Declarantes de proveedores*/
		-- SI NO EXISTE UN REGISTRO CON ESE RTN SE INSERTA

			IF NOT EXISTS ( SELECT decl_Id FROM Adua.tbDeclarantes WHERE decl_NumeroIdentificacion = @prov_RTN)
				BEGIN
					EXEC adua.UDP_tbDeclarantes_Insertar @prov_decl_Nombre_Raso,
													   @prov_decl_Direccion_Exacta,
													   @prov_ciud_Id,
													   @prov_decl_Correo_Electronico,
													   @prov_decl_Telefono,
													   @prov_decl_Fax,
													   @usua_UsuarioCreacion,
													   @deva_FechaCreacion,
													   @prov_RTN,
													   @prov_decl_Id OUTPUT

					INSERT INTO Adua.tbProveedoresDeclaracion(	 coco_Id, 
																  pvde_Condicion_Otra, 
																  decl_Id, 
																  usua_UsuarioCreacion, 
																  pvde_FechaCreacion)
															VALUES(@coco_Id, 
																   @pvde_Condicion_Otra,
																   @prov_decl_Id,
																   @usua_UsuarioCreacion,
																   @deva_FechaCreacion)

					SET @prov_Id = SCOPE_IDENTITY()
				END
			ELSE
				BEGIN
				    --SACAMOS EL ID DEL DECLARANTE 
					SET @prov_decl_Id = (SELECT decl_Id 
										FROM Adua.tbDeclarantes
										WHERE decl_NumeroIdentificacion = @prov_RTN)

					--VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
					IF  EXISTS 	(SELECT decl_Id 
							FROM tbDeclarantes
							WHERE	(decl_Nombre_Raso = @prov_decl_Nombre_Raso
							AND		decl_Direccion_Exacta = @prov_decl_Direccion_Exacta
							AND		ciud_Id = @prov_ciud_Id
							AND		decl_Correo_Electronico = @prov_decl_Correo_Electronico
							AND		decl_Telefono = @prov_decl_Telefono
							AND		ISNULL(decl_Fax, '') = ISNULL(@prov_decl_Fax, '')
							AND		decl_NumeroIdentificacion = @prov_RTN))

						BEGIN
							SET @prov_Id = (SELECT pvde_Id
											FROM Adua.tbProveedoresDeclaracion
											WHERE decl_Id = @prov_decl_Id)
						END
					ELSE --SI NO SON IGUALES SE EDITA LA NUEVA INFORMACION
						BEGIN
							UPDATE Adua.tbDeclarantes
							SET decl_Nombre_Raso			= @prov_decl_Nombre_Raso, 
								decl_Direccion_Exacta		= @prov_decl_Direccion_Exacta, 
								ciud_Id						= @prov_ciud_Id, 
								decl_Correo_Electronico		= @prov_decl_Correo_Electronico, 
								decl_Telefono				= @prov_decl_Telefono, 
								decl_Fax					= @prov_decl_Fax, 
								usua_UsuarioModificacion	= @usua_UsuarioCreacion, 
								decl_FechaModificacion		= @deva_FechaCreacion
							WHERE decl_Id = @prov_decl_Id

							SET @prov_Id = (SELECT pvde_Id
											FROM Adua.tbProveedoresDeclaracion
											WHERE decl_Id = @prov_decl_Id)
						END

					--REVISAMOS SI EL DECLARANTE YA ESTÁ PRESENTE EN LA TABLA DE PROVEEDORES
					IF(@prov_Id > 0)
						BEGIN
							--REVISAMOS SI HUBO CAMBIOS EN LA TABLA DE PROVEEDORES
							IF EXISTS(SELECT coco_Id, 
												pvde_Condicion_Otra
										FROM Adua.tbProveedoresDeclaracion
										WHERE pvde_Id = @prov_Id
										EXCEPT
										SELECT @coco_Id				AS coco_Id, 
												@pvde_Condicion_Otra	AS pvde_Condicion_Otra)
								BEGIN
									UPDATE Adua.tbProveedoresDeclaracion
									SET	   coco_Id = @coco_Id,
											pvde_Condicion_Otra = @pvde_Condicion_Otra,
											usua_UsuarioModificacion = @usua_UsuarioCreacion,
											pvde_FechaModificacion = @deva_FechaCreacion
									WHERE pvde_Id = @prov_Id
								END
							
						END
					ELSE --INSERTAMOS EL PROVEEDOR
						BEGIN
							INSERT INTO Adua.tbProveedoresDeclaracion(	 coco_Id, 
																  pvde_Condicion_Otra, 
																  decl_Id, 
																  usua_UsuarioCreacion, 
																  pvde_FechaCreacion)
															VALUES(@coco_Id, 
																   @pvde_Condicion_Otra,
																   @prov_decl_Id,
																   @usua_UsuarioCreacion,
																   @deva_FechaCreacion)

							SET @prov_Id = SCOPE_IDENTITY()
						END
				END

		/*Declarantes de intermediarios*/
		IF(@inte_decl_Nombre_Raso IS NOT NULL)
			BEGIN

				-- SI NO EXISTE UN REGISTRO CON ESE RTN SE INSERTA
				IF NOT EXISTS (SELECT decl_Id FROM Adua.tbDeclarantes WHERE decl_NumeroIdentificacion = @inte_RTN)
					BEGIN
						EXEC adua.UDP_tbDeclarantes_Insertar @inte_decl_Nombre_Raso,
																@inte_decl_Direccion_Exacta,
																@inte_ciud_Id,
																@inte_decl_Correo_Electronico,
																@inte_decl_Telefono,
																@inte_decl_Fax,
																@usua_UsuarioCreacion,
																@deva_FechaCreacion,
																@inte_RTN,
																@inte_decl_Id OUTPUT


							INSERT INTO Adua.tbIntermediarios(		tite_Id, 
																	inte_Tipo_Otro,
																	decl_Id, 
																	usua_UsuarioCreacion, 
																	inte_FechaCreacion)
															VALUES (@tite_Id, 
																	@inte_Tipo_Otro, 
																	@inte_decl_Id,
																	@usua_UsuarioCreacion,
																	@deva_FechaCreacion)

							SET @inte_Id = SCOPE_IDENTITY()
					END
				ELSE
					BEGIN
						--SACAMOS EL ID DEL DECLARANTE
						SET @inte_decl_Id = (SELECT decl_Id 
										FROM Adua.tbDeclarantes
										WHERE decl_NumeroIdentificacion = @inte_RTN)

						--VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
						IF  EXISTS 	(SELECT decl_Id 
									 FROM tbDeclarantes
									 WHERE	(decl_Nombre_Raso = @inte_decl_Nombre_Raso
									 AND	 decl_Direccion_Exacta = @inte_decl_Direccion_Exacta
									 AND	 ciud_Id = @inte_ciud_Id
									 AND	 decl_Correo_Electronico = @inte_decl_Correo_Electronico
									 AND	 decl_Telefono = @inte_decl_Telefono
									 AND	 ISNULL(decl_Fax, '') = ISNULL(@inte_decl_Fax, '')
									 AND	 decl_NumeroIdentificacion = @inte_RTN))

							BEGIN --SI SON IGUALES NO PASA NADA SOLO GUARDAMOS EL ID
								SET @inte_Id = (SELECT inte_Id 
												FROM Adua.tbIntermediarios
												WHERE decl_Id = @inte_decl_Id)
							END
						ELSE --SI NO SON IGUALES SE EDITA LA NUEVA INFORMACION
							BEGIN
								UPDATE Adua.tbDeclarantes
								SET decl_Nombre_Raso			= @inte_decl_Nombre_Raso, 
									decl_Direccion_Exacta		= @inte_decl_Direccion_Exacta, 
									ciud_Id						= @inte_ciud_Id, 
									decl_Correo_Electronico		= @inte_decl_Correo_Electronico, 
									decl_Telefono				= @inte_decl_Telefono, 
									decl_Fax					= @inte_decl_Fax, 
									usua_UsuarioModificacion	= @usua_UsuarioCreacion, 
									decl_FechaModificacion		= @deva_FechaCreacion
								WHERE decl_Id = @inte_decl_Id

								SET @inte_Id = (SELECT inte_Id 
												FROM Adua.tbIntermediarios
												WHERE decl_Id = @inte_decl_Id)
							END
							
						
						--REVISAMOS SI EL DECLARANTE YA ESTÁ PRESENTE EN LA TABLA DE INTERMEDIARIOS
						IF	(@inte_Id > 0)
							BEGIN
								--REVISAMOS SI HUBO CAMBIOS EN LA TABLA DE INTERMEDIARIOS
								IF EXISTS (SELECT tite_Id, 
												  inte_Tipo_Otro
										   FROM Adua.tbIntermediarios
										   WHERE inte_Id = @inte_Id
										   EXCEPT 
										   SELECT @tite_Id			AS tite_Id, 
												  @inte_Tipo_Otro	AS inte_Tipo_Otro)
									BEGIN
										UPDATE Adua.tbIntermediarios
										SET	   tite_Id = @tite_Id, 
											   inte_Tipo_Otro = @inte_Tipo_Otro,
											   usua_UsuarioModificacion = @usua_UsuarioCreacion,
											   inte_FechaModificacion = @deva_FechaCreacion
										WHERE inte_Id = @inte_Id
									END

							END
						ELSE
							BEGIN
								INSERT INTO Adua.tbIntermediarios(		tite_Id, 
																	inte_Tipo_Otro,
																	decl_Id, 
																	usua_UsuarioCreacion, 
																	inte_FechaCreacion)
															VALUES (@tite_Id, 
																	@inte_Tipo_Otro, 
																	@inte_decl_Id,
																	@usua_UsuarioCreacion,
																	@deva_FechaCreacion)

								SET @inte_Id = SCOPE_IDENTITY()
							END
					END
			 END

		UPDATE Adua.tbDeclaraciones_Valor
		SET inte_Id = @inte_Id,
			pvde_Id = @prov_Id,
			usua_UsuarioModificacion = @usua_UsuarioCreacion,
			deva_FechaModificacion = @deva_FechaCreacion
		WHERE deva_Id = @deva_Id

		INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
															deva_AduanaIngresoId, 
															deva_AduanaDespachoId, 
															deva_DeclaracionMercancia, 
															deva_FechaAceptacion, 
															impo_Id, 
															pvde_Id, 
															inte_Id, 
															hdev_UsuarioAccion, 
															hdev_FechaAccion, 
															hdev_Accion)
		SELECT deva_Id,
			   deva_AduanaIngresoId,
			   deva_AduanaDespachoId,
			   deva_DeclaracionMercancia,
			   deva_FechaAceptacion,
			   impo_Id,
			   @prov_Id,
			   @inte_Id,
			   @usua_UsuarioCreacion,
			   @deva_FechaCreacion,
			   @accion
		FROM Adua.tbDeclaraciones_Valor
		WHERE deva_Id = @deva_Id

		SELECT 1
			
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaraciones_Valor_Tab3_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATE OR ALTER PROCEDURE adua.UDP_tbDeclaraciones_Valor_Tab2_Editar
--	@deva_Id						INT,
--	@prov_decl_Nombre_Raso			NVARCHAR(250),
--	@prov_decl_Direccion_Exacta		NVARCHAR(250),
--	@prov_ciud_Id					INT,
--	@prov_decl_Correo_Electronico	NVARCHAR(150),
--	@prov_decl_Telefono				NVARCHAR(50),
--	@prov_decl_Fax					NVARCHAR(50),
--	@prov_RTN						NVARCHAR(50),
--	@coco_Id						INT,
--	@pvde_Condicion_Otra			NVARCHAR(30),
--	@inte_decl_Nombre_Raso			NVARCHAR(250),
--	@inte_decl_Direccion_Exacta		NVARCHAR(250),
--	@inte_ciud_Id					INT,
--	@inte_decl_Correo_Electronico	NVARCHAR(150),
--	@inte_decl_Telefono				NVARCHAR(50),
--	@inte_decl_Fax					NVARCHAR(50),
--	@inte_RTN						NVARCHAR(50),
--	@tite_Id						INT,
--	@inte_Tipo_Otro					NVARCHAR(30),
--	@usua_UsuarioModificacion		INT,
--	@deva_FechaModificacion			DATETIME
--AS
--BEGIN
--	BEGIN TRANSACTION 
--	BEGIN TRY
		
--		DECLARE @prov_decl_Id INT;
--		DECLARE @inte_decl_Id INT;
--		DECLARE @pvde_Id INT
--		DECLARE @inte_Id INT

--		/*Declarantes de proveedores*/
--		-- SI NO EXISTE UN PROVEEDOR CON ESE RTN SE INSERTA
--		IF NOT EXISTS (SELECT decl_NumeroIdentificacion FROM Adua.tbDeclarantes WHERE decl_NumeroIdentificacion = @prov_RTN)
--			BEGIN

--					EXEC adua.UDP_tbDeclarantes_Insertar @prov_decl_Nombre_Raso,
--													   @prov_decl_Direccion_Exacta,
--													   @prov_ciud_Id,
--													   @prov_decl_Correo_Electronico,
--													   @prov_decl_Telefono,
--													   @prov_decl_Fax,
--													   @usua_UsuarioModificacion,
--													   @deva_FechaModificacion,
--													   @prov_RTN,
--													   @prov_decl_Id OUTPUT

--					INSERT INTO Adua.tbProveedoresDeclaracion(	 coco_Id, 
--																  pvde_Condicion_Otra, 
--																  decl_Id, 
--																  usua_UsuarioCreacion, 
--																  pvde_FechaCreacion)
--															VALUES(@coco_Id, 
--																   @pvde_Condicion_Otra,
--																   @prov_decl_Id,
--																   @usua_UsuarioModificacion,
--																	@deva_FechaModificacion)

--					SET @pvde_Id = SCOPE_IDENTITY()	
		
--			END
--			ELSE 
--				BEGIN
--					--SACAMOS EL ID DEL DECLARANTE 
--					SET @prov_decl_Id = (SELECT decl_Id 
--								FROM Adua.tbDeclarantes
--								WHERE decl_NumeroIdentificacion = @prov_RTN)

--				    --VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
--					IF EXISTS (SELECT decl_Id 
--							   FROM tbDeclarantes
--							   WHERE	(decl_Nombre_Raso = @prov_decl_Nombre_Raso
--							   AND		decl_Direccion_Exacta = @prov_decl_Direccion_Exacta
--							   AND		ciud_Id = @prov_ciud_Id
--							   AND		decl_Correo_Electronico = @prov_decl_Correo_Electronico
--							   AND		decl_Telefono = @prov_decl_Telefono
--							   AND		ISNULL(decl_Fax, '') = ISNULL(@prov_decl_Fax, '')
--							   AND		decl_NumeroIdentificacion = @prov_RTN))
--						BEGIN --SI SON IGUALES NO PASA NADA SOLO GUARDAMOS EL ID
--							SET @pvde_Id = (SELECT pvde_Id 
--										FROM Adua.tbProveedoresDeclaracion
--										WHERE decl_Id = @prov_decl_Id)
--						END
--					ELSE --SI NO SON IGUALES SE EDITA LA NUEVA INFORMACION
--						BEGIN

--							EXEC adua.UDP_tbDeclarantes_Editar @prov_decl_Id,
--															   @prov_decl_Nombre_Raso,
--															   @prov_decl_Direccion_Exacta,
--															   @prov_ciud_Id,
--															   @prov_decl_Correo_Electronico,
--															   @prov_decl_Telefono,
--															   @prov_decl_Fax,
--															   @prov_RTN,
--															   @usua_UsuarioModificacion,
--															   @deva_FechaModificacion

--							SET @pvde_Id  = (SELECT pvde_Id
--											FROM Adua.tbProveedoresDeclaracion
--											WHERE decl_Id = @prov_decl_Id)
							
--						END

--					--REVISAMOS SI HUBO CAMBIOS EN LA TABLA DE PROVEEDORES
--					IF EXISTS(SELECT coco_Id, 
--									 pvde_Condicion_Otra
--								FROM Adua.tbProveedoresDeclaracion
--								WHERE pvde_Id = @pvde_Id
--								EXCEPT
--								SELECT  @coco_Id				AS coco_Id, 
--										@pvde_Condicion_Otra	AS pvde_Condicion_Otra)
--						BEGIN
--							UPDATE Adua.tbProveedoresDeclaracion
--							SET	   coco_Id = @coco_Id,
--									pvde_Condicion_Otra = @pvde_Condicion_Otra,
--									usua_UsuarioModificacion = @usua_UsuarioModificacion,
--									pvde_FechaModificacion = @deva_FechaModificacion
--							WHERE pvde_Id = @pvde_Id
--						END
--				END


		

--		/*Declarantes de intermediarios*/
--		IF(@inte_decl_Nombre_Raso IS NOT NULL)
--			BEGIN

--				-- SI NO EXISTE UN REGISTRO CON ESE RTN SE INSERTA
--				IF NOT EXISTS (SELECT decl_Id FROM Adua.tbDeclarantes WHERE decl_NumeroIdentificacion = @inte_RTN)
--					BEGIN
--						EXEC adua.UDP_tbDeclarantes_Insertar @inte_decl_Nombre_Raso,
--																@inte_decl_Direccion_Exacta,
--																@inte_ciud_Id,
--																@inte_decl_Correo_Electronico,
--																@inte_decl_Telefono,
--																@inte_decl_Fax,
--																@usua_UsuarioModificacion,
--																@deva_FechaModificacion,
--																@inte_RTN,
--																@inte_decl_Id OUTPUT


--							INSERT INTO Adua.tbIntermediarios(		tite_Id, 
--																	inte_Tipo_Otro,
--																	decl_Id, 
--																	usua_UsuarioCreacion, 
--																	inte_FechaCreacion)
--															VALUES (@tite_Id, 
--																	@inte_Tipo_Otro, 
--																	@inte_decl_Id,
--																	@usua_UsuarioModificacion,
--																	@deva_FechaModificacion)

--							SET @inte_Id = SCOPE_IDENTITY()
--					END
--				ELSE
--					BEGIN
--						--SACAMOS EL ID DEL DECLARANTE
--						SET @inte_decl_Id = (SELECT decl_Id 
--										FROM Adua.tbDeclarantes
--										WHERE decl_NumeroIdentificacion = @inte_RTN)

--						--VERIFICAMOS SI LOS DATOS SIGUEN SIENDO LOS MISMOS 
--						IF  EXISTS 	(SELECT decl_Id 
--									 FROM tbDeclarantes
--									 WHERE	(decl_Nombre_Raso = @inte_decl_Nombre_Raso
--									 AND	 decl_Direccion_Exacta = @inte_decl_Direccion_Exacta
--									 AND	 ciud_Id = @inte_ciud_Id
--									 AND	 decl_Correo_Electronico = @inte_decl_Correo_Electronico
--									 AND	 decl_Telefono = @inte_decl_Telefono
--									 AND	 ISNULL(decl_Fax, '') = ISNULL(@inte_decl_Fax, '')
--									 AND	 decl_NumeroIdentificacion = @inte_RTN))

--							BEGIN --SI SON IGUALES NO PASA NADA SOLO GUARDAMOS EL ID
--								SET @inte_Id = (SELECT inte_Id 
--												FROM Adua.tbIntermediarios
--												WHERE decl_Id = @inte_decl_Id)
--							END
--						ELSE --SI NO SON IGUALES SE EDITA LA NUEVA INFORMACION
--							BEGIN
--								UPDATE Adua.tbDeclarantes
--								SET decl_Nombre_Raso			= @inte_decl_Nombre_Raso, 
--									decl_Direccion_Exacta		= @inte_decl_Direccion_Exacta, 
--									ciud_Id						= @inte_ciud_Id, 
--									decl_Correo_Electronico		= @inte_decl_Correo_Electronico, 
--									decl_Telefono				= @inte_decl_Telefono, 
--									decl_Fax					= @inte_decl_Fax, 
--									usua_UsuarioModificacion	= @usua_UsuarioModificacion, 
--									decl_FechaModificacion		= @deva_FechaModificacion
--								WHERE decl_Id = @inte_decl_Id

--								SET @inte_Id = (SELECT inte_Id 
--												FROM Adua.tbIntermediarios
--												WHERE decl_Id = @inte_decl_Id)
--							END
							

--						--REVISAMOS SI HUBO CAMBIOS EN LA TABLA DE INTERMEDIARIOS
--						IF EXISTS (SELECT tite_Id, 
--										  inte_Tipo_Otro
--								   FROM Adua.tbIntermediarios
--								   WHERE inte_Id = @inte_Id
--								   EXCEPT 
--								   SELECT @tite_Id			AS tite_Id, 
--										  @inte_Tipo_Otro	AS inte_Tipo_Otro)
--							BEGIN
--								UPDATE Adua.tbIntermediarios
--								SET	   tite_Id = @tite_Id, 
--									   inte_Tipo_Otro = @inte_Tipo_Otro,
--									   usua_UsuarioModificacion = @usua_UsuarioModificacion,
--									   inte_FechaModificacion = @deva_FechaModificacion
--								WHERE inte_Id = @inte_Id
--							END
--					END
--			 END

--		UPDATE Adua.tbDeclaraciones_Valor
--		SET inte_Id = @inte_Id,
--			pvde_Id = @pvde_Id,
--			usua_UsuarioModificacion = @usua_UsuarioModificacion,
--			deva_FechaModificacion = @deva_FechaModificacion
--		WHERE deva_Id = @deva_Id

--		INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
--															deva_AduanaIngresoId, 
--															deva_AduanaDespachoId, 
--															deva_DeclaracionMercancia, 
--															deva_FechaAceptacion, 
--															impo_Id, 
--															pvde_Id, 
--															inte_Id, 
--															deva_LugarEntrega, 
--															inco_Id, 
--															deva_NumeroContrato, 
--															deva_FechaContrato, 
--															foen_Id, 
--															deva_FormaEnvioOtra, 
--															deva_PagoEfectuado, 
--															fopa_Id, 
--															deva_FormaPagoOtra, 
--															emba_Id, 
--															pais_ExportacionId, 
--															deva_FechaExportacion, 
--															mone_Id, 
--															mone_Otra, 
--															deva_ConversionDolares, 
--															--deva_Condiciones,
--															hdev_UsuarioAccion, 
--															hdev_FechaAccion, 
--															hdev_Accion)
--		SELECT deva_Id, 
--			   deva_AduanaIngresoId, 
--			   deva_AduanaDespachoId, 
--			   deva_DeclaracionMercancia, 
--			   deva_FechaAceptacion, 
--			   impo_Id, 
--			   pvde_Id, 
--			   inte_Id, 
--			   deva_LugarEntrega, 
--			   inco_Id, 
--			   deva_NumeroContrato, 
--			   deva_FechaContrato, 
--			   foen_Id, 
--			   deva_FormaEnvioOtra, 
--			   deva_PagoEfectuado, 
--			   fopa_Id, 
--			   deva_FormaPagoOtra, 
--			   emba_Id, 
--			   pais_ExportacionId, 
--			   deva_FechaExportacion, 
--			   mone_Id, 
--			   mone_Otra, 
--			   deva_ConversionDolares, 
--			   --deva_Condiciones,
--			   @usua_UsuarioModificacion,
--			   @deva_FechaModificacion,
--			   'Editar tab2'
--		FROM Adua.tbDeclaraciones_Valor
--		WHERE deva_Id = @deva_Id

--		SELECT 1
			
--		COMMIT TRAN
--	END TRY
--	BEGIN CATCH
--		SELECT 'Error Message: ' + ERROR_MESSAGE()
--		ROLLBACK TRAN
--	END CATCH
--END
--GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclaraciones_Valor_Tab3_Insertar] 
	@deva_Id					INT,	
	@deva_LugarEntrega			NVARCHAR(800),
	@pais_EntregaId				INT,
	@inco_Id					INT,
	@inco_Version				NVARCHAR(10),
	@deva_NumeroContrato		NVARCHAR(200),
	@deva_FechaContrato			DATE,
	@foen_Id					INT,
	@deva_FormaEnvioOtra		NVARCHAR(500),
	@deva_PagoEfectuado			BIT,
	@fopa_Id					INT,
	@deva_FormaPagoOtra			NVARCHAR(200),
	@emba_Id					INT,
	@pais_ExportacionId			INT,
	@deva_FechaExportacion		DATE,
	@mone_Id					INT,
	@mone_Otra					NVARCHAR(200),
	@deva_ConversionDolares		DECIMAL(18,2),
	@usua_UsuarioCreacion		INT,
	@usua_UsuarioModificacion	INT,
	@deva_FechaCreacion			DATETIME
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

			/*IMPORTANTE: Ya que el insertar y editar de tab3 eran exactamente lo mismo, se usará el insertar para ambas funciones*/

			DECLARE @accion NVARCHAR(15) = 'Insertar tab3';

			--Si se envía usuario modificación es porque se edita (la variable @usua_UsuarioCreacion toma el valor simple y sencillamente porque me dio pereza cambiarla XD)
			IF @usua_UsuarioModificacion IS NOT NULL
				BEGIN
					SET @usua_UsuarioCreacion = @usua_UsuarioModificacion
					SET @accion = 'Editar tab3'
				END

			UPDATE Adua.tbDeclaraciones_Valor
			SET deva_LugarEntrega = @deva_LugarEntrega,
				pais_EntregaId = @pais_EntregaId,
				inco_Id = @inco_Id,
				inco_Version = @inco_Version,
				deva_NumeroContrato = @deva_NumeroContrato,
				deva_FechaContrato = @deva_FechaContrato,
				foen_Id = @foen_Id,
				deva_FormaEnvioOtra = @deva_FormaEnvioOtra,
				deva_PagoEfectuado = @deva_PagoEfectuado,
				fopa_Id = @fopa_Id,
				deva_FormaPagoOtra = @deva_FormaPagoOtra,
				emba_Id = @emba_Id,
				pais_ExportacionId = @pais_ExportacionId,
				deva_FechaExportacion = @deva_FechaExportacion,
				mone_Id = @mone_Id,
				mone_Otra = @mone_Otra,
				deva_ConversionDolares = @deva_ConversionDolares,
				usua_UsuarioModificacion = @usua_UsuarioCreacion,
				deva_FechaModificacion = @deva_FechaCreacion
			WHERE deva_id = @deva_Id

			INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
																deva_AduanaIngresoId, 
																deva_AduanaDespachoId, 
																deva_DeclaracionMercancia, 
																deva_FechaAceptacion, 
																impo_Id, 
																pvde_Id, 
																inte_Id, 
																deva_LugarEntrega, 
																inco_Id, 
																deva_NumeroContrato, 
																deva_FechaContrato, 
																foen_Id, 
																deva_FormaEnvioOtra, 
																deva_PagoEfectuado, 
																fopa_Id, 
																deva_FormaPagoOtra, 
																emba_Id, 
																pais_ExportacionId, 
																deva_FechaExportacion, 
																mone_Id, 
																mone_Otra, 
																deva_ConversionDolares, 
																hdev_UsuarioAccion, 
																hdev_FechaAccion, 
																hdev_Accion)

				SELECT deva_Id, 
					   deva_AduanaIngresoId, 
					   deva_AduanaDespachoId, 
					   deva_DeclaracionMercancia, 
					   deva_FechaAceptacion, 
					   impo_Id, 
					   pvde_Id, 
					   inte_Id, 
					   @deva_LugarEntrega,
					   @inco_Id, 
					   @deva_NumeroContrato, 
					   @deva_FechaContrato, 
					   @foen_Id, 
					   @deva_FormaEnvioOtra, 
					   @deva_PagoEfectuado, 
					   @fopa_Id, 
					   @deva_FormaPagoOtra, 
					   @emba_Id, 
					   @pais_ExportacionId, 
					   @deva_FechaExportacion, 
					   @mone_Id, 
					   @mone_Otra, 
					   @deva_ConversionDolares, 
					   @usua_UsuarioCreacion, 
					   @deva_FechaCreacion, 
					   @accion
				FROM Adua.tbDeclaraciones_Valor
				WHERE deva_Id = @deva_Id

			SELECT 1
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END

--GO
--CREATE OR ALTER PROCEDURE adua.UDP_tbDeclaraciones_Valor_Tab3_Editar 
--	@deva_Id					INT,	
--	@deva_LugarEntrega			NVARCHAR(800),
--	@pais_EntregaId				INT,
--	@inco_Id					INT,
--	@inco_Version				NVARCHAR(10),
--	@deva_NumeroContrato		NVARCHAR(200),
--	@deva_FechaContrato			DATE,
--	@foen_Id					INT,
--	@deva_FormaEnvioOtra		NVARCHAR(500),
--	@deva_PagoEfectuado			BIT,
--	@fopa_Id					INT,
--	@deva_FormaPagoOtra			NVARCHAR(200),
--	@emba_Id					INT,
--	@pais_ExportacionId			INT,
--	@deva_FechaExportacion		DATE,
--	@mone_Id					INT,
--	@mone_Otra					NVARCHAR(200),
--	@deva_ConversionDolares	DECIMAL(18,2),
--	@deva_UsuarioModificacion	INT,
--	@deva_FechaModificacion		DATETIME
--AS 
--BEGIN
--	BEGIN TRANSACTION
--	BEGIN TRY

--			UPDATE Adua.tbDeclaraciones_Valor
--			SET deva_LugarEntrega = @deva_LugarEntrega,
--				pais_EntregaId = @pais_EntregaId,
--				inco_Id = @inco_Id,
--				inco_Version = @inco_Version,
--				deva_NumeroContrato = @deva_NumeroContrato,
--				deva_FechaContrato = @deva_FechaContrato,
--				foen_Id = @foen_Id,
--				deva_FormaEnvioOtra = @deva_FormaEnvioOtra,
--				deva_PagoEfectuado = @deva_PagoEfectuado,
--				fopa_Id = @fopa_Id,
--				deva_FormaPagoOtra = @deva_FormaPagoOtra,
--				emba_Id = @emba_Id,
--				pais_ExportacionId = @pais_ExportacionId,
--				deva_FechaExportacion = @deva_FechaExportacion,
--				mone_Id = @mone_Id,
--				mone_Otra = @mone_Otra,
--				deva_ConversionDolares = @deva_ConversionDolares,
--				usua_UsuarioModificacion = @deva_UsuarioModificacion,
--				deva_FechaModificacion = @deva_FechaModificacion
--			WHERE deva_id = @deva_Id

--			INSERT INTO Adua.tbDeclaraciones_ValorHistorial(deva_Id, 
--															deva_AduanaIngresoId, 
--															deva_AduanaDespachoId, 
--															deva_DeclaracionMercancia, 
--															deva_FechaAceptacion, 
--															impo_Id, 
--															pvde_Id, 
--															inte_Id, 
--															deva_LugarEntrega, 
--															inco_Id, 
--															deva_NumeroContrato, 
--															deva_FechaContrato, 
--															foen_Id, 
--															deva_FormaEnvioOtra, 
--															deva_PagoEfectuado, 
--															fopa_Id, 
--															deva_FormaPagoOtra, 
--															emba_Id, 
--															pais_ExportacionId, 
--															deva_FechaExportacion, 
--															mone_Id, 
--															mone_Otra, 
--															deva_ConversionDolares, 
--															--deva_Condiciones,
--															hdev_UsuarioAccion, 
--															hdev_FechaAccion, 
--															hdev_Accion)
--			SELECT deva_Id, 
--				   deva_AduanaIngresoId, 
--				   deva_AduanaDespachoId, 
--				   deva_DeclaracionMercancia, 
--				   deva_FechaAceptacion, 
--				   impo_Id, 
--				   pvde_Id, 
--				   inte_Id, 
--				   deva_LugarEntrega, 
--				   inco_Id, 
--				   deva_NumeroContrato, 
--				   deva_FechaContrato, 
--				   foen_Id, 
--				   deva_FormaEnvioOtra, 
--				   deva_PagoEfectuado, 
--				   fopa_Id, 
--				   deva_FormaPagoOtra, 
--				   emba_Id, 
--				   pais_ExportacionId, 
--				   deva_FechaExportacion, 
--				   mone_Id, 
--				   mone_Otra, 
--				   deva_ConversionDolares, 
--				   --deva_Condiciones,
--				   @deva_UsuarioModificacion,
--				   @deva_FechaModificacion,
--				   'Editar tab3'
--			FROM Adua.tbDeclaraciones_Valor
--			WHERE deva_Id = @deva_Id

--			SELECT 1
--		COMMIT TRAN
--	END TRY
--	BEGIN CATCH
--		SELECT 'Error Message: ' + ERROR_MESSAGE()
--		ROLLBACK TRAN
--	END CATCH
--END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclaracionValor_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbDeclaracionValor_Eliminar]
	@deva_Id	INT,
	@fact_Id	INT,
	@codi_Id	INT,
	@base_Id	INT
AS
BEGIN
BEGIN TRAN
	BEGIN TRY
		IF(@base_Id <> 0)
			BEGIN
				DELETE FROM [Adua].[tbBaseCalculos] WHERE base_Id = @base_Id
			END
		IF(@codi_Id <> 0)
			BEGIN
				DELETE FROM [Adua].[tbCondiciones] WHERE codi_Id = @codi_Id
			END
		IF(@fact_Id <> 0)
			BEGIN
				DELETE FROM [Adua].[tbItems] WHERE fact_Id = @fact_Id

				DELETE FROM [Adua].[tbFacturas] WHERE fact_Id = @fact_Id
			END

		DELETE FROM [Adua].[tbDeclaraciones_Valor] WHERE deva_Id = @deva_Id

		SELECT 1
COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclarantes_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclarantes_Editar]
	@decl_Id						INT,
	@decl_Nombre_Raso				NVARCHAR(250),
	@decl_Direccion_Exacta			NVARCHAR(250),
	@ciud_Id						INT,
	@decl_Correo_Electronico		NVARCHAR(150),
	@decl_Telefono					NVARCHAR(50),
	@decl_Fax						NVARCHAR(50),
	@decl_NumeroIdentificacion		NVARCHAR(50),
	@usua_UsuarioModificacion		INT,
	@decl_FechaModificacion			DATETIME
AS
BEGIN
	BEGIN TRY
		
		UPDATE Adua.tbDeclarantes
		SET decl_Nombre_Raso = @decl_Nombre_Raso, 
			decl_Direccion_Exacta = @decl_Direccion_Exacta, 
			ciud_Id = @ciud_Id, 
			decl_Correo_Electronico = @decl_Correo_Electronico, 
			decl_Telefono = @decl_Telefono, 
			decl_Fax = @decl_Fax, 
			usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			decl_FechaModificacion = @decl_FechaModificacion
		WHERE decl_Id = @decl_Id

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclarantes_Find]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--Endpoint para rellenar información cuando se escriba el número de identificación 
CREATE   PROCEDURE [Adua].[UDP_tbDeclarantes_Find] 
	@decl_NumeroIdentificacion	NVARCHAR(MAX)
AS
BEGIN
	SELECT decl.decl_Id,
		   decl.decl_NumeroIdentificacion, 
		   decl.decl_Nombre_Raso, 
		   decl.decl_Direccion_Exacta, 
		   decl.ciud_Id, 
		   decl.decl_Correo_Electronico, 
		   decl.decl_Telefono, 
		   decl.decl_Fax,
		   impo.nico_Id,
		   impo.impo_NivelComercial_Otro,
		   impo.impo_RTN,
		   impo.impo_NumRegistro,
		   inte.tite_Id,
		   inte.inte_Tipo_Otro,
		   prov.coco_Id,
		   prov.pvde_Condicion_Otra
	FROM   Adua.tbDeclarantes decl
	LEFT JOIN Adua.tbImportadores impo				ON decl.decl_Id = impo.decl_Id
	LEFT JOIN Adua.tbIntermediarios inte			ON decl.decl_Id = inte.decl_Id
	LEFT JOIN Adua.tbProveedoresDeclaracion	prov	ON decl.decl_Id = prov.decl_Id
	WHERE decl_NumeroIdentificacion = @decl_NumeroIdentificacion
END

--GO
--CREATE OR ALTER PROCEDURE adua.UDP_tbDeclaraciones_ValorCompleto_Listar
--AS
--BEGIN
--	SELECT	deva_Id, 
--			deva_AduanaIngresoId, 
--			aduaIngreso.adua_Nombre		AS adua_IngresoNombre,
--			deva_AduanaDespachoId, 
--			aduaDespacho.adua_Nombre	AS adua_DespachoNombre,
--			deva_DeclaracionMercancia, 
--			deva_FechaAceptacion, 

--			impo.impo_Id, 
--			impo.impo_NumRegistro,
--			impo.nico_Id,
--			nico.nico_Descripcion,
--			impo.impo_NivelComercial_Otro,
--			declaImpo.decl_Nombre_Raso			AS impo_Nombre_Raso,
--			declaImpo.decl_Direccion_Exacta		AS impo_Direccion_Exacta,
--			declaImpo.decl_Correo_Electronico	AS impo_Correo_Electronico,
--			declaImpo.decl_Telefono				AS impo_Telefono,
--			declaImpo.decl_Fax					AS impo_Fax,			
--			declaImpo.ciud_Id					AS impo_ciudId,
			
--			deva.pvde_Id,			
--			declaProv.decl_Nombre_Raso			AS prov_Nombre_Raso,
--			declaProv.decl_Direccion_Exacta		AS prov_Direccion_Exacta,
--			declaProv.decl_Correo_Electronico	AS prov_Correo_Electronico,
--			declaProv.decl_Telefono				AS prov_Telefono,
--			declaProv.decl_Fax					AS prov_Fax,			
--			declaProv.ciud_Id					AS prov_ciudId,
--			prov.coco_Id,			
--			coco.coco_Descripcion,
--			prov.pvde_Condicion_Otra,		

--			inte.inte_Id, 
--			inte.tite_Id,
--			declaInte.decl_Nombre_Raso			AS inte_Nombre_Raso,
--			declaInte.decl_Direccion_Exacta		AS inte_Direccion_Exacta,
--			declaInte.decl_Correo_Electronico	AS inte_Correo_Electronico,
--			declaInte.decl_Telefono				AS inte_Telefono,
--			declaInte.decl_Fax					AS inte_Fax,			
--			declaInte.ciud_Id					AS inte_ciudId,


--			deva_LugarEntrega, 
--			pais_EntregaId, 
--			inco.inco_Id, 
--			inco.inco_Descripcion,
--			inco_Version, 
--			deva_NumeroContrato, 
--			deva_FechaContrato, 
--			foen.foen_Id, 
--			foen.foen_Descripcion,

--			deva_FormaEnvioOtra, 
--			deva_PagoEfectuado, 
--			fopa_Id, 
--			deva_FormaPagoOtra, 
--			emba_Id, 
--			pais_ExportacionId, 
--			deva_FechaExportacion, 
--			mone_Id, 
--			mone_Otra, 
--			deva_ConversionDolares, 
--			----deva_Condiciones, 
--			deva.usua_UsuarioCreacion, 
--			usuaCrea.usua_Nombre				AS usua_CreacionNombre,
--			deva_FechaCreacion, 
--			deva.usua_UsuarioModificacion		AS usua_ModificacionNombre,
--			deva_FechaModificacion, 
--			deva_Estado 
--	FROM	Adua.tbDeclaraciones_Valor deva 
--			LEFT JOIN Adua.tbAduanas aduaIngreso			ON deva.deva_AduanaIngresoId = aduaIngreso.adua_Id
--			LEFT JOIN Adua.tbAduanas aduaDespacho			ON deva.deva_AduanaDespachoId = aduaDespacho.adua_Id
--			LEFT JOIN Adua.tbImportadores impo				ON deva.impo_Id = impo.impo_Id
--			LEFT JOIN Adua.tbDeclarantes declaImpo			ON impo.decl_Id = declaImpo.decl_Id
--			LEFT JOIN Adua.tbNivelesComerciales nico		ON impo.nico_Id = nico.nico_Id
--			LEFT JOIN Adua.tbProveedoresDeclaracion prov	ON prov.pvde_Id = deva.pvde_Id
--			LEFT JOIN Adua.tbDeclarantes declaProv			ON prov.decl_Id = declaProv.decl_Id
--			LEFT JOIN Adua.tbCondicionesComerciales coco	ON prov.coco_Id = coco.coco_Id
--			LEFT JOIN Adua.tbIntermediarios inte			ON inte.inte_Id = deva.inte_Id
--			LEFT JOIN Adua.tbDeclarantes declaInte			ON declaInte.decl_Id = inte.decl_Id
--			LEFT JOIN Adua.tbIncoterm inco					ON deva.inco_Id = inco.inco_Id
--			LEFT JOIN Gral.tbFormas_Envio foen				ON deva.foen_Id = foen.foen_Id 
--			LEFT JOIN Acce.tbUsuarios usuaCrea				ON deva.usua_UsuarioCreacion = usuaCrea.usua_Id
--			LEFT JOIN Acce.tbUsuarios usuaModifica			ON deva.usua_UsuarioModificacion = usuaModifica.usua_Id
	
--END
--GO
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclarantes_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDeclarantes_Insertar]
	@decl_Nombre_Raso				NVARCHAR(250),
	@decl_Direccion_Exacta			NVARCHAR(250),
	@ciud_Id						INT,
	@decl_Correo_Electronico		NVARCHAR(150),
	@decl_Telefono					NVARCHAR(50),
	@decl_Fax						NVARCHAR(50),
	@usua_UsuarioCreacion			INT,
	@decl_FechaCreacion				DATETIME,
	@decl_NumeroIdentificacion		NVARCHAR(50),
	@decl_Id						INT OUTPUT
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbDeclarantes(decl_NumeroIdentificacion,
										   decl_Nombre_Raso, 
										   decl_Direccion_Exacta, 
										   ciud_Id, 
										   decl_Correo_Electronico, 
										   decl_Telefono, 
										   decl_Fax, 
										   usua_UsuarioCreacion, 
										   decl_FechaCreacion)
		VALUES(@decl_NumeroIdentificacion,
			   @decl_Nombre_Raso,
			   @decl_Direccion_Exacta,
			   @ciud_Id,
			   @decl_Correo_Electronico,
			   @decl_Telefono,
			   @decl_Fax,
			   @usua_UsuarioCreacion,
			   @decl_FechaCreacion)

		SET @decl_Id = SCOPE_IDENTITY()

		RETURN @decl_Id
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDeclarantes_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* Listar Declarantes*/ 
CREATE   PROCEDURE [Adua].[UDP_tbDeclarantes_Listar]
AS
BEGIN
	SELECT	decl.decl_Id AS idDeclarante, 
		decl.decl_Nombre_Raso  AS NombreDeclarante, 
		decl.decl_Direccion_Exacta AS DireccionExacta, 
		decl.ciud_Id  AS idProvincia,
		
		prvi.pvin_Codigo AS CodigoProvincia,
		prvi.pvin_Nombre  AS NombreProvincia,
		
		pais.pais_Codigo AS CodigoPais,
		pais.pais_Nombre AS NombrePais,
		
		decl.decl_Correo_Electronico AS CorreoElectronico, 
		decl.decl_Telefono AS Telefono,  
		decl.decl_Fax  AS Fax,
		
		usu.usua_Id  AS IdUsuarioCreacion,
		usu.usua_UsuarioCreacion AS UsuarioCreacion,
		decl.decl_FechaCreacion AS FechaCreacion,
		usu1.usua_Id AS IdUsuarioModifica,
		usu1.usua_Nombre AS usuarioModifica,
		decl.decl_FechaModificacion AS FechaModificacion,

		decl.decl_Estado
		 
FROM    Adua.tbDeclarantes decl 
         INNER JOIN Gral.tbProvincias prvi ON		decl.ciud_Id = prvi.pvin_Id 
         INNER JOIN Gral.tbPaises  pais    ON		prvi.pvin_Codigo = pais.pais_Codigo
		 INNER JOIN Acce.tbUsuarios usu    ON       usu.usua_UsuarioCreacion = decl.usua_UsuarioCreacion 
		 LEFT JOIN Acce.tbUsuarios usu1   ON       usu1.usua_UsuarioModificacion = decl.usua_UsuarioModificacion
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_CargarDocuComerciante]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA/PRUEBA

CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_CargarDocuComerciante]
@coin_Id				INT
AS
BEGIN
		SELECT 
		[doco_Id], [coin_Id], [doco_Numero_O_Referencia], [doco_TipoDocumento], 
		[usua_UsuarioCreacion],[doco_FechaCreacion], 
		[usua_UsuarioModificacion], [doco_FechaModificacion], [doco_Estado], 
		[doco_URLImagen], [doco_NombreImagen]
		
		FROM [Adua].[tbDocumentosContratos]
		WHERE [coin_Id] = @coin_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_CargarDocuJuridica]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_CargarDocuJuridica]
    @peju_Id				INT
AS
BEGIN
		SELECT 
		[doco_Id], [peju_Id], [doco_Numero_O_Referencia], [doco_TipoDocumento], 
		[usua_UsuarioCreacion],[doco_FechaCreacion], 
		[usua_UsuarioModificacion], [doco_FechaModificacion], [doco_Estado], 
		[doco_URLImagen], [doco_NombreImagen]
		
		FROM [Adua].[tbDocumentosContratos]
		WHERE [peju_Id] = @peju_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_ComercianteEditar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_ComercianteEditar] 
	@coin_Id						INT,
    @doco_URLImagen					NVARCHAR(MAX),
    @usua_UsuarioModificacion		INT,
    @doco_FechaModificacion			DATETIME,
	@FormaRepresentacion			BIT   --NUEVO
AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

        INSERT INTO Adua.tbDocumentosContratos ([coin_Id],
                                                [doco_URLImagen],
                                                [usua_UsuarioModificacion],
												[usua_UsuarioCreacion],
                                                [doco_FechaModificacion],
												[doco_FechaCreacion],
                                                [doco_Numero_O_Referencia],
                                                [doco_TipoDocumento])
        SELECT @coin_Id,
               [doco_URLImagen],
               @usua_UsuarioModificacion,
			   @usua_UsuarioModificacion,
               @doco_FechaModificacion,
			   @doco_FechaModificacion,
               [doco_Numero_O_Referencia],
               [doco_TipoDocumento]
        FROM OPENJSON(@doco_URLImagen, '$.documentos')
        WITH (
            doco_TipoDocumento NVARCHAR(7),
            doco_Numero_O_Referencia NVARCHAR(50),
            doco_URLImagen NVARCHAR(MAX)
        )

		IF(@FormaRepresentacion = 0)
		BEGIN
			DELETE FROM Adua.tbDocumentosContratos 
			WHERE coin_Id = @coin_Id AND (
			 [doco_TipoDocumento] = 'RTN-RL'
			OR [doco_TipoDocumento] = 'DNI-RL')
		END

		UPDATE Adua.tbComercianteIndividual
		SET usua_UsuarioModificacion = @usua_UsuarioModificacion,
			coin_FechaModificacion = @doco_FechaModificacion
		WHERE  coin_Id = @coin_Id

        SELECT 1
	COMMIT TRAN	
    END TRY
    BEGIN CATCH
       	ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_ComercianteInsertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_ComercianteInsertar]
    @coin_Id INT,
    @doco_URLImagen NVARCHAR(MAX),
    @usua_UsuarioCreacion INT,
    @doco_FechaCreacion DATETIME
AS
BEGIN
    BEGIN TRY
        -- Insertar los datos desde el JSON sin modificar @usua_UsuarioCreacion
        INSERT INTO Adua.tbDocumentosContratos ([coin_Id],
                                                [doco_URLImagen],
                                                [usua_UsuarioCreacion],
                                                [doco_FechaCreacion],
                                                [doco_Numero_O_Referencia],
                                                [doco_TipoDocumento])
        SELECT @coin_Id,
               [doco_URLImagen],
               @usua_UsuarioCreacion, 
               @doco_FechaCreacion,
               [doco_Numero_O_Referencia],
               [doco_TipoDocumento]
        FROM OPENJSON(@doco_URLImagen, '$.documentos')
        WITH (
            doco_TipoDocumento NVARCHAR(6),
            doco_Numero_O_Referencia NVARCHAR(50),
            doco_URLImagen NVARCHAR(MAX)
        )

        SELECT 1
    END TRY
    BEGIN CATCH
        SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_JuridicaInsertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_JuridicaInsertar]
    @peju_Id INT,
    @doco_URLImagen NVARCHAR(MAX),
    @usua_UsuarioCreacion INT,
    @doco_FechaCreacion DATETIME
AS
BEGIN
    BEGIN TRY
        INSERT INTO Adua.tbDocumentosContratos ([peju_Id],
                                                [doco_URLImagen],
                                                [usua_UsuarioCreacion],
                                                [doco_FechaCreacion],
                                                [doco_Numero_O_Referencia],
                                                [doco_TipoDocumento])
        SELECT @peju_Id,
               [doco_URLImagen],
               @usua_UsuarioCreacion, 
               @doco_FechaCreacion,
               [doco_Numero_O_Referencia],
               [doco_TipoDocumento]
        FROM OPENJSON(@doco_URLImagen, '$.documentos')
        WITH (
            doco_TipoDocumento NVARCHAR(6),
            doco_Numero_O_Referencia NVARCHAR(50),
            doco_URLImagen NVARCHAR(MAX)
        )

        SELECT 1
    END TRY
    BEGIN CATCH
        SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContrato_PersonaJuridicaEditar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContrato_PersonaJuridicaEditar]
    @peju_Id						INT,
    @doco_URLImagen					NVARCHAR(MAX),
    @usua_UsuarioCreacion			INT,
    @peju_FechaCreacion				DATETIME
AS
BEGIN
    BEGIN TRY
    BEGIN TRANSACTION

		DELETE FROM Adua.tbDocumentosContratos 
		WHERE [peju_Id] = @peju_Id


        INSERT INTO Adua.tbDocumentosContratos ([coin_Id],
                                                [doco_URLImagen],
                                                [usua_UsuarioCreacion],
                                                [doco_FechaModificacion],
                                                [doco_Numero_O_Referencia],
                                                [doco_TipoDocumento])
        SELECT @peju_Id,
               [doco_URLImagen],
               @usua_UsuarioCreacion,
               @peju_FechaCreacion,
               [doco_Numero_O_Referencia],
               [doco_TipoDocumento]
        FROM OPENJSON(@doco_URLImagen, '$.documentos')
        WITH (
            doco_TipoDocumento NVARCHAR(6),
            doco_Numero_O_Referencia NVARCHAR(50),
            doco_URLImagen NVARCHAR(MAX)
        )

        SELECT 1
	COMMIT TRAN	
    END TRY
    BEGIN CATCH
       	ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContratos_DeleteByCoin_Id]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContratos_DeleteByCoin_Id]
@coin_Id INT
AS
	BEGIN
		BEGIN TRY
			DELETE Adua.tbDocumentosContratos WHERE coin_Id = @coin_Id
			SELECT 1
		END TRY

		BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
		END CATCH
	END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContratos_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ELIMINAR DOCUMENTOS CONTRATOS */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContratos_Eliminar]
@doco_Id					INT
AS
BEGIN
  	BEGIN TRY


		DELETE FROM Adua.tbDocumentosContratos
		   WHERE	doco_Id = @doco_Id
 
  				   SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosContratos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* LISTAR DOCUMENTOS CONTRATOS */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosContratos_Listar]
AS
BEGIN
 

	SELECT	 [doco_Id], [coin_Id], [peju_Id],
	[doco_Numero_O_Referencia], [doco_TipoDocumento],
	[usua_UsuarioCreacion], [doco_FechaCreacion], 
	[usua_UsuarioModificacion], [doco_FechaModificacion], 
	[doco_Estado], [doco_URLImagen], [doco_NombreImagen]
	 FROM	Adua.tbDocumentosContratos					

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosDeSoporte_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* INSERTAR DOCUMENTOS DE SOPORTE */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosDeSoporte_Insertar] 
	@tido_Id					        INT,
	@duca_Id							INT,
	@doso_NumeroDocumento		        NVARCHAR(15),
	@doso_FechaEmision			        DATE,
	@doso_FechaVencimiento		        DATE,
	@doso_PaisEmision			        INT,
	@doso_LineaAplica			        CHAR(4),
	@doso_EntidadEmitioDocumento        NVARCHAR(75),
	@doso_Monto				           	NVARCHAR(50),
	@usua_UsuarioCreacion				INT,
	@doso_FechaCreacion					DATETIME

AS
BEGIN 

BEGIN TRY

	INSERT INTO Adua.tbDocumentosDeSoporte
			   (tido_Id
			   ,duca_Id
			   ,doso_NumeroDocumento
			   ,doso_FechaEmision
			   ,doso_FechaVencimiento
			   ,doso_PaisEmision
			   ,doso_LineaAplica
			   ,doso_EntidadEmitioDocumento
			   ,doso_Monto

			   ,usua_UsuarioCreacion
			   ,doso_FechaCreacion)
		 VALUES
			   (@tido_Id
			   ,@duca_Id
			   ,UPPER(@doso_NumeroDocumento)
			   ,@doso_FechaEmision
			   ,@doso_FechaVencimiento
			   ,@doso_PaisEmision
			   ,@doso_LineaAplica
			   ,@doso_EntidadEmitioDocumento
			   ,@doso_Monto

			   ,@usua_UsuarioCreacion
			   ,@doso_FechaCreacion)

			   SELECT 1
			   END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 

END


-------------------------------------------------------

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosDeSoporte_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* LISTAR DOCUMENTOS DE SOPORTE */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosDeSoporte_Listar]
AS 
BEGIN

	SELECT  doso.doso_Id
		   ,tido.tido_Id
		   ,tido.tido_Codigo
		   ,tido.tido_Descripcion
		   ,doso.duca_Id
		   ,doso.doso_NumeroDocumento
		   ,doso.doso_FechaEmision
		   ,doso.doso_FechaVencimiento
		   ,doso.doso_PaisEmision
		   ,doso.doso_LineaAplica
		   ,doso.doso_EntidadEmitioDocumento
		   ,doso.doso_Monto
		   ,doso.usua_UsuarioCreacion
		   ,crea.usua_Nombre AS UsuarioCreacionNombre
		   ,doso.doso_FechaCreacion
		   ,doso.usua_UsuarioModificacion 
		   ,modi.usua_Nombre AS UsuarioModificadorNombre 
		   ,doso.doso_FechaModificacion
		   ,doso.usua_UsuarioEliminacion AS UsuarioElimincionNombre
		   ,elim.usua_Nombre
		   ,doso.doso_FechaEliminacion
		   ,doso.doso_Estado
	  FROM Adua.tbDocumentosDeSoporte doso	
			INNER JOIN Adua.tbTipoDocumento tido   ON	doso.tido_Id					= tido.tido_Id 
			INNER JOIN Acce.tbUsuarios	  crea	   ON	doso.usua_UsuarioCreacion		= crea.usua_Id
			LEFT JOIN Acce.tbUsuarios	  modi     ON	doso.usua_UsuarioModificacion	= modi.usua_Id
			LEFT JOIN Acce.tbUsuarios	  elim     ON	doso.usua_UsuarioEliminacion	= elim.usua_Id
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosPDF_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* EDITAR DOCUMENTOS PDF */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosPDF_Editar]
@dpdf_Id					INT,
@deva_Id					INT,
@dpdf_CA					NVARCHAR(200),
@dpdf_DVA					NVARCHAR(200),
@dpdf_DUCA					NVARCHAR(200),
@dpdf_Boletin				NVARCHAR(200),
@usua_UsuarioModificacion   INT,
@dpdf_FechaModificacion     DATETIME

AS
BEGIN 

 
	BEGIN TRY
		BEGIN TRAN
			UPDATE	Adua.tbDocumentosPDF
				SET	deva_Id = @deva_Id
					,dpdf_CA = @dpdf_CA
					,dpdf_DVA = @dpdf_DVA
					,dpdf_DUCA = @dpdf_DUCA
					,dpdf_Boletin = @dpdf_Boletin
					,usua_UsuarioModificacion = @usua_UsuarioModificacion
					,dpdf_FechaModificacion = @dpdf_FechaModificacion
			  WHERE	dpdf_Id = @dpdf_Id
 
 					   SELECT 1

					   


		  INSERT INTO Adua.tbDocumentosPDFHistorial	(dpdf_Id
													,deva_Id
													,dpdf_CA
													,dpdf_DVA
													,dpdf_DUCA
													,dpdf_Boletin
													,hpdf_UsuarioAccion
													,hpdf_FechaAccion
													,hpdf_Accion)
			VALUES (  @dpdf_Id,
					  @deva_Id,
					  @dpdf_CA,
					  @dpdf_DVA,
					  @dpdf_DUCA,
					  @dpdf_Boletin,
					  @usua_UsuarioModificacion,
					  @dpdf_FechaModificacion,
					  'Editar')
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 


END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosPDF_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ELIMINAR DOCUMENTOS PDF */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosPDF_Eliminar]
	@dpdf_Id					INT,
	@usua_UsuarioEliminacion    INT,
	@dpdf_FechaEliminacion		DATETIME
AS
BEGIN 

	BEGIN TRY
 		BEGIN TRAN
		UPDATE	 Adua.tbDocumentosPDF
		   SET	 usua_UsuarioEliminacion =	@usua_UsuarioEliminacion
				,dpdf_FechaEliminacion =		@dpdf_FechaEliminacion
				,dpdf_Estado = 0
		 WHERE	 dpdf_Id = @dpdf_Id
 



				   SELECT 1

			
  INSERT INTO Adua.tbDocumentosPDFHistorial	(dpdf_Id
											,deva_Id
											,dpdf_CA
											,dpdf_DVA
											,dpdf_DUCA
											,dpdf_Boletin
											,hpdf_UsuarioAccion
											,hpdf_FechaAccion
											,hpdf_Accion)
	SELECT    dpdf_Id,
			  deva_Id,
			  dpdf_CA,
			  dpdf_DVA,
			  dpdf_DUCA,
			  dpdf_Boletin,
			  @usua_UsuarioEliminacion,
			  @dpdf_FechaEliminacion,
			  'Eliminar'
			  FROM Adua.tbDocumentosPDF 
			  WHERE dpdf_Id = @dpdf_Id

		 COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK
			SELECT 'Error Message: ' + ERROR_MESSAGE()
		END CATCH 

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosPDF_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* INSERTAR DOCUMENTOS PDF */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosPDF_Insertar]
	@deva_Id				INT,
	@dpdf_CA				NVARCHAR(200),
	@dpdf_DVA				NVARCHAR(200),
	@dpdf_DUCA				NVARCHAR(200),
	@dpdf_Boletin			NVARCHAR(200),
	@usua_UsuarioCreacion   INT,
	@dpdf_FechaCreacion     DATETIME
     
AS
BEGIN 
 
	BEGIN TRY
		BEGIN TRAN
			INSERT INTO Adua.tbDocumentosPDF
					   (deva_Id
					   ,dpdf_CA
					   ,dpdf_DVA
					   ,dpdf_DUCA
					   ,dpdf_Boletin
					   ,usua_UsuarioCreacion
					   ,dpdf_FechaCreacion)
				 VALUES
					   (@deva_Id				
					   ,@dpdf_CA				
					   ,@dpdf_DVA				
					   ,@dpdf_DUCA				
					   ,@dpdf_Boletin			
					   ,@usua_UsuarioCreacion   
					   ,@dpdf_FechaCreacion)

				   SELECT 1

				   
	  DECLARE @dpdf_Id INT = SCOPE_IDENTITY();

	  INSERT INTO Adua.tbDocumentosPDFHistorial	(dpdf_Id
												,deva_Id
												,dpdf_CA
												,dpdf_DVA
												,dpdf_DUCA
												,dpdf_Boletin
												,hpdf_UsuarioAccion
												,hpdf_FechaAccion
												,hpdf_Accion)
		VALUES	 (@dpdf_Id,
				  @deva_Id,
				  @dpdf_CA,
				  @dpdf_DVA,
				  @dpdf_DUCA,
				  @dpdf_Boletin,
				  @usua_UsuarioCreacion,
				  @dpdf_FechaCreacion,
				  'Insertar')

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 

END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosPDF_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* LISTAR DOCUMENTOS PDF */
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosPDF_Listar]
AS
BEGIN 
 

 SELECT	 pdf.dpdf_Id
		,deva.deva_Id
		,deva.deva_NumeroContrato
		,deva.deva_DeclaracionMercancia
 		,deva.emba_Id
 		,deva.deva_LugarEntrega
  		,pdf.dpdf_CA
		,pdf.dpdf_DVA
		,pdf.dpdf_DUCA
		,pdf.dpdf_Boletin
		,pdf.usua_UsuarioCreacion
		,crea.usua_Nombre AS UsuarioCreacionNombre	
		,pdf.dpdf_FechaCreacion
		,pdf.usua_UsuarioModificacion
		,modi.usua_Nombre AS UsuarioModificadorNombre
		,pdf.dpdf_FechaModificacion
		,pdf.usua_UsuarioEliminacion
		,elim.usua_Nombre AS UsuarioElimincionNombre
		,pdf.dpdf_FechaEliminacion
		,pdf.dpdf_Estado
  FROM	Adua.tbDocumentosPDF			pdf
  INNER JOIN Adua.tbDeclaraciones_Valor deva		ON	pdf.deva_Id						= deva.deva_Id
  INNER JOIN Acce.tbUsuarios			crea		ON	pdf.usua_UsuarioCreacion		= crea.usua_Id
  LEFT JOIN Acce.tbUsuarios				modi		ON	pdf.usua_UsuarioModificacion	= modi.usua_Id
  LEFT JOIN Acce.tbUsuarios				elim		ON	pdf.usua_UsuarioEliminacion		= elim.usua_Id

END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosSanciones_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--***************************************Documentos de Sanciones***************************************--
/*Insertar documento de sanciones*/
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosSanciones_Insertar]
(
	@dosa_NombreDocumento		NVARCHAR(150),
	@dosa_UrlDocumento			NVARCHAR(250),
	@usua_UsuarioCreacion		INT,
	@dosa_FechaCreacion			DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbDocumentosSanciones
		VALUES (@dosa_NombreDocumento, @dosa_UrlDocumento, @usua_UsuarioCreacion, @dosa_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDocumentosSanciones_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Listar documento de sanciones*/
CREATE   PROCEDURE [Adua].[UDP_tbDocumentosSanciones_Listar]
AS
BEGIN
	SELECT dosa_Id,
		   dosa_NombreDocumento,
		   dosa_UrlDocumento,
		   usua_UsuarioCreacion,
		   dosa_FechaCreacion
	  FROM Adua.tbDocumentosSanciones
  ORDER BY dosa_FechaCreacion DESC 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_CancelarEliminarDuca]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Procedimiento para eliminar por completo una DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_CancelarEliminarDuca]
(
	@duca_Id	INT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN 

			DECLARE @cont_Id INT = (SELECT duca_Conductor_Id FROM Adua.tbDuca WHERE duca_Id = @duca_Id)
			DECLARE @tran_Id INT = (SELECT tran_Id FROM Adua.tbConductor WHERE cont_Id = @cont_Id)

			DELETE FROM Adua.tbDocumentosDeSoporte WHERE duca_Id = @duca_Id

			DELETE FROM Adua.tbItemsDEVAPorDuca WHERE duca_Id = @duca_Id

			DELETE FROM Adua.tbDuca WHERE duca_Id = @duca_Id

			DELETE FROM Adua.tbConductor WHERE cont_Id = @cont_Id

			DELETE FROM Adua.tbTransporte WHERE tran_Id = @tran_Id

		COMMIT
		SELECT 1
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_EditarTab1]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar parte 1 de la DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_EditarTab1]
	@duca_Id							INT,
	@duca_No_Duca						NVARCHAR(100),
	@duca_No_Correlativo_Referencia		NVARCHAR(MAX),
	@duca_AduanaRegistro				INT,
	@duca_AduanaDestino					INT,
	@duca_Regimen_Aduanero				INT,
	@duca_Modalidad						NVARCHAR(MAX),
	@duca_Clase							NVARCHAR(MAX),
	@duca_FechaVencimiento				DATETIME,
	@duca_Pais_Procedencia				INT,
	@duca_Pais_Destino					INT,
	@duca_Deposito_Aduanero				NVARCHAR(MAX),
	@duca_Lugar_Desembarque				NVARCHAR(MAX),
	@duca_Manifiesto					NVARCHAR(150),
	@duca_Titulo						NVARCHAR(150),
	@duca_Ventaja						NVARCHAR(100),
	@usua_UsuarioModificacion			INT,
	@duca_FechaModificacion				DATETIME
AS
BEGIN
	BEGIN TRY
	 UPDATE Adua.tbDuca
		SET duca_No_Duca					 = UPPER(@duca_No_Duca),
			duca_No_Correlativo_Referencia	 = UPPER(@duca_No_Correlativo_Referencia),
			duca_AduanaRegistro				 = @duca_AduanaRegistro,
			duca_AduanaDestino				 = @duca_AduanaDestino,
			duca_Regimen_Aduanero			 = @duca_Regimen_Aduanero,
			duca_Modalidad					 = @duca_Modalidad,
			duca_Clase						 = @duca_Clase,
			duca_FechaVencimiento			 = @duca_FechaVencimiento,
			duca_Pais_Procedencia			 = @duca_Pais_Procedencia,
			duca_Pais_Destino				 = @duca_Pais_Destino,
			duca_Deposito_Aduanero			 = @duca_Deposito_Aduanero,
			duca_Lugar_Desembarque			 = @duca_Lugar_Desembarque,
			duca_Manifiesto					 = UPPER(@duca_Manifiesto),
			duca_Titulo						 = UPPER(@duca_Titulo),
			duca_Ventaja					 = @duca_Ventaja,
			usua_UsuarioModificacion		 = @usua_UsuarioModificacion,
			duca_FechaModificacion			 = @duca_FechaModificacion
	  WHERE duca_Id = @duca_Id	

		  SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error :' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_EditarTab2]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar parte 2 de la DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_EditarTab2]
	@duca_Id							INT,
	@duca_Codigo_Declarante				NVARCHAR(200),
	@duca_Numero_Id_Declarante			NVARCHAR(200),
	@duca_NombreSocial_Declarante		NVARCHAR(MAX),
	@duca_DomicilioFiscal_Declarante	NVARCHAR(MAX),
	@duca_Codigo_Transportista			NVARCHAR(200),
	@duca_Transportista_Nombre			NVARCHAR(MAX),
	@motr_Id							INT,
	@duca_Conductor_Id					INT,
	@cont_NoIdentificacion				VARCHAR(50),
	@cont_Licencia						NVARCHAR(200),
	@pais_IdExpedicion					INT,
	@cont_Nombre						NVARCHAR(200),
	@cont_Apellido						NVARCHAR(200),
	@pais_Id							INT,
	@marca_Id							INT,
	@tran_IdUnidadTransporte			INT,
	@tran_Chasis						NVARCHAR(100),
	@tran_Remolque						NVARCHAR(50),
	@tran_CantCarga						INT,
	@tran_NumDispositivoSeguridad		INT,
	@tran_Equipamiento					NVARCHAR(200),
	@tran_TamanioEquipamiento			NVARCHAR(50),
	@tran_TipoCarga						NVARCHAR(200),
	@tran_IdContenedor					NVARCHAR(100),
	@usua_UsuarioModificacion			INT,
	@duca_FechaModificacion				DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN

			DECLARE @Transporte_Id INT = (SELECT tran_Id FROM Adua.tbConductor WHERE cont_Id = @duca_Conductor_Id);

			UPDATE Adua.tbTransporte 
			SET    pais_Id = @pais_Id, 
				   tran_Chasis = UPPER(@tran_Chasis), 
				   marca_Id = @marca_Id, 
				   tran_Remolque = @tran_Remolque, 
				   tran_CantCarga = @tran_CantCarga,
				   tran_NumDispositivoSeguridad = @tran_NumDispositivoSeguridad,
				   tran_Equipamiento = @tran_Equipamiento, 
				   tran_TipoCarga = @tran_TipoCarga, 
				   tran_IdContenedor = @tran_IdContenedor, 
				   usua_UsuarioModificacion = @usua_UsuarioModificacion, 
				   tran_FechaModificacion = @duca_FechaModificacion,
				   tran_IdUnidadTransporte = @tran_IdUnidadTransporte,
				   tran_TamanioEquipamiento = @tran_TamanioEquipamiento
			WHERE  tran_Id = @Transporte_Id

			UPDATE Adua.tbConductor
			SET    cont_NoIdentificacion = @cont_NoIdentificacion,
				   cont_Nombre = @cont_Nombre,
				   cont_Apellido = @cont_Apellido,
				   cont_Licencia = @cont_Licencia,
				   pais_IdExpedicion = @pais_IdExpedicion,
				   tran_Id = @Transporte_Id,
				   usua_UsuarioModificacion = @usua_UsuarioModificacion,
				   cont_FechaModificacion = @duca_FechaModificacion
			WHERE  cont_Id = @duca_Conductor_Id

			UPDATE Adua.tbDuca
			   SET duca_Codigo_Declarante = @duca_Codigo_Declarante
				  ,duca_Numero_Id_Declarante = @duca_Numero_Id_Declarante
				  ,duca_NombreSocial_Declarante = @duca_NombreSocial_Declarante
				  ,duca_DomicilioFiscal_Declarante = @duca_DomicilioFiscal_Declarante
				  ,duca_Codigo_Transportista = @duca_Codigo_Transportista 
				  ,motr_id = @motr_Id
				  ,duca_Transportista_Nombre = @duca_Transportista_Nombre
				  ,duca_Conductor_Id = @duca_Conductor_Id
				  ,usua_UsuarioModificacion = @usua_UsuarioModificacion
				  ,duca_FechaModificacion = @duca_FechaModificacion
			 WHERE duca_Id = @duca_Id
		
		COMMIT
		SELECT 1
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_EditarTab3]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar documentos de soprte*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_EditarTab3]
	@doso_Id						INT,
	@tido_Id						INT,
	@doso_NumeroDocumento			NVARCHAR(15),
	@doso_FechaEmision				DATETIME,
	@doso_FechaVencimiento			DATETIME,
	@doso_PaisEmision				INT,
	@doso_LineaAplica				CHAR(4),
	@doso_EntiadEmitioDocumento		NVARCHAR(75),
	@doso_Monto						NVARCHAR(50),
	@usua_UsuarioModificacion		INT,
	@doso_FechaModificacion			DATETIME
AS
BEGIN
    BEGIN TRY
	    UPDATE Adua.tbDocumentosDeSoporte 
		   SET tido_Id						= @tido_Id,
		       doso_NumeroDocumento			= UPPER(@doso_NumeroDocumento),
			   doso_FechaEmision			= @doso_FechaEmision,
			   doso_FechaVencimiento		= @doso_FechaVencimiento,
			   doso_PaisEmision				= @doso_PaisEmision,
			   doso_LineaAplica				= @doso_LineaAplica,
			   doso_EntidadEmitioDocumento	= @doso_EntiadEmitioDocumento,
			   doso_Monto					= @doso_Monto,
			   usua_UsuarioModificacion		= @usua_UsuarioModificacion,
			   doso_FechaModificacion		= @doso_FechaModificacion
		 WHERE doso_Id = @doso_Id

		SELECT 1
    END TRY
    BEGIN CATCH
        SELECT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_InsertarTab1]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar parte 1 de la DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_InsertarTab1]
	@duca_Id							INT,
	@duca_No_Duca						NVARCHAR(100),
	@duca_No_Correlativo_Referencia		NVARCHAR(MAX),
	@duca_AduanaRegistro				INT,
	@duca_AduanaDestino					INT,
	@duca_Regimen_Aduanero				INT,
	@duca_Modalidad						NVARCHAR(MAX),
	@duca_Clase							NVARCHAR(MAX),
	@duca_FechaVencimiento				DATETIME,
	@duca_Pais_Procedencia				INT,
	@duca_Pais_Destino					INT,
	@duca_Deposito_Aduanero				NVARCHAR(MAX),
	@duca_Lugar_Desembarque				NVARCHAR(MAX),
	@duca_Manifiesto					NVARCHAR(150),
	@duca_Titulo						NVARCHAR(150),
	@duca_Ventaja						NVARCHAR(100),
	@usua_UsuarioCreacion				INT,
	@duca_FechaCreacion					DATETIME
AS
BEGIN
	BEGIN TRY
	 UPDATE Adua.tbDuca
		SET duca_No_Duca					 = UPPER(@duca_No_Duca),
			duca_No_Correlativo_Referencia	 = UPPER(@duca_No_Correlativo_Referencia),
			duca_AduanaRegistro				 = @duca_AduanaRegistro,
			duca_AduanaDestino				 = @duca_AduanaDestino,
			duca_Regimen_Aduanero			 = @duca_Regimen_Aduanero,
			duca_Modalidad					 = @duca_Modalidad,
			duca_Clase						 = @duca_Clase,
			duca_FechaVencimiento			 = @duca_FechaVencimiento,
			duca_Pais_Procedencia			 = @duca_Pais_Procedencia,
			duca_Pais_Destino				 = @duca_Pais_Destino,
			duca_Deposito_Aduanero			 = @duca_Deposito_Aduanero,
			duca_Lugar_Desembarque			 = @duca_Lugar_Desembarque,
			duca_Manifiesto					 = UPPER(@duca_Manifiesto),
			duca_Titulo						 = UPPER(@duca_Titulo),
			duca_Ventaja					 = @duca_Ventaja,
			usua_UsuarioCreacion			 = @usua_UsuarioCreacion,
			duca_FechaCreacion				 = @duca_FechaCreacion
	  WHERE duca_Id = @duca_Id	

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_InsertarTab2]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar parte 2 de la DUCA*/
CREATE  	PROCEDURE [Adua].[UDP_tbDuca_InsertarTab2]
	@duca_Id							INT,
	@duca_Codigo_Declarante				NVARCHAR(200),
	@duca_Numero_Id_Declarante			NVARCHAR(200),
	@duca_NombreSocial_Declarante		NVARCHAR(MAX),
	@duca_DomicilioFiscal_Declarante	NVARCHAR(MAX),
	@duca_Codigo_Transportista			NVARCHAR(200),
	@duca_Transportista_Nombre			NVARCHAR(MAX),
	@motr_Id							INT,
	@cont_NoIdentificacion				VARCHAR(50),
	@cont_Licencia						NVARCHAR(200),
	@pais_IdExpedicion					INT,
	@cont_Nombre						NVARCHAR(200),
	@cont_Apellido						NVARCHAR(200),
	@pais_Id							INT,
	@marca_Id							INT,
	@tran_IdUnidadTransporte			VARCHAR(50),
	@tran_Chasis						NVARCHAR(100),
	@tran_Remolque						NVARCHAR(50),
	@tran_CantCarga						INT,
	@tran_NumDispositivoSeguridad		INT,
	@tran_Equipamiento					NVARCHAR(200),
	@tran_TamanioEquipamiento			NVARCHAR(50),
	@tran_TipoCarga						NVARCHAR(200),
	@tran_IdContenedor					NVARCHAR(100),
	@usua_UsuarioCreacion				INT,
	@tran_FechaCreacion					DATETIME
AS	
BEGIN
	BEGIN TRY
		BEGIN TRAN
			SET @tran_FechaCreacion = GETDATE();
			DECLARE @ducaConductor INT = 0

			IF @pais_Id > 0
				BEGIN
					INSERT INTO Adua.tbTransporte (pais_Id, tran_Chasis, marca_Id, tran_Remolque, tran_CantCarga, tran_NumDispositivoSeguridad, tran_Equipamiento, tran_TipoCarga, tran_IdContenedor, usua_UsuarioCreacio, tran_FechaCreacion,tran_IdUnidadTransporte, tran_TamanioEquipamiento)
					VALUES(@pais_Id,UPPER(@tran_Chasis),@marca_Id,@tran_Remolque,@tran_CantCarga,@tran_NumDispositivoSeguridad,@tran_Equipamiento,@tran_TipoCarga,@tran_IdContenedor,@usua_UsuarioCreacion,@tran_FechaCreacion,@tran_IdUnidadTransporte,@tran_TamanioEquipamiento);

					DECLARE @Transporte_Id INT = (SELECT TOP 1 tran_Id FROM Adua.tbTransporte ORDER BY tran_Id DESC);
			
					INSERT INTO Adua.tbConductor (cont_NoIdentificacion, cont_Nombre, cont_Apellido, cont_Licencia, pais_IdExpedicion, tran_Id, usua_UsuarioCreacion, cont_FechaCreacion)
					VALUES(@cont_NoIdentificacion, @cont_Nombre,@cont_Apellido,@cont_Licencia,@pais_IdExpedicion,@Transporte_Id,@usua_UsuarioCreacion,@tran_FechaCreacion);

					SET @ducaConductor = (SELECT TOP 1 cont_Id FROM Adua.tbConductor ORDER BY cont_Id DESC);

					UPDATE Adua.tbDuca
					   SET duca_Codigo_Declarante = @duca_Codigo_Declarante
						  ,duca_Numero_Id_Declarante = @duca_Numero_Id_Declarante
						  ,duca_NombreSocial_Declarante = @duca_NombreSocial_Declarante
						  ,duca_DomicilioFiscal_Declarante = @duca_DomicilioFiscal_Declarante
						  ,duca_Codigo_Transportista = @duca_Codigo_Transportista 
						  ,motr_id = @motr_Id
						  ,duca_Transportista_Nombre = @duca_Transportista_Nombre
						  ,duca_Conductor_Id = @ducaConductor      
					 WHERE duca_Id = @duca_Id
				END
		     ELSE
				BEGIN
					UPDATE Adua.tbDuca
					   SET duca_Codigo_Declarante = @duca_Codigo_Declarante
						  ,duca_Numero_Id_Declarante = @duca_Numero_Id_Declarante
						  ,duca_NombreSocial_Declarante = @duca_NombreSocial_Declarante
						  ,duca_DomicilioFiscal_Declarante = @duca_DomicilioFiscal_Declarante
						  ,duca_Codigo_Transportista = @duca_Codigo_Transportista 
						  ,motr_id = @motr_Id
						  ,duca_Transportista_Nombre = @duca_Transportista_Nombre     
					 WHERE duca_Id = @duca_Id
				END
		COMMIT 
		SELECT @ducaConductor
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT 'Error' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_InsertarTab3]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar documento de soporte*/
CREATE   PROCEDURE  [Adua].[UDP_tbDuca_InsertarTab3]
	@tido_Id					INT,
	@duca_Id					INT,
	@doso_NumeroDocumento		NVARCHAR(15),
	@doso_FechaEmision			DATETIME,
	@doso_FechaVencimiento		DATETIME,
	@doso_PaisEmision			INT,
	@doso_LineaAplica			CHAR(4),
	@doso_EntiadEmitioDocumento	NVARCHAR(75),
	@doso_Monto					NVARCHAR(50),
	@usua_UsuarioCreacion		INT,
	@doso_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbDocumentosDeSoporte (tido_Id, duca_Id, doso_NumeroDocumento, doso_FechaEmision, doso_FechaVencimiento, doso_PaisEmision, doso_LineaAplica, doso_EntidadEmitioDocumento, doso_Monto, usua_UsuarioCreacion, doso_FechaCreacion)
		VALUES(@tido_Id, @duca_Id, UPPER(@doso_NumeroDocumento), @doso_FechaEmision, @doso_FechaVencimiento, @doso_PaisEmision, @doso_LineaAplica, @doso_EntiadEmitioDocumento, @doso_Monto, @usua_UsuarioCreacion, @doso_FechaCreacion);
		
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--**************************************/Documentos de Sanciones***************************************--

--***********************************************DUCA**************************************************--

/*Listar todas las DUCAS*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_Listar]
AS
BEGIN
   SELECT --Identificación de la Declaración parte I
		  duca_Id,
		  duca_No_Duca, 
		  duca_No_Correlativo_Referencia, 
		  
		  --4.1 Exportador / Proveedor
		  duca_Tipo_Iden_Exportador, 
		  tipo.iden_Descripcion					AS 'Tipo_identidad_exportador_descripcion',
		  duca_Pais_Emision_Exportador,
		  paisEE.pais_Nombre					AS 'Nombre_pais_del_exportador', 
		  duca_DomicilioFiscal_Exportador, 
		  
		  --Identificación de la Declaración parte II --
		  duca.duca_AduanaRegistro,
		  adua1.adua_Nombre						AS 'Nombre_Aduana_Registro',			
		  duca.duca_AduanaDestino,
		  adua2.adua_Nombre						AS 'Nombre_Aduana_Destino',
		  
		  --5.1  Iportador / Destinatario
		  duca_Numero_Id_Importador, 
		  duca_Pais_Emision_Importador,
		  paisEI.pais_Nombre					AS 'Nombre_pais_importador',
		  duca_DomicilioFiscal_Importador, 
		  
		  --Identificación de la Declaración parte III
		  duca.duca_Regimen_Aduanero,
		  duca.duca_Modalidad,
		  duca.duca_Clase,
		  duca.duca_FechaVencimiento,
		  
		  --Identificacion de la Declaracion parte IV
		  duca_Pais_Procedencia,
		  paisP.pais_Nombre						AS 'Nombre_pais_procedencia', 
		  duca_Pais_Exportacion,
		  paisE.pais_Nombre						AS 'Nombre_pais_exportacion', 
		  duca_Pais_Destino,
		  paisD.pais_Nombre						AS 'Nombre_pais_destino', 
		  duca_Deposito_Aduanero,
		  duca_Lugar_Desembarque,
		  embarque.emba_Codigo,
		  duca_Manifiesto, 
		  duca_Titulo, 
		  
		  --6.1 Declarante 
		  duca_Codigo_Declarante,
		  duca_Numero_Id_Declarante, 
		  duca_NombreSocial_Declarante,
		  duca_DomicilioFiscal_Declarante, 
		  
		  --19.1 Transportista 		
		  duca_Codigo_Transportista,
		  duca.motr_id, 
		  duca_Transportista_Nombre,
		  
		  --23.1 Conductor 
		  duca_Conductor_Id,
		  cond.cont_NoIdentificacion,
		  cond.cont_Licencia,
		  paisc.pais_Nombre						AS 'Nombre_pais_conductor',
		  cond.cont_Nombre,
		  cond.cont_Apellido,
		  cond.pais_IdExpedicion,		
		  duca_Conductor_Id, 
		  duca_Ventaja,

		  --Identificacion de la Declaracion parte V
		  trns.tran_Id,
		  trns.tran_IdUnidadTransporte,
		  trns.tran_TamanioEquipamiento,
		  trns.pais_Id							AS 'Id_pais_transporte',
		  paist.pais_Nombre						AS 'Nombre_pais_transporte',
		  trns.marca_Id							AS 'Transporte_marca_Id',
		  marc.marc_Descripcion					AS 'Transporte_marc_Descripcion',
		  trns.tran_Chasis,
		  trns.tran_Remolque,
		  trns.tran_CantCarga,
		  trns.tran_NumDispositivoSeguridad,
		  trns.tran_Equipamiento,
		  	  
		  --Tamaño del equipamiento
		  trns.tran_TipoCarga,
		  trns.tran_IdContenedor,	
		  	  
		  --Otros gastos
		  
		  --32.Totales 
		  duca.duca_PesoBrutoTotal,      
		  duca.duca_PesoNetoTotal,
		  
		  --Liquidacion general 
		  --Mercancias
		  duca.usua_UsuarioCreacion,
		  usu1.usua_Nombre, 
		  duca_FechaCreacion, 
		  duca.usua_UsuarioModificacion, 
		  usu2.usua_Nombre,
		  duca_FechaModificacion, 
		  duca_Finalizado,
		  duca_Estado
	 FROM Adua.tbDuca duca 
LEFT JOIN Acce.tbUsuarios				AS usu1		ON duca.usua_UsuarioCreacion = usu1.usua_Id
LEFT JOIN Acce.tbUsuarios				AS usu2		ON duca.usua_UsuarioModificacion = usu2.usua_Id
LEFT JOIN Adua.tbConductor				AS cond		ON duca.duca_Conductor_Id = cond.cont_Id
LEFT JOIN Adua.tbTransporte				AS trns		ON cond.tran_Id = trns.tran_Id 
LEFT JOIN Gral.tbPaises					AS paisc	ON cond.pais_IdExpedicion = paisc.pais_Id 
LEFT JOIN Gral.tbPaises					AS paist	ON paist.pais_Id = trns.pais_Id
LEFT JOIN Adua.tbMarcas					AS marc		ON marc.marc_Id = trns.marca_Id
LEFT JOIN Gral.tbPaises					AS paisD	ON duca.duca_Pais_Destino = paisD.pais_Id
LEFT JOIN Gral.tbPaises					AS paisEE	ON duca.duca_Pais_Emision_Exportador = paisEE.pais_Id
LEFT JOIN Gral.tbPaises					AS paisEI	ON duca.duca_Pais_Emision_Importador = paisEI.pais_Id
LEFT JOIN Gral.tbPaises					AS paisE	ON duca.duca_Pais_Exportacion = paisE.pais_Id
LEFT JOIN Gral.tbPaises					AS paisP	ON duca.duca_Pais_Procedencia = paisP.pais_Id
LEFT JOIN Adua.tbLugaresEmbarque		AS embarque ON duca.duca_Lugar_Desembarque = embarque.emba_Id
LEFT JOIN Adua.tbModoTransporte			AS modoT	ON duca.motr_id = modoT.motr_Id
LEFT JOIN Adua.tbAduanas				AS adua1	ON duca.duca_AduanaRegistro = adua1.adua_Id
LEFT JOIN Adua.tbAduanas				AS adua2	ON duca.duca_AduanaDestino = adua2.adua_Id
LEFT JOIN Adua.tbTiposIdentificacion	AS tipo		ON duca.duca_Tipo_Iden_Exportador = tipo.iden_Id
ORDER BY duca_FechaCreacion DESC
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_Listar_ById]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Duca listar by Id*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_Listar_ById] 
@duca_Id INT 
AS
BEGIN
   SELECT --Identificación de la Declaración parte I
		  duca_Id,
		  duca_No_Duca, 
		  duca_No_Correlativo_Referencia, 
		  
		  --4.1 Exportador / Proveedor
		  duca_Tipo_Iden_Exportador, 
		  tipo.iden_Descripcion					AS 'Tipo_identidad_exportador_descripcion',
		  duca_Pais_Emision_Exportador,
		  paisEE.pais_Nombre					AS 'Nombre_pais_del_exportador', 
		  duca_DomicilioFiscal_Exportador, 
		  
		  --Identificación de la Declaración parte II --
		  duca.duca_AduanaRegistro,
		  adua1.adua_Nombre						AS 'Nombre_Aduana_Registro',			
		  duca.duca_AduanaDestino,
		  adua2.adua_Nombre						AS 'Nombre_Aduana_Destino',
		  
		  --5.1  Iportador / Destinatario
		  duca_Numero_Id_Importador, 
		  duca_Pais_Emision_Importador,
		  paisEI.pais_Nombre					AS 'Nombre_pais_importador',
		  duca_DomicilioFiscal_Importador, 
		  
		  --Identificación de la Declaración parte III
		  duca.duca_Regimen_Aduanero,
		  duca.duca_Modalidad,
		  duca.duca_Clase,
		  duca.duca_FechaVencimiento,
		  
		  --Identificacion de la Declaracion parte IV
		  duca_Pais_Procedencia,
		  paisP.pais_Nombre						AS 'Nombre_pais_procedencia', 
		  duca_Pais_Exportacion,
		  paisE.pais_Nombre						AS 'Nombre_pais_exportacion', 
		  duca_Pais_Destino,
		  paisD.pais_Nombre						AS 'Nombre_pais_destino', 
		  duca_Deposito_Aduanero,
		  duca_Lugar_Desembarque,
		  embarque.emba_Codigo,
		  duca_Manifiesto, 
		  duca_Titulo, 
		  
		  --6.1 Declarante 
		  duca_Codigo_Declarante,
		  duca_Numero_Id_Declarante, 
		  duca_NombreSocial_Declarante,
		  duca_DomicilioFiscal_Declarante, 
		  
		  --19.1 Transportista 		
		  duca_Codigo_Transportista,
		  duca.motr_id, 
		  duca_Transportista_Nombre,
		  
		  --23.1 Conductor 
		  duca_Conductor_Id,
		  cond.cont_NoIdentificacion,
		  cond.cont_Licencia,
		  paisc.pais_Nombre						AS 'Nombre_pais_conductor',
		  cond.cont_Nombre,
		  cond.cont_Apellido,
		  cond.pais_IdExpedicion,		
		  duca_Conductor_Id, 
		  
		  --Identificacion de la Declaracion parte V
		  trns.tran_Id,
		  trns.tran_IdUnidadTransporte,
		  trns.tran_TamanioEquipamiento,
		  trns.pais_Id							AS 'Id_pais_transporte',
		  paist.pais_Nombre						AS 'Nombre_pais_transporte',
		  trns.marca_Id							AS 'Transporte_marca_Id',
		  marc.marc_Descripcion					AS 'Transporte_marc_Descripcion',
		  trns.tran_Chasis,
		  trns.tran_Remolque,
		  trns.tran_CantCarga,
		  trns.tran_NumDispositivoSeguridad,
		  trns.tran_Equipamiento,
		  	  
		  --Tamaño del equipamiento
		  trns.tran_TipoCarga,
		  trns.tran_IdContenedor,	
		  	  
		  --Otros gastos
		  
		  --32.Totales 
		  duca.duca_PesoBrutoTotal,      
		  duca.duca_PesoNetoTotal,
		  
		  --Liquidacion general 
		  --Mercancias
		  duca.usua_UsuarioCreacion,
		  usu1.usua_Nombre, 
		  duca_FechaCreacion, 
		  duca.usua_UsuarioModificacion, 
		  usu2.usua_Nombre,
		  duca_FechaModificacion, 
		  duca_Finalizado,
		  duca_Estado
	 FROM Adua.tbDuca duca 
LEFT JOIN Acce.tbUsuarios				AS usu1		ON duca.usua_UsuarioCreacion = usu1.usua_Id
LEFT JOIN Acce.tbUsuarios				AS usu2		ON duca.usua_UsuarioModificacion = usu2.usua_Id
LEFT JOIN Adua.tbConductor				AS cond		ON duca.duca_Conductor_Id = cond.cont_Id
LEFT JOIN Adua.tbTransporte				AS trns		ON cond.tran_Id = trns.tran_Id 
LEFT JOIN Gral.tbPaises					AS paisc	ON cond.pais_IdExpedicion = paisc.pais_Id 
LEFT JOIN Gral.tbPaises					AS paist	ON paist.pais_Id = trns.pais_Id
LEFT JOIN Adua.tbMarcas					AS marc		ON marc.marc_Id = trns.marca_Id
LEFT JOIN Gral.tbPaises					AS paisD	ON duca.duca_Pais_Destino = paisD.pais_Id
LEFT JOIN Gral.tbPaises					AS paisEE	ON duca.duca_Pais_Emision_Exportador = paisEE.pais_Id
LEFT JOIN Gral.tbPaises					AS paisEI	ON duca.duca_Pais_Emision_Importador = paisEI.pais_Id
LEFT JOIN Gral.tbPaises					AS paisE	ON duca.duca_Pais_Exportacion = paisE.pais_Id
LEFT JOIN Gral.tbPaises					AS paisP	ON duca.duca_Pais_Procedencia = paisP.pais_Id
LEFT JOIN Adua.tbLugaresEmbarque		AS embarque ON duca.duca_Lugar_Desembarque = embarque.emba_Id
LEFT JOIN Adua.tbModoTransporte			AS modoT	ON duca.motr_id = modoT.motr_Id
LEFT JOIN Adua.tbAduanas				AS adua1	ON duca.duca_AduanaRegistro = adua1.adua_Id
LEFT JOIN Adua.tbAduanas				AS adua2	ON duca.duca_AduanaDestino = adua2.adua_Id
LEFT JOIN Adua.tbTiposIdentificacion	AS tipo		ON duca.duca_Tipo_Iden_Exportador = tipo.iden_Id 
WHERE duca.duca_Id = @duca_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDuca_PreInsertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
/*Preinsert DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbDuca_PreInsertar]
AS
BEGIN	
	BEGIN TRY
		INSERT INTO Adua.tbDuca (duca_No_Duca, duca_No_Correlativo_Referencia, duca_AduanaRegistro, duca_AduanaDestino, duca_Regimen_Aduanero, duca_Modalidad,duca_Clase, duca_FechaVencimiento,duca_Pais_Procedencia,duca_Pais_Destino ,duca_Deposito_Aduanero, duca_Lugar_Desembarque,duca_Manifiesto,duca_Titulo, usua_UsuarioCreacion, duca_FechaCreacion)
		VALUES (NULL, NULL, NULL, NULL, NULL, NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL, NULL, NULL)

		SELECT SCOPE_IDENTITY()

	END TRY
	BEGIN CATCH
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbDUCA_PreInsertarListado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--*********************************************************************--
--------------------- PROC DE DUCA INICIAR --------------------------------------
CREATE   PROC [Adua].[UDP_tbDUCA_PreInsertarListado]
AS
BEGIN
    SELECT
        DEVA.deva_Id, 
        ADUAIngreso.adua_Codigo + ' ' + ADUAIngreso.adua_Nombre AS 'adua_IngresoNombre', 
        ADUADespacho.adua_Codigo + ' ' + ADUADespacho.adua_Nombre AS 'adua_DespachoNombre',
        DEVA.deva_FechaAceptacion
    FROM [Adua].[tbDeclaraciones_Valor] DEVA
    INNER JOIN [Adua].[tbAduanas] ADUAIngreso ON DEVA.deva_AduanaIngresoId = ADUAIngreso.adua_Id
    INNER JOIN [Adua].[tbAduanas] ADUADespacho ON DEVA.deva_AduanaDespachoId = ADUADespacho.adua_Id
    LEFT JOIN [Adua].[tbItemsDEVAPorDuca] ITEMSDEVAPorDuca ON DEVA.deva_Id = ITEMSDEVAPorDuca.deva_Id
    WHERE ITEMSDEVAPorDuca.deva_Id IS NULL AND deva_Finalizacion = 1
	; -- Excluir registros que existen en la otra tabla
END

--------------------- PROC DE DUCA FINALIZAR --------------------------------------
--*********************************************************************--

-------****************** FILTRADO  DE DATOS ***************----------


/*------------ PROVINCIAS POR PAIS --------------*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoBoletin_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Estado boletin*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoBoletin_Editar]
@esbo_Id					INT,
@esbo_Descripcion			NVARCHAR(200),
@usua_UsuarioModificacion	INT,
@esbo_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Adua.tbEstadoBoletin
		SET esbo_Descripcion = @esbo_Descripcion,
		usua_UsuarioModificacion = @usua_UsuarioModificacion,
		esbo_FechaModificacion = @esbo_FechaModificacion
		WHERE esbo_Id = @esbo_Id
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoBoletin_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Estado boletin*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoBoletin_Insertar]
@esbo_Descripcion		NVARCHAR(200),
@usua_UsuarioCreacion	INT,
@esbo_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
			INSERT INTO Adua.tbEstadoBoletin(esbo_Descripcion,usua_UsuarioCreacion,esbo_FechaCreacion)
			VALUES (
			@esbo_Descripcion,		
			@usua_UsuarioCreacion,	
			@esbo_FechaCreacion					
			)
			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoBoletin_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************ESTADO BOLETIN******************--
/*Listar Estado boletin*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoBoletin_Listar]
AS
BEGIN
SELECT	esbo_Id								,
		esbo_Descripcion					, 
		crea.usua_Nombre					AS usua_NombreCreacion,
		esbo_FechaCreacion					,
		modi.usua_Nombre					AS usua_NombreModificacion,
		esbo_FechaModificacion				,
		esbo_Estadoo 						
FROM	Adua.tbEstadoBoletin esbo 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = esbo.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = esbo.usua_UsuarioModificacion 
WHERE	esbo_Estadoo = 1
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoMercancias_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar ESTADO MERCANCIAS*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoMercancias_Editar]
(
	@merc_Id					INT,
	@merc_Codigo				CHAR(2),
	@merc_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@merc_FechaModificacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		   UPDATE Adua.tbEstadoMercancias
			  SET	merc_Codigo = @merc_Codigo,
					merc_Descripcion = @merc_Descripcion,
					usua_UsuarioModificacion = @usua_UsuarioModificacion,
					merc_FechaModificacion = @merc_FechaModificacion
			WHERE	merc_Id = @merc_Id 
			  AND	merc_Estado = 1

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoMercancias_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar ESTADO MERCANCIAS*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoMercancias_Eliminar]
(
	@merc_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@merc_FechaEliminacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'merc_Id', @merc_Id, 'Adua.tbEstadoMercancias', @respuesta OUTPUT

		IF(@respuesta = 1)
			BEGIN
				 UPDATE Adua.tbEstadoMercancias
					SET merc_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						merc_FechaEliminacion = @merc_FechaEliminacion
				  WHERE merc_Id = @merc_Id 
					AND merc_Estado = 1
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbEstadoMercancias_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar ESTADO MERCANCIAS*/
CREATE   PROCEDURE [Adua].[UDP_tbEstadoMercancias_Insertar]
(
	@merc_Codigo			CHAR(2),
	@merc_Descripcion		NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@merc_FechaCreacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * 
					 FROM Adua.tbEstadoMercancias 
					WHERE merc_Descripcion = @merc_Descripcion 
					  AND merc_Estado = 0)
		BEGIN 			
			UPDATE Adua.tbEstadoMercancias
			   SET merc_Estado = 1
			 WHERE merc_Descripcion = @merc_Descripcion 
		END
		ELSE
		BEGIN
			INSERT INTO Adua.tbEstadoMercancias (merc_Codigo ,merc_Descripcion, usua_UsuarioCreacion, merc_FechaCreacion)
			VALUES (@merc_Codigo ,@merc_Descripcion, @usua_UsuarioCreacion, @merc_FechaCreacion)
		END

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFacturas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [Adua].[UDP_tbFacturas_Editar]
	@fact_Id					INT, 
	@fact_Numero				NVARCHAR(4000),
	@deva_Id					INT,
	@fact_Fecha					DATE, 
	@usua_UsuarioModificacion	INT, 
	@fact_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

	IF NOT EXISTS(SELECT fact_Id FROM Adua.tbFacturas WHERE fact_Id = @fact_Id AND fact_Numero = @fact_Numero)
		BEGIN
			UPDATE Adua.tbFacturas
			SET   deva_Id = @deva_Id, 
				  fact_Numero = @fact_Numero,
				  fact_Fecha = @fact_Fecha, 
				  usua_UsuarioModificacion = @usua_UsuarioModificacion, 
				  fact_FechaModificacion = @fact_FechaModificacion
			WHERE fact_Id = @fact_Id


			INSERT INTO Adua.tbFacturasHistorial(fact_Id, 
													 fact_Numero,
													 deva_Id, 
													 fect_Fecha, 
													 hfact_UsuarioAccion, 
													 hfact_FechaAccion, 
													 hfact_Accion)
			VALUES (@fact_Id,
					@fact_Numero,
					@deva_Id, 
					@fact_Fecha, 
					@usua_UsuarioModificacion, 
					@fact_FechaModificacion,
					'Editar')
			
			SELECT 1
		END
	ELSE
		BEGIN
			SELECT 2
		END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFacturas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE     PROCEDURE [Adua].[UDP_tbFacturas_Eliminar]
	@fact_Id			INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY

			DELETE FROM Adua.tbItems
			WHERE fact_Id = @fact_Id

			DELETE FROM Adua.tbFacturas
			WHERE fact_Id = @fact_Id

			SELECT 1

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END


GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFacturas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbFacturas_Insertar]
	@deva_Id					INT,
	@fact_Numero				NVARCHAR(4000),
	@fact_Fecha					DATE, 
	@usua_UsuarioCreacion		INT, 
	@fact_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO Adua.tbFacturas(deva_Id, 
										fact_Numero,
										fact_Fecha, 
										usua_UsuarioCreacion, 
										fact_FechaCreacion)
		VALUES(@deva_Id, 
			   @fact_Numero,
			   @fact_Fecha, 
			   @usua_UsuarioCreacion, 
			   @fact_FechaCreacion)

		SELECT SCOPE_IDENTITY()


		INSERT INTO Adua.tbFacturasHistorial(fact_Id, 
												 fact_Numero,
												 deva_Id, 
												 fect_Fecha, 
												 hfact_UsuarioAccion, 
												 hfact_FechaAccion, 
												 hfact_Accion)
		VALUES (SCOPE_IDENTITY(),
				@fact_Numero,
				@deva_Id, 
			    @fact_Fecha, 
			    @usua_UsuarioCreacion, 
			    @fact_FechaCreacion,
				'Insertar')

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFacturas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbFacturas_Listar] 
	@deva_Id				INT
AS
BEGIN
	SELECT fact_Id, 
		   deva_Id,
		   fact_Numero,
		   fact_Fecha, 
		   fact.usua_UsuarioCreacion, 
		   usuaCrea.usua_Nombre					AS usuarioCreacionNombre,
		   fact_FechaCreacion, 
		   fact.usua_UsuarioModificacion, 
		   usuaModifica.usua_Nombre				AS usuarioModificacionNombre,
		   fact_FechaModificacion, 
		   fact_Estado
	FROM Adua.tbFacturas fact 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON fact.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica  ON fact.usua_UsuarioModificacion = usuaModifica.usua_Id
	WHERE deva_Id = @deva_Id
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFacturas_VerificarFacturas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbFacturas_VerificarFacturas]
	@fact_Numero	NVARCHAR(500)
AS
BEGIN	
	BEGIN TRY
		IF EXISTS (SELECT fact_Id FROM Adua.tbFacturas WHERE fact_Numero = @fact_Numero)
			BEGIN 
				SELECT 1
			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY
	BEGIN CATCH
		SELECT -2
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFormadePago_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************** Formas de pago*****************************************/

CREATE   PROCEDURE [Adua].[UDP_tbFormadePago_Listar]
AS
BEGIN 
SELECT	fopa_Id							,
        fopa_Descripcion				,
		usu.usua_Nombre					AS usua_NombreCreacion,
		fopa_FechaCreacion				,
		usu1.usua_Nombre				AS usua_NombreModificacion,
		fopa_FechaModificacion			,
		fopa_Estado						
FROM	Adua.tbFormasdePago form 
		INNER JOIN Acce.tbUsuarios usu	ON usu.usua_Id = form.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios usu1	ON usu1.usua_Id = form.usua_UsuarioModificacion   
WHERE	fopa_Estado = 1
END




/**************Crear Formas de pago**********************/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFormasdePago_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/********************Editar Formas de pago************************/
CREATE   PROCEDURE [Adua].[UDP_tbFormasdePago_Editar] 
   @fopa_id    INT,
   @fopa_Descripcion  NVARCHAR(350),  
   @usua_UsuarioModificacion INT, 
   @fopa_FechaModificacion  DATETIME
AS
BEGIN 
      BEGIN TRY 
	  
	      UPDATE Adua.tbFormasdePago
		  SET fopa_Descripcion = @fopa_Descripcion, 
		      usua_UsuarioModificacion = @usua_UsuarioModificacion,
			  fopa_FechaModificacion = @fopa_FechaModificacion
		  WHERE fopa_Id = @fopa_id
		  SELECT 1
	   END TRY 
	   BEGIN CATCH 
		SELECT 'Error Messagee: ' + ERROR_MESSAGE()
	   END CATCH
END 

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFormasdePago_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************Eliminar Formas de pago*******************/
CREATE   PROCEDURE [Adua].[UDP_tbFormasdePago_Eliminar] 
	@fopa_id					INT,
	@usua_UsuarioEliminacion	INT,
	@fopa_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'fopa_id', @fopa_id, 'Adua.tbFormasdePago', @respuesta OUTPUT

			IF(@respuesta) = 1
				BEGIN
					UPDATE Adua.tbFormasdePago
					SET fopa_Estado = 0,
					    usua_UsuarioEliminacion=@usua_UsuarioEliminacion,
						fopa_FechaEliminacion=@fopa_FechaEliminacion
					WHERE fopa_Id = @fopa_id
				END

			SELECT @respuesta AS Resultado
		END
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbFormasdePago_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbFormasdePago_Insertar] 
   @fopa_Descripcion        NVARCHAR(MAX), 
   @usua_UsuarioCreacion    INT, 
   @fopa_FechaCreacion      DATETIME
AS
BEGIN
     BEGIN TRY 
	 
	    IF EXISTS(SELECT * FROM Adua.tbFormasdePago WHERE fopa_Descripcion=@fopa_Descripcion 
		 AND fopa_Estado = 0)	 
		 BEGIN 
		    UPDATE Adua.tbFormasdePago
			SET fopa_Estado = 1
			WHERE fopa_Descripcion=@fopa_Descripcion
		 END
		ELSE 
		 BEGIN
		    INSERT INTO Adua.tbFormasdePago 
			( fopa_Descripcion, 
			  usua_UsuarioCreacion, 
			  fopa_FechaCreacion  
	 		)
		    VALUES(
	          @fopa_Descripcion ,
			  @usua_UsuarioCreacion,
			  @fopa_FechaCreacion  
			)
         END
		 SELECT 1
	END TRY 
	BEGIN CATCH
	   SELECT 0	
	END CATCH    
END


GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImportadores_ById]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Importadores ById*/
CREATE   PROCEDURE [Adua].[UDP_tbImportadores_ById]
@impo_Id INT
AS
BEGIN
	
		SELECT [impo_Id], 
		   [nico_Id], 
		   [decl_Id], 
		   [impo_NivelComercial_Otro], 
		   [impo_RTN], 
		   [impo_NumRegistro], 
		   [usua_UsuarioCreacion], 
		   [impo_FechaCreacion], 
		   [usua_UsuarioModificacion], 
		   [impo_FechaModificacion], 
		   [usua_UsuarioEliminacion], 
		   [impo_FechaEliminacion], 
		   [impo_Estado]
	FROM [Adua].[tbImportadores]
	WHERE impo_Id = @impo_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImportadores_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
/*Importadores*/
CREATE   PROCEDURE [Adua].[UDP_tbImportadores_Listar]
AS
BEGIN	
	SELECT [impo_Id], 
		   [nico_Id], 
		   [decl_Id], 
		   [impo_NivelComercial_Otro], 
		   [impo_RTN], 
		   [impo_NumRegistro], 
		   [usua_UsuarioCreacion], 
		   [impo_FechaCreacion], 
		   [usua_UsuarioModificacion], 
		   [impo_FechaModificacion], 
		   [usua_UsuarioEliminacion], 
		   [impo_FechaEliminacion], 
		   [impo_Estado]
	FROM [Adua].[tbImportadores]
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EDITAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestos_Editar] 
    @impu_Id                    INT,
	@impu_Descripcion           NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@impu_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Adua.tbImpuestos
		SET		
		        impu_Descripcion = @impu_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				impu_FechaModificacion = @impu_FechaModificacion
		WHERE	impu_Id = @impu_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
--INSERTAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestos_Insertar] 
	@impu_Descripcion       NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@impu_FechaCreacion     DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT impu_Id FROM Adua.tbImpuestos WHERE impu_Descripcion = @impu_Descripcion AND impu_Estado = 0)
			BEGIN
				UPDATE Adua.tbImpuestos
				SET	   impu_Estado = 1
				WHERE  impu_Descripcion = @impu_Descripcion
				SELECT 1
			END
		ELSE
			BEGIN 
				INSERT INTO Adua.tbImpuestos (
				                                  impu_Descripcion,
											      usua_UsuarioCreacion, 
											      impu_FechaCreacion)
			VALUES(
			       @impu_Descripcion,
				   @usua_UsuarioCreacion,
				   @impu_FechaCreacion)
				SELECT 1
			END
	END TRY
	BEGIN CATCH
				SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--******************* UDPS tbImpuestos ***************************
--LISTAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestos_Listar]
AS
BEGIN
	SELECT	impu.impu_Id          ,--AS IdImpuesto,
		    impu.impu_Descripcion ,--AS DescripcionImpuesto,
		   		
			impu.usua_UsuarioCreacion,
			usu.usua_Nombre         AS UsuarioCreacion ,
			impu_FechaCreacion      ,--AS FechaCreacion,

			impu.usua_UsuarioModificacion,
			usu1.usua_Nombre        AS UsuarioModificacion,
			impu_FechaModificacion  --AS FechaModificacion
 
  FROM	    Adua.tbImpuestos impu
			INNER JOIN Acce.tbUsuarios usu ON usu.usua_Id = impu.usua_UsuarioCreacion 
			LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = impu.usua_UsuarioModificacion
			WHERE impu.impu_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestosPorArancel_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EDITAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestosPorArancel_Editar] 
    @imar_Id                    INT,
	@impu_Id     		        INT,
	@aran_Id                    INT,
	@imar_PorcentajeImpuesto	DECIMAL(08,2),
	@usua_UsuarioModificacion	INT,
	@imar_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Adua.tbImpuestosPorArancel
		SET		impu_Id = @impu_Id,
		        aran_Id = @aran_Id,
				imar_PorcentajeImpuesto = @imar_PorcentajeImpuesto,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				imar_FechaModificacion = @imar_FechaModificacion
		WHERE	imar_Id = @imar_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestosPorArancel_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbImpuestosPorArancel_Eliminar]
@imar_Id INT
AS
BEGIN
	DELETE FROM Adua.tbImpuestosPorArancel 
	WHERE imar_Id = @imar_Id
SELECT 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestosPorArancel_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	
--INSERTAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestosPorArancel_Insertar] 
	@impu_Id     				INT,
	@imar_PorcentajeImpuesto	DECIMAL(18,2),
	@usua_UsuarioCreacion		INT,
	@imar_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRY
	DECLARE @aran_Id INT 
	SELECT TOP 1 @aran_Id = aran_ID FROM Adua.tbAranceles ORDER BY aran_ID desc
			INSERT INTO Adua.tbImpuestosPorArancel (impu_Id, 
				                                        aran_Id,
														imar_PorcentajeImpuesto,
											            usua_UsuarioCreacion, 
											            imar_FechaCreacion)
		VALUES(@impu_Id,	
			    @aran_Id,
				@imar_PorcentajeImpuesto,			
				@usua_UsuarioCreacion,
				@imar_FechaCreacion)
			SELECT 1
	END TRY
	BEGIN CATCH
				SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestosPorArancel_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ********************  UDPS Impuesto por Arancel ********************

--LISTAR
CREATE   PROCEDURE [Adua].[UDP_tbImpuestosPorArancel_Listar]
AS
BEGIN
	SELECT	imar.imar_Id				 AS IdImpuestoPorArancel,
		    impu.impu_Id				 AS ArancelCodigo,
		    aran.aran_Id				 AS DescripcionImpuesto,
		   	imar.imar_PorcentajeImpuesto AS CantidadPorPorcentajeImpuesto,	
			usu.usua_Id					 AS IDUsuarioCreacion,
			usu.usua_Nombre				 AS UsuarioCreacion ,
			impu_FechaCreacion			 AS FechaCreacion,
										 
			usu1.usua_Id				 AS IDUsuarioModificacion,
			usu1.usua_Nombre			 AS UsuarioModificacion,
			impu_FechaModificacion		 AS FechaModificacion
 
  FROM	    Adua.tbImpuestosPorArancel imar
            INNER JOIN Adua.tbImpuestos impu ON imar.impu_Id = impu.impu_Id
			INNER JOIN Acce.tbUsuarios usu ON usu.usua_Id = impu.usua_UsuarioCreacion 
			LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_UsuarioModificacion = impu.usua_UsuarioModificacion
			INNER JOIN Adua.tbAranceles aran ON imar.aran_Id = aran.aran_Id 
			WHERE imar.imar_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbImpuestosPorArancel_ListarPorArancel]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbImpuestosPorArancel_ListarPorArancel]
@aran_Id INT 
AS
BEGIN
SELECT	imar.imar_Id				 AS IdImpuestoPorArancel,
		    impu.impu_Id				 AS ArancelCodigo,
		    aran.aran_Id				 AS DescripcionImpuesto,
		   	imar.imar_PorcentajeImpuesto AS CantidadPorPorcentajeImpuesto,	
			usu.usua_Id					 AS IDUsuarioCreacion,
			usu.usua_Nombre				 AS UsuarioCreacion ,
			impu_FechaCreacion			 AS FechaCreacion,
										 
			usu1.usua_Id				 AS IDUsuarioModificacion,
			usu1.usua_Nombre			 AS UsuarioModificacion,
			impu_FechaModificacion		 AS FechaModificacion
 
  FROM	    Adua.tbImpuestosPorArancel imar
            INNER JOIN Adua.tbImpuestos impu ON imar.impu_Id = impu.impu_Id
			INNER JOIN Acce.tbUsuarios usu ON usu.usua_Id = impu.usua_UsuarioCreacion 
			LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id = impu.usua_UsuarioModificacion
			INNER JOIN Adua.tbAranceles aran ON imar.aran_Id = aran.aran_Id 
			WHERE imar.imar_Estado = 1 AND imar.aran_Id = @aran_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbIncoterm_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar incoterm*/
CREATE   PROCEDURE [Adua].[UDP_tbIncoterm_Editar]
	@inco_Id					INT,
	@inco_Codigo				CHAR(3),
	@inco_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@inco_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Adua.tbIncoterm
		SET		inco_Descripcion = @inco_Descripcion,
		        inco_Codigo = @inco_Codigo,
 				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				inco_FechaModificacion = @inco_FechaModificacion
		WHERE	inco_Id = @inco_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbIncoterm_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar incoterm*/
CREATE   PROCEDURE [Adua].[UDP_tbIncoterm_Insertar] 
	@inco_Codigo			CHAR(3),
	@inco_Descripcion		NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@inco_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
				INSERT INTO Adua.tbIncoterm (inco_Codigo,
												 inco_Descripcion, 
											     usua_UsuarioCreacion, 
											     inco_FechaCreacion)
			VALUES(@inco_Codigo,
				   @inco_Descripcion,	
				   @usua_UsuarioCreacion,
				   @inco_FechaCreacion)


			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbIncoterm_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************INCOTERM******************--
/*Listar incoterm*/
CREATE   PROCEDURE [Adua].[UDP_tbIncoterm_Listar]
AS
BEGIN
	SELECT inco_Id								
		   ,inco_Codigo							
		   ,inco_Descripcion					
		   ,inco.usua_UsuarioCreacion			
		   ,usuaCrea.usua_Nombre				AS usuarioCreacionNombre
		   ,inco_FechaCreacion					
		   ,inco.usua_UsuarioModificacion		
		   ,usuaModifica.usua_Nombre			AS usuarioModificacionNombre
		   ,inco_FechaModificacion				
		   ,inco_Estado							
	FROM Adua.tbIncoterm inco 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON inco.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica	ON inco.usua_UsuarioModificacion = usuaCrea.usua_Id 
	WHERE inco_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItems_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbItems_Editar]
	@item_Id									INT,
	@fact_Id									INT, 
	@item_Cantidad								INT, 
	@item_PesoNeto								DECIMAL(18,2), 
	@item_PesoBruto								DECIMAL(18,2), 
	@unme_Id									INT, 
	@item_IdentificacionComercialMercancias		NVARCHAR(300), 
	@item_CaracteristicasMercancias				NVARCHAR(400), 
	@item_Marca									NVARCHAR(50), 
	@item_Modelo								NVARCHAR(100), 
	@merc_Id									INT, 
	@pais_IdOrigenMercancia						INT, 
	@item_ClasificacionArancelaria				CHAR(16), 
	@item_ValorUnitario							DECIMAL(18,2), 
	@item_GastosDeTransporte					DECIMAL(18,2), 
	@item_ValorTransaccion						DECIMAL(18,2), 
	@item_Seguro								DECIMAL(18,2), 
	@item_OtrosGastos							DECIMAL(18,2), 
	@item_ValorAduana							DECIMAL(18,2), 
	@item_CuotaContingente						DECIMAL(18,2), 
	@item_ReglasAccesorias						NVARCHAR(MAX), 
	@item_CriterioCertificarOrigen				NVARCHAR(MAX), 
	@usua_UsuarioModificacion					INT, 
	@item_FechaModificacion						DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		
		UPDATE Adua.tbItems
		SET item_Cantidad = @item_Cantidad, 
			item_PesoNeto = @item_PesoNeto, 
			item_PesoBruto = @item_PesoBruto, 
			unme_Id = @unme_Id, 
			item_IdentificacionComercialMercancias = @item_IdentificacionComercialMercancias, 
			item_CaracteristicasMercancias = @item_CaracteristicasMercancias, 
			item_Marca = @item_Marca, 
			item_Modelo = @item_Modelo, 
			merc_Id = @merc_Id, 
			pais_IdOrigenMercancia = @pais_IdOrigenMercancia, 
			item_ClasificacionArancelaria = @item_ClasificacionArancelaria, 
			item_ValorUnitario = @item_ValorUnitario, 
			item_GastosDeTransporte = @item_GastosDeTransporte, 
			item_ValorTransaccion = @item_ValorTransaccion, 
			item_Seguro = @item_Seguro, 
			item_OtrosGastos = @item_OtrosGastos, 
			item_ValorAduana = @item_ValorAduana, 
			item_CuotaContingente = @item_CuotaContingente, 
			item_ReglasAccesorias = @item_ReglasAccesorias, 
			item_CriterioCertificarOrigen = @item_CriterioCertificarOrigen, 
			usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			item_FechaModificacion = @item_FechaModificacion
		WHERE item_Id = @item_Id

		INSERT INTO Adua.tbItemsHistorial(item_Id,
											  item_Cantidad, 
											  item_PesoNeto, 
											  item_PesoBruto, 
											  unme_Id, 
											  item_IdentificacionComercialMercancias, 
											  item_CaracteristicasMercancias, 
											  item_Marca, 
											  item_Modelo, 
											  merc_Id, 
											  pais_IdOrigenMercancia, 
											  item_ClasificacionArancelaria, 
											  item_ValorUnitario, 
											  item_GastosDeTransporte, 
											  item_ValorTransaccion, 
											  item_Seguro, 
											  item_OtrosGastos, 
											  item_ValorAduana, 
											  item_CuotaContingente, 
											  item_ReglasAccesorias, 
											  item_CriterioCertificarOrigen, 
											  hduc_UsuarioAccion, 
											  hduc_FechaAccion, 
											  hduc_Accion)

			VALUES (@item_Id, 
					@item_Cantidad, 
					@item_PesoNeto, 
					@item_PesoBruto, 
					@unme_Id, 
					@item_IdentificacionComercialMercancias, 
					@item_CaracteristicasMercancias, 
					@item_Marca, 
					@item_Modelo, 
					@merc_Id, 
					@pais_IdOrigenMercancia, 
					@item_ClasificacionArancelaria, 
					@item_ValorUnitario, 
					@item_GastosDeTransporte, 
					@item_ValorTransaccion, 
					@item_Seguro, 
					@item_OtrosGastos, 
					@item_ValorAduana, 
					@item_CuotaContingente, 
					@item_ReglasAccesorias, 
					@item_CriterioCertificarOrigen,
					@usua_UsuarioModificacion, 
					@item_FechaModificacion,
					'Editar')

		SELECT 1

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItems_EditarItemDuca]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbItems_EditarItemDuca]
	@item_Id									INT,
	@item_Cantidad_Bultos						INT,
	@item_ClaseBulto							NVARCHAR(100),
	@item_Acuerdo								NVARCHAR(100),
	@item_PesoNeto								DECIMAL(18,2), 
	@item_PesoBruto								DECIMAL(18,2),  
	@item_GastosDeTransporte					DECIMAL(18,2), 
	@item_Seguro								DECIMAL(18,2), 
	@item_OtrosGastos							DECIMAL(18,2),
	@item_CuotaContingente						DECIMAL(18,2), 
	@item_ReglasAccesorias						NVARCHAR(MAX), 
	@item_CriterioCertificarOrigen				NVARCHAR(MAX), 
	@usua_UsuarioModificacion					INT, 
	@item_FechaModificacion						DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		
		UPDATE Adua.tbItems
		SET item_Acuerdo = @item_Acuerdo,
			item_ClaseBulto = @item_ClaseBulto,
			item_Cantidad_Bultos = @item_Cantidad_Bultos,
			item_PesoNeto = @item_PesoNeto, 
			item_PesoBruto = @item_PesoBruto, 		
			item_GastosDeTransporte = @item_GastosDeTransporte, 
			item_Seguro = @item_Seguro, 
			item_OtrosGastos = @item_OtrosGastos, 
			item_CuotaContingente = @item_CuotaContingente, 
			item_ReglasAccesorias = @item_ReglasAccesorias, 
			item_CriterioCertificarOrigen = @item_CriterioCertificarOrigen, 
			usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			item_FechaModificacion = @item_FechaModificacion
		WHERE item_Id = @item_Id

		
		SELECT 1

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItems_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [Adua].[UDP_tbItems_Eliminar]
	@item_Id					INT,
	@item_FechaEliminacion		DATETIME,
	@usua_UsuarioEliminacion	INT
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	DECLARE @respuesta INT
	EXEC dbo.UDP_ValidarReferencias 'item_Id', @item_Id,'Adua.tbItems',@respuesta OUTPUT

	SELECT @respuesta AS Resultado
	IF(@respuesta = 1)
		BEGIN
			
		INSERT INTO Adua.tbItemsHistorial(item_Id, 
											  fact_Id, 
											  item_Cantidad, 
											  item_PesoNeto, 
											  item_PesoBruto, 
											  unme_Id, 
											  item_IdentificacionComercialMercancias, 
											  item_CaracteristicasMercancias, 
											  item_Marca, 
											  item_Modelo, 
											  merc_Id, 
											  pais_IdOrigenMercancia, 
											  item_ClasificacionArancelaria, 
											  item_ValorUnitario, 
											  item_GastosDeTransporte, 
											  item_ValorTransaccion, 
											  item_Seguro, 
											  item_OtrosGastos, 
											  item_ValorAduana, 
											  item_CuotaContingente, 
											  item_ReglasAccesorias, 
											  item_CriterioCertificarOrigen, 
											  hduc_UsuarioAccion, 
											  hduc_FechaAccion, 
											  hduc_Accion)
		SELECT item_Id, 
			   fact_Id, 
			   item_Cantidad, 
			   item_PesoNeto, 
			   item_PesoBruto, 
			   unme_Id, 
			   item_IdentificacionComercialMercancias, 
			   item_CaracteristicasMercancias, 
			   item_Marca, 
			   item_Modelo, 
			   merc_Id, 
			   pais_IdOrigenMercancia, 
			   item_ClasificacionArancelaria, 
			   item_ValorUnitario, 
			   item_GastosDeTransporte, 
			   item_ValorTransaccion, 
			   item_Seguro, 
			   item_OtrosGastos, 
			   item_ValorAduana, 
			   item_CuotaContingente, 
			   item_ReglasAccesorias, 
			   item_CriterioCertificarOrigen, 
			   @usua_UsuarioEliminacion,
			   @item_FechaEliminacion,
			   'Eliminar'
				FROM Adua.tbItems
				WHERE item_Id = @item_Id

			DELETE FROM Adua.tbItems
			WHERE item_Id = @item_Id

			SELECT 1
		END
		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
		ROLLBACK TRAN
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItems_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbItems_Insertar]
	@fact_Id									INT, 
	@item_Cantidad								INT, 
	@item_PesoNeto								DECIMAL(18,2), 
	@item_PesoBruto								DECIMAL(18,2), 
	@unme_Id									INT, 
	@item_IdentificacionComercialMercancias		NVARCHAR(300), 
	@item_CaracteristicasMercancias				NVARCHAR(400), 
	@item_Marca									NVARCHAR(50), 
	@item_Modelo								NVARCHAR(100), 
	@merc_Id									INT, 
	@pais_IdOrigenMercancia						INT, 
	@item_ClasificacionArancelaria				CHAR(16), 
	@item_ValorUnitario							DECIMAL(18,2), 
	@item_GastosDeTransporte					DECIMAL(18,2), 
	@item_ValorTransaccion						DECIMAL(18,2), 
	@item_Seguro								DECIMAL(18,2), 
	@item_OtrosGastos							DECIMAL(18,2), 
	@item_ValorAduana							DECIMAL(18,2), 
	@item_CuotaContingente						DECIMAL(18,2), 
	@item_ReglasAccesorias						NVARCHAR(MAX), 
	@item_CriterioCertificarOrigen				NVARCHAR(MAX), 
	@usua_UsuarioCreacion						INT, 
	@item_FechaCreacion							DATETIME
AS
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO Adua.tbItems(fact_Id, 
									 item_Cantidad, 
									 item_PesoNeto, 
									 item_PesoBruto, 
									 unme_Id, 
									 item_IdentificacionComercialMercancias, 
									 item_CaracteristicasMercancias, 
									 item_Marca, 
									 item_Modelo, 
									 merc_Id, 
									 pais_IdOrigenMercancia, 
									 item_ClasificacionArancelaria, 
									 item_ValorUnitario, 
									 item_GastosDeTransporte, 
									 item_ValorTransaccion, 
									 item_Seguro, 
									 item_OtrosGastos, 
									 item_ValorAduana, 
									 item_CuotaContingente, 
									 item_ReglasAccesorias, 
									 item_CriterioCertificarOrigen, 
									 usua_UsuarioCreacion, 
									 item_FechaCreacion)
		VALUES (@fact_Id, 
				@item_Cantidad, 
				@item_PesoNeto, 
				@item_PesoBruto, 
				@unme_Id, 
				@item_IdentificacionComercialMercancias, 
				@item_CaracteristicasMercancias, 
				@item_Marca, 
				@item_Modelo, 
				@merc_Id, 
				@pais_IdOrigenMercancia, 
				@item_ClasificacionArancelaria, 
				@item_ValorUnitario, 
				@item_GastosDeTransporte, 
				@item_ValorTransaccion, 
				@item_Seguro, 
				@item_OtrosGastos, 
				@item_ValorAduana, 
				@item_CuotaContingente, 
				@item_ReglasAccesorias, 
				@item_CriterioCertificarOrigen, 
				@usua_UsuarioCreacion, 
				@item_FechaCreacion)

		DECLARE @item_Id INT = SCOPE_IDENTITY()

		INSERT INTO Adua.tbItemsHistorial(item_Id, 
											  fact_Id, 
											  item_Cantidad, 
											  item_PesoNeto, 
											  item_PesoBruto, 
											  unme_Id, 
											  item_IdentificacionComercialMercancias, 
											  item_CaracteristicasMercancias, 
											  item_Marca, 
											  item_Modelo, 
											  merc_Id, 
											  pais_IdOrigenMercancia, 
											  item_ClasificacionArancelaria, 
											  item_ValorUnitario, 
											  item_GastosDeTransporte, 
											  item_ValorTransaccion, 
											  item_Seguro, 
											  item_OtrosGastos, 
											  item_ValorAduana, 
											  item_CuotaContingente, 
											  item_ReglasAccesorias, 
											  item_CriterioCertificarOrigen, 
											  hduc_UsuarioAccion, 
											  hduc_FechaAccion, 
											  hduc_Accion)

			VALUES (@item_Id, 
					@fact_Id, 
					@item_Cantidad, 
					@item_PesoNeto, 
					@item_PesoBruto, 
					@unme_Id, 
					@item_IdentificacionComercialMercancias, 
					@item_CaracteristicasMercancias, 
					@item_Marca, 
					@item_Modelo, 
					@merc_Id, 
					@pais_IdOrigenMercancia, 
					@item_ClasificacionArancelaria, 
					@item_ValorUnitario, 
					@item_GastosDeTransporte, 
					@item_ValorTransaccion, 
					@item_Seguro, 
					@item_OtrosGastos, 
					@item_ValorAduana, 
					@item_CuotaContingente, 
					@item_ReglasAccesorias, 
					@item_CriterioCertificarOrigen,
					@usua_UsuarioCreacion, 
					@item_FechaCreacion,
					'Insertar')

		SELECT 1

		COMMIT TRAN
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItems_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* LISTAR items*/
CREATE   PROCEDURE [Adua].[UDP_tbItems_Listar] 
	@fact_Id				INT
AS
BEGIN
	SELECT item_Id, 
	       fact_Id, 
		   item_Cantidad, 
		   item_PesoNeto, 
		   item_PesoBruto, 
		   unme_Id, 
		   item_IdentificacionComercialMercancias, 
		   item_CaracteristicasMercancias, 
		   item_Marca, 
		   item_Modelo, 
		   merc_Id, 
		   pais_IdOrigenMercancia, 
		   item_ClasificacionArancelaria, 
		   item_ValorUnitario, 
		   item_GastosDeTransporte, 
		   item_ValorTransaccion, 
		   item_Seguro, 
		   item_OtrosGastos, 
		   item_ValorAduana, 
		   item_CuotaContingente, 
		   item_ReglasAccesorias, 
		   item_CriterioCertificarOrigen,
		   item.usua_UsuarioCreacion, 
		   usuaCrea.usua_Nombre					AS usuarioCreacionNombre,
		   item_FechaCreacion, 
		   item.usua_UsuarioModificacion, 
		   usuaModifica.usua_Nombre				AS usuarioModificacionNombre,
		   item_FechaModificacion, 
		   item_Estado
	FROM Adua.tbItems item 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON item.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica  ON item.usua_UsuarioModificacion = usuaModifica.usua_Id
	WHERE fact_Id = @fact_Id
END


GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItemsDEVAPorDuca_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Editar ITEMXDUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbItemsDEVAPorDuca_Editar]
(
	@dedu_Id						INT,
	@duca_Id						INT,
	@deva_Id						INT,
	@usua_UsuarioModificacion		INT,
	@dedu_FechaModificacion			DATETIME
)
AS
BEGIN
	BEGIN TRY
		UPDATE Adua.tbItemsDEVAPorDuca
		   SET duca_Id = @duca_Id,
		       deva_Id = @deva_Id,
			   usua_UsuarioModificacion = @usua_UsuarioModificacion,
			   dedu_FechaModificacion = @dedu_FechaModificacion
		 WHERE dedu_Id = @dedu_Id

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItemsDEVAPorDuca_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbItemsDEVAPorDuca_Insertar] 
(   @duca_Id						INT,
	@deva_Id						INT,
	@usua_UsuarioCreacion 			INT,
	@dedu_FechaCreacion				DATETIME
)
AS
BEGIN
	BEGIN TRY	
			BEGIN
				INSERT INTO Adua.tbItemsDEVAPorDuca (duca_Id, deva_Id, usua_UsuarioCreacion, dedu_FechaCreacion)
				     VALUES							(@duca_Id, @deva_Id, @usua_UsuarioCreacion, @dedu_FechaCreacion )
				     SELECT  1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItemsDEVAPorDuca_InsertarDuca]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar DEVAS por DUCA*/
CREATE   PROCEDURE [Adua].[UDP_tbItemsDEVAPorDuca_InsertarDuca]
	@duca_Id				INT,
	@deva_Id				INT,
	@usua_UsuarioCreacion	INT,
	@dedu_FechaCreacion		DATETIME
AS
BEGIN	
	BEGIN TRY
		
		INSERT INTO [Adua].[tbItemsDEVAPorDuca](duca_Id, [deva_Id], [usua_UsuarioCreacion], [dedu_FechaCreacion], [usua_UsuarioModificacion], [dedu_FechaModificacion])
		VALUES(@duca_Id,@deva_Id,@usua_UsuarioCreacion,@dedu_FechaCreacion,NULL,NULL)

		SELECT 1

	END TRY
	BEGIN CATCH
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItemsDEVAPorDuca_LiberarDevasPorDucaId]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Para liberar todas las DEVAS asociadas a una DUCA en especifico*/
CREATE   PROCEDURE [Adua].[UDP_tbItemsDEVAPorDuca_LiberarDevasPorDucaId]
(
	@duca_Id	INT
)
AS
BEGIN
	BEGIN TRY
		DELETE FROM Adua.tbItemsDEVAPorDuca 
			  WHERE duca_Id = @duca_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error: ' + ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbItemsDEVAPorDuca_ListadoDevasPorduca_Id]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbItemsDEVAPorDuca_ListadoDevasPorduca_Id]
	@duca_Id	INT
AS
BEGIN
	 SELECT dedu_Id, 
			duca_Id, 
			deva_Id, 
			usua_UsuarioCreacion, 
			dedu_FechaCreacion, 
			usua_UsuarioModificacion, 
			dedu_FechaModificacion
	   FROM Adua.tbItemsDEVAPorDuca
	  WHERE duca_Id = @duca_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionGeneral_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* EDITAR LIQUIDACION GENERAL */
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionGeneral_Editar]
	@lige_Id				INT,
	@lige_TipoTributo		NVARCHAR(50), 
	@lige_TotalPorTributo	NVARCHAR(25),
	@lige_ModalidadPago		NVARCHAR(55), 
	@lige_TotalGral			NVARCHAR(50), 
	@duca_Id				NVARCHAR(100),
	@hlig_UsuarioAccion		INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO Adua.tbLiquidacionGeneralHistorial (lige_Id, 
															lige_TipoTributo, 
															lige_TotalPorTributo, 
															lige_ModalidadPago, 
															lige_TotalGral, 
															duca_Id, 
															hlig_UsuarioAccion, 
															hlig_FechaAccion, 
															hlig_Accion)
			SELECT	lige_Id, 
					lige_TipoTributo, 
					lige_TotalPorTributo, 
					lige_ModalidadPago, 
					lige_TotalGral, 
					duca_Id,
					@hlig_UsuarioAccion,
					GETDATE(),
					'Editar'
			FROM	Adua.tbLiquidacionGeneral 
			WHERE	lige_Id = @lige_Id


			UPDATE	Adua.tbLiquidacionGeneral 
			SET		lige_TipoTributo		=	@lige_TipoTributo,
					lige_TotalPorTributo	=	@lige_TotalPorTributo ,
					lige_ModalidadPago		=	@lige_ModalidadPago, 
					lige_TotalGral			=	@lige_TotalGral, 
					duca_Id					=	@duca_Id
			WHERE	lige_Id					=	@lige_Id

			SELECT 1
		COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionGeneral_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* INSERTAR LIQUIDACION GENERAL */
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionGeneral_Insertar]
	@lige_TipoTributo		NVARCHAR(50), 
	@lige_TotalPorTributo	NVARCHAR(25),
	@lige_ModalidadPago		NVARCHAR(55), 
	@lige_TotalGral			NVARCHAR(50), 
	@duca_Id				NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbLiquidacionGeneral(lige_TipoTributo, 
											lige_TotalPorTributo, 
											lige_ModalidadPago, 
											lige_TotalGral, 
											duca_Id)
		VALUES (@lige_TipoTributo, 
				@lige_TotalPorTributo, 
				@lige_ModalidadPago, 
				@lige_TotalGral, 
				@duca_Id)
		
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionGeneral_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------- TABLA LIQUIDACION GENERAL ---------------------------------------------------------------
/* LISTAR LIQUIDACION GENERAL */
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionGeneral_Listar]
AS
BEGIN
	SELECT	lige.lige_Id, 
			lige.lige_TipoTributo, 
			lige.lige_TotalPorTributo, 
			lige.lige_ModalidadPago, 
			lige.lige_TotalGral, 
			lige.duca_Id
	FROM	Adua.tbLiquidacionGeneral	AS	lige
	INNER JOIN Adua.tbDuca AS duca ON lige.duca_Id = duca.duca_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionGeneralHistorial_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--------------------------------------------------------------- TABLA LIQUIDACION GENERAL HISTORIAL ---------------------------------------------------------------

/* LISTAR  LIQUIDACION GENERAL HISTORIAL */
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionGeneralHistorial_Listar]
AS
BEGIN
	SELECT	hlig_Id, 
			lige_Id, 
			lige_TipoTributo, 
			lige_TotalPorTributo, 
			lige_ModalidadPago, 
			lige_TotalGral, 
			duca_Id, 
			hlig_UsuarioAccion, 
			hlig_FechaAccion, 
			hlig_Accion
	FROM	Adua.tbLiquidacionGeneralHistorial
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionPorLinea_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionPorLinea_Editar]
	@lili_Id			INT,
	@lili_Tipo			NVARCHAR(100), 
	@lili_Alicuota		DECIMAL(18,2), 
	@lili_Total			DECIMAL(18,2), 
	@lili_ModalidadPago NVARCHAR(200), 
	@lili_TotalGral		DECIMAL(18,2),  
	@item_Id			INT
AS
BEGIN
	BEGIN TRY
		UPDATE 	Adua.tbLiquidacionPorLinea
		SET lili_Tipo			= @lili_Tipo, 
			lili_Alicuota		= @lili_Alicuota, 
			lili_Total			= @lili_Total, 
			lili_ModalidadPago	= @lili_ModalidadPago, 
			lili_TotalGral		= @lili_TotalGral, 
			item_Id				= @item_Id
		WHERE lili_Id = @lili_Id 
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionPorLinea_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Insertar Liquidacion Por Linea*/
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionPorLinea_Insertar]
	@lili_Tipo			NVARCHAR(100), 
	@lili_Alicuota		DECIMAL(18,2), 
	@lili_Total			DECIMAL(18,2), 
	@lili_ModalidadPago NVARCHAR(200), 
	@lili_TotalGral		DECIMAL(18,2),  
	@item_Id			INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbLiquidacionPorLinea (lili_Tipo, 
													lili_Alicuota, 
													lili_Total, 
													lili_ModalidadPago, 
													lili_TotalGral, 
													item_Id)
		VALUES (@lili_Tipo, @lili_Alicuota, @lili_Total, @lili_ModalidadPago, @lili_TotalGral, @item_Id)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


/*Editar Liquidacion Por Linea*/
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLiquidacionPorLinea_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Listar Liquidacion Por Linea*/
CREATE   PROCEDURE [Adua].[UDP_tbLiquidacionPorLinea_Listar]
AS
BEGIN	
	SELECT	lili_Id, 
			lili_Tipo, 
			lili_Alicuota, 
			lili_Total, 
			lili_ModalidadPago, 
			lili_TotalGral, 
			liquiLinea.item_Id

	FROM	Adua.tbLiquidacionPorLinea liquiLinea 
	INNER JOIN Adua.tbItems Items ON liquiLinea.item_Id = Items.item_Id
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLugaresEmbarque_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar lugares embarque*/
CREATE   PROCEDURE [Adua].[UDP_tbLugaresEmbarque_Editar]
	@emba_Id                  INT,
    @emba_Codigo              CHAR(5),
    @emba_Descripcion         NVARCHAR(200),
	@usua_UsuarioModificacion INT,
	@emba_FechaModificacion   DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT emba_Codigo
				   FROM Adua.tbLugaresEmbarque
				   WHERE emba_Codigo = @emba_Codigo
				   AND emba_Estado = 0)
			BEGIN
				DELETE FROM Adua.tbLugaresEmbarque
				WHERE emba_Codigo = @emba_Codigo
				AND emba_Estado = 0
			END
		ELSE
			BEGIN
		UPDATE  Adua.tbLugaresEmbarque
		SET		emba_Codigo              = @emba_Codigo,
		        emba_Descripcion         = @emba_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				emba_FechaModificacion   = @emba_FechaModificacion
		WHERE	emba_Id                  = @emba_Id

		SELECT 1
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLugaresEmbarque_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar lugares Embarque*/
CREATE   PROCEDURE [Adua].[UDP_tbLugaresEmbarque_Eliminar]
	@emba_Id					INT,
	@usua_UsuarioEliminacion    INT,
	@emba_FechaEliminacion      DATETIME
AS
BEGIN
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'emba_Id', @emba_Id, 'Adua.tbLugaresEmbarque', @respuesta OUTPUT

			IF(@respuesta) = 1
			BEGIN
				UPDATE	Adua.tbLugaresEmbarque
				   SET	emba_Estado             = 0,
				        usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						emba_FechaEliminacion   = @emba_FechaEliminacion
				  WHERE emba_Id                 = @emba_Id 
			END

			SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLugaresEmbarque_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar lugares embarque*/
CREATE   PROCEDURE [Adua].[UDP_tbLugaresEmbarque_Insertar] 
	 @emba_Codigo             CHAR(5),
	 @emba_Descripcion        NVARCHAR(200),
	 @usua_UsuarioCreacion    INT, 
	 @emba_FechaCreacion      DATETIME
AS 
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT emba_Codigo
				   FROM Adua.tbLugaresEmbarque
				   WHERE emba_Codigo = @emba_Codigo
				   AND emba_Estado = 0)
			BEGIN
				UPDATE Adua.tbLugaresEmbarque
				SET emba_Estado = 1,
					emba_Descripcion = @emba_Descripcion
				WHERE emba_Codigo = @emba_Codigo

				SELECT 1
			END
		ELSE
			BEGIN
				INSERT INTO Adua.tbLugaresEmbarque (emba_Codigo, emba_Descripcion, usua_UsuarioCreacion, emba_FechaCreacion)
				VALUES(@emba_Codigo, @emba_Descripcion, @usua_UsuarioCreacion, @emba_FechaCreacion)
		
				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbLugaresEmbarque_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--**********LUGARES EMBARQUE**********--
/*Listar lugares embarque*/
CREATE    PROCEDURE [Adua].[UDP_tbLugaresEmbarque_Listar] 
@emba_Codigo	CHAR(5)
AS
BEGIN
	--SELECT @emba_Codigo = SUBSTRING(@emba_Codigo ,1,2)
	SELECT lugar.emba_Id,
	       lugar.emba_Codigo, 
		   gral.ProperCase(lugar.emba_Descripcion) AS emba_Descripcion, 
		   lugar.usua_UsuarioCreacion, 
		   usuaCrea.usua_Nombre             AS usuarioCreacionNombre,
		   lugar.emba_FechaCreacion, 
		   lugar.usua_UsuarioModificacion,
		   usuaModifica.usua_Nombre         AS usuarioModificacionNombre,
		   lugar.emba_FechaModificacion, 
		   lugar.usua_UsuarioEliminacion, 
		   usuaElimi.usua_Nombre            AS usuarioEliminacionNombre,
		   lugar.emba_FechaEliminacion, 
		   lugar.emba_Estado   
      FROM Adua.tbLugaresEmbarque lugar
	       INNER JOIN Acce.tbUsuarios usuaCrea			ON lugar.usua_UsuarioCreacion     = usuaCrea.usua_Id 
		   LEFT JOIN  Acce.tbUsuarios usuaModifica		ON lugar.usua_UsuarioModificacion = usuaModifica.usua_Id 
		   LEFT JOIN  Acce.tbUsuarios usuaElimi		    ON lugar.usua_UsuarioEliminacion  = usuaElimi.usua_Id 
	 WHERE SUBSTRING(lugar.emba_Codigo,1,2) = @emba_Codigo 
	 OR @emba_Codigo IS NULL
	 AND emba_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbMarcas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Marcas*/
CREATE     PROCEDURE [Adua].[UDP_tbMarcas_Editar] 
	@marc_Id					INT,
	@marc_Descripcion			NVARCHAR(20),
	@usua_UsuarioModificacion	INT,
	@marc_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY

		IF EXISTS (SELECT marc_Id FROM Adua.tbMarcas WHERE @marc_Descripcion = marc_Descripcion AND marc_Id != @marc_Id AND marc_Estado = 0)
			BEGIN
				DELETE FROM Adua.tbMarcas 
				WHERE marc_Descripcion = @marc_Descripcion AND marc_Estado = 0	

				UPDATE  Adua.tbMarcas
				SET		marc_Descripcion = @marc_Descripcion,
						usua_UsuarioModificacion = @usua_UsuarioModificacion,
						marc_FechaModificacion = @marc_FechaModificacion
				WHERE	marc_Id = @marc_Id

				SELECT 1
			END
		ELSE
			BEGIN

				UPDATE  Adua.tbMarcas
				SET		marc_Descripcion = @marc_Descripcion,
						usua_UsuarioModificacion = @usua_UsuarioModificacion,
						marc_FechaModificacion = @marc_FechaModificacion
				WHERE	marc_Id = @marc_Id

				SELECT 1
			END

		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbMarcas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar Marcas*/
CREATE   PROCEDURE [Adua].[UDP_tbMarcas_Eliminar] --3, 1, '2023-07-31 10:46:58.590'
	@marc_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@marc_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'marc_Id', @marc_Id, 'Adua.tbMarcas', @respuesta OUTPUT

			IF(@respuesta) = 1
			BEGIN
				UPDATE	Adua.tbMarcas
				SET		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						marc_FechaEliminacion = @marc_FechaEliminacion,
						marc_Estado = 0
				WHERE marc_Id = @marc_Id
				
				SELECT 1
			END

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbMarcas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Marcas*/
CREATE   PROCEDURE [Adua].[UDP_tbMarcas_Insertar] 
	@marc_Descripcion		NVARCHAR(20),
	@usua_UsuarioCreacion	INT,
	@marc_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
		
		IF EXISTS (SELECT marc_Id FROM Adua.tbMarcas WHERE marc_Descripcion = @marc_Descripcion AND marc_Estado = 0)
			BEGIN
				UPDATE Adua.tbMarcas
				SET marc_Descripcion = @marc_Descripcion,
					usua_UsuarioCreacion = @usua_UsuarioCreacion,
					marc_FechaCreacion = @marc_FechaCreacion,
					usua_UsuarioModificacion = NULL,
					marc_FechaModificacion =NULL,
					marc_Estado = 1
				WHERE marc_Descripcion = @marc_Descripcion

				SELECT 1
			END
		ELSE
		 BEGIN

			INSERT INTO Adua.tbMarcas (marc_Descripcion, usua_UsuarioCreacion, marc_FechaCreacion)
			VALUES(@marc_Descripcion, @usua_UsuarioCreacion, @marc_FechaCreacion)

			SELECT 1

		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Messagee: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbMarcas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--************MARCAS******************--
/*Listar marcas*/
CREATE   PROCEDURE [Adua].[UDP_tbMarcas_Listar]
AS
BEGIN
	SELECT marca.marc_Id, 
	       marca.marc_Descripcion, 
		   marca.usua_UsuarioCreacion, 
		   usuCrea.usua_Nombre					AS usuarioCreacionNombre,
		   marca.marc_FechaCreacion, 
		   marca.usua_UsuarioModificacion, 
		   usuModi.usua_Nombre					AS usuarioModificacionNombre,
		   marca.marc_FechaModificacion, 
		   marca.usua_UsuarioEliminacion,
		   usuElim.usua_Nombre					AS usuarioEliminacionNombre,
		   marca.marc_FechaEliminacion,
		   marca.marc_Estado
	 FROM  Adua.tbMarcas marca 
		   INNER JOIN acce.tbUsuarios usuCrea	ON marca.usua_UsuarioCreacion = usuCrea.usua_Id
		   LEFT JOIN acce.tbUsuarios usuModi	ON marca.usua_UsuarioModificacion = usuModi.usua_Id
		   LEFT JOIN Acce.tbUsuarios usuElim	ON marca.usua_UsuarioEliminacion = usuElim.usua_Id
	WHERE  marc_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbModoTransporte_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Modo Transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbModoTransporte_Editar]
@motr_Id					INT,
@motr_Descripcion			NVARCHAR(75),
@usua_UsuarioModificacion	INT,
@motr_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY 

		UPDATE Adua.tbModoTransporte
		SET		motr_Descripcion = @motr_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				motr_FechaModificacion = @motr_FechaModificacion
		WHERE	motr_Id = @motr_Id
		
		SELECT 1
	END TRY 
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbModoTransporte_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Modo Transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbModoTransporte_Insertar]
@motr_Descripcion		NVARCHAR(75),
@usua_UsuarioCreacion	INT,
@motr_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY 
		INSERT INTO Adua.tbModoTransporte(motr_Descripcion,usua_UsuarioCreacion,motr_FechaCreacion)
		VALUES (
		@motr_Descripcion,
		@usua_UsuarioCreacion,
		@motr_FechaCreacion
		)
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbModoTransporte_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************MODO TRANSPORTE******************--
/*Listar Modo Transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbModoTransporte_Listar]
AS
BEGIN
SELECT	modo.motr_Id						,
		modo.motr_Descripcion				,
		modo.usua_UsuarioCreacion			,
		crea.usua_Nombre					AS usuarioCreacionNombre,
		modo.motr_FechaCreacion				,
		modo.usua_UsuarioModificacion		,
		modi.usua_Nombre					AS usuarioModificacionNombre,
		modo.motr_FechaModificacion			,
		modo.usua_UsuarioEliminacion		,
		elim.usua_Nombre					AS usuarioEliminacionNombre,
		modo.motr_Estado					
FROM	Adua.tbModoTransporte modo 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = modo.usua_UsuarioCreacion		
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = modo.usua_UsuarioModificacion 
		LEFT JOIN Acce.tbUsuarios elim		ON elim.usua_Id = modo.usua_UsuarioEliminacion
WHERE	motr_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbNivelesComerciales_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar NIVELES COMERCIALES*/

CREATE   PROCEDURE [Adua].[UDP_tbNivelesComerciales_Editar]
@nico_Id						INT,
@nico_Codigo					CHAR(3),
@nico_Descripcion				NVARCHAR(150), 
@usua_UsuarioModificacion		INT,
@nico_FechaModificacion			DATETIME
AS
BEGIN
	BEGIN TRY
	UPDATE Adua.tbNivelesComerciales 
	SET nico_Codigo = @nico_Codigo,
		nico_Descripcion = @nico_Descripcion, 
		usua_UsuarioModificacion = @usua_UsuarioModificacion,
		nico_FechaModificacion = @nico_FechaModificacion 
	WHERE nico_Id = @nico_Id
		SELECT 1
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbNivelesComerciales_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar NIVELES COMERCIALES*/
CREATE   PROCEDURE [Adua].[UDP_tbNivelesComerciales_Eliminar]
(
	@nico_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@nico_FechaEliminacion	 DATETIME
)
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'nico_Id', @nico_Id, 'Adua.tbNivelesComerciales', @respuesta OUTPUT

		
		IF(@respuesta = 1)
			BEGIN
				 UPDATE Adua.tbNivelesComerciales
					SET nico_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						
						nico_FechaEliminacion = @nico_FechaEliminacion
				  WHERE nico_Id = @nico_Id 
					AND nico_Estado = 1
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbNivelesComerciales_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar NIVELES COMERCIALES*/

CREATE   PROCEDURE [Adua].[UDP_tbNivelesComerciales_Insertar]
@nico_Codigo					CHAR(3),
@nico_Descripcion				NVARCHAR(150), 
@usua_UsuarioCreacion			INT,
@nico_FechaCreacion				DATETIME
AS
BEGIN
	
	BEGIN TRY
		IF EXISTS(SELECT*FROM Adua.tbNivelesComerciales WHERE nico_Descripcion = @nico_Descripcion AND nico_Estado = 0 )
		BEGIN
			UPDATE Adua.tbNivelesComerciales SET nico_Estado = 1
			SELECT 1
		END
		ELSE
		BEGIN
			INSERT INTO Adua.tbNivelesComerciales (nico_Codigo,nico_Descripcion, usua_UsuarioCreacion, nico_FechaCreacion)
			VALUES (@nico_Codigo,@nico_Descripcion, @usua_UsuarioCreacion, @nico_FechaCreacion)
			SELECT 1
		END
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbNivelesComerciales_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************NIVELES COMERCIALES******************--
/*Listar NIVELES COMERCIALES*/

CREATE   PROCEDURE [Adua].[UDP_tbNivelesComerciales_Listar]
AS
BEGIN
SELECT	nico_Id								,
		nico_Codigo							,
		nico_Descripcion					,
		nco.usua_UsuarioCreacion			,
		usu1.usua_Nombre					AS UsuarioCreacionNombre,
		nico_FechaCreacion 					, 
		nco.usua_UsuarioModificacion		,
		usu2.usua_Nombre					AS usuarioModificacionNombre,
		nico_FechaModificacion 				,
		nco.usua_UsuarioEliminacion,
		nico_FechaEliminacion,
		elim.usua_Nombre					AS UsuarioEliminacionNombre,
		nico_Estado
FROM	Adua.tbNivelesComerciales nco			
		INNER JOIN Acce.tbUsuarios usu1		ON nco.usua_UsuarioCreacion = usu1.usua_Id		
		LEFT JOIN Acce.tbUsuarios usu2		ON nco.usua_UsuarioModificacion = usu2.usua_Id
		LEFT JOIN Acce.tbUsuarios elim		ON nco.usua_UsuarioEliminacion = elim.usua_Id
WHERE	nico_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_ContratoFinalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_ContratoFinalizado] 
	@peju_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE Adua.tbPersonaJuridica
		SET	   [peju_ContratoFinalizado] = 1
		WHERE  peju_Id = @peju_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Persona Juridica*/
CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_Editar]
  @peju_Id                 INT,
  @pers_RTN                NVARCHAR(40),
  @pers_Nombre             NVARCHAR(150),
  @ofic_Id                 INT,
  @escv_Id                 INT,
  @ofpr_Id                 INT,
  @usua_UsuarioModificacion INT,
  @peju_FechaModificacion  DATETIME
AS
BEGIN
    DECLARE @pers_Id INT = (SELECT pers_Id FROM Adua.tbPersonaJuridica WHERE peju_Id = @peju_Id);
	DECLARE @pers_FechaModificacion DATETIME = @peju_FechaModificacion;
    BEGIN TRY
        BEGIN TRANSACTION

        UPDATE [Adua].[tbPersonas]
        SET
            [pers_RTN] = @pers_RTN,
		    [pers_Nombre] = @pers_Nombre,
            [ofic_Id] = @ofic_Id,
            [escv_Id] = @escv_Id,
            [ofpr_Id] = @ofpr_Id,
            [usua_UsuarioModificacion] = @usua_UsuarioModificacion,
            [pers_FechaModificacion] = @pers_FechaModificacion
        WHERE
            [pers_Id] = @pers_Id;


        UPDATE Adua.tbPersonaJuridica
        SET
            [usua_UsuarioModificacion] = @usua_UsuarioModificacion,
            [peju_FechaModificacion] = @peju_FechaModificacion
        WHERE
            peju_Id = @peju_Id;

	    SELECT 1;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 'Mensaje de error: ' + ERROR_MESSAGE() AS Resultado;
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_Eliminar] 
@peju_Id	INT,
@pers_Id    INT
AS
BEGIN
BEGIN TRY
	BEGIN TRANSACTION
		DELETE FROM Adua.tbPersonaJuridica WHERE peju_Id = @peju_Id
		DELETE FROM Adua.tbPersonas WHERE pers_Id = @pers_Id
		SELECT 1
	
	COMMIT TRAN	
END TRY
BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_InsertarTab1]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Persona Juridica*/
CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_InsertarTab1] 

  @pers_RTN                 NVARCHAR(40),
  @pers_Nombre				NVARCHAR(150),
  @ofic_Id                  INT,
  @escv_Id                  INT,
  @ofpr_Id                  INT,
  @usua_UsuarioCreacion     INT,
  @peju_FechaCreacion       DATETIME
AS
BEGIN
    DECLARE @pers_FechaCreacion DATETIME = @peju_FechaCreacion;
    DECLARE @pers_Id INT;
    DECLARE @peju_Id INT;

    BEGIN TRY
    BEGIN TRAN
        
        INSERT INTO [Adua].[tbPersonas]([pers_RTN], pers_Nombre,[ofic_Id], [escv_Id], [ofpr_Id], [pers_escvRepresentante], [pers_OfprRepresentante], [usua_UsuarioCreacion], [pers_FechaCreacion])
        VALUES (@pers_RTN,@pers_Nombre ,@ofic_Id, @escv_Id, @ofpr_Id, null, null, @usua_UsuarioCreacion, @pers_FechaCreacion);
        
        SET @pers_Id = SCOPE_IDENTITY();
        
        INSERT INTO Adua.tbPersonaJuridica(pers_Id,usua_UsuarioCreacion, peju_FechaCreacion)
        VALUES (@pers_Id, @usua_UsuarioCreacion, @peju_FechaCreacion);
        
        SET @peju_Id = SCOPE_IDENTITY();
        
        SELECT CONCAT(@peju_Id, '.',@pers_Id) AS peju_Id;

    COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        SELECT 'Mensaje de error: ' + ERROR_MESSAGE() AS Resultado;
    END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_InsertarTab2]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_InsertarTab2]
(
  @peju_Id                          INT,
  @ciud_Id					        INT,
  @alde_Id				        	INT,
  @colo_Id				    	    INT,
  @peju_NumeroLocalApart            NVARCHAR(150),
  @peju_PuntoReferencia             NVARCHAR(150)
)
AS
BEGIN

	BEGIN TRY
	 DECLARE @aldea INT;
     IF (@aldea = 0)
	 BEGIN
	   SET @aldea = NULL;	
	 END
	 ELSE
	 BEGIN
	     SET @aldea = @alde_Id;
	 END
	  UPDATE [Adua].[tbPersonaJuridica]
	     SET  ciud_Id = @ciud_Id, alde_Id = @aldea, peju_PuntoReferencia = @peju_PuntoReferencia,
		    colo_Id = @colo_Id, peju_NumeroLocalApart = @peju_NumeroLocalApart 
      WHERE peju_Id =  @peju_Id
	   SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_InsertarTab3]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_InsertarTab3]
(
  @peju_Id                            INT,
  @peju_CiudadIdRepresentante	      INT,
  @peju_AldeaIdRepresentante          INT,
  @peju_ColoniaRepresentante		  INT,
  @peju_NumeroLocalRepresentante      NVARCHAR(150),
  @peju_PuntoReferenciaRepresentante  NVARCHAR(150)
)
AS
BEGIN
	BEGIN TRY
	   DECLARE @aldea INT;
     IF (@aldea = 0)
	 BEGIN
	   SET @aldea = NULL;	
	 END
	 ELSE
	 BEGIN
	     SET @aldea = @peju_AldeaIdRepresentante;
	 END
	  UPDATE [Adua].[tbPersonaJuridica]
	     SET  peju_CiudadIdRepresentante = @peju_CiudadIdRepresentante, peju_AldeaIdRepresentante = @peju_AldeaIdRepresentante, peju_PuntoReferenciaRepresentante = @peju_PuntoReferenciaRepresentante,
		    peju_ColoniaRepresentante = @peju_ColoniaRepresentante, peju_NumeroLocalRepresentante = @peju_NumeroLocalRepresentante 
      WHERE peju_Id =  @peju_Id
	   SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_InsertarTab4]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_InsertarTab4]
( 
  @peju_Id                                INT,
  @peju_TelefonoEmpresa                   NVARCHAR(200),
  @peju_TelefonoFijoRepresentanteLegal    NVARCHAR(200),
  @peju_TelefonoRepresentanteLegal        NVARCHAR(200),
  @peju_CorreoElectronico                 NVARCHAR(200),
  @peju_CorreoEletronicoAlternativo       NVARCHAR(200)
)
AS
BEGIN
	BEGIN TRY
	  UPDATE [Adua].[tbPersonaJuridica]
	     SET  [peju_TelefonoEmpresa] = @peju_TelefonoEmpresa , [peju_TelefonoFijoRepresentanteLegal] = @peju_TelefonoFijoRepresentanteLegal, [peju_TelefonoRepresentanteLegal] = @peju_TelefonoRepresentanteLegal,
		    peju_CorreoElectronico  = @peju_CorreoElectronico, [peju_CorreoElectronicoAlternativo] = @peju_CorreoEletronicoAlternativo 
      WHERE peju_Id =  @peju_Id
	   SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaJuridica_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*************** UDPS Para Tabla Persona Juridica ************--

/*Listar Persona Juridica*/

CREATE   PROCEDURE [Adua].[UDP_tbPersonaJuridica_Listar]
AS
BEGIN
	SELECT	 personaJuridica.peju_Id      --
			 ,personas.pers_Nombre
			,personas.pers_Id             --
			,personas.pers_RTN            --
			,personas.ofic_Id             -- TABLA PERSONA TAB 1
			,oficina.ofic_Nombre          -- 
			,personas.escv_Id             --
			,estadoCivil.escv_Nombre      --
			,personas.ofpr_Id             --
			,oficioProfesion.ofpr_Nombre  --
			,personaJuridica.peju_ContratoFinalizado
		   
			,personaJuridica.colo_Id               
			,colonia.colo_Nombre                   AS ColiniaEmpresa
			,personaJuridica.ciud_Id               
			,ciudad.ciud_Nombre                    AS CiudadEmpresa
			,personaJuridica.alde_Id                   --Tab 2
			,Aldea.alde_Nombre                     AS AldeaEmpresa 
			,Provincia.pvin_Id                     
			,Provincia.pvin_Nombre                 AS ProvinciaEmpresa
			,personaJuridica.peju_PuntoReferencia
			,personaJuridica.peju_NumeroLocalApart

			,personaJuridica.peju_ColoniaRepresentante  
			,coloniaRepresentante.colo_Nombre           AS ColoniaRepresentante
			,personaJuridica.peju_AldeaIdRepresentante  
			,aldeaRepresentante.alde_Nombre             AS AldeaRepresemtante  --Tab 3
			,personaJuridica.peju_CiudadIdRepresentante 
			,ciudadesReprentante.ciud_Nombre            AS CiudadRepresentante
			,ProvinciaRepresentante.pvin_Id                          AS ProvinciaIdRepresentante
			,ProvinciaRepresentante.pvin_Nombre                      AS ProvinciaRepresentante
			,personaJuridica.peju_NumeroLocalRepresentante
			,personaJuridica.peju_PuntoReferenciaRepresentante

			,personaJuridica.peju_TelefonoEmpresa
			,personaJuridica.peju_TelefonoFijoRepresentanteLegal
			,personaJuridica.peju_TelefonoRepresentanteLegal        --Tab 4
			,personaJuridica.peju_CorreoElectronico 
			,personaJuridica.peju_CorreoElectronicoAlternativo

			,personaJuridica.usua_UsuarioCreacion
			,usuarioCreacion.usua_Nombre				as usuarioCreacionNombre
			,personaJuridica.peju_FechaCreacion
			,personaJuridica.usua_UsuarioModificacion
			,usuarioModificacion.usua_Nombre			as usuarioModificaNombre
			,personaJuridica.peju_FechaModificacion
			,personaJuridica.peju_Estado
			FROM	    Adua.tbPersonaJuridica			personaJuridica
			LEFT JOIN	Adua.tbPersonas					personas								ON personaJuridica.pers_Id						= personas.pers_Id
			LEFT JOIN	Gral.tbOficinas					oficina									ON personas.ofic_Id								= oficina.ofic_Id
			LEFT JOIN	Gral.tbEstadosCiviles			estadoCivil								ON personas.escv_Id								= estadoCivil.escv_Id
			LEFT JOIN	Gral.tbOficio_Profesiones		oficioProfesion							ON personas.ofpr_Id								= oficioProfesion.ofpr_Id
		
			LEFT JOIN  Gral.tbColonias					colonia									ON personaJuridica.colo_Id						= colonia.colo_Id
			LEFT JOIN  Gral.tbAldeas                    Aldea                                   ON personaJuridica.alde_Id                      = aldea.alde_Id
			LEFT JOIN  Gral.tbCiudades                  Ciudad                                  ON personaJuridica.ciud_Id                      = ciudad.ciud_Id
			LEFT JOIN  Gral.tbProvincias                Provincia                               ON Ciudad.pvin_Id                               = Provincia.pvin_Id

			LEFT JOIN   Gral.tbColonias					coloniaRepresentante					ON personaJuridica.peju_ColoniaRepresentante	= coloniaRepresentante.colo_Id
			LEFT JOIN   Gral.tbAldeas					aldeaRepresentante						ON personaJuridica.peju_AldeaIdRepresentante    = aldeaRepresentante.alde_Id
			LEFT JOIN	Gral.tbCiudades					ciudadesReprentante						ON personaJuridica.peju_CiudadIdRepresentante	= ciudadesReprentante.ciud_Id
			LEFT JOIN   Gral.tbProvincias               ProvinciaRepresentante                  ON ciudadesReprentante.pvin_Id                               = ProvinciaRepresentante.pvin_Id

			LEFT JOIN  Acce.tbUsuarios					usuarioCreacion							ON personaJuridica.usua_UsuarioCreacion			= usuarioCreacion.usua_Id
			LEFT JOIN  Acce.tbUsuarios					usuarioModificacion						ON personaJuridica.usua_UsuarioModificacion		= usuarioModificacion.usua_Id
			WHERE [peju_Estado] = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaNatural_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbPersonaNatural_Editar]
(
	@pena_Id					INT,
	@pers_Id					INT,
	@pena_DireccionExacta		NVARCHAR(200),
	@ciud_Id					INT,
	@pena_TelefonoFijo			NVARCHAR(20),
	@pena_TelefonoCelular		NVARCHAR(20),
	@pena_CorreoElectronico		NVARCHAR(50),
	@pena_CorreoAlternativo		NVARCHAR(50),
	@pena_RTN					NVARCHAR(40),
	@pena_ArchivoRTN			NVARCHAR(MAX),
	@pena_DNI					NVARCHAR(40),
	@pena_ArchivoDNI			NVARCHAR(MAX),
	@pena_NumeroRecibo			VARCHAR(100),
	@pena_ArchivoNumeroRecibo	NVARCHAR(MAX),
	@pena_NombreArchDNI VARCHAR(100),
	@pena_NombreArchRTN VARCHAR(100),
	@pena_NombreArchRecibo VARCHAR(100),
	@usua_UsuarioModificacion   INT,
	@pena_FechaModificacion     DATETIME
)
AS
BEGIN
	BEGIN TRY
		 UPDATE Adua.tbPersonaNatural
			SET pers_Id						= @pers_Id,						
				pena_DireccionExacta		= @pena_DireccionExacta,		
				ciud_Id						= @ciud_Id,						
				pena_TelefonoFijo			= @pena_TelefonoFijo,			
				pena_TelefonoCelular		= @pena_TelefonoCelular,		
				pena_CorreoElectronico		= @pena_CorreoElectronico,		
				pena_CorreoAlternativo		= @pena_CorreoAlternativo,		
				pena_RTN					= @pena_RTN,					
				pena_ArchivoRTN				= @pena_ArchivoRTN,				
				pena_DNI					= @pena_DNI,					
				pena_ArchivoDNI				= @pena_ArchivoDNI,				
				pena_NumeroRecibo			= @pena_NumeroRecibo,
				pena_NombreArchRecibo		= @pena_NombreArchRecibo,
				pena_NombreArchRTN			= @pena_NombreArchRTN,
				pena_NombreArchDNI			= @pena_NombreArchDNI,
				pena_ArchivoNumeroRecibo	= @pena_ArchivoNumeroRecibo,	  	
				usua_UsuarioModificacion	= @usua_UsuarioModificacion,   	
				pena_FechaModificacion		= @pena_FechaModificacion     	
		  WHERE pena_Id = @pena_Id

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaNatural_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*****Finalizar*****--

CREATE    PROCEDURE [Adua].[UDP_tbPersonaNatural_Finalizado]
	@pena_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Adua].[tbPersonaNatural]
		SET	   [pena_Finalizado] = 1
		WHERE  pena_Id = @pena_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaNatural_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbPersonaNatural_Insertar]
(
	@pers_Id					INT,
	@pena_DireccionExacta		NVARCHAR(200),
	@ciud_Id					INT,
	@pena_TelefonoFijo			NVARCHAR(20),
	@pena_TelefonoCelular		NVARCHAR(20),
	@pena_CorreoElectronico		NVARCHAR(50),
	@pena_CorreoAlternativo		NVARCHAR(50),
	@pena_RTN					NVARCHAR(40),
	@pena_ArchivoRTN			NVARCHAR(MAX),
	@pena_DNI					NVARCHAR(40),
	@pena_ArchivoDNI			NVARCHAR(MAX),
	@pena_NumeroRecibo			VARCHAR(100),
	@pena_ArchivoNumeroRecibo	NVARCHAR(MAX),
	@pena_NombreArchDNI VARCHAR(100),
	@pena_NombreArchRTN VARCHAR(100),
	@pena_NombreArchRecibo VARCHAR(100),
	@usua_UsuarioCreacion       INT,
	@pena_FechaCreacion         DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbPersonaNatural
					(pers_Id,						
					pena_DireccionExacta,		
					ciud_Id,						
					pena_TelefonoFijo,			
					pena_TelefonoCelular,		
					pena_CorreoElectronico,		
					pena_CorreoAlternativo,		
					pena_RTN,					
					pena_ArchivoRTN,				
					pena_DNI,					
					pena_ArchivoDNI,				
					pena_NumeroRecibo,			
					pena_ArchivoNumeroRecibo,
					pena_NombreArchRecibo,
					pena_NombreArchRTN,
					pena_NombreArchDNI,
					usua_UsuarioCreacion,       	
					pena_FechaCreacion)
			VALUES (@pers_Id,					
					@pena_DireccionExacta,		
					@ciud_Id,					
					@pena_TelefonoFijo,			
					@pena_TelefonoCelular,		
					@pena_CorreoElectronico,		
					@pena_CorreoAlternativo,		
					@pena_RTN,					
					@pena_ArchivoRTN,			
					@pena_DNI,					
					@pena_ArchivoDNI,			
					@pena_NumeroRecibo,			
					@pena_ArchivoNumeroRecibo,	
					@pena_NombreArchRecibo,
					@pena_NombreArchRTN,
					@pena_NombreArchDNI,
					@usua_UsuarioCreacion,      
					@pena_FechaCreacion)

		SELECT SCOPE_IDENTITY() AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonaNatural_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Adua].[UDP_tbPersonaNatural_Listar]
AS
BEGIN
		SELECT	tbpn.pena_Id							, 
				tbpn.pers_Id							, 
				tbpn.pena_DireccionExacta				, 
				tbc.pvin_Id								,
				provincia.pvin_Nombre					,
				tbpn.ciud_Id							, 
				tbc.ciud_Nombre							,
				tbpn.pena_TelefonoFijo					, 
				tbpn.pena_TelefonoCelular				, 
				tbpn.pena_CorreoElectronico				, 
				tbpn.pena_CorreoAlternativo				, 
				tbpn.pena_RTN							, 
				tbpn.pena_ArchivoRTN					, 
				tbpn.pena_DNI							, 
				tbpn.pena_ArchivoDNI					, 
				tbpn.pena_NumeroRecibo					, 
				tbpn.pena_ArchivoNumeroRecibo			, 
				tbpn.usua_UsuarioCreacion				,
				pers.ofic_Id							,
				ofic.ofic_Nombre						,
				usu.usua_Nombre							AS usuarioCreacion,
				tbpn.pena_FechaCreacion					, 
				tbpn.usua_UsuarioModificacion			, 
				usu2.usua_Nombre						AS usuarioModificacion,
				tbpn.pena_FechaModificacion				, 
				tbpn.pena_Estado						,
				tbpn.pena_Finalizado					,
				pena_NombreArchRTN						,
				pena_NombreArchRecibo					,
				pena_NombreArchDNI						,
				
				pers_Nombre  AS Cliente
		FROM	Adua.tbPersonaNatural  tbpn			
				INNER JOIN Acce.tbUsuarios usu			ON 	tbpn.usua_UsuarioCreacion		= usu.usua_Id 
				LEFT  JOIN Acce.tbUsuarios usu2			ON	tbpn.usua_UsuarioModificacion	= usu2.usua_Id
				INNER JOIN Gral.tbCiudades tbc			ON	tbpn.ciud_Id					= tbc.ciud_Id 
				INNER JOIN Gral.tbProvincias provincia  ON  tbc.pvin_Id						= provincia.pvin_Id
				INNER JOIN [Gral].[tbEmpleados]	empl    ON  usu.empl_Id						= empl.empl_Id
				INNER JOIN [Adua].[tbPersonas] pers		ON	tbpn.pers_Id					= pers.pers_Id
				INNER JOIN [Gral].[tbOficinas] ofic		ON	pers.ofic_Id					= ofic.ofic_Id 
		WHERE	tbpn.pena_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Adua].[UDP_tbPersonas_Editar]
(
	@pers_Id 					INT,
	@pers_RTN					VARCHAR(20),
	@ofic_Id					INT,
	@escv_Id					INT,
	@ofpr_Id					INT,
	@pers_Nombre				NVARCHAR(250),
	@pers_escvRepresentante		INT,
	@pers_OfprRepresentante		INT,
	@usua_UsuarioModificacion		INT,
	@pers_FechaModificacion			DATETIME
)
AS
BEGIN
	BEGIN TRY
			UPDATE Adua.tbPersonas 
			   SET pers_RTN					    = @pers_RTN, 					
				   ofic_Id					    = @ofic_Id, 					
				   escv_Id					    = @escv_Id, 					
				   ofpr_Id					    = @ofpr_Id,
				   pers_Nombre				    = @pers_Nombre,
				   pers_escvRepresentante	    = @pers_escvRepresentante, 		
				   pers_OfprRepresentante	    = @pers_OfprRepresentante, 		
				   usua_UsuarioModificacion		= @usua_UsuarioModificacion,      	
				   pers_FechaModificacion		= @pers_FechaModificacion
			 WHERE pers_Id = @pers_Id

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbPersonas_Insertar]
(
	@pers_RTN					VARCHAR(20),
	@ofic_Id					INT,
	@escv_Id					INT,
	@ofpr_Id					INT,
	@pers_Nombre				NVARCHAR(250),
	@pers_escvRepresentante		INT,
	@pers_OfprRepresentante		INT,
	@usua_UsuarioCreacion		INT,
	@pers_FechaCreacion			DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbPersonas 
					(pers_RTN, 
					ofic_Id, 
					escv_Id, 
					ofpr_Id,
					[pers_Nombre],
					pers_escvRepresentante, 
					pers_OfprRepresentante, 
					usua_UsuarioCreacion, 
					pers_FechaCreacion)
			 VALUES (@pers_RTN,
					@ofic_Id,
					@escv_Id,
					@ofpr_Id,
					@pers_Nombre,
					@pers_escvRepresentante,
					@pers_OfprRepresentante,
					@usua_UsuarioCreacion,
					@pers_FechaCreacion)

		SELECT SCOPE_IDENTITY() AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbPersonas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-----------------PROCEDIMIENTOS ALMACENADOS Y VISTAS MÓDULO ADUANA


--*************** UDPS Para Tabla Personas ************--


/*Listar Personas*/
CREATE   PROC [Adua].[UDP_tbPersonas_Listar]
AS
BEGIN
		SELECT	Personas.pers_Id, 
				Personas.pers_RTN, 
				Personas.ofic_Id,
				Oficina.ofic_Nombre,
				Personas.escv_Id, 
				Civil.escv_Nombre,
				Personas.ofpr_Id, 
				Profesion.ofpr_Nombre,
				Personas.pers_Nombre,

				Personas.pers_escvRepresentante,
				Civil2.escv_Nombre					AS EstadoCivilRepresentante,
				Personas.pers_OfprRepresentante,
				Profesion2.ofpr_Nombre				AS OficioProfecionRepresentante,

				Personas.usua_UsuarioCreacion, 
				Personas.pers_FechaCreacion, 
				Usuario1.usua_Nombre				AS usuarioCreacion,
				Personas.usua_UsuarioModificacion,
				Usuario2.usua_Nombre				AS usuarioModificacion, 
				Personas.pers_FechaModificacion, 
				Personas.pers_Estado

		FROM	Adua.tbPersonas				AS	Personas
		INNER JOIN	Gral.tbOficinas				AS	Oficina		ON Personas.ofic_Id						= Oficina.ofic_Id
		INNER JOIN	Gral.tbEstadosCiviles		AS	Civil		ON Personas.escv_Id						= Civil.escv_Id
		INNER JOIN	Gral.tbOficio_Profesiones	AS	Profesion	ON Personas.ofpr_Id						= Profesion.ofpr_Id
		INNER JOIN	Acce.tbUsuarios				AS	Usuario1	ON Personas.usua_UsuarioCreacion		= Usuario1.usua_Id
		LEFT JOIN	Acce.tbUsuarios				AS	Usuario2	ON Personas.usua_UsuarioModificacion	= Usuario2.usua_Id

		LEFT JOIN	Gral.tbOficio_Profesiones	AS	Profesion2	ON Personas.pers_OfprRepresentante		= Profesion2.ofpr_Id
		LEFT JOIN	Gral.tbEstadosCiviles		AS	Civil2		ON Personas.pers_escvRepresentante		= Civil2.escv_Id
		WHERE	Personas.pers_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbRegimenesAduaneros_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Editar REGIMEN ADUANERO*/
CREATE   PROCEDURE [Adua].[UDP_tbRegimenesAduaneros_Editar]
(
	@regi_Id						INT,
	@regi_Codigo					VARCHAR(10),
	@regi_Descripcion				NVARCHAR(500),
	@usua_UsuarioModificacion		INT,
	@regi_FechaModificacion			DATETIME
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT regi_Id 
				   FROM Adua.tbRegimenesAduaneros
				   WHERE regi_Descripcion = @regi_Descripcion
				   AND regi_Estado = 0)
			BEGIN
				DELETE FROM Adua.tbRegimenesAduaneros
				WHERE regi_Descripcion = @regi_Descripcion
				AND regi_Estado = 0
			END

		UPDATE Adua.tbRegimenesAduaneros
		   SET regi_Codigo = @regi_Codigo,
		       regi_Descripcion = @regi_Descripcion,
			   usua_UsuarioModificacion = @usua_UsuarioModificacion,
			   regi_FechaModificacion = @regi_FechaModificacion
		 WHERE regi_Id = @regi_Id
		   AND regi_Estado = 1

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbRegimenesAduaneros_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar REGIMEN ADUANERO*/
CREATE   PROCEDURE [Adua].[UDP_tbRegimenesAduaneros_Eliminar]
(
	@regi_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@regi_FechaEliminacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'regi_Id', @regi_Id, 'Adua.tbRegimenesAduaneros', @respuesta OUTPUT
		
		IF(@respuesta) = 1
		BEGIN
			UPDATE Adua.tbRegimenesAduaneros
			   SET regi_Estado = 0,
				   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				   regi_FechaEliminacion = @regi_FechaEliminacion
			 WHERE regi_Id = @regi_Id
		END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbRegimenesAduaneros_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar REGIMEN ADUANERO*/
CREATE   PROCEDURE [Adua].[UDP_tbRegimenesAduaneros_Insertar] 
(   @regi_Codigo					VARCHAR(10),
	@regi_Descripcion				NVARCHAR(500),
	@usua_UsuarioCreacion 			INT,
	@regi_FechaCreacion 			DATETIME
)
AS
BEGIN
	BEGIN TRY	
			BEGIN
				INSERT INTO Adua.tbRegimenesAduaneros ( regi_Codigo, 
														regi_Descripcion, 
														usua_UsuarioCreacion, 
														regi_FechaCreacion)
				     VALUES (@regi_Codigo,
					         @regi_Descripcion,
							 @usua_UsuarioCreacion,
							 @regi_FechaCreacion)
				     SELECT  1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbRegimenesAduaneros_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************REGIMENES ADUANEROS******************--
/*Listar REGIMENES ADUANEROS*/
CREATE   PROCEDURE [Adua].[UDP_tbRegimenesAduaneros_Listar]
AS
BEGIN
SELECT	regi_Id 																	,
		regi_Codigo																	,
		regi_Descripcion															,
		regimen.usua_UsuarioCreacion												,
		usuarioCreacion.usua_Nombre						AS usuarioCreacionNombre	,
		regi_FechaCreacion 															,
		regimen.usua_UsuarioModificacion											,
		usuarioModificacion.usua_Nombre					AS usuarioModificacionNombre,
		regi_FechaModificacion														,
		regimen.usua_UsuarioEliminacion												,
		usuarioEliminacion.usua_Nombre					AS usuarioEliminacionNombre	,
		regi_FechaEliminacion														,
		regi_Estado										
FROM	Adua.tbRegimenesAduaneros regimen
		INNER JOIN	Acce.tbUsuarios usuarioCreacion		ON regimen.usua_UsuarioCreacion =		usuarioCreacion.usua_Id
		LEFT JOIN	Acce.tbUsuarios usuarioModificacion	ON regimen.usua_UsuarioModificacion =	usuarioModificacion.usua_Id
		LEFT JOIN	Acce.tbUsuarios usuarioEliminacion	ON regimen.usua_UsuarioEliminacion =	usuarioEliminacion.usua_Id
WHERE	regi_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoDocumento_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Tipo documento*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoDocumento_Editar]
@tido_Id					INT,
@tido_Codigo				CHAR(4),
@tido_Descripcion			NVARCHAR(50),
@usua_UsuarioModificacion	INT,
@tido_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Adua.tbTipoDocumento
		SET tido_Descripcion = @tido_Descripcion,
		tido_Codigo = @tido_Codigo,
		usua_UsuarioModificacion = @usua_UsuarioModificacion,
		tido_FechaModificacion = @tido_FechaModificacion
		WHERE tido_Id = @tido_Id
		SELECT 1
	END TRY
BEGIN CATCH 
	SELECT 'Error Message: ' + ERROR_MESSAGE()
END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoDocumento_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Tipo documento*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoDocumento_Insertar]
@tido_Codigo			CHAR(4),
@tido_Descripcion		NVARCHAR(50),
@usua_UsuarioCreacion	INT,
@tido_FechaCrea			DATETIME
AS
BEGIN
	BEGIN TRY
				INSERT INTO Adua.tbTipoDocumento (tido_Codigo,tido_Descripcion,usua_UsuarioCreacion,tido_FechaCreacion)
				VALUES (
				@tido_Codigo,
				@tido_Descripcion,
				@usua_UsuarioCreacion,
				@tido_FechaCrea
				)
				SELECT 1
	END TRY
	BEGIN CATCH
	SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoDocumento_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************TIPO DOCUMENTO******************--
/*Listar Tipo documento*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoDocumento_Listar]
AS
BEGIN
SELECT	tido_Id								, 
		tido_Codigo							,
		tido_Descripcion					,
		crea.usua_Nombre					AS usarioCreacion,
		tido_FechaCreacion					,
		modi.usua_Nombre					AS usuarioModificacion,
		tido_FechaModificacion				,
		tido_Estado 								
FROM	Adua.tbTipoDocumento tido 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = tido.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = tido.usua_UsuarioModificacion 
WHERE	tido_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoIntermediario_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************Editar Tipo de intermediario ************************/
CREATE   PROCEDURE [Adua].[UDP_tbTipoIntermediario_Editar]  
	@tite_Id					INT,
	@tite_Codigo				CHAR(2),
	@tite_Descripcion			NVARCHAR(150),
	@tite_UsuarioModificacion   INT,
	@tite_FechaModicacion		DATETIME
AS
BEGIN 
   BEGIN TRY 
      UPDATE	Adua.tbTipoIntermediario
      SET		tite_Descripcion = @tite_Descripcion,
				tite_Codigo = @tite_Codigo,
				usua_UsuarioModificacion = @tite_UsuarioModificacion,
				tite_FechaModificacion = @tite_FechaModicacion
      WHERE		tite_Id = @tite_Id
	  SELECT 1
   END TRY 
   BEGIN CATCH 
       SELECT 'Error Message: ' + ERROR_MESSAGE()
   END CATCH
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoIntermediario_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Adua].[UDP_tbTipoIntermediario_Eliminar]
	@tite_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@tite_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'tite_Id', @tite_Id, 'Adua.tbTipoIntermediario', @respuesta OUTPUT

			IF(@respuesta = 1)
				BEGIN
					   UPDATE Adua.tbTipoIntermediario
					   SET tite_Estado = 0,
					       usua_UsuarioEliminacion=@usua_UsuarioEliminacion,
						   tite_FechaEliminacion = @tite_FechaEliminacion
                       WHERE tite_Id = @tite_Id
				END

			SELECT @respuesta AS Resultado
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoIntermediario_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 /********************Crear Tipo Intermediario******************************/
CREATE   PROCEDURE [Adua].[UDP_tbTipoIntermediario_Insertar]
	@tite_Codigo			CHAR(2),
	@tite_Descripcion		NVARCHAR(150), 
	@tite_UsuCreacion		INT, 
	@tite_FechaCreacion		DATETIME
AS    
BEGIN 
   BEGIN TRY 
      IF EXISTS(SELECT * FROM Adua.tbTipoIntermediario WHERE tite_Descripcion = @tite_Descripcion AND tite_Estado = 0)
      BEGIN 
         UPDATE Adua.tbTipoIntermediario
         SET tite_Estado = 1
         SELECT 1
      END
      ELSE 
      BEGIN 
         INSERT INTO Adua.tbTipoIntermediario (tite_Codigo,tite_Descripcion, usua_UsuarioCreacion, tite_FechaCreacion)
         VALUES (@tite_Codigo, @tite_Descripcion, @tite_UsuCreacion, @tite_FechaCreacion)			  
         SELECT 1
      END
   END TRY
   BEGIN CATCH
      SELECT 'Error Message: ' + ERROR_MESSAGE()
   END CATCH  
END

GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoIntermediario_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/********************Listar Tipo intermediario***************************/
CREATE    PROCEDURE [Adua].[UDP_tbTipoIntermediario_Listar]
AS
BEGIN 
SELECT	tite_Id							,
		tite_Codigo						,	
		tite_Descripcion				, 
		usu.usua_Nombre					AS usarioCreacion,
		tite_FechaCreacion				,
		usu1.usua_Nombre				AS usuarioModificacion,
		tite_FechaModificacion			,
		tite_Estado						
FROM	Adua.tbTipoIntermediario tip 
		INNER JOIN Acce.tbUsuarios usu	ON tip.usua_UsuarioCreacion = usu.usua_Id 
		LEFT JOIN Acce.tbUsuarios usu1	ON tip.usua_UsuarioModificacion = usu1.usua_Id 
WHERE	tite_Estado = 1
END 
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoLiquidacion_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar tipo liquidacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoLiquidacion_Editar]
@tipl_Id					INT,
@tipl_Descripcion			NVARCHAR(200),
@usua_UsuarioModificacion	INT,
@tipl_FechaModificacion 	DATETIME
AS
BEGIN
	BEGIN TRY

			IF EXISTS(SELECT * FROM Adua.tbTipoLiquidacion WHERE tipl_Descripcion = @tipl_Descripcion AND tipl_Estado = 0)
			BEGIN
				UPDATE	Adua.tbTipoLiquidacion
				SET		tipl_Estado = 1
				WHERE   tipl_Descripcion = @tipl_Descripcion
				SELECT 1
			END
	ELSE
			BEGIN
				UPDATE Adua.tbTipoLiquidacion
				SET tipl_Descripcion = @tipl_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				tipl_FechaModificacion = @tipl_FechaModificacion
				WHERE tipl_Id = @tipl_Id
				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoLiquidacion_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar tipo liquidacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoLiquidacion_Insertar]
@tipl_Descripcion		NVARCHAR(200),
@usua_UsuarioCreacion	INT,
@tipl_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY

	IF EXISTS(SELECT * FROM Adua.tbTipoLiquidacion WHERE tipl_Descripcion = @tipl_Descripcion AND tipl_Estado = 0)
			BEGIN
				UPDATE	Adua.tbTipoLiquidacion
				SET		tipl_Estado = 1
				WHERE   tipl_Descripcion = @tipl_Descripcion
				SELECT 1
			END
	ELSE
			BEGIN

				INSERT INTO Adua.tbTipoLiquidacion (tipl_Descripcion,usua_UsuarioCreacion, tipl_FechaCreacion)
				VALUES ( @tipl_Descripcion,		 @usua_UsuarioCreacion, @tipl_FechaCreacion	 )
				SELECT 1
			END

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTipoLiquidacion_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************TIPO LIQUIDACION******************--
/*Listar tipo liquidacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTipoLiquidacion_Listar]
AS
BEGIN
SELECT	tipl_Id								,
		tipl_Descripcion					,
		crea.usua_Nombre					AS usarioCreacion,
		tipl_FechaCreacion					,
		modi.usua_Nombre					AS usuarioModificacion,
		tipl_FechaModificacion				,
		tipl_Estado 							
FROM	Adua.tbTipoLiquidacion tilin 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = tilin.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = tilin.usua_UsuarioModificacion
WHERE	tipl_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTiposIdentificacion_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Editar Tipos Identificacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTiposIdentificacion_Editar] 
	@iden_Id					INT,
	@iden_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@iden_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Adua.tbTiposIdentificacion
		SET		iden_Descripcion = @iden_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				iden_FechaModificacion = @iden_FechaModificacion	
		WHERE	iden_Id = @iden_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTiposIdentificacion_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar Tipos Identificacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTiposIdentificacion_Eliminar] 
	@iden_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@iden_FechaEliminacion		DATETIME
AS
BEGIN
	SET @iden_FechaEliminacion = GETDATE();
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'iden_Id', @iden_Id, 'Adua.tbTiposIdentificacion', @respuesta OUTPUT

			IF(@respuesta = 1)
			BEGIN
				UPDATE	Adua.tbTiposIdentificacion
				SET		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						iden_FechaEliminacion = @iden_FechaEliminacion,
						iden_Estado = 0
				WHERE iden_Id = @iden_Id
			END
			SELECT @respuesta
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTiposIdentificacion_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Tipos Identificacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTiposIdentificacion_Insertar] 
	@iden_Descripcion			NVARCHAR(75),
	@usua_UsuarioCreacion	    INT,
	@iden_FechaCreacion         DATETIME
AS 
BEGIN
	
	BEGIN TRY
		INSERT INTO Adua.tbTiposIdentificacion(iden_Descripcion, usua_UsuarioCreacion, iden_FechaCreacion)
		VALUES(@iden_Descripcion, @usua_UsuarioCreacion, @iden_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTiposIdentificacion_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************TIPOS IDENTIFICACION******************--
/*Listar Tipos Identificacion*/
CREATE   PROCEDURE [Adua].[UDP_tbTiposIdentificacion_Listar]
AS
BEGIN
	SELECT identi.iden_Id,
	       identi.iden_Descripcion, 
		   identi.usua_UsuarioCreacion, 
		   usuCrea.usua_Nombre					AS usuarioCreacionNombre,
		   identi.iden_FechaCreacion, 
		   identi.iden_FechaModificacion, 
		   usuModi.usua_Nombre					AS usuarioModificacionNombre,
		   identi.iden_FechaModificacion, 
		   identi.usua_UsuarioEliminacion,
		   usuElim.usua_Nombre					AS usuarioEliminacionNombre,
           iden_FechaEliminacion,
		   identi.iden_Estado
	  FROM Adua.tbTiposIdentificacion identi 
		   LEFT JOIN acce.tbUsuarios usuCrea	ON identi.usua_UsuarioCreacion	 = usuCrea.usua_Id
		   LEFT JOIN acce.tbUsuarios usuModi	ON identi.usua_UsuarioModificacion = usuModi.usua_Id
		   LEFT JOIN acce.tbUsuarios usuElim	ON identi.usua_UsuarioEliminacion = usuElim.usua_Id
     WHERE iden_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTransporte_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbTransporte_Editar] 
	@tran_Id                       INT,
	@pais_Id                       INT,
	@tran_Chasis                   NVARCHAR(100), 
	@marca_Id                      INT, 
	@tran_IdRemolque               NVARCHAR(50), 
	@tran_CantCarga                INT , 
	@tran_NumDispositivoSeguridad  INT, 
	@tran_Equipamiento             NVARCHAR(200) , 
	@tran_TipoCarga                NVARCHAR(200) , 
	@tran_IdContenedor             NVARCHAR(200),  
	@usua_UsuarioModificacion      INT, 
	@tran_FechaModificacion        DATETIME 
AS
BEGIN
	BEGIN TRY
		UPDATE Adua.tbTransporte
		SET  pais_Id                      = @pais_Id, 
			 marca_Id                     = @marca_Id, 
			 tran_Chasis                  = @tran_Chasis,
			 tran_Remolque                = @tran_IdRemolque, 
			 tran_CantCarga               = @tran_CantCarga, 
			 tran_NumDispositivoSeguridad = @tran_NumDispositivoSeguridad,
			 tran_Equipamiento            = @tran_Equipamiento, 
			 tran_TipoCarga               = @tran_TipoCarga, 
			 tran_IdContenedor            = @tran_IdContenedor, 
			 usua_UsuarioModificacion     = @usua_UsuarioModificacion, 
			 tran_FechaModificacion       = @tran_FechaModificacion
		WHERE tran_Id                      = @tran_Id

		SELECT 1
		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTransporte_Insert]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbTransporte_Insert] 
	 @pais_Id                      INT,
	 @tran_Chasis                  NVARCHAR(100) ,
	 @marca_Id                     INT, 
	 @tran_IdRemolque              NVARCHAR(50),
	 @tran_CantCarga               INT, 
	 @tran_NumDispositivoSeguridad INT,
	 @tran_Equipamiento            NVARCHAR(200), 
	 @tran_TipoCarga               NVARCHAR(200),
	 @tran_IdContenedor            NVARCHAR(100), 
	 @usua_UsuarioCreacio          INT, 
	 @tran_FechaCreacion           DATETIME
AS 
BEGIN
	BEGIN TRY
		INSERT INTO Adua.tbTransporte(pais_Id,
										tran_Chasis, 
										marca_Id, 
										tran_Remolque, 
										tran_CantCarga, 
										tran_NumDispositivoSeguridad, 
										tran_Equipamiento, 
										tran_TipoCarga,
										tran_IdContenedor, 
										usua_UsuarioCreacio, 
										tran_FechaCreacion)
		VALUES(@pais_Id,
				@tran_Chasis, 
				@marca_Id, 
				@tran_IdRemolque, 
				@tran_CantCarga, 
				@tran_NumDispositivoSeguridad, 
				@tran_Equipamiento, 
				@tran_TipoCarga,
				@tran_IdContenedor, 
				@usua_UsuarioCreacio, 
				@tran_FechaCreacion);	
		SELECT 1		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_tbTransporte_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************TRANSPORTE******************--
/*Listar transporte*/
CREATE   PROCEDURE [Adua].[UDP_tbTransporte_Listar]
AS
BEGIN
	SELECT trans.tran_Id, 
	       trans.pais_Id, 
		   pais.pais_Nombre                     AS paisNombre,
		   trans.tran_Chasis, 
		   trans.marca_Id, 
		   marc.marc_Descripcion                AS marcaDescripcion,
		   trans.tran_Remolque, 
		   trans.tran_CantCarga, 
		   trans.tran_NumDispositivoSeguridad, 
		   trans.tran_Equipamiento, 
		   trans.tran_TipoCarga, 
		   trans.tran_IdContenedor, 
		   trans.usua_UsuarioCreacio,
		   usuCrea.usua_Nombre                  AS usuarioCreacionNombre,
		   trans.tran_FechaCreacion, 
		   trans.usua_UsuarioModificacion,  
		   usuModi.usua_Nombre                  AS usuarioModificacionNombre,
		   trans.tran_FechaModificacion,
		   trans.usua_UsuarioEliminacion,
		   usuElim.usua_Nombre					AS usuarioEliminacionNombre,
		   trans.trant_FechaEliminacion,
		   trans.tran_Estado
	 FROM  Adua.tbTransporte trans  
		   LEFT JOIN acce.tbUsuarios usuCrea	ON trans.usua_UsuarioCreacio = usuCrea.usua_Id
		   LEFT JOIN acce.tbUsuarios usuModi	ON trans.usua_UsuarioModificacion = usuModi.usua_Id
		   LEFT JOIN Acce.tbUsuarios usuElim	ON trans.usua_UsuarioEliminacion = usuElim.usua_Id		   
		   LEFT JOIN Gral.tbPaises pais			ON trans.pais_Id = pais.pais_Id
		   LEFT JOIN Adua.tbMarcas marc			ON trans.marca_Id = marc.marc_Id
	WHERE trans.tran_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UDP_VW_tbEstadoMercancias_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************ESTADO MERCANCIAS******************--
/*Listar ESTADO MERCANCIAS*/
CREATE   PROCEDURE [Adua].[UDP_VW_tbEstadoMercancias_Listar]
AS
BEGIN
SELECT	merc_Id										,
		merc_Codigo									,
		merc_Descripcion							,
		estadoMercancia.usua_UsuarioCreacion		,
		usuarioCreacion.usua_Nombre					AS usua_NombreCreacion,
		merc_FechaCreacion							,
		estadoMercancia.usua_UsuarioModificacion	,
		usuarioModificacion.usua_Nombre				AS usua_NombreModificacion,
		merc_FechaModificacion						,
		merc_Estado									
FROM	Adua.tbEstadoMercancias estadoMercancia
		INNER JOIN Acce.tbUsuarios usuarioCreacion		ON estadoMercancia.usua_UsuarioCreacion = usuarioCreacion.usua_Id
		LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON estadoMercancia.usua_UsuarioModificacion = usuarioModificacion.usua_Id
WHERE	merc_Estado = 1
END
GO
/****** Object:  StoredProcedure [Adua].[UPD_tbItemsDEVAPorDuca_DEVAsPorDUCANo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Adua].[UPD_tbItemsDEVAPorDuca_DEVAsPorDUCANo]
	@duca_Id INT
AS
BEGIN
	SELECT [dedu_Id]
			,DPD.[deva_Id]
			,DPD.[usua_UsuarioCreacion]
			,DPD.[dedu_FechaCreacion]
			,DPD.[usua_UsuarioModificacion]
			,DPD.[dedu_FechaModificacion]
			,DPD.duca_Id
			,deva.deva_Id, 
			deva.deva_AduanaIngresoId, 
			aduaIngreso.adua_Codigo + ' ' + aduaIngreso.adua_Nombre				AS adua_IngresoNombre,
			deva.deva_AduanaDespachoId, 
			aduaDespacho.adua_Codigo + ' ' + aduaDespacho.adua_Nombre			AS adua_DespachoNombre,
			deva.deva_DeclaracionMercancia, 
			deva.deva_FechaAceptacion, 
			deva.deva_Finalizacion,
			deva.deva_PagoEfectuado, 
			deva.pais_ExportacionId, 
			paix.pais_Codigo + ' - ' + paix.pais_Nombre as pais_ExportacionNombre,
			deva.deva_FechaExportacion, 
			deva.mone_Id, 
			mone.mone_Codigo + ' - ' + mone.mone_Descripcion as monedaNombre,
			deva.mone_Otra, 
			deva.deva_ConversionDolares, 

			--Lugares de embarque
			deva.emba_Id,
			emba.emba_Codigo,
			emba.emba_Codigo +' - '+ emba.emba_Descripcion as LugarEmbarque,

			--Nivel comercial del importador
			impo.nico_Id,
			nico.nico_Descripcion,

			--datos del importador de la tabla de importador
			impo.impo_Id, 
			impo.impo_NumRegistro,
			impo.impo_RTN				        AS impo_RTN,
			impo.impo_NivelComercial_Otro,

			--Datos del importador pero de la tabla de declarantes
			declaImpo.decl_Nombre_Raso			AS impo_Nombre_Raso,
			declaImpo.decl_Direccion_Exacta		AS impo_Direccion_Exacta,
			declaImpo.decl_Correo_Electronico	AS impo_Correo_Electronico,
			declaImpo.decl_Telefono				AS impo_Telefono,
			declaImpo.decl_Fax					AS impo_Fax,			
			provimpo.pvin_Id					AS impo_ciudId,
			provimpo.pvin_Codigo + ' - ' + provimpo.pvin_Nombre AS impo_CiudadNombre,
			provimpo.pais_Id					AS impo_paisId,
			impoPais.pais_Codigo + ' - ' + impoPais.pais_Nombre AS impo_PaisNombre,
			

			--Condiciones comerciales del proveedor
			prov.coco_Id,			
			coco.coco_Descripcion,

			--Proveedor 		
			deva.pvde_Id,		
			declaProv.decl_NumeroIdentificacion AS prov_NumeroIdentificacion,
			declaProv.decl_Nombre_Raso			AS prov_Nombre_Raso,
			declaProv.decl_Direccion_Exacta		AS prov_Direccion_Exacta,
			declaProv.decl_Correo_Electronico	AS prov_Correo_Electronico,
			declaProv.decl_Telefono				AS prov_Telefono,
			declaProv.decl_Fax					AS prov_Fax,
			prov.pvde_Condicion_Otra,
			provprove.pvin_Id					AS prov_ciudId,
			provprove.pvin_Codigo + ' - ' + provprove.pvin_Nombre AS prov_CiudadNombre,
			provprove.pais_Id					AS prov_paisId,
			provPais.pais_Codigo + ' - ' + provPais.pais_Nombre AS prov_PaisNombre,
			
					
			--Tipo intermediario 
			inte.tite_Id,
			tite.tite_Codigo +' - '+ tite.tite_Descripcion as TipoIntermediario,
			 
			  --Datos intermediario tabla intermediario
			inte.inte_Id, 
			provInte.pvin_Id					AS inte_ciudId,
			provInte.pvin_Codigo + ' - ' + provInte.pvin_Nombre AS inte_CiudadNombre,
			provInte.pais_Id					AS inte_paisId,
			intePais.pais_Codigo + ' - ' + intePais.pais_Nombre AS inte_PaisNombre,
			inte.inte_Tipo_Otro,

			 --Datos intermediario tabla declarante
			declaInte.decl_NumeroIdentificacion AS inte_NumeroIdentificacion,
			declaInte.decl_Nombre_Raso			AS inte_Nombre_Raso,
			declaInte.decl_Direccion_Exacta		AS inte_Direccion_Exacta,
			declaInte.decl_Correo_Electronico	AS inte_Correo_Electronico,
			declaInte.decl_Telefono				AS inte_Telefono,
			declaInte.decl_Fax					AS inte_Fax,			
			


			deva.deva_LugarEntrega, 
			deva.pais_EntregaId, 
			pais.pais_Codigo + ' - ' + pais.pais_Nombre as pais_EntregaNombre,
			inco.inco_Id, 
			inco.inco_Descripcion,
			deva.inco_Version, 
			deva.deva_NumeroContrato, 
			deva.deva_FechaContrato, 

			--Datos forma de envio
			foen.foen_Id, 
			foen.foen_Descripcion,
			deva.deva_FormaEnvioOtra, 

			--Datos forma de pago
			deva.fopa_Id, 
			fopa.fopa_Descripcion,
			deva.deva_FormaPagoOtra 			
			
		FROM [Adua].[tbItemsDEVAPorDuca] DPD 
			INNER JOIN Adua.tbDeclaraciones_Valor deva		ON DPD.deva_Id = deva.deva_Id 
			LEFT JOIN Adua.tbAduanas aduaIngreso			ON deva.deva_AduanaIngresoId = aduaIngreso.adua_Id
			LEFT JOIN Adua.tbAduanas aduaDespacho			ON deva.deva_AduanaDespachoId = aduaDespacho.adua_Id
			LEFT JOIN Adua.tbImportadores impo				ON deva.impo_Id = impo.impo_Id
			LEFT JOIN Adua.tbDeclarantes declaImpo			ON impo.decl_Id = declaImpo.decl_Id
			LEFT JOIN Gral.tbProvincias provimpo            ON declaImpo.ciud_Id = provimpo.pvin_Id
			LEFT JOIN Gral.tbPaises impoPais                ON provimpo.pais_Id = impoPais.pais_Id
			LEFT JOIN Gral.tbMonedas mone                   ON deva.mone_Id = mone.mone_Id
			
			
			LEFT JOIN Adua.tbNivelesComerciales nico		ON impo.nico_Id = nico.nico_Id
			LEFT JOIN Adua.tbProveedoresDeclaracion prov	ON prov.pvde_Id = deva.pvde_Id
			LEFT JOIN Adua.tbDeclarantes declaProv			ON prov.decl_Id = declaProv.decl_Id
			LEFT JOIN Gral.tbProvincias provprove           ON declaProv.ciud_Id = provprove.pvin_Id
			LEFT JOIN Gral.tbPaises provPais                ON provprove.pais_Id = provPais.pais_Id


			LEFT JOIN Adua.tbCondicionesComerciales coco	ON prov.coco_Id = coco.coco_Id
			LEFT JOIN Adua.tbIntermediarios inte			ON inte.inte_Id = deva.inte_Id
			LEFT JOIN Adua.tbTipoIntermediario tite			ON inte.tite_Id = tite.tite_Id
			LEFT JOIN Adua.tbDeclarantes declaInte			ON declaInte.decl_Id = inte.decl_Id
			LEFT JOIN Gral.tbProvincias provInte            ON declaInte.ciud_Id = provInte.pvin_Id
			LEFT JOIN Gral.tbPaises intePais                ON provInte.pais_Id = intePais.pais_Id

			LEFT JOIN Adua.tbIncoterm inco					ON deva.inco_Id = inco.inco_Id
			LEFT JOIN Gral.tbFormas_Envio foen				ON deva.foen_Id = foen.foen_Id 
			LEFT JOIN Adua.tbFormasdePago fopa				ON deva.fopa_Id = fopa.fopa_Id
			LEFT JOIN Gral.tbPaises	pais					ON deva.pais_EntregaId = pais.pais_Id
			LEFT JOIN Gral.tbPaises	paix					ON deva.pais_ExportacionId	 = paix.pais_Id
			LEFT JOIN Adua.tbLugaresEmbarque emba			ON deva.emba_Id = emba.emba_Id 
			WHERE DPD.duca_Id = @duca_Id			
END
GO
/****** Object:  StoredProcedure [dbo].[UDP_ValidarReferencias]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UDP_ValidarReferencias]
	(@Id_Nombre		NVARCHAR(250),
	 @Id_Valor		NVARCHAR(50),
	 @tabla_Nombre NVARCHAR(1000),
	 @respuesta INT OUTPUT)
AS BEGIN
	DECLARE @QUERY NVARCHAR(MAX);
	SET @Id_Valor = CONCAT('=', @Id_Valor);

	/*En esta sección se consiguen las tablas que está referenciadas al campo*/

	WITH AKT AS ( SELECT ROW_NUMBER() OVER (ORDER BY f.name) RN, f.name AS ForeignKey
						,OBJECT_NAME(f.parent_object_id) AS TableName
						,COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName
						,SCHEMA_NAME(f.schema_id) SchemaName
						,OBJECT_NAME (f.referenced_object_id) AS ReferenceTableName
						,COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferenceColumnName
				  FROM   sys.foreign_keys AS f
						 INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
						 INNER JOIN sys.objects oo ON oo.object_id = fc.referenced_object_id
				  WHERE  f.referenced_object_id = object_id(@tabla_Nombre))

		,bs AS (SELECT AKT.RN
					  ,'SELECT ' + ColumnName + ' FROM ' + SchemaName + '.' + TableName + ' WHERE ' + ColumnName + ' = OO.' + ReferenceColumnName  SubQuery
				FROM   AKT)
		,re AS (SELECT bs.RN, CAST(RTRIM(bs.SubQuery) AS VARCHAR(MAX)) Joined
				FROM   bs
				WHERE  bs.RN = 1
				UNION  ALL
				SELECT bs2.RN, CAST(re.Joined + ' UNION ALL ' + ISNULL(RTRIM(bs2.SubQuery), '') AS VARCHAR(MAX)) Joined
				FROM   re, bs bs2 
				WHERE  re.RN = bs2.RN - 1 )
		,fi AS (SELECT ROW_NUMBER() OVER (ORDER BY RN DESC) RNK, Joined
				FROM   re)

	/*Se crea el query para verificar si el campo se usó*/
	SELECT @QUERY  = '
			SELECT CASE WHEN XX.REFERENCED IS NULL THEN 1 ELSE 0 END Referenced
			FROM   '+ @tabla_Nombre + ' OO
			OUTER APPLY (SELECT SUM(1) REFERENCED
						FROM   (' + Joined + ') II) XX
						WHERE OO.'+ @Id_Nombre + '' + @Id_Valor 
	FROM   fi
	WHERE  RNK = 1
		
	/*Se ejecuta y consigue el código de verificación (0 no se puede eliminar porque está siendo usado, 1 se puede eliminar porque no está siendo usado*/
	DECLARE @TempTable TABLE (Referenced INT)
	INSERT INTO @TempTable
	EXEC (@QUERY)

	SELECT @respuesta = Referenced
	FROM @TempTable

END
GO
/****** Object:  StoredProcedure [Gral].[UDP_FiltrarAldeasPorCiudades]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Gral].[UDP_FiltrarAldeasPorCiudades] 
@ciud_Id INT
AS
BEGIN
    SELECT    alde_Id, alde_Nombre
    FROM    Gral.tbAldeas
    WHERE    ciud_Id = @ciud_Id AND alde_Estado = 1

END


/*------------- COLONIAS POR CIUDAD --------------*/
GO
/****** Object:  StoredProcedure [Gral].[UDP_FiltrarCiudadesPorProvincia]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Gral].[UDP_FiltrarCiudadesPorProvincia] 
    @pvin_Id INT
AS
BEGIN
    SELECT    ciud_Id, 
            ciud_Nombre, 
            ciud.pvin_Id, 
            pvin.pvin_Nombre,
            ciud.ciud_Estado
    FROM Gral.tbCiudades AS ciud
    INNER JOIN    Gral.tbProvincias    AS pvin        ON  ciud.pvin_Id = pvin.pvin_Id
    WHERE ciud.pvin_Id = @pvin_Id AND ciud_Estado = 1
END


/*------------- ALDEAS POR CIUDADES --------------*/
GO
/****** Object:  StoredProcedure [Gral].[UDP_FiltrarColoniasPorCiudad]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Gral].[UDP_FiltrarColoniasPorCiudad] 
(@ciud_Id INT)
AS
SELECT  colo_Id, 
		colo_Nombre, 
		alde_Id, 
		col.ciud_Id, 
		ciudad.ciud_Nombre,
		colo_Estado
FROM Gral.tbColonias  AS col INNER JOIN Gral.tbCiudades ciudad
ON col.ciud_Id = ciudad.ciud_Id
WHERE col.ciud_Id = @ciud_Id AND col.colo_Estado = 1




GO
/****** Object:  StoredProcedure [Gral].[UDP_FiltrarProvinciasPorPais]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Gral].[UDP_FiltrarProvinciasPorPais] 
(@pais_Id INT)
AS
BEGIN
	SELECT	pvin_Id, 
			pvin_Nombre, 
			pvin_Codigo, 
			provincia.pais_Id, 
			pais.pais_Codigo,
			pais.pais_Nombre, 
			pvin_Estado
	FROM Gral.tbProvincias AS provincia INNER JOIN Gral.tbPaises AS pais
	ON  provincia.pais_Id = pais.pais_Id
	WHERE provincia.pais_Id = @pais_Id AND provincia.pvin_Estado = 1
END


/*------------- CIUDADES POR PROVINCIAS --------------*/
GO
/****** Object:  StoredProcedure [Gral].[UDP_FiltrarProvinciasPorPaisYaduana]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Gral].[UDP_FiltrarProvinciasPorPaisYaduana] 
@pais_Id INT,
@pvin_EsAduana BIT
AS
BEGIN
	SELECT	pvin_Id, 
			pvin_Nombre, 
			pvin_Codigo, 
			provincia.pais_Id, 
			pais.pais_Codigo,
			pais.pais_Nombre, 
			pvin_Estado
	FROM Gral.tbProvincias AS provincia INNER JOIN Gral.tbPaises AS pais
	ON  provincia.pais_Id = pais.pais_Id
	WHERE provincia.pais_Id = @pais_Id AND provincia.pvin_Estado = 1
	AND pvin_EsAduana = @pvin_EsAduana
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbAldeas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar ALDEAS*/
CREATE   PROCEDURE [Gral].[UDP_tbAldeas_Editar]
 @alde_Id						INT,
 @alde_Nombre					NVARCHAR(150), 
 @ciud_Id						INT, 
 @usua_UsuarioModificacion		INT,
 @alde_FechaModificacion		DATETIME

AS
BEGIN
		
	BEGIN TRY
		UPDATE	Gral.tbAldeas 
		SET		alde_Nombre = @alde_Nombre, 
				ciud_Id = @ciud_Id, 
				alde_FechaModificacion = @alde_FechaModificacion, 
				usua_UsuarioModificacion = @usua_UsuarioModificacion
		WHERE	alde_Id = @alde_Id

		SELECT 1
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbAldeas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UDP Eliminación Aldeas
CREATE   PROCEDURE [Gral].[UDP_tbAldeas_Eliminar]
	@alde_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@alde_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
				DECLARE @respuesta INT
				EXEC dbo.UDP_ValidarReferencias 'alde_Id', @alde_Id, 'Gral.tbAldeas', @respuesta OUTPUT

				SELECT @respuesta AS Resultado
				IF(@respuesta) = 1
					BEGIN
						UPDATE	Gral.tbAldeas
						SET		alde_Estado = 0,
								usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
								alde_FechaEliminacion = @alde_FechaEliminacion
						WHERE	alde_Id = @alde_Id
					END

			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


GO
/****** Object:  StoredProcedure [Gral].[UDP_tbAldeas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar ALDEAS*/
CREATE   PROCEDURE [Gral].[UDP_tbAldeas_Insertar]
 @alde_Nombre				NVARCHAR(150), 
 @ciud_Id					INT, 
 @usua_UsuarioCreacion		INT,
 @alde_FechaCreacion		DATETIME

AS
BEGIN
	
	BEGIN TRY
		IF EXISTS (SELECT * 
				   FROM Gral.tbAldeas 
				   WHERE alde_Nombre = @alde_Nombre 
				   AND ciud_Id = @ciud_Id
				   AND alde_Estado = 0 )
		BEGIN
			UPDATE Gral.tbAldeas 
			SET    alde_Estado = 1, 
				   ciud_Id  = @ciud_Id 
				   WHERE alde_Nombre = @alde_Nombre 
				   AND ciud_Id = @ciud_Id

			SELECT 1
		END
		ELSE 
		BEGIN
			INSERT INTO Gral.tbAldeas (alde_Nombre, 
									   ciud_Id, 
									   usua_UsuarioCreacion, 
									   alde_FechaCreacion)
			VALUES (@alde_Nombre, 
					@ciud_Id, 
					@usua_UsuarioCreacion, 
					@alde_FechaCreacion)

			SELECT 1
		END
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbAldeas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************ALDEAS******************--
/*Listar ALDEAS*/
CREATE   PROCEDURE [Gral].[UDP_tbAldeas_Listar]
AS
BEGIN
SELECT	alde_Id								,
		alde_Nombre							,
		alde.ciud_Id						,
		ciu.ciud_Nombre						,
		ciu.pvin_Id							,
		provincias.pvin_Codigo				,
		provincias.pvin_Nombre				,
		alde.usua_UsuarioCreacion			,
		usu1.usua_Nombre					AS UsuarioCreacionNombre,
		alde_FechaCreacion	 				, 
		alde.usua_UsuarioModificacion		,
		usu2.usua_Nombre					AS UsuarioModificadorNombre,
		alde_FechaModificacion	 			,
		alde_Estado
FROM	Gral.tbAldeas alde					
		INNER JOIN Gral.tbCiudades		AS ciu			ON alde.ciud_Id = ciu.ciud_Id
		INNER JOIN Gral.tbProvincias	AS provincias	ON ciu.pvin_Id = provincias.pvin_Id
		INNER JOIN Acce.tbUsuarios		AS usu1			ON alde.usua_UsuarioCreacion = usu1.usua_Id 
		LEFT JOIN Acce.tbUsuarios		AS usu2			ON alde.usua_UsuarioModificacion = usu2.usua_Id
WHERE	alde_Estado = 1
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCargos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar cargos*/
CREATE   PROCEDURE [Gral].[UDP_tbCargos_Editar] 
	@carg_Id					INT,
	@carg_Nombre				NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@carg_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Gral.tbCargos
		SET		carg_Nombre = @carg_Nombre,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				carg_FechaModificacion = @carg_FechaModificacion
		WHERE	carg_Id = @carg_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCargos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar cargos*/
CREATE   PROCEDURE [Gral].[UDP_tbCargos_Insertar] --'prueba1', 1, '2023-07-28 14:26:31.000'
	@carg_Nombre			NVARCHAR(150),
	@carg_Aduana			BIT,
	@usua_UsuarioCreacion	INT,
	@carg_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY

		INSERT INTO Gral.tbCargos (carg_Nombre,  carg_Aduana, usua_UsuarioCreacion,  carg_FechaCreacion)
			VALUES(@carg_Nombre, @carg_Aduana,  @usua_UsuarioCreacion,  @carg_FechaCreacion)


			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCargos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--**********CARGOS**********--

/*Listar cargos*/
CREATE   PROCEDURE [Gral].[UDP_tbCargos_Listar]
	@carg_Aduana			BIT
AS
BEGIN
	SELECT carg_Id							
		   ,carg_Nombre
		   ,carg_Aduana
	       ,carg.usua_UsuarioCreacion		
	       ,usuaCrea.usua_Nombre			AS usuarioCreacionNombre
	       ,carg_FechaCreacion				
	       ,carg.usua_UsuarioModificacion	
	       ,usuaModifica.usua_Nombre		AS usuarioModificacionNombre
	       ,carg_FechaModificacion			
	       ,carg_Estado						
    FROM Gral.tbCargos carg 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON carg.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica	ON carg.usua_UsuarioModificacion = usuaModifica.usua_Id 
	WHERE carg_Estado = 1
	AND carg_Aduana = @carg_Aduana
	OR @carg_Aduana IS NULL
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCiudades_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Paises*/
CREATE   PROCEDURE [Gral].[UDP_tbCiudades_Editar]
	@ciud_Id					INT,
	@ciud_Nombre				NVARCHAR(150), 
	@pvin_Id					INT, 
	@usua_UsuarioModificacion	INT,
	@ciud_FechaModificacion		DATETIME
AS
BEGIN 
	
	BEGIN TRY
		 UPDATE Gral.tbCiudades 
		 SET	ciud_Nombre = @ciud_Nombre, 
				pvin_Id = @pvin_Id,
				usua_UsuarioModificacion = @usua_UsuarioModificacion, 
				ciud_FechaModificacion = @ciud_FechaModificacion
		 WHERE ciud_Id = @ciud_Id

		 SELECT 1
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCiudades_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Gral].[UDP_tbCiudades_Eliminar] 
	@ciud_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@ciud_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'ciud_Id', @ciud_Id, 'gral.tbCiudades', @respuesta OUTPUT

			SELECT @respuesta AS Resultado
			IF(@respuesta) = 1
				BEGIN
					UPDATE	Gral.tbCiudades
					SET		ciud_Estado = 0,
							usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
							ciud_FechaEliminacion = @ciud_FechaEliminacion
					WHERE	ciud_Id = @ciud_Id
				END
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCiudades_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Ciudades*/
CREATE   PROCEDURE [Gral].[UDP_tbCiudades_Insertar]
	@ciud_Nombre				NVARCHAR(150), 
	@ciud_EsAduana				BIT,
	@pvin_Id					INT, 
	@usua_UsuarioCreacion		INT,
	@ciud_FechaCreacion		    DATETIME
AS
BEGIN
	
	BEGIN TRY
			INSERT INTO Gral.tbCiudades (ciud_Nombre, 
										 ciud_EsAduana,
										 pvin_Id, 
										 usua_UsuarioCreacion, 
										 ciud_FechaCreacion)
			VALUES (@ciud_Nombre, 
					@ciud_EsAduana,
					@pvin_Id, 
					@usua_UsuarioCreacion, 
					@ciud_FechaCreacion)

			SELECT 1
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH

END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbCiudades_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************CIUDADES******************--
/*Listar Paises*/
CREATE   PROCEDURE [Gral].[UDP_tbCiudades_Listar]
	@ciud_EsAduana		BIT
AS
BEGIN
SELECT	ciud_Id								,
		ciud_Nombre							,
		ciud_EsAduana						,
		ciu.pvin_Id							,
		provi.pvin_Nombre					,
		provi.pvin_Codigo					,
		pais.pais_Id                        ,
		pais.pais_Codigo					,
		pais.pais_Nombre					,
		ciu.usua_UsuarioCreacion			,
		usu1.usua_Nombre					AS usuarioCreacionNombre,
		ciud_FechaCreacion					, 
		ciu.usua_UsuarioModificacion		,
		usu2.usua_Nombre					AS usuarioModificadorNombre,
		ciud_FechaModificacion				,
		ciud_Estado
FROM	Gral.tbCiudades ciu					
		INNER JOIN Acce.tbUsuarios usu1			ON ciu.usua_UsuarioCreacion = usu1.usua_Id		
		LEFT JOIN  Acce.tbUsuarios  usu2		ON ciu.usua_UsuarioModificacion = usu2.usua_Id	
		INNER JOIN Gral.tbProvincias provi		ON ciu.pvin_Id = provi.pvin_Id					
		INNER JOIN Gral.tbPaises pais			ON provi.pais_Id = pais.pais_Id
WHERE	ciud_Estado = 1
AND	ciud_EsAduana = @ciud_EsAduana
OR @ciud_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbColonias_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar colonias*/
CREATE   PROCEDURE [Gral].[UDP_tbColonias_Editar] 
	@colo_Id					INT,
	@colo_Nombre				NVARCHAR(150),
	@alde_Id					INT,
	@ciud_Id					INT,
	@usua_UsuarioModificacion	INT,
	@colo_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Gral.tbColonias
		SET		colo_Nombre = @colo_Nombre,
				alde_Id = @alde_Id,
				ciud_Id = @ciud_Id,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				colo_FechaModificacion = @colo_FechaModificacion
		WHERE	colo_Id = @colo_Id

		SELECT 1
		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbColonias_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UDP Eliminación Colonias
CREATE   PROCEDURE [Gral].[UDP_tbColonias_Eliminar]
	@colo_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@colo_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
				DECLARE @respuesta INT
				EXEC dbo.UDP_ValidarReferencias 'colo_Id', @colo_Id, 'Gral.tbColonias', @respuesta OUTPUT

				SELECT @respuesta AS Resultado
				IF(@respuesta) = 1
					BEGIN
						UPDATE	Gral.tbColonias
						SET		colo_Estado = 0,
								usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
								colo_FechaEliminacion = @colo_FechaEliminacion
						WHERE	colo_Id = @colo_Id
					END
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


GO
/****** Object:  StoredProcedure [Gral].[UDP_tbColonias_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar colonias*/
CREATE   PROCEDURE [Gral].[UDP_tbColonias_Insertar] 
	@colo_Nombre			NVARCHAR(150),
	@alde_Id				INT,
	@ciud_Id				INT,
	@usua_UsuarioCreacion	INT,
	@colo_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY

		INSERT INTO Gral.tbColonias (colo_Nombre, 
									 alde_Id,
									 ciud_Id,
									 usua_UsuarioCreacion, 
									 colo_FechaCreacion)
		VALUES(@colo_Nombre,	
				@alde_Id,
				@ciud_Id,
				@usua_UsuarioCreacion,
				@colo_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbColonias_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--**********COLONIAS**********--

/*Listar colonias*/
CREATE   PROCEDURE [Gral].[UDP_tbColonias_Listar]
AS
BEGIN
	SELECT colo_Id								
	       ,colo_Nombre							
	       ,colo.alde_Id						
	       ,alde.alde_Nombre					
	       ,colo.ciud_Id						
	       ,ciud.ciud_Nombre
		   
		   ,prov.pvin_Codigo
		   ,prov.pvin_Id
		   ,prov.pvin_Nombre

		   ,pais.pais_Codigo
		   ,pais_Nombre
		   ,pais.pais_Id

	       ,colo.usua_UsuarioCreacion			
	       ,usuaCrea.usua_Nombre				AS usuarioCreacionNombre
	       ,colo_FechaCreacion					
	       ,colo.usua_UsuarioModificacion		
	       ,usuaModifica.usua_Nombre			AS usuarioModificacionNombre
		   ,colo.colo_FechaModificacion
	       ,colo.usua_UsuarioEliminacion
		   ,usuaElimina.usua_Nombre				AS usuarioEliminacionNombre
		   ,colo.colo_FechaEliminacion
	       ,colo_Estado							
   FROM Gral.tbColonias colo 
   LEFT JOIN Gral.tbAldeas alde				ON colo.alde_Id = alde.alde_Id 
   LEFT JOIN Gral.tbCiudades ciud			ON colo.ciud_Id = ciud.ciud_Id 
   INNER JOIN Gral.tbProvincias prov        ON ciud.pvin_Id = prov.pvin_Id
   INNER JOIN Gral.tbPaises pais            ON pais.pais_Id = prov.pais_Id
   INNER JOIN Acce.tbUsuarios usuaCrea		ON colo.usua_UsuarioCreacion = usuaCrea.usua_Id 
   LEFT JOIN Acce.tbUsuarios usuaModifica	ON colo.usua_UsuarioModificacion = usuaModifica.usua_Id 
   LEFT JOIN Acce.tbUsuarios usuaElimina	ON colo.usua_UsuarioEliminacion = usuaElimina.usua_Id
   WHERE colo_Estado = 1
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar EMPLEADOS*/
CREATE   PROCEDURE [Gral].[UDP_tbEmpleados_Editar]
	@empl_Id					INT,
	@empl_Nombres				NVARCHAR(150),
	@empl_Apellidos				NVARCHAR(150),
	@empl_DNI					NVARCHAR(20), 
	@escv_Id					INT, 
	@empl_Sexo					CHAR, 
	@empl_FechaNacimiento		DATE, 
	@empl_Telefono				NVARCHAR(20), 
	@empl_DireccionExacta		NVARCHAR(500), 
	@pvin_Id					INT, 
	@empl_CorreoElectronico		NVARCHAR(150), 
	@carg_Id					INT, 
	@empl_EsAduana				BIT, 
	@usua_UsuarioModificacion	INT,
	@empl_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		 UPDATE Gral.tbEmpleados
		    SET empl_Nombres = @empl_Nombres, 
				empl_Apellidos = @empl_Apellidos, 
				empl_DNI = @empl_DNI, 
				escv_Id = @escv_Id, 
				empl_Sexo = @empl_Sexo, 
				empl_FechaNacimiento = @empl_FechaNacimiento, 
				empl_Telefono = @empl_Telefono, 
				empl_DireccionExacta = @empl_DireccionExacta, 
				pvin_Id = @pvin_Id, 
				empl_CorreoElectronico = @empl_CorreoElectronico, 
				carg_Id = @carg_Id, 
				empl_EsAduana = @empl_EsAduana,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				empl_FechaModificacion = @empl_FechaModificacion
		  WHERE empl_Id = @empl_Id

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar EMPLEADOS*/
CREATE   PROCEDURE [Gral].[UDP_tbEmpleados_Eliminar]
	@empl_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@empl_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
			UPDATE Acce.tbUsuarios
			SET usua_Estado = 0
			WHERE empl_Id = @empl_Id

			UPDATE Gral.tbEmpleados
			   SET empl_Estado = 0,
				   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				   empl_FechaEliminacion = @empl_FechaEliminacion
			 WHERE empl_Id = @empl_Id

			 SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Insertar EMPLEADOS*/
CREATE   PROCEDURE [Gral].[UDP_tbEmpleados_Insertar]
	@empl_Nombres			NVARCHAR(150),
	@empl_Apellidos			NVARCHAR(150),
	@empl_DNI				NVARCHAR(20), 
	@escv_Id				INT, 
	@empl_Sexo				CHAR, 
	@empl_FechaNacimiento	DATE, 
	@empl_Telefono			NVARCHAR(20), 
	@empl_DireccionExacta	NVARCHAR(500), 
	@pvin_Id				INT, 
	@empl_CorreoElectronico	NVARCHAR(150), 
	@carg_Id				INT, 
	@empl_EsAduana			BIT, 
	@usua_UsuarioCreacion	INT,
	@empl_FechaCreacion     DATETIME
AS 
BEGIN
	BEGIN TRY
		--IF EXISTS (SELECT * FROM Gral.tbEmpleados
		--				WHERE empl_DNI = @empl_DNI AND empl_Telefono = @empl_Telefono
		--				AND empl_Estado = 0)
		--BEGIN
		--	UPDATE Gral.tbEmpleados
		--	SET	   empl_Estado = 1,
		--		   empl_Nombres = @empl_Nombres, 
		--		   empl_Apellidos = @empl_Apellidos, 
		--		   empl_DNI = @empl_DNI, 
		--		   escv_Id = @escv_Id, 
		--		   empl_Sexo = @empl_Sexo, 
		--		   empl_FechaNacimiento = @empl_FechaNacimiento, 
		--		   empl_Telefono = @empl_Telefono, 
		--		   empl_DireccionExacta = @empl_DireccionExacta, 
		--		   pvin_Id = @pvin_Id, 
		--		   empl_CorreoElectronico = @empl_CorreoElectronico, 
		--		   carg_Id = @carg_Id, 
		--		   empl_EsAduana = @empl_EsAduana
		--	WHERE  empl_DNI = @empl_DNI

		--	SELECT 1
		--END
		--ELSE 
		--	BEGIN
		--		INSERT INTO  Gral.tbEmpleados(empl_Nombres, 
		--										  empl_Apellidos, 
		--										  empl_DNI, 
		--										  escv_Id, 
		--										  empl_Sexo, 
		--										  empl_FechaNacimiento, 
		--										  empl_Telefono, 
		--										  empl_DireccionExacta, 
		--										  pvin_Id, 
		--										  empl_CorreoElectronico, 
		--										  carg_Id, 
		--										  empl_EsAduana, 
		--										  usua_UsuarioCreacion, 
		--										  empl_FechaCreacion)
		--	VALUES(@empl_Nombres,
		--		   @empl_Apellidos,
		--		   @empl_DNI, 
		--		   @escv_Id,
		--		   @empl_Sexo,				
		--		   @empl_FechaNacimiento,	
		--		   @empl_Telefono, 
		--		   @empl_DireccionExacta, 
		--		   @pvin_Id,
		--		   @empl_CorreoElectronico, 
		--		   @carg_Id,
		--		   @empl_EsAduana,		
		--		   @usua_UsuarioCreacion,	
		--		   @empl_FechaCreacion)


		--	SELECT 1
		--END
			INSERT INTO Gral.tbEmpleados
						(empl_Nombres, 
						 empl_Apellidos, 
						 empl_DNI, 
						 escv_Id, 
						 empl_Sexo, 
						 empl_FechaNacimiento, 
						 empl_Telefono, 
						 empl_DireccionExacta, 
						 pvin_Id, 
						 empl_CorreoElectronico, 
						 carg_Id, 
						 empl_EsAduana, 
						 usua_UsuarioCreacion, 
						 empl_FechaCreacion)
				  VALUES (@empl_Nombres,
				  	      @empl_Apellidos,
				  	      @empl_DNI, 
				  	      @escv_Id,
				  	      @empl_Sexo,				
				  	      @empl_FechaNacimiento,	
				  	      @empl_Telefono, 
				  	      @empl_DireccionExacta, 
				  	      @pvin_Id,
				  	      @empl_CorreoElectronico, 
				  	      @carg_Id,
				  	      @empl_EsAduana,		
				  	      @usua_UsuarioCreacion,	
				  	      @empl_FechaCreacion)
		
		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************EMPLEADOS******************--


--************EMPLEADOS******************--
/*Listar EMPLEADOS*/
CREATE   PROCEDURE [Gral].[UDP_tbEmpleados_Listar]
	@empl_EsAduana		BIT
AS
BEGIN

SELECT  empl.empl_Id								,
		empl_Nombres								,
		empl_Apellidos								,
		CONCAT(empl_Nombres, ' ', empl_Apellidos)		AS empl_NombreCompleto,
		empl_DNI									,
		empl.escv_Id								,
		escv.escv_Nombre							,
		CASE 
		WHEN empl_Sexo = 'F' THEN 'Femenino'
		ELSE 'Masculino'
		END											AS empl_Sexo,
		empl_FechaNacimiento						,
		empl_Telefono								,
		empl_DireccionExacta						,
		empl.pvin_Id								,
		pais.pais_Id								,
		pvin.pvin_Nombre							,
		pais.pais_Codigo							,
		pais.pais_Nombre							,
		empl_CorreoElectronico						,
		empl.carg_Id								,
		carg.carg_Nombre							,
		empl_EsAduana								,
		empl.usua_UsuarioCreacion					,
		usuaCrea.usua_Nombre						AS usuarioCreacionNombre,
		empl_FechaCreacion							,
		empl.usua_UsuarioModificacion				,
		usuaModifica.usua_Nombre					AS usuarioModificacionNombre,
		empl_FechaModificacion						,
		empl.usua_UsuarioEliminacion				,
		usuaElimina.usua_Nombre						AS usuarioEliminacionNombre,
		empl_FechaEliminacion						,
		empl.usua_UsuarioActivacion					,
		usuaActiva.usua_Nombre						AS usuarioActivacionNombre,
		empl.empl_FechaActivacion					,
		empl_Estado								
FROM	Gral.tbEmpleados empl 
		INNER JOIN Acce.tbUsuarios usuaCrea		ON empl.usua_UsuarioCreacion = usuaCrea.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaModifica	ON empl.usua_UsuarioModificacion = usuaModifica.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaElimina	ON empl.usua_UsuarioEliminacion = usuaElimina.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaActiva	ON empl.usua_UsuarioActivacion = usuaActiva.usua_Id
		INNER JOIN Gral.tbEstadosCiviles escv	ON empl.escv_Id = escv.escv_Id 
		INNER JOIN Gral.tbProvincias pvin		ON empl.pvin_Id = pvin.pvin_Id 
		INNER JOIN Gral.tbPaises pais			ON pvin.pais_Id = pais.pais_Id 
		INNER JOIN Gral.tbCargos carg			ON empl.carg_Id = carg.carg_Id
WHERE empl_EsAduana = @empl_EsAduana
OR @empl_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_ListarNoTieneUsuario]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Gral].[UDP_tbEmpleados_ListarNoTieneUsuario]
	@empl_EsAduana		BIT
AS
BEGIN

SELECT		empl.empl_Id								,
			empl_Nombres								,
			empl_Apellidos								,
			empl_EsAduana,
			CONCAT(empl_Nombres, ' ', empl_Apellidos)		AS empl_NombreCompleto,
			empl_Estado								
FROM		Gral.tbEmpleados	empl 
FULL JOIN	Acce.tbUsuarios		usua
ON			empl.empl_Id = usua.empl_Id
WHERE (empl_EsAduana = @empl_EsAduana)
AND   (usua.usua_Id IS NULL AND empl.empl_Estado = 1)
END

--EXEC acce.UDP_tbUsuarios_Insertar 'juan', '123', 1,1, 'https://www.dumpaday.com/wp-content/uploads/2019/04/the-random-pics-4.jpg', 1, 1, 1,'08-08-2023'
--EXEC acce.UDP_tbUsuarios_Insertar 'angie', '123', 2,0, 'https://i.pinimg.com/originals/10/b8/50/10b8509d551e5a264227dee8248fc1fa.jpg', 1, 1, 1,'08-08-2023'
/*Insertar Usuarios*/
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEmpleados_Reactivar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Reactivar EMPLEADOS*/
CREATE   PROCEDURE [Gral].[UDP_tbEmpleados_Reactivar]
	@empl_Id					INT,
	@usua_UsuarioActivacion		INT,
	@empl_FechaActivacion		DATETIME
AS
BEGIN
	BEGIN TRY	
			UPDATE	Gral.tbEmpleados
			SET		empl_Estado = 1,
					usua_UsuarioActivacion = @usua_UsuarioActivacion,
					empl_FechaActivacion = @empl_FechaActivacion
			WHERE	empl_Id = @empl_Id

			UPDATE Acce.tbUsuarios
			SET usua_Estado = 1
			WHERE empl_Id = @empl_Id

			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEstadosCiviles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Estados Civiles*/
CREATE   PROCEDURE [Gral].[UDP_tbEstadosCiviles_Editar] 
	@escv_Id					INT,
	@escv_Nombre				NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@escv_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Gral.tbEstadosCiviles
		SET		escv_Nombre = @escv_Nombre,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				escv_FechaModificacion = @escv_FechaModificacion
		WHERE	escv_Id = @escv_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEstadosCiviles_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar estados civiles*/

CREATE   PROCEDURE [Gral].[UDP_tbEstadosCiviles_Eliminar]  
	@escv_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@escv_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
				DECLARE @respuesta INT
				EXEC dbo.UDP_ValidarReferencias 'escv_Id', @escv_Id, 'Gral.tbEstadosCiviles', @respuesta OUTPUT

				SELECT @respuesta AS Resultado
				IF(@respuesta) = 1
					BEGIN
						UPDATE	Gral.tbEstadosCiviles
						SET		escv_Estado = 0,
								usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
								escv_FechaEliminacion = @escv_FechaEliminacion
						WHERE	escv_Id = @escv_Id
					END
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END


GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEstadosCiviles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar estados civiles*/

CREATE   PROCEDURE [Gral].[UDP_tbEstadosCiviles_Insertar] --'prueba1', 1, '2023-07-28 14:26:31.000'
	@escv_Nombre			NVARCHAR(150),
	@escv_EsAduana			BIT,
	@usua_UsuarioCreacion	INT,
	@escv_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
	IF EXISTS (SELECT * FROM Gral.tbEstadosCiviles
						WHERE escv_Nombre = @escv_Nombre
						AND escv_Estado = 0 AND escv_EsAduana = @escv_EsAduana)
		BEGIN 
		   UPDATE Gral.tbEstadosCiviles
			SET	   escv_Estado = 1
			WHERE  escv_Nombre = @escv_Nombre

			SELECT 1
		END
		ELSE
		BEGIN
		INSERT INTO Gral.tbEstadosCiviles(escv_Nombre,
										  escv_EsAduana,
		                                  usua_UsuarioCreacion, 
										  escv_FechaCreacion)
			  VALUES (@escv_Nombre,
					  @escv_EsAduana,
			          @usua_UsuarioCreacion, 
					  @escv_FechaCreacion)
			SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbEstadosCiviles_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-----------------PROCEDIMIENTOS ALMACENADOS Y VISTAS GENERAL

--**********ESTADOS CIVILES**********--

/*Listar estados civiles*/
CREATE   PROCEDURE [Gral].[UDP_tbEstadosCiviles_Listar]
	@escv_EsAduana		BIT
AS
BEGIN
	SELECT escv_Id,
	       escv_Nombre, 
		   esta.usua_UsuarioCreacion,
		   usuaCrea.usua_Nombre			AS usuarioCreacionNombre,
		   escv_FechaCreacion, 
		   esta.usua_UsuarioModificacion, 
		   usuaModifica.usua_Nombre		AS usuarioModificacionNombre,
		   escv_FechaModificacion, 
		   esta.usua_UsuarioEliminacion, 
		   usuaElimina.usua_Nombre		AS usuarioEliminacionNombre,
		   escv_FechaEliminacion, 
		   escv_Estado
    FROM Gral.tbEstadosCiviles esta
	INNER JOIN Acce.tbUsuarios usuaCrea		ON esta.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica  ON esta.usua_UsuarioModificacion = usuaModifica.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaElimina   ON esta.usua_UsuarioEliminacion = usuaElimina.usua_Id
	WHERE escv_Estado = 1 AND escv_EsAduana = @escv_EsAduana
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbFormas_Envio_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar FORMAS DE ENVIO*/
CREATE   PROCEDURE [Gral].[UDP_tbFormas_Envio_Editar]
(
	@foen_Id					INT,
	@foen_Codigo                CHAR(2),
	@foen_Descripcion			NVARCHAR(500),
	@usua_UsuarioModificacion	INT,
	@foen_FechaModificacion		DATETIME
)
AS
BEGIN
	BEGIN TRY

		IF EXISTS (SELECT foen_Id 
				   FROM Gral.tbFormas_Envio
				   WHERE foen_Descripcion = @foen_Descripcion
				   AND foen_Estado = 0)
			BEGIN
				DELETE FROM Gral.tbFormas_Envio
				WHERE foen_Descripcion = @foen_Descripcion
				AND foen_Estado = 0
			END

		UPDATE Gral.tbFormas_Envio
		   SET foen_Codigo = @foen_Codigo,
		       foen_Descripcion = @foen_Descripcion,
			   usua_UsuarioModificacion = @usua_UsuarioModificacion,
			   foen_FechaModificacion = @foen_FechaModificacion
		 WHERE foen_Id = @foen_Id
		   AND foen_Estado = 1

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbFormas_Envio_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar FORMAS DE ENVIO*/
CREATE   PROCEDURE [Gral].[UDP_tbFormas_Envio_Eliminar]
(
	@foen_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@foen_FechaEliminacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'foen_Id', @foen_Id, 'Gral.tbFormas_Envio', @respuesta OUTPUT
		
		IF(@respuesta) = 1
		BEGIN
			UPDATE Gral.tbFormas_Envio
			   SET foen_Estado = 0,
				   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				   foen_FechaEliminacion = @foen_FechaEliminacion
			 WHERE foen_Id = @foen_Id
		END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbFormas_Envio_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar FORMAS DE ENVIO*/
CREATE   PROCEDURE [Gral].[UDP_tbFormas_Envio_Insertar] 
(   @foen_Codigo            CHAR(2),
	@foen_Descripcion		NVARCHAR(500),
	@usua_UsuarioCreacion	INT,
	@foen_FechaCreacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * 
					 FROM Gral.tbFormas_Envio
					WHERE foen_Descripcion = @foen_Descripcion
					  AND foen_Estado = 0)
		BEGIN
			UPDATE Gral.tbFormas_Envio
			   SET foen_Estado = 1,
			       foen_Codigo = @foen_Codigo
			 WHERE foen_Descripcion = @foen_Descripcion
		END
		ELSE
		BEGIN
			INSERT INTO Gral.tbFormas_Envio (foen_Codigo,foen_Descripcion, usua_UsuarioCreacion, foen_FechaCreacion)
			VALUES (@foen_Codigo,@foen_Descripcion, @usua_UsuarioCreacion, @foen_FechaCreacion)
		END
		
		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbFormas_Envio_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************FORMAS DE ENVIO******************--
/*Listar FORMAS DE ENVIO*/
CREATE     PROCEDURE [Gral].[UDP_tbFormas_Envio_Listar]
AS
BEGIN
SELECT	foen_Id											,
        foen_Codigo                                     ,
		foen_Descripcion								,
		formasEnvio.usua_UsuarioCreacion				,
		usuarioCreacion.usua_Nombre						AS usuarioCreacionNombre,
		foen_FechaCreacion								,
		formasEnvio.usua_UsuarioModificacion			,
		usuarioModificacion.usua_Nombre					AS usuarioModificacionNombre,
		foen_FechaModificacion							,
		usuarioEliminacion.usua_Nombre					AS usuarioEliminacionNombre,
		foen_FechaEliminacion							,
		foen_Estado							
FROM	Gral.tbFormas_Envio formasEnvio
		INNER JOIN Acce.tbUsuarios usuarioCreacion		ON formasEnvio.usua_UsuarioCreacion = usuarioCreacion.usua_Id
		LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON formasEnvio.usua_UsuarioModificacion = usuarioModificacion.usua_Id
		LEFT JOIN Acce.tbUsuarios usuarioEliminacion	ON formasEnvio.usua_UsuarioEliminacion = usuarioEliminacion.usua_Id
WHERE	foen_Estado = 1
END

GO
/****** Object:  StoredProcedure [Gral].[UDP_tbMonedas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar monedas*/
CREATE   PROCEDURE [Gral].[UDP_tbMonedas_Editar]
	@mone_Id					INT,
	@mone_Codigo				CHAR(3),
	@mone_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@mone_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Gral.tbMonedas
		SET		mone_Descripcion = @mone_Descripcion,
				mone_Codigo = @mone_Codigo,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				mone_FechaModificacion = @mone_FechaModificacion
		WHERE	mone_Id = @mone_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbMonedas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar monedas*/
CREATE   PROCEDURE [Gral].[UDP_tbMonedas_Insertar] 
	@mone_Codigo			CHAR(3),
	@mone_EsAduana			BIT,
	@mone_Descripcion		NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@mone_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
				INSERT INTO Gral.tbMonedas ( mone_Codigo,
											 mone_EsAduana,
												 mone_Descripcion, 
											     usua_UsuarioCreacion, 
											     mone_FechaCreacion)
			VALUES(@mone_Codigo,
				   @mone_EsAduana,
				   @mone_Descripcion,	
				   @usua_UsuarioCreacion,
				   @mone_FechaCreacion)


			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error_Message: ' + ERROR_MESSAGE () 
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbMonedas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--**********MONEDAS**********--

/*Listar monedas*/
CREATE   PROCEDURE [Gral].[UDP_tbMonedas_Listar]
	@mone_EsAduana	BIT
AS
BEGIN
	SELECT  mone_Id								
	       ,mone_Codigo			
		   ,mone_EsAduana
	       ,mone_Descripcion					
	       ,mone.usua_UsuarioCreacion			
	       ,usuaCrea.usua_Nombre				AS usuarioCreacionNombre
	       ,mone_FechaCreacion					
	       ,mone.usua_UsuarioModificacion		
	       ,usuaModifica.usua_Nombre			AS usuarioModificacionNombre
	       ,mone_FechaModificacion				
	       --,mone.usua_UsuarioEliminacion		
	       --,usuaElimina.usua_Nombre				AS usuarioEliminacionNombre
	       --,mone_FechaEliminacion				
	       ,mone_Estado							
   FROM Gral.tbMonedas mone 
   INNER JOIN Acce.tbUsuarios usuaCrea		ON mone.usua_UsuarioCreacion = usuaCrea.usua_Id 
   LEFT JOIN Acce.tbUsuarios usuaModifica   ON mone.usua_UsuarioModificacion = usuaModifica.usua_Id 
   --LEFT JOIN Acce.tbUsuarios usuaModifica   ON mone.usua_UsuarioModificacion = usuaCrea.usua_Id 
   --LEFT JOIN Acce.tbUsuarios usuaElimina	ON mone.usua_UsuarioEliminacion = usuaCrea.usua_Id
   WHERE mone_Estado = 1
   AND mone_EsAduana = @mone_EsAduana
   OR @mone_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficinas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar oficinas*/
CREATE   PROCEDURE [Gral].[UDP_tbOficinas_Editar] 
	@ofic_Id					INT,
	@ofic_Nombre				NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@ofic_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT ofic_Id
				   FROM Gral.tbOficinas
				   WHERE ofic_Nombre = @ofic_Nombre
				   AND ofic_Estado = 0)
			BEGIN
				DELETE FROM Gral.tbOficinas
				WHERE ofic_Nombre = @ofic_Nombre
				AND ofic_Estado = 0
			END

		UPDATE  Gral.tbOficinas
		SET		ofic_Nombre = @ofic_Nombre,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				ofic_FechaModificacion = @ofic_FechaModificacion
		WHERE	ofic_Id = @ofic_Id
				
		SELECT 1
		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficinas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar oficinas*/
CREATE   PROCEDURE [Gral].[UDP_tbOficinas_Eliminar] 
	@ofic_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@ofic_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'ofic_Id', @ofic_Id, 'gral.tbOficinas', @respuesta OUTPUT

			SELECT @respuesta AS Resultado
			IF(@respuesta) = 1
				BEGIN
					UPDATE	Gral.tbOficinas
					SET		ofic_Estado = 0,
							usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
							ofic_FechaEliminacion = @ofic_FechaEliminacion
					WHERE	ofic_Id = @ofic_Id
				END
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficinas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar oficinas*/
CREATE   PROCEDURE [Gral].[UDP_tbOficinas_Insertar] 
	@ofic_Nombre			NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@ofic_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY

		IF EXISTS (SELECT * FROM Gral.tbOficinas
						WHERE @ofic_Nombre = ofic_Nombre
						AND ofic_Estado = 0)
		BEGIN
			UPDATE Gral.tbOficinas
			SET	   ofic_Estado = 1
			WHERE  ofic_Nombre = @ofic_Nombre

			SELECT 1
		END
		ELSE 
			BEGIN
				INSERT INTO Gral.tbOficinas (ofic_Nombre, 
											     usua_UsuarioCreacion, 
											     ofic_FechaCreacion)
			VALUES(@ofic_Nombre,	
				   @usua_UsuarioCreacion,
				   @ofic_FechaCreacion)


			SELECT 1
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficinas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Listar oficinas*/
CREATE   PROCEDURE [Gral].[UDP_tbOficinas_Listar]
AS
BEGIN
	SELECT	ofic_Id							
			,ofic_Nombre					
			,ofic.usua_UsuarioCreacion		
			,usuaCrea.usua_Nombre			AS usuarioCreacionNombre
			,ofic_FechaCreacion				
			,ofic.usua_UsuarioModificacion	 
			,usuaModifica.usua_Nombre		AS usuarioModificacionNombre
			,ofic_FechaModificacion			
			,ofic.usua_UsuarioEliminacion	 
			,usuaElimina.usua_Nombre		AS usuarioEliminacionNombre
			,ofic_FechaEliminacion			 
			,ofic_Estado						
	FROM Gral.tbOficinas ofic 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON ofic.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica  ON ofic.usua_UsuarioModificacion = usuaModifica.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaElimina   ON ofic.usua_UsuarioEliminacion = usuaElimina.usua_Id
	WHERE ofic_Estado = 1
	ORDER BY ofic_FechaCreacion DESC
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficio_Profesiones_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar oficio/profesión*/
CREATE   PROCEDURE [Gral].[UDP_tbOficio_Profesiones_Editar] 
	@ofpr_Id					INT,
	@ofpr_Nombre				NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@ofpr_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Gral.tbOficio_Profesiones
		SET		ofpr_Nombre = @ofpr_Nombre,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				ofpr_FechaModificacion = @ofpr_FechaModificacion
		WHERE	ofpr_Id = @ofpr_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficio_Profesiones_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar oficio/profesión*/
CREATE   PROCEDURE [Gral].[UDP_tbOficio_Profesiones_Insertar] 
	@ofpr_Nombre			NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@ofpr_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY

		INSERT INTO Gral.tbOficio_Profesiones (ofpr_Nombre, 
														   usua_UsuarioCreacion, 
														   ofpr_FechaCreacion)
			VALUES(@ofpr_Nombre,	
				   @usua_UsuarioCreacion,
				   @ofpr_FechaCreacion)


			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbOficio_Profesiones_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Listar oficio/profesión*/
CREATE   PROCEDURE [Gral].[UDP_tbOficio_Profesiones_Listar]
AS
BEGIN
	SELECT ofpr_Id							
			,ofpr_Nombre					
			,ofpr.usua_UsuarioCreacion		 
			,usuaCrea.usua_Nombre			AS usuarioCreacionNombre
			,ofpr_FechaCreacion				 
			,ofpr.usua_UsuarioModificacion	 
			,usuaModifica.usua_Nombre		AS usuarioModificacionNombre
			,ofpr_FechaModificacion			
			,ofpr_Estado					
	FROM Gral.tbOficio_Profesiones ofpr 
	INNER JOIN Acce.tbUsuarios usuaCrea		ON ofpr.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica	ON ofpr.usua_UsuarioModificacion = usuaModifica.usua_Id 
	WHERE ofpr_Estado = 1
	ORDER BY ofpr_FechaCreacion DESC
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbPaises_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Paises*/
CREATE   PROCEDURE [Gral].[UDP_tbPaises_Editar]
	@pais_Id						INT,
	@pais_Codigo					CHAR(2),
	@pais_Nombre					NVARCHAR(150),
	@pais_prefijo					NVARCHAR(4),
	@usua_UsuarioModificacion		INT,
	@pais_FechaModificacion	DATETIME

AS
BEGIN

	BEGIN TRY		
		UPDATE Gral.tbPaises
		SET pais_Nombre = @pais_Nombre,pais_Codigo = @pais_Codigo,pais_prefijo = @pais_prefijo, 
		usua_UsuarioModificacion = @usua_UsuarioModificacion, pais_FechaModificacion = @pais_FechaModificacion
		WHERE pais_Id = @pais_Id
		SELECT 1
	END TRY
BEGIN CATCH
		SELECT 'Error Message: '+ ERROR_MESSAGE();
END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbPaises_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar PAISES*/
CREATE   PROCEDURE [Gral].[UDP_tbPaises_Insertar]
	@pais_Codigo				CHAR(2), 
	@pais_Nombre				NVARCHAR(150),
	@pais_prefijo				NVARCHAR(4),
	@pais_EsAduana				BIT,
	@usua_UsuarioCreacion		INT,
	@pais_FechaCreacion			DATETIME

AS
BEGIN
	BEGIN TRY 
		IF EXISTS (SELECT * FROM Gral.tbPaises WHERE @pais_Nombre = pais_Nombre		
				   AND pais_Estado = 0)
		BEGIN
			UPDATE Gral.tbPaises
			SET	  pais_Estado = 1
			WHERE pais_Nombre = @pais_Nombre

			SELECT 1
		END
		ELSE
		BEGIN
			INSERT INTO Gral.tbPaises (pais_Codigo, 
									   pais_Nombre, 
									   pais_EsAduana,
									   pais_prefijo,
									   usua_UsuarioCreacion, 
									   pais_FechaCreacion)
			VALUES (@pais_Codigo, 
					@pais_Nombre, 
					@pais_EsAduana,
					@pais_prefijo,
					@usua_UsuarioCreacion, 
					@pais_FechaCreacion)
			SELECT 1
		END

	END TRY

	BEGIN CATCH
		SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbPaises_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Gral].[UDP_tbPaises_Listar]
	@pais_EsAduana			BIT
AS
BEGIN
	
SELECT	pais_Id								,
		pais_Codigo							,
		Gral.ProperCase(pais_Nombre)		AS pais_Nombre,
		pais_EsAduana						,
		pais_prefijo						,
		pais.usua_UsuarioCreacion			,
		usua.usua_Nombre					AS UsuarioCreacionNombre,
		pais_FechaCreacion					, 
		pais.usua_UsuarioModificacion		,
		usua2.usua_Nombre					AS UsuarioModificadorNombre,
		pais_FechaModificacion				,
		pais_Estado							
FROM	Gral.tbPaises pais						 
		INNER JOIN Acce.tbUsuarios usua		ON pais.usua_UsuarioCreacion = usua.usua_Id 
		LEFT JOIN  Acce.tbUsuarios usua2	ON pais.usua_UsuarioModificacion = usua2.usua_Id
WHERE	pais_Estado = 1
AND		pais_EsAduana = @pais_EsAduana
OR		@pais_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProveedores_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar PROVEEDORES*/
CREATE   PROCEDURE [Gral].[UDP_tbProveedores_Editar]
@prov_Id						INT,
@prov_NombreCompania			NVARCHAR(200), 
@prov_NombreContacto			NVARCHAR(200), 
@prov_Telefono					NVARCHAR(20), 
@prov_CodigoPostal				VARCHAR(5), 
@prov_Ciudad					INT, 
@prov_DireccionExacta			NVARCHAR(350), 
@prov_CorreoElectronico			NVARCHAR(250), 
@prov_Fax						NVARCHAR(20), 
@usua_UsuarioModificacion		INT,
@prov_FechaModificacion			DATETIME
AS
BEGIN
	
	BEGIN TRY
		
			UPDATE Gral.tbProveedores SET prov_NombreCompania = @prov_NombreCompania, prov_Ciudad = @prov_Ciudad, prov_CodigoPostal = @prov_CodigoPostal,
			prov_CorreoElectronico = @prov_CorreoElectronico, prov_DireccionExacta = @prov_DireccionExacta, prov_NombreContacto = @prov_NombreContacto,
			prov_Fax = @prov_Fax, prov_Telefono = @prov_Telefono, prov_FechaModificacion = @prov_FechaModificacion, usua_UsuarioModificacion = @usua_UsuarioModificacion
			WHERE prov_Id = @prov_Id
			SELECT 1
		
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProveedores_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar PROVEEDORES*/
CREATE   PROCEDURE [Gral].[UDP_tbProveedores_Eliminar]
(
	@prov_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@prov_FechaEliminacion		DATETIME
)
AS
BEGIN
	
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'prov_Id', @prov_Id, 'Gral.tbProveedores', @respuesta OUTPUT

		
		IF(@respuesta) = 1
			BEGIN
				 UPDATE Gral.tbProveedores
					SET prov_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						prov_FechaEliminacion = @prov_FechaEliminacion
				  WHERE prov_Id = @prov_Id 
					AND prov_Estado = 1
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();	
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProveedores_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar PROVEEDORES*/
CREATE   PROCEDURE [Gral].[UDP_tbProveedores_Insertar]
@prov_NombreCompania			NVARCHAR(200), 
@prov_NombreContacto			NVARCHAR(200), 
@prov_Telefono					NVARCHAR(20), 
@prov_CodigoPostal				VARCHAR(5), 
@prov_Ciudad					INT, 
@prov_DireccionExacta			NVARCHAR(350), 
@prov_CorreoElectronico			NVARCHAR(250), 
@prov_Fax						NVARCHAR(20), 
@usua_UsuarioCreacion			INT,
@prov_FechaCreacion				DATETIME
AS
BEGIN
	
	BEGIN TRY
		IF EXISTS (SELECT*FROM Gral.tbProveedores WHERE prov_NombreCompania = @prov_NombreCompania AND prov_Estado = 0)
		BEGIN
			UPDATE Gral.tbProveedores 
			SET prov_Estado = 1
			WHERE prov_NombreCompania = @prov_NombreCompania

			SELECT 1
		END
		ELSE
		BEGIN
			INSERT INTO Gral.tbProveedores(prov_NombreCompania, 
										   prov_NombreContacto, 
										   prov_Telefono, 
										   prov_CodigoPostal, 
										   prov_Ciudad, 
										   prov_DireccionExacta, 
										   prov_CorreoElectronico, 
										   prov_Fax, 
										   usua_UsuarioCreacion, 
										   prov_FechaCreacion)
			VALUES(@prov_NombreCompania, 
				   @prov_NombreContacto, 
				   @prov_Telefono, 
				   @prov_CodigoPostal, 
				   @prov_Ciudad, 
				   @prov_DireccionExacta, 
				   @prov_CorreoElectronico, 
				   @prov_Fax, 
				   @usua_UsuarioCreacion, 
				   @prov_FechaCreacion)
			SELECT 1
		END
	END TRY

	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProveedores_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--************PROVEEDORES******************--
/*Listar PROVEEDORES*/
CREATE   PROCEDURE [Gral].[UDP_tbProveedores_Listar]
AS
BEGIN
SELECT	prov_Id								,
		prov_NombreCompania 				,
		prov_NombreContacto 				,
		prov_Telefono						,
		prov_CodigoPostal 					,
		prov_Ciudad							,
		ciu.ciud_Nombre						,
		provi.pvin_Id						,
		provi.pvin_Nombre					,
		pais.pais_Nombre					,
		pais.pais_Codigo					,
		pais.pais_Id						,
		prov_DireccionExacta 				,
		prov_CorreoElectronico				,
		prov_Fax 							,
		prov.usua_UsuarioCreacion			,
		usu1.usua_Nombre					AS UsuarioCreacionNombre,
		prov_FechaCreacion	 				, 
		prov.usua_UsuarioModificacion		,
		usu2.usua_Nombre					AS UsuarioModificadorNombre,
		prov.usua_UsuarioEliminacion,
		prov_FechaEliminacion,
		usu3.usua_Nombre 					AS UsuarioEliminacionNombre,
		prov_FechaModificacion	 			,
		prov.usua_UsuarioEliminacion		,
		usu3.usua_Nombre					AS UsuarioEliminacionNombre,
		prov.prov_FechaEliminacion,
		prov_Estado
FROM	Gral.tbProveedores prov					
		INNER JOIN Gral.tbCiudades ciu	ON prov.prov_Ciudad = ciu.ciud_Id				
		INNER JOIN Acce.tbUsuarios usu1		ON prov.usua_UsuarioCreacion = usu1.usua_Id		
		LEFT JOIN  Acce.tbUsuarios usu2		ON prov.usua_UsuarioModificacion = usu2.usua_Id 
		LEFT JOIN  Acce.tbUsuarios usu3		ON prov.usua_UsuarioEliminacion	= usu3.usua_Id
		INNER JOIN Gral.tbProvincias provi	ON ciu.pvin_Id = provi.pvin_Id					
		INNER JOIN Gral.tbPaises pais		ON provi.pais_Id = pais.pais_Id
WHERE	prov_Estado = 1
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProvincias_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UDP Eliminación Provincias
CREATE   PROCEDURE [Gral].[UDP_tbProvincias_Eliminar]
	@pvin_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@pvin_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
				DECLARE @respuesta INT
				EXEC dbo.UDP_ValidarReferencias 'pvin_Id', @pvin_Id, 'Gral.tbProvincias', @respuesta OUTPUT

				SELECT @respuesta AS Resultado
				IF(@respuesta) = 1
					BEGIN
						UPDATE	Gral.tbProvincias
						SET		pvin_Estado = 0,
								usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
								pvin_FechaEliminacion = @pvin_FechaEliminacion
						WHERE	pvin_Id = @pvin_Id
					END
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProvincias_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Provincias*/
CREATE   PROCEDURE [Gral].[UDP_tbProvincias_Insertar]
 @pvin_Nombre				NVARCHAR(150), 
 @pvin_EsAduana				BIT,
 @pvin_Codigo				NVARCHAR(20), 
 @pais_Id					INT, 
 @usua_UsuarioCreacion		INT,
 @pvin_FechaCreacion		DATETIME

AS
BEGIN
	
	BEGIN TRY
		IF EXISTS (SELECT*FROM Gral.tbProvincias WHERE pvin_Nombre = @pvin_Nombre AND pvin_Estado = 0)
		BEGIN
			UPDATE Gral.tbProvincias SET pvin_Estado = 1 WHERE  @pvin_Nombre = pvin_Nombre
		SELECT 1
		END
		ELSE
		BEGIN
			INSERT INTO Gral.tbProvincias (pvin_Nombre, pvin_EsAduana, pvin_Codigo, pais_Id, usua_UsuarioCreacion, pvin_FechaCreacion)
			VALUES(@pvin_Nombre, @pvin_EsAduana, @pvin_Codigo, @pais_Id, @usua_UsuarioCreacion, @pvin_FechaCreacion)
			SELECT 1
		END		
	END TRY

	BEGIN CATCH 
			SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProvincias_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************PROVINCIAS******************--
/*Listar Provincias*/
CREATE   PROCEDURE [Gral].[UDP_tbProvincias_Listar]
	@pvin_EsAduana		BIT
AS
BEGIN
SELECT	pvin_Id								,
		pvin_Nombre							,
		pvin_EsAduana							,
		pvin_Codigo							,
		provin.pais_Id 						,
		pais.pais_Nombre					AS pais_Nombre,
		provin.usua_UsuarioCreacion			,
		usua1.usua_Nombre					AS UsuarioCreacionNombre,
		pvin_FechaCreacion	 				, 
		provin.usua_UsuarioModificacion		,
		usua2.usua_Nombre					AS UsuarioModificadorNombre,
		pvin_FechaModificacion				,
		provin.usua_UsuarioEliminacion		,
		usua3.usua_Nombre					AS UsuarioEliminacionNombre,
		provin.pvin_FechaEliminacion		,
		pvin_Estado
FROM	Gral.tbProvincias provin				
		INNER JOIN Gral.tbPaises pais		ON provin.pais_Id =  pais.pais_Id		
		INNER JOIN Acce.tbUsuarios usua1	ON provin.usua_UsuarioCreacion = usua1.usua_Id	
		LEFT JOIN Acce.tbUsuarios usua2		ON provin.usua_UsuarioModificacion = usua2.usua_Id 
		LEFT JOIN Acce.tbUsuarios usua3		ON provin.usua_UsuarioEliminacion = usua3.usua_Id
WHERE	pvin_Estado = 1
AND		pvin_EsAduana = @pvin_EsAduana
OR		@pvin_EsAduana IS NULL
END


GO
/****** Object:  StoredProcedure [Gral].[UDP_tbProvinvias_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Editar Provincias*/
CREATE   PROCEDURE [Gral].[UDP_tbProvinvias_Editar]
 @pvin_Id						INT,
 @pvin_Nombre					NVARCHAR(150), 
 @pvin_Codigo					NVARCHAR(20), 
 @pais_Id						INT, 
 @usua_UsuarioModificacion		INT,
 @pvin_FechaModificacion		DATETIME

AS
BEGIN
	
	BEGIN TRY
    		UPDATE Gral.tbProvincias SET pvin_Nombre = @pvin_Nombre, pvin_Codigo = @pvin_Codigo, pais_Id = @pais_Id,
			pvin_FechaModificacion = @pvin_FechaModificacion, usua_UsuarioModificacion = @usua_UsuarioModificacion
			WHERE pvin_Id = @pvin_Id
			SELECT 1
		
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: '+ ERROR_MESSAGE();
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbUnidadMedidas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Editar UNIDAD DE MEDIDA*/
CREATE   PROCEDURE [Gral].[UDP_tbUnidadMedidas_Editar]
(
	@unme_Id					INT,
	@unme_Descripcion			NVARCHAR(500),
	@usua_UsuarioModificacion	INT,
	@unme_FechaModificacion		DATETIME
)
AS
BEGIN 
	BEGIN TRY

		IF EXISTS (SELECT unme_Id
					   FROM Gral.tbUnidadMedidas
					   WHERE unme_Descripcion = @unme_Descripcion
					   AND unme_Estado = 0)
			BEGIN
				DELETE FROM Gral.tbUnidadMedidas
				WHERE unme_Descripcion = @unme_Descripcion
			    AND unme_Estado = 0
			END

		UPDATE Gral.tbUnidadMedidas
		   SET unme_Descripcion = @unme_Descripcion,
			   usua_UsuarioModificacion = @usua_UsuarioModificacion,
			   unme_FechaModificacion = @unme_FechaModificacion
		 WHERE unme_Id = @unme_Id
		   AND unme_Estado = 1
			
		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbUnidadMedidas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar UNIDAD DE MEDIDA*/
CREATE   PROCEDURE [Gral].[UDP_tbUnidadMedidas_Eliminar]
(
	@unme_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@unme_FechaEliminacion		DATETIME
)
AS
BEGIN 
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'unme_Id', @unme_Id, 'Gral.tbUnidadMedidas', @respuesta OUTPUT
		
		IF(@respuesta = 1)
			BEGIN
				UPDATE Gral.tbUnidadMedidas
				   SET unme_Estado = 0,
					   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
					   unme_FechaEliminacion = @unme_FechaEliminacion
				 WHERE unme_Id = @unme_Id
				   AND unme_Estado = 1
			END

		SELECT @respuesta 
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbUnidadMedidas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar UNIDAD DE MEDIDA*/
CREATE   PROCEDURE [Gral].[UDP_tbUnidadMedidas_Insertar] --'111', 1, '10-16-2004'
(
	@unme_Descripcion		NVARCHAR(500),
	@unme_EsAduana			BIT,
	@usua_UsuarioCreacion	INT,
	@unme_FechaCreacion		DATETIME
)
AS
BEGIN 
	BEGIN TRY
		IF EXISTS (SELECT *
					 FROM Gral.tbUnidadMedidas
					WHERE unme_Descripcion = @unme_Descripcion
					  AND unme_Estado = 0) 
		BEGIN
			UPDATE Gral.tbUnidadMedidas
			   SET unme_Estado = 1
			 WHERE unme_Descripcion = @unme_Descripcion
			   AND unme_Estado = 0
		END
		ELSE
		BEGIN
			INSERT INTO Gral.tbUnidadMedidas (unme_Descripcion, unme_EsAduana, usua_UsuarioCreacion, unme_FechaCreacion)
			VALUES (@unme_Descripcion, @unme_EsAduana, @usua_UsuarioCreacion, @unme_FechaCreacion)
		END

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Mensaje de error: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Gral].[UDP_tbUnidadMedidas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--************UNIDAD DE MEDIDA******************--

/*Listar UNIDAD DE MEDIDA*/
CREATE   PROCEDURE [Gral].[UDP_tbUnidadMedidas_Listar]
	@unme_EsAduana			BIT
AS
BEGIN
SELECT	unme_Id											,
		unme_Descripcion								,
		unme_EsAduana										,
		unidadMedidas.usua_UsuarioCreacion				,
		usuarioCreacion.usua_Nombre						AS usuarioCreacionNombre,
		unme_FechaCreacion								,
		unidadMedidas.usua_UsuarioModificacion			,
		usuarioModificacion.usua_Nombre					AS usuarioModificacionNombre,
		unme_FechaModificacion							,
		usuarioEliminacion.usua_Nombre					AS usuarioEliminacionNombre,
		unme_FechaEliminacion						    ,
		unme_Estado								
FROM Gral.tbUnidadMedidas unidadMedidas
		INNER JOIN Acce.tbUsuarios usuarioCreacion		ON unidadMedidas.usua_UsuarioCreacion = usuarioCreacion.usua_Id
		LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON unidadMedidas.usua_UsuarioModificacion = usuarioModificacion.usua_Id
		LEFT JOIN Acce.tbUsuarios usuarioEliminacion	ON unidadMedidas.usua_UsuarioEliminacion = usuarioEliminacion.usua_Id
WHERE unme_Estado = 1
AND	  unme_EsAduana = @unme_EsAduana
OR	  @unme_EsAduana IS NULL
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_AvanceOrdenCompraByID]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM Prod.tbOrdenCompra

--SELECT * FROM Prod.tbClientes
--GO


-- PROCEDIMIENTO PARA VER EL AVANCE DE LAS ORDENES DE COMPRA SEGUN EL ID 
CREATE   PROCEDURE [Prod].[UDP_AvanceOrdenCompraByID] 
	@orco_Id INT
AS
BEGIN
SELECT 
		ordencompra.orco_Id, 
		ordencompra.orco_FechaEmision, 
		ordencompra.orco_FechaLimite,
		CASE ordencompra.orco_EstadoOrdenCompra
			WHEN 'P' THEN '33%'
			WHEN 'C'THEN '66%'
			WHEN 'T' THEN '100%'
		END AS orco_Avance,
		cliente.clie_Nombre_O_Razon_Social,
		cliente.clie_Direccion, 
		cliente.clie_RTN, 
		cliente.clie_Nombre_Contacto, 
		cliente.clie_Numero_Contacto, 
		cliente.clie_Correo_Electronico, 
		cliente.clie_FAX

FROM		Prod.tbOrdenCompra AS ordencompra
			INNER JOIN Prod.tbClientes AS cliente ON ordencompra.orco_IdCliente = cliente.clie_Id 
WHERE orco_Id = @orco_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_CantidadPrendas_SegunIDEstilo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- EJEMPLO: LA CANTIDAD DE CHAQUETAS QUE SE PIDIERON EN LAS ORDENES DE COMPRA AGRUPADAS POR SEXO (F, M, U)
CREATE   PROCEDURE [Prod].[UDP_CantidadPrendas_SegunIDEstilo]
	@esti_Id INT
AS
BEGIN
	SELECT	 
			SUM(code_CantidadPrenda) AS PrendasSumatoria, 
			code_Sexo,
			esti_Descripcion
	FROM Prod.tbOrdenCompraDetalles AS POdetail
	INNER JOIN Prod.tbEstilos AS Style ON POdetail.esti_Id = Style.esti_Id
	WHERE POdetail.esti_Id = @esti_Id
	GROUP BY code_Sexo, esti_Descripcion
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_ClientesMasProductivos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- CLIENTES MÁS PRODUCTIVOS
CREATE   PROCEDURE [Prod].[UDP_ClientesMasProductivos]
AS
	BEGIN
		SELECT 
				TOP(5)
				Clie.clie_Nombre_O_Razon_Social,
				SUM(Fact.faex_Total) AS CantidadIngresos
		FROM Prod.tbFacturasExportacion AS Fact
		INNER JOIN Prod.tbOrdenCompra AS PO ON Fact.orco_Id = PO.orco_Id
		INNER JOIN Prod.tbClientes AS Clie ON PO.orco_IdCliente = Clie.clie_Id
		GROUP BY Clie.clie_Nombre_O_Razon_Social
	END
GO
/****** Object:  StoredProcedure [Prod].[UDP_ComprobarNoDUCA]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA COMPROBAR SI EL NUMERO DE DUCA EXISTE
CREATE   PROCEDURE [Prod].[UDP_ComprobarNoDUCA]
	@duca_No_Duca NVARCHAR(100)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT duca_Id FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca)
			BEGIN 
				--SELECT duca_No_Duca FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca
				SELECT @duca_No_Duca

			END
		ELSE
			BEGIN
				SELECT 0
			END
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_ContadorOrdenesCompra_PorEstado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA MOSTRAR EL CONTEO DE ORDENES DE COMPRA AGRUPADOS POR ESTADO (Pendiente, En Curso, Terminado)
CREATE   PROCEDURE [Prod].[UDP_ContadorOrdenesCompra_PorEstado]
AS
BEGIN
	SELECT	
			COUNT(orco_Id) AS orco_Conteo, 
			CASE orco_EstadoOrdenCompra
				WHEN 'P' THEN 'Pendiente'
				WHEN 'C'THEN 'En Curso'
				WHEN 'T' THEN 'Terminado'
			END AS orco_Avance
		
	FROM	Prod.tbOrdenCompra
	GROUP BY orco_EstadoOrdenCompra
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_ContadorOrdenesCompra_PorEstado_UltimaSemana]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA MOSTRAR LAS ORDENES DE COMPRA POR ESTADO DE LA ULTIMA SEMANA
CREATE   PROCEDURE [Prod].[UDP_ContadorOrdenesCompra_PorEstado_UltimaSemana]
AS
BEGIN
    DECLARE @FechaInicial DATE, @FechaFinal DATE;
    SET @FechaInicial = DATEADD(DAY, -7, GETDATE()); 
    SET @FechaFinal = GETDATE();

	SELECT	
			COUNT(orco_Id) AS orco_Conteo, 
			CASE orco_EstadoOrdenCompra
				WHEN 'P' THEN 'Pendiente'
				WHEN 'T' THEN 'Terminado'
			END AS orco_Avance
	FROM	Prod.tbOrdenCompra
	WHERE orco_FechaCreacion BETWEEN @FechaInicial AND @FechaFinal
	GROUP BY orco_EstadoOrdenCompra
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_CostosMaterialesNoBrindados]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_CostosMaterialesNoBrindados] 
	@mate_FechaInicio		DATE,
	@mate_FechaLimite			DATE
AS
BEGIN
	SELECT	mate.mate_Descripcion,
		    (SUM(peod.prod_Cantidad)) as TotalCantidad,
			CONVERT( DECIMAL(18,2), (CONVERT(DECIMAL(18,2), SUM(peod.prod_Cantidad) * 100)) / CONVERT(DECIMAL(18,2),(SELECT SUM(prod_Cantidad)FROM Prod.tbPedidosOrdenDetalle))) AS PorcentajeProductos,
			AVG(peod.prod_Precio) AS PrecioPromedioMaterial
		FROM Prod.tbPedidosOrdenDetalle peod  LEFT JOIN Prod.tbMateriales mate ON peod.mate_Id = mate.mate_Id
		WHERE peod.prod_FechaCreacion BETWEEN @mate_FechaInicio AND @mate_FechaLimite
		GROUP BY mate.mate_Descripcion;
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_DibujarDetalles]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_DibujarDetalles]
	@orco_Codigo NVARCHAR(100)
AS
BEGIN
	SELECT	orden.orco_Id, code_Id, code_CantidadPrenda, estilos.esti_Descripcion, [tall_Nombre]  , proc_IdActual, [proc_Descripcion], [code_FechaProcActual]
	FROM	[Prod].[tbOrdenCompraDetalles] orderdet	INNER JOIN [Prod].[tbOrdenCompra] orden
	ON		orderdet.orco_Id = orden.orco_Id		INNER JOIN [Prod].[tbEstilos] estilos
	ON		orderdet.esti_Id = estilos.esti_Id		INNER JOIN [Prod].[tbTallas] tallas
	ON		orderdet.tall_Id = tallas.tall_Id		INNER JOIN [Prod].[tbProcesos] procesos
	ON		orderdet.proc_IdActual = procesos.proc_Id
	WHERE	orco_Codigo = @orco_Codigo
	ORDER BY code_FechaProcActual ASC
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_DibujarProcesos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_DibujarProcesos]
	@orco_Codigo NVARCHAR(100)
AS
BEGIN
SELECT	DISTINCT 
		proce.proc_Descripcion,
		proce.proc_CodigoHTML,
		procxorder.proc_Id
FROM	[Prod].[tbProcesoPorOrdenCompraDetalle] procxorder	INNER JOIN [Prod].[tbProcesos] proce
ON		procxorder.proc_Id = proce.proc_Id					INNER JOIN [Prod].[tbOrdenCompraDetalles] orderdet
ON		procxorder.code_Id = orderdet.code_Id				INNER JOIN [Prod].[tbOrdenCompra] orderhead
ON		orderdet.orco_Id = orderhead.orco_Id
WHERE	orco_Codigo = @orco_Codigo
ORDER BY procxorder.proc_Id DESC;
END


-- ///
GO
/****** Object:  StoredProcedure [Prod].[UDP_DUCAsDDL]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA LISTAR LAS DUCAS 
CREATE   PROCEDURE [Prod].[UDP_DUCAsDDL]
AS
BEGIN
	SELECT duca_Id ,duca_No_Duca FROM Adua.tbDuca
	WHERE duca_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_OrdenCompra_Delete]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_OrdenCompra_Delete] 
  @orco_Id INT
AS 
BEGIN
BEGIN TRY 
 DECLARE @code_Id INT;
  DECLARE cur CURSOR FOR
    SELECT code_Id FROM Prod.tbOrdenCompraDetalles WHERE orco_Id = @orco_Id;

  OPEN cur;
  FETCH NEXT FROM cur INTO @code_Id;

  WHILE @@FETCH_STATUS = 0
  BEGIN
	DELETE FROM Prod.tbProcesoPorOrdenCompraDetalle WHERE code_Id = @code_Id;
    DELETE FROM Prod.tbDocumentosOrdenCompraDetalles WHERE code_Id = @code_Id;
	DELETE FROM Prod.tbMaterialesBrindar WHERE code_Id = @code_Id;
    FETCH NEXT FROM cur INTO @code_Id;
  END;

  CLOSE cur;
  DEALLOCATE cur;

  DELETE FROM Prod.tbOrdenCompraDetalles WHERE orco_Id = @orco_Id;
  DELETE FROM Prod.tbOrdenCompra WHERE orco_Id = @orco_Id

  SELECT 1
END TRY 
BEGIN CATCH
		SELECT 'Error Message: 'ERROR_MESSAGE;
END CATCH
END;

GO
/****** Object:  StoredProcedure [Prod].[UDP_OrdenCompra_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_OrdenCompra_Finalizado] 
  @orco_Id                   INT
AS
BEGIN
 BEGIN TRY
     UPDATE Prod.tbOrdenCompra
	 SET    orco_EstadoFinalizado = 1
	 WHERE  orco_Id = @orco_Id 
	 SELECT 1
 END TRY
 BEGIN CATCH
 		SELECT 'Error Message: 'ERROR_MESSAGE;
 END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_OrdenCompraDataToExport]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_OrdenCompraDataToExport]
AS
BEGIN
		SELECT	 
			ordenCompra.orco_Id
			,cliente.clie_Nombre_O_Razon_Social
			,cliente.clie_Direccion
			,cliente.clie_RTN
			,cliente.clie_Nombre_Contacto
			,cliente.clie_Numero_Contacto
			,cliente.clie_Correo_Electronico
			,cliente.clie_FAX
			,ordenCompra.orco_FechaEmision
			,ordenCompra.orco_FechaLimite
			,ordenCompra.orco_Materiales
			,fomapago.fopa_Descripcion
			,tipoEmbajale.tiem_Descripcion
			,ordenCompra.orco_EstadoOrdenCompra
			,ordenCompra.orco_DireccionEntrega
			,(
			
			SELECT	 ordenCompraDetalle.code_Id
					,ordenCompraDetalle.orco_Id
					,ordenCompraDetalle.code_CantidadPrenda
					,estilo.esti_Descripcion
					,talla.tall_Nombre
					,ordenCompraDetalle.code_Sexo
					,colores.colr_Nombre
					,ordenCompraDetalle.code_Unidad
					,ordenCompraDetalle.code_Valor
					,ordenCompraDetalle.code_Impuesto
					,ordenCompraDetalle.code_EspecificacionEmbalaje
			  FROM	Prod.tbOrdenCompraDetalles			    ordenCompraDetalle
					INNER JOIN	Prod.tbEstilos				estilo						ON	ordenCompraDetalle.esti_Id						= estilo.esti_Id
					INNER JOIN	Prod.tbTallas				talla						ON	ordenCompraDetalle.tall_Id						= talla.tall_Id
					INNER JOIN  Prod.tbColores				colores						ON	ordenCompraDetalle.colr_Id						= colores.colr_Id
					WHERE ordenCompraDetalle.orco_Id	=	ordenCompra.orco_Id FOR JSON PATH
			) AS Detalles
		FROM  Prod.tbOrdenCompra							ordenCompra
			INNER JOIN  Prod.tbClientes					cliente				ON ordenCompra.orco_IdCliente  = cliente.clie_Id
			INNER JOIN  Prod.tbTipoEmbalaje				tipoEmbajale		ON ordenCompra.orco_IdEmbalaje = tipoEmbajale.tiem_Id
			INNER JOIN	Adua.tbFormasdePago				fomapago			ON ordenCompra.orco_MetodoPago = fomapago.fopa_Id
		WHERE ordenCompra.orco_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_OrdenesCompraDDL]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- PROCEDIMIENTO PARA LISTAR LAS ORDENES DE COMPRA QUE SI POSEEN ITEMS
CREATE   PROCEDURE [Prod].[UDP_OrdenesCompraDDL]
AS
BEGIN
	SELECT DISTINCT(PO.orco_Id), CONCAT('No. ', PO.orco_Codigo, ' - ', Clie.clie_Nombre_O_Razon_Social, ' - ', CONVERT(DATE, PO.orco_FechaEmision)) AS orco_Descripcion 
	FROM Prod.tbOrdenCompra AS PO
	INNER JOIN Prod.tbClientes AS Clie ON PO.orco_IdCliente = Clie.clie_Id
	INNER JOIN Prod.tbOrdenCompraDetalles AS POdetail ON PO.orco_Id = POdetail.orco_Id
	WHERE PO.orco_Estado = 1 AND PO.orco_EstadoOrdenCompra = 'T'
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_PO_EntregadasPendientes_Anualmente]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- TOTAL DE ORDENES DE COMPRA ENTREGADAS Y PENDIENTES DEL AÑO
CREATE   PROCEDURE [Prod].[UDP_PO_EntregadasPendientes_Anualmente]
AS
BEGIN
		SELECT	
					COUNT(orco_Id) AS orco_Conteo, 
					CASE orco_EstadoOrdenCompra
						WHEN 'P' THEN 'Pendiente'
						WHEN 'T' THEN 'Terminado'
					END AS orco_Avance
		FROM		Prod.tbOrdenCompra
		WHERE		(DATEPART(YEAR, orco_FechaCreacion) = DATEPART(YEAR, GETDATE()))
					AND orco_EstadoOrdenCompra IN ('P', 'T')
		GROUP BY	orco_EstadoOrdenCompra
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_PO_EntregadasPendientes_Mensualmente]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- TOTAL DE ORDENES DE COMPRA ENTREGADAS Y PENDIENTES DEL MES
CREATE   PROCEDURE [Prod].[UDP_PO_EntregadasPendientes_Mensualmente]
AS
BEGIN
		SELECT	
					COUNT(orco_Id) AS orco_Conteo, 
					CASE orco_EstadoOrdenCompra
						WHEN 'P' THEN 'Pendiente'
						WHEN 'T' THEN 'Terminado'
					END AS orco_Avance
		FROM		Prod.tbOrdenCompra
		WHERE		(DATEPART(YEAR, orco_FechaCreacion) = DATEPART(YEAR, GETDATE()))
					AND (DATEPART(MONTH, orco_FechaCreacion) = DATEPART(MONTH, GETDATE()))
					AND orco_EstadoOrdenCompra IN ('P', 'T')
		GROUP BY	orco_EstadoOrdenCompra
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_PO_EntregadasPendientes_Semanalmente]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- TOTAL DE ORDENES DE COMPRA ENTREGADAS Y PENDIENTES DE LA SEMANA
CREATE   PROCEDURE [Prod].[UDP_PO_EntregadasPendientes_Semanalmente]
AS
BEGIN
		SELECT	
					COUNT(orco_Id) AS orco_Conteo,
					CASE orco_EstadoOrdenCompra
						WHEN 'P' THEN 'Pendiente'
						WHEN 'T' THEN 'Terminado'
					END AS orco_Avance
		FROM		Prod.tbOrdenCompra
		WHERE		(DATEPART(WEEK, orco_FechaCreacion)) = DATEPART(WEEK, GETDATE())
					AND (DATEPART(YEAR, orco_FechaCreacion) = DATEPART(YEAR, GETDATE()))
					AND (DATEPART(MONTH, orco_FechaCreacion) = DATEPART(MONTH, GETDATE()))
					AND orco_EstadoOrdenCompra IN ('P', 'T')
		GROUP BY	orco_EstadoOrdenCompra
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_PODetallesByID]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PROCEDIMIENTO PARA LISTAR LOS DETALLES (ITEMS) DE LA ORDEN DE COMPRA SELECCIONADA EN EL ENCABEZADO DE LA FACTURA EXPORTACION
CREATE   PROCEDURE [Prod].[UDP_PODetallesByID] 
	@faex_Id INT
AS
BEGIN 
	DECLARE @orco_Id INT = (SELECT orco_Id FROM Prod.tbFacturasExportacion WHERE faex_Id = @faex_Id)

	SELECT code.code_Id ,CONCAT('#: ', code.code_Id, ' - ',esti.esti_Descripcion,' - ',tall.tall_Codigo,' - ',code.code_Sexo,' - ',colr.colr_Nombre) AS code_Descripcion 
	FROM Prod.tbOrdenCompraDetalles code
	INNER JOIN Prod.tbEstilos AS esti ON code.esti_Id = esti.esti_Id
	INNER JOIN Prod.tbTallas AS tall ON code.tall_Id = tall.tall_Id
	INNER JOIN Prod.tbColores AS colr ON code.colr_Id = colr.colr_Id
	WHERE orco_Id = @orco_Id AND code.code_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_ProduccionModulo_CantidadPorcentaje]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- CANTIDAD Y PORCENTAJE DE LAS PRENDAS QUE HAN HECHO POR MODULO
CREATE   PROCEDURE [Prod].[UDP_ProduccionModulo_CantidadPorcentaje]
AS
	BEGIN
		SELECT 
				Modulo.modu_Nombre,
				SUM(ReporteModulo.remo_TotalDia) AS TotalProduccionDia,
				CONVERT( DECIMAL(18,2), (CONVERT(DECIMAL(18,2), SUM(ReporteModulo.remo_TotalDia) * 100)) / CONVERT(DECIMAL(18,2),(SELECT SUM(remo_TotalDia)FROM Prod.tbReporteModuloDia))) AS PorcentajeProduccion
		FROM Prod.tbReporteModuloDia AS ReporteModulo
		INNER JOIN Prod.tbModulos AS Modulo ON ReporteModulo.modu_Id = Modulo.modu_Id
		GROUP BY Modulo.modu_Nombre
	END
GO
/****** Object:  StoredProcedure [Prod].[UDP_Reporte_ProduccionAreas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------------------------------
--REPORTES

CREATE     PROCEDURE [Prod].[UDP_Reporte_ProduccionAreas]
@fechaInicio DATE,
@fechaFin DATE,
@tipa_Id INT
AS
BEGIN
SELECT	area.tipa_area
		,SUM(rdet_TotalDia) AS TotalPeriodo
		,SUM(rdet_TotalDanado) AS TotalDanado
		,SUM(rdet_TotalDia) - SUM(rdet_TotalDanado) AS TotalExitoso
		,AVG(rdet_TotalDia) AS PromedioDia
		,AVG(rdet_TotalDanado) AS PromedioDanado
		,AVG(rdet_TotalDia - rdet_TotalDanado) AS PromedioExitoso
		,(SUM(rdet_TotalDanado) * 100) / CAST (SUM(rdet_TotalDia) AS DECIMAL(18,2)) AS PorcentajeDanado
		,100 - ((SUM(rdet_TotalDanado) * 100) / CAST (SUM(rdet_TotalDia) AS DECIMAL(18,2))) AS PorcentajeBueno
		,(SELECT m.*
			FROM 
			(SELECT  rdd.rdet_Id
					 ,rdd.remo_Id
					 ,rdd.rdet_TotalDia
					 ,rdd.rdet_TotalDanado
					 ,ensa2.code_Id
					 ,code2.esti_Id
					 ,esti.esti_Descripcion
					 ,code2.code_Sexo
					 ,code_Valor
					 ,code2.code_Impuesto
					 ,remd2.remo_Fecha
					 ,orco.orco_Codigo
			  FROM prod.tbReporteModuloDiaDetalle rdd 
			  LEFT JOIN prod.tbReporteModuloDia remd2 ON remd2.remo_Id = rdd.remo_Id
			  LEFT JOIN prod.tbModulos modu2 ON remd2.modu_Id = modu2.modu_Id 
			  LEFT JOIN Prod.tbOrde_Ensa_Acab_Etiq ensa2 ON ensa2.ensa_Id = rdd.ensa_Id
			  LEFT JOIN Prod.tbOrdenCompraDetalles code2 ON code2.code_Id = ensa2.code_Id
			  LEFT JOIN Prod.tbOrdenCompra orco ON orco.orco_Id = code2.orco_Id
			  LEFT JOIN Prod.tbEstilos esti ON esti.esti_Id = code2.esti_Id
			  WHERE rdd.remo_Id IN (
								SELECT remo_Id FROM Prod.tbArea area1 INNER JOIN Prod.tbProcesos prox1
								ON prox1.proc_Id = area1.proc_Id INNER JOIN prod.tbModulos modu1
								ON modu1.proc_Id = prox1.proc_Id INNER JOIN prod.tbReporteModuloDia remd1
								ON remd1.modu_Id = modu1.modu_Id WHERE area1.tipa_Id = area.tipa_Id)			
		)AS m FOR JSON AUTO)
		
		 AS Detalles
FROM Prod.tbArea area INNER JOIN Prod.tbProcesos prox
ON prox.proc_Id = area.proc_Id INNER JOIN prod.tbModulos modu
ON modu.proc_Id = prox.proc_Id INNER JOIN prod.tbReporteModuloDia remd
ON remd.modu_Id = modu.modu_Id INNER JOIN prod.tbReporteModuloDiaDetalle rmdd
ON rmdd.remo_Id = remd.remo_Id
WHERE (remd.remo_Fecha BETWEEN @fechaInicio AND @fechaFin) AND (area.tipa_Id = @tipa_Id OR @tipa_Id = 0)
GROUP BY area.tipa_area, area.tipa_Id
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_ReporteSeguimientoProcesosPO]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [Prod].[UDP_ReporteSeguimientoProcesosPO] -- '12345'
@orco_Codigo NVARCHAR(100)
AS
BEGIN

SELECT DISTINCT
     orco.orco_Id,
	 orco.orco_Codigo,
	 clie.clie_Nombre_O_Razon_Social,
	 orco.orco_EstadoFinalizado,
	 orco.orco_EstadoOrdenCompra,

	 
	 orde.code_Id,
	 proceActual.proc_Descripcion AS proc_Actual,
	 proceComienza.proc_Descripcion as proc_Comienza,
	 orde.code_CantidadPrenda,
	 estilo.esti_Descripcion,
	 talla.tall_Nombre,
	 orde.code_Sexo,
	 colores.colr_Nombre,

	 todo.ppro_Id AS OrdenProduccion,

	 faex.faex_Id,
	 faex.faex_Fecha AS FechaExportacion, 
	 fade.fede_Cantidad AS CantidadExportada, 
	 fade.fede_Cajas, 
	 fade.fede_TotalDetalle,
	 
	 (
		SELECT p.* 
					FROM 
				(  SELECT	 pros.proc_Descripcion,	
				             modu.modu_Nombre ,    
							 area.tipa_area ,     
				
				CASE
				   WHEN asor.asor_FechaInicio IS NULL THEN 'NADA'
				ELSE CONVERT(NVARCHAR, asor.asor_FechaInicio, 120)
			    END AS asor_FechaInicio,
			    CASE
				   WHEN asor.asor_FechaLimite IS NULL THEN 'NADA'
				ELSE CONVERT(NVARCHAR, asor.asor_FechaLimite, 120)
			   END AS asor_FechaLimite,
			    CASE
				   WHEN asor.asor_Cantidad IS NULL THEN 'NADA'
				ELSE CONVERT(NVARCHAR, asor.asor_Cantidad, 120)
			   END AS asor_Cantidad,
			  
			  CASE
				   WHEN empl.empl_Nombres + ' '+ empl_Apellidos IS NULL THEN 'Nada'
				ELSE CONVERT(NVARCHAR, (empl.empl_Nombres + ' '+ empl_Apellidos), 120)
			   END AS Empleado

			  
				             
										
					FROM	Prod.tbOrdenCompraDetalles ordenCompraDetalle
						LEFT JOIN	Prod.tbProcesoPorOrdenCompraDetalle	procesos ON	ordenCompraDetalle.code_Id = procesos.code_Id
						LEFT JOIN	Prod.tbProcesos	pros                         ON	pros.proc_Id = procesos.proc_Id					
						LEFT JOIN   Prod.tbAsignacionesOrden asor                ON asor.proc_Id = procesos.proc_Id  AND   ordenCompraDetalle.code_Id = asor.asor_OrdenDetId
						LEFT JOIN   Gral.tbEmpleados empl                        ON asor.empl_Id = empl.empl_Id
					    LEFT JOIN   Prod.tbModulos modu                          ON modu.proc_Id = procesos.proc_Id
						LEFT JOIN   Prod.tbArea area                             ON area.proc_Id = procesos.proc_Id

						WHERE       orde.code_Id = procesos.code_Id) AS p
				FOR JSON PATH ) AS SeguimientoProcesos
			
FROM 
Prod.tbOrdenCompraDetalles orde
INNER JOIN Prod.tbOrdenCompra orco                       ON orco.orco_Id        = orde.orco_Id
INNER JOIN Prod.tbProcesos	proceActual                  ON	proceActual.proc_Id = orde.proc_IdActual	
INNER JOIN Prod.tbProcesos	proceComienza                ON	proceComienza.proc_Id = orde.proc_IdComienza	
INNER JOIN Prod.tbClientes clie                          ON orco.orco_IdCliente = clie.clie_Id 
INNER JOIN Prod.tbEstilos estilo			             ON	orde.esti_Id		= estilo.esti_Id
INNER JOIN Prod.tbTallas	talla	                     ON	orde.tall_Id		= talla.tall_Id
INNER JOIN Prod.tbColores	colores	                     ON	orde.colr_Id	    = colores.colr_Id
LEFT  JOIN Prod.tbOrde_Ensa_Acab_Etiq todo               ON todo.code_Id        = orde.code_Id
LEFT  JOIN Prod.tbFacturasExportacionDetalles fade       ON orde.code_Id        = fade.code_Id
LEFT  JOIN Prod.tbFacturasExportacion faex               ON fade.faex_Id        = faex.faex_Id 
WHERE  orco.orco_Codigo = @orco_Codigo
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbArea_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Area*/
CREATE   PROCEDURE [Prod].[UDP_tbArea_Editar]
	@tipa_Id					INT,
	@tipa_area					NVARCHAR(200),
	@proc_Id					INT,
	@usua_UsuarioModificacion	INT,
	@tipa_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
			IF EXISTS(SELECT tipa_area	
					  FROM Prod.tbArea
					  WHERE tipa_Area = @tipa_area
					  AND tipa_Estado = 0)
				BEGIN
					DELETE FROM Prod.tbArea
					WHERE tipa_Area = @tipa_area
					AND tipa_Estado = 0

				END

					UPDATE Prod.tbArea
					SET   tipa_area = @tipa_area,
						  proc_Id = @proc_Id,
						  usua_UsuarioModificacion = @usua_UsuarioModificacion,
						  tipa_FechaModificacion = @tipa_FechaModificacion
					WHERE tipa_Id = @tipa_Id	

					SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbArea_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar Area*/
CREATE   PROCEDURE [Prod].[UDP_tbArea_Eliminar]
@tipa_Id					INT,
@usua_UsuarioEliminacion	INT,
@tipa_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'tipa_Id', @tipa_Id, 'Prod.tbArea', @respuesta OUTPUT

		IF(@respuesta) = 1
		BEGIN
				UPDATE Prod.tbArea
				SET tipa_Estado = 0,
				usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				tipa_FechaEliminacion = @tipa_FechaEliminacion
				WHERE tipa_Id = @tipa_Id
		END

		SELECT @respuesta AS Resultado
		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbArea_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Area*/
CREATE   PROCEDURE [Prod].[UDP_tbArea_Insertar]
	@tipa_area				NVARCHAR(200),
	@proc_Id				INT,
	@usua_UsuarioCreacion	INT,
	@tipa_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT tipa_area
				   FROM Prod.tbArea
				   WHERE tipa_area = @tipa_area
				   AND tipa_Estado = 0)
			BEGIN
				UPDATE Prod.tbArea
				SET	   tipa_Estado = 1
				WHERE  tipa_area = @tipa_area

				SELECT 1
			END
		ELSE
			BEGIN
				INSERT INTO Prod.tbArea(tipa_area,
										proc_Id,
										usua_UsuarioCreacion,
										tipa_FechaCreacion)
				VALUES (@tipa_area,				
						@proc_Id,				
						@usua_UsuarioCreacion,	
						@tipa_FechaCreacion)

				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbArea_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************AREA******************--
/*Listar Area*/ 
CREATE   PROCEDURE [Prod].[UDP_tbArea_Listar]
AS
BEGIN
SELECT	tipa_Id							,
		tipa_area						,
		pro.proc_Id						,
		pro.proc_Descripcion			,
		area.usua_UsuarioCreacion		,
		crea.usua_Nombre 				AS usarioCreacion,	
		tipa_FechaCreacion				,
		area.usua_UsuarioModificacion	,
		modi.usua_Nombre  				AS usuarioModificacion,
		tipa_FechaModificacion			,
		area.usua_UsuarioEliminacion	,
		elim.usua_Nombre 				AS usuarioEliminacion,
		tipa_FechaEliminacion			,
		tipa_Estado 					
FROM	Prod.tbArea area 
		INNER JOIN Prod.tbProcesos pro	ON area.proc_Id = pro.proc_Id  
		INNER JOIN Acce.tbUsuarios crea ON crea.usua_Id = area.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi	ON modi.usua_Id = area.usua_UsuarioModificacion 
		LEFT JOIN Acce.tbUsuarios elim	ON elim.usua_Id = area.usua_UsuarioEliminacion 
WHERE	tipa_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrden_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrden_Editar]
(
	@asor_Id					INT,
	@asor_OrdenDetId			INT,
	@asor_FechaInicio			DATETIME,
	@asor_FechaLimite			DATETIME,
	@asor_Cantidad				INT,
	@proc_Id					INT,
	@empl_Id					INT,
	@usua_UsuarioModificacion	INT,
	@asor_FechaModificacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		 UPDATE Prod.tbAsignacionesOrden
			SET	asor_OrdenDetId			= @asor_OrdenDetId,
				asor_FechaInicio		= @asor_FechaInicio,	
				asor_FechaLimite		= @asor_FechaLimite,	
				asor_Cantidad			= @asor_Cantidad,	
				proc_Id					= @proc_Id,
				empl_Id					= @empl_Id,
				usua_UsuarioModificacion= @usua_UsuarioModificacion,	
				asor_FechaModificacion	= @asor_FechaModificacion
		  WHERE asor_Id	= @asor_Id

			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrden_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrden_Eliminar]
(
	@asor_Id	INT
)
AS
BEGIN
	BEGIN TRY
		DELETE Prod.tbAsignacionesOrdenDetalle
		WHERE asor_Id = @asor_Id

		DELETE Prod.tbAsignacionesOrden
		WHERE asor_Id = @asor_Id

		SELECT 1 AS Resultado

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrden_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrden_Insertar] --1,'10-16-2004', '10-16-2004', 1,1,1,'[{"lote_Id":1,"adet_Cantidad":2},{"lote_Id":2,"adet_Cantidad":2},{"lote_Id":3,"adet_Cantidad":2},{"lote_Id":4,"adet_Cantidad":2},{"lote_Id":7,"adet_Cantidad":2}]',1, '10-16-2004'  
(
	@asor_OrdenDetId			INT,
	@asor_FechaInicio			DATETIME,
	@asor_FechaLimite			DATETIME,
	@asor_Cantidad				INT,
	@proc_Id					INT,
	@empl_Id					INT,
	@detalles					NVARCHAR(MAX),
	@usua_UsuarioCreacion		INT,
	@asor_FechaCreacion			DATETIME
)
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY
		INSERT INTO Prod.tbAsignacionesOrden
					(asor_OrdenDetId,			
					asor_FechaInicio,			
					asor_FechaLimite,			
					asor_Cantidad,				
					proc_Id,					
					empl_Id,					
					usua_UsuarioCreacion,		
					asor_FechaCreacion)
			 VALUES (@asor_OrdenDetId,			
					@asor_FechaInicio,			
					@asor_FechaLimite,			
					@asor_Cantidad,				
					@proc_Id,					
					@empl_Id,					
					@usua_UsuarioCreacion,		
					@asor_FechaCreacion)
		
		DECLARE @asor_Id INT = SCOPE_IDENTITY() 


INSERT INTO [Prod].[tbAsignacionesOrdenDetalle]
           ([lote_Id]
           ,[adet_Cantidad]
           ,[asor_Id]
           ,[usua_UsuarioCreacion]
           ,[adet_FechaCreacion])
     SELECT *
           ,@asor_Id
           ,@usua_UsuarioCreacion	
		   ,@asor_FechaCreacion
		   FROM OPENJSON(@detalles, '$.detalles')
				WITH (
					 lote_Id INT
					,adet_Cantidad INT
				) 

	UPDATE Prod.tbOrdenCompra
	SET [orco_EstadoOrdenCompra] = 'C'
	WHERE [orco_Id] = (SELECT [orco_Id]
						 FROM Prod.tbOrdenCompraDetalles
						 WHERE [code_Id] = @asor_OrdenDetId)
	SELECT SCOPE_IDENTITY() 
	COMMIT TRAN
	END TRY
	BEGIN CATCH
		 ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrden_Listado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrden_Listado]
AS
BEGIN
	 SELECT asor_Id,						
			asor_OrdenDetId,
			esti.esti_Descripcion,
			colr.colr_Nombre,
			tall.tall_Nombre,
			orco.orco_Id,
			orco.orco_Codigo,
			orco.orco_FechaEmision,
			orco.orco_FechaLimite,
			clie.clie_Nombre_O_Razon_Social,
			--(SELECT RowNumber
			--  FROM (SELECT ROW_NUMBER() OVER (ORDER BY prod_Id) AS RowNumber,
			--			   prod_Id 
			--		  FROM Prod.tbPedidosOrdenDetalle
			--		 WHERE pedi_Id = pedidos.peor_Id)			AS RowNumbers
			-- WHERE prod_Id = pedidosDetalle.prod_Id)			AS prod_NumeroLinea,
			
			(SELECT COUNT(orco_Id)
			 FROM Prod.tbOrdenCompraDetalles
			 WHERE orco_Id = orco.orco_Id) AS cantidad_Items,
			asor_FechaInicio,			
			asor_FechaLimite,						
			asor_Cantidad,				
			pro.proc_Id,	
			pro.proc_Descripcion,
			empl.empl_Id,			
			empl.empl_Nombres + ' ' + empl_Apellidos AS empl_NombreCompleto,
			asignacionesOrden.usua_UsuarioCreacion,
			usuarioCreacion.usua_Nombre					AS usuarioCreacionNombre,
			asor_FechaCreacion,			
			asignacionesOrden.usua_UsuarioModificacion,
			usuarioModificacion.usua_Nombre				AS usuarioModificacionNombre,
			asor_FechaModificacion,
			(SELECT		adet_Id,						
					   lote.lote_Id,
					   lote.lote_CodigoLote,
					   mate.mate_Id,
					   mate.mate_Descripcion,
					   lote.colr_Id,
					   colors.colr_Nombre,
					   adet_Cantidad,				
					   AsignacionesOrdenDetalle.usua_UsuarioCreacion,
					   usuarioCreacion.usua_Nombre							AS usuarioCreacionNombre,
					   adet_FechaCreacion,			
					   AsignacionesOrdenDetalle.usua_UsuarioModificacion,
					   usuarioModificacion.usua_Nombre						AS usuarioModificacionNombre,
					   adet_FechaModificacion
			FROM Prod.tbAsignacionesOrdenDetalle		AS AsignacionesOrdenDetalle	
			INNER JOIN Prod.tbLotes		lote				ON AsignacionesOrdenDetalle.lote_Id = lote.lote_Id
			INNER JOIN Acce.tbUsuarios usuarioCreacion		ON AsignacionesOrdenDetalle.usua_UsuarioCreacion = usuarioCreacion.usua_Id
			INNER JOIN prod.tbMateriales mate				ON lote.mate_Id = mate.mate_Id
			LEFT JOIN prod.tbColores colors					ON colors.colr_Id = lote.colr_Id
			LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON AsignacionesOrdenDetalle.usua_UsuarioModificacion = usuarioModificacion.usua_Id
			WHERE 	AsignacionesOrdenDetalle.asor_Id = asignacionesOrden.asor_Id FOR JSON AUTO) AS Detalles

	   FROM Prod.tbAsignacionesOrden					AS asignacionesOrden 
	   INNER JOIN Prod.tbProcesos pro					ON asignacionesOrden.proc_Id = pro.proc_Id
	   INNER JOIN Gral.tbEmpleados empl					ON asignacionesOrden.empl_Id = empl.empl_Id
	   INNER JOIN Prod.tbOrdenCompraDetalles code		ON asignacionesOrden.asor_OrdenDetId = code.code_Id
	   INNER JOIN Prod.tbEstilos esti					ON code.esti_Id = esti.esti_Id
	   INNER JOIN Prod.tbColores colr					ON code.colr_Id = colr.colr_Id
	   INNER JOIN Prod.tbTallas tall					ON code.tall_Id = tall.tall_Id
	   INNER JOIN Prod.tbOrdenCompra orco				ON code.orco_Id = orco.orco_Id
	   INNER JOIN Prod.tbClientes clie					ON orco.orco_IdCliente = clie.clie_Id
	   INNER JOIN Acce.tbUsuarios usuarioCreacion		ON asignacionesOrden.usua_UsuarioCreacion = usuarioCreacion.usua_Id
	   LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON asignacionesOrden.usua_UsuarioModificacion = usuarioModificacion.usua_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrdenDetalle_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrdenDetalle_Editar]
(
	@adet_Id					INT,
	@lote_Id					INT, 
	@adet_Cantidad				INT, 
	@asor_Id					INT,
	@usua_UsuarioModificacion	INT,
	@adet_FechaModificacion		DATETIME,
	@jsonParameter				NVARCHAR(MAX)
)	
AS
BEGIN
	BEGIN TRY
		DECLARE @lote_Viejo INT = JSON_VALUE(@jsonParameter, '$.lote_viejo')
		DECLARE @lote_Nuevo INT = JSON_VALUE(@jsonParameter, '$.lote_nuevo')
		
		UPDATE Prod.tbAsignacionesOrdenDetalle
		   SET lote_Id					= @lote_Nuevo,					 
			   adet_Cantidad			= @adet_Cantidad,	
			   asor_Id					= @asor_Id,
			   usua_UsuarioModificacion	= @usua_UsuarioModificacion,		
			   adet_FechaModificacion	= @adet_FechaModificacion
		 WHERE asor_Id = @asor_Id
		 AND   lote_Id = @lote_Viejo

		 SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrdenDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrdenDetalle_Eliminar]
(
	@lote_Id		INT,
	@adet_Cantidad		INT
)
AS
BEGIN
	BEGIN TRY
		DELETE Prod.tbAsignacionesOrdenDetalle
		 WHERE lote_Id = @lote_Id
		 AND   asor_Id = @adet_Cantidad

		 SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrdenDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrdenDetalle_Insertar] 
(
	@lote_Id					INT, 
	@adet_Cantidad				INT, 
	@asor_Id					INT,
	@usua_UsuarioCreacion		INT,
	@adet_FechaCreacion			DATETIME
	
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbAsignacionesOrdenDetalle
					(lote_Id,					
					adet_Cantidad,
					asor_Id,
					usua_UsuarioCreacion,		
					adet_FechaCreacion)
			VALUES (@lote_Id,					
					@adet_Cantidad,
					@asor_Id,
					@usua_UsuarioCreacion,		
					@adet_FechaCreacion)
	
		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbAsignacionesOrdenDetalle_Listado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------/UDPS Para Asignaciones Orden--------------------------------------------

-------------------------------------------UDPS Para Asignaciones Orden detalle---------------------------------------

CREATE   PROCEDURE [Prod].[UDP_tbAsignacionesOrdenDetalle_Listado] 
	@asor_Id INT
AS
BEGIN
	SELECT adet_Id,						
		   lote.lote_Id,
		   adet_Cantidad,				
		   AsignacionesOrdenDetalle.usua_UsuarioCreacion,
		   usuarioCreacion.usua_Nombre							AS usuarioCreacionNombre,
		   adet_FechaCreacion,			
		   AsignacionesOrdenDetalle.usua_UsuarioModificacion,
		   usuarioModificacion.usua_Nombre						AS usuarioModificacionNombre,
		   adet_FechaModificacion
	  FROM Prod.tbAsignacionesOrdenDetalle		AS AsignacionesOrdenDetalle
INNER JOIN Prod.tbLotes		lote				ON AsignacionesOrdenDetalle.lote_Id = lote.lote_Id
INNER JOIN Acce.tbUsuarios usuarioCreacion		ON AsignacionesOrdenDetalle.usua_UsuarioCreacion = usuarioCreacion.usua_Id
 LEFT JOIN Acce.tbUsuarios usuarioModificacion	ON AsignacionesOrdenDetalle.usua_UsuarioModificacion = usuarioModificacion.usua_Id

WHERE 	AsignacionesOrdenDetalle.asor_Id = @asor_Id

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbCategoria_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar CATEGORIA*/
CREATE   PROCEDURE [Prod].[UDP_tbCategoria_Editar]
	@cate_Id					INT,
	@cate_Descripcion			NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@cate_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT cate_Id
				   FROM Prod.tbCategoria
				   WHERE cate_Descripcion = @cate_Descripcion
				   AND cate_Estado = 0)
			BEGIN
				UPDATE Prod.tbCategoria
				   SET cate_Estado = 0
				 WHERE cate_Id = @cate_Id

				UPDATE Prod.tbCategoria
				   SET cate_Estado = 1
				 WHERE cate_Descripcion = @cate_Descripcion
				 
				SELECT 1 AS Resultado
			END
		ELSE
			BEGIN
				UPDATE Prod.tbCategoria
				   SET cate_Descripcion = @cate_Descripcion,
					   usua_UsuarioModificacion = @usua_UsuarioModificacion,
					   cate_FechaModificacion = @cate_FechaModificacion
				 WHERE cate_Id = @cate_Id

				SELECT 1 AS Resultado
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbCategoria_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar CATEGORIA*/
CREATE   PROCEDURE [Prod].[UDP_tbCategoria_Eliminar] 
	@cate_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@cate_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'cate_Id', @cate_Id, 'prod.tbCategoria', @respuesta OUTPUT

		IF(@respuesta = 1)
		BEGIN
			UPDATE Prod.tbCategoria
			   SET cate_Estado = 0,
				   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				   cate_FechaEliminacion = @cate_FechaEliminacion
			 WHERE cate_Id = @cate_Id
			
		END

		SELECT @respuesta
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbCategoria_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar CATEGORIA*/
CREATE   PROCEDURE [Prod].[UDP_tbCategoria_Insertar] --'Telas',1,'10-16-2004'
	@cate_Descripcion		NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@cate_FechaCreacion     DATETIME
AS 
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * 
					 FROM Prod.tbCategoria
					WHERE cate_Descripcion = @cate_Descripcion
					  AND cate_Estado = 0)
		BEGIN
			UPDATE Prod.tbCategoria
			SET	   cate_Estado = 1
			WHERE  cate_Descripcion = @cate_Descripcion
		END
		ELSE 
		BEGIN
			INSERT INTO Prod.tbCategoria (cate_Descripcion, usua_UsuarioCreacion, cate_FechaCreacion)
			VALUES(@cate_Descripcion, @usua_UsuarioCreacion, @cate_FechaCreacion)
		END

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbCategoria_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************CATEGORIA******************--
/*Listar CATEGORIA*/
CREATE   PROCEDURE [Prod].[UDP_tbCategoria_Listar]
AS
BEGIN

SELECT	cate_Id										,
		cate_Descripcion							,
		cate.usua_UsuarioCreacion					,
		usuaCrea.usua_Nombre						AS usuarioCreacionNombre,
		cate_FechaCreacion							,
		cate.usua_UsuarioModificacion				,
		usuaModifica.usua_Nombre					AS usuarioModificacionNombre,
		cate_FechaModificacion						,
		cate.usua_UsuarioEliminacion				,
		usuaElimina.usua_Nombre						AS usuarioEliminacionNombre,
		cate_FechaEliminacion						,
		cate_Estado						
FROM	Prod.tbCategoria cate 
		INNER JOIN Acce.tbUsuarios usuaCrea		ON cate.usua_UsuarioCreacion = usuaCrea.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaModifica	ON cate.usua_UsuarioModificacion = usuaModifica.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaElimina	ON cate.usua_UsuarioEliminacion = usuaElimina.usua_Id 
WHERE cate_Estado = 1

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbClientes_Activar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* Activar Clientes*/
CREATE   PROCEDURE [Prod].[UDP_tbClientes_Activar]
	@clie_Id					INT,
	@usua_UsuarioModificacion	INT,
	@clie_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		BEGIN
			 UPDATE Prod.tbClientes
			    SET clie_Estado               = 1,
					usua_UsuarioModificacion  = @usua_UsuarioModificacion,
					clie_FechaModificacion    = @clie_FechaModificacion
			  WHERE clie_Id                   = @clie_Id
			 SELECT 1
		END
	END TRY
	BEGIN CATCH
		SELECT 0
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbClientes_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Clientes*/
CREATE   PROCEDURE [Prod].[UDP_tbClientes_Editar] 
  @clie_Id    INT, 
  @clie_Nombre_O_Razon_Social NVARCHAR(200), 
  @clie_Direccion     NVARCHAR(200), 
  @clie_RTN			  NVARCHAR(40),
  @clie_Nombre_Contacto   NVARCHAR(200),
  @clie_Numero_Contacto VARCHAR(15), 
  @clie_Correo_Electronico  NVARCHAR(200) , 
  @clie_FAX  NVARCHAR(50) , 
  @pvin_Id   INT,
  @usua_UsuarioModificacion INT, 
  @clie_FechaModificacion DATETIME
AS
BEGIN   
    BEGIN TRY 
	    UPDATE Prod.tbClientes
		SET clie_Nombre_O_Razon_Social =@clie_Nombre_O_Razon_Social, 
		    clie_Direccion=@clie_Direccion, 
			clie_RTN = @clie_RTN, 
			clie_Nombre_Contacto=@clie_Nombre_Contacto, 
			clie_Numero_Contacto=@clie_Numero_Contacto, 
			clie_Correo_Electronico=@clie_Correo_Electronico, 
			clie_FAX=@clie_FAX, 
			pvin_Id = @pvin_Id,
			usua_UsuarioModificacion=@usua_UsuarioModificacion, 
			clie_FechaModificacion=@clie_FechaModificacion 
		WHERE clie_Id = @clie_Id

		 SELECT 1
	END TRY
	BEGIN CATCH
	     SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END


/*Eliminar Clientes*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbClientes_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbClientes_Eliminar] --1, 1, '10-16-2004'
	@clie_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@clie_FechaEliminacion	DATETIME
AS
BEGIN
	BEGIN TRY
	DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'clie_Id', @clie_Id, 'Prod.tbClientes', @respuesta OUTPUT

		
		IF(@respuesta) = 1
			BEGIN

		UPDATE Prod.tbClientes
		SET clie_Estado = 0, 
				usua_UsuarioEliminacion =@usua_UsuarioEliminacion,
				clie_FechaEliminacion =@clie_FechaEliminacion
		WHERE clie_Id = @clie_Id

		END
		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbClientes_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Crear Clientes*/
CREATE   PROCEDURE [Prod].[UDP_tbClientes_Insertar] 
   @clie_Nombre_O_Razon_Social    NVARCHAR(200), 
   @clie_Direccion                NVARCHAR(250), 
   @clie_RTN                      NVARCHAR(40), 
   @clie_Nombre_Contacto          NVARCHAR(200), 
   @clie_Numero_Contacto          VARCHAR(15), 
   @clie_Correo_Electronico       NVARCHAR(200), 
   @clie_FAX                      NVARCHAR(50), 
   @pvin_Id						  INT,
   @usua_UsuarioCreacion          INT, 
   @clie_FechaCreacion            DATETIME

AS
BEGIN 
  BEGIN TRY
	  IF EXISTS (SELECT*FROM Prod.tbClientes WHERE clie_Nombre_O_Razon_Social = @clie_Nombre_O_Razon_Social AND clie_RTN = @clie_RTN
	  AND clie_Estado = 0)
		BEGIN
			UPDATE Prod.tbClientes 
			SET clie_Estado = 1, clie_Correo_Electronico = @clie_Correo_Electronico, clie_FAX = @clie_FAX,
			clie_Numero_Contacto = @clie_Numero_Contacto,clie_Nombre_Contacto = @clie_Nombre_Contacto
			WHERE clie_Nombre_O_Razon_Social = @clie_Nombre_O_Razon_Social AND clie_RTN = @clie_RTN
			SELECT 1
		END
		ELSE
		BEGIN
	      INSERT INTO Prod.tbClientes
		  ( 
	      clie_Nombre_O_Razon_Social,
		  clie_Direccion   ,  
		  clie_RTN          , 
		  clie_Nombre_Contacto ,
		  clie_Numero_Contacto,
		  clie_Correo_Electronico,
		  clie_FAX ,
		  pvin_Id,
		  usua_UsuarioCreacion,
		  clie_FechaCreacion            	  		  
		  )
		  VALUES (		         
		  @clie_Nombre_O_Razon_Social ,   
		  @clie_Direccion ,  
		  @clie_RTN ,  
		  @clie_Nombre_Contacto ,  
		  @clie_Numero_Contacto  ,  
		  @clie_Correo_Electronico,  
		  @clie_FAX,
		  @pvin_Id,
		  @usua_UsuarioCreacion,  
		  @clie_FechaCreacion           
		  )	 
		  END
	   SELECT 1
END TRY	    
   BEGIN CATCH 	 
	 SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
   END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbClientes_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************UDP's Clientes*********************************/
/*Listar Clientes*/
CREATE   PROCEDURE [Prod].[UDP_tbClientes_Listar]
AS
BEGIN 
SELECT	clie.clie_Id					,
		clie.clie_Nombre_O_Razon_Social ,
		clie.clie_Numero_Contacto,
		clie.clie_Nombre_Contacto		,
		clie.clie_Correo_Electronico	,
		clie.clie_Direccion				,
		clie.clie_FAX					,
		clie.clie_RTN					,
		clie.pvin_Id					,
		provi.pvin_Codigo				,
		provi.pvin_Nombre				,
		pais.pais_Id					,
		pais.pais_Nombre				,
		clie.usua_UsuarioCreacion		,
		usu.usua_Nombre					AS usuarioNombreCreacion,
		clie.clie_FechaCreacion			,
		clie.usua_UsuarioModificacion	,
		usu1.usua_Nombre				AS usuarioNombreModificacion,
		clie.clie_FechaModificacion		,
		clie.usua_UsuarioEliminacion	,
		usu2.usua_Nombre				AS usuarioNombreEliminacion,
		clie.clie_Estado				
FROM	Prod.tbClientes clie 
		INNER JOIN Acce.tbUsuarios usu		  ON usu.usua_Id = clie.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios usu1		  ON usu1.usua_Id = clie.usua_UsuarioModificacion
		LEFT JOIN Acce.tbUsuarios usu2		  ON usu2.usua_Id = clie.usua_UsuarioEliminacion
		INNER JOIN Gral.tbProvincias provi    ON provi.pvin_Id = clie.pvin_Id
		INNER JOIN Gral.tbPaises pais		  ON provi.pais_Id = pais.pais_Id
		WHERE clie.clie_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbColores_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_tbColores_Editar]
	@colr_Id INT,
	@colr_Nombre NVARCHAR(100),
	@colr_Codigo NVARCHAR(100),
	@colr_CodigoHtml  NVARCHAR(100),
	@usua_UsuarioModificacion INT,
	@colr_FechaModificacion DATETIME
AS BEGIN

BEGIN TRY

UPDATE Prod.tbColores SET colr_Nombre = @colr_Nombre,
						  colr_Codigo = @colr_Codigo,  
						  colr_CodigoHtml=@colr_CodigoHtml,
						  usua_UsuarioModificacion = @usua_UsuarioModificacion,
						  colr_FechaModificacion = @colr_FechaModificacion
					  WHERE colr_Id = @colr_Id

					  SELECT 1

END TRY

BEGIN CATCH

		SELECT 'Error Message: ' + ERROR_MESSAGE()

END CATCH

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbColores_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Eliminar Colores*/
CREATE   PROC [Prod].[UDP_tbColores_Eliminar] 
@colr_Id INT,
@usua_UsuarioEliminacion INT,
@colr_FechaEliminacion DATETIME
AS BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'colr_Id', @colr_Id, 'Prod.tbColores', @respuesta OUTPUT

		
		IF(@respuesta) = 1
			BEGIN
				 UPDATE Prod.tbColores
					SET colr_Estado = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						colr_FechaEliminacion = @colr_FechaEliminacion
				  WHERE colr_Id = @colr_Id
					AND colr_Estado = 1

					
			END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: '+ ERROR_MESSAGE();	
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbColores_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_tbColores_Insertar] --'verde','22', 1,'10.16-2004'
@colr_Nombre NVARCHAR(100),
@colr_Codigo NVARCHAR(100),
@colr_CodigoHtml  NVARCHAR(100),
@usua_UsuarioCreacion INT,
@colr_FechaCreacion DATETIME
AS BEGIN

BEGIN TRY
		INSERT INTO Prod.tbColores(colr_Nombre, 
					       colr_Codigo,
						   colr_CodigoHtml,
						   usua_UsuarioCreacion, 
						   colr_FechaCreacion)
		VALUES (@colr_Nombre, 
				@colr_Codigo,
				@colr_CodigoHtml,
				@usua_UsuarioCreacion, 
				@colr_FechaCreacion)

		SELECT 1
END TRY

BEGIN CATCH

		SELECT 'Error Message: ' + ERROR_MESSAGE()

END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbColores_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_tbColores_Listar]
AS BEGIN

SELECT colores.colr_Id,
	   colores.colr_Nombre,
	   colores.colr_Codigo,
	   colores.colr_CodigoHtml,
	   colores.usua_UsuarioCreacion, 
	   Creacion.usua_Nombre AS UsuarioNombreCreacion,
	   colores.colr_FechaCreacion,
	   colores.usua_UsuarioModificacion,
	   Modificacion.usua_Nombre AS UsuarioNombreModificacion,
	   colores.colr_FechaModificacion, 
	   colores.usua_UsuarioEliminacion,
		Eliminacion.usua_Nombre AS UsuarioNombreEliminacion,
	   colores.colr_FechaEliminacion,
	   colores.colr_Estado 
FROM   Prod.tbColores colores
INNER JOIN Acce.tbUsuarios Creacion
ON Creacion.usua_Id = colores.usua_UsuarioCreacion
LEFT JOIN Acce.tbUsuarios Modificacion
ON Modificacion.usua_Id = colores.usua_UsuarioModificacion
LEFT JOIN Acce.tbUsuarios Eliminacion
ON Eliminacion.usua_Id = colores.usua_UsuarioEliminacion
WHERE colr_Estado = 1

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Editar]
@dopo_Id					 INT,
@code_Id					 INT,
@dope_NombreArchivo          NVARCHAR(MAX),
@dopo_Archivo				 NVARCHAR(max),
@dopo_TipoArchivo			 NVARCHAR(40),
@usua_UsuarioModificacion	 INT,
@dopo_FechaModificacion		 DATETIME
AS
BEGIN
 BEGIN TRY 
 
	UPDATE Prod.tbDocumentosOrdenCompraDetalles
	   SET code_Id                  =		@code_Id
		  ,dopo_Archivo             =		@dopo_Archivo
		  ,dopo_TipoArchivo         =		@dopo_TipoArchivo
 		  ,usua_UsuarioModificacion =		@usua_UsuarioModificacion
		  ,dopo_FechaModificacion   =		@dopo_FechaModificacion
 	 WHERE dopo_Id = @dopo_Id
 
 		 SELECT 1
	END TRY 
	BEGIN CATCH
	   SELECT 0	
	END CATCH    
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Eliminar]  
@dopo_Id					 INT
AS
BEGIN
 BEGIN TRY 

	 		 DELETE 
	         FROM	 Prod.tbDocumentosOrdenCompraDetalles
			 WHERE dopo_Id = @dopo_Id
	   
		 SELECT 1
	END TRY 
	BEGIN CATCH
	   SELECT 0	
	END CATCH    

END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE       PROCEDURE [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Insertar] 
@code_Id					 int,
@dopo_NombreArchivo          NVARCHAR(MAX),
@dopo_Archivo				 nvarchar(max),
@dopo_TipoArchivo			 nvarchar(40),
@usua_UsuarioCreacion		 int,
@dopo_FechaCreacion			 datetime
AS
BEGIN
BEGIN TRY 
	INSERT INTO Prod.tbDocumentosOrdenCompraDetalles
			   (code_Id
			   ,dopo_NombreArchivo
			   ,dopo_Archivo
			   ,dopo_TipoArchivo
			   ,usua_UsuarioCreacion
			   ,dopo_FechaCreacion )
		 VALUES
			   (@code_Id
			   ,@dopo_NombreArchivo
			   ,@dopo_Archivo
			   ,@dopo_TipoArchivo
			   ,@usua_UsuarioCreacion
			   ,@dopo_FechaCreacion)
 		 SELECT 1
	END TRY 
	BEGIN CATCH
	   SELECT 0	
	END CATCH    
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------
--ORDEN DE COMPRA DETALLES  (DOCUMENTOS)---------------------------------------------------------------------------------

CREATE    PROCEDURE [Prod].[UDP_tbDocumentosOrdenCompraDetalles_Listar] 
@code_Id	INT
AS
BEGIN
 
	SELECT	 dopo_Id
			,code_Id
			,dopo_NombreArchivo
			,dopo_Archivo
			,dopo_TipoArchivo
			,documentosOrdenCompraDetalle.usua_UsuarioCreacion
			,UsuarioCreacion.usua_Nombre							AS UsuarioCreacionNombre
 			,documentosOrdenCompraDetalle.dopo_FechaCreacion
			,documentosOrdenCompraDetalle.usua_UsuarioModificacion
			,UsuarioModificacion.usua_Nombre							AS UsuarioModificacionNombre
 			,documentosOrdenCompraDetalle.dopo_FechaModificacion
			,code_Estado
	  FROM	Prod.tbDocumentosOrdenCompraDetalles			documentosOrdenCompraDetalle
			INNER JOIN Acce.tbUsuarios UsuarioCreacion			ON UsuarioCreacion.usua_Id			= documentosOrdenCompraDetalle.usua_UsuarioCreacion
			LEFT  JOIN Acce.tbUsuarios UsuarioModificacion		ON UsuarioModificacion.usua_Id		= documentosOrdenCompraDetalle.usua_UsuarioModificacion
	 
	 WHERE code_Estado = 1 AND code_Id = @code_Id

END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbEstilos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbEstilos_Editar] 
   @esti_Id                  INT,
   @esti_Descripcion         NVARCHAR(200),
   @usua_UsuarioModificacion INT,
   @esti_FechaModificacion   DATETIME
AS
BEGIN 
   BEGIN TRY 
	  IF EXISTS (SELECT esti_Id
				 FROM Prod.tbEstilos
				 WHERE esti_Descripcion = @esti_Descripcion
				 AND esti_Estado = 0)
		BEGIN
			DELETE FROM Prod.tbEstilos
			WHERE esti_Descripcion = @esti_Descripcion
			AND esti_Estado = 0
		END

      UPDATE Prod.tbEstilos
      SET esti_Descripcion = @esti_Descripcion, 
          usua_UsuarioModificacion = @usua_UsuarioModificacion,
          esti_FechaModificacion = @esti_FechaModificacion
      WHERE esti_Id = @esti_Id

	  SELECT 1
   END TRY 
   BEGIN CATCH 
       SELECT 'Error Message: ' + ERROR_MESSAGE()
   END CATCH
END

/*Eliminar estilos*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbEstilos_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbEstilos_Eliminar]
	@esti_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@esti_FechaEliminacion	DATETIME
AS
BEGIN
	BEGIN TRY

		BEGIN
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'esti_Id', @esti_Id, 'Prod.tbEstilos', @respuesta OUTPUT

			IF(@respuesta) = 1
				BEGIN
					 UPDATE Prod.tbEstilos
						SET esti_Estado = 0,
						   usua_UsuarioEliminacion =@usua_UsuarioEliminacion,
						   esti_FechaEliminacion = @esti_FechaEliminacion
						WHERE esti_Id = @esti_Id
				END

			SELECT @respuesta AS Resultado
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbEstilos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/***Insertar estilos*/
CREATE   PROCEDURE [Prod].[UDP_tbEstilos_Insertar] 
   @esti_Descripcion    NVARCHAR(200), 
   @usua_UsuarioCreacion        INT, 
   @esti_FechaCreacion      DATETIME
AS    
BEGIN 
   BEGIN TRY 
	 IF EXISTS(SELECT * FROM Prod.tbEstilos WHERE esti_Descripcion = @esti_Descripcion AND esti_Estado = 0)
      BEGIN 
         UPDATE Prod.tbEstilos
         SET esti_Estado = 1
		 WHERE esti_Descripcion = @esti_Descripcion
         SELECT 1
      END
      ELSE 
      BEGIN 
         INSERT INTO Prod.tbEstilos (esti_Descripcion, usua_UsuarioCreacion, esti_FechaCreacion)
         VALUES (@esti_Descripcion, @usua_UsuarioCreacion, @esti_FechaCreacion)			  
         SELECT 1
      END
   END TRY
   BEGIN CATCH
      SELECT 'Error Message: ' + ERROR_MESSAGE()
   END CATCH  
END

/***Editar estilos*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbEstilos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------------/UDPS Para Asignaciones Orden detalle---------------------------------------





/****************************************UDPs Estilos******************/
/*Listar estilos*/
CREATE   PROCEDURE [Prod].[UDP_tbEstilos_Listar]
AS
BEGIN
SELECT	est.esti_Id						,
		est.esti_Descripcion			,
		est.usua_UsuarioCreacion,
		usu.usua_Nombre					AS usarioCreacion,
		est.esti_FechaCreacion			,
		est.usua_UsuarioModificacion,
		usu2.usua_Nombre				AS usuarioModificacion,
		est.esti_FechaModificacion		,
		est.esti_Estado					
FROM	Prod.tbEstilos est 
		INNER JOIN Acce.tbUsuarios usu	ON est.usua_UsuarioCreacion = usu.usua_Id 
		LEFT JOIN Acce.tbUsuarios usu2 ON usu2.usua_Id = est.usua_UsuarioModificacion 
WHERE	esti_Estado = 1
END 

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacion_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PROCEDIMIENTO PARA EDITAR LAS FACTURAS EXPORTACION (ENCABEZADO)
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacion_Editar]
	@faex_Id					INT, 
	@duca_No_Duca				NVARCHAR(100), 
	@faex_Fecha					DATETIME, 
	@orco_Id					INT,   
	@usua_UsuarioModificacion	INT, 
	@faex_FechaModificacion		DATETIME
AS
BEGIN 
	BEGIN TRY
		
		DECLARE @prev_orco_Id INT =	(SELECT orco_Id FROM Prod.tbFacturasExportacion WHERE faex_Id = @faex_Id)
		DECLARE @duca_Id INT = (SELECT duca_Id FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca)

		IF @prev_orco_Id != @orco_Id
			BEGIN

				/* Debido a que el usuario cambio de ï¿½rden de compra en el encabezado,
				los items aï¿½adidos con la orden de compra previa serï¿½n eliminados */
				DELETE FROM Prod.tbFacturasExportacionDetalles
				WHERE faex_Id = @faex_Id


				UPDATE Prod.tbFacturasExportacion
				SET	duca_Id = @duca_Id, 
					faex_Fecha = @faex_Fecha, 
					orco_Id = @orco_Id,
					faex_Total = 0,
					usua_UsuarioModificacion = @usua_UsuarioModificacion, 
					faex_FechaModificacion = @faex_FechaModificacion
				WHERE faex_Id = @faex_Id

				SELECT 1
			END
		ELSE
			BEGIN
				UPDATE Prod.tbFacturasExportacion
				SET	duca_Id = @duca_Id, 
					faex_Fecha = @faex_Fecha, 
					orco_Id = @orco_Id, 
					usua_UsuarioModificacion = @usua_UsuarioModificacion, 
					faex_FechaModificacion = @faex_FechaModificacion
				WHERE faex_Id = @faex_Id

				SELECT 1
			END
	END TRY

	BEGIN CATCH 
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacion_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PROCEDIMIENTO PARA ESTABLECER EL ESTADO DE LAS FACTURAS EXPORTACION A 0 (DESHABILITADO)
CREATE   PROC [Prod].[UDP_tbFacturasExportacion_Eliminar]
	@faex_Id  		INT
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
			
			DELETE FROM Prod.tbFacturasExportacionDetalles
			WHERE faex_Id = @faex_Id

			DELETE FROM Prod.tbFacturasExportacion
			WHERE faex_Id = @faex_Id

			SELECT 1
	END TRY	
	BEGIN CATCH
			SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacion_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PROCEDIMIENTO PARA FINALIZAR LAS FACTURAS EXPORTACION (faex_Finalizado = 1)
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacion_Finalizado]
	@faex_Id  	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Prod].[tbFacturasExportacion]
		SET	   faex_Finalizado = 1
		WHERE  faex_Id  = @faex_Id  

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacion_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- PROCEDIMIENTO PARA INSERTAR LAS FACTURAS EXPORTACION (ENCABEZADO)
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacion_Insertar] --'12345678696', '08/31/2023', 2, 3, '08/31/2023'
	@duca_No_Duca			NVARCHAR(100),
	@faex_Fecha				DATETIME, 
	@orco_Id				INT, 
	@usua_UsuarioCreacion	INT, 
	@faex_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @duca_Id INT = (SELECT duca_Id FROM Adua.tbDuca WHERE duca_No_Duca = @duca_No_Duca)

		INSERT INTO Prod.tbFacturasExportacion(duca_Id, faex_Fecha, orco_Id, 
												faex_Total, usua_UsuarioCreacion, faex_FechaCreacion)
		VALUES(@duca_Id, @faex_Fecha, @orco_Id, 0, @usua_UsuarioCreacion, @faex_FechaCreacion)

		DECLARE @faex_Id INT = SCOPE_IDENTITY();

		SELECT @faex_Id 
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacion_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacion_Listar]
AS
	BEGIN
		SELECT	FactExport.faex_Id, 
				ISNULL(FactExport.duca_Id, '') AS duca_Id,
				ISNULL(Duca.duca_No_Duca, 'N/A') AS duca_No_Duca,
				FactExport.faex_Fecha, 
				FactExport.orco_Id, 
				CONCAT('No. ', PO.orco_Codigo, ' - ', Clie.clie_Nombre_O_Razon_Social, ' - ', CONVERT(DATE, PO.orco_FechaEmision)) AS orco_Descripcion,
				PO.orco_Codigo,
				FactExport.faex_Total,

				Clie.clie_Nombre_O_Razon_Social,
				Clie.clie_Direccion,
				Clie.clie_Numero_Contacto,
				Clie.clie_RTN,
				Clie.clie_Correo_Electronico,
				Clie.clie_FAX,
				
				FactExport.usua_UsuarioCreacion, 
				UserCrea.usua_Nombre	AS usuarioCreacionNombre,
				FactExport.faex_FechaCreacion, 
				FactExport.usua_UsuarioModificacion,
				UserModifica.usua_Nombre AS usuarioModificacionNombre, 
				FactExport.faex_FechaModificacion,
				FactExport.faex_Finalizado,
				FactExport.faex_Estado,
				(SELECT	FactExportDetails.fede_Id, 
						FactExportDetails.faex_Id, 
						FactExportDetails.code_Id, 
						PODetail.code_CantidadPrenda, 
						Style.esti_Descripcion,
						Talla.tall_Codigo,
						PODetail.code_Sexo, 
						Color.colr_Nombre,
						PODetail.code_Unidad, 
						PODetail.code_Valor, 
						PODetail.code_Impuesto, 
						PODetail.code_EspecificacionEmbalaje,
						FactExportDetails.fede_Cajas, 
						FactExportDetails.fede_Cantidad, 
						FactExportDetails.fede_PrecioUnitario, 
						FactExportDetails.fede_TotalDetalle,
						CONCAT('#: ', PODetail.code_Id, ' - ',Style.esti_Descripcion,' - ',Talla.tall_Codigo,' - ',PODetail.code_Sexo,' - ',Color.colr_Nombre) AS code_Descripcion 
				FROM Prod.tbFacturasExportacionDetalles AS FactExportDetails
				INNER JOIN Prod.tbOrdenCompraDetalles AS PODetail ON FactExportDetails.code_Id = PODetail.code_Id
				INNER JOIN Prod.tbEstilos AS Style ON PODetail.esti_Id = Style.esti_Id
				INNER JOIN Prod.tbTallas AS Talla ON PODetail.tall_Id = Talla.tall_Id
				INNER JOIN Prod.tbColores AS Color ON PODetail.colr_Id = Color.colr_Id
				WHERE FactExportDetails.faex_Id = FactExport.faex_Id
				FOR JSON PATH) AS Detalles
		FROM	Prod.tbFacturasExportacion		AS FactExport
		INNER JOIN Prod.tbOrdenCompra		AS PO			ON FactExport.orco_Id = PO.orco_Id
		INNER JOIN Prod.tbClientes			AS Clie			ON PO.orco_IdCliente = Clie.clie_Id
		INNER JOIN Acce.tbUsuarios			AS UserCrea		ON FactExport.usua_UsuarioCreacion = UserCrea.usua_Id
		LEFT JOIN Adua.tbDuca				AS Duca			ON FactExport.duca_Id = Duca.duca_Id
		LEFT JOIN Acce.tbUsuarios			AS UserModifica ON FactExport.usua_UsuarioModificacion = UserModifica.usua_Id
		WHERE FactExport.faex_Estado = 1
		--ORDER BY FactExport.faex_FechaCreacion ASC
	END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacionDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA BORRAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE   PROC [Prod].[UDP_tbFacturasExportacionDetalle_Eliminar]
(@fede_Id  INT)
AS
BEGIN
	BEGIN TRY
		
		-- Primero Extraer el ID del encabezado de factura correspondiente (faex_Id)
		DECLARE @faex_Id INT = (SELECT faex_Id FROM Prod.tbFacturasExportacionDetalles WHERE fede_Id = @fede_Id)

		-- Borrar el registro por completo
		DELETE FROM [Prod].[tbFacturasExportacionDetalles]
		WHERE fede_Id = @fede_Id 

		-- Hacer la nueva sumatoria con los items que le quedan a esa factura
		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		IF(@faex_Total IS NULL)
			BEGIN
				UPDATE Prod.tbFacturasExportacion 
				SET faex_Total = 0
				WHERE faex_Id = @faex_Id
								
				SELECT 1
			END
		ELSE
			BEGIN
				UPDATE Prod.tbFacturasExportacion 
				SET faex_Total = @faex_Total
				WHERE faex_Id = @faex_Id
				
				SELECT 1
		END

	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacionDetalles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA LISTAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacionDetalles_Editar] --37, 141, 8, 34, 110, 35, 2000, 3, '2023-08-29 15:07:45.000'
	@fede_Id						INT, 
	@faex_Id						INT, 
	@code_Id						INT, 
	@fede_Cajas						INT, 
	@fede_Cantidad					DECIMAL(18,2), 
	@fede_PrecioUnitario			DECIMAL(18,2), 
	@fede_TotalDetalle				DECIMAL(18,2),
	@usua_UsuarioModificacion		INT,	 
	@fede_FechaModificacion			DATETIME
AS
BEGIN
	BEGIN TRY

		UPDATE Prod.tbFacturasExportacionDetalles
		SET faex_Id = @faex_Id, 
			code_Id = @code_Id, 
			fede_Cajas = @fede_Cajas, 
			fede_Cantidad = @fede_Cantidad, 
			fede_PrecioUnitario = @fede_PrecioUnitario, 
			fede_TotalDetalle = @fede_TotalDetalle, 
			usua_UsuarioModificacion = @usua_UsuarioModificacion, 
			fede_FechaModificacion = @fede_FechaModificacion
		WHERE fede_Id = @fede_Id

		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		UPDATE Prod.tbFacturasExportacion 
		SET faex_Total = @faex_Total
		WHERE faex_Id = @faex_Id

		SELECT 1
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacionDetalles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA INSERTAR LAS FACTURAS EXPORTACION DETALLES (ITEMS)
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacionDetalles_Insertar] --141, 8, 34, 110, 35, 23232,3, '2023-08-29 15:07:45.000'
	@faex_Id				INT, 
	@code_Id				INT, 
	@fede_Cajas				INT, 
	@fede_Cantidad			DECIMAL(18,2), 
	@fede_PrecioUnitario	DECIMAL(18,2), 
	@fede_TotalDetalle		DECIMAL(18,2), 
	@usua_UsuarioCreacion	INT, 
	@fede_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		
		INSERT INTO Prod.tbFacturasExportacionDetalles(faex_Id, code_Id, fede_Cajas, 
		fede_Cantidad, fede_PrecioUnitario, fede_TotalDetalle, usua_UsuarioCreacion, fede_FechaCreacion)
		VALUES(@faex_Id, @code_Id, @fede_Cajas, @fede_Cantidad, @fede_PrecioUnitario, @fede_TotalDetalle, @usua_UsuarioCreacion, @fede_FechaCreacion)
		

		DECLARE @faex_Total DECIMAL(18,2) = (SELECT SUM(fede_TotalDetalle) FROM Prod.tbFacturasExportacionDetalles WHERE faex_Id = @faex_Id)

		UPDATE Prod.tbFacturasExportacion 
		SET faex_Total = @faex_Total
		WHERE faex_Id = @faex_Id

		SELECT 1
	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFacturasExportacionDetalles_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/* PROCEDIMIENTOS tb.FacturasExportacionDetalles*/

-- PROCEDIMIENTO PARA LISTAR LAS FACTURAS EXPORTACION DETALLES POR EL ID DEL ENCABEZADO
CREATE   PROCEDURE [Prod].[UDP_tbFacturasExportacionDetalles_Listar]
	@faex_Id INT
AS
BEGIN
	SELECT	Detail.fede_Id, 
			Detail.faex_Id, 
			Detail.code_Id,			

			PODetail.code_CantidadPrenda, 
			Style.esti_Descripcion,

			Talla.tall_Codigo,

			PODetail.code_Sexo, 

			Color.colr_Nombre,
			PODetail.code_Unidad, 
			PODetail.code_Valor, 
			PODetail.code_Impuesto, 
			PODetail.code_EspecificacionEmbalaje,
			Detail.fede_Cajas, 
			Detail.fede_Cantidad, 
			Detail.fede_PrecioUnitario, 
			Detail.fede_TotalDetalle,
			CONCAT('#: ', PODetail.code_Id, ' - ',Style.esti_Descripcion,' - ',Talla.tall_Codigo,' - ',PODetail.code_Sexo,' - ',Color.colr_Nombre) AS code_Descripcion 
	FROM Prod.tbFacturasExportacionDetalles AS Detail
	INNER JOIN Prod.tbOrdenCompraDetalles AS PODetail ON Detail.code_Id = PODetail.code_Id
	INNER JOIN Prod.tbEstilos AS Style ON PODetail.esti_Id = Style.esti_Id
	INNER JOIN Prod.tbTallas AS Talla ON PODetail.tall_Id = Talla.tall_Id
	INNER JOIN Prod.tbColores AS Color ON PODetail.colr_Id = Color.colr_Id
	WHERE Detail.faex_Id = @faex_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFuncionesMaquina_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar FUNCIONES MAQUINA*/
CREATE   PROCEDURE [Prod].[UDP_tbFuncionesMaquina_Editar]
	@func_Id					INT,
	@func_Nombre				NVARCHAR(150),
	@usua_UsuarioModificacion	INT,
	@func_FechaModificacion     DATETIME
AS
BEGIN
	BEGIN TRY
	   IF EXISTS (SELECT func_Id
				  FROM Prod.tbFuncionesMaquina
				  WHERE func_Nombre = @func_Nombre
				  AND func_Estado = 0)
			BEGIN
				DELETE FROM Prod.tbFuncionesMaquina
				WHERE func_Nombre = @func_Nombre
				AND func_Estado = 0
			END

	   UPDATE Prod.tbFuncionesMaquina
		  SET func_Nombre = @func_Nombre,
			  usua_UsuarioModificacion = @usua_UsuarioModificacion,
			  func_FechaModificacion = @func_FechaModificacion
		WHERE func_Id = @func_Id

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFuncionesMaquina_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar FUNCIONES MAQUINA*/
CREATE   PROCEDURE [Prod].[UDP_tbFuncionesMaquina_Eliminar] 
	@func_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@func_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'func_Id', @func_Id, 'prod.tbFuncionesMaquina', @respuesta OUTPUT

		IF(@respuesta) = 1
		BEGIN
			UPDATE Prod.tbFuncionesMaquina
			   SET func_Estado = 0
			 WHERE func_Id = @func_Id
		END

		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFuncionesMaquina_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar FUNCIONES MAQUINA*/
CREATE   PROCEDURE [Prod].[UDP_tbFuncionesMaquina_Insertar]
	@func_Nombre			NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@func_FechaCreacion     DATETIME
AS 
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT * 
					 FROM Prod.tbFuncionesMaquina
					WHERE @func_Nombre = func_Nombre
					  AND func_Estado = 0)
		BEGIN
			UPDATE Prod.tbFuncionesMaquina
			   SET func_Estado = 1
			 WHERE func_Nombre = @func_Nombre
		END
		ELSE 
		BEGIN
			INSERT INTO Prod.tbFuncionesMaquina (func_Nombre, usua_UsuarioCreacion, func_FechaCreacion)
			VALUES(@func_Nombre, @usua_UsuarioCreacion, @func_FechaCreacion)
		END

		SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbFuncionesMaquina_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************FUNCIONES MAQUINA******************--
/*Listar FUNCIONES MAQUINA*/
CREATE   PROCEDURE [Prod].[UDP_tbFuncionesMaquina_Listar]
AS
BEGIN

SELECT func_Id										,
		func_Nombre									,
		func.usua_UsuarioCreacion					,
		usuaCrea.usua_Nombre						AS usuarioCreacionNombre,
		func_FechaCreacion							,
		func.usua_UsuarioModificacion				,
		usuaModifica.usua_Nombre					AS usuarioModificacionNombre,
		func_FechaModificacion						,
		func.usua_UsuarioEliminacion				,
		usuaElimina.usua_Nombre						AS usuarioEliminacionNombre,
		func_FechaEliminacion						,
		func_Estado									
FROM	Prod.tbFuncionesMaquina func 
		INNER JOIN Acce.tbUsuarios usuaCrea		ON func.usua_UsuarioCreacion = usuaCrea.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaModifica	ON func.usua_UsuarioModificacion = usuaModifica.usua_Id 
		LEFT JOIN Acce.tbUsuarios usuaElimina	ON func.usua_UsuarioEliminacion = usuaElimina.usua_Id 
WHERE	func_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbLotes_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_tbLotes_Editar]
	@lote_Id				  INT,
	@mate_Id				  INT,
	@lote_CodigoLote          NVARCHAR(150),
	@colr_Id                  INT,
	@unme_Id				  INT,
	@prod_Id				  INT,
	@lote_Stock               INT,
	@tipa_Id				  INT,
	@lote_Observcaciones	  NVARCHAR(MAX),
	@usua_UsuarioModificacion INT,
	@lote_FechaModificacion	  DATETIME
AS BEGIN
BEGIN TRY

	UPDATE Prod.tbLotes 
	SET  mate_Id                   = @mate_Id, 
			lote_CodigoLote           = @lote_CodigoLote,
			lote_Stock                = @lote_Stock,
			lote_CantIngresada        = 0,
			colr_Id                   = @colr_Id,
			unme_Id                   = @unme_Id,
			prod_Id				   = @prod_Id,
			tipa_Id                   = @tipa_Id, 
			lote_Observaciones        = @lote_Observcaciones,
			usua_UsuarioModificacion  = @usua_UsuarioModificacion,
			lote_FechaModificacion    = @lote_FechaModificacion
	WHERE lote_Id                   = @lote_Id

	SELECT 1
END TRY
BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()

END CATCH
END	

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbLotes_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbLotes_Eliminar] 
	@lote_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@lote_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'lote_Id', @lote_Id, 'Prod.tbLotes', @respuesta OUTPUT

		IF(@respuesta) = 1
		BEGIN
			UPDATE Prod.tbLotes
			   SET lote_Estado             = 0,
				   usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
				   lote_FechaEliminacion   = @lote_FechaEliminacion
			 WHERE lote_Id                 = @lote_Id
		END
		
		SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbLotes_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROC [Prod].[UDP_tbLotes_Insertar]
	@mate_Id				INT,
	@unme_Id				INT,
	@prod_Id				INT,
	@lote_Stock         	INT,
	@colr_Id                INT,
	@tipa_Id				INT,
	@lote_Observaciones		NVARCHAR(MAX),
	@lote_CodigoLote        NVARCHAR(150),
	@usua_UsuarioCreacion	INT,
	@lote_FechaCreacion		DATETIME
AS BEGIN
BEGIN TRY
	INSERT INTO Prod.tbLotes(mate_Id, 
	                         lote_CodigoLote,
							 lote_Stock,
							 colr_Id,
							 lote_CantIngresada,
							 unme_Id,
							 prod_Id,
							 tipa_Id, 
							 lote_Observaciones,
							 usua_UsuarioCreacion,
							 lote_FechaCreacion)

	VALUES					(@mate_Id,
	                         @lote_CodigoLote,
							 @lote_Stock,
							 @colr_Id,
							 0,
							 @unme_Id,
							 @prod_Id,			
							 @tipa_Id,
							 @lote_Observaciones,
							 @usua_UsuarioCreacion,
							 @lote_FechaCreacion)
    SELECT 1
END TRY
BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()

END CATCH
END	
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbLotes_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbLotes_Listar]
AS
BEGIN
SELECT 
	   --CAMPOS PROPIOS DE LOTES
	   lote_Id, 
	   lotes.mate_Id, 
	   lotes.prod_Id,
	   materiales.mate_Descripcion,
	   lotes.unme_Id,
	   UnidadesMedida.unme_Descripcion,
	   lotes.lote_CodigoLote,
	   lotes.lote_Observaciones,
	   lote_Stock,
	   lote_CantIngresada,
	   areas.tipa_area,
	   lotes.tipa_id,
	   lotes.colr_Id,
	   color.colr_Nombre,
	   color.colr_Codigo,
	   color.colr_CodigoHtml,
	   --PEDIDOS DE MATERIALES
	   pedidos.peor_Id,
	   pedidosDetalle.prod_Id,
	   (SELECT RowNumber
		  FROM (SELECT ROW_NUMBER() OVER (ORDER BY prod_Id) AS RowNumber,
					   prod_Id 
				  FROM Prod.tbPedidosOrdenDetalle
				 WHERE pedi_Id = pedidos.peor_Id)			AS RowNumbers
		 WHERE prod_Id = pedidosDetalle.prod_Id)			AS prod_NumeroLinea,
	   pedidos.prov_Id,
	   prov.prov_NombreCompania,
	   prov.prov_NombreContacto,
	   prov.prov_DireccionExacta,

	   --ASIGNACION A P.O
	   po.orco_Id,
	   po.orco_IdCliente,
	   poDetalle.code_Id,
	   poDetalle.code_CantidadPrenda,
	   poDetalle.esti_Id,
	   poDetalle.tall_Id,
	   poDetalle.esti_Id,
	   poDetalle.code_CantidadPrenda,
	   poDetalle.code_Sexo,
	   talla.tall_Nombre,
	   poDetalle.colr_Id,
	   colr.colr_Nombre,
	   esti.esti_Descripcion,

	   --INFO DUCA (PENDIENTE)
	   pedidos.duca_Id,
	   UsuCreacion.usua_Nombre        AS UsuarioCreacionNombre,
	   lotes.usua_UsuarioCreacion,
	   lotes.lote_FechaCreacion, 
	   UsuModificacion.usua_Nombre    AS UsuarioModificacionNombre,
	   lotes.usua_UsuarioModificacion,
	   lotes.lote_FechaModificacion, 
	   UsuEliminacion.usua_Nombre     AS UsuarioEliminacionNombre,
	   lotes.usua_UsuarioEliminacion, 
	   lotes.lote_FechaEliminacion, 
	   lotes.lote_Estado
  FROM Prod.tbLotes lotes
	   LEFT JOIN Prod.tbMateriales						AS materiales        ON lotes.mate_Id                  = materiales.mate_Id
	   LEFT JOIN Prod.tbArea							AS areas             ON lotes.tipa_id                  = areas.tipa_id
	   LEFT JOIN Prod.tbColores                         AS color             ON lotes.colr_Id                  = color.colr_Id
	   LEFT JOIN Gral.tbUnidadMedidas					AS UnidadesMedida    ON lotes.unme_Id                  = UnidadesMedida.unme_Id
	   LEFT JOIN Prod.tbPedidosOrdenDetalle				AS pedidosDetalle	 ON lotes.prod_Id				   = pedidosDetalle.prod_Id
	   LEFT JOIN Prod.tbPedidosOrden					AS pedidos			 ON pedidosDetalle.pedi_Id		   = pedidos.peor_Id
	   LEFT JOIN Prod.tbPODetallePorPedidoOrdenDetalle  AS poDetpedidoDet	 ON pedidosDetalle.prod_Id         = poDetpedidoDet.prod_Id
	   LEFT JOIN Prod.tbOrdenCompraDetalles				AS poDetalle		 ON poDetpedidoDet.code_Id		   = poDetalle.code_Id
	   LEFT JOIN Prod.tbEstilos							AS esti				 ON poDetalle.esti_Id			   = esti.esti_Id
	   LEFT JOIN Prod.tbTallas							AS talla			 ON poDetalle.tall_Id			   = talla.tall_Id
	   LEFT JOIN Prod.tbColores							AS colr				 ON poDetalle.colr_Id			   = colr.colr_Id
	   LEFT JOIN Prod.tbOrdenCompra						AS po				 ON poDetpedidoDet.orco_Id		   = po.orco_Id
	   LEFT JOIN Gral.tbProveedores						AS prov				 ON pedidos.prov_Id			       = prov.prov_Id
	   LEFT JOIN Adua.tbDuca							AS duca				 ON pedidos.duca_Id				   = duca.duca_Id
	   LEFT JOIN Acce.tbUsuarios						AS UsuCreacion       ON lotes.usua_UsuarioCreacion     = UsuCreacion.usua_Id
	   LEFT JOIN Acce.tbUsuarios						AS UsuModificacion   ON lotes.usua_UsuarioModificacion = UsuModificacion.usua_Id
	   LEFT JOIN Acce.tbUsuarios						AS UsuEliminacion    ON lotes.usua_UsuarioEliminacion  = UsuEliminacion.usua_Id
 WHERE lotes.lote_Estado                                                                     = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbLotes_Materiales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [Prod].[UDP_tbLotes_Materiales] --'CW20230827'
(
	@lote_CodigoLote NVARCHAR(40)
)
AS
BEGIN
	SELECT	lote_Id,
			tblotes.lote_CodigoLote,
			tblotes.mate_Id,
			mate_Descripcion,
			tblotes.lote_Stock,
			tbarea.tipa_area,
			tbcolo.colr_Id,
			tbcolo.colr_Nombre
	FROM Prod.tbLotes tblotes			
			INNER JOIN Prod.tbMateriales tbmats		ON tblotes.mate_Id = tbmats.mate_Id
			INNER JOIN Prod.tbArea	tbarea			ON tblotes.tipa_Id = tbarea.tipa_Id
			LEFT JOIN Prod.tbColores tbcolo			ON tblotes.colr_Id = tbcolo.colr_Id
	WHERE tblotes.lote_CodigoLote = @lote_CodigoLote
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinaHistorial_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbMaquinaHistorial_Editar]
	@mahi_Id					INT,
	@maqu_Id					INT, 
	@mahi_FechaInicio			DATETIME, 
	@mahi_FechaFin				DATETIME, 
	@mahi_Observaciones			NVARCHAR(350), 
	@usua_UsuarioModificacion	INT, 
	@mahi_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbMaquinaHistorial
		SET maqu_Id						= @maqu_Id, 
			mahi_FechaInicio			= @mahi_FechaInicio, 
			mahi_FechaFin				= @mahi_FechaFin, 
			mahi_Observaciones			= @mahi_Observaciones, 
			usua_UsuarioModificacion	= @usua_UsuarioModificacion, 
			mahi_FechaModificacion		= @mahi_FechaModificacion
		WHERE mahi_Id = @mahi_Id

		SELECT 1

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

/*Editar Maquinaria Historial*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinaHistorial_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbMaquinaHistorial_Eliminar]
	@mahi_Id					INT,
	@usua_UsuarioEliminacion	INT, 
	@mahi_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbMaquinaHistorial
		SET usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
			mahi_FechaEliminacion = @mahi_FechaEliminacion,
			mahi_Estado = 0
		WHERE mahi_Id = @mahi_Id

		SELECT 1 
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinaHistorial_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbMaquinaHistorial_Insertar]
	@maqu_Id				INT, 
	@mahi_FechaInicio		DATETIME, 
	@mahi_FechaFin			DATETIME, 
	@mahi_Observaciones		NVARCHAR(350), 
	@usua_UsuarioCreacion	INT, 
	@mahi_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbMaquinaHistorial(maqu_Id, 
												mahi_FechaInicio, 
												mahi_FechaFin, 
												mahi_Observaciones, 
												usua_UsuarioCreacion, 
												mahi_FechaCreacion)
		VALUES(@maqu_Id,@mahi_FechaInicio,@mahi_FechaFin,@mahi_Observaciones,@usua_UsuarioCreacion,@mahi_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

/*Editar Maquinaria Historial*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinaHistorial_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbMaquinaHistorial_Listar]
AS
BEGIN
	SELECT	mahi_Id, 
			maquiHisto.maqu_Id, 
			maquina.maqu_NumeroSerie		AS MaquinaNumeroSerie,
			mahi_FechaInicio, 
			mahi_FechaFin, 
			mahi_Observaciones, 
			maquiHisto.usua_UsuarioCreacion, 
			usuarioCrea.usua_Nombre			AS  usuarioCreacionNombre, 
			mahi_FechaCreacion, 
			maquiHisto.usua_UsuarioModificacion, 
			usuarioModifica.usua_Nombre		AS usuarioModificaNombre,
			mahi_FechaModificacion, 
			maquiHisto.usua_UsuarioEliminacion, 
			usuarioElimina.usua_Nombre		AS usuarioEliminaNombre,
			mahi_FechaEliminacion, 
			mahi_Estado
	FROM	Prod.tbMaquinaHistorial maquiHisto 
	INNER JOIN Prod.tbMaquinas	maquina				ON maquiHisto.maqu_Id = maquina.maqu_Id
	LEFT JOIN  Acce.tbUsuarios	usuarioCrea			ON maquiHisto.usua_UsuarioCreacion = usuarioCrea.usua_Id 
	LEFT JOIN  Acce.tbUsuarios	usuarioModifica		ON maquiHisto.usua_UsuarioModificacion = usuarioModifica.usua_Id	
	LEFT JOIN  Acce.tbUsuarios	usuarioElimina		ON maquiHisto.usua_UsuarioEliminacion = usuarioElimina.usua_Id
	WHERE mahi_Estado = 1
END

/*Insertar Maquinaria Historial*/
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar Maquinas*/
CREATE   PROCEDURE [Prod].[UDP_tbMaquinas_Editar] 
	@maqu_Id				    INT,
	@maqu_NumeroSerie		    NVARCHAR(100),
	@modu_Id                    INT,
    @mmaq_Id                    INT, 
	@usua_UsuarioModificacion	INT,
	@maqu_FechaModificacion	    DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT maqu_Id
				   FROM Prod.tbMaquinas
				   WHERE maqu_NumeroSerie = @maqu_NumeroSerie
				   AND maqu_Estado = 0)
			BEGIN
				DELETE FROM Prod.tbMaquinas
				WHERE maqu_NumeroSerie = @maqu_NumeroSerie
				AND maqu_Estado = 0
			END
		UPDATE Prod.tbMaquinas
		   SET maqu_NumeroSerie         = @maqu_NumeroSerie
			  ,modu_Id                  = @modu_Id
			  ,mmaq_Id                  = @mmaq_Id
			  ,usua_UsuarioModificacion = @usua_UsuarioModificacion
			  ,maqu_FechaModificacion   = @maqu_FechaModificacion
		 WHERE maqu_Id                  = @maqu_Id
		 SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinas_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar Maquinas*/
CREATE   PROCEDURE [Prod].[UDP_tbMaquinas_Eliminar]  
	@maqu_Id						INT,
	@usua_UsuarioEliminacion		INT,
	@maqu_FechaEliminacion			DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'maqu_Id', @maqu_Id, 'Prod.tbMaquinas', @respuesta OUTPUT

		SELECT @respuesta AS Resultado
		IF(@respuesta) = 1
			BEGIN
				UPDATE	Prod.tbMaquinas
				SET		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						maqu_FechaEliminacion   = @maqu_FechaEliminacion,
						maqu_Estado          	= 0
				WHERE	maqu_Id                 = @maqu_Id
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar Maquinas*/
CREATE   PROCEDURE [Prod].[UDP_tbMaquinas_Insertar] 
	@maqu_NumeroSerie		NVARCHAR(100),
	@modu_Id                INT,
    @mmaq_Id                INT, 
	@usua_UsuarioCreacion	INT,
	@maqu_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
			BEGIN
				INSERT INTO Prod.tbMaquinas (maqu_NumeroSerie,
				                             mmaq_Id,modu_Id, 
											 usua_UsuarioCreacion, 
											 maqu_FechaCreacion)
				     VALUES (@maqu_NumeroSerie,
				             @mmaq_Id,@modu_Id,
						     @usua_UsuarioCreacion,
						     @maqu_FechaCreacion);
				     SELECT 1
			END
	END TRY
	BEGIN CATCH
	 SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaquinas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************************************************************************   Tabla Maquinas inicio   ***********************************************************************************************

/*Listar Maquinas*/
CREATE   PROCEDURE [Prod].[UDP_tbMaquinas_Listar]
AS
BEGIN
	
	SELECT	maqu_Id,
		    maqu_NumeroSerie,
			maqu.mmaq_Id,
			molM.mmaq_Nombre,
			maqu.modu_Id,		    
			modu.modu_Nombre                    ,
			maqu.usua_UsuarioCreacion,
		    usu.usua_Nombre                     AS usuarioCreacionNombre,
			maqu_FechaCreacion,
		    maqu.usua_UsuarioModificacion,
		    usu1.usua_Nombre                    AS usuarioModificacionNombre,
			maqu_FechaModificacion,
			usu2.usua_Nombre                    AS usuarioEliminacionNombre,
			maqu.usua_UsuarioEliminacion,
			maqu_Estado
     FROM	Prod.tbMaquinas maqu		
            LEFT JOIN   Prod.tbModulos modu         ON modu.modu_Id                   = maqu.modu_Id
            LEFT JOIN   Acce.tbUsuarios usu         ON usu.usua_Id                    = maqu.usua_UsuarioCreacion
            LEFT JOIN   Acce.tbUsuarios usu1       ON usu1.usua_Id  = maqu.usua_UsuarioModificacion
            LEFT JOIN   Acce.tbUsuarios usu2       ON usu2.usua_Id   = maqu.usua_UsuarioEliminacion
			LEFT JOIN  Prod.tbModelosMaquina molM  ON molM.mmaq_Id                   = maqu.mmaq_Id
     WHERE  maqu.maqu_Estado                                                         = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMarcasMaquina_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar  MarcasMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbMarcasMaquina_Editar] 
	@marq_Id					INT,
	@marq_Nombre				NVARCHAR(250),
	@usua_UsuarioModificacion	INT,
	@marq_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
	IF EXISTS(SELECT * FROM 
			  Prod.tbMarcasMaquina 
			  WHERE marq_Nombre = @marq_Nombre 
			  AND marq_Estado = 0)
			BEGIN
				DELETE FROM Prod.tbMarcasMaquina 
				WHERE marq_Nombre = @marq_Nombre 
				AND marq_Estado = 0
			END

	UPDATE	Prod.tbMarcasMaquina
	SET		marq_Nombre = @marq_Nombre,
			usua_UsuarioModificacion = @usua_UsuarioModificacion,
			marq_FechaModificacion = @marq_FechaModificacion
	WHERE	marq_Id  = @marq_Id

	SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMarcasMaquina_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar  MarcasMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbMarcasMaquina_Eliminar] 
	@marq_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@marq_FechaEliminacion		DATETIME
AS
BEGIN
	SET @marq_FechaEliminacion = GETDATE();
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'marq_Id', @marq_Id, 'Prod.tbMarcasMaquina', @respuesta OUTPUT

		SELECT @respuesta AS Resultado
			IF(@respuesta) = 1
				BEGIN
					UPDATE	Prod.tbMarcasMaquina
					SET		marq_Estado = 0,
							usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
							marq_FechaEliminacion = @marq_FechaEliminacion
					WHERE	marq_Id = @marq_Id
				END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMarcasMaquina_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar MarcasMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbMarcasMaquina_Insertar] 
	@marq_Nombre			NVARCHAR(250),
	@usua_UsuarioCreacion	INT,
	@marq_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT marq_Id FROM Prod.tbMarcasMaquina WHERE marq_Nombre = @marq_Nombre AND marq_Estado = 0)
			BEGIN
				UPDATE	Prod.tbMarcasMaquina
				SET		marq_Estado = 1
				WHERE   marq_Nombre = @marq_Nombre
				SELECT 1
			END
		ELSE
			BEGIN
				INSERT INTO Prod.tbMarcasMaquina (marq_Nombre, usua_UsuarioCreacion, marq_FechaCreacion, usua_UsuarioModificacion, marq_FechaModificacion, marq_Estado)
				VALUES(@marq_Nombre,@usua_UsuarioCreacion,@marq_FechaCreacion,NULL,NULL,1)
				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMarcasMaquinas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************MARCAS MAQUINAS******************--
/*Listar MarcasMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbMarcasMaquinas_Listar]
AS
BEGIN
	SELECT  mrqu.marq_Id,
		    mrqu.marq_Nombre,

			mrqu.usua_UsuarioCreacion,			
			Usu.usua_Nombre				AS UsuarioCreacion,
            mrqu.marq_FechaCreacion,

            mrqu.usua_UsuarioModificacion,
			usu1.usua_Nombre			AS UsuarioModificador, 
            mrqu.marq_FechaModificacion,

			mrqu.usua_UsuarioEliminacion,
			usu2.usua_Nombre			AS UsuarioEliminacion, 
            mrqu.marq_FechaEliminacion ,
           
		    mrqu.marq_Estado 
   
    FROM    Prod.tbMarcasMaquina mrqu 
	INNER JOIN Acce.tbUsuarios usu ON usu.usua_Id = mrqu.usua_UsuarioCreacion
	 LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_Id =  mrqu.usua_UsuarioModificacion
	 LEFT JOIN Acce.tbUsuarios usu2 ON usu2.usua_Id =  mrqu.usua_UsuarioEliminacion
    WHERE	mrqu.marq_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMateriales_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar material*/
CREATE   PROCEDURE [Prod].[UDP_tbMateriales_Editar]  
	@mate_Id                   INT,
	@mate_Descripcion          NVARCHAR(200), 
	@subc_Id                   INT, 
	@colr_Id                  INT,
	@mate_Imagen			   NVARCHAR(MAX), 
	@usua_UsuarioModificacion  INT, 
	@mate_FechaModificacion    DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Prod.tbMateriales
		SET		mate_Descripcion         = @mate_Descripcion,
		        subc_Id                  = @subc_Id,
				mate_Imagen				 = @mate_Imagen,
				colr_Id                  = @colr_Id,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				mate_FechaModificacion   = @mate_FechaModificacion
		WHERE	mate_Id = @mate_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMateriales_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar materiales*/
CREATE   PROCEDURE [Prod].[UDP_tbMateriales_Eliminar]
	@mate_Id					INT	
AS
BEGIN
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'mate_Id', @mate_Id, 'Prod.tbMateriales', @respuesta OUTPUT

			IF(@respuesta) = 1
			BEGIN
				UPDATE	Prod.tbMateriales
				   SET	mate_Estado = 0
				 WHERE  mate_Id     = @mate_Id
			END

			SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMateriales_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Insertar materiales*/
CREATE   PROCEDURE [Prod].[UDP_tbMateriales_Insertar]
	 @mate_Descripcion         NVARCHAR(200),
	 @subc_Id                  INT,
	 @colr_Id                  INT,
	 @mate_Imagen			   NVARCHAR(MAX),
	 @usua_UsuarioCreacion     INT, 
	 @mate_FechaCreacion       DATETIME
AS 
BEGIN
	
	BEGIN TRY
		INSERT INTO Prod.tbMateriales (mate_Descripcion, subc_Id, colr_Id,mate_Imagen, usua_UsuarioCreacion, mate_FechaCreacion)
		VALUES(@mate_Descripcion, @subc_Id, @colr_Id, @mate_Imagen, @usua_UsuarioCreacion, @mate_FechaCreacion)
		
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMateriales_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************MATERIALES******************--
/*Listar materiales*/
CREATE   PROCEDURE [Prod].[UDP_tbMateriales_Listar]
AS
BEGIN
	SELECT mate.mate_Id,
           mate.mate_Descripcion, 
	       mate.subc_Id,
	       subc.subc_Descripcion,
		   cate.cate_Id,
		   cate.cate_Descripcion,
		   colo.colr_Id,
		   colo.colr_Nombre,
		   mate.mate_Imagen, 
	       mate.usua_UsuarioCreacion, 
	       usuaCrea.usua_Nombre							AS usuarioCreacionNombre,
	       mate.mate_FechaCreacion, 
	       mate.usua_UsuarioModificacion, 
	       usuaModifica.usua_Nombre						AS usuarioModificaNombre,
		   mate.mate_FechaModificacion,
	       mate.mate_Estado
      FROM Prod.tbMateriales mate 
	       INNER JOIN Acce.tbUsuarios usuaCrea			ON mate.usua_UsuarioCreacion     = usuaCrea.usua_Id 
	       LEFT JOIN Acce.tbUsuarios usuaModifica		ON mate.usua_UsuarioModificacion = usuaModifica.usua_Id 
	       LEFT JOIN Prod.tbSubcategoria subc			ON mate.subc_Id                  = subc.subc_Id
		   LEFT JOIN Prod.tbCategoria  cate            ON cate.cate_Id                  = subc.cate_Id
		   LEFT JOIN Prod.tbColores  colo               ON mate.colr_Id                  = colo.colr_Id   
	 WHERE mate_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaterialesBrindar_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROC [Prod].[UDP_tbMaterialesBrindar_Editar]
@mabr_Id					INT,
@code_Id					INT, 
@mate_Id					INT, 
@mabr_Cantidad				INT, 
@unme_Id					INT,
@usua_UsuarioModificacion	INT, 
@mabr_FechaModificacion		DATETIME
AS 
BEGIN
	BEGIN TRY
		UPDATE  Prod.tbMaterialesBrindar
		SET		code_Id						= @code_Id,				
				mate_Id						= @mate_Id,				 
				mabr_Cantidad				= @mabr_Cantidad,
				unme_Id						= @unme_Id,
				usua_UsuarioModificacion	= @usua_UsuarioModificacion,
				mabr_FechaModificacion		= @mabr_FechaModificacion	
		WHERE	mabr_Id						= @mabr_Id
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaterialesBrindar_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbMaterialesBrindar_Eliminar]
	@mabr_Id	INT
AS
BEGIN
	BEGIN TRY 
		DELETE FROM Prod.tbMaterialesBrindar WHERE mabr_Id = @mabr_Id
		SELECT 1
	END TRY
	BEGIN CATCH 
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaterialesBrindar_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbMaterialesBrindar_Insertar] 
@code_Id					INT, 
@mate_Id					INT, 
@mabr_Cantidad				INT, 
@unme_Id					INT,
@usua_UsuarioCreacion		INT, 
@mabr_FechaCreacion			DATETIME
AS 
BEGIN
	BEGIN TRY

		INSERT INTO Prod.tbMaterialesBrindar (code_Id, 
		                                      mate_Id, 
		                                      mabr_Cantidad, 
											  unme_Id,
		                                      usua_UsuarioCreacion, 
		                                      mabr_FechaCreacion)
		    VALUES (@code_Id,				
		            @mate_Id,				
		            @mabr_Cantidad,	
					@unme_Id,
		            @usua_UsuarioCreacion,
		            @mabr_FechaCreacion)
		   SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaterialesBrindar_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------
--MATERIALES BRINDADOS ---------------------------------------------------------------------------------

CREATE     PROC [Prod].[UDP_tbMaterialesBrindar_Listar]
AS
BEGIN
	SELECT	mabr_Id, 
			mabr.code_Id, 
			ordeC.code_CantidadPrenda,
			mabr.mate_Id, 
			mate.mate_Descripcion,
			mabr_Cantidad, 
			unid.unme_Id,
			unid.unme_Descripcion,
			mabr.usua_UsuarioCreacion, 
			usuCrea.usua_Nombre              AS usuarioCreacionNombre,
			mabr_FechaCreacion,
			mabr.usua_UsuarioModificacion,
			usuModi.usua_Nombre              AS usuarioModificacionNombre,
			mabr_FechaModificacion, 
			mabr_Estado
	  FROM  Prod.tbMaterialesBrindar mabr
	        INNER JOIN Acce.tbUsuarios usuCrea           ON usuCrea.usua_Id = mabr.usua_UsuarioCreacion
			LEFT JOIN Acce.tbUsuarios usuModi            ON usuModi.usua_Id = mabr.usua_UsuarioModificacion
			LEFT JOIN Prod.tbOrdenCompraDetalles ordeC   ON ordeC.code_Id   = mabr.code_Id
			LEFT JOIN Prod.tbMateriales mate             ON mate.mate_Id    = mabr.mate_Id
			INNER JOIN Gral.tbUnidadMedidas unid		 ON mabr.unme_Id	= unid.unme_Id
	  WHERE mabr_Estado = 1

END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbMaterialesBrindarPorOrdenCompraDetalle_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*PROCEDIMIENTO DE Listar materiales a brindar por el code_Id*/

CREATE   PROCEDURE [Prod].[UDP_tbMaterialesBrindarPorOrdenCompraDetalle_Listar] 
@code_Id		INT
AS
BEGIN
	SELECT	mabr_Id, 
			mabr.code_Id, 
			ordeC.code_CantidadPrenda,
			mabr.mate_Id, 
			mate.mate_Descripcion,
			mabr_Cantidad, 
			unid.unme_Id,
			unid.unme_Descripcion,
			mabr.usua_UsuarioCreacion, 
			usuCrea.usua_Nombre              AS usuarioCreacionNombre,
			mabr_FechaCreacion,
			mabr.usua_UsuarioModificacion,
			usuModi.usua_Nombre              AS usuarioModificacionNombre,
			mabr_FechaModificacion, 
			mabr_Estado
	  FROM  Prod.tbMaterialesBrindar mabr
	        INNER JOIN Acce.tbUsuarios usuCrea           ON usuCrea.usua_Id = mabr.usua_UsuarioCreacion
			LEFT JOIN Acce.tbUsuarios usuModi            ON usuModi.usua_Id = mabr.usua_UsuarioModificacion
			LEFT JOIN Prod.tbOrdenCompraDetalles ordeC   ON ordeC.code_Id   = mabr.code_Id
			LEFT JOIN Prod.tbMateriales mate             ON mate.mate_Id    = mabr.mate_Id
			INNER JOIN Gral.tbUnidadMedidas unid		 ON mabr.unme_Id	= unid.unme_Id
	  WHERE mabr_Estado = 1 AND mabr.code_Id = @code_Id
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModelosMaquina_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar procedimiento de listar ModelosMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbModelosMaquina_Editar] 
	@mmaq_Id					INT,
	@mmaq_Nombre				NVARCHAR(250),
	@marq_Id					INT,
	@func_Id					INT,
	@mmaq_Imagen				NVARCHAR(MAX),
	@usua_UsuarioModificacion	INT,
	@mmaq_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbModelosMaquina
		   SET mmaq_Nombre               = @mmaq_Nombre,
		       marq_Id                   = @marq_Id,
			   func_Id                   = @func_Id,
			   mmaq_Imagen               = @mmaq_Imagen,
			   usua_UsuarioModificacion  = @usua_UsuarioModificacion,
			   mmaq_FechaModificacion    = @mmaq_FechaModificacion
		 WHERE mmaq_Id                   = @mmaq_Id
		 SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModelosMaquina_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Eliminar procedimiento de listar ModelosMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbModelosMaquina_Eliminar] 
	@mmaq_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@mmaq_FechaEliminacion	    DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
		EXEC dbo.UDP_ValidarReferencias 'mmaq_Id', @mmaq_Id, 'Prod.tbModelosMaquina', @respuesta OUTPUT

		SELECT @respuesta AS Resultado
		IF(@respuesta = 1)
			BEGIN
				UPDATE	Prod.tbModelosMaquina
				SET		mmaq_Estado             = 0,
						usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						mmaq_FechaEliminacion   = @mmaq_FechaEliminacion
				WHERE	mmaq_Id                 = @mmaq_Id
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()		
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModelosMaquina_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar procedimiento de listar ModelosMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbModelosMaquina_Insertar] 
	@mmaq_Nombre				NVARCHAR(250),
	@marq_Id					INT,
	@func_Id					INT,
	@mmaq_Imagen				NVARCHAR(MAX),
	@usua_UsuarioCreacion		INT,
	@mmaq_FechaCreacion			DATETIME
AS
BEGIN
	BEGIN TRY	
			BEGIN
				INSERT INTO Prod.tbModelosMaquina (mmaq_Nombre, 
				                                   marq_Id, 
												   func_Id,  
												   mmaq_Imagen, 
												   usua_UsuarioCreacion, 
												   mmaq_FechaCreacion)
				     VALUES (@mmaq_Nombre,
					         @marq_Id,
							 @func_Id,
							 @mmaq_Imagen,
							 @usua_UsuarioCreacion,
							 @mmaq_FechaCreacion)
				     SELECT  1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()	
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModelosMaquina_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************************************************************************   Tabla Modelos maquinas inicio   ***********************************************************************************************

--Listar Modelos Maquina

/*Ejecutar procedimiento de listar ModelosMaquina*/
CREATE   PROCEDURE [Prod].[UDP_tbModelosMaquina_Listar]
AS
BEGIN
	SELECT	moma.mmaq_Id,
		    moma.mmaq_Nombre,
		    moma.mmaq_Imagen,
			moma.marq_Id,       
		    mrqu.marq_Nombre ,                         
			moma.func_Id,
		    fuma.func_Nombre      ,                    
			moma.usua_UsuarioCreacion,
			usu.usua_Nombre         ,                  
			moma.mmaq_FechaCreacion,
			moma.usua_UsuarioModificacion,
			usu1.usua_Nombre                          AS UsuarioModificacion,
			moma.mmaq_FechaModificacion,
			moma.usua_UsuarioEliminacion,
			usuEli.usua_Nombre                        AS usuarioEliminacionNombre,
			moma.mmaq_FechaEliminacion,
            moma.mmaq_Estado
  FROM	    Prod.tbModelosMaquina moma  
            INNER JOIN Prod.tbFuncionesMaquina fuma    ON moma.func_Id                  = fuma.func_Id 
			INNER JOIN Acce.tbUsuarios usu             ON usu.usua_Id                   = moma.usua_UsuarioCreacion 
			LEFT JOIN Acce.tbUsuarios usu1             ON usu1.usua_UsuarioModificacion = moma.usua_UsuarioModificacion
			LEFT JOIN Acce.tbUsuarios usuEli           ON usuEli.usua_Id                = moma.usua_UsuarioEliminacion
			INNER JOIN Prod.tbMarcasMaquina	mrqu       ON mrqu.marq_Id                  = moma.marq_Id 
			WHERE moma.mmaq_Estado                                                      = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModulos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Modulos*/
CREATE   PROCEDURE [Prod].[UDP_tbModulos_Editar]  
	@modu_Id					INT,
	@modu_Nombre				NVARCHAR(200),
	@proc_Id					INT,
	@empr_Id					INT,
	@usua_UsuarioModificacion	INT,
	@modu_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT modu_Id
					FROM Prod.tbModulos
					WHERE modu_Nombre = @modu_Nombre
					AND modu_Estado = 0)
			BEGIN
				DELETE FROM Prod.tbModulos
				WHERE modu_Nombre = @modu_Nombre
				AND modu_Estado = 0
			END
		UPDATE Prod.tbModulos
		   SET modu_Nombre = @modu_Nombre
			  ,proc_Id = @proc_Id
			  ,empr_Id = @empr_Id
			  ,usua_UsuarioModificacion = @usua_UsuarioModificacion
			  ,modu_FechaModificacion = @modu_FechaModificacion
		 WHERE modu_Id = @modu_Id
		 SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModulos_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar Modulos*/
CREATE   PROCEDURE [Prod].[UDP_tbModulos_Eliminar]    
	@modu_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@modu_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'modu_Id', @modu_Id, 'Prod.tbModulos', @respuesta OUTPUT

			IF(@respuesta) = 1
			BEGIN
				 UPDATE Prod.tbModulos
				    SET usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						modu_FechaEliminacion   = @modu_FechaEliminacion,
						modu_Estado             = 0
				  WHERE modu_Id                 = @modu_Id
			END

			SELECT @respuesta AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModulos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Modulos*/
CREATE   PROCEDURE [Prod].[UDP_tbModulos_Insertar] 
	@modu_Nombre			NVARCHAR(200),
	@proc_Id				INT,
	@empr_Id				INT,
	@usua_UsuarioCreacion	INT,
	@modu_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT modu_Id FROM Prod.tbModulos WHERE modu_Nombre = @modu_Nombre AND modu_Estado = 0)
			BEGIN
				UPDATE Prod.tbModulos
				SET	   modu_Estado = 1
				WHERE  modu_Nombre = @modu_Nombre 
				SELECT 1
			END
		ELSE
			BEGIN 
				INSERT INTO Prod.tbModulos (modu_Nombre, proc_Id, empr_Id, usua_UsuarioCreacion, modu_FechaCreacion)
				VALUES (@modu_Nombre,@proc_Id,@empr_Id,@usua_UsuarioCreacion,@modu_FechaCreacion);
				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END 







GO
/****** Object:  StoredProcedure [Prod].[UDP_tbModulos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----************INSPECCION ESTADO******************--
--/*Listar INSPECCION ESTADO*/
--CREATE OR ALTER PROCEDURE Prod.UDP_tbInspeccionesEstado_Listar
--AS
--BEGIN
--	SELECT insp.ines_Id,
--           insp.reca_Id, 
--	       revi.reca_Descripcion						AS revisionDescripcion,
--	       insp.usua_UsuarioCreacion, 
--	       usuaCrea.usua_Nombre							AS usuarioCreacionNombre,
--	       insp.ines_FechaCreacion, 
--	       insp.usua_UsuarioModificacion, 
--	       usuaModifica.usua_Nombre						AS usuarioModificaNombre,
--	       insp.ines_FechaModificacion,
--		   insp.usua_UsuarioEliminacion,
--           ines_FechaEliminacion,
--		   usuaElimi.usua_Nombre                        AS usuarioEliminaNombre,
--	       insp.ines_Estado   
--      FROM Prod.tbInspeccionesEstado insp 
--	       INNER JOIN Acce.tbUsuarios usuaCrea			ON insp.usua_UsuarioCreacion     = usuaCrea.usua_Id 
--		   LEFT JOIN  Acce.tbUsuarios usuaModifica		ON insp.usua_UsuarioModificacion = usuaModifica.usua_Id 
--		   LEFT JOIN  Acce.tbUsuarios usuaElimi		    ON insp.usua_UsuarioEliminacion  = usuaElimi.usua_Id 
--		   INNER JOIN Prod.tbRevisionDeCalidad revi		ON insp.reca_Id = revi.reca_Id
--	 WHERE ines_Estado = 1

--END
--GO

--/*Insertar inspecciones estado*/
--CREATE OR ALTER PROCEDURE Prod.UDP_tbInspeccionesEstado_Insertar
--	 @reca_Id                INT, 
--	 @usua_UsuarioCreacion   INT, 
--	 @ines_FechaCreacion     DATETIME 
--AS 
--BEGIN
	
--	BEGIN TRY
--			INSERT INTO Prod.tbInspeccionesEstado(reca_Id, usua_UsuarioCreacion, ines_FechaCreacion)
--			VALUES(@reca_Id, @usua_UsuarioCreacion, @ines_FechaCreacion)
--			SELECT 1
--	END TRY
--	BEGIN CATCH
--		SELECT 'Error Message: ' + ERROR_MESSAGE()
--	END CATCH 
--END
--GO

--/*Editar inspecciones estado*/
--CREATE OR ALTER PROCEDURE Prod.UDP_tbInspeccionesEstado_Editar
--	@ines_Id                   INT,
--	@reca_Id                   INT, 
--	@usua_UsuarioModificacion  INT, 
--	@ines_FechaModificacion    DATETIME
--AS
--BEGIN
--	BEGIN TRY
--		UPDATE  Prod.tbInspeccionesEstado
--		SET		reca_Id                  = @reca_Id,
--		        usua_UsuarioModificacion = @usua_UsuarioModificacion,
--				ines_FechaModificacion   = @ines_FechaModificacion
--		WHERE	ines_Id = @ines_Id

--		SELECT 1
--	END TRY
--	BEGIN CATCH
--		SELECT 'Error Message: ' + ERROR_MESSAGE()
--	END CATCH
--END
--GO
--/*Eliminar inspecciones estado*/
--CREATE OR ALTER PROCEDURE Prod.UDP_tbInspeccionesEstado_Eliminar
--	@ines_Id					INT,
--	@usua_UsuarioEliminacion	INT,
--	@ines_FechaEliminacion		DATETIME
--AS
--BEGIN
--	SET @ines_FechaEliminacion = GETDATE();
--	BEGIN TRY
--			DECLARE @respuesta INT
--			EXEC dbo.UDP_ValidarReferencias 'ines_Id', @ines_Id, 'Prod.tbInspeccionesEstado', @respuesta OUTPUT

--			SELECT @respuesta AS Resultado
--			IF(@respuesta) = 1
--			BEGIN
--				UPDATE	Prod.tbInspeccionesEstado
--				SET		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
--						ines_FechaEliminacion = @ines_FechaEliminacion,
--						ines_Estado = 0
--			END
--	END TRY
--	BEGIN CATCH
--		SELECT 'Error Message: ' + ERROR_MESSAGE()
--	END CATCH
--END
--GO



--************MODULOS******************--
/*Listar Modulos*/
CREATE   PROCEDURE [Prod].[UDP_tbModulos_Listar]
AS
BEGIN
SELECT  modu_Id, 
        modu_Nombre, 
	    
		modu.proc_Id,	
		pro.proc_Descripcion,
	    
		empr_Id,
	    emp.empl_Nombres + ' ' + emp.empl_Apellidos AS empl_NombreCompleto,
	    
		modu.usua_UsuarioCreacion,
	    crea.usua_Nombre AS UsuarioCreacion,
		modu_FechaCreacion, 
		modu.usua_UsuarioModificacion, 
		modi.usua_Nombre AS UsuarioModifica,
		modu_FechaModificacion,	    
		modu.usua_UsuarioEliminacion,
		elim.usua_Nombre AS UsuarioEliminacion,
		modu_FechaEliminacion,
		
		modu_Estado 
		
		FROM Prod.tbModulos modu 
		inner join Acce.tbUsuarios crea       ON crea.usua_Id = modu.usua_UsuarioCreacion		
		LEFT JOIN Acce.tbUsuarios modi       ON modi.usua_Id = modu.usua_UsuarioModificacion
		LEFT JOIN Acce.tbUsuarios elim       ON elim.usua_Id = modu.usua_UsuarioEliminacion
		INNER JOIN Gral.tbEmpleados emp  ON modu.empr_Id = emp.empl_Id
		INNER JOIN Prod.tbProcesos pro   ON pro.proc_Id = modu.proc_Id
		WHERE modu.modu_Estado = 1
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Editar ORDEN ENSABLAJE ACBADO ETIQUEDATO*/
CREATE   PROCEDURE [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Editar]
@ensa_Id					INT,
@ensa_Cantidad				INT,
@empl_Id					INT,
@code_Id					INT,
@ensa_FechaInicio			DATE,	
@ensa_FechaLimite			DATE,
@ppro_Id					INT,
@modu_Id					INT,
@usua_UsuarioModificacion	INT,
@ensa_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbOrde_Ensa_Acab_Etiq
		SET		ensa_Cantidad			= @ensa_Cantidad,			
				empl_Id					= @empl_Id, 
				code_Id					= @code_Id,				
				ensa_FechaInicio		= @ensa_FechaInicio, 
				ensa_FechaLimite		= @ensa_FechaLimite,		
				ppro_Id					= @ppro_Id, 
				modu_Id					= @modu_Id,
				usua_UsuarioCreacion	= @usua_UsuarioModificacion,	
				ensa_FechaCreacion		= @ensa_FechaModificacion
		WHERE	ensa_Id					= @ensa_Id
		
		UPDATE [Prod].tbPedidosProduccion  SET
		[ppro_Finalizado] = 1,
		[ppro_Estados] = 'Entregada'
		WHERE [ppro_Id] = @ppro_Id

		UPDATE [Prod].[tbOrdenCompraDetalles] SET
		proc_IdActual = (SELECT proc_Id FROM Prod.tbModulos WHERE modu_Id = @modu_Id )
		WHERE code_Id = @code_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar ORDEN ENSABLAJE ACBADO ETIQUEDATO*/
CREATE   PROCEDURE [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Insertar] 
@ensa_Cantidad			INT,
@empl_Id				INT,
@code_Id				INT,
@ensa_FechaInicio		DATE,	
@ensa_FechaLimite		DATE,
@ppro_Id				INT,
@modu_Id				INT,
@usua_UsuarioCreacion	INT,
@ensa_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbOrde_Ensa_Acab_Etiq (ensa_Cantidad,			
												empl_Id, 
												code_Id,				
												ensa_FechaInicio, 
												ensa_FechaLimite,		ppro_Id, 
												usua_UsuarioCreacion,	ensa_FechaCreacion, 
												modu_Id)
		VALUES (
		@ensa_Cantidad,			
		@empl_Id, 
		@code_Id,				
		@ensa_FechaInicio, 
		@ensa_FechaLimite,		
		@ppro_Id, 
		@usua_UsuarioCreacion,	
		@ensa_FechaCreacion,
		@modu_Id
		)

		UPDATE [Prod].tbPedidosProduccion  SET
		[ppro_Finalizado] = 1,
		[ppro_Estados] = 'Entregada'
		WHERE [ppro_Id] = @ppro_Id

		UPDATE [Prod].[tbOrdenCompraDetalles] 
		SET proc_IdActual = (SELECT proc_Id FROM Prod.tbModulos WHERE modu_Id = @modu_Id )
		WHERE code_Id = @code_Id
		SELECT 1		
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************ORDEN ENSABLAJE ACBADO ETIQUEDATO******************--
/*Listar ORDEN ENSABLAJE ACBADO ETIQUEDATO*/
CREATE   PROCEDURE [Prod].[UDP_tbOrde_Ensa_Acab_Etiq_Listar]
AS
BEGIN
SELECT    ensa_Id, 
        ensa_Cantidad, 
        emp.empl_Id, 
        CONCAT(emp.empl_Nombres ,' ',emp.empl_Apellidos) AS empl_NombreCompleto,
        ocd.code_Id,
        ocd.code_Sexo,
        est.esti_Id,
        est.esti_Descripcion,
        ensa_FechaInicio, 
        ensa_FechaLimite, 
        pp.ppro_Id, 
        modu.modu_Id,
        modu.modu_Nombre,
        modu.proc_Id,
        ordenCompra.orco_Codigo,
        estilos.esti_Descripcion, --// campo nuevo
        pro.proc_Descripcion,
        crea.usua_Nombre                            AS UsurioCreacionNombre, 
        ensa_FechaCreacion,
        modi.usua_Nombre                            AS UsuarioModificacionNombre, 
        ensa_FechaModificacion, 
        ensa_Estado
        FROM    Prod.tbOrde_Ensa_Acab_Etiq ensa
        INNER JOIN Gral.tbEmpleados emp                ON emp.empl_Id  = ensa.empl_Id
        INNER JOIN Prod.tbOrdenCompraDetalles ocd    ON ocd.code_Id  = ensa.code_Id
        INNER JOIN Prod.tbEstilos est                ON est.esti_Id    = ocd.esti_Id
        INNER JOIN Prod.tbPedidosProduccion pp        ON pp.ppro_Id   = ensa.ppro_Id
        INNER JOIN Prod.tbModulos            modu    ON ensa.modu_Id = modu.modu_Id
        INNER JOIN Prod.tbProcesos    pro                ON modu.proc_Id = pro.proc_Id
        INNER JOIN Prod.tbOrdenCompra ordenCompra    ON ocd.orco_Id  = ordenCompra.orco_Id 
        INNER JOIN Prod.tbEstilos            estilos ON ocd.esti_Id  = estilos.esti_Id
        INNER JOIN Acce.tbUsuarios crea                ON crea.usua_Id = ensa.usua_UsuarioCreacion 
        LEFT JOIN  Acce.tbUsuarios modi                ON modi.usua_Id = ensa.usua_UsuarioModificacion
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompra_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE       PROCEDURE [Prod].[UDP_tbOrdenCompra_Editar]
(
	@orco_Id					INT,
	@orco_IdCliente				INT,
	@orco_FechaEmision			DATETIME,
	@orco_FechaLimite			DATETIME,
	@orco_MetodoPago 			INT,
	@orco_Materiales			BIT,
	@orco_IdEmbalaje 			INT,
	@orco_EstadoOrdenCompra		CHAR(1),
	@orco_DireccionEntrega		NVARCHAR(250),
	@usua_UsuarioModificacion   INT,
	@orco_FechaModificacion     DATETIME
)
AS
BEGIN
	BEGIN TRY
		 UPDATE Prod.tbOrdenCompra
			SET	orco_IdCliente				= @orco_IdCliente,				
				orco_FechaEmision			= @orco_FechaEmision,			
				orco_FechaLimite			= @orco_FechaLimite,			
				orco_MetodoPago				= @orco_MetodoPago, 			
				orco_Materiales				= @orco_Materiales,			
				orco_IdEmbalaje				= @orco_IdEmbalaje, 			
				orco_EstadoOrdenCompra		= @orco_EstadoOrdenCompra,		
				orco_DireccionEntrega		= @orco_DireccionEntrega,		
				usua_UsuarioModificacion	= @usua_UsuarioModificacion,       
				orco_FechaModificacion		= @orco_FechaModificacion
		  WHERE orco_Id = @orco_Id

		  SELECT 1 AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompra_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/*Eliminar orden de compra solo si no tiene detalles*/
CREATE   PROCEDURE [Prod].[UDP_tbOrdenCompra_Eliminar]
	@orco_Id		INT
AS 
BEGIN 
	BEGIN TRY
		IF EXISTS(SELECT code_Id FROM Prod.tbOrdenCompraDetalles WHERE orco_Id = @orco_Id)
			BEGIN
				SELECT 2
			END
		ELSE
			BEGIN
				/*UPDATE Prod.tbOrdenCompra
				SET [orco_Estado] = 0
				WHERE orco_Id = @orco_Id*/
				DELETE FROM Prod.tbOrdenCompra
				WHERE orco_Id = @orco_Id

				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: 'ERROR_MESSAGE;
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompra_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompra_Insertar]
(
	@orco_IdCliente				INT,
	@orco_FechaEmision			DATETIME,
	@orco_FechaLimite			DATETIME,
	@orco_MetodoPago 			INT,
	@orco_Materiales			BIT,
	@orco_IdEmbalaje 			INT,
	@orco_EstadoOrdenCompra		CHAR(1),
	@orco_DireccionEntrega		NVARCHAR(250),
	@usua_UsuarioCreacion       INT,
	@orco_FechaCreacion         DATETIME,
	@orco_Codigo				NVARCHAR(100)
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbOrdenCompra
					(orco_IdCliente,				
					orco_FechaEmision,			
					orco_FechaLimite,			
					orco_MetodoPago, 			
					orco_Materiales,			
					orco_IdEmbalaje, 			
					orco_EstadoOrdenCompra,		
					orco_DireccionEntrega,		
					usua_UsuarioCreacion,       
					orco_FechaCreacion,
					orco_Codigo)
			VALUES (@orco_IdCliente,				
					@orco_FechaEmision,			
					@orco_FechaLimite,			
					@orco_MetodoPago, 			
					@orco_Materiales,			
					@orco_IdEmbalaje, 			
					@orco_EstadoOrdenCompra,		
					@orco_DireccionEntrega,		
					@usua_UsuarioCreacion,       
					@orco_FechaCreacion,
					@orco_Codigo)
			
		SELECT SCOPE_IDENTITY() AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompra_Listado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------
--ORDEN DE COMPRA ENCABEZADO---------------------------------------------------------------------------------

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompra_Listado]
AS
BEGIN
	SELECT	 ordenCompra.orco_Id
	-- Informacion del cliente
			,ordenCompra.orco_Codigo
			,ordenCompra.orco_IdCliente
			,cliente.clie_Nombre_O_Razon_Social
			,cliente.clie_Direccion
			,cliente.clie_RTN
			,cliente.clie_Nombre_Contacto
			,cliente.clie_Numero_Contacto
			,cliente.clie_Correo_Electronico
			,cliente.clie_FAX
			,ordenCompra.orco_EstadoFinalizado
			,ordenCompra.orco_FechaEmision
			,ordenCompra.orco_FechaLimite
			,ordenCompra.orco_Materiales

			,ordenCompra.orco_MetodoPago
			,fomapago.fopa_Descripcion

	--Informacion del Embalaje
			,ordenCompra.orco_IdEmbalaje
			,tipoEmbajale.tiem_Descripcion

			,ordenCompra.orco_EstadoOrdenCompra
			,ordenCompra.orco_DireccionEntrega
			,ordenCompra.usua_UsuarioCreacion
			,usuarioCreacion.usua_Nombre		AS usuarioCreacionNombre
			,ordenCompra.orco_FechaCreacion
			,ordenCompra.usua_UsuarioModificacion
			,usuarioModificacion.usua_Nombre	AS usuarioModificacionNombre
			,ordenCompra.orco_FechaModificacion
			,ordenCompra.orco_Estado
	  FROM  Prod.tbOrdenCompra							ordenCompra
			INNER JOIN  Prod.tbClientes					cliente				ON ordenCompra.orco_IdCliente  = cliente.clie_Id
			INNER JOIN  Prod.tbTipoEmbalaje				tipoEmbajale		ON ordenCompra.orco_IdEmbalaje = tipoEmbajale.tiem_Id
			INNER JOIN	Adua.tbFormasdePago				fomapago			ON ordenCompra.orco_MetodoPago = fomapago.fopa_Id
		    INNER JOIN  Acce.tbUsuarios					usuarioCreacion		ON ordenCompra.usua_UsuarioCreacion			= usuarioCreacion.usua_Id
			LEFT  JOIN  Acce.tbUsuarios					usuarioModificacion ON ordenCompra.usua_UsuarioModificacion		= usuarioModificacion.usua_Id
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompra_ObtenerPorId_Para_LineaTiempo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompra_ObtenerPorId_Para_LineaTiempo]
(
	@orco_Codigo		nvarchar(100)
)	
AS
BEGIN
	 SELECT ordenCompra.orco_Id,
			ordenCompra.orco_Codigo,
		    --Informacion del cliente
		    ordenCompra.orco_IdCliente,
			cliente.clie_Nombre_O_Razon_Social,
			cliente.clie_Direccion,
			cliente.clie_RTN,
			cliente.clie_Nombre_Contacto,
			cliente.clie_Numero_Contacto,
			cliente.clie_Correo_Electronico,
			cliente.clie_FAX,
			
			ordenCompra.orco_FechaEmision,
			ordenCompra.orco_FechaLimite,
			ordenCompra.orco_MetodoPago,
			formasPago.fopa_Descripcion,
			ordenCompra.orco_Materiales,

			--Informacion del Embalaje
			ordenCompra.orco_IdEmbalaje,
			tipoEmbajale.tiem_Descripcion,

			ordenCompra.orco_EstadoOrdenCompra,
			ordenCompra.orco_DireccionEntrega,
			ordenCompra.usua_UsuarioCreacion,
			usuarioCreacion.usua_Nombre				AS usuarioCreacionNombre,
			ordenCompra.orco_FechaCreacion,
			ordenCompra.usua_UsuarioModificacion,
			usuarioModificacion.usua_Nombre			AS usuarioModificacionNombre,
			ordenCompra.orco_FechaModificacion,
			ordenCompra.orco_Estado
	   FROM Prod.tbOrdenCompra		ordenCompra
 INNER JOIN Prod.tbClientes			cliente					ON ordenCompra.orco_IdCliente				= cliente.clie_Id
  LEFT JOIN Adua.tbFormasdePago     formasPago				ON ordenCompra.orco_MetodoPago				= formasPago.fopa_Id
 INNER JOIN Prod.tbTipoEmbalaje		tipoEmbajale			ON ordenCompra.orco_IdEmbalaje				= tipoEmbajale.tiem_Id
 INNER JOIN Acce.tbUsuarios			usuarioCreacion			ON ordenCompra.usua_UsuarioCreacion			= usuarioCreacion.usua_Id
  LEFT JOIN Acce.tbUsuarios			usuarioModificacion		ON ordenCompra.usua_UsuarioModificacion		= usuarioModificacion.usua_Id
	  WHERE orco_Codigo = @orco_Codigo
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalle_Listado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------
--ORDEN DE COMPRA DETALLES---------------------------------------------------------------------------------

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompraDetalle_Listado]
	@orco_Id			INT
AS
BEGIN
	SELECT	 ordenCompraDetalle.code_Id
			,ordenCompraDetalle.orco_Id
			,ordenCompraDetalle.code_CantidadPrenda
			,ordenCompraDetalle.esti_Id
			,estilo.esti_Descripcion
			,ordenCompraDetalle.tall_Id
			,talla.tall_Nombre
			,ordenCompraDetalle.code_Sexo
			,ordenCompraDetalle.colr_Id
			--,colores.colr_Codigo
			,colores.colr_Nombre
	
			,ordenCompraDetalle.proc_IdComienza
			,procesoComienza.proc_Descripcion	AS proc_DescripcionComienza
			,ordenCompraDetalle.proc_IdActual
			,procesoActual.proc_Descripcion		AS proc_DescripcionActual
			,ordenCompraDetalle.code_Unidad
			,ordenCompraDetalle.code_Valor
			,ordenCompraDetalle.code_Impuesto
	
			,ordenCompraDetalle.code_EspecificacionEmbalaje
			,ordenCompraDetalle.usua_UsuarioCreacion
			,usuarioCreacion.usua_Nombre AS usuarioCreacionNombre
			,ordenCompraDetalle.code_FechaCreacion
			,ordenCompraDetalle.usua_UsuarioModificacion
			,usuarioModificacion.usua_Nombre AS usuarioModificacionNombre
			,ordenCompraDetalle.code_FechaModificacion
			,ordenCompraDetalle.code_Estado
			,code_FechaProcActual
	  FROM	Prod.tbOrdenCompraDetalles			    ordenCompraDetalle
			INNER JOIN	Prod.tbEstilos				estilo						ON	ordenCompraDetalle.esti_Id						= estilo.esti_Id
			INNER JOIN	Prod.tbTallas				talla						ON	ordenCompraDetalle.tall_Id						= talla.tall_Id
			INNER JOIN  Prod.tbColores				colores						ON	ordenCompraDetalle.colr_Id						= colores.colr_Id
			INNER JOIN  Prod.tbProcesos				procesoComienza				ON	ordenCompraDetalle.proc_IdComienza				= procesoComienza.proc_Id
			INNER JOIN  Prod.tbProcesos				procesoActual				ON	ordenCompraDetalle.proc_IdActual				= procesoActual.proc_Id
			INNER JOIN  Acce.tbUsuarios				usuarioCreacion				ON  ordenCompraDetalle.usua_UsuarioCreacion			= usuarioCreacion.usua_Id
			LEFT  JOIN  Acce.tbUsuarios				usuarioModificacion			ON  ordenCompraDetalle.usua_UsuarioModificacion		= usuarioModificacion.usua_Id
			WHERE ordenCompraDetalle.orco_Id	=	@orco_Id OR @orco_Id = -1
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalle_ObtenerPorIdOrdenCompra_ParaLineaTiempo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-----------------------------------------------/UDPS Para orden de compra---------------------------------------------

--------------------------------------------UDPS Para orden de compra detalle-----------------------------------------

CREATE   PROCEDURE [Prod].[UDP_tbOrdenCompraDetalle_ObtenerPorIdOrdenCompra_ParaLineaTiempo]
(
	@orco_Id			INT
)
AS
BEGIN
	 SELECT * FROM Prod.VW_tbOrdenCompraDetalle_LineaTiempo ordenCompraDetalle
	 WHERE ordenCompraDetalle.orco_Id = @orco_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalles_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompraDetalles_Editar]
(
	@code_Id						INT,
	@orco_Id						INT,
	@code_CantidadPrenda			INT,
	@esti_Id						INT,
	@tall_Id						INT,
	@code_Sexo						CHAR(1),
	@colr_Id						INT,

	@proc_IdComienza				INT,
	@proc_IdActual					INT,
	@code_Unidad					DECIMAL(18,2),
	@code_Valor						DECIMAL(18,2),
	@code_Impuesto					DECIMAL(18,2),

	@code_EspecificacionEmbalaje	NVARCHAR(200),
	@usua_UsuarioModificacion     	INT,
	@code_FechaModificacion      	DATETIME
)
AS
BEGIN
	BEGIN TRY
		 UPDATE Prod.tbOrdenCompraDetalles
			SET orco_Id						= @orco_Id,						
				code_CantidadPrenda			= @code_CantidadPrenda,			
				esti_Id						= @esti_Id,						
				tall_Id						= @tall_Id,						
				code_Sexo					= @code_Sexo,						
				colr_Id						= @colr_Id,						
					
				proc_IdComienza				= @proc_IdComienza,				
				proc_IdActual				= @proc_IdActual,					
				code_Unidad					= @code_Unidad,					
				code_Valor					= @code_Valor,						
				code_Impuesto				= @code_Impuesto,					
						
				code_EspecificacionEmbalaje	= @code_EspecificacionEmbalaje,	
				usua_UsuarioModificacion    = @usua_UsuarioModificacion,       	
				code_FechaModificacion      = @code_FechaModificacion    
		  WHERE code_Id = @code_Id

		  SELECT 1 
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalles_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompraDetalles_Eliminar]
	@code_Id	INT
AS
BEGIN
BEGIN TRANSACTION
	BEGIN TRY   
		
		DELETE FROM  Prod.tbDocumentosOrdenCompraDetalles WHERE code_Id = @code_Id
	
	    DELETE FROM  Prod.tbProcesoPorOrdenCompraDetalle WHERE code_Id = @code_Id
	
		DELETE FROM Prod.tbMaterialesBrindar WHERE code_Id = @code_Id

		DELETE FROM Prod.tbOrdenCompraDetalles WHERE code_Id = @code_Id

		SELECT 1
		COMMIT TRAN
	END TRY
	BEGIN CATCH 
	ROLLBACK TRAN
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalles_FiltrarProceso]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbOrdenCompraDetalles_FiltrarProceso] 
	@code_Id		INT
AS
BEGIN
	SELECT	[poco_Id], [code_Id], ppcd.[proc_Id],[proc_Descripcion]
	FROM	[Prod].[tbProcesoPorOrdenCompraDetalle] ppcd
			INNER JOIN [Prod].[tbProcesos] prc on ppcd.proc_Id = prc.proc_Id
	WHERE	ppcd.code_Id = @code_Id 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalles_Find]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbOrdenCompraDetalles_Find]
	@code_Id		NVARCHAR(MAX)
AS
BEGIN
	SELECT	 ordenCompraDetalle.code_Id
			,ordenCompraDetalle.orco_Id
			,ordenCompraDetalle.esti_Id
			,ordenCompraDetalle.proc_IdComienza AS proc_Id
			,orco.orco_Codigo
			,estilo.esti_Descripcion
			,ordenCompraDetalle.tall_Id
			,orco.orco_FechaEmision
			,orco.orco_FechaLimite
			,(SELECT COUNT(orco_Id)
			 FROM Prod.tbOrdenCompraDetalles
			 WHERE orco_Id = orco.orco_Id) AS cantidad_Items
			,CONCAT(talla.tall_Codigo, ' (', talla.tall_Nombre, ')') AS tall_Nombre
			,ordenCompraDetalle.colr_Id
			,colores.colr_Nombre
			,clie.clie_Nombre_O_Razon_Social
	  FROM	Prod.tbOrdenCompraDetalles			    ordenCompraDetalle
			INNER JOIN	Prod.tbEstilos				estilo						ON	ordenCompraDetalle.esti_Id						= estilo.esti_Id
			INNER JOIN	Prod.tbTallas				talla						ON	ordenCompraDetalle.tall_Id						= talla.tall_Id
			INNER JOIN  Prod.tbColores				colores						ON	ordenCompraDetalle.colr_Id						= colores.colr_Id
			INNER JOIN Prod.tbOrdenCompra			orco						ON ordenCompraDetalle.orco_Id						= orco.orco_Id
			INNER JOIN Prod.tbClientes				clie						ON orco.orco_IdCliente = clie.clie_Id						
	  WHERE CONCAT(orco.orco_Codigo, ' - ', ordenCompraDetalle.code_Id )	=	@code_Id 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbOrdenCompraDetalles_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     PROCEDURE [Prod].[UDP_tbOrdenCompraDetalles_Insertar]
(
	@orco_Id						INT,
	@code_CantidadPrenda			INT,
	@esti_Id						INT,
	@tall_Id						INT,
	@code_Sexo						CHAR(1),
	@colr_Id						INT,
	@proc_IdComienza				INT,
	@proc_IdActual					INT,
	@code_Unidad					DECIMAL(18,2),
	@code_Valor						DECIMAL(18,2),
	@code_Impuesto					DECIMAL(18,2),
	@code_EspecificacionEmbalaje	NVARCHAR(200),
	@usua_UsuarioCreacion       	INT,
	@code_FechaProcActual			DATETIME,
	@code_FechaCreacion         	DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbOrdenCompraDetalles
					(orco_Id,						
					code_CantidadPrenda,			
					esti_Id,						
					tall_Id,						
					code_Sexo,						
					colr_Id,						
							
					proc_IdComienza,				
					proc_IdActual,					
					code_Unidad,					
					code_Valor,						
					code_Impuesto,					
							
					code_EspecificacionEmbalaje,	
					usua_UsuarioCreacion,
					code_FechaProcActual,
					code_FechaCreacion)
			 VALUES (@orco_Id,						
					@code_CantidadPrenda,			
					@esti_Id,						
					@tall_Id,						
					@code_Sexo,						
					@colr_Id,						
								
							
					@proc_IdComienza,				
					@proc_IdActual,					
					@code_Unidad,					
					@code_Valor,						
					@code_Impuesto,					
								
					@code_EspecificacionEmbalaje,	
					@usua_UsuarioCreacion,
					@code_FechaProcActual,
					@code_FechaCreacion)
		
		SELECT SCOPE_IDENTITY() AS Resultado
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrden_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrden_Editar]
@peor_Codigo				NVARCHAR(100),
@peor_Id					INT, 
@prov_Id					INT, 
@duca_Id					INT, 
@ciud_Id					INT,
@peor_DireccionExacta		NVARCHAR(500),
@peor_FechaEntrada			DATETIME, 
@peor_Obsevaciones			NVARCHAR(100), 
@peor_Impuestos				DECIMAL(8,2),
@usua_UsuarioModificacion	INT, 
@peor_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY

		DECLARE @impuesto DECIMAL(8,2)
		IF(@peor_Impuestos = 1)
		BEGIN
		 SET @impuesto = (SELECT TOP 1 impr_Valor FROM Prod.tbImpuestosProd)
		END
		ELSE 
		BEGIN
		 SET @impuesto = 0
		END


		UPDATE Prod.tbPedidosOrden 
		SET 
		peor_Codigo				= @peor_Codigo,
		prov_Id 					= @prov_Id, 
		duca_Id						= @duca_Id,
		ciud_Id						= @ciud_Id,
		peor_DireccionExacta		= @peor_DireccionExacta,
		peor_FechaEntrada			= @peor_FechaEntrada,	 
		peor_Obsevaciones			= @peor_Obsevaciones,  
		peor_Impuestos				= @impuesto,
		usua_UsuarioModificacion	= @usua_UsuarioModificacion,
		peor_FechaModificacion		= @peor_FechaModificacion	
		WHERE peor_Id				= @peor_Id

		SELECT 1 

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrden_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrden_Finalizado]
	@peor_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Prod].[tbPedidosOrden]
		SET	   [peor_finalizacion] = 1
		WHERE  peor_Id = @peor_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrden_FindCodigo]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrden_FindCodigo] --'SAGAS245'
  @peor_Codigo   NVARCHAR(100)
AS
BEGIN 
SELECT	    peor.prod_Id,
			po.peor_Id,
			po.peor_Codigo,
			prov.prov_Id, 
		    prov.prov_NombreCompania,
		    prov.prov_NombreContacto,
			peor.prod_Cantidad,
			peor.mate_Id,
			mate_Descripcion,
			peor.prod_Precio	  
	FROM	[Prod].[tbPedidosOrdenDetalle]	peor
	        INNER JOIN Prod.tbPedidosOrden po       ON peor.peDI_Id = po.peor_Id
		    LEFT  JOIN Gral.tbProveedores prov	    ON po.prov_Id   = prov.prov_Id
			LEFT  JOIN Prod.tbMateriales tbmats		ON peor.mate_Id = tbmats.mate_Id
   WHERE peor_Codigo = @peor_Codigo
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrden_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrden_Insertar] 
@peor_Codigo			NVARCHAR(100),
@prov_Id				INT, 
@duca_Id				INT, 
@ciud_Id				INT,	
@peor_DireccionExacta	NVARCHAR(500),
@peor_FechaEntrada		DATETIME, 
@peor_Obsevaciones		NVARCHAR(100), 
@peor_Impuestos			DECIMAL(8,2),
@usua_UsuarioCreacion	INT, 
@peor_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY

	DECLARE @impuesto DECIMAL(8,2)
		IF(@peor_Impuestos = 1)
		BEGIN
		 SET @impuesto = (SELECT TOP 1 impr_Valor FROM Prod.tbImpuestosProd)
		END
		ELSE 
		BEGIN
		 SET @impuesto = 0
		END



	DECLARE  @duca INT;
		IF(@duca_Id = 0 )
		BEGIN
			SET @duca = NULL;
		END
		ELSE
		BEGIN
		 	SET @duca = @duca_Id;
		END

		INSERT INTO Prod.tbPedidosOrden (peor_Codigo, prov_Id, duca_Id,ciud_Id,peor_DireccionExacta, peor_FechaEntrada, peor_Obsevaciones, peor_Impuestos, usua_UsuarioCreacion, peor_FechaCreacion)
		VALUES	(@peor_Codigo,
				 @prov_Id,				
				 @duca,	
				 @ciud_Id,	
				 @peor_DireccionExacta,
				 @peor_FechaEntrada,		
				 @peor_Obsevaciones,	
				 @impuesto,
				 @usua_UsuarioCreacion,	
				 @peor_FechaCreacion	
				 )	
		SELECT SCOPE_IDENTITY() AS Resultado
	END TRY


	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrden_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrden_Listar] 
AS
BEGIN
SELECT	peor_Id, 
		COALESCE(prov.prov_NombreCompania, 'No disponible') AS prov_NombreCompania,
		COALESCE(prov.prov_NombreContacto, 'No disponible') AS prov_NombreContacto,
		COALESCE(prov.prov_Telefono, 'No disponible') AS prov_Telefono,
		prov.prov_Id,
		po.peor_finalizacion,
		peor_Codigo,
		peor_Impuestos,
		po.duca_Id, 
		ciud.ciud_Id,
		COALESCE(ciud.ciud_Nombre, 'No disponible') AS ciud_Nombre,
		COALESCE(duca.duca_No_Duca, 'No disponible') AS duca_No_Duca,
		pais.pais_Codigo,
		pais.pais_Id,
		pais.pais_Nombre,
		pvin.pvin_Codigo,
		pvin.pvin_Id,
		pvin.pvin_Nombre,
		po.peor_DireccionExacta,
		SUBSTRING(CAST(po.peor_FechaEntrada AS NVARCHAR(100)), 1, 12) AS peor_FechaEntrada,
		COALESCE(po.peor_Obsevaciones, 'No disponible') AS peor_Obsevaciones, 
		CONCAT(empl_Nombres, ' ', empl_Apellidos) AS empl_Creador,
		peor_DadoCliente, 
		CASE peor_DadoCliente
		WHEN 1 THEN 'Sí'
		ELSE 'NO' END AS DadoCliente,
		peor_Est, 
		po.usua_UsuarioCreacion,
		crea.usua_Nombre							AS UsuarioCreacionNombre, 
		peor_FechaCreacion, 
		po.usua_UsuarioModificacion,
		modi.usua_Nombre							AS UsuarioModificacionNombre, 
		peor_FechaModificacion, 
		peor_Estado,
		   (SELECT prod_Id,
				   pedi_Id,
				   pod.mate_Id,
				   COALESCE(mates.mate_Descripcion, 'No disponible') AS mate_Descripcion,
				   (pod.prod_Cantidad * pod.prod_Precio) AS Total,
				   prod_Cantidad,
				   prod_Precio
   FROM Prod.tbPedidosOrdenDetalle pod
   INNER JOIN Prod.tbMateriales mates
   ON pod.mate_Id = mates.mate_Id
   WHERE po.peor_Id = pod.pedi_Id


   FOR JSON PATH) 
   AS Detalles
FROM	Prod.tbPedidosOrden po
		INNER JOIN Gral.tbProveedores prov			    ON po.prov_Id   = prov.prov_Id
		LEFT JOIN  gral.tbCiudades	  ciud			    ON po.ciud_Id = ciud.ciud_Id
		LEFT JOIN Gral.tbProvincias   pvin				ON pvin.pvin_Id = ciud.pvin_Id
		LEFT JOIN Gral.tbPaises	      pais				ON pvin.pais_Id = pais.pais_Id
		LEFT JOIN  Adua.tbDuca        duca			    ON po.duca_Id = duca.duca_Id
		LEFT JOIN  Acce.tbUsuarios    crea				ON crea.usua_Id = po.usua_UsuarioCreacion 
		LEFT JOIN  Acce.tbUsuarios    modi				ON modi.usua_Id = po.usua_UsuarioModificacion 	
		INNER JOIN Gral.tbEmpleados Emples				ON crea.empl_Id = Emples.empl_Id
		   ORDER BY peor_FechaEntrada DESC 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrdenDetalle_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EDITAR
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrdenDetalle_Editar]
(
     @prod_Id                    INT,
     @pedi_Id                    INT,
	 @mate_Id                    INT,
	 @prod_Cantidad              INT,
	 @prod_Precio                DECIMAL(18,2),
	 @usua_UsuarioModificacion   INT,
	 @prod_FechaModificacion     DATETIME
)
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbPedidosOrdenDetalle
		   SET pedi_Id = @pedi_Id,
		       mate_Id = @mate_Id,
               prod_Cantidad = @prod_Cantidad,
               prod_Precio = @prod_Precio,
               usua_UsuarioModificacion = @usua_UsuarioModificacion,
               prod_FechaModificacion = @prod_FechaModificacion
		 WHERE prod_Id = @prod_Id
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrdenDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrdenDetalle_Eliminar]
	@prod_Id                    INT	
AS
BEGIN
	BEGIN TRY 
		UPDATE Prod.tbPedidosOrdenDetalle
		   SET prod_Estado = 0
		 WHERE prod_Id = @prod_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrdenDetalle_Find]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Find de pedidos Orden detalles*/
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrdenDetalle_Find]
	@prod_Id INT
AS 
BEGIN
	SELECT	peor.prod_Id,
			peor.pedi_Id,
			peor.prod_Cantidad,
			peor.mate_Id,
			mate_Descripcion,
			peor.prod_Precio	  
	FROM	[Prod].[tbPedidosOrdenDetalle]	peor
			INNER JOIN Prod.tbMateriales tbmats		ON peor.mate_Id = tbmats.mate_Id
	WHERE	peor.prod_Id = @prod_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrdenDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--INSERTAR
CREATE   PROCEDURE [Prod].[UDP_tbPedidosOrdenDetalle_Insertar]
(
     @pedi_Id                    INT,
	 @mate_Id                    INT,
	 @prod_Cantidad              INT,
	 @prod_Precio                DECIMAL(18,2),
	 @usua_UsuarioCreacion       INT,
	 @prod_FechaCreacion         DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbPedidosOrdenDetalle
					(
					  pedi_Id,
                      mate_Id,
                      prod_Cantidad,
                      prod_Precio,
                      usua_UsuarioCreacion,
                      prod_FechaCreacion
					)
			 VALUES (
			           @pedi_Id,
					   @mate_Id,
					   @prod_Cantidad,
					   @prod_Precio,
					   @usua_UsuarioCreacion,
					   @prod_FechaCreacion
			        )
		
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosOrdenDetalle_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----------------------------UDPS Pedidos Orden Detalle-----------------------------
--LISTAR
CREATE PROCEDURE [Prod].[UDP_tbPedidosOrdenDetalle_Listar] 
(
@pedi_Id INT
)
AS
BEGIN
SELECT
    prod.prod_Id,
    prod.pedi_Id,
    prod.mate_Id,
    mate.mate_Descripcion,
    prod.prod_Cantidad,
    prod.prod_Precio,
    usu.usua_Id,
    usu.usua_Nombre AS UsuarioCreacionNombre,
    prod_FechaCreacion,
    usu1.usua_Id,
    usu1.usua_Nombre AS UsuarioModificacionNombre,
    prod_FechaModificacion,
    (
        SELECT
            podetas.ocpo_Id,
            podetas.prod_Id,
			clie.clie_Nombre_O_Razon_Social,
			orcomde.code_CantidadPrenda,
			CASE code_Sexo
			WHEN 'F' THEN 'Femenino'
			WHEN NULL THEN 'N/A'
			ELSE 'Masculino' END AS code_SexoEvaluado,
			orcomde.code_Sexo,
			CASE esti_Descripcion 
			WHEN NULL THEN 'PO completa asignada'
			ELSE esti_Descripcion END AS esti_DescripcionEvaludado,
			esti.esti_Descripcion,
			CASE colr_Nombre 
			WHEN NULL THEN 'PO completa asignada'
			ELSE colr_Nombre END AS colr_NombreEvaludado,
			colr.colr_Nombre,
			CASE tall_Nombre 
			WHEN NULL THEN 'PO completa asignada'
			ELSE tall_Nombre END AS tall_NombreEvaludado,
			talla.tall_Nombre,
			CASE podetas.code_Id 
			WHEN NULL THEN 'PO completa asignada'
			ELSE  podetas.code_Id  END AS code_IdEvaludado,
            podetas.code_Id,
            orcom.orco_Codigo AS orco_Id
        FROM [Prod].[tbPODetallePorPedidoOrdenDetalle] podetas
        LEFT JOIN [Prod].[tbOrdenCompra] orcom
            ON orcom.orco_Id = podetas.orco_Id
        INNER JOIN [Prod].[tbOrdenCompraDetalles] orcomde
            ON orcomde.code_Id = podetas.code_Id
		LEFT JOIN Prod.tbEstilos esti					
			ON orcomde.esti_Id = esti.esti_Id
		LEFT JOIN Prod.tbTallas talla					
			ON orcomde.tall_Id = talla.tall_Id
		LEFT JOIN Prod.tbColores colr					
			ON orcomde.colr_Id = colr.colr_Id
        INNER JOIN [Prod].[tbPedidosOrdenDetalle] pedisorde
            ON pedisorde.prod_Id = podetas.prod_Id
		LEFT JOIN Prod.tbClientes clie					
			ON orcom.orco_IdCliente = clie.clie_Id
        INNER JOIN [Prod].[tbPedidosOrden] pedisor
            ON pedisor.peor_Id = pedisorde.pedi_Id
        WHERE podetas.prod_Id = prod.prod_Id
        FOR JSON PATH
    ) AS detalles
FROM Prod.tbPedidosOrdenDetalle prod
INNER JOIN Prod.tbPedidosOrden pedi ON prod.pedi_Id = pedi.peor_Id
INNER JOIN Acce.tbUsuarios usu ON usu.usua_Id = prod.usua_UsuarioCreacion
LEFT JOIN Acce.tbUsuarios usu1 ON usu1.usua_UsuarioModificacion = prod.usua_UsuarioModificacion
INNER JOIN Prod.tbMateriales mate ON prod.mate_Id = mate.mate_Id
WHERE prod.prod_Estado = 1 AND prod.pedi_Id = @pedi_Id

END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbPedidosProduccion_Editar]
@ppro_Id INT,
@empl_Id INT,
@ppro_Fecha DATETIME,
@ppro_Estados NVARCHAR(150),
@ppro_Observaciones NVARCHAR(MAX),
@usua_UsuarioModificacion INT,
@ppro_FechaModificacion DATETIME
AS 
BEGIN
	BEGIN TRY

		UPDATE Prod.tbPedidosProduccion SET empl_Id = @empl_Id,
									ppro_Fecha = @ppro_Fecha,
									ppro_Estados = @ppro_Estados,
									ppro_Observaciones = @ppro_Observaciones,
									usua_UsuarioModificacion = @usua_UsuarioModificacion,
									ppro_FechaModificacion = @ppro_FechaModificacion
								WHERE ppro_Id = @ppro_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- CORRECIONES PEDIDOS PRODUCCION ---

/*
en el procedimiento [Prod].[UDP_tbPedidosProduccionDetalle_Filtrar_Estado] quitar el "select 1"
*/



----- UDP ELIMINAR PEDISOS PRODUCCION ----
CREATE    PROC [Prod].[UDP_tbPedidosProduccion_Eliminar]
	@ppro_Id		INT
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
			IF EXISTS (SELECT ppro_Id FROM Prod.tbOrde_Ensa_Acab_Etiq WHERE ppro_Id = @ppro_Id)
				BEGIN 
					SELECT 2
				END
			ELSE
				BEGIN
					DELETE FROM [Prod].[tbPedidosProduccionDetalles]
					WHERE ppro_Id = @ppro_Id

					DELETE FROM [Prod].[tbPedidosProduccion]
					WHERE ppro_Id = @ppro_Id

					SELECT 1
				END		
	END TRY	
	BEGIN CATCH
		SELECT 0
	END CATCH
END



----- UDP LISTAR PEDIDOS PRODUCCION DETALLE ----

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPedidosProduccion_Finalizado]
	@ppro_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Prod].[tbPedidosProduccion]
		SET	   [ppro_Finalizado] = 1
		WHERE  ppro_Id = @ppro_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Find]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbPedidosProduccion_Find] 
@ppro_Id INT
AS
BEGIN
IF NOT EXISTS (SELECT * FROM Prod.tbPedidosProduccion WHERE ppro_Finalizado = 1 AND ppro_Id = @ppro_Id )
	BEGIN
	SELECT ppro_Id,
		   pediproduccion.empl_Id,
		   CONCAT(empl_Nombres, ' ', empl_Apellidos)					AS empl_NombreCompleto,
		   ppro_Fecha,
		   ppro_Estados, 
		   ppro_Observaciones, 
		   Creacion.usua_Nombre											AS UsuarioCreacionNombre,
		   pediproduccion.usua_UsuarioCreacion,
		   ppro_FechaCreacion,
		   Modificacion.usua_Nombre										AS UsuarioModificacionNombre,
		   pediproduccion.usua_UsuarioModificacion, 
		   ppro_FechaModificacion,
		   ppro_Finalizado,
		   ppro_Estado,
	   	      (SELECT ppro_Id,
					ppde_Id,
		   		   tbdetalles.lote_Id,
		   		   ppde_Cantidad,
		   		   mate_Descripcion,
				   tblotes.lote_Stock,
				   tbarea.tipa_area,
				   tblotes.lote_CodigoLote
		   	  FROM Prod.tbPedidosProduccionDetalles tbdetalles
					INNER JOIN Prod.tbLotes tblotes			ON tbdetalles.lote_Id = tblotes.lote_Id
					INNER JOIN Prod.tbMateriales tbmats		ON tblotes.mate_Id = tbmats.mate_Id
					INNER JOIN Prod.tbArea	tbarea			ON tblotes.tipa_Id = tbarea.tipa_Id
			  WHERE pediproduccion.ppro_Id = tbdetalles.ppro_Id
				  FOR JSON PATH)										AS Detalles,
				  'Esta bien'  AS mensaje
	  FROM Prod.tbPedidosProduccion pediproduccion
INNER JOIN Gral.tbEmpleados emples
		ON pediproduccion.empl_Id = emples.empl_Id
INNER JOIN Acce.tbUsuarios Creacion
		ON pediproduccion.usua_UsuarioCreacion = Creacion.usua_Id
 LEFT JOIN Acce.tbUsuarios Modificacion
		ON pediproduccion.usua_UsuarioModificacion = Modificacion.usua_Id

		WHERE [ppro_Estado] = 1
		AND ppro_Id = @ppro_Id
	END
		ELSE
	BEGIN
		SELECT 'Este pedido ya esta finalizado'  AS mensaje
	END
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbPedidosProduccion_Insertar]
	@empl_Id					INT,
	@ppro_Fecha					DATETIME,
	@ppro_Estados				NVARCHAR(150),
	@ppr_Observaciones			NVARCHAR(MAX),
	@lote_Id					INT,
	@ppde_Cantidad				INT,
	@usua_UsuarioCreacion		INT,	
	@ppro_FechaCreacion			DATETIME
AS 
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbPedidosProduccion(empl_Id, 
									     ppro_Fecha,
										 ppro_Estados,
										 ppro_Observaciones, 
										 usua_UsuarioCreacion,
										 ppro_FechaCreacion
										 )
		VALUES(@empl_Id, @ppro_Fecha, @ppro_Estados, @ppr_Observaciones, @usua_UsuarioCreacion, @ppro_FechaCreacion)

		DECLARE @ppro_Id INT = SCOPE_IDENTITY();

		

		SELECT @ppro_Id
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccion_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--**************************************************************************************************--


--***************************************PEDIDOS PRODUCCION*****************************************--
CREATE   PROC [Prod].[UDP_tbPedidosProduccion_Listar]
AS BEGIN
	SELECT ppro_Id,
		   pediproduccion.empl_Id,
		   CONCAT(empl_Nombres, ' ', empl_Apellidos)					AS empl_NombreCompleto,
		   ppro_Fecha,
		   ppro_Estados, 
		   ppro_Observaciones, 
		   Creacion.usua_Nombre											AS UsuarioCreacionNombre,
		   pediproduccion.usua_UsuarioCreacion,
		   ppro_FechaCreacion,
		   Modificacion.usua_Nombre										AS UsuarioModificacionNombre,
		   pediproduccion.usua_UsuarioModificacion, 
		   ppro_FechaModificacion,
		   ppro_Finalizado,
		   ppro_Estado,
	   	      (SELECT ppro_Id,
					ppde_Id,
		   		   tbdetalles.lote_Id,
		   		   ppde_Cantidad,
		   		   mate_Descripcion,
				   tblotes.lote_Stock,
				   tbarea.tipa_area,
				   tblotes.lote_CodigoLote
		   	  FROM Prod.tbPedidosProduccionDetalles tbdetalles
					INNER JOIN Prod.tbLotes tblotes			ON tbdetalles.lote_Id = tblotes.lote_Id
					INNER JOIN Prod.tbMateriales tbmats		ON tblotes.mate_Id = tbmats.mate_Id
					INNER JOIN Prod.tbArea	tbarea			ON tblotes.tipa_Id = tbarea.tipa_Id
			  WHERE pediproduccion.ppro_Id = tbdetalles.ppro_Id
				  FOR JSON PATH)										AS Detalles
	  FROM Prod.tbPedidosProduccion pediproduccion
INNER JOIN Gral.tbEmpleados emples
		ON pediproduccion.empl_Id = emples.empl_Id
INNER JOIN Acce.tbUsuarios Creacion
		ON pediproduccion.usua_UsuarioCreacion = Creacion.usua_Id
 LEFT JOIN Acce.tbUsuarios Modificacion
		ON pediproduccion.usua_UsuarioModificacion = Modificacion.usua_Id

		WHERE [ppro_Estado] = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccionDetalle_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROC [Prod].[UDP_tbPedidosProduccionDetalle_Editar] --158, 1,1, 8,1,'10-16-2004'
(@ppde_Id                    INT,
 @ppro_Id                    INT,
 @lote_Id                    INT,
 @ppde_Cantidad                INT,
 @usua_UsuarioModificacion    INT,
 @ppde_FechaModificacion DATETIME)
AS
BEGIN
    BEGIN TRY

		DECLARE @CantidadAnterior INT = (SELECT ppde_Cantidad FROM Prod.tbPedidosProduccionDetalles WHERE ppde_Id = @ppde_Id)	

		IF (@lote_Id = (SELECT lote_Id FROM Prod.tbPedidosProduccionDetalles WHERE ppde_Id = @ppde_Id))
			BEGIN 
				
				IF (@ppde_Cantidad > (SELECT ppde_Cantidad FROM Prod.tbPedidosProduccionDetalles WHERE ppde_Id = @ppde_Id))
					BEGIN

						UPDATE Prod.tbLotes
						SET
							lote_Stock = lote_Stock - (@ppde_Cantidad - @CantidadAnterior)
						WHERE lote_Id = @lote_Id
					END
				ELSE
					BEGIN
						UPDATE Prod.tbLotes
						SET
							lote_Stock = lote_Stock + (@CantidadAnterior - @ppde_Cantidad)
						WHERE lote_Id = @lote_Id
					END

				UPDATE [Prod].[tbPedidosProduccionDetalles]
				SET [ppro_Id] = @ppro_Id, 
					[lote_Id] = @lote_Id, 
					[ppde_Cantidad] = @ppde_Cantidad, 
					[usua_UsuarioModificacion] = @usua_UsuarioModificacion, 
					[ppde_FechaModificacion] = @ppde_FechaModificacion
				WHERE ppde_Id = @ppde_Id
				
				SELECT 1
			END
		ELSE
			BEGIN
				
				DECLARE @LoteAnterior INT = (SELECT lote_Id FROM Prod.tbPedidosProduccionDetalles WHERE ppde_Id = @ppde_Id)
				

				-- NUEVO STOCK DEL ANTIGUO LOTE
				UPDATE Prod.tbLotes
				SET lote_Stock = lote_Stock + @CantidadAnterior
				WHERE lote_Id = @LoteAnterior


				-- NUEVO STOCK DE NUEVO LOTE
				UPDATE Prod.tbLotes
				SET lote_Stock = lote_Stock - @ppde_Cantidad
				WHERE lote_Id = @lote_Id


				UPDATE [Prod].[tbPedidosProduccionDetalles]
				SET [ppro_Id] = @ppro_Id, 
					[lote_Id] = @lote_Id, 
					[ppde_Cantidad] = @ppde_Cantidad , 
					[usua_UsuarioModificacion] = @usua_UsuarioModificacion, 
					[ppde_FechaModificacion] = @ppde_FechaModificacion
				WHERE ppde_Id = @ppde_Id

				SELECT 1
			END


    END TRY
    BEGIN CATCH
            SELECT 'Error Message: ' + ERROR_MESSAGE()
    END CATCH
END


GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccionDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbPedidosProduccionDetalle_Eliminar]
(@ppde_Id					INT)
AS
BEGIN
	BEGIN TRY

		DELETE FROM [Prod].[tbPedidosProduccionDetalles]
		WHERE ppde_Id = @ppde_Id

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccionDetalle_Filtrar_Estado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [Prod].[UDP_tbPedidosProduccionDetalle_Filtrar_Estado]
(
@ppro_Id INT
)
AS
BEGIN
	BEGIN TRY
		SELECT	PPD.ppde_Id, 
		PPD.ppro_Id, 
		PPD.ppde_Cantidad,
		pp.[ppro_Estados],
		PPD.lote_Id, 
		lot.[lote_Stock],
		lot.lote_CodigoLote,
		col.colr_Codigo,
		col.colr_Nombre,
		are.tipa_Id,
		are.tipa_area,
		mat.mate_Id,
		mat.mate_Descripcion

		FROM Prod.tbPedidosProduccionDetalles PPD
			INNER JOIN Prod.tbPedidosProduccion pp	ON ppd.ppro_Id = pp.ppro_Id
			LEFT JOIN Prod.tbLotes lot				ON PPD.lote_Id = lot.lote_Id
			LEFT JOIN Prod.tbMateriales mat			ON lot.mate_Id = mat.mate_Id
			LEFT JOIN Prod.tbColores col			ON lot.colr_Id = col.colr_Id
			LEFT JOIN Prod.tbArea are				ON are.tipa_Id = lot.tipa_Id
			WHERE ppd.ppro_Id = @ppro_Id

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPedidosProduccionDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [Prod].[UDP_tbPedidosProduccionDetalle_Insertar] 
(@ppro_Id INT,
 @lote_Id INT,
 @ppde_Cantidad INT,
 @usua_UsuarioCreacion INT,
 @ppde_FechaCreacion DATETIME)
AS
BEGIN
	BEGIN TRY
		INSERT INTO [Prod].[tbPedidosProduccionDetalles] ([ppro_Id], [lote_Id], [ppde_Cantidad], [usua_UsuarioCreacion], [ppde_FechaCreacion])
		VALUES (@ppro_Id,@lote_Id,@ppde_Cantidad,@usua_UsuarioCreacion,@ppde_FechaCreacion);

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END



GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Editar] 
	@ocpo_Id						INT,
	@prod_Id						INT,
	@code_Id						INT,
	@orco_Id						INT,
	@usua_UsuarioModificacion		INT,
	@ocpo_FechaModificacion			DATETIME 
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbPODetallePorPedidoOrdenDetalle
		SET code_Id = @code_Id,
			orco_Id = @orco_Id
		WHERE ocpo_Id = @ocpo_Id

		SELECT 1

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Eliminar] 
	@ocpo_Id						INT
AS
BEGIN
	BEGIN TRY
		DELETE FROM Prod.tbPODetallePorPedidoOrdenDetalle
		WHERE ocpo_Id = @ocpo_Id

		SELECT 1

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Insertar] 
    @prod_Id INT,
    @code_Id INT,
    @orco_Id INT,
    @usua_UsuarioCreacion INT,
    @ocpo_FechaCreacion DATETIME 
AS
BEGIN
    BEGIN TRY
        IF (@code_Id IS NULL OR @code_Id = 0)
        BEGIN
            INSERT INTO Prod.tbPODetallePorPedidoOrdenDetalle (prod_Id, code_Id, orco_Id, usua_UsuarioCreacion, ocpo_FechaCreacion)
            SELECT DISTINCT @prod_Id, orcomde.code_Id, orcomde.orco_Id, @usua_UsuarioCreacion, @ocpo_FechaCreacion
            FROM  [Prod].[tbOrdenCompraDetalles] orcomde
            INNER JOIN [Prod].[tbOrdenCompra] orcom
            ON orcom.orco_Id = orcomde.orco_Id
            WHERE orcomde.orco_Id = @orco_Id
        END
        ELSE
        BEGIN
            INSERT INTO Prod.tbPODetallePorPedidoOrdenDetalle (prod_Id, code_Id, orco_Id, usua_UsuarioCreacion, ocpo_FechaCreacion)
            VALUES (@prod_Id, @code_Id, @orco_Id, @usua_UsuarioCreacion, @ocpo_FechaCreacion)
        END

        SELECT 1
    END TRY
    BEGIN CATCH
        SELECT 'Error Message: ' + ERROR_MESSAGE()
    END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----------------------------UDPS tbPODetallePorPedidoOrdenDetalle-----------------------------
--LISTAR
CREATE   PROCEDURE [Prod].[UDP_tbPODetallePorPedidoOrdenDetalle_Listar]
@prod_Id INT
AS
BEGIN
  SELECT    ocpo.ocpo_Id,
			code.code_Id,
			ocpo.orco_Id,
			clie.clie_Id,
			clie.clie_Nombre_O_Razon_Social,
			ocpo.prod_Id,
			code.esti_Id,
			code.code_CantidadPrenda,
			code.code_Sexo,
			code.tall_Id,
			talla.tall_Nombre,
			code.colr_Id,
			colr.colr_Nombre,
			esti.esti_Descripcion,
		   		
			ocpo.usua_UsuarioCreacion,
			usu.usua_Nombre						  AS usua_UsuarioCreacionNombre,
			ocpo_FechaCreacion
 
  FROM	    Prod.tbPODetallePorPedidoOrdenDetalle ocpo
			LEFT JOIN  Prod.tbOrdenCompra orco				ON ocpo.orco_Id = orco.orco_Id
			LEFT JOIN Prod.tbClientes clie					ON orco.orco_IdCliente = clie.clie_Id
            LEFT JOIN  Prod.tbOrdenCompraDetalles code		ON ocpo.code_Id = code.code_Id
			LEFT JOIN Prod.tbEstilos esti					ON code.esti_Id = esti.esti_Id
			LEFT JOIN Prod.tbTallas talla					ON code.tall_Id = talla.tall_Id
			LEFT JOIN Prod.tbColores colr					ON code.colr_Id = colr.colr_Id
			LEFT JOIN Acce.tbUsuarios usu					ON usu.usua_Id = ocpo.usua_UsuarioCreacion 
			WHERe prod_Id =@prod_Id
END 
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Eliminar]
(
@code_Id INT
)
AS
BEGIN
	BEGIN TRY
		DELETE 
		FROM	Prod.tbProcesoPorOrdenCompraDetalle
		WHERE	code_Id = @code_Id

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE       PROCEDURE [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Insertar]
(
@code_Id				INT,
@proc_Id				INT,
@usua_UsuarioCreacion	INT,
@poco_FechaCreacion		DATETIME
)
AS
BEGIN
	BEGIN TRY
		INSERT INTO	Prod.tbProcesoPorOrdenCompraDetalle
					(code_Id,
					proc_Id,
					usua_UsuarioCreacion,
					poco_FechaCreacion)
		VALUES		(@code_Id,
					@proc_Id,
					@usua_UsuarioCreacion,
					@poco_FechaCreacion)

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() AS Resultado
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Listado_PorDetalle]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------------------------------------------------------------------
--ORDEN DE COMPRA DETALLES  (PROCESOS)---------------------------------------------------------------------------------


CREATE    PROCEDURE [Prod].[UDP_tbProcesoPorOrdenCompraDetalle_Listado_PorDetalle] 
(
@code_Id INT
)
AS
BEGIN
	BEGIN TRY
		SELECT	PPOCD.poco_Id, 
				PPOCD.code_Id, 
				PPOCD.proc_Id, 
				PROCE.proc_Descripcion,
				PPOCD.usua_UsuarioCreacion, 
				PPOCD.poco_FechaCreacion, 
				PPOCD.usua_UsuarioModificacion, 
				PPOCD.poco_FechaModificacion, 
				PPOCD.code_Estado,
				PROCE.proc_CodigoHtml
		FROM Prod.tbProcesoPorOrdenCompraDetalle PPOCD
			INNER JOIN Prod.tbOrdenCompraDetalles OCD
			ON PPOCD.code_Id = OCD.code_Id
			INNER JOIN Prod.tbProcesos PROCE
			ON PPOCD.proc_Id = PROCE.proc_Id
			WHERE PPOCD.code_Id = @code_Id

	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesos_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbProcesos_Editar] 
@proc_ID					INT,
@proc_CodigoHtml            NVARCHAR(50),
@proc_Descripcion			NVARCHAR(200),
@usua_UsuarioModificacion	INT,
@proc_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY
			IF EXISTS (SELECT proc_Id 
						FROM Prod.tbProcesos
						WHERE proc_Descripcion = @proc_Descripcion
						AND proc_Estado = 0)
				BEGIN
					DELETE FROM Prod.tbProcesos
					WHERE proc_Descripcion = @proc_Descripcion 
					AND proc_Estado = 0
				END

			UPDATE Prod.tbProcesos
			SET proc_Descripcion = @proc_Descripcion,
			proc_CodigoHtml = @proc_CodigoHtml,
			usua_UsuarioModificacion = @usua_UsuarioModificacion,
			proc_FechaModificacion = @proc_FechaModificacion
			WHERE proc_ID = @proc_ID
			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesos_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar Proceso*/
CREATE   PROCEDURE [Prod].[UDP_tbProcesos_Eliminar]
@proc_ID					INT,
@usua_UsuarioEliminacion	INT,
@proc_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
	DECLARE @respuesta INT
	 EXEC dbo.UDP_ValidarReferencias 'proc_ID', @proc_ID, 'Prod.tbProcesos', @respuesta OUTPUT
	 IF(@respuesta) = 1
			BEGIN
			UPDATE Prod.tbProcesos
			SET proc_Estado = 0,
			usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
			proc_FechaEliminacion = @proc_FechaEliminacion
			WHERE proc_ID = @proc_ID
	 END
		SELECT @respuesta AS Resultado

	END TRY
	BEGIN CATCH 
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesos_Filtrar_Modulos]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbProcesos_Filtrar_Modulos]
(
@proc_Id INT
)
AS
BEGIN
	BEGIN TRY
		SELECT	[modu_Id],
				[modu_Nombre],
				Proce.proc_Id,
				Proce.proc_Descripcion
		FROM	Prod.tbProcesos Proce
				INNER JOIN Prod.tbModulos Modu
				ON	Proce.proc_Id = Modu.proc_Id
		WHERE Proce.proc_Id = @proc_Id

		SELECT 1
	END TRY
	BEGIN CATCH
			SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesos_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbProcesos_Insertar]
@proc_Descripcion		NVARCHAR(200),
@proc_CodigoHtml		NVARCHAR(50),
@usua_UsuarioCreacion	INT,
@proc_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
			INSERT INTO Prod.tbProcesos(proc_Descripcion,proc_CodigoHtml,usua_UsuarioCreacion,proc_FechaCreacion)
			VALUES (
			@proc_Descripcion,		
			@proc_CodigoHtml,
			@usua_UsuarioCreacion,	
			@proc_FechaCreacion
			)
			SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbProcesos_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Prod].[UDP_tbProcesos_Listar]
AS
BEGIN
SELECT	proc_Id								,
		proc_Descripcion					,
		proc_CodigoHtml						, 
		pro.usua_UsuarioCreacion				,
		crea.usua_Nombre					AS usarioCreacion,			 
		proc_FechaCreacion					,
		pro.usua_UsuarioModificacion			,
		modi.usua_Nombre  					AS usuarioModificacion,
		proc_FechaModificacion				,
		pro.usua_UsuarioEliminacion				,
		elim.usua_Nombre 					AS usuarioEliminacion,
		proc_FechaEliminacion				,
		proc_Estado							
FROM	Prod.tbProcesos pro					
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = pro.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = pro.usua_UsuarioModificacion 
		LEFT JOIN Acce.tbUsuarios elim		ON elim.usua_Id = pro.usua_UsuarioEliminacion 
WHERE	proc_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDia_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****Editar*****--

CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDia_Editar]
@remo_Id					INT, 
@modu_Id					INT, 
@remo_Fecha					DATE, 
@remo_TotalDia				INT, 
@remo_TotalDanado			INT, 
@usua_UsuarioModificacion	INT, 
@remo_FechaModificacion	 	DATETIME 
AS
BEGIN
	BEGIN TRY
		UPDATE Prod.tbReporteModuloDia
		SET modu_Id					= @modu_Id, 
		remo_Fecha					= @remo_Fecha, 
		remo_TotalDia				= @remo_TotalDia, 
		remo_TotalDanado			= @remo_TotalDanado, 
		usua_UsuarioModificacion	= @usua_UsuarioModificacion, 
		remo_FechaModificacion		= @remo_FechaModificacion	 
		where remo_Id				= @remo_Id				

				select 1 

	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDia_Finalizado]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*****Finalizar*****--

CREATE    PROCEDURE [Prod].[UDP_tbReporteModuloDia_Finalizado]
	@remo_Id	INT
AS
BEGIN
	BEGIN TRY
		UPDATE [Prod].[tbReporteModuloDia]
		SET	   [remo_Finalizado] = 1
		WHERE  remo_Id = @remo_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error:' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDia_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****Insertar*****--
CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDia_Insertar]
@modu_Id				INT, 
@remo_Fecha				DATE, 
@remo_TotalDia			INT, 
@remo_TotalDanado		INT, 
@usua_UsuarioCreacion	INT, 
@remo_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY
		INSERT INTO Prod.tbReporteModuloDia (modu_Id, remo_Fecha, remo_TotalDia, remo_TotalDanado, usua_UsuarioCreacion, remo_FechaCreacion)
		VALUES (
		@modu_Id,				
		@remo_Fecha,				
		@remo_TotalDia,		
		@remo_TotalDanado,		
		@usua_UsuarioCreacion,	
		@remo_FechaCreacion
		)

		select SCOPE_IDENTITY()
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDia_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****ReporteModuloDia*****-
--*****Listado*****--
CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDia_Listar]
AS
BEGIN
SELECT	remo_Id, 
		modu.modu_Id, 
		modu.modu_Nombre,
		empleados.empl_Nombres + ' ' + empleados.empl_Apellidos as Empleado,
		remo_Fecha,
		remo_TotalDia - remo_TotalDanado as CantidadTotal,
		remo_TotalDia, 
		remo_TotalDanado, 
		(SELECT	rdet.[rdet_Id], 
		rdet.[remo_Id], 
		rdet.[code_Id], 
		rdet.[ensa_Id], 
		code.[orco_Id],
		orco.[orco_Codigo],
		rdet.[rdet_TotalDia], 
		rdet.[rdet_TotalDanado], 
		[proc].[proc_Descripcion],
		--modu.proc_Id AS colr_Nombre,
		modu.proc_Id,  

		(CASE code.code_Sexo 
			WHEN 'M' THEN 'Masculino'
			WHEN 'F' THEN 'Femenino'
			WHEN 'U' THEN 'Unisex'
			ELSE code.code_Sexo 
		END) AS Sexo,

		code.esti_Id,
		esti.esti_Descripcion, 

		clie.[clie_Nombre_Contacto], 
		clie.[clie_RTN],

		colr.[colr_Id],
		colr.[colr_Nombre],
		rdet.[rdet_Estado] 

		FROM	Prod.tbReporteModuloDiaDetalle			rdet
				INNER JOIN Prod.tbReporteModuloDia		remo					ON rdet.remo_Id = remo.remo_Id
				INNER JOIN Prod.tbModulos				modu					ON remo.modu_Id	= modu.modu_Id
				INNER JOIN Prod.tbOrde_Ensa_Acab_Etiq	ensa					ON rdet.ensa_Id	= ensa.ensa_Id
				INNER JOIN Prod.tbOrdenCompraDetalles   code				    ON ensa.code_Id	= code.code_Id
				INNER JOIN Prod.tbOrdenCompra			orco					ON code.orco_Id	= orco.orco_Id
				INNER JOIN Prod.tbClientes				clie					ON orco.orco_IdCliente = clie.clie_Id
				INNER JOIN Prod.tbProcesos				[proc]					ON modu.proc_Id	= [proc].proc_Id
				INNER JOIN Prod.tbEstilos				esti					ON code.esti_Id = esti.esti_Id
				INNER JOIN Prod.tbColores				colr					ON code.colr_Id	= colr.colr_Id
		WHERE rdet.remo_Id = rmd.remo_Id AND rdet_Estado = 1
			FOR JSON PATH) as detalles,
		rmd.usua_UsuarioCreacion, 
		crea.usua_Nombre AS usua_NombreUsuarioCreacion, 
		remo_FechaCreacion, 
		rmd.usua_UsuarioModificacion,
		modi.usua_Nombre AS usua_NombreUsuarioModificacion, 
		remo_FechaModificacion, 
		remo_Estado,
		remo_Finalizado 
FROM	Prod.tbReporteModuloDia rmd 
		INNER JOIN Prod.tbModulos modu				ON rmd.modu_Id = modu.modu_Id 
		INNER JOIN Gral.tbEmpleados  empleados		ON modu.empr_Id	= empleados.empl_Id
		INNER JOIN Acce.tbUsuarios crea				ON crea.usua_Id = rmd.usua_UsuarioCreacion 
		LEFT JOIN  Acce.tbUsuarios modi				ON modi.usua_Id = rmd.usua_UsuarioModificacion 	
ORDER BY rmd.remo_FechaCreacion desc
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDia_ListarPorFechas]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****Listado por fechas*****--
CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDia_ListarPorFechas]
@FechaInicio	DATE,
@FechaFin		DATE
AS
BEGIN
SELECT	remo_Id, 
		modu.modu_Id, 
		modu.modu_Nombre,
		remo_Fecha,
		remo_TotalDia - remo_TotalDanado as CantidadTotal,
		remo_TotalDia, 
		remo_TotalDanado, 
		(SELECT	rdet.[rdet_Id], 
		rdet.[remo_Id], 
		rdet.[code_Id], 
		rdet.[ensa_Id], 
		code.[orco_Id],
		orco.[orco_Codigo],
		rdet.[rdet_TotalDia], 
		rdet.[rdet_TotalDanado], 
		[proc].[proc_Descripcion],
		--modu.proc_Id AS colr_Nombre,
		modu.proc_Id,  

		(CASE code.code_Sexo 
			WHEN 'M' THEN 'Masculino'
			WHEN 'F' THEN 'Femenino'
			WHEN 'U' THEN 'Unisex'
			ELSE code.code_Sexo 
		END) AS Sexo,

		code.esti_Id,
		esti.esti_Descripcion, 

		clie.[clie_Nombre_Contacto], 
		clie.[clie_RTN],

		colr.[colr_Id],
		colr.[colr_Nombre],
		rdet.[rdet_Estado] 

		FROM	Prod.tbReporteModuloDiaDetalle			rdet
				INNER JOIN Prod.tbReporteModuloDia		remo					ON rdet.remo_Id = remo.remo_Id
				INNER JOIN Prod.tbModulos				modu					ON remo.modu_Id	= modu.modu_Id
				INNER JOIN Prod.tbOrde_Ensa_Acab_Etiq	ensa					ON rdet.ensa_Id	= ensa.ensa_Id
				INNER JOIN Prod.tbOrdenCompraDetalles   code				    ON ensa.code_Id	= code.code_Id
				INNER JOIN Prod.tbOrdenCompra			orco					ON code.orco_Id	= orco.orco_Id
				INNER JOIN Prod.tbClientes				clie					ON orco.orco_IdCliente = clie.clie_Id
				INNER JOIN Prod.tbProcesos				[proc]					ON modu.proc_Id	= [proc].proc_Id
				INNER JOIN Prod.tbEstilos				esti					ON code.esti_Id = esti.esti_Id
				INNER JOIN Prod.tbColores				colr					ON code.colr_Id	= colr.colr_Id
		WHERE rdet.remo_Id = rmd.remo_Id AND rdet_Estado = 1
			FOR JSON PATH) as detalles,
		rmd.usua_UsuarioCreacion, 
		crea.usua_Nombre AS usua_NombreUsuarioCreacion, 
		remo_FechaCreacion, 
		rmd.usua_UsuarioModificacion,
		modi.usua_Nombre AS usua_NombreUsuarioModificacion, 
		remo_FechaModificacion, 
		remo_Estado,
		remo_Finalizado 
FROM	Prod.tbReporteModuloDia rmd 
		INNER JOIN Prod.tbModulos modu				ON rmd.modu_Id = modu.modu_Id 
		INNER JOIN Acce.tbUsuarios crea				ON crea.usua_Id = rmd.usua_UsuarioCreacion 
		LEFT JOIN  Acce.tbUsuarios modi				ON modi.usua_Id = rmd.usua_UsuarioModificacion 		
WHERE	(remo_Fecha >= @FechaInicio AND remo_Fecha <= @FechaFin) OR (@FechaInicio IS NULL AND @FechaFin IS NULL)
ORDER BY remo_Fecha desc
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDiaDetalle_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* EDITAR REPORTE MODULO DIA DETALLE */
CREATE     PROCEDURE [Prod].[UDP_tbReporteModuloDiaDetalle_Editar] --415,246,777,7,298,70,33	
	@rdet_Id						INT,
	@remo_Id 						INT,
	@rdet_TotalDia					INT,
	@rdet_TotalDanado				INT,
	@code_Id						INT,
    @ensa_Id						INT,
	@usua_UsuarioModificacion		INT
AS
BEGIN
	BEGIN TRY


		UPDATE	Prod.tbReporteModuloDiaDetalle 
		SET		remo_Id						=	@remo_Id, 
				rdet_TotalDia				=	@rdet_TotalDia, 
				rdet_TotalDanado			=	@rdet_TotalDanado, 
				code_Id						=	@code_Id,
				ensa_Id						=   @ensa_Id,
				usua_UsuarioModificacion	=	@usua_UsuarioModificacion,
				rdet_FechaModificacion		=	GETDATE()
		WHERE	rdet_Id						=	@rdet_Id

		UPDATE [Prod].[tbReporteModuloDia]
		SET [remo_TotalDia] = (SELECT SUM(rdet_TotalDia) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id ),
			[remo_TotalDanado] = (SELECT SUM(rdet_TotalDanado) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id )
		WHERE [remo_Id] = @remo_Id

		SELECT 1
		COMMIT;
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK;
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDiaDetalle_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* ELIMINAR REPORTE MODULO DIA DETALLE */
CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDiaDetalle_Eliminar]
	@rdet_Id	INT
AS
BEGIN
	BEGIN TRY 

		DECLARE @remo_Id INT = (SELECT remo_Id FROM Prod.tbReporteModuloDiaDetalle WHERE rdet_Id = @rdet_Id)

		DELETE FROM Prod.tbReporteModuloDiaDetalle
		WHERE rdet_Id = @rdet_Id

		UPDATE [Prod].[tbReporteModuloDia]
		SET [remo_TotalDia] = (SELECT SUM(rdet_TotalDia) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id ),
			[remo_TotalDanado] = (SELECT SUM(rdet_TotalDanado) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id )
		WHERE [remo_Id] = @remo_Id

		SELECT 1
		COMMIT;
	END TRY
	BEGIN CATCH 
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK;
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDiaDetalle_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/* INSERTAR REPORTE MODULO DETALLE  */
CREATE   PROCEDURE [Prod].[UDP_tbReporteModuloDiaDetalle_Insertar] --1,50,6,298,70,33				
	@remo_Id 					INT,
	@rdet_TotalDia				INT,
	@rdet_TotalDanado			INT,
	@code_Id					INT,
    @ensa_Id					INT,
	@usua_UsuarioCreacion		INT
AS
BEGIN
	BEGIN TRY

		INSERT INTO Prod.tbReporteModuloDiaDetalle(	remo_Id, 
													rdet_TotalDia, 
													rdet_TotalDanado, 
													code_Id,
													ensa_Id,
													usua_UsuarioCreacion, 
													rdet_FechaCreacion)
		VALUES(	@remo_Id,
				@rdet_TotalDia,
				@rdet_TotalDanado,
				@code_Id,
				@ensa_Id,
				@usua_UsuarioCreacion,
				GETDATE())

		UPDATE [Prod].[tbReporteModuloDia]
		SET [remo_TotalDia] = (SELECT SUM(rdet_TotalDia) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id ),
			[remo_TotalDanado] = (SELECT SUM(rdet_TotalDanado) FROM Prod.tbReporteModuloDiaDetalle WHERE remo_Id = @remo_Id )
		WHERE [remo_Id] = @remo_Id

		--UPDATE [Prod].[tbOrde_Ensa_Acab_Etiq]
		--SET ensa_Terminado = 1
		--WHERE ensa_Id = @ensa_Id AND ensa_Cantidad <= (SELECT SUM(rdet_TotalDia) FROM Prod.tbReporteModuloDiaDetalle WHERE ensa_Id = @ensa_Id)
		UPDATE [Prod].[tbProcesoPorOrdenCompraDetalle]
		SET poco_Completado = poco_Completado + (@rdet_TotalDia - @rdet_TotalDanado)
		WHERE code_Id = (SELECT code_Id FROM [Prod].[tbOrde_Ensa_Acab_Etiq] WHERE ensa_Id = @ensa_Id)
		AND proc_Id = (SELECT proc_Id FROM [Prod].[tbReporteModuloDia] remo 
				INNER JOIN [Prod].[tbModulos] modu ON remo.modu_Id = modu.modu_Id 
			 WHERE remo_Id = @remo_Id)

		SELECT 1
		COMMIT; 
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
		ROLLBACK; 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbReporteModuloDiaDetalle_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [Prod].[UDP_tbReporteModuloDiaDetalle_Listar]	 --246
@remo_Id		INT
AS
BEGIN
SELECT	rdet.[rdet_Id], 
		rdet.[remo_Id], 
		rdet.[code_Id], 
		rdet.[ensa_Id], 
		code.[orco_Id],
		orco.[orco_Codigo],
		rdet.[rdet_TotalDia], 
		rdet.[rdet_TotalDanado], 
		[proc].[proc_Descripcion],
		--modu.proc_Id AS colr_Nombre,
		modu.proc_Id,  

		(CASE code.code_Sexo 
			WHEN 'M' THEN 'Masculino'
			WHEN 'F' THEN 'Femenino'
			WHEN 'U' THEN 'Unisex'
			ELSE code.code_Sexo 
		END) AS Sexo,

		code.esti_Id,
		esti.esti_Descripcion, 

		clie.[clie_Nombre_Contacto], 
		clie.[clie_RTN],

		colr.[colr_Id],
		colr.[colr_Nombre],
		rdet.[rdet_Estado] 

		FROM	Prod.tbReporteModuloDiaDetalle			rdet
				INNER JOIN Prod.tbReporteModuloDia		remo					ON rdet.remo_Id = remo.remo_Id
				INNER JOIN Prod.tbModulos				modu					ON remo.modu_Id	= modu.modu_Id
				INNER JOIN Prod.tbOrde_Ensa_Acab_Etiq	ensa					ON rdet.ensa_Id	= ensa.ensa_Id
				INNER JOIN Prod.tbOrdenCompraDetalles   code				    ON ensa.code_Id	= code.code_Id
				INNER JOIN Prod.tbOrdenCompra			orco					ON code.orco_Id	= orco.orco_Id
				INNER JOIN Prod.tbClientes				clie					ON orco.orco_IdCliente = clie.clie_Id
				INNER JOIN Prod.tbProcesos				[proc]					ON modu.proc_Id	= [proc].proc_Id
				INNER JOIN Prod.tbEstilos				esti					ON code.esti_Id = esti.esti_Id
				INNER JOIN Prod.tbColores				colr					ON code.colr_Id	= colr.colr_Id
		WHERE rdet.remo_Id = @remo_Id AND rdet_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionCalidad_NuevoListar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*NuevoListar revision de calidad*/
CREATE   PROCEDURE [Prod].[UDP_tbRevisionCalidad_NuevoListar]
@ensa_id INT
AS
BEGIN
SELECT	ensa_Id, 
		ensa_Cantidad, 
		emp.empl_Id, 
		CONCAT(emp.empl_Nombres ,' ',emp.empl_Apellidos) AS empl_NombreCompleto,
		ocd.code_Id,
		ocd.code_Sexo,
		est.esti_Id,
		est.esti_Descripcion,
		ensa_FechaInicio, 
		ensa_FechaLimite, 
		pp.ppro_Id, 
		modu.modu_Id,
		modu.modu_Nombre,
		modu.proc_Id,
		pro.proc_Descripcion,
		crea.usua_Nombre							AS UsurioCreacionNombre, 
		ensa_FechaCreacion,							
		modi.usua_Nombre							AS UsuarioModificacionNombre, 
		ensa_FechaModificacion, 
		ensa_Estado,
		(SELECT m.* 
				FROM 
				(	SELECT ROW_NUMBER() OVER(ORDER BY revi.reca_Id DESC) AS [key],
						   revi.reca_Id,
						   revi.ensa_Id, 
						   revi.reca_Descripcion, 
						   revi.reca_Cantidad, 
						   revi.reca_Scrap, 
						   revi.reca_FechaRevision, 
						   revi.reca_Imagen, 
						   revi.usua_UsuarioCreacion, 
						   usuaCrea.usua_Nombre                       AS usuarioCreacionNombre,
						   revi.reca_FechaCreacion, 
						   revi.usua_UsuarioModificacion,
						   usuaModifica.usua_Nombre                   AS usuarioModificacionNombre,
						   revi.reca_FechaModificacion, 
						   revi.reca_Estado
					  FROM Prod.tbRevisionDeCalidad revi
						   LEFT JOIN  Acce.tbUsuarios usuaCrea		  ON revi.usua_UsuarioCreacion     = usuaCrea.usua_Id 
						   LEFT JOIN  Acce.tbUsuarios usuaModifica	  ON revi.usua_UsuarioModificacion = usuaModifica.usua_Id
					  WHERE revi.ensa_id = ensa.ensa_Id) AS m
			  FOR JSON AUTO) as detalles
		FROM	Prod.tbOrde_Ensa_Acab_Etiq ensa
		INNER JOIN Gral.tbEmpleados emp				ON emp.empl_Id  = ensa.empl_Id
		INNER JOIN Prod.tbOrdenCompraDetalles ocd	ON ocd.code_Id  = ensa.code_Id
		INNER JOIN Prod.tbEstilos est				ON est.esti_Id	= ocd.esti_Id
		INNER JOIN Prod.tbPedidosProduccion pp		ON pp.ppro_Id   = ensa.ppro_Id
		INNER JOIN Prod.tbModulos			modu	ON ensa.modu_Id = modu.modu_Id
		INNER JOIN Prod.tbProcesos	pro				ON modu.proc_Id = pro.proc_Id
		INNER JOIN Acce.tbUsuarios crea				ON crea.usua_Id = ensa.usua_UsuarioCreacion 
		LEFT JOIN  Acce.tbUsuarios modi				ON modi.usua_Id = ensa.usua_UsuarioModificacion 
		WHERE ensa.ensa_Id = @ensa_Id OR @ensa_Id = 0
END

GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionDeCalidad_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar revision de calidad*/
CREATE   PROCEDURE [Prod].[UDP_tbRevisionDeCalidad_Editar]
	@reca_Id                  INT, 
	@ensa_Id                  INT, 
	@reca_Descripcion         NVARCHAR(200), 
	@reca_Cantidad            INT, 
	@reca_Scrap               BIT, 
	@reca_FechaRevision       DATETIME,
	@reca_Imagen              NVARCHAR(MAX),
	@usua_UsuarioModificacion INT, 
	@reca_FechaModificacion   DATETIME
AS
BEGIN
	BEGIN TRY
		UPDATE  Prod.tbRevisionDeCalidad
		SET		ensa_Id                  = @ensa_Id                 ,
		        reca_Descripcion         = @reca_Descripcion        ,
				reca_Cantidad            = @reca_Cantidad           ,
				reca_Scrap               = @reca_Scrap              ,
				reca_FechaRevision       = @reca_FechaRevision      ,
				reca_Imagen              = @reca_Imagen             ,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				reca_FechaModificacion   = @reca_FechaModificacion
		WHERE	reca_Id                  = @reca_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionDeCalidad_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Eliminar revision de calidad*/
CREATE   PROCEDURE [Prod].[UDP_tbRevisionDeCalidad_Eliminar]
	@reca_Id                  INT
AS
BEGIN
	BEGIN TRY
		DELETE FROM Prod.tbRevisionDeCalidad
		WHERE	reca_Id                  = @reca_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionDeCalidad_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*Insertar revision de calidad*/
CREATE   PROCEDURE [Prod].[UDP_tbRevisionDeCalidad_Insertar]
	@ensa_Id                  INT,
	@reca_Descripcion         NVARCHAR(200),
	@reca_Cantidad            INT,
	@reca_Scrap               BIT, 
	@reca_FechaRevision       DATETIME, 
	@reca_Imagen              NVARCHAR(MAX), 
	@usua_UsuarioCreacion     INT, 
	@reca_FechaCreacion       DATETIME	 
AS 
BEGIN
	
	BEGIN TRY
		INSERT INTO Prod.tbRevisionDeCalidad(ensa_Id,
		                                     reca_Descripcion, 
											 reca_Cantidad, 
											 reca_Scrap, 
											 reca_FechaRevision, 
											 reca_Imagen, 
											 usua_UsuarioCreacion, 
											 reca_FechaCreacion)
		      VALUES(@ensa_Id,
			         @reca_Descripcion, 
					 @reca_Cantidad, 
					 @reca_Scrap, 
					 @reca_FechaRevision, 
					 @reca_Imagen, 
					 @usua_UsuarioCreacion, 
					 @reca_FechaCreacion)
		
		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionDeCalidad_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--**********REVISION DE CALIDAD**********--
/*Listar revisión de calidad*/
CREATE   PROCEDURE [Prod].[UDP_tbRevisionDeCalidad_Listar]
AS
BEGIN
	SELECT revi.reca_Id,
	       revi.ensa_Id, 
		   revi.reca_Descripcion, 
		   revi.reca_Cantidad, 
		   revi.reca_Scrap, 
		   revi.reca_FechaRevision, 
		   revi.reca_Imagen, 
		   revi.usua_UsuarioCreacion, 
		   usuaCrea.usua_Nombre                       AS usuarioCreacionNombre,
		   revi.reca_FechaCreacion, 
		   revi.usua_UsuarioModificacion,
		   usuaModifica.usua_Nombre                   AS usuarioModificacionNombre,
		   revi.reca_FechaModificacion, 
		   revi.reca_Estado
      FROM Prod.tbRevisionDeCalidad revi
	       LEFT JOIN  Acce.tbUsuarios usuaCrea		  ON revi.usua_UsuarioCreacion     = usuaCrea.usua_Id 
		   LEFT JOIN  Acce.tbUsuarios usuaModifica	  ON revi.usua_UsuarioModificacion = usuaModifica.usua_Id
		   INNER JOIN Prod.tbOrde_Ensa_Acab_Etiq ensa ON revi.ensa_Id                  = ensa.ensa_Id
	 WHERE reca_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbRevisionDeCalidadErrores_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*Listar Revision de calidad errores */
CREATE   PROCEDURE [Prod].[UDP_tbRevisionDeCalidadErrores_Listar]
AS
BEGIN
	SELECT [rcer_Id]
		  ,[rcer_Nombre]
		   ,usuaCrea.usua_Nombre			AS usuarioCreacionNombre,
		   rcer_FechaCreacion, 
		   reca.usua_UsuarioModificacion, 
		   usuaModifica.usua_Nombre		AS usuarioModificacionNombre,
		   rcer_FechaModificacion, 
		   reca.usua_UsuarioEliminacion, 
		   usuaElimina.usua_Nombre		AS usuarioEliminacionNombre,
		   rcer_FechaEliminacion
		  ,[rcer_Estado]
	  FROM [Prod].[tbRevisionDeCalidadErrores] reca
	INNER JOIN Acce.tbUsuarios usuaCrea		ON reca.usua_UsuarioCreacion = usuaCrea.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaModifica  ON reca.usua_UsuarioModificacion = usuaModifica.usua_Id 
	LEFT JOIN Acce.tbUsuarios usuaElimina   ON reca.usua_UsuarioEliminacion = usuaElimina.usua_Id
	WHERE [rcer_Estado] = 1 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbSubcategoria_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Editar subcategoria*/
CREATE   PROCEDURE [Prod].[UDP_tbSubcategoria_Editar]
	@subc_Id                   INT,
	@cate_Id                   INT, 
	@subc_Descripcion          NVARCHAR(200), 
	@usua_UsuarioModificacion  INT, 
	@subc_FechaModificacion    DATETIME
AS
BEGIN
	BEGIN TRY
		IF EXISTS (SELECT *
				   FROM Prod.tbSubcategoria
				   WHERE cate_Id = @cate_Id
				   AND	 subc_Descripcion = @subc_Descripcion
				   AND subc_Estado = 0)
			BEGIN
				DELETE FROM Prod.tbSubcategoria
				WHERE cate_Id = @cate_Id
				AND	 subc_Descripcion = @subc_Descripcion
				AND subc_Estado = 0

			END

		UPDATE  Prod.tbSubcategoria
		SET		cate_Id                  = @cate_Id,
				subc_Descripcion         = @subc_Descripcion,
				usua_UsuarioModificacion = @usua_UsuarioModificacion,
				subc_FechaModificacion   = @subc_FechaModificacion
		WHERE	subc_Id = @subc_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbSubcategoria_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar subcategoria*/
CREATE   PROCEDURE [Prod].[UDP_tbSubcategoria_Eliminar]
	@subc_Id					INT,
	@usua_UsuarioEliminacion	INT,
	@subc_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
			DECLARE @respuesta INT
			EXEC dbo.UDP_ValidarReferencias 'subc_Id', @subc_Id, 'Prod.tbSubcategoria', @respuesta OUTPUT

			IF(@respuesta) = 1
			BEGIN
				UPDATE	Prod.tbSubcategoria
				SET		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
						subc_FechaEliminacion = @subc_FechaEliminacion,
						subc_Estado = 0
				WHERE subc_Id = @subc_Id
			END			
			SELECT @respuesta AS Resultado

	END TRY

	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbSubcategoria_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*Insertar subcategoria*/
CREATE   PROCEDURE [Prod].[UDP_tbSubcategoria_Insertar]
	@cate_Id			    INT,
	@subc_Descripcion       NVARCHAR(200),
	@usua_UsuarioCreacion	INT,
	@usua_FechaCreacion     DATETIME
AS 
BEGIN
	
	BEGIN TRY
		IF EXISTS (SELECT *
				   FROM Prod.tbSubcategoria
				   WHERE cate_Id = @cate_Id
				   AND subc_Descripcion = @subc_Descripcion
				   AND subc_Estado = 0)
			BEGIN
				UPDATE Prod.tbSubcategoria
				SET subc_Estado = 1
				WHERE cate_Id = @cate_Id
				AND subc_Descripcion = @subc_Descripcion

				SELECT 1
			END
		ELSE
			BEGIN
				INSERT INTO Prod.tbSubcategoria (cate_Id, subc_Descripcion, usua_UsuarioCreacion, subc_FechaCreacion)
				VALUES(@cate_Id, @subc_Descripcion, @usua_UsuarioCreacion, @usua_FechaCreacion)
		
				SELECT 1
			END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE()
	END CATCH 
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbSubcategoria_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************SUBCATEGORIA******************--
/*Listar subcategoria*/
CREATE   PROCEDURE [Prod].[UDP_tbSubcategoria_Listar]
AS
BEGIN
	SELECT subc.subc_Id,
           subc.cate_Id, 
	       cate.cate_Descripcion,					
	       subc.subc_Descripcion, 
	       subc.usua_UsuarioCreacion,
	       usuaCrea.usua_Nombre						AS usuarioCreacionNombre,
	       subc.subc_FechaCreacion, 
	       subc.usua_UsuarioModificacion, 
	       usuaModifica.usua_Nombre					AS usuarioModificaNombre,
	       subc.subc_FechaModificacion, 
           subc.usua_UsuarioEliminacion,
		   usuaElim.usua_Nombre                     AS usuarioEliminaNombre,                   
           subc_FechaEliminacion,
	       subc.subc_Estado
      FROM Prod.tbSubcategoria subc 
	       INNER JOIN Acce.tbUsuarios usuaCrea      ON subc.usua_UsuarioCreacion = usuaCrea.usua_Id 
		   LEFT JOIN Acce.tbUsuarios usuaModifica   ON subc.usua_UsuarioModificacion = usuaModifica.usua_Id 
		   LEFT JOIN Acce.tbUsuarios usuaElim       ON subc.usua_UsuarioEliminacion = usuaElim.usua_Id 
		   INNER JOIN Prod.tbCategoria cate         ON subc.cate_Id = cate.cate_Id
	 WHERE subc_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbSubcategoria_ListarByIdCategoria]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Prod].[UDP_tbSubcategoria_ListarByIdCategoria]
(
	@cate_Id		INT
)
AS
BEGIN
	SELECT subc.subc_Id,
           subc.cate_Id, 
	       cate.cate_Descripcion,					
	       subc.subc_Descripcion, 
	       subc.usua_UsuarioCreacion,
	       usuaCrea.usua_Nombre						AS usuarioCreacionNombre,
	       subc.subc_FechaCreacion, 
	       subc.usua_UsuarioModificacion, 
	       usuaModifica.usua_Nombre					AS usuarioModificaNombre,
	       subc.subc_FechaModificacion, 
           subc.usua_UsuarioEliminacion,
		   usuaElim.usua_Nombre                     AS usuarioEliminaNombre,                   
           subc_FechaEliminacion,
	       subc.subc_Estado
      FROM Prod.tbSubcategoria subc 
	       INNER JOIN Acce.tbUsuarios usuaCrea      ON subc.usua_UsuarioCreacion = usuaCrea.usua_Id 
		   LEFT JOIN Acce.tbUsuarios usuaModifica   ON subc.usua_UsuarioModificacion = usuaModifica.usua_Id 
		   LEFT JOIN Acce.tbUsuarios usuaElim       ON subc.usua_UsuarioEliminacion = usuaElim.usua_Id 
		   INNER JOIN Prod.tbCategoria cate         ON subc.cate_Id = cate.cate_Id
	 WHERE subc_Estado = 1
	   AND subc.cate_Id = @cate_Id
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTallas_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Talla*/
CREATE   PROCEDURE [Prod].[UDP_tbTallas_Editar]
@tall_Id					INT,
@tall_Codigo				CHAR(5),
@tall_Nombre				NVARCHAR(200),
@usua_UsuarioModificacion	INT,
@tall_FechaModificacion		DATETIME
AS
BEGIN
BEGIN TRY  
		UPDATE  Prod.tbTallas 
		SET tall_Nombre				= @tall_Nombre,
		tall_Codigo					= @tall_Codigo,
		usua_UsuarioModificacion	= @usua_UsuarioModificacion,
		tall_FechaModificacion		= @tall_FechaModificacion
		WHERE tall_Id				= @tall_Id
			SELECT 1
END TRY
BEGIN CATCH
	SELECT 'Error Message: ' + ERROR_MESSAGE()
END CATCH

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTallas_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Talla*/
CREATE   PROCEDURE [Prod].[UDP_tbTallas_Insertar]
@tall_Codigo			CHAR(5),
@tall_Nombre			NVARCHAR(200),
@usua_UsuarioCreacion	INT,
@tall_FechaCreacion		DATETIME
AS
BEGIN
BEGIN TRY 
		INSERT INTO Prod.tbTallas(tall_Codigo,tall_Nombre,usua_UsuarioCreacion,tall_FechaCreacion)
		VALUES (
		@tall_Codigo,
		@tall_Nombre,
		@usua_UsuarioCreacion,
		@tall_FechaCreacion
		)
			SELECT 1
END TRY
BEGIN CATCH
	SELECT 'Error Message: ' + ERROR_MESSAGE()
END CATCH

END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTallas_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--************TALLA******************--
/*Listar Talla*/
CREATE   PROCEDURE [Prod].[UDP_tbTallas_Listar]
AS
BEGIN
SELECT	tall_Id								,
		tall_Codigo							,
		tall_Nombre							,			 
		crea.usua_Nombre					AS usarioCreacion,
		tall_FechaCreacion					,
		modi.usua_Nombre 					AS usuarioModificacion,
		tall_FechaModificacion 				,
		tall_Estado							
FROM	Prod.tbTallas tall 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = tall.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = tall.usua_UsuarioModificacion 
WHERE	tall_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTipoEmbalaje_Editar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Editar Tipo Embalaje*/
CREATE   PROCEDURE [Prod].[UDP_tbTipoEmbalaje_Editar]
@tiem_Id					INT,
@tiem_Descripcion			NVARCHAR(200),
@usua_UsuarioModificacion	INT,
@tiem_FechaModificacion		DATETIME
AS
BEGIN
	BEGIN TRY

	IF EXISTS (SELECT * FROM Prod.tbTipoEmbalaje 
			   WHERE tiem_Descripcion = @tiem_Descripcion
			   AND tiem_Estado = 0)
		BEGIN
			DELETE FROM Prod.tbTipoEmbalaje	
			WHERE tiem_Descripcion = @tiem_Descripcion
			AND tiem_Estado = 0
		END

		UPDATE Prod.tbTipoEmbalaje
		SET tiem_Descripcion = @tiem_Descripcion,
		usua_UsuarioModificacion = @usua_UsuarioModificacion,
		tiem_FechaModificacion = @tiem_FechaModificacion
		WHERE tiem_Id = @tiem_Id

		SELECT 1
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTipoEmbalaje_Eliminar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Eliminar Tipo Embalaje*/
CREATE   PROCEDURE [Prod].[UDP_tbTipoEmbalaje_Eliminar]
@tiem_Id					INT,
@usua_UsuarioEliminacion	INT,
@tiem_FechaEliminacion		DATETIME
AS
BEGIN
	BEGIN TRY
		DECLARE @respuesta INT
	 EXEC dbo.UDP_ValidarReferencias 'tiem_Id', @tiem_Id, 'Prod.tbTipoEmbalaje', @respuesta OUTPUT
	 IF(@respuesta) = 1
	 BEGIN
		UPDATE Prod.tbTipoEmbalaje
		SET tiem_Estado = 0,
		usua_UsuarioEliminacion = @usua_UsuarioEliminacion,
		tiem_FechaEliminacion = @tiem_FechaEliminacion
		WHERE tiem_Id = @tiem_Id
	END			
	SELECT @respuesta AS Resultado	
	END TRY 
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTipoEmbalaje_Insertar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Insertar Tipo Embalaje*/
CREATE   PROCEDURE [Prod].[UDP_tbTipoEmbalaje_Insertar]
@tiem_Descripcion		NVARCHAR(200),
@usua_UsuarioCreacion	INT,
@tiem_FechaCreacion		DATETIME
AS
BEGIN
	BEGIN TRY

		IF EXISTS (SELECT * FROM Prod.tbTipoEmbalaje WHERE tiem_Descripcion = @tiem_Descripcion AND tiem_Estado = 0)
		BEGIN
		UPDATE Prod.tbTipoEmbalaje
			SET tiem_Estado = 1,
				usua_UsuarioCreacion = @usua_UsuarioCreacion,
				tiem_FechaCreacion = @tiem_FechaCreacion
			WHERE tiem_Descripcion = @tiem_Descripcion
			SELECT 1	
		END
		ELSE
		BEGIN
			INSERT INTO Prod.tbTipoEmbalaje (tiem_Descripcion, usua_UsuarioCreacion, tiem_FechaCreacion)
			VALUES ( @tiem_Descripcion, @usua_UsuarioCreacion, @tiem_FechaCreacion )
			SELECT 1
		END
	END TRY
	BEGIN CATCH
		SELECT 'Error Message: ' + ERROR_MESSAGE() 
	END CATCH
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_tbTipoEmbalaje_Listar]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--************TIPO EMBALAJE******************--
/*Listar Tipo Embalaje*/
CREATE   PROCEDURE [Prod].[UDP_tbTipoEmbalaje_Listar]
AS
BEGIN
SELECT	tiem_Id								,
		tiem_Descripcion					,
		crea.usua_Nombre					AS usarioCreacion,			 
		tiem_FechaCreacion					,
		modi.usua_Nombre 					AS usuarioModificacion,
		tiem_FechaModificacion				,
		elim.usua_Nombre 					AS usuarioEliminacion,
		tiem_FechaEliminacion				,
		tiem_Estado 						
FROM	Prod.tbTipoEmbalaje tiem 
		INNER JOIN Acce.tbUsuarios crea		ON crea.usua_Id = tiem.usua_UsuarioCreacion 
		LEFT JOIN Acce.tbUsuarios modi		ON modi.usua_Id = tiem.usua_UsuarioModificacion 
		LEFT JOIN Acce.tbUsuarios elim		ON elim.usua_Id = tiem.usua_UsuarioEliminacion
WHERE	tiem_Estado = 1
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_TotalOrdenesCompraAnual]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA MOSTRAR EL TOTAL DE ORDENES DE COMPRA ANUALES
CREATE   PROCEDURE [Prod].[UDP_TotalOrdenesCompraAnual]
AS
BEGIN
    SELECT		
        YEAR(orco_FechaCreacion) AS Anio,
        COUNT(orco_Id) AS orco_Conteo
    FROM Prod.tbOrdenCompra
    GROUP BY YEAR(orco_FechaCreacion)
    ORDER BY Anio;
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_TotalOrdenesCompraDiario]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA MOSTRAR LAS ORDENES DE COMPRA DIARIAS
CREATE   PROCEDURE [Prod].[UDP_TotalOrdenesCompraDiario]
AS
BEGIN
    SET LANGUAGE Spanish;

    DECLARE @FechaInicial DATE, @FechaFinal DATE;
    SET @FechaInicial = DATEADD(DAY, -7, GETDATE()); 
    SET @FechaFinal = GETDATE();
    SELECT
        CAST(orco_FechaCreacion AS DATE) AS Fecha,
        COUNT(orco_Id) AS orco_Conteo
    FROM Prod.tbOrdenCompra
    WHERE orco_FechaCreacion BETWEEN @FechaInicial AND @FechaFinal
    GROUP BY CAST(orco_FechaCreacion AS DATE)
    ORDER BY Fecha;
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_TotalOrdenesCompraMensual]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO PARA MOSTRAR EL TOTAL; DE OPRDENES DE COMPRA MENSUALES
CREATE   PROCEDURE [Prod].[UDP_TotalOrdenesCompraMensual]
AS
BEGIN
SET LANGUAGE Spanish;

    SELECT
        YEAR(orco_FechaCreacion) AS Anio,
        MONTH(orco_FechaCreacion) AS Mes,
        COUNT(orco_Id) AS orco_Conteo,
        DATENAME(MONTH, orco_FechaCreacion) AS MesLabel
    FROM Prod.tbOrdenCompra
    GROUP BY YEAR(orco_FechaCreacion), MONTH(orco_FechaCreacion), DATENAME(MONTH, orco_FechaCreacion)
    ORDER BY Anio, Mes;
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_VentasAnuales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO QUE MUESTRA TODAS LAS VENTAS DEL AÑO (DIVIDIDO EN MESES)
CREATE   PROCEDURE [Prod].[UDP_VentasAnuales]
AS
BEGIN
	SELECT	
			CONVERT(DATE, MIN(faex_Fecha))	 AS FechaAntigua,
			CONVERT(DATE, MAX(faex_Fecha))	AS FechaReciente,
			DATEPART(MONTH, faex_Fecha)		AS NumeroMes,
			SUM(faex_Total)					AS TotalIngresos	
	FROM Prod.tbFacturasExportacion
	WHERE 
			DATEPART(YEAR, faex_Fecha) =  DATEPART(YEAR, GETDATE())
	GROUP BY
			DATEPART(YEAR, faex_Fecha),
			DATEPART(MONTH, faex_Fecha)
	ORDER BY FechaAntigua ASC
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_VentasMensuales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- PROCEDIMIENTO QUE MUESTRA  TODAS LAS VENTAS DEL MES (DIVIDIDO EN SEMANAS)
CREATE   PROCEDURE [Prod].[UDP_VentasMensuales]
AS
BEGIN
	
	SET LANGUAGE Spanish;

	SELECT	
			CONVERT(DATE, MIN(faex_Fecha))	 AS FechaAntigua,
			CONVERT(DATE, MAX(faex_Fecha))	AS FechaReciente,
			DATEPART(MONTH, faex_Fecha) AS NumeroMes,
			DATENAME(month, GETDATE()) AS mes,
			SUM(faex_Total)				AS TotalIngresos	
	FROM	Prod.tbFacturasExportacion
	WHERE	
			DATEPART(YEAR, faex_Fecha) =  DATEPART(YEAR, GETDATE())
			AND DATEPART(MONTH, faex_Fecha) = DATEPART(MONTH, GETDATE()) 
	GROUP BY
			DATEPART(YEAR, faex_Fecha),
			DATEPART(MONTH, faex_Fecha)
	ORDER BY FechaAntigua ASC
END
GO
/****** Object:  StoredProcedure [Prod].[UDP_VentasSemanales]    Script Date: 28/9/2023 13:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--INSERT INTO Prod.tbFacturasExportacion(duca_No_Duca, faex_Fecha, orco_Id, faex_Total, usua_UsuarioCreacion, faex_FechaCreacion)
--VALUES	('54363244535', '08-07-2023', 1, 15000, 1, '08-07-2023'),
--		('54363244535', '08-09-2023', 2, 35000, 1, '08-09-2023'),
--		('54363244535', '08-10-2023', 3, 20000, 1, '08-10-2023'),
--		('54363244535', '08-11-2023', 1, 30000, 1, '08-11-2023'),

--		('83739333921', '08-12-2023', 2, 50000, 1, '08-12-2023'),
--		('83739333921', '08-13-2023', 3, 45000, 1, '08-13-2023'),
--		('83739333921', '08-14-2023', 1, 75000, 1, '08-14-2023'),
--		('83739333921', '08-15-2023', 2, 55000, 1, '08-15-2023'),
													 
--		('54363244535', '08-16-2023', 2, 34000, 1, '08-16-2023'),
--		('54363244535', '08-17-2023', 4, 23000, 1, '08-17-2023'),
--		('54363244535', '08-18-2023', 1, 66000, 1, '08-18-2023'),
--		('83739333921', '08-19-2023', 4, 12000, 1, '08-19-2023'),
													 
--		('83739333921', '08-20-2023', 1, 23000, 1, '08-20-2023'),
--		('83739333921', '08-20-2023', 2, 34500, 1, '08-20-2023'),
--		('83739333921', '08-21-2023', 2, 56000, 1, '08-21-2023'),
--		('83739333921', '08-21-2023', 3, 100000, 1, '08-21-2023'),
		
--		('54363244535', '08-07-2022', 1, 15000, 1, '08-07-2022'),
--		('54363244535', '08-09-2022', 2, 35000, 1, '08-09-2022'),
--		('54363244535', '08-10-2022', 3, 20000, 1, '08-10-2022'),
--		('54363244535', '08-11-2022', 1, 30000, 1, '08-11-2022'),

--		('83739333921', '08-12-2022', 2, 50000, 1, '08-12-2022'),
--		('83739333921', '08-13-2022', 3, 45000, 1, '08-13-2022'),
--		('83739333921', '08-14-2022', 1, 75000, 1, '08-14-2022'),
--		('83739333921', '08-15-2022', 2, 55000, 1, '08-15-2022'),

--		('54363244535', '08-16-2022', 2, 34000, 1, '08-16-2022'),
--		('54363244535', '08-17-2022', 4, 23000, 1, '08-17-2022'),
--		('54363244535', '08-18-2022', 1, 66000, 1, '08-18-2022'),
--		('83739333921', '08-19-2022', 4, 12000, 1, '08-19-2022'),

--		('83739333921', '08-20-2022', 1, 23000, 1, '08-20-2022'),
--		('83739333921', '08-20-2022', 2, 34500, 1, '08-20-2022'),
--		('83739333921', '08-21-2022', 2, 56000, 1, '08-21-2022'),
--		('83739333921', '08-21-2022', 3, 100000, 1, '08-21-2022'),
		
--		('54363244535', '08-22-2023', 1, 15000, 1, '08-22-2023'),
--		('54363244535', '08-23-2023', 2, 35000, 1, '08-23-2023'),
--		('54363244535', '08-24-2023', 3, 20000, 1, '08-24-2023'),
--		('54363244535', '08-25-2023', 1, 30000, 1, '08-25-2023'),
								  							 
--		('83739333921', '08-26-2023', 2, 50000, 1, '08-26-2023'),
--		('83739333921', '08-27-2023', 3, 45000, 1, '08-27-2023'),
--		('83739333921', '08-28-2023', 1, 75000, 1, '08-28-2023'),
--		('83739333921', '08-29-2023', 2, 55000, 1, '08-29-2023'),
								  							 
--		('54363244535', '08-30-2023', 2, 34000, 1, '08-30-2023'),
--		('54363244535', '08-31-2023', 4, 23000, 1, '08-31-2023'),
--		('54363244535', '09-01-2023', 1, 66000, 1, '09-01-2023'),
--		('83739333921', '09-02-2023', 4, 12000, 1, '09-02-2023'),
								  							 
--		('83739333921', '09-03-2023', 1, 23000, 1, '09-03-2023'),
--		('83739333921', '09-04-2023', 2, 34500, 1, '09-04-2023'),
--		('83739333921', '09-05-2023', 2, 56000, 1, '09-04-2023'),
--		('83739333921', '09-06-2023', 3, 100000, 1, '09-06-2023')
--GO



-- PROCEDIMIENTO QUE MUESTRA TODAS LAS VENTAS DE LA SEMANA (DIVIDIDO EN DIAS)
CREATE   PROCEDURE [Prod].[UDP_VentasSemanales]
AS
BEGIN
	SELECT	
			CONVERT(DATE, MIN(faex_Fecha))	 AS FechaAntigua,
			CONVERT(DATE, MAX(faex_Fecha))	AS FechaReciente,
			DATEPART(MONTH, faex_Fecha) AS NumeroMes,
			DATEPART(WEEK, faex_Fecha)	AS NumeroSemana,
			DATEPART(DAY, faex_Fecha)	AS NumeroDia, 
			SUM(faex_Total)				AS TotalIngresos	
	FROM	Prod.tbFacturasExportacion
	WHERE	
			DATEPART(YEAR, faex_Fecha) =  DATEPART(YEAR, GETDATE())
			AND DATEPART(MONTH, faex_Fecha) =  DATEPART(MONTH, GETDATE()) 
			AND	DATEPART(WEEK, faex_Fecha) =  DATEPART(WEEK, GETDATE()) 
	GROUP BY
			DATEPART(YEAR, faex_Fecha),
			DATEPART(MONTH, faex_Fecha),
			DATEPART(WEEK, faex_Fecha),
			DATEPART(DAY, faex_Fecha) 
	ORDER BY FechaAntigua ASC
END
GO
ALTER DATABASE [SIMEXPRO] SET  READ_WRITE 
GO
