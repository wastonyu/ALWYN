CREATE TABLE [dbo].[disc_mm_type_list_h](
	[h_add_time] [datetime] NOT NULL,
	[h_add_user_id] [int] NOT NULL,
	[h_add_station_id] [int] NULL,
	[disc_mm_id] [int] NOT NULL,
	[sub_id] [int] NOT NULL,
	[type_a] [varchar](100) NULL,
	[type_a_id] [int] NULL,
	[type_b] [varchar](100) NULL,
	[type_b_id] [int] NULL,
	[type_c] [varchar](100) NULL,
	[type_c_id] [int] NULL,
	[dispord] [int] NULL,
)
ON [PRIMARY]
