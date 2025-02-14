Use rms6_pic
Alter table cate_pic add uid uniqueidentifier null
Alter table item_pic add uid uniqueidentifier null
Alter table item_pic add code varchar(8) null
update item_pic set uid = newid() where uid is null 
update cate_pic set uid = newid() where uid is null 
go 
CREATE TABLE [dbo].[croppedimage](
	[uid] [uniqueidentifier] NULL,
	[id] [int] NULL,
	[code] [varchar](8) NULL,
	[pic_crop] [varchar](max) NULL,
	[pic_crop_loc] [varchar](50) NULL,
	[type] [int] NULL,
	[keywords] [nvarchar](300) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
go 


Use rms6
Alter table cate add pic_uid uniqueidentifier null 
Alter table item add pic_uid uniqueidentifier null 
Alter table item_backup add pic_uid uniqueidentifier null
go
Update item set pic_uid = (select uid from rms6_pic.dbo.item_pic where item_id = item.id) where pic_uid is null 
Update cate set pic_uid = (select uid from rms6_pic.dbo.cate_pic where cate_id = cate.id) where pic_uid is null 


Insert into rms6_pic.dbo.croppedimage(uid,id,code,pic_crop,pic_crop_loc,type,keywords)
Select b.uid,b.cate_id,a.id,b.pic_crop,b.pic_crop_loc,1,rtrim(a.desccn) + ';' + rtrim(a.descen) 
from cate a left join rms6_pic.dbo.cate_pic b on a.pic_uid = b.uid 
where a.pic_uid is not null

Insert into rms6_pic.dbo.croppedimage(uid,id,code,pic_crop,pic_crop_loc,type,keywords)
Select b.uid,b.cate_id,a.code,b.pic_crop,b.pic_crop_loc,2,rtrim(a.desccn) + ';' + rtrim(a.descen) 
from item a left join rms6_pic.dbo.item_pic b on a.pic_uid = b.uid 
where a.pic_uid is not null


