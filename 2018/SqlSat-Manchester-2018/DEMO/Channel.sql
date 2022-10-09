USE [CRM]
GO

CREATE TABLE [dbo].[Channel](
	[ChannelId] [int] IDENTITY(1,1) NOT NULL,
	[Label] [nvarchar](100) NOT NULL,
	[Name] [nvarchar](20) NULL,
	[Description] [varchar](50) NULL,
 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED 
(
	[ChannelId] ASC
)
) ON [PRIMARY]
GO

--Populate data
SET IDENTITY_INSERT [dbo].[Channel] ON 
GO
INSERT [dbo].[Channel] ([ChannelId], [Label], [Name], [Description]) 
VALUES (1, N'01', N'Store', N'Store')
GO
INSERT [dbo].[Channel] ([ChannelId], [Label], [Name], [Description]) 
VALUES (2, N'02', N'Online', N'Online')
GO
INSERT [dbo].[Channel] ([ChannelId], [Label], [Name], [Description]) 
VALUES (3, N'03', N'Catalog', N'Catalog')
GO
INSERT [dbo].[Channel] ([ChannelId], [Label], [Name], [Description]) 
VALUES (4, N'04', N'Reseller', N'Reseller')
GO
SET IDENTITY_INSERT [dbo].[Channel] OFF
GO
