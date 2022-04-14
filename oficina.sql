CREATE DATABASE [oficina]
GO
USE [oficina]
GO
/****** Object:  Table [dbo].[cliente_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente_oficina](
	[id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](50) NULL,
	[sobrenome] [varchar](50) NULL,
	[cep] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[carro_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carro_oficina](
	[id_carro] [int] IDENTITY(1,1) NOT NULL,
	[placa] [varchar](20) NULL,
	[modelo] [varchar](30) NULL,
	[marca] [varchar](30) NULL,
	[ano] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_carro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[cliente_carro]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cliente_carro](
	[id_cliente] [int] NULL,
	[id_carro] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_cliente_carro_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_cliente_carro_oficina]
AS
    select cc.id_cliente, nome, cc.id_carro, placa, modelo from cliente_carro cc
    inner join cliente_oficina c on cc.id_cliente = c.id_cliente
    inner join carro_oficina ca on cc.id_carro = ca.id_carro
GO
/****** Object:  Table [dbo].[pedido_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[pedido_oficina](
	[id_pedido] [int] IDENTITY(1,1) NOT NULL,
	[id_cliente] [int] NULL,
	[id_carro] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_pedido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_pedido_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vw_pedido_oficina]
as
    select id_pedido, co.nome,co.sobrenome, placa from pedido_oficina po
    inner join cliente_oficina co on po.id_cliente = co.id_cliente
    inner join carro_oficina car on po.id_carro = car.id_carro
GO
/****** Object:  Table [dbo].[venda_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[venda_oficina](
	[id_pedido] [int] NULL,
	[id_orcamento] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_venda_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create VIEW [dbo].[vw_venda_oficina]
AS
    select vo.id_pedido, vpo.placa,vo.id_orcamento from venda_oficina vo
    inner join vw_pedido_oficina vpo on vo.id_pedido = vpo.id_pedido
GO
/****** Object:  Table [dbo].[peca_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[peca_oficina](
	[id_peca] [int] IDENTITY(1,1) NOT NULL,
	[nome] [varchar](50) NULL,
	[valor_unidade] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_peca] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orcamento_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orcamento_oficina](
	[id_orcamento] [int] IDENTITY(1,1) NOT NULL,
	[id_carro] [int] NULL,
	[id_peca] [int] NULL,
	[quantidade] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_orcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_valor_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create view [dbo].[vw_valor_oficina] as 
	select vo.id_pedido, id_carro, sum((quantidade * valor_unidade)) valor_total from orcamento_oficina oo
	inner join peca_oficina po on oo.id_peca = po.id_peca
	inner join venda_oficina vo on vo.id_orcamento = oo.id_orcamento
	group by id_pedido, id_carro
GO
/****** Object:  View [dbo].[vw_valor_final_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_valor_final_oficina]
as
    select vwp.id_pedido, nome, sobrenome, placa, valor_total from vw_valor_oficina vwv
    inner join vw_pedido_oficina vwp on vwv.id_pedido = vwp.id_pedido
GO
/****** Object:  View [dbo].[vw_orcamento_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_orcamento_oficina]
as
    select id_orcamento, placa, nome, quantidade  from orcamento_oficina oo
    inner join carro_oficina co on oo.id_carro = co.id_carro
    inner join peca_oficina po on oo.id_peca = po.id_peca
GO
ALTER TABLE [dbo].[cliente_carro]  WITH CHECK ADD FOREIGN KEY([id_carro])
REFERENCES [dbo].[carro_oficina] ([id_carro])
GO
ALTER TABLE [dbo].[cliente_carro]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [dbo].[cliente_oficina] ([id_cliente])
GO
ALTER TABLE [dbo].[orcamento_oficina]  WITH CHECK ADD FOREIGN KEY([id_carro])
REFERENCES [dbo].[carro_oficina] ([id_carro])
GO
ALTER TABLE [dbo].[orcamento_oficina]  WITH CHECK ADD FOREIGN KEY([id_peca])
REFERENCES [dbo].[peca_oficina] ([id_peca])
GO
ALTER TABLE [dbo].[pedido_oficina]  WITH CHECK ADD FOREIGN KEY([id_carro])
REFERENCES [dbo].[carro_oficina] ([id_carro])
GO
ALTER TABLE [dbo].[pedido_oficina]  WITH CHECK ADD FOREIGN KEY([id_cliente])
REFERENCES [dbo].[cliente_oficina] ([id_cliente])
GO
ALTER TABLE [dbo].[venda_oficina]  WITH CHECK ADD FOREIGN KEY([id_orcamento])
REFERENCES [dbo].[orcamento_oficina] ([id_orcamento])
GO
ALTER TABLE [dbo].[venda_oficina]  WITH CHECK ADD FOREIGN KEY([id_pedido])
REFERENCES [dbo].[pedido_oficina] ([id_pedido])
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_carro_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[sp_cadastro_carro_oficina](
	@placa varchar(20),
	@modelo varchar(30),
	@marca varchar(30),
	@ano int)
	as
		insert into carro_oficina
			values(
				@placa,@modelo, @marca,@ano
			);
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_cliente_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[sp_cadastro_cliente_oficina](
		@nome varchar(20),
		@sobrenome varchar(30),
		@cep varchar(30))
	as
		insert into cliente_oficina
			values(
				@nome,@sobrenome, @cep
			);
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_orcamento_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--procedure orcamento
	create procedure [dbo].[sp_cadastro_orcamento_oficina](
		@idcarro int,
		@idpeca int,
		@quantidade int
	)as
		insert into orcamento_oficina
		values(
			@idcarro, @idpeca, @quantidade
		);
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_peca_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[sp_cadastro_peca_oficina](
		@nome varchar(50), 
		@valor decimal
	)as
	insert into peca_oficina
		values(
			@nome,@valor
		);
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_pedido_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[sp_cadastro_pedido_oficina](
		@idcliente int,
		@idcarro int
	)as
	insert into pedido_oficina 
		values(
			@idcliente,@idcarro
		);
GO
/****** Object:  StoredProcedure [dbo].[sp_cadastro_venda_oficina]    Script Date: 14/04/2022 13:05:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	create procedure [dbo].[sp_cadastro_venda_oficina](
		@idpedido int,
		@idorcamento int
	)as
	insert into pedido_oficina 
		values(
			@idpedido,@idorcamento
		);
GO
