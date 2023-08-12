CREATE TABLE [dbo].[main_cate](
	[active] [bit] NOT NULL,
	[id] [int] NOT NULL,
	[desccn] [nvarchar](50) NOT NULL,
	[descen] [nvarchar](50) NOT NULL,
	[dispord] [int] NOT NULL,
	[updateno] [int] NULL,
	[logo] [text] NULL,
 CONSTRAINT [PK_main_cate] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[main_mcate](
	[maincate_id] [int] NOT NULL,
	[cate_id] [int] NOT NULL,
	[dispord] [int] NOT NULL
) ON [PRIMARY]
GO


