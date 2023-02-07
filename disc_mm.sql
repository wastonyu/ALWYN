CREATE TABLE [dbo].[disc_mm](
 [id] [int] NOT NULL,
 [code] [nvarchar](50) NULL,
 [name] [nvarchar](100) NULL,
 [priority] [smallint] NULL,
 /*Date and time*/
 [begdate] [datetime] NOT NULL,
 [enddate] [datetime] NOT NULL,
 [begtime] [char](5) NULL,
 [endtime] [char](5) NULL,
 [day1] [bit] NULL,
 [day2] [bit] NULL,
 [day3] [bit] NULL,
 [day4] [bit] NULL,
 [day5] [bit] NULL,
 [day6] [bit] NULL,
 [day7] [bit] NULL,
 [holiday] [bit] NULL,
 [ex_holiday] [bit] NULL,
 [festival] [bit] NULL,
 [ex_festival] [bit] NULL,
 /*Method*/
 [mm_by] [int] NULL,	/*Method1,2,3...*/
 /*Method 1*/
 [m1_qty] [numeric](18, 5) NULL,
 [m1_less_unit_amt] [numeric](18, 5) NULL,
 [m1_net_total_amt] [numeric](18, 5) NULL,
 [m1_perc] [numeric](18, 5) NULL,
 [m1_less_unit_amt2] [numeric](18, 5) NULL,
 [m1_less_unit_amt3] [numeric](18, 5) NULL,
 [m1_less_unit_amt4] [numeric](18, 5) NULL,
 [m1_less_unit_amt5] [numeric](18, 5) NULL,
 [m1_net_total_amt2] [numeric](18, 5) NULL,
 [m1_net_total_amt3] [numeric](18, 5) NULL,
 [m1_net_total_amt4] [numeric](18, 5) NULL,
 [m1_net_total_amt5] [numeric](18, 5) NULL,
 [m1_same_item] [bit] NULL,
 /*Method 2*/
 [m2_qty] [numeric](18, 5) NULL,
 [m2_amt] [numeric](18, 5) NULL,
 [m2_less_amt] [numeric](18, 5) NULL,
 [m2_less_unit_amt] [numeric](18, 5) NULL,
 [m2_less_amt_cycle] [bit] NULL,
 [m2_less_perc] [numeric](18, 5) NULL,
 /*Method 3*/
 [m3_qty] [numeric](18, 5) NULL,
 [m3_qty1] [numeric](18, 5) NULL,
 [m3_add_1_amt] [numeric](18, 5) NULL,
 [m3_item_id] [int] NULL,
 
 /*others*/
 [updateno] [int] NULL,
 [suspend] [bit] NULL,
 [active] [bit] NULL,
 [create_by] [int] NULL,
 [create_date] [datetime] NULL,
 [edit_by] [int] NULL,
 [edit_date] [datetime] NULL,
 [void_by] [int] NULL,
 [void_date] [datetime] NULL,
 CONSTRAINT [pk_disc_mm] PRIMARY KEY NONCLUSTERED ([id] ASC) 
 ) 
 ON [PRIMARY]