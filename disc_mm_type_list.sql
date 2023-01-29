CREATE TABLE [dbo].[disc_mm_type_list](
	[disc_mm_id] [int] NOT NULL,
	[sub_id] [int] NOT NULL,
	[type_a] [varchar](100) NULL,
	[type_a_id] [int] NULL,
	[type_b] [varchar](100) NULL,
	[type_b_id] [int] NULL,
	[type_c] [varchar](100) NULL,
	[type_c_id] [int] NULL,
	[dispord] [int] NULL,
 CONSTRAINT [PK_disc_mm_type_list] PRIMARY KEY CLUSTERED ([disc_mm_id] ASC,[sub_id] ASC)
) 
ON [PRIMARY]
