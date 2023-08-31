FUNCTION build_index 

*** 2007-12-11 member 加 index
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[Member] ([id])")
=SQLEXEC(nhand, "CREATE INDEX [ix_cardno] ON [dbo].[Member] ([cardno])")
=SQLEXEC(nhand, "CREATE INDEX [ix_namecn] ON [dbo].[Member] ([name_cn])")
=SQLEXEC(nhand, "CREATE INDEX [ix_nameen] ON [dbo].[Member] ([name_en])")
=SQLEXEC(nhand, "CREATE INDEX [ix_tel] ON [dbo].[Member] ([tel])")
=SQLEXEC(nhand, "CREATE INDEX [ix_memberno] ON [dbo].[Inv] ([memberno])")

*** 2008-01-08
=SQLEXEC(nhand, "CREATE INDEX [ix_date] ON [dbo].[Oct_log] ([date])")

* 2008-04-09 加 index
=SQLEXEC(nhand, "CREATE INDEX [ix_pid] ON [dbo].[slip_print_main] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_pid] ON [dbo].[slip_print_detail] ([pid])")

* 2008-08-1
*加 index
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[inv_modi] ([id])")
=SQLEXEC(nhand, "CREATE INDEX [ix_modi_id] ON [dbo].[inv_modi] ([modi_id])")

* 2008-08-1
=SQLEXEC(nhand , "CREATE INDEX [ix_item_id] ON [dbo].[inv_detail] ([item_id])")

* 2008-10-16
* 於小菊發現有 pay_detail 的 payamt = 0, 引致清機時付款次數加大
* 於 清機 / 日結 時先 delete from pay_detail where payamt = 0 and netamt = 0 and pay_others = 0
=SQLEXEC(nhand, "CREATE INDEX [ix_amt] ON [dbo].[pay_detail] ([payamt], [netamt])")

* 2008-10-20
* [Microsoft][ODBC SQL Server Driver][SQL Server]交易 (處理序識別碼 54) 在 lock 資源上已經被另一個處理序鎖死並造成死結。請重新執行該交易。 連接錯誤。
=SQLEXEC(nhand, "CREATE INDEX [ix_updateno] ON [dbo].[inv] ([UpdateNo]) ON [PRIMARY]")
=SQLEXEC(nhand, "CREATE INDEX [ix_tableno] ON [dbo].[tables] ([tableno])")

*2008-11-04
*山田要於 dayend report show 改單價 record (sys_log.log_id = 95)
=SQLEXEC(nhand, "CREATE INDEX [ix_logid] ON [dbo].[sys_log] ([log_id])")

*2008-11-06
*mathy 經常有 error
*[Microsoft][ODBC SQL Server Driver][SQL Server]交易 (處理序識別碼 57) 在 lock 資源上已經被另一個處理序鎖死並造成死結。請重新執行該交易。 連接錯誤。
*SLIP_PRINT line 283
*加 index 試試

TEXT TO cmd noshow
	CREATE INDEX [ix_pid] ON [dbo].[slip_print_detail] ([pid])
	CREATE INDEX [ix_pid] ON [dbo].[slip_print_main] ([pid])
	CREATE INDEX [ix_tableno] ON [dbo].[slip_print_main] ([tableno])
ENDTEXT 
=SQLEXEC(nhand, cmd)

=SQLEXEC(nhand,"DROP INDEX [inv].[ix_inv_id]")			&&2009.01.19
=SQLEXEC(nhand,"alter table inv drop column inv_Id")

*2009-2-3
*v6.9.190 江南美廚 試過 INVINFO.GRID_INV.AFTERROWCOLCHANGE 時 timeout
=SQLEXEC( nhand , "CREATE INDEX [ix_item_id] ON [inv_detail] ([item_id]) ")
=SQLEXEC( nhand , "CREATE INDEX [ix_logid] ON [sys_log] ([log_id]) ")
=SQLEXEC( nhand , "CREATE INDEX [ix_date] ON [sys_log] ([datetime]) ")

*2009-3-10
*加快 delete inv_print_??? 
=SQLEXEC( nhand , "CREATE INDEX [ix_pid] ON [inv_print_detail] ([pid])")
=SQLEXEC( nhand , "CREATE INDEX [ix_pid] ON [inv_print_main] ([pid])")
=SQLEXEC( nhand , "CREATE INDEX [ix_pid] ON [inv_print_disc] ([pid])")
=SQLEXEC( nhand , "CREATE INDEX [ix_pid] ON [inv_print_void] ([pid])")


*2009-2-16
*江南有 deadlock 懷疑入 work_cashier 同 print_server 撞
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[printerset] ([id])")
=SQLEXEC(nhand, "CREATE INDEX [ix_printer] ON [dbo].[printerset] ([printer])")

=SQLEXEC(nhand, "CREATE INDEX [ix_pno] ON [dbo].[order_print_main] ([print_no])")		&&2009.03.16

*2009-3-21
*同時印單可能 deadlock
=sqlexec(nhand, 'CREATE INDEX [ix_id] ON [dbo].[inv_disc] ([id])')
=sqlexec(nhand, 'CREATE INDEX [ix_id] ON [dbo].[inv_itemdisc] ([id])')

=SQLEXEC(nhand, "CREATE UNIQUE INDEX [ix_id] ON [dbo].[message_log] ([id])")

* 2009-4-20
* la bons deadlock
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[pay_print_main] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[pay_print_detail] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[pay_print_disc] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[pay_print_job] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_inv_id] ON [dbo].[pay_print_job] ([inv_id])")

=SQLEXEC(nhand, "CREATE  INDEX [ix_updateno] ON [dbo].[itempic] ([UpdateNo])")


TEXT TO ssql noshow	&&2010.02.17
	CREATE NONCLUSTERED INDEX [lms_cardno] ON [dbo].[lms_Log] 
	(
		[card_no] ASC
	) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow	&&2010.02.17
	CREATE NONCLUSTERED INDEX [lms_datetime] ON [dbo].[lms_Log] 
	(
		[datetime] ASC
	) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow	&&2010.02.17
	CREATE NONCLUSTERED INDEX [lms_action] ON [dbo].[lms_Log] 
	(
		[action] ASC
	) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand, "CREATE INDEX [ix_sn] ON [dbo].[oct_log] ([sn])")		&&2010.04.15

=SQLEXEC(nhand, "CREATE INDEX [ix_cardno2] ON [dbo].[member] ([cardno2])")		&&2010.04.20


=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[disc_log] ([id])")
=SQLEXEC(nhand, "CREATE INDEX [ix_invno] ON [dbo].[disc_log] ([inv_no])")
=SQLEXEC(nhand, "CREATE INDEX [ix_dt] ON [dbo].[disc_log] ([datetime])")

=SQLEXEC(nhand, "CREATE INDEX [ix_tel] ON [dbo].[tel_order] ([tel])")
=SQLEXEC(nhand, "CREATE INDEX [ix_action] ON [dbo].[oct_log] ([action])")

=SQLEXEC(nhand, "CREATE INDEX [ix_pid] ON [dbo].[print_log] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_date] ON [dbo].[print_log] ([datetime])")

=SQLEXEC(nhand, "CREATE INDEX [ix_pid] ON [dbo].[print_log2] ([pid])")
=SQLEXEC(nhand, "CREATE INDEX [ix_date] ON [dbo].[print_log2] ([datetime])")


=SQLEXEC(nhand, "CREATE INDEX [ix_nsubtable] ON [dbo].[tables] ([nsubtable])")
=SQLEXEC(nhand, "CREATE INDEX [ix_finish] ON [dbo].[tables] ([have_unfinish])")

=SQLEXEC(nhand, "CREATE INDEX [ix_octid] ON [dbo].[inv] ([oct_invid])")

=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[inv_reprint] ([inv_id])")


TEXT TO ssql   noshow

	CREATE UNIQUE NONCLUSTERED INDEX [ix_id] ON [dbo].[inv] 
	(
		[id] ASC
	) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,ssql)

*-----------------------


TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_main] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [ix_begtime] ON [dbo].[android_order_main] 
(
	[begintime] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)



*--

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_detail] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)

*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_modi] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)

*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_disc] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)

*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_itemdisc] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)


*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_itemdept] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)


*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[android_order_tax] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)


*---

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_idx] ON [dbo].[exec_android_data] 
(
	[mark_id] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)


*--------------------
TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_addtime] ON [dbo].[exec_android_data] 
(
	[addtime] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)

*--------------------
TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [id_flag] ON [dbo].[exec_android_data] 
(
	[flag] ASC
)

ENDTEXT

=SQLEXEC(nhand,ssql)


* 2012-06-02

TEXT TO ssql noshow
	CREATE INDEX [ix_id] ON [dbo].[sys_log] ( [id] )
	CREATE INDEX [ix_date] ON [dbo].[sys_log] (	[datetime] )
	CREATE INDEX [ix_logid] ON [dbo].[sys_log] ( [log_id] )


ENDTEXT
=SQLEXEC(nhand, ssql)

=SQLEXEC(nhand,"CREATE INDEX [ix_datetime] ON [dbo].[edit_log] ([datetime])")

=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[item_move] ([id])")

=SQLEXEC(nhand, "CREATE INDEX [ix_id] ON [dbo].[less_cash] ([id])")

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [x_id] ON [dbo].[warn_log] 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
CREATE NONCLUSTERED INDEX [x_tableno] ON [dbo].[warn_log] 
(
	[tableno] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]


ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [x_time] ON [dbo].[warn_log] 
(
	[addtime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)


RETURN 

ENDFUNC



*********************************************
*
*
FUNCTION data_auto_update			&&數據自動更新,包括增加修改

LPARAMETERS lForceUpdate

IF VARTYPE(nhand_multi_db_tmp)="N"
	PRIVATE nhand
	nhand = nhand_multi_db_tmp
ENDIF 


*RETURN


*!*	=SQLEXEC(nhand, "truncate table print_log")
*!*	=SQLEXEC(nhand, "truncate table slip_print_main")
*!*	=SQLEXEC(nhand, "truncate table slip_print_detail")
*!*	=SQLEXEC(nhand, "truncate table pay_print_main")
*!*	=SQLEXEC(nhand, "truncate table pay_print_detail")
*!*	=SQLEXEC(nhand, "truncate table pay_print_disc")
*!*	=SQLEXEC(nhand, "truncate table inv_print_main")
*!*	=SQLEXEC(nhand, "truncate table inv_print_detail")
*!*	=SQLEXEC(nhand, "truncate table inv_print_disc")
*!*	=SQLEXEC(nhand, "truncate table payway_print_detail")



*!*	*** delete kitchen print log & print job
*!*	_date = DATETIME() - 3600 * 24
*!*	c=SQLEXEC(nhand, "delete from order_print_detail where pid in ( select pid from order_print_main where sendtime < ?_date)")
*!*	c=SQLEXEC(nhand, "delete from order_print_main where sendtime < ?_date")


*!*	ADIR(fs,"auto_update.fxp")

*!*	cTime =DTOC(fs(1,3))+" "+fs(1,4)

*!*	IF lForceUpdate=.f.

*!*		IF SQLEXEC(nhand,"select defavalue_char  from sys_options where type='autoupdate' ","cun_tmp")>0

*!*			
*!*			IF EOF("cun_tmp")
*!*			
*!*				=SQLEXEC(nhand," insert into sys_options(defavalue_char,type,desccn) values (?cTime,'autoupdate','')")
*!*				
*!*			ELSE
*!*			
*!*				IF  TRIM(cun_tmp.defavalue_char) >=cTime
*!*					
*!*						
*!*					build_index()
*!*					
*!*			
*!*					RETURN 
*!*					
*!*				ENDIF
*!*				
*!*			ENDIF
*!*			


*!*		ENDIF

*!*	ENDIF
*!*	*--------------------------------------------



LOCAL lcTime
ADIR(sstime,"auto_update.fxp")
lcTime = DTOC(sstime(1,3)) + " " + sstime(1,4)

frm_wait.showmessage("data auto update ...")
frm_wait.show


***
***總步數
_total_step = 104

&&創建proan_ctrl表
TEXT TO dbsql NOSHOW TEXTMERGE
	IF NOT exists(select 1 from sysobjects where id = object_id(N'proan_ctrl') AND type = 'U' )
		CREATE TABLE [dbo].[proan_ctrl](
			[code] [nvarchar](100) NULL,
			[value] [nvarchar](100) NULL,
			[update_date] [datetime] NULL
		) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand, dbsql)

=SQLEXEC(nhand, "select * from proan_ctrl where code = 'data_auto_update_verno'", "cr_tmp1")
IF lForceUpdate = .F.
	IF RECCOUNT("cr_tmp1") > 0
		IF ALLTRIM(cr_tmp1.VALUE) >= lcTime
			TRY
				build_index()
				show_wait()
			CATCH
			FINALLY
			ENDTRY
			WAIT CLEAR
			RETURN
		ENDIF
	ENDIF
ENDIF

=SQLEXEC(nhand, "select * from proan_ctrl where code = 'data_auto_update_step'", "cr_tmp1")
_last_run_step = 0
IF RECCOUNT("cr_tmp1") > 0
	_last_run_step = VAL(ALLTRIM(cr_tmp1.VALUE))
ENDIF

IF USED("cr_tmp1")
	USE IN "cr_tmp1"
ENDIF




IF _last_run_step = 0   &&Runing only first time  By Waston 20/07/2022

IF SQLEXEC(nhand,"alter table system_setting add password [bit] Null")>0		&&07/06/2007	system_setting 增加password (是否密碼方式)
	SQLEXEC(nhand,"update system_setting set password=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table order_disc add disc_reason INT NULL")>0			&&08/06/2007	order_disc 加入折扣原因
	SQLEXEC(nhand,"update order_disc set disc_reason=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table order_itemdisc add disc_reason INT NULL")>0			&&08/06/2007	order_itemdisc加入折扣原因
	SQLEXEC(nhand,"update order_itemdisc set disc_reason=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))
  

IF SQLEXEC(nhand,"alter table inv_disc add disc_reason INT NULL")>0			&&08/06/2007	inv_disc 加入折扣原因

	SQLEXEC(nhand,"update inv_disc set disc_reason=0")

ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table inv_itemdisc add disc_reason INT NULL")>0			&&08/06/2007	inv_itemdisc 加入折扣原因

	SQLEXEC(nhand,"update inv_itemdisc set disc_reason=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


SQLEXEC(nhand,"alter table order_print_main add move bit null,move_from char(10) null,move_to char(10) null")		&&08/06/2007 order_print_main 加入轉檯


SQLEXEC(nhand,"alter table station add pserver_active [datetime] NULL")			&&11/06/2007	station  加入print_server 在線時間


IF SQLEXEC(nhand,"alter table tables add inv_lock [bit] null")>0						&&14/06/2007	tables 	加入是否禁止印單(發票)

	SQLEXEC(nhand,"update tables set inv_lock=0")
	
ENDIF
*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



SQLEXEC(nhand,"alter table payway add lock [bit] null")						&&22/06/2007	payway加入lock


SQLEXEC(nhand,"update payway set lock=1 where descen='Cash'")					&&設定現金為預設方式，不可刪除



IF SQLEXEC(nhand,"alter table order_disc add disc_level varchar(100) null")>0		&&22/06/2007 order_disc 加入disc_level
	SQLEXEC(nhand,"update order_disc set disc_Level=''")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


SQLEXEC(nhand,"alter table order_print_main ALTER COLUMN void_reason int null")		&&26/06/2007 order_print_main void_reason

*!*	IF SQLEXEC(nhand,"alter table pay_print_job add void bit null")>0
*!*		SQLEXEC(nhand,"update pay_print_job set void=0")

*!*	ENDIF


SQLEXEC(nhand,"alter table order_print_main ALTER COLUMN tableno char(30) null")		&&05/07/2007 order_print_main tableno


												&&11/07/2007   item 加入計時


*chris

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

TEXT TO cmd noshow
	ALTER table item ADD timer_active bit null, 
		timer_style int null,
		free_hours int null, 
		free_style int null, 
		timer_begtime char(5) null,
		timer_endtime char(5) null,
		timer_mincharge int null,
		timer_disc bit null	
ENDTEXT 

*!*		ALTER table item ADD timer_active bit null, 
*!*		
*!*		ALTER table item ADD 
*!*		[timer_active] [bit] NULL,
*!*		[timer_style] [int] NULL,
*!*		[free_hours] [int] NULL,
*!*		[free_style] [int] NULL,
*!*		[timer_begtime] [char](5)  NULL,
*!*		[timer_endtime] [char](5)   NULL,
*!*		[timer_mincharge] [int]  NULL,
*!*		[timer_disc] [bit] NULL


IF SQLEXEC(nhand, cmd ) > 0
	
	SQLEXEC(nhand,"update item set timer_active=0,timer_style=0,free_hours=0,free_style=0,timer_begtime='',timer_endtime='',timer_mincharge=0,timer_disc=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table item add timer_mincharge int null")>0
	SQLEXEC(nhand,"update item set timer_mincharge=0")
ENDIF



												&&13/07/2007   order_detail 加入計時
TEXT TO csql noshow
	ALTER table order_detail ADD 
	[timer_active] [bit] NULL,
	[timer_style] [int] NULL,
	[free_hours] [int] NULL,
	[free_style] [int] NULL,
	[timer_begtime] [char](5)  NULL,
	[timer_endtime] [char](5)   NULL,
	[timer_mincharge] [int]  NULL,
	[timer_disc] [bit] NULL

ENDTEXT

IF SQLEXEC(nhand,csql)>0
	
	SQLEXEC(nhand,"update order_detail set timer_active=0,timer_style=0,free_hours=0,free_style=0,timer_begtime='',timer_endtime='',timer_mincharge=0,timer_disc=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



IF SQLEXEC(nhand,"alter table order_detail add timer_mincharge int null")>0
	SQLEXEC(nhand,"update order_detail set timer_mincharge=0")
ENDIF



IF SQLEXEC(nhand,"alter table member add update_time datetime null")>0		&&18/07/2007 member加入update_time

	SQLEXEC(nhand,"update member set update_time=id")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



IF SQLEXEC(nhand,"alter table order_print_detail add item_id int null")>0		&&23/07/2007 order_print_detail 加入item_id
	
	SQLEXEC(nhand,"update order_print_detail set item_id=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



IF SQLEXEC(nhand,"alter table print_log add tableno char(10) null,item_id int null,item char(50) null,printer char(20) null")>0

	SQLEXEC(nhand,"update print_log set tableno='',item_id=0,item='',printer=''")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table cate add startdate datetime null,enddate datetime null")>0

	SQLEXEC(nhand,"update cate set startdate = '2000-01-01',enddate='2099-01-01' where startdate is null")

ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table inv add endtime datetime null")>0		&&7/08/2007   INV加入endtime
	SQLEXEC(nhand,"update inv set endtime='2000-01-01'")
ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow					&&8/08/2007  新增 inv_reprint_main

	CREATE TABLE [dbo].[inv_reprint_main](					
		[pid] [char](16)  NULL,
		[inv_id] [int] NULL,
		[tableno] [char](8)  NULL,
		[pplcnt] [int] NULL,
		[sendtime] [datetime] NULL,
		[username] [nchar](20)  NULL,
		[station_id] [int] NULL,
		[langue] [char](4)  NULL,
		[training] [bit] NULL,
		[fastfood] [bit] NULL,
		[reprint] [bit] NULL,
		[tel] [nchar](20)  NULL,
		[address] [nchar](50)  NULL,
		[amount] [numeric](12, 2) NULL,
		[discamt] [numeric](12, 2) NULL,
		[itemdiscamt] [numeric](12, 2) NULL,
		[srvamt] [numeric](12, 2) NULL,
		[taxamt] [numeric](12, 2) NULL,
		[rndamt] [numeric](12, 2) NULL,
		[invamt] [numeric](12, 2) NULL,
		[begintime] [datetime] NULL,
		[paidtime] [datetime] NULL,
		[member_name] [nchar](100)  NULL,
		[member_no] [nchar](100)  NULL,
		[void] [bit] NULL
	) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow
	CREATE TABLE [dbo].[inv_reprint_detail](
		[pid] [char](20)  NULL,
		[item] [nchar](100)  NULL,
		[qty] [nchar](15)  NULL,
		[amt] [numeric](12, 2) NULL,
		[free] [bit] NULL
	) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow

	CREATE TABLE [dbo].[inv_reprint_disc](
		[pid] [char](20)  NULL,
		[descdisp] [nchar](100)  NULL,
		[amt] [numeric](12, 2) NULL
	) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



SQLEXEC(nhand,"alter table slip_print_main add member_name nchar(100) null,member_no char(100) null") &&上菜紙加入會員編號及會員名稱  10/08/2007


SQLEXEC(nhand,"alter table inv_print_main ALTER COLUMN tableno char(30) null")		&&INV_PRINT_MAIN  更改tableno 為char(30) 14/08/2007



SQLEXEC(nhand,"alter table slip_print_main ALTER COLUMN tableno char(30) null")		&&SLIP_PRINT_MAIN  更改tableno 為char(30) 14/08/2007



LOCAL _move_table_cn,_move_table_en

_move_table_cn=getmessage("_table_swap","CN")		&&加入"轉檯"取消原因
_move_table_en=getmessage("_table_swap","EN")


TEXT TO csql noshow	
	IF NOT exists (select id from void_reason where id=0)
	insert into void_reason (active,id,desccn,descen,dispord)
	values(0,0,_move_table_cn,_move_table_en,0)

ENDTEXT
=SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


=SQLEXEC(nhand, "update order_function set barcode = 1 where pcode= '_save_only'")	&& 2007-08-24 補單於 barcode mode 也生效


=SQLEXEC(nhand, "if not exists (select * from tax where id = 0) insert into tax values (0,0,'No Tax','No Tax',0)")  && 2007-08-24 快速新增項目時需要 tax 表有記錄


IF SQLEXEC(nhand,"alter table order_main add used_station char(20) null")>0			&&2007-08-27  order_main 加入used_station

	SQLEXEC(nhand,"update order_main set used_station=''")
	
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



TEXT TO csql noshow					&&28/08/2007  新增 order_barcode_temp

CREATE TABLE [dbo].[order_barcode_temp](					
	[barcode] [char](20)  NULL
	)

ENDTEXT

=SQLEXEC(nhand,csql)



*----------------------
=SQLEXEC(nhand,"ALTER TABLE pay_print_main ALTER COLUMN tableno char(30) null") 		&&6/09/2007 更改pay_reprint_main的tableno



=SQLEXEC(nhand,"ALTER TABLE print_log ALTER COLUMN tableno char(30) null") 		&&6/09/2007 更改print_log的tableno



=SQLEXEC(nhand,"ALTER TABLE inv_reprint_main ALTER COLUMN tableno char(30) null") 		&&6/09/2007 更改inv_reprint_main的tableno



=SQLEXEC(nhand,"ALTER TABLE slip_print_detail ALTER COLUMN qty numeric(12, 2) null") 	&&10/09/2007 更改slip_reprint_detail的 qty


=SQLEXEC(nhand,"ALTER TABLE order_print_detail ALTER COLUMN qty numeric(12, 2) null") 	&&10/09/2007 更改order_reprint_detail的 qty



IF SQLEXEC(nhand,"alter table sys_user add enter_mode char(10) null")>0					&&15/09/2007 sys_user 新增自動進入的點菜模式
	
	SQLEXEC(nhand,"update sys_user set enter_mode='dine' where autologin=1")
	SQLEXEC(nhand,"update sys_user set enter_mode='' where autologin=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


SQLEXEC(nhand,"alter table slip_print_main add tel nchar(20) null,address nchar(50) null")


SQLEXEC(nhand,"alter table order_main add outlet_id int null")


TEXT TO csql noshow
	CREATE TABLE [dbo].[print_log](
		[id] [int] IDENTITY(1,1) NOT NULL,
		[pid] [char](20) NULL,
		[station] [varchar](20)  NULL,
		[datetime] [datetime] NULL,
		[action] [varchar](100)  NULL
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow
	CREATE TABLE [dbo].[print_tmp](
		[pid] [char](20) NULL,
		[datetime] [datetime] NULL,
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


	
TEXT TO csql noshow
	CREATE TABLE [dbo].[inv_print_detail](
		[pid]  [char](20)  NULL,
		[item] [char](100) NULL,
		[qty]  [char](15)  NULL,
		[amt]  [numeric](12,2) Null,
		[free] [bit] 	   NULL
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)



TEXT TO csql noshow
	CREATE TABLE [dbo].[pay_print_detail](
		[pid]  [char](20)  NULL,
		[item] [char](100) NULL,
		[qty]  [char](15)  NULL,
		[amt]  [numeric](12,2) Null,
		[free] [bit] 	   NULL
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)



TEXT TO csql noshow
	CREATE TABLE [dbo].[inv_print_disc](
		[pid]  [char](20)  NULL,
		[descdisp] [char](100) NULL,
		[amt]  [numeric](12,2) Null
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)


SQLEXEC(nhand, "ALTER table print_log ADD finish bit null")


TEXT TO csql noshow
	CREATE TABLE [dbo].[print_finish](
		[pid] [char](20) NULL,
		[datetime] [datetime] NULL,
	) ON [PRIMARY]

ENDTEXT
SQLEXEC(nhand,csql)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*---------------------------------------------------------------------------------------------->>>>>
SQLEXEC(nhand,"alter table print_finish add printer char(30) null")
	
SQLEXEC(nhand,"update order_modi set modi_per=0 where modi_per is null")		&& 08/10/2007  


IF SQLEXEC(nhand,"alter table item add Desc_other varchar(254) null")>0		&&16/10/2007		&&item增加其它語言

	SQLEXEC(nhand,"update item set desc_other=''")

ENDIF
=SQLEXEC(nhand,"ALTER TABLE item  ALTER COLUMN Desc_other varchar(254) null") 		


IF SQLEXEC(nhand,"alter table printerset add other_langue bit null")>0

	SQLEXEC(nhand,"update printerset set other_langue=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table modifier add desc_other varchar(254) null")>0		&&18/10/2007  modifier 加入其它語言
	
	SQLEXEC(nhand,"update modifier set desc_other=''")

ENDIF
=SQLEXEC(nhand,"ALTER TABLE modifier ALTER COLUMN Desc_other varchar(254) null") 		&&fix


SQLEXEC(nhand,"alter table  modifier drop column descpole")		&&18/10/2007 modifier drop column descpole

SQLEXEC(nhand,"alter table order_print_detail add item_unicode varchar(254) null")		&&18/10/2007 order_print_detail
=SQLEXEC(nhand,"ALTER TABLE order_print_detail ALTER COLUMN item_unicode varchar(254) null") 		&&fix 


SQLEXEC(nhand,"alter table inv_print_detail add item_unicode varchar(254) null")	&&20/10/2007 inv_print_detail
=SQLEXEC(nhand,"ALTER TABLE inv_print_detail ALTER COLUMN item_unicode varchar(254) null") 		&&fix


SQLEXEC(nhand,"alter table inv_reprint_detail add item_unicode varchar(254) null")		&&20/10/2007 inv_reprint_detail
=SQLEXEC(nhand,"ALTER TABLE inv_reprint_detail ALTER COLUMN item_unicode varchar(254) null") 		&&fix 


IF SQLEXEC(nhand,"alter table tables add link_table varchar(100) null")>0		&&24/10/2007 tables  link_table 
	
	SQLEXEC(nhand,"update tables set link_table=''")

ENDIF

IF SQLEXEC(nhand,"alter table inv add link_table varchar(100) null")>0			&&25/10/2007 inv  link_table
	
	SQLEXEC(nhand,"update inv set link_table=''")

ENDIF

IF SQLEXEC(nhand,"alter table inv_print_main add link_table varchar(100) null")>0			&&25/10/2007 inv_print_main  link_table
	
	SQLEXEC(nhand,"update inv_print_main set link_table=''")

ENDIF

IF SQLEXEC(nhand,"alter table inv_reprint_main add link_table varchar(100) null")>0			&&25/10/2007 inv_reprint_main  link_table
	
	SQLEXEC(nhand,"update inv_reprint_main set link_table=''")

ENDIF

IF SQLEXEC(nhand,"alter table order_void add void_id int null")>0				&&27/10/2007   order_void   void_id
	SQLEXEC(nhand,"update order_void set void_id=0")	

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table order_main add void_id int null")>0				&&27/10/2007   order_main   void_id
	SQLEXEC(nhand,"update order_main set void_id=0")	

ENDIF

SQLEXEC(nhand,"alter table inv add void_id int null")						&&27/10/2007	inv         void_id

TEXT TO ssql noshow															&&27/10/2007 inv_Print_void

	CREATE TABLE [dbo].[inv_print_void](
		[pid] [char](20)  NULL,
		[descdisp] [nvarchar](100)  NULL,
		[qty] [numeric](6,2) NULL,
		[amt] [numeric](12, 2) NULL
	) ON [PRIMARY]

ENDTEXT

SQLEXEC(nhand,ssql)

TEXT TO ssql noshow															&&27/10/2007 inv_rePrint_void

	CREATE TABLE [dbo].[inv_reprint_void](
		[pid] [char](20)  NULL,
		[descdisp] [nvarchar](100)  NULL,
		[qty] [numeric](6,2) NULL,
		[amt] [numeric](12, 2) NULL
	) ON [PRIMARY]

ENDTEXT

SQLEXEC(nhand,ssql)

IF SQLEXEC(nhand,"alter table order_detail add printer varchar(50) null")>0				&&30/10/2007   order_detail   printer
	SQLEXEC(nhand,"update order_detail set printer='' ")	

ENDIF

IF SQLEXEC(nhand,"alter table sys_user add level_list varchar(200) null")>0				&&1/11/2007   sys_user   level_list
	SQLEXEC(nhand,"update sys_user set level_list='ALL' ")	

ENDIF

IF SQLEXEC(nhand,"alter table item add  warning_qty [numeric](8,2) null")>0				&&1/11/2007   sitem   warning_qty

	SQLEXEC(nhand,"update item set warning_qty=0 ")	

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow					&& 3/11/2007		table_booking

CREATE TABLE [dbo].[table_booking](
	[id] [int] NOT NULL,
	[tableno] [nchar](10)  NULL,
	[member_Id] [varchar](100)  NULL,
	[name] [nchar](20)  NULL,
	[sex] [char](2)  NULL,
	[tel] [varchar](20)  NULL,
	[pplcnt] [int] NULL,
	[book_time] [datetime] NULL,
	[add_user] [nvarchar](20)  NULL,
	[add_time] [datetime] NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

IF SQLEXEC(nhand,"alter table tables add  booking_list  varchar(100) null")>0				&&6/11/2007   tables  booking_list

	SQLEXEC(nhand,"update tables set booking_list ='' ")	

ENDIF

IF SQLEXEC(nhand,"alter table table_booking add used bit null, void bit null")>0				&&7/11/2007   table_booking  void

	SQLEXEC(nhand,"update table_booking set used=0,void=0 ")	

ENDIF

IF SQLEXEC(nhand,"alter table table_booking add id int null")>0				&&8/11/2007   table_booking  id

	SQLEXEC(nhand,"update table_booking set Id=0")	

ENDIF

IF SQLEXEC(nhand,"alter table table_booking add m_id int null")>0				&&8/11/2007   table_booking  m_id

	SQLEXEC(nhand,"update table_booking set m_Id=0")	

ENDIF

SQLEXEC(nhand,"update tables set link_table='' where link_table is null")
SQLEXEC(nhand,"update tables set booking_list='' where booking_list is null")


SQLEXEC(nhand,"alter table order_print_detail ALTER COLUMN item varchar(100) null")		&&19/11/2007 order_print_main  item -->100 

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow																			&&20/11/2007	sys_options 增加 barcode_askno 用於條碼模式 快餐方式

	if not exists (select type from sys_options where type='barcode_askno')
	insert into sys_options (defavalue,type,active,disporder) values (999,'barcode_askno',1,0)

ENDTEXT

SQLEXEC(nhand,csql)


IF SQLEXEC(nhand,"alter table sys_options add update_date datetime null")>0				&&21/11/2007   sys_otpions    增加
	
	SQLEXEC(nhand,"update sys_options set update_date=getdate() ")

ENDIF


IF SQLEXEC(nhand,"alter table tel_order add remark char(20) null")>0				&&21/11/2007   tel_order 增加 remark
	
	SQLEXEC(nhand,"update tel_order  set remark ='' ")

ENDIF

SQLEXEC(nhand,"alter table tel_order ALTER COLUMN address nvarchar(50) null")		&&21/11/2007 tel_order  address 100-->50

SQLEXEC(nhand,"alter table order_main ALTER COLUMN address nvarchar(100) null")		&&21/11/2007 order_main  address 100-->50


SQLEXEC(nhand,"alter table print_log ALTER COLUMN item  nvarchar(100) null")		&&23/11/2007 print_log  item 50-->100


IF SQLEXEC(nhand,"alter table slip_Print_main add discamt numeric(12,2) null")>0	&&27/11/2007   slip_Print_main  增加 disc_amount
	
	SQLEXEC(nhand,"update slip_Print_main  set discamt =0 ")

ENDIF

 SQLEXEC(nhand,"alter table payway drop column changes ")	&&29/11/2007   payway  刪除 changes  是否可找回
	

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table pay_detail add rate numeric(8,2) null")>0				&&24/11/2007   pay_detail 增加 rate
	
	SQLEXEC(nhand,"update pay_detail set rate=1")
	
ENDIF


IF SQLEXEC(nhand,"alter table pay_detail add changes_id int null")>0				&&1/12/2007   pay_detail 增加 changes_id
	
	SQLEXEC(nhand,"update pay_detail set changes_id=0 where changes=0")						
	SQLEXEC(nhand,"update pay_detail set changes_id=pay_id where changes>0")				&&將產生找贖的changes_id 替換為pay_id
	
ENDIF

IF SQLEXEC(nhand,"alter table payway add mark nchar(10) null")>0				&&1/12/2007   payway 增加 mark  貨幣符號
	
	SQLEXEC(nhand,"update payway set mark='$' ")
	
ENDIF

IF SQLEXEC(nhand,"alter table payway_Print_detail add pay_other numeric(12,2),changes_mark  nchar(10) null")>0				&&1/12/2007   payway_print_detail 增加 pay_other 其它付款方式金額,changes_mark  找回貨幣
	
	SQLEXEC(nhand,"update payway_print_detail set pay_other=0,changes_mark  ='' ")						
	
ENDIF

IF SQLEXEC(nhand,"alter table pay_detail add pay_others numeric(12,2) null")>0				&&4/12/2007   pay_detail 增加 pay_others 其它付款方式金額
	
	SQLEXEC(nhand,"update pay_detail set pay_others=0 ")						
	
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO csql noshow																			&&8/12/2007  增加vendor --- 供應商
	CREATE TABLE [dbo].[vendor](
	[active] [bit] NOT null,
	[id]  [int] NOT NULL,
	[name] [nchar](50)  NULL,
	[tel]  [nchar](50)  NULL,
	[addr1] [nchar](50) null,
	[addr2] [nchar](50) null,
	[addr3] [nchar](50) null,
	[rem] [text] null

	)

ENDTEXT

SQLEXEC(nhand,csql)																		

*2008-04-10 vendor 加聯絡人

IF SQLEXEC(nhand, "alter table vendor add attn nvarchar (50)") > 0
	=SQLEXEC(nhand, "update vendor set attn = '' where attn is null")
ENDIF 	


=SQLEXEC(nhand, "alter table member add times int null")

*** 

=SQLEXEC(nhand,"alter table slip_print_main add pplcnt int null")			&&12/12/2007  slip_print_Main 上菜紙增加人數

IF SQLEXEC(nhand,"alter table outlet add mincharge bit null")>0				&&12/12/2007  outlet 增加最低消費
	
	SQLEXEC(nhand,"update outlet set mincharge=0")

ENDIF

TEXT TO csql noshow																			&&14/12/2007  增加oct_log --- 八達通log
	CREATE TABLE [dbo].[oct_log](
	[cocode] [char](10) NOT null,
	[station] [char](20) null,
	[adduser]  [varchar](20) null,
	[date] [datetime] null,
	[action] [varchar](50) null,
	[card_no] [char](20) null,
	[remain] [numeric](10,2) null,
	[error_no] [char](10) null,
	[ret_code] [char](20) null,
	[amount] [numeric](10,2) null,
	[device_id] [char](10) null,
	[sn] [int] null
	
	)

ENDTEXT

SQLEXEC(nhand,csql)																		



LOCAL _desccn
_desccn=getmessage("_octopus","cn")														&& 17/12/2007 	payway 增加八達通付款方式  id=-1
ssql="if not exists (select id from payway where id=-1 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-1,?_desccn,'Octopus',1,1,0,0,0,'1990-1-1','2099-1-1',0,2,0,1,'',0,'',0)"

SQLEXEC(nhand,ssql)

SQLEXEC(nhand,"alter table pay_print_main add oct_device_id char(10) null,oct_card_id char(10) null,oct_remain numeric (10,2) null")		&&18/12/2007  pay_print_main 增加八達通ID,余額

SQLEXEC(nhand,"alter table pay_detail add oct_device_id char(10) null,oct_card_id char(10) null,oct_remain numeric (10,2) null")			&&18/12/2007  pay_detail 增加八達通ID,余額

SQLEXEC(nhand,"alter table inv add octopus bit null")					&&19/12/2007  inv 增加八達通標記




=SQLEXEC(nhand,"drop table oct_upload")
=SQLEXEC(nhand,"drop table oct_download")


IF SQLEXEC(nhand,"alter table vendor add email nchar(50)  null")>0					&&8/1/2008 供應商增加email

	SQLEXEC(nhand,"update vendor set email='' ")
ENDIF


TEXT TO ssql noshow				&& 8/1/2008										原材料種類 material_main
	
	CREATE TABLE [dbo].[material_main](
	[active] [bit] not null,
	[id] 	 [int] not null,
	[desccn] [nvarchar](30) not null,
	[descen] [nvarchar](30) not null,
	[dispord] [int] not null
	)

ENDTEXT

SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow				&& 8/1/2008										原材料 material
	
	CREATE TABLE [dbo].[material](
	[active] [bit] not null,
	[id] 	 [int] not null,
	[m_cate] [int]  not null,
	[desccn] [nvarchar](50) not null,
	[descen] [nvarchar](50) not null,
	[qty]    [numeric] (10,4) not null,
	[unit_id]   [int]  not null,
	[cost]   [numeric] (12,2) not null
	)

ENDTEXT

SQLEXEC(nhand,ssql)

TEXT TO ssql noshow				&& 8/1/2008										原材料單位 m_unit
	
	CREATE TABLE [dbo].[m_unit](
	[active] [bit] not null,
	[id] 	 [int] not null,
	[unit_desc]  [nvarchar](20) not null,
	[unit1_name] [nvarchar](20) not null,
	[unit2_name] [nvarchar](20) not null,
	[unit3_name] [nvarchar](20) not null,
	[u1_u2]  [numeric] (12,4)  null,
	[u2_u3]  [numeric] (12,4)  null
	)

ENDTEXT

SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table tel_order add phase  nchar(10)  null,tower nchar(10) null")>0	&& 11/1/2008  地址增加 "期","座"
	
	SQLEXEC(nhand,"update tel_order set phase='',tower='' ")

ENDIF


TEXT TO ssql noshow				&& 17/1/2008										菜式原材料 item_material
	
	CREATE TABLE [dbo].[item_material](
	[item_id] 	 [int] not null,
	[material_id] [int] not null,
	[unit_id]  [int] not null,
	[qty1]  [numeric] (10,4) not null,
	[qty2]  [numeric] (10,4) not null,
	[qty3]  [numeric] (10,4) not null,
	[u1_u2] [numeric] (10,4) not null,
	[u2_u3] [numeric] (10,4) not null,
	[qty]    [numeric] (10,4) not null

	)

ENDTEXT

SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table item add  use_material bit  null")>0	&& 28/1/2008  菜式增加 "是否使用成份"
	
	SQLEXEC(nhand,"update item  set use_material =0")

ENDIF

SQLEXEC(nhand,"alter table expense add belongdate datetime null,cln_id int null")		&&30/1/2008 支出增加belongdate,cln_id

SQLEXEC(nhand,"alter table expense add station_id int null")							&&30/1/2008 支出增加station_id

IF SQLEXEC(nhand,"alter table order_barcode_temp add tableno char(10) null")>0			&&30/12008  
	
	SQLEXEC(nhand,"update order_barcode_temp set tableno='' ")

ENDIF

IF SQLEXEC(nhand,"alter table order_barcode_temp add used_station char(20) null")>0			&&31/12008  
	
	SQLEXEC(nhand,"update order_barcode_temp set used_station ='' ")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


LOCAL _cancel_cn,_cancel_en

_cancel_cn=getmessage("_cancel","CN")		&&加入"取消"取消原因
_cancel_en=getmessage("_cancel","EN")

TEXT TO csql noshow	
	IF NOT exists (select id from void_reason where id=-1)
	insert into void_reason (active,id,desccn,descen,dispord)
	values(0,-1,?_cancel_cn,?_cancel_en,-1)

ENDTEXT
=SQLEXEC(nhand,csql)


TEXT TO csql noshow									&&12/2/2008   加入 材料進倉  main
	CREATE TABLE [dbo].[material_in_main](
		id int,
		vendor_id int,
		date datetime,
		rem text,
		adduser nchar(20) 		
	)

ENDTEXT
=SQLEXEC(nhand,csql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

TEXT TO csql noshow									&&12/2/2008   加入 材料進倉  detail
	CREATE TABLE [dbo].[material_in_detail](
		id int,
		material_id int,
		unit_id int,
		QTY1 NUMERIC(12,4),
		QTY2 NUMERIC(12,4),
		QTY3 NUMERIC(12,4),
		amount numeric(12,2)
	)

ENDTEXT
=SQLEXEC(nhand,csql)

TEXT TO csql noshow									&&12/2/2008   加入 材料出倉 
	CREATE TABLE [dbo].[material_out](
		id int,
		date datetime,
		item_id int,
		material_id int,
		unit_id int,
		QTY1 NUMERIC(12,4),
		QTY2 NUMERIC(12,4),
		QTY3 NUMERIC(12,4),
		adduser nchar(20)
	)

ENDTEXT
=SQLEXEC(nhand,csql)

*!*	IF SQLEXEC(nhand,"alter table order_void add order_id int null")>0		&&14 /2/2008  order_void 加入order_id
*!*		SQLEXEC(nhand,"update order_void set order_id=0")
*!*		
*!*	ENDIF

SQLEXEC(nhand,"alter table order_void drop column order_id")				&&27/10/2007   order_void drop  void_id


SQLEXEC(nhand,"alter table inv_print_detail add printtime varchar(20) null,adduser varchar(20)")	&&18/03/2008 inv_print_detail

SQLEXEC(nhand,"alter table inv_reprint_detail add printtime varchar(20) null,adduser varchar(20)")		&&18/03/2008  inv_reprint_detail

SQLEXEC(nhand,"alter table pay_print_detail add printtime varchar(20) null,adduser varchar(20)")		&&18/03/2008  inv_reprint_detail


IF SQLEXEC(nhand,"alter table member add company nvarchar(50) null,payway_id int null")>0				&&18/03/2008  membeer 增加公司名稱及付款方式

	SQLEXEC(nhand,"update disc set company='', payway_id=(select id from payway where id>0 and lock=1)")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table disc add askqty bit null")>0				&&1/04/2008  disc 折扣增加是否問數量

	SQLEXEC(nhand,"update disc set askqty=0")

ENDIF

IF SQLEXEC(nhand,"alter table order_disc add disc_qty int null")>0				&&1/04/2008  order_disc 增加折扣數量

	SQLEXEC(nhand,"update order_disc set disc_qty=1")

ENDIF

IF SQLEXEC(nhand,"alter table order_itemdisc add disc_qty int null")>0				&&1/04/2008  order_itemdisc 增加折扣數量

	SQLEXEC(nhand,"update order_itemdisc set disc_qty=1")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

IF SQLEXEC(nhand,"alter table inv_disc add disc_qty int null")>0				&&1/04/2008  inv_disc 增加折扣數量

	SQLEXEC(nhand,"update inv_disc set disc_qty=1")

ENDIF

IF SQLEXEC(nhand,"alter table inv_itemdisc add disc_qty int null")>0				&&1/04/2008  inv_disc 增加折扣數量

	SQLEXEC(nhand,"update inv_itemdisc set disc_qty=1")
ENDIF


IF SQLEXEC(nhand,"alter table material_in_main add inv_id int null")>0				&&5/04/2008  material_in_main 增加inv_Id

	SQLEXEC(nhand,"update material_in_main  set inv_Id=0")

ENDIF
*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table order_detail add  material bit null")>0				&&5/04/2008  order_detail 增加material		(是否應用成份)

	SQLEXEC(nhand,"update order_detail  set material=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table inv_detail add material bit null")>0				&&5/04/2008  inv_detail 增加 material		(是否應用成份)

	SQLEXEC(nhand,"update inv_detail  set material=0")

ENDIF

IF SQLEXEC(nhand,"alter table material_in_main add  in_id varchar(20) null")>0				&&7/04/2008  material_in_main 增加  inv_Id

	SQLEXEC(nhand,"update material_in_main set in_id ='' ")

ENDIF



IF SQLEXEC(nhand,"alter table outlet  add  price_style smallint null")>0				&&10/04/2008  outlet  增加  price_style

	SQLEXEC(nhand,"update outlet set price_style =1 ")
	SQLEXEC(nhand,"update outlet set price_style =2 where id=0")		&&外賣區域按外賣價(預設)

ENDIF

TEXT TO ssql noshow					&&14/4/2008	增加table_move 記錄餐檯移動(整單轉檯)

CREATE TABLE [dbo].[table_move](
	[order_id] int null,
	[move_from] [char](10) NULL,
	[move_to] [char](10)   NULL,
	[datetime] [datetime]  NULL,
	[adduser] [nchar](20)  NULL,
	[barcode_mode] bit null,
	
)

ENDTEXT
=SQLEXEC(nhand,ssql)


SQLEXEC(nhand,"ALTER TABLE  inv_print_detail ADD	id int NOT NULL IDENTITY (1, 1)")		&&18/04/2008		

SQLEXEC(nhand,"ALTER TABLE inv_reprint_detail ADD	id int NOT NULL IDENTITY (1, 1)")		&&18/04/2008

SQLEXEC(nhand,"ALTER TABLE pay_print_detail ADD	id int NOT NULL IDENTITY (1, 1)")		&&18/04/2008

SQLEXEC(nhand,"alter table slip_print_detail add item_unicode varchar(254) null")			&&29/04/2008 slip_print_detail

SQLEXEC(nhand,"alter table pay_print_detail add item_unicode varchar(254) null")			&&30/04/2008 slip_print_detail

IF SQLEXEC(nhand,"alter table  itemPrice add onlyperiod bit null")>0											&&03/05/2008	 itemprice  增加onlyperiod
		SQLEXEC(nhand,"update itemPrice set onlyperiod=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

TEXT TO ssql noshow
	alter table system_setting alter column clistcn varchar(200)
	alter table system_setting alter column clisten varchar(200)
	alter table system_setting alter column clist_value varchar(200)

ENDTEXT
=SQLEXEC(nhand,ssql)



IF SQLEXEC(nhand,"alter table inv add updateno int null")>0   &&05/09/2008

		SQLEXEC(nhand,"update inv set updateno=1")			
		
ENDIF
*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



IF SQLEXEC(nhand,"alter table holi add pbegdate datetime null,penddate datetime null")>0						&& 05/13/2008   公眾假期 增加發票備注的打印起止日期
			
			=SQLEXEC(nhand,"update holi set pbegdate=begdate,penddate=enddate")

ENDIF

TEXT TO ssql noshow

	CREATE TABLE [dbo].[cp](
		[active] [bit] NULL,
		[id] [int] NULL,
		[desccn] [varchar](50) NULL,
		[descen] [varchar](50)  NULL,
		[dine_active] [bit] NULL,
		[fastfood_active] [bit] NULL,
		[barcode_active] [bit] NULL,
		[begtime] [char](5)  NULL,
		[endtime] [char](5)  NULL,
		[day1] [bit] NULL,
		[day2] [bit] NULL,
		[day3] [bit] NULL,
		[day4] [bit] NULL,
		[day5] [bit] NULL,
		[day6] [bit] NULL,
		[day7] [bit] NULL,
		[holiday] [bit] NULL,
		[recur] [bit] NULL,
		[dispord] [int] NULL
	) 

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow
CREATE TABLE [dbo].[item_cp](
	[item_id] [int] NULL,
	[cp_Id] [int] NULL,
	[price] [numeric](12, 2) NULL
) 
ENDTEXT
=SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table order_detail add org_price numeric(12,2) null ,turnup bit null")>0				&&  order_tail add org_price,turnup   05/15/2008
	=SQLEXEC(nhand,"update order_detail set org_price=price,turnup=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

TEXT TO ssql noshow						&& 5/16/2008   add 		cp_log

	CREATE TABLE [dbo].[cp_log](
		[id] [int] NULL,
		[order_ID] [int] NULL,
		[inv_id] [int] NULL,
		[tableno] [char](10)  NULL,
		[datetime] [datetime] NULL,
		[item_id] [int] NULL,
		[org_price] [numeric](12, 2) NULL,
		[price] [numeric](12, 2) NULL,
		[cp_price] [numeric](12, 2) NULL,
		[cp_id] [int] NULL,
		[adduser] [nchar](20)  NULL
	) 

ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table cp_log add run_mode char(10) null")

=SQLEXEC(nhand,"update item set timer_style=2,timer_begtime='00:00',timer_endtime='23:59' where timer_style=1")			&&更新到新的計鍾方式數據
=SQLEXEC(nhand,"update item set timer_style=2 where timer_style=3 ")

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table order_main add remark varchar(20) null")>0			&& 3/6/2008 
	=SQLEXEC(nhand,"update order_main set remark='' ")

ENDIF

IF SQLEXEC(nhand,"alter table inv add remark varchar(20) null")>0			&& 3/6/2008 
	=SQLEXEC(nhand,"update inv set remark='' ")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table inv_print_main add remark varchar(20) null")>0			&& 3/6/2008 
	=SQLEXEC(nhand,"update inv_print_main set remark='' ")

ENDIF

IF SQLEXEC(nhand,"alter table inv_reprint_main add remark varchar(20) null")>0			&& 3/6/2008 
	=SQLEXEC(nhand,"update inv_reprint_main set remark='' ")

ENDIF

IF SQLEXEC(nhand,"alter table order_print_main add remark varchar(20) null")>0			&& 11/6/2008 
	=SQLEXEC(nhand,"update order_print_main set remark='' ")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

IF SQLEXEC(nhand,"alter table station add mainserver bit null")>0			&& 13/6/2008 
	=SQLEXEC(nhand,"update station  set mainserver=0")

ENDIF

SQLEXEC(nhand,"create table  dbo.updateno ( table_name char(30),max_updateno int )")		&&創建表updateno

SQLEXEC(nhand,"if not exists (select table_name from updateno where table_name='inv')	insert into updateno (table_name,max_updateno) values('inv',1)")		&&如果沒有inv,加入

		IF SQLTABLES(nhand,"table","tables_tmp")>0
			
			SELECT tables_tmp		&&  刪除觸發器
			SCAN
				_cname=TRIM(tables_tmp.table_name)
				IF _cname#"updateno"		

				ssql="DROP TRIGGER [dbo]."+_cname+"_tig"
				
				TEXT TO ssql noshow
				
					if not exists(select table_name from updateno where table_name=?_cname)
						insert into updateno (table_name,max_updateno) values(?_cname,1)
						
				
				ENDTEXT
				=SQLEXEC(nhand,ssql)
					
			ENDIF
			
			ENDSCAN

			USE IN tables_tmp
			
		ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table outlet_printer add begtime char(5) null,endtime char(5) null")>0			&& 8/7/2008 
	
 	SQLEXEC(nhand,"update outlet_printer set begtime='00:00',endtime='23:59' ")

ENDIF

IF SQLEXEC(nhand,"alter table outlet_printer add station_id  int null")>0			&& 9/7/2008 
	
 	SQLEXEC(nhand,"update outlet_printer set station_id=0 ")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*=SQLEXEC(nhand,"alter table sys_user alter column password nvarchar(50) COLLATE Chinese_Taiwan_Stroke_CS_AS")		&& 記密碼區分大小寫
*=SQLEXEC(nhand,"alter table sys_user alter column cardno nvarchar(50) COLLATE Chinese_Taiwan_Stroke_CS_AS")		&& 記卡號區分大小寫


IF SQLEXEC(nhand,"alter table printerset add report_form varchar(20) null")>0		&& 22/07/2008
	
	SQLEXEC(nhand,"update printerset  set report_form='' ")

ENDIF

IF SQLEXEC(nhand,"alter table inv_detail add onlysave bit null")>0			&&23/07/2008
	
	SQLEXEC(nhand,"update inv_detail set onlysave=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table itemprice add orgsrv bit null")>0			&&24/07/2008		 時段售價加入"按原價計算服務費"
	
	SQLEXEC(nhand,"update itemprice set orgsrv=0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add orgsrv bit null")>0			&&24/07/2008		order_detail 加入"按原價計算服務費"
	
	SQLEXEC(nhand,"update order_detail set orgsrv=0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add price0 numeric(12,2) null ")>0			&&24/07/2008		order_detail 加入原價
	
	SQLEXEC(nhand,"update order_detail set price0=0.00")

ENDIF



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



** 2008-08-01
** 於 import item 時會 delete from cate, departmetn, item
** 要加回 min charge & octopus, 否則 report 唔夾數

&&Lihong 2021.04.21 department add -5 報表合計才能一致  
TEXT TO cmd noshow
	DELETE FROM itemdept WHERE item_id = -3 OR item_id = -8 OR item_id=-5 OR item_id=-9 OR item_id = -10  OR item_id=-6
	insert into itemdept (item_id,dept_id,price,price_per) values (-3,-3,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-8,-8,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-5,-5,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-9,-9,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-10,-10,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-6,-6,0,100)


	delete from department where id = -3 or id = -8 OR id=-5 OR id=-9 OR id=-10 OR id=-6
	insert into department (active, id, desccn, descen, disporder) values (0, -3, '最低消費', 'Min Charge', -3)
	insert into department (active, id, desccn, descen, disporder) values (0, -8, '八達通增值', 'Octopus Add Value' , -8)
	insert into department (active, id, desccn, descen, disporder) values (0, -5, '多出現金', 'EXCESS_CASH' , -5)
	insert into department (active, id, desccn, descen, disporder) values (0, -9, '八達通退款', 'Octopus Add Value' , -9)
	insert into department (active, id, desccn, descen, disporder) values (0, -10, '澳門通退款', 'Octopus Add Value' , -10)
	insert into department (active, id, desccn, descen, disporder) values (0, -6, ' 附加費', 'additional fee' , -6)

ENDTEXT 

*	insert into department (active, id, desccn, descen, disporder) values (0, -5, '多出現金', 'EXCESS_CASH' , -8)


=SQLEXEC(nhand, cmd)

&&Lihong 2021.04.21 cate add -5
TEXT TO cmd noshow
	delete from cate where id = -3 or id = -8 OR id=-5  OR id=-9 OR id = -10 OR id=-6

	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -3, '最低消費' , 'Min Charge' , 0 , -3, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')

	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -8, '八達通增值' , 'Octopus Add Value' , 0 , -8, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')
	
	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -5, '多出現金', 'EXCESS_CASH', 0 , -5, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')
	
	
	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -9, '八達通退款' , 'Octopus Refund' , 0 , -9, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')

	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -10, '澳門通退款' , 'MacauPass Refund' , 0 , -10, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')

	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -6, '附加費' , 'additional fee' , 0 , -10, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')

ENDTEXT 
=SQLEXEC(nhand, cmd)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))
TEXT TO cmd noshow
	delete from item where id = -3 or id = -8 OR id=-5 OR id=-9 OR id = -10 OR id=-6

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -3, -3, -3, -3, '-3', '最低消費' , 'Min Charge' , 'Min Charge' , '最低消費' , '最低消費' , 'Min Charge', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -8, -8, -8, -8, '-8', '八達通增值' , 'Octopus Add Value' , 'Octopus Add Value' , '八達通增值' , '八達通增值' , 'Octopus Add Value', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')
		


	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -5, -5, -5, -5, '-5', '多出現金' , 'EXCESS_CASH' , 'EXCESS_CASH' , '多出現金' , '多出現金' , 'EXCESS_CASH', 0  , 0, 0 , 0, 0, 0, 0, 0 , 1, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')
		

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -9, -9, -9, -9, '-9', '八達通退款' , 'Octopus Refund' , 'Octopus Refund' , '八達通退款' , '八達通退款' , 'Octopus Refund', 0  , 0, 0 , 0, 0, 0, 0, 0 , 1, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')


	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -10, -10, -10, -10, '-10', '澳門通退款' , ' Refund' , 'MacauPass Refund' , '澳門通退款' , '澳門通退款' , 'MacauPass Refund', 0  , 0, 0 , 0, 0, 0, 0, 0 , 1, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')


	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -6, -6, -6, -6, '-6', '附加費' , ' additional fee' , ' additional fee' , '附加費' , '附加費' , 'additional fee', 0  , 0, 0 , 0, 0, 0, 0, 0 , 1, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '') 
		
ENDTEXT 
=SQLEXEC(nhand, cmd)
*------------------------------------


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))




* 2008-08-1
* 將 payment 中英名稱統一, 避免中英互換時顯示 付款 'cash' 找回 '現金'
=SQLEXEC(nhand,"update payway set desccn = 'Cash' where descen = 'Cash' ")
=SQLEXEC(nhand,"update payway set desccn = 'EPS' where descen = 'EPS' ")
=SQLEXEC(nhand,"update payway set desccn = 'Octopus' where descen = 'Octopus' ")


*
*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))




* 2008-08-1
*payway.desccn 長 30, 要把 pay_detail 一併加至 30
=SQLEXEC(nhand, "alter table pay_detail alter column payway nvarchar (30)")
=SQLEXEC(nhand, "alter table payway_print_detail alter column payway nvarchar (30)")





* 2008-08-1
*經由 4310 轉至 rms6 時沒有處理 onlyperiod, 引致不能於 setup_item 更改
=SQLEXEC(nhand, "update itemprice set onlyperiod = 0 where onlyperiod is null")


* 2008-08-1
*避免營業額中, 付 "現金", 找回 "cash", 把名統一為 cash
TEXT TO cmd noshow
	update message set message_cn = 'Cash' where m_code = '_cash'
	update pay_detail set payway = 'Cash' where payway = '現金'                  
	update payway set desccn = 'Cash' where desccn = '現金'                  
ENDTEXT 
=SQLEXEC(nhand, cmd)

* 2008-08-1
=SQLEXEC(nhand, "alter table inv_print_main alter column address nvarchar (100)")
=SQLEXEC(nhand, "alter table inv_reprint_main alter column address nvarchar (100)")

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


** 2008-8-6
** backup 時如有設定 usbdrive, 把 sbk file zip 去 usbdrive
=SQLEXEC(nhand, "alter table backup_schedule add usbdrive char (1) null")
=SQLEXEC(nhand, "update backup_schedule set usbdrive = '' where usbdrive is null")

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



SQLEXEC(nhand,"alter table order_print_main alter column remin_difftime char(8)")		&& 21/08/2008
SQLEXEC(nhand,"alter table sys_user  alter column  name nchar(20) null")		&&09/09/2008
SQLEXEC(nhand,"alter table role  alter column  name nchar(30) null")		&&09/09/2008

TEXT TO SSQL NOSHOW					&& 12/09/2008			
	CREATE TABLE [dbo].[pay_print_disc](
		[pid] [char](20) NULL,
		[descdisp] [char](100) NULL,
		[amt] [numeric](12, 2) NULL
	) 
ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


&&廚房單加入會員編號及會員名稱  20/09/2008
SQLEXEC(nhand,"alter table order_print_main add member_name nchar(100) null,member_no char(100) null") 



* 2008-10-08
* 發現出街時於系統設定中無左 '點菜設定'
TEXT TO cmd noshow
	if not exists (select id from system_menu where id = 21)
		insert into system_menu values (1,21, '點菜設定' , 'Order Setting' , 2 ,  '__order_setting')     
ENDTEXT
=SQLEXEC(nhand, cmd)


&&Lihong 2021.09.26 處理重複roleaccess_id 
TEXT TO cmd NOSHOW 
select roleaccess_id from roleaccess group by roleaccess_id having count(roleaccess_id)>1
ENDTEXT
IF SQLEXEC(nhand, cmd, "roleaccess_id_tmp") > 0
SCAN 
	IF SQLEXEC(nhand, "select * from roleaccess where roleaccess_id=?roleaccess_id_tmp.roleaccess_id ", "roleaccess_id_tmp1") > 0
		SCAN FOR RECNO()<RECCOUNT()
			=SQLEXEC(nhand, "update roleaccess set roleaccess_id = (select ISNULL(MAX(roleaccess_id),0)+1 from roleaccess) where code=?TRIM(roleaccess_id_tmp1.code)")
		ENDSCAN 
	ENDIF 
	SELECT roleaccess_id_tmp
ENDSCAN 
ENDIF 


*2008-11-25 
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id125->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_setting')
		insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id,'fr_setting', '          菜色資料', '          Item Setting', 2305,1,1)
ENDTEXT
=SQLEXEC(nhand, cmd)
 


*2008-11-29
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id300->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_cp')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, 'setup_cp', '          轉價', '          Change Price' , 535 , 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))






*2008-12-03
*error log 記錄 exe version
TEXT TO cmd noshow
	alter table error_log add version nvarchar (100) null
ENDTEXT 
=SQLEXEC(nhand, cmd)


&&12/12/2008		order_print_main 加入print_no
=SQLEXEC(nhand,"alter table order_print_main  add print_no  int  null ")>0			


&&12/12/2008   printerset 加入print_no及last_belongdae
IF SQLEXEC(nhand,"alter table printerset  add print_no  int null,last_belongdate smalldatetime null ")>0							
	=SQLEXEC(nhand,"update printerset set print_no=0,last_belongdate=getdate()")
ENDIF


&&2008.12.16  加入自動折扣
TEXT TO ssql noshow									
	CREATE TABLE [dbo].[autoDisc](
		[active] [bit] NULL,
		[id] [int] NULL,
		[desccn] [nvarchar](50)  NULL,
		[descen] [nvarchar](50)  NULL,
		[minamt] [numeric] (12,2) null,
		[disc_id] [int] null,
		[dine_active] [bit] NULL,
		[fastfood_active] [bit] NULL,
		[barcode_active] [bit] NULL,
		[begtime] [char](5)  NULL,
		[endtime] [char](5)  NULL,
		[day1] [bit] NULL,
		[day2] [bit] NULL,
		[day3] [bit] NULL,
		[day4] [bit] NULL,
		[day5] [bit] NULL,
		[day6] [bit] NULL,
		[day7] [bit] NULL,
		[holiday] [bit] NULL,
		[ex_holiday] [bit] null
	) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

&& 整單折扣加入自動折扣  2008.12.19
SQLEXEC(nhand,"alter table order_disc add  autodisc bit null") 

&& OUTLET加入自動折扣  2008.12.19
IF SQLEXEC(nhand,"alter table outlet add  autodisc bit null")>0 
	SQLEXEC(nhand,"update outlet set autodisc=1")
ENDIF




*2008-12-20
*加文成記 item qty per date reprot
=SQLEXEC(nhand, "alter table modifier add show_in_report bit null")
=SQLEXEC(nhand, "update modifier set show_in_report = 0 where show_in_report is null")

=SQLEXEC(nhand, "alter table modi_clean add show_in_report bit null")
=SQLEXEC(nhand, "update modi_clean set show_in_report = 0 where show_in_report is null")


TEXT TO cmd noshow
	if not exists (select * from report_lookup where cmd = 'do form form\fr_item_daily')
	insert into report_lookup (cn, en, cmd, show, dispord, imagefile, exportoption)
	values ('菜色每日數量', 'Item Qty Per Day','do form form\fr_item_daily', 1, 205, '', '1,2,3,4,5,6,7,8,9')

	update report_lookup set dispord = 30 where cmd = 'do form form\fr_item_daily'
ENDTEXT
=SQLEXEC(nhand, cmd)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*2008-12-20
*加比較報表
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id301 302->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_item_daily')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_item_daily','          菜色每日數量', '          Item Qty Per Day', 2102, 1,1)

	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_compare')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_compare','          比較報表', '          Compare Report', 2104, 1,1)
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO cmd noshow
	if not exists (select * from report_lookup where cmd = 'do form form\fr_compare')
	insert into report_lookup (cn, en, cmd, show, dispord, imagefile, exportoption)
	values ('比較報表', 'Compare Report','do form form\fr_compare', 1, 40, '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
=SQLEXEC(nhand, cmd)

TEXT TO cmd noshow
	if not exists (select * from sys_options where type ='date_compare' and descen = 'this month')
		insert into sys_options values (1,'','date_compare', '本月', 'This Month', 1,10,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'last month')
		insert into sys_options values (2,'','date_compare', '上月', 'Last Month', 1,20,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'last last month')
		insert into sys_options values (3,'','date_compare', '上上月', 'Last Last Month', 1,30,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'last year this month')
		insert into sys_options values (4,'','date_compare', '去年本月', 'Last Year This Month', 1,40,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'last year last month')
		insert into sys_options values (5,'','date_compare', '去年上月', 'Last Year Last Month', 1,50,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'this year')
		insert into sys_options values (6,'','date_compare', '本年', 'This Year', 1,60,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'last year')
		insert into sys_options values (7,'','date_compare', '去年', 'Last Year', 1,70,getdate())
	if not exists (select * from sys_options where type ='date_compare' and descen = 'custom')
		insert into sys_options values (8,'','date_compare', '自訂', 'Custom', 1,80,getdate())
ENDTEXT
=SQLEXEC(nhand, cmd)



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


&& 整單折扣加入自動折扣  2008.12.29
SQLEXEC(nhand,"alter table inv_disc add  autodisc bit null") 


&& 自動折扣 加入DISPORD  2008.12.29
IF SQLEXEC(nhand,"alter table autodisc add  dispord int")>0 
	SQLEXEC(nhand,"update autodisc set dispord=id")
ENDIF

&& 加入稅率2--用於荷蘭版本
IF SQLEXEC(nhand,"alter table item add  tax2 numeric(6,2)")>0 
	SQLEXEC(nhand,"update item set tax2=0.00")
ENDIF


&& 加入稅率2--用於荷蘭版本
=SQLEXEC(nhand,"alter table order_detail add  tax2 numeric(6,2)") 

&& 加入稅率2--用於荷蘭版本
=SQLEXEC(nhand,"alter table inv_detail add  tax2 numeric(6,2)") 



*2008-12-30
*加 tel1 
=SQLEXEC(nhand, "alter table member add tel1 nvarchar (50) null") 
=SQLEXEC(nhand, "update member set tel1 = '' where tel1 is null") 


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

*2008-12-31
*report + group send sms
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id303->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_sms')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_sms','          群發短信', '          Group send SMS', 2330, 1,1)

	if not exists (select * from report_lookup where cmd = 'do form form\fr_sms')
	insert into report_lookup (cn, en, cmd, show, dispord, imagefile, exportoption)
	values ('群發短信', 'Group send SMS','do form form\fr_sms', 1, 1030, '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
=SQLEXEC(nhand, cmd)



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*---------------
TEXT TO ssql noshow											&&加入發票荷蘭稅統計 2009.01.02

CREATE TABLE [dbo].[inv_print_tax](
	[pid] [char](20)  NULL,
	[descdisp] [nvarchar](100)  NULL,
	[amt] [numeric](12, 2) NULL
) 


ENDTEXT


=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE TABLE [dbo].[inv_reprint_tax](
	[pid] [char](20)  NULL,
	[descdisp] [nvarchar](100)  NULL,
	[amt] [numeric](12, 2) NULL
) 


ENDTEXT


=SQLEXEC(nhand,ssql)

*---------

IF SQLEXEC(nhand,"alter table itemprice add begtime char(5) null,endtime char(5) null")>0			&&時段售價加入起止時間 2009.01.05
	
	IF SQLEXEC(nhand,"select a.item_id,a.section_id,a.dispord,b.s_from,b.s_to from itemprice a left join system_period b on a.section_id=b.id","cun_tmp")>0
		
		UPDATE cun_tmp SET s_from="00:00",s_to="23:59" WHERE section_id=0
		SELECT cun_tmp
		SCAN
			
			=SQLEXEC(nhand,"update itemprice set begtime=?cun_tmp.s_from,endtime=?cun_tmp.s_to where item_id=?cun_tmp.item_id and dispord=?cun_tmp.dispord")
		
		ENDSCAN
		
	
	ENDIF
	
ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*2009-1-14
*edit invoice content + access right
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id304->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invinfo_edit_content')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id , 'invinfo_edit_content', '          更改發票內容', '          Edit invoice content', 845, 1,1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW &&By Waston 17/05/2022 更改發票鎖腳
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invinfo_edit_cashier')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id , 'invinfo_edit_cashier', '          更改鎖腳', '          Change Cashier', 857, 1,1)
ENDTEXT 
=SQLEXEC(nhand, cmd)


*2009-1-14
*message_log 加 record for 改單用
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 181)
	insert into message_log values (181, '更改發票', 'Edit invoice', '_chnage_invoice', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO cmd noshow
	if not exists (select id from message_log where id = 182)
	insert into message_log values (182, '更改發票成功', 'Edit invoice ok', '_chnage_invoice_ok' , 1,1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

TEXT TO cmd noshow
	if not exists (select id from message_log where id = 183)
	insert into message_log values (183, '更改發票不成功', 'Edit invoice failed', '_chnage_invoice_fail' , 1,1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



&&加入打印付款清單的log_id 2009.01.15
ssql="if not exists(select id from message_log where id=184) insert into message_Log (id,desccn,descen,pcode,log_level) values (184,'列印付款清單','Print PayList','_print_paylist',1)"
=SQLEXEC(nhand,ssql)






*2009-1-20
*打卡出入6組時間 (滋味滿屋)

TEXT TO cmd NOSHOW 
	alter table atte add time7 datetime NULL 
	alter table atte add time8 datetime NULL 
	alter table atte add time9 datetime NULL 
	alter table atte add time10 datetime NULL 
	alter table atte add time11 datetime NULL 
	alter table atte add time12 datetime NULL 
ENDTEXT 	
=SQLEXEC(nhand, cmd)



SQLEXEC(nhand,"alter table material  alter column  qty numeric(18,4) null")		&&2009.02.13




&& 2009.03.11 加入會員積分計劃
TEXT TO ssql noshow			

	CREATE TABLE [dbo].[member_point](
		[active] [bit] NULL,
		[id] [int] NULL,
		[descdisp] [nvarchar](50)  NULL,
		[member_type] [int] null,
		[member_id] [int] null,
		[begdate] [datetime] null,
		[enddate] [datetime] null,
		[minamt] [numeric](12, 2) NULL,
		[per_amt] [numeric](12,2) null,
		[points] [numeric] (12,2) null,
		[dine_active] [bit] NULL,
		[fastfood_active] [bit] NULL,
		[barcode_active] [bit] NULL,
		[begtime] [char](5)  NULL,
		[endtime] [char](5)  NULL,
		[day1] [bit] NULL,
		[day2] [bit] NULL,
		[day3] [bit] NULL,
		[day4] [bit] NULL,
		[day5] [bit] NULL,
		[day6] [bit] NULL,
		[day7] [bit] NULL,
		[holiday] [bit] NULL,
		[ex_holiday] [bit] NULL,
		[dispord] [int] NULL
	) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

&& 2009.03.12 DISC	加入積分
IF SQLEXEC(nhand,"alter table disc add  points numeric(12,2)")>0 
	=SQLEXEC(nhand,"update disc set points=0")
ENDIF

&& 2009.03.13 item	加入積分
IF SQLEXEC(nhand,"alter table item add  points numeric(12,2)")>0 
	=SQLEXEC(nhand,"update item set points=0")
ENDIF

&& 2009.03.13 member 加入積分
IF SQLEXEC(nhand,"alter table member add  points numeric(12,2)")>0 
	=SQLEXEC(nhand,"update member set points=0")
ENDIF





IF SQLEXEC(nhand,"alter table order_detail add  pointed bit null,points numeric(12,2) null")>0 && 2009.03.18 order_detail 加入是否已換購
	=SQLEXEC(nhand,"update order_detail set pointed=0,points=0.00")
ENDIF

IF SQLEXEC(nhand,"alter table inv_detail add  pointed bit null,points numeric (12,2) null")>0 && 2009.03.18 inv_detail 加入是否已換購
	=SQLEXEC(nhand,"update inv_detail set pointed=0,points=0.00")
ENDIF


IF SQLEXEC(nhand,"alter table inv add  points numeric(12,2)")>0 && 2009.03.19 inv 加入積分
	=SQLEXEC(nhand,"update inv set points=0")
ENDIF


IF SQLEXEC(nhand,"alter table order_disc add  points numeric(12,2)")>0 && 2009.03.19 inv 加入積分
	=SQLEXEC(nhand,"update order_disc set points=0")
ENDIF

IF SQLEXEC(nhand,"alter table inv_disc add  points numeric(12,2)")>0 && 2009.03.19 inv 加入積分
	=SQLEXEC(nhand,"update inv_disc set points=0")
ENDIF

IF SQLEXEC(nhand,"alter table inv add  points_used numeric(12,2)")>0 && 2009.03.23 inv 加入積分(使用)
	=SQLEXEC(nhand,"update inv set points_used=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))





=SQLEXEC(nhand,"alter table inv_print_main add  points numeric(12,2),points_used numeric(12,2),points_remain numeric(12,2)") && 2009.03.24 inv_print_main 加入積分
=SQLEXEC(nhand,"alter table inv_reprint_main add  points numeric(12,2),points_used numeric(12,2),points_remain numeric(12,2)") && 2009.03.24 inv_reprint_main 加入積分

=SQLEXEC(nhand,"alter table inv_print_detail add  points numeric(12,2)") && 2009.03.24 inv_print_detail 加入積分
=SQLEXEC(nhand,"alter table inv_reprint_detail add  points numeric(12,2)") && 2009.03.24 inv_reprint_detail 加入積分

SQLEXEC(nhand,"alter table inv add  points_remain numeric(12,2)") && 2009.03.24 inv 加入會員所余積分

=SQLEXEC(nhand,"alter table inv_print_disc add  points numeric(12,2)") && 2009.03.25 inv_print_disc 加入積分
=SQLEXEC(nhand,"alter table inv_reprint_disc add  points numeric(12,2)") && 2009.03.25 inv_reprint_disc 加入積分


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

*2009-3-27
*report add log


=SQLEXEC(nhand, "insert into message_log  values (185, '執行報表', 'Run report', '_run_report', 1,1)")
=SQLEXEC(nhand, "insert into message_log  values (186, '打印報表', 'Print report', '_print_report', 1,1)")
=SQLEXEC(nhand, "insert into message_log  values (187, '輸出報表', 'Export report', '_export_report', 1,1)")
=SQLEXEC(nhand, "insert into message_log  values (188, '電郵報表', 'email report', '_email_report', 1,1)")
=SQLEXEC(nhand, "alter table sys_log alter column [action] nvarchar (200)")
=SQLEXEC(nhand, "alter table sys_log alter column [station] nvarchar (30)")
=SQLEXEC(nhand, "alter table sys_log alter column [adduser] nvarchar (30)")

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


&&2009.04.16 
=SQLEXEC(nhand,"alter table message  alter column  message_cn nvarchar(150) null")		
IF SQLEXEC(nhand,"alter table message  alter column  message_en nvarchar(150) null")>0
 
	LOCAL cmsg1,cmsg2

	cmsg1="+++ 請勿取消交易 +++"+CHR(13)+"交易未能完成請通知顧客用同一張卡"+CHR(13)+"再次拍卡，以確保交易無誤"
	cmsg2="+++ DO NOTCANCEL THE TXN +++"+CHR(13)+"Transaction Incomplete"+CHR(13)+"Please request customer to present the same card again to complete the transaction"

	=SQLEXEC(nhand,"update message set message_cn=?cmsg1,message_en=?cmsg2 where m_code='octopus_rw_100022'")

ENDIF


&&2009.04.16 
=SQLEXEC(nhand,"alter table order_disc  alter column disc_level  nvarchar(200) null")		



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

&&2009.05.22 cate add blank
IF SQLEXEC(nhand,"alter table cate add blank bit null")>0		
	=SQLEXEC(nhand,"update cate set blank=0")
ENDIF

&&2009.05.25 modifier add blank
IF SQLEXEC(nhand,"alter table modifier add blank bit null")>0		
	=SQLEXEC(nhand,"update modifier set blank=0")
ENDIF


&&2009.05.25 create item_backup table for item edit log
IF SQLEXEC(nhand,"select top 0 *  into item_backup  from item")>0		
	=SQLEXEC(nhand,"alter table   item_backup add adduser  nvarchar(20) null ,updatetime datetime null")
ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

* 2009-05-29
*!*	TEXT TO cmd noshow
*!*		update message set message_cn = '特別處理顏色及次序', message_en = 'Modifier Color & Order' where m_code = '_modifier_color_setup'
*!*		update message set message_cn = '菜式顏色及次序', message_en = 'Item Color & Order' where m_code = '_item_color_setup'
*!*	ENDTEXT 	
*!*	=SQLEXEC(nhand, cmd)	


&&2009.06.08 
=SQLEXEC(nhand,"alter table order_detail  alter column qty  numeric (8,3) null")		
=SQLEXEC(nhand,"alter table inv_detail  alter column qty  numeric (8,3) null")		


&&2009.06.09 item增加barcode
IF SQLEXEC(nhand,"alter table item add barcode varchar(20) null ")>0		
	=SQLEXEC(nhand,"update item set barcode='' ")
ENDIF


&&2009.06.09 item增加 kilo(以斤兩計數量)
IF SQLEXEC(nhand,"alter table item add kilo bit null ")>0		
	=SQLEXEC(nhand,"update item set kilo=0 ")
ENDIF


&&2009.06.19 outlet加入
IF SQLEXEC(nhand,"alter table outlet add srvper numeric(6,2) null")>0		
	=SQLEXEC(nhand,"update outlet set srvper=0")
ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


&&2009.06.22加入支出付款方式
TEXT TO ssql noshow														
	CREATE TABLE [dbo].[expense_payway](
		[active] [bit] NOT NULL,
		[id] [int] NOT NULL,
		[desccn] [nvarchar](30)  NOT NULL,
		[descen] [nvarchar](30)  NOT NULL,
		[dispord] [int] NOT NULL
	) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

ssql="if not exists (select id from expense_payway where id=1) "+;
	"insert into expense_payway (active,id,desccn,descen,dispord) values(1,1,'Cash','Cash',1)"
=SQLEXEC(nhand,ssql)



&&2009.07.04 update table_function
SQLEXEC(nhand,"alter table table_function  alter column  pcode nvarchar(30) null")		

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



*2009-7-22
*澳門集美個 computer name 長過20位
TEXT TO cmd noshow
	alter table station alter column desccn nvarchar (50)
ENDTEXT 
=SQLEXEC(nhand, cmd)	




&&2009.08.04 cate加入unicode
IF SQLEXEC(nhand,"alter table cate add desc_other varchar(254) null")>0		
	=SQLEXEC(nhand,"update cate set desc_other='' ")
ENDIF



&&2009.08.10
IF SQLEXEC(nhand,"select top 0 kilo from item_backup","cun_tmp")<0			
	=SQLEXEC(nhand,"drop table item_backup")
	=SQLEXEC(nhand,"select top 0 * into item_backup from item")
	=SQLEXEC(nhand,"alter table   item_backup add adduser  nvarchar(20) null ,updatetime datetime null")
ENDIF


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

*2009-8-25
*摩卡加 report
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id133 134->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_user')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_user', '          用戶列表' , '          Users List' , 3000, 1,1)

	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_role')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_role', '          角色列表' , '          Role List' , 3100, 1,1)

	if not exists (select * from report_lookup where cmd = 'do form form\fr_user')
	insert into report_lookup values ('用戶列表' , 'Users List' , 'do form form\fr_user' , 1, 30000, '', '1,2,3,4,5,6,7,8,9')

	if not exists (select * from report_lookup where cmd = 'do form form\fr_role')
	insert into report_lookup values ('角色列表' , 'Role List' , 'do form form\fr_role' , 1, 30100, '', '1,2,3,4,5,6,7,8,9')
ENDTEXT 
=SQLEXEC(nhand, cmd)	



&&2009.09.08 
=SQLEXEC(nhand,"alter table order_modi  alter column descdisp  nvarchar(50) null")		
=SQLEXEC(nhand,"alter table inv_modi  alter column descdisp  nvarchar(50) null")		



*2009-9-11
*將清機方式收埋唔比客自己 set
=SQLEXEC(nhand, "update system_setting set show = 0 where pcode = '__checked_method'")


&&2009.09.26		加入區域組合優惠B項目加價
IF SQLEXEC(nhand,"alter table outlet add levelDiscAdd numeric (12,2) null")>0		
	SQLEXEC(nhand,"update outlet set levelDiscAdd=0")
ENDIF


&&2009.10.02   加入ITEMPIC 表用於存放相片
TEXT TO SSQL NOSHOW 								
	  CREATE TABLE [dbo].[itempic] (
	   [UpdateNo] [int] NULL ,
	   [filename] [nvarchar] (50)  NULL ,
	   [pic] [text]  NULL 
	  ) ON [PRIMARY] 
ENDTEXT 
= SQLEXEC(nhand, SSQL)


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

&&2009.10.05
IF SQLEXEC(nhand,"alter table itempic add update_datetime datetime null")>0		
	=SQLEXEC(nhand,"update itempic set update_datetime =getdate()")
ENDIF


&& 2009.10.15
= SQLEXEC(nhand,"alter table inv add fastfood_info_id int null")		
TEXT TO ssql noshow
	if not exists( select id from fastfood_info where pcode='_fastfood') 
		insert into fastfood_Info (active,id,desccn,descen,pcode,dispord)
		values(1,0,'外賣','fastfood','_fastfood',0)
ENDTEXT
=SQLEXEC(nhand,ssql)



* 2009-10-20
* 加長由 200 > 250
=SQLEXEC(nhand, "alter table system_setting alter column clistcn nvarchar (250)")
=SQLEXEC(nhand, "alter table system_setting alter column clisten nvarchar (250)")
=SQLEXEC(nhand, "alter table system_setting alter column clist_value nvarchar (250)")


* 2009-11-27
* 更正 modi_clean structure
IF SQLEXEC(nhand, "alter table modi_clean add blank bit null" ) > 0
	=SQLEXEC(nhand, "UPDATE modi_clean SET blank = 0 WHERE blank is null")
ENDIF 


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


**********************
* 2010-2-9
* 最初 inv_itemdept id 寫錯為 order_id
* 如果有 order_id 就先 drop inv_itemdept 
**********************

IF SQLEXEC( nhand, "select top 1 order_id from inv_itemdept") > 0
	=SQLEXEC(nhand, "drop table inv_itemdept")
ENDIF 	


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow			&&  2009.12.07  加入個別菜式的部門分帳

	CREATE TABLE [dbo].[inv_itemdept](	
		[id] [int] NULL,
		[Parent_id] [numeric](10, 5) NULL,
		[item_id] [int] NOT NULL,
		[dept_id] [int] NOT NULL,
		[amount] [numeric](12, 2) NULL,
		[srvamt] [numeric](12, 2) NULL
	) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow		&&  2009.12.07  加入個別菜式的部門分帳

CREATE TABLE [dbo].[order_itemdept](
	[order_id] [int] NULL,
	[Parent_id] [numeric](10, 5) NULL,
	[item_id] [int] NOT NULL,
	[dept_id] [int] NOT NULL,
	[amount] [numeric](12, 2) NULL,
	[srvamt] [numeric](12, 2) NULL
) ON [PRIMARY]


ENDTEXT

=SQLEXEC(nhand,ssql)

IF SQLEXEC(nhand,"alter table item add askdept bit null")>0

	=SQLEXEC(nhand,"UPDATE item SET askdept=0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add askdept bit null")>0

	=SQLEXEC(nhand,"UPDATE item_ackup SET askdept=0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add askdept bit null")>0		&&2009.12.16

	=SQLEXEC(nhand,"UPDATE order_detail SET askdept=0")

ENDIF

IF SQLEXEC(nhand,"alter table inv_detail add askdept bit null")>0		&&2009.12.16

	=SQLEXEC(nhand,"UPDATE inv_detail SET askdept=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow		&&2009.12.24 &&Lihong 2021.09.26  roleaccess_id305->max+1

DECLARE @roleaccess_id int
SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
if not exists (select roleaccess_id  from roleaccess where code = 'order_return' /* Lihong 2021.09.26 roleaccess_id=305 */)
insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'order_return', '          退貨', '          Order Return', 265,1,1)

ENDTEXT

=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow			&&2010.01.09	

IF NOT exists(select id from disc where id=-1)
INSERT INTO [disc]
           ([active]
           ,[id]
           ,[desccn]
           ,[descen]
           ,[discper]
           ,[discamt]
           ,[begdate]
           ,[enddate]
           ,[disclevel]
           ,[dispord]
           ,[disc_type]
           ,[forecolor]
           ,[backcolor]
           ,[parent_id]
           ,[askqty]
           ,[points])
     VALUES
           (0
           ,-1
           ,'member discount'
           ,'member discount'
           ,0
           ,0
           ,''
           ,''
           ,''
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0)

ENDTEXT

=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table order_disc add member_number char(10) null") 		&&2010.01.11	加入會員編號(會員卡)
=SQLEXEC(nhand,"alter table order_disc add member_name varchar(30) null") 		&&2010.01.11	加入會員名稱(會員卡)

=SQLEXEC(nhand,"alter table inv_disc add member_number char(10) null")			&&2010.01.11	加入會員編號(會員卡)
*=SQLEXEC(nhand,"alter table inv  add member_disc bit null")					&&2010.01.12    發票加入是否有會員折扣



=SQLEXEC(nhand, "alter table item alter column price0 numeric(12,2)")			&&2010.01.12  更改item/item_backup 有關價格的寬度以適應越南需要
=SQLEXEC(nhand, "alter table item alter column price1 numeric(12,2)")
=SQLEXEC(nhand, "alter table item alter column priceset numeric(12,2)")
=SQLEXEC(nhand, "alter table item alter column cost numeric(12,2)")

=SQLEXEC(nhand, "alter table item_backup alter column price0 numeric(12,2)")
=SQLEXEC(nhand, "alter table item_backup alter column price1 numeric(12,2)")
=SQLEXEC(nhand, "alter table item_backup alter column priceset numeric(12,2)")
=SQLEXEC(nhand, "alter table item_backup alter column cost numeric(12,2)")


=SQLEXEC(nhand, "alter table inv_detail alter column round_amount numeric (12,2)")
=SQLEXEC(nhand, "alter table order_detail alter column round_amount numeric (12,2)")
=SQLEXEC(nhand, "alter table inv_detail alter column xdisc numeric (12,2)")
=SQLEXEC(nhand, "alter table order_detail alter column xdisc numeric (12,2)")


=SQLEXEC(nhand, "alter table order_detail alter column hold numeric (8,2)")		&&2010.01.18  更改order_detail  hold 接受小數

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow		&&2010.02.17

CREATE TABLE [dbo].[lms_Log](
	[log_id] [int] NULL,
	[datetime] [datetime] NULL,
	[shop] [char](10) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	[adduser] [nchar](20) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	[card_no] [char](20) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	[action] [nvarchar](200) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	[inv_no] [char](15) COLLATE Chinese_Taiwan_Stroke_CI_AS NULL,
	[amount] [numeric](12, 2) NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=189)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (189
           ,'開新積分卡'
           ,'new accumulating card'
           ,'_new_point_card'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=190)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (190
           ,'開新會員卡'
           ,'new member card'
           ,'_new_member_card'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=191)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (191
           ,'換領會藉/Coupon'
           ,'exchange membreship/Coupon'
           ,'_exchange_membership_coupon'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=192)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (192
           ,'換領現金券'
           ,'exchange Coupon'
           ,'_exchange_coupon'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=193)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (193
           ,'加會員積分'
           ,'加會員積分'
           ,'_add_points_inv'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=194)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (194
           ,'加會員積分(功能表)'
           ,'加會員積分(功能表)'
           ,'_add_points_other'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
IF NOT exists (select id from message_log where id=195)
INSERT INTO [dbo].[message_log]
           ([id]
           ,[desccn]
           ,[descen]
           ,[pcode]
           ,[log_level]
           ,[updated])
     VALUES
           (195
           ,'後補積分'
           ,'後補積分'
           ,'_add_points_reserve'
           ,1
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*2010-2-23
*先達 report
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id306->max+1
	if not exists (select * from report_lookup where cmd = 'do form form\fr_sintat')
		insert into report_lookup values ('先達會員報表', '先達會員報表', 'do form form\fr_sintat', 1, 1025, '', '1,2,3,4,5,6,7,8,9')

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_sintat')
		insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id, 'fr_sintat', '          先達會員報表', '          先達會員報表', 2325, 1, 1) 
ENDTEXT 
=SQLEXEC(nhand, cmd)






=SQLEXEC(nhand, "update table_function set desccn = '加非本店積分', descn = '加非本店積分' where id = 28" )
=SQLEXEC(nhand, "alter table lms_log add void_by nvarchar (100) NULL")
=SQLEXEC(nhand, "alter table lms_log add void_date datetime NULL")




=SQLEXEC(nhand,"update itemdept set price_per=100  where price=0 and price_per=0")	&&2010.03.05


=SQLEXEC(nhand,"alter table lms_Log add id  int IDENTITY(1,1)  not NULL")  &&2010.03.08


=SQLEXEC(nhand,"alter table item add gram bit null")				&&2010.03.11		item加入 是否按百克計算
=SQLEXEC(nhand,"alter table item_backup add gram bit null")			&&2010.03.11		item_backup

=SQLEXEC(nhand,"alter table member add fax varchar(30) null, dept nvarchar(30) null,work_addr nvarchar(50)")	&&2010.03.23 

=SQLEXEC(nhand,"alter table table_booking add book_time2 datetime null")		&&2010.03.24

=SQLEXEC(nhand,"alter table table_booking add remark nvarchar(200) null")		&&2010.03.24

*----item code 擴展到8位長度
=SQLEXEC(nhand,"alter table item alter column code char(8)null")					&&2010.03.26
=SQLEXEC(nhand,"alter table item_backup alter column code char(8)null")				&&2010.03.26
=SQLEXEC(nhand,"alter table order_detail alter column item_code char(8) null")		&&2010.03.26
=SQLEXEC(nhand,"alter table inv_detail alter column item_code char(8) null")		&&2010.03.26

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*------slip_print_main 

=SQLEXEC(nhand,"alter table slip_print_main add srvamt numeric(12,2) null")			&&2010.03.27
=SQLEXEC(nhand,"alter table slip_print_main add taxamt numeric(12,2) null")
=SQLEXEC(nhand,"alter table slip_print_main add rndamt numeric(12,2) null")
=SQLEXEC(nhand,"alter table slip_print_main add invamt numeric(12,2) null")
=SQLEXEC(nhand,"alter table slip_print_main add itemdiscamt numeric(12,2) null")

=SQLEXEC(nhand,"alter table member add carno varchar(15)  null")		&&2010.03.29

=SQLEXEC(nhand,"alter table slip_print_main add fastfood_info varchar(30) null")		&&2010.03.30

=SQLEXEC(nhand,"alter table tel_order add address2 nvarchar(50) null,address3 nvarchar(50) null,address4 nvarchar(50) null")		&&2010.04.12
=SQLEXEC(nhand,"alter table tel_order alter column remark nvarchar(50) null")

=SQLEXEC(nhand,"alter table order_main alter column address nvarchar(250) null")		&&2010.4.12



=SQLEXEC(nhand,"alter table slip_print_main alter column  fastfood_info nvarchar(30) null")	&&2010.04.16

=SQLEXEC(nhand,"alter table slip_print_main alter column  address nvarchar(250) null")


= SQLEXEC(nhand,"alter table member add cardno2 varchar(50) null")

	


IF SQLEXEC(nhand,"alter table itemprice add ex_holiday bit null")>0		&&2010.04.20

	=SQLEXEC(nhand,"update itemprice set ex_holiday=0")

ENDIF

=SQLEXEC(nhand,"alter table item alter column tax_id varchar(30) null")				&&2010.04.23	多選稅項方式
=SQLEXEC(nhand,"alter table item_backup alter column tax_id varchar(30) null")		&&2010.04.23	多選稅項方式

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow

CREATE TABLE [dbo].[order_tax](
	[id] [int] NOT NULL,
	[item_id] [numeric](10, 5) NOT NULL,
	[tax_id] [int] NULL,
	[tax_per] [numeric](6, 2) NULL,
	[tax_amount] [numeric](12, 2) NULL
) ON [PRIMARY]


ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE TABLE [dbo].[inv_tax](
	[id] [int] NOT NULL,
	[item_id] [numeric](10, 5) NOT NULL,
	[tax_id] [int] NULL,
	[tax_per] [numeric](6, 2) NULL,
	[tax_amount] [numeric](12, 2) NULL
) ON [PRIMARY]


ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table inv_print_void alter column qty  numeric(12,2) null")		&&2010.05.06
=SQLEXEC(nhand,"alter table inv_reprint_void alter column qty  numeric(12,2) null")		&&2010.05.06

=SQLEXEC(nhand,"alter table slip_print_detail alter column code  char(8) null")		&&2010.05.15

=SQLEXEC(nhand,"alter table sys_user add pwdcrypt varbinary(128) null")			&&2010.05.26

IF SQLEXEC(nhand,"select id,password from sys_user","cun_tmp")>0
	
	
	LOCAL lcPwd
	SELECT cun_tmp
	SCAN
		lcPwd=Strconv(STRCONV(TRIM(cun_tmp.password),14),14)
	
		=SQLEXEC(nhand,"update	sys_user set pwdcrypt=pwdencrypt('"+lcPwd+"') where id=?cun_tmp.id")
	
	ENDSCAN

ENDIF

IF SQLEXEC(nhand,"alter table disc add active_user varchar(200) null")>0

	=SQLEXEC(nhand,"update disc set active_user='all' ")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

=SQLEXEC(nhand,"alter table system_setting alter column desccn nvarchar(100) null")
=SQLEXEC(nhand,"alter table system_setting alter column descen nvarchar(100) null")

=SQLEXEC(nhand,"alter table tel_order add address5 nvarchar(50) null,address6 nvarchar(50) null")		&&2010.07.03


IF SQLEXEC(nhand,"alter table item add invlst_print bit null,invlst_noprint bit null")>0		&&2010.07.13		設定item 在發票清單中 必定列印及必定不列印

		=SQLEXEC(nhand,"update item set invlst_print =0,invlst_noprint =0")
		

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add invlst_print bit null,invlst_noprint bit null")>0		&&2010.07.13		設定item 在發票清單中 必定列印及必定不列印

		=SQLEXEC(nhand,"update item_backup set invlst_print =0,invlst_noprint =0")
		

ENDIF

*------




&& 2010.07.14 修正pay_detail中可能出現pay_id=0的情況
=SQLEXEC(nhand," if exists (select id from pay_detail where pay_id=0) update pay_detail set pay_id=(select id from payway where descen='Cash') where pay_id=0")


TEXT TO ssql noshow			&&2010.07.17		disc_log  折扣記錄

CREATE TABLE [dbo].[disc_log](
	[id] [int] NULL,
	[datetime] [datetime] NULL,
	[disc_type] [char](1) NULL,
	[disc_id] [int] NULL,
	[descdisp] [nvarchar](50) NULL,
	[disc_amount] [numeric](12, 2) NULL,
	[inv_no] [char](15) NULL,
	[adduser] [nchar](20) NULL,
	[void] [bit] NULL
) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table disc_log alter column inv_no [int] NULL")		&&  inv_no  --int


IF SQLEXEC(nhand,"alter table disc_log add tableno char(10) null")>0		&& disc_log  ad tableno

	=SQLEXEC(nhand,"update disc_log  set tableno='' ")
	

ENDIF



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


IF SQLEXEC(nhand,"alter table cate add active_station varchar(100) null")>0

	IF SQLEXEC(nhand,"select id from station where active=1 order by id","cun_tmp")>0
	
		LOCAL cid
		cid=""
		SELECT cun_tmp
		SCAN
			cid=cid+ALLTRIM(STR(id))+","
		
		ENDSCAN
		
		=SQLEXEC(nhand,"update cate set active_station=?cid")
	
	ENDIF
	

ENDIF


IF SQLEXEC(nhand,"alter table lms_log add member_type nvarchar(20) null")>0


	=SQLEXEC(nhand,"update lms_log set member_type='' ")


ENDIF


IF SQLEXEC(nhand,"alter table lms_log add access_user nvarchar(20) null")>0


	=SQLEXEC(nhand,"update lms_log set access_user ='' ")


ENDIF

*!*	TEXT TO ssql noshow		&& 2012.10.10   system_setting 增加label print 類

*!*	declare @id int
*!*	select @id=max(id)+1 from system_menu

*!*	if not exists( select id from system_menu where pcode='_label_print')
*!*	begin
*!*	insert into system_menu (active,id,desccn,descen,dispord,pcode)
*!*	values (1,@id,'Label 打印','Label Print',@id,'_label_print')
*!*	update system_setting set id=@id where pcode='__label_size' or pcode='__label_item_length'
*!*	end

*!*	ENDTEXT

*!*	=SQLEXEC(nhand)



*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*--------------------------------- update 2010.07.27  create function for web-side dev

TEXT TO ssql noshow

CREATE function Get_StrArrayStrOfIndex
(
 @str varchar(1024),  
 @split varchar(10),  
 @index int 
)
returns varchar(1024)
as
begin
 declare @location int
 declare @start int
 declare @next int
 declare @seed int
 set @str=ltrim(rtrim(@str))
 set @start=1
 set @next=1
 set @seed=len(@split)
 set @location=charindex(@split,@str)
 while @location<>0 and @index>@next
   begin
    set @start=@location+@seed
    set @location=charindex(@split,@str,@start)
    set @next=@next+1
   end
 if @location =0 select @location =len(@str)+1

 return substring(@str,@start,@location-@start)
end

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE function Get_StrArrayLength
(
 @str varchar(1024),  
 @split varchar(10)  
)
returns int
as
 begin
  declare @location int
  declare @start int
  declare @length int
  set @str=ltrim(rtrim(@str))
  set @location=charindex(@split,@str)
  set @length=1
   while @location<>0
     begin
      set @start=@location+1
      set @location=charindex(@split,@str,@start)
      set @length=@length+1
     end
   return @length
 end

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow

CREATE function Get_IndexOfStrArray
(
 @str varchar(1024),  
 @str2 varchar(1024)	
)
returns int
as
 begin

 declare @next int
 set @next=1 


 set @str=ltrim(rtrim(@str)) 

 while @next<=dbo.Get_StrArrayLength(@str,',')
   begin
     if upper(dbo.Get_StrArrayStrOfIndex(@str,',',@next))=upper(@str2) return @next
      set @next=@next+1
   end
	
  return 1
  

end

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

create function PadLeft(@num varchar(16),@paddingChar char(1),@totalWidth int)
returns varchar(16) as
begin
declare @curStr varchar(16)
select @curStr = isnull(replicate(@paddingChar,@totalWidth - len(isnull(@num ,0))), '') + @num
return @curStr
end
ENDTEXT

=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow

CREATE function [dbo].[Get_Printer]
(
 @cid varchar(10)  
)
returns nvarchar(100)
as
begin

declare @cprinter as nvarchar(100)
	
select @cprinter=desccn from printerset where id=@cid

return isnull(@cprinter,'')

end

ENDTEXT
=SQLEXEC(nhand,ssql)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



*2010-07-28
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id307->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_member_card')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_member_card', '          會員卡', '          Member Card' , 100001, 1 ,1 )
ENDTEXT 

=SQLEXEC(nhand, cmd)


TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id308->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_member_card_new')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_member_card_new', '          開新卡', '          開新卡' , 100002, 1 ,1 )
ENDTEXT 

=SQLEXEC(nhand, cmd)



TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id309->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_member_card_addvalue_loc')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_member_card_addvalue_loc', '          加積分(本店)', '          加積分(本店)' , 100003, 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id310->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_member_card_addvalue_other')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_member_card_addvalue_other', '          加積分(非本店)', '          加積分(非本店)' , 100004, 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id311->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_member_card_gift')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_member_card_gift', '          禮品換購', '          禮品換購' , 100005, 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

*2010.08.12

TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id312->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_order_disc_after_inv')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_order_disc_after_inv', '          已印單後給予折扣', '          已印單後給予折扣' , 581, 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id313->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_order_voiditem_after_inv')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, '_order_voiditem_after_inv', '          已印單後刪除菜色', '          已印單後刪除菜色' , 582, 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)


*2010-12-22
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id314->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'order_split')
	insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values ( @roleaccess_id, 'order_split', '          分單', '          Split Order' , 421 , 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)


*2011-08-01
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id315->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'settle_opendrawer')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) VALUES 
	 ( @roleaccess_id, 'settle_opendrawer', '          打開收銀櫃', '          Open Drawer' , 583 , 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)


*2011-08-18
TEXT TO cmd NOSHOW &&Lihong 2021.09.26  roleaccess_id316->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'order_soldout')
	insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) VALUES 
	( @roleaccess_id, 'order_soldout', '          售罄信息', '          Sold out Message' , 536 , 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_takeaway')
		insert into report_lookup values ('外賣地址報表', '外賣地址報表', 'do form form\fr_takeaway', 1, 485, '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)

TEXT TO ssql NOSHOW &&Lihong 2021.09.26  roleaccess_id317->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )

	if not exists (select * from roleaccess where code = 'fr_takeaway')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_takeaway', '          外賣地址報表', '          外賣地址報表', 128, 1, 1) 

ENDTEXT

=SQLEXEC(nhand,ssql)


*----------------------- &&2013.10.22

TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_membinvg')
		insert into report_lookup values ('會員分組統計報表', '會員分組統計報表', 'do form form\fr_membinvg', 1, 1022 , '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id317->max+1 [後面代碼修正了fr_membinvg的317 （7200里317是外賣地址報表）]

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_membinvg')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_membinvg', '          會員分組統計報表', '          會員分組統計報表', 2322, 1, 1) 

ENDTEXT

=SQLEXEC(nhand,ssql)

*----------------------- &&2014.02.27

TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_dept_daily')
		insert into report_lookup values ('部門按日統計報表', '部門按日統計報表', 'do form form\fr_dept_daily', 1, 330 , '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)

TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id318->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_dept_daily')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_dept_daily', '          部門按日統計報表', '          部門按日統計報表', 2210, 1, 1) 

ENDTEXT

=SQLEXEC(nhand,ssql)



*----------------------- &&2014.07.03

TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_commission')
		insert into report_lookup values ('佣金統計報表', '佣金統計報表', 'do form form\fr_commission', 1, 40000 , '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)

&&Lihong 2021.09.26 增加供應商設定
TEXT TO ssql noshow
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_vendor')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'setup_vendor', '          供應商設定', '         Setup Vendor', 930, 1, 1) 
ENDTEXT
=SQLEXEC(nhand,ssql)


&&Lihong 2021.09.26 改到刪除之後
*!*	TEXT TO ssql noshow

*!*		if not exists (select * from roleaccess where code = 'fr_commission')
*!*			insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
*!*			 values (322, 'fr_commission', '          佣金統計報表', '         佣金統計報表', 3200, 1, 1) 

*!*	ENDTEXT

*!*	=SQLEXEC(nhand,ssql)

*----------------------- &&2014.12.01

&&Lihong 2021.09.26 原來322有重複，註釋掉另寫處理重複代碼
&&=SQLEXEC(nhand,"delete from roleaccess where roleaccess_id=322")

&&Lihong 2021.09.26 改到刪除之後
TEXT TO ssql NOSHOW &&7200及多個用戶數據庫未有，roleaccess_id322改為max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_commission')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_commission', '          佣金統計報表', '         佣金統計報表', 3200, 1, 1) 
ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_section_daily')
		insert into report_lookup values ('日期時段統計報表(Excel)', '日期時段統計報表(Excel)', 'do form form\fr_section_daily', 1, 215 , '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id322->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_section_daily')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_section_daily', '          日期時段統計報表', '         日期時段統計報表', 2155, 1, 1) 

ENDTEXT

=SQLEXEC(nhand,ssql)


*-------------------

TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_booking')
		insert into report_lookup values ('訂檯統計報表', '訂檯統計報表', 'do form form\fr_booking', 1, 50000 , '', '1,2,3,4,5,6,7,8,9')


ENDTEXT 

=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 7200roleaccess_id322與"日期時段統計報表"roleaccess_id同，改為max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_booking')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_booking', '          訂檯統計報表', '         訂檯統計報表', 3300, 1,1) 

ENDTEXT

=SQLEXEC(nhand,ssql)



*2016-4-5
TEXT TO ssql NOSHOW
	if not exists (select * from report_lookup where cmd = 'do form form\fr_yearly')
		insert into report_lookup values ('全年營業報表', '全年營業報表', 'do form form\fr_yearly', 1, 51000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id400->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_yearly')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_yearly', '          全年營業報表', '         全年營業報表', 3400, 1,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)



*2016-4-6
TEXT TO ssql NOSHOW
	if not exists (select * from report_lookup where cmd = 'do form form\fr_invl_saichuen')
		insert into report_lookup values ('每日賬單明細報表', '每日賬單明細報表', 'do form form\fr_invl_saichuen', 0, 52000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id401->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_invl_saichuen')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_invl_saichuen', '          每日賬單明細報表', '         每日賬單明細報表', 3500, 0,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)



*2016-4-7
TEXT TO ssql NOSHOW
	if not exists (select * from report_lookup where cmd = 'do form form\fr_sa_cate_saichuen')
		insert into report_lookup values ('銷售排行報表', '銷售排行報表', 'do form form\fr_sa_cate_saichuen', 0, 53000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id402->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_sa_cate_saichuen')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_sa_cate_saichuen', '          銷售排行報表', '         銷售排行報表', 3600, 0,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)



*2016-4-7
TEXT TO ssql NOSHOW 
	if not exists (select * from report_lookup where cmd = 'do form form\fr_sa_hourly_saichuen')
		insert into report_lookup values ('分時營業之總結報表', '分時營業之總結報表', 'do form form\fr_sa_hourly_saichuen', 0, 54000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id403->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_sa_hourly_saichuen')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_sa_hourly_saichuen', '          分時營業之總結報表', '         分時營業之總結報表', 3700, 0,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)



*2016-4-8
TEXT TO ssql NOSHOW
	if not exists (select * from report_lookup where cmd = 'do form form\fr_sa_daily_saichuen')
		insert into report_lookup values ('每日營業之總結報表', '每日營業之總結報表', 'do form form\fr_sa_daily_saichuen', 0, 55000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id404->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_sa_daily_saichuen')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_sa_daily_saichuen', '          每日營業之總結報表', '         每日營業之總結報表', 3800, 0,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW &&Lihong 2021.09.26 roleaccess_id405->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_macau_pass')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_macau_pass', '          澳門通報表', '         澳門通報表', 3900, 0,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
	if not exists (select * from report_lookup where cmd = 'do form form\fr_macau_pass')
		insert into report_lookup values ('澳門通報表', '澳門通報表', 'do form form\fr_macau_pass', 0, 56000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)

&&Lihong 2022.03.11
IF VARTYPE(__special_customer)#"U" AND upper(__special_customer) = "MS"
TEXT TO ssql NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invcln_reprint')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'invcln_reprint', '          清機報表', '         Closing Report', 4000, 1,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)
TEXT TO ssql noshow
	if not exists (select * from report_lookup where cmd = 'do form form\invcln_reprint')
		insert into report_lookup values ('清機報表', 'Closing Report', 'do form form\invcln_reprint', 0, 57000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)
ENDIF 


********************* chris : report add here 



*--------------------

TEXT TO ssql noshow		&& 2013.01.08  &&Lihong 2021.09.26  roleaccess_id320->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'clear_subtable')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'clear_subtable', '          清空分檯', '          清空分檯', 250, 1, 1,320,0) 

ENDTEXT

=SQLEXEC(nhand,ssql)

&&Lihong 2021.09.26 註釋掉另寫處理重複代碼
&&=SQLEXEC(nhand,"update roleaccess set roleaccess_id=320,updateno=321 where code='clear_subtable' and roleaccess_id=318 ")		&& fix


TEXT TO ssql noshow		&& 2014.05.14  &&Lihong 2021.09.26  roleaccess_id321->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invinfo_show_amt')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'invinfo_show_amt', '          顯示未清機金額', '           顯示未清機金額', 875, 1,0,321,0) 

ENDTEXT

=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow		&& 2014.07.04  &&Lihong 2021.09.26  roleaccess_id323->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invinfo_edit_seller')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'invinfo_edit_seller', '          更改營業員', '           更改營業員', 855, 1,0,323,0) 

ENDTEXT

=SQLEXEC(nhand,ssql)




TEXT TO ssql noshow		&& 2019.04.16  &&Lihong 2021.09.26  roleaccess_id325->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_modifier_fast')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_modifier_fast', '            特別處理批量修改', '           特別處理批量修改', 955, 1,0,1060,0) 

ENDTEXT

=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow		&&Lihong 2019.08.16  &&Lihong 2021.09.26  roleaccess_id328->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_cut_order')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_cut_order', '          截單時間設置', '          截單時間設置', 958, 1,0,2116,0) 
ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow		&&Lihong 2019.08.16  &&Lihong 2021.09.26  roleaccess_id331->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_item_catecopy')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_item_catecopy', '          菜式按種類複製', '          菜式按種類複製', 961, 1,0,2118,0) 
ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow		&&Lihong 2019.08.16  &&Lihong 2021.09.26  roleaccess_id335->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_menu_select')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_menu_select', '          選擇餐牌', '          Select Menu', 1410, 1,1,2480,0) 
ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow		&& 2019.12.09 &&fly_add 是否即時追加權限  &&Lihong 2021.09.26  roleaccess_id342->max+1

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_bat_printer')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_bat_printer', '          列印批量設置', '           Printing Batch Setting', 964, 1,0,3135,0) 

ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2021.08.13 多價格
TEXT TO ssql NOSHOW  &&Lihong 2021.09.26  roleaccess_id345->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_cate_price')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_cate_price', '          種類價格設定', '          Category Price Setting', 967, 1,0,3459,0) 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2019.11.04
TEXT TO ssql noshow 
CREATE TABLE [dbo].[tables_qrcode_info](
	[id] [uniqueidentifier] NOT NULL,
	[tableno] [varchar](100) NULL,
	[sub_id] [int] NULL,
	[check_valid] [varchar](50) NULL,
	[check_type] [int] NULL,
	[suspend] [bit] NULL,
	[active] [bit] NULL,
	[create_by] [int] NULL,
	[create_date] [datetime] NULL,
	[edit_by] [int] NULL,
	[edit_date] [datetime] NULL,
	[void_by] [int] NULL,
	[void_date] [datetime] NULL,
 CONSTRAINT [pk_tables_qrcode_info] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2019.11.04
TEXT TO ssql NOSHOW  &&Lihong 2021.09.26  roleaccess_id338->max+1
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_table_qrcode')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'setup_table_qrcode', '          餐檯QRcode', '          Tables QRcode', 1420, 1,0,2810,0) 
ENDTEXT
=SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table role add updateno int null")>0			&& role

	=SQLEXEC(nhand,"UPDATE role SET updateno=id+1")

ENDIF

&&Lihong 2021.09.26 註釋掉另寫處理重複代碼
*!*	TEXT TO ssql noshow		&&修正 317     2014.09.29

*!*	if exists( select * from roleaccess where roleaccess_id=317 and code='fr_membinvg') 
*!*	begin
*!*	declare @nid int
*!*	select @nid=max(roleaccess_id)+1 from roleaccess
*!*	update roleaccess set roleaccess_id=@nid where roleaccess_id=317 and code='fr_membinvg'
*!*	end


*!*	ENDTEXT

*!*	=SQLEXEC(nhand,ssql)




*---------確保admin擁有所有的權限  （如有新增權限，請放在此前)

IF SQLEXEC(nhand,"select roleaccess_id from roleaccess order by roleaccess_id","cun_tmp")>0
	_access=""
	SELECT cun_tmp
	SCAN
		
		_access=_access+ALLTRIM(STR(roleaccess_id))+","
	
	ENDSCAN
	
	IF SQLEXEC(nhand,"select access from role where id=0","cun_tmp")>0
	
		IF  ALLTRIM(cun_tmp.access)<>_access
		
			_updateno=getupdateno("role")		
		
			=SQLEXEC(nhand,"update role set access=?_access,updateno=?_updateno where id=0")
	
	
		ENDIF
		
		
		
	ENDIF
	


ENDIF
*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


*------------------------------------------------------------------------------------
=SQLEXEC(nhand,"update system_setting set cvalue=default_value where type=3 and cvalue='' ")		&&修正setting的數據問題

TEXT TO ssql noshow

if not exists(select type from sys_options where type='item_daily' ) 
 insert into sys_options(defavalue,type,desccn) values ('','item_daily','')
 
ENDTEXT
=SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table inv add oct_invID int null")>0				&&2010.08.06 

	
	=SQLEXEC(nhand,"update inv set oct_invID=id where octopus=1")
	

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))


TEXT TO ssql noshow
	declare @max_id as int
	select @max_id=max(oct_invID) from inv 

	if not exists(select type from sys_options where type='oct_inv' ) 
	 insert into sys_options(defavalue,type,desccn) values (@max_id,'oct_inv','')
ENDTEXT
=SQLEXEC(nhand,ssql)







IF SQLEXEC(nhand,"alter table autodisc add member_type int null")>0		&&2010.08.12

	=SQLEXEC(nhand,"update autodisc set member_type=0")

ENDIF

*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))

=SQLEXEC(nhand,"update item set invlst_print=0 where invlst_print is null")		&&2010.09.10

=SQLEXEC(nhand,"update item set invlst_noprint=0 where invlst_noprint is null")


*---------------------------------------- history inv


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



*message_log 加 分單
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 196)
	insert into message_log values (196, '分單', 'Order Split', '_order_split', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO cmd noshow
	if not exists (select id from message_log where id = 197)
	insert into message_log values (197, '分單成功', 'Order Split Success', '_order_split_ok', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)


TEXT TO cmd noshow
	if not exists (select id from message_log where id = 198)
	insert into message_log values (198, '分單不成功', 'Order Split Fail', '_order_split_fail', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&Lihong 2020.05.18
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 199)
	insert into message_log values (199, '修改雲端會員', 'Edit Cloud Member', '_edit_cloud_member', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

=SQLEXEC(nhand,"alter table tables alter column inv_id int null")		&&2010.10.20


IF SQLEXEC(nhand,"alter table inv add split int null")>0		&&2010.10.21

	=SQLEXEC(nhand,"update inv set split=0")

ENDIF



IF SQLEXEC(nhand,"alter table tables add split int null")>0

	=SQLEXEC(nhand,"update tables set split=0")

ENDIF

TEXT TO ssql noshow

alter table disc  add begtime char(5) null,endtime char(5) null,
	day1 bit null,
	day2 bit null,
	day3 bit null,
	day4 bit null,
	day5 bit null,
	day6 bit null,
	day7 bit null,
	holiday bit null

ENDTEXT


IF SQLEXEC(nhand,ssql)>0		&&2010.10.27


	=SQLEXEC(nhand,"update disc set begtime='00:00',endtime='23:59',day1=1,day2=1,day3=1,day4=1,day5=1,day6=1,day7=1,holiday=1")
	

ENDIF


IF SQLEXEC(nhand,"alter table disc add ex_holiday bit null")>0

	
	=SQLEXEC(nhand,"update disc set ex_holiday=0")


ENDIF

IF SQLEXEC(nhand,"alter table disc add minamt numeric (12,2)")>0

	
	=SQLEXEC(nhand,"update disc set minamt=0.00")


ENDIF


IF SQLEXEC(nhand,"alter table order_disc add minamt numeric (12,2)")>0		&&2010.11.04

	
	=SQLEXEC(nhand,"update order_disc set minamt=0.00")


ENDIF


IF SQLEXEC(nhand,"alter table order_itemdisc add minamt numeric (12,2)")>0		&&2010.11.04

	
	=SQLEXEC(nhand,"update order_itemdisc set minamt=0.00")


ENDIF

IF SQLEXEC(nhand,"alter table order_main add split int null")>0

	=SQLEXEC(nhand,"update order_main set split=0")

ENDIF

&&2010.11.26
IF SQLEXEC(nhand,"alter table tables add item_warning bit null,warning_begtime char(5) null,warning_endtime char(5) null ")>0

	=SQLEXEC(nhand,"update tables set item_warning =0,warning_begtime ='00:00',warning_endtime ='00:00' ")

ENDIF

IF SQLEXEC(nhand,"alter table item add item_warning bit null,warning_begtime char(5) null,warning_endtime char(5) null,warning_inMinute int null")>0

	=SQLEXEC(nhand,"update tables set item_warning =0,warning_begtime ='00:00',warning_endtime ='00:00',warning_inMinute =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add item_warning bit null,warning_begtime char(5) null,warning_endtime char(5) null,warning_inMinute int null")>0

	=SQLEXEC(nhand,"update tables set item_warning =0,warning_begtime ='00:00',warning_endtime ='00:00',warning_inMinute =0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add item_warning bit null,warning_begtime char(5) null,warning_endtime char(5) null,warning_inMinute int null ")>0

	=SQLEXEC(nhand,"update order_detail set item_warning =0,warning_begtime ='00:00',warning_endtime ='00:00',warning_inMinute =0 ")

ENDIF



* -------------------------- 2011.01.23

=SQLEXEC(nhand,"select top 0 * into order_main_bak from order_main")
=SQLEXEC(nhand,"select top 0 * into order_detail_bak from order_detail")
=SQLEXEC(nhand,"select top 0 * into order_modi_bak from order_modi")
=SQLEXEC(nhand,"select top 0 * into order_disc_bak from order_disc")
=SQLEXEC(nhand,"select top 0 * into order_itemdisc_bak from order_itemdisc")
=SQLEXEC(nhand,"select top 0 * into order_tax_bak from order_tax")
=SQLEXEC(nhand,"select top 0 * into order_itemdept_bak from order_itemdept")

=SQLEXEC(nhand,"create table order_update (id int,item_qty int,last_update datetime)")

*-------------------------------------------------------

TEXT TO ssql noshow			&&2011.02.07


CREATE TABLE  [change_price](
	[id] [int] NULL,
	[order_ID] [int] NULL,
	[inv_id] [int] NULL,
	[tableno] [char](10) NULL,
	[datetime] [datetime] NULL,
	[belongdate] [datetime] NULL,
	[item_id] [int] NULL,
	[org_price] [numeric](12, 2) NULL,
	[to_price] [numeric](12, 2) NULL,
	[adduser] [nchar](20) NULL,
	[run_mode] [char](10) NULL,
	[station] [nvarchar](30) null,
	[action] [nvarchar](200) null
) 

ENDTEXT

IF SQLEXEC(nhand,ssql)>0
	IF SQLEXEC(nhand,"select * from sys_log where log_id=95 order by datetime","cun_tmp")>0
		
		SELECT cun_tmp
		SCAN

				
			TEXT TO ssql noshow

					DECLARE @max_id int
					SELECT @max_id=ISNULL(MAX(id),0)+1 FROM change_price
			
				INSERT INTO change_price
				           ([id]
				           ,[order_ID]
				           ,[inv_id]
				           ,[tableno]
				           ,[datetime]
				           ,[belongdate]
				           ,[item_id]
				           ,[org_price]
				           ,[to_price]
				           ,[adduser]
				           ,[run_mode]
				           ,[station]
				           ,action)
				     VALUES
				           (@max_id
				           ,0
				           ,0
				           ,''
				           ,?cun_tmp.datetime
				           ,?TTOD(cun_tmp.datetime)
				           ,0
				           ,0
				           ,0
				           ,?cun_tmp.adduser
				           ,''
				           ,?cun_tmp.station
				           ,?cun_tmp.action)

			
			ENDTEXT
			
			=SQLEXEC(nhand,ssql)
		
		
		
		ENDSCAN
	
	ENDIF
	
ENDIF

IF SQLEXEC(nhand,"alter table sys_user add info_day int null")>0

	=SQLEXEC(nhand,"update sys_user set info_day=0")

ENDIF

*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

TEXT TO cmd NOSHOW TEXTMERGE 
	create procedure dbo.create_inv_view as 
	begin
		ErrorHandle:
	end
ENDTEXT
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW TEXTMERGE 
	ALTER procedure [dbo].[create_inv_view]
	@nRandomStr nvarchar(50), 
	@dStart_Date datetime, 
	@dEnd_Date datetime
	as
	begin
		declare @index int
		declare @nstr nvarchar(200)
		declare @nstr_inv nvarchar(200)
		declare @nstr_inv1 nvarchar(4000)
		declare @nstr_inv2 nvarchar(4000)
		declare @nstr_inv3 nvarchar(4000)
		declare @nstr_inv4 nvarchar(4000)
		declare @nstr_inv5 nvarchar(4000)
		declare @nstr_inv6 nvarchar(4000)
		declare @nstr_inv_disc nvarchar(200)
		declare @nstr_inv_disc1 nvarchar(4000)
		declare @nstr_inv_disc2 nvarchar(4000)
		declare @nstr_inv_disc3 nvarchar(4000)
		declare @nstr_inv_disc4 nvarchar(4000)
		declare @nstr_inv_disc5 nvarchar(4000)
		declare @nstr_inv_disc6 nvarchar(4000)		
		declare @nstr_inv_detail nvarchar(200)
		declare @nstr_inv_detail1 nvarchar(4000)
		declare @nstr_inv_detail2 nvarchar(4000)
		declare @nstr_inv_detail3 nvarchar(4000)
		declare @nstr_inv_detail4 nvarchar(4000)
		declare @nstr_inv_detail5 nvarchar(4000)
		declare @nstr_inv_detail6 nvarchar(4000)
		declare @nstr_inv_itemdisc nvarchar(200)
		declare @nstr_inv_itemdisc1 nvarchar(4000)
		declare @nstr_inv_itemdisc2 nvarchar(4000)
		declare @nstr_inv_itemdisc3 nvarchar(4000)
		declare @nstr_inv_itemdisc4 nvarchar(4000)
		declare @nstr_inv_itemdisc5 nvarchar(4000)
		declare @nstr_inv_itemdisc6 nvarchar(4000)
		declare @nstr_inv_modi nvarchar(200)
		declare @nstr_inv_modi1 nvarchar(4000)
		declare @nstr_inv_modi2 nvarchar(4000)
		declare @nstr_inv_modi3 nvarchar(4000)
		declare @nstr_inv_modi4 nvarchar(4000)
		declare @nstr_inv_modi5 nvarchar(4000)
		declare @nstr_inv_modi6 nvarchar(4000)

		declare @nstr_inv_pay nvarchar(200)
		declare @nstr_inv_pay1 nvarchar(4000)
		declare @nstr_inv_pay2 nvarchar(4000)
		declare @nstr_inv_pay3 nvarchar(4000)
		declare @nstr_inv_pay4 nvarchar(4000)
		declare @nstr_inv_pay5 nvarchar(4000)
		declare @nstr_inv_pay6 nvarchar(4000)


		declare @name varchar(200)
		declare @ninvName varchar(1000)
		set @index = 1
		set @nstr_inv = ''
		set @nstr_inv1 = ''
		set @nstr_inv2 = ''
		set @nstr_inv3 = ''
		set @nstr_inv4 = ''
		set @nstr_inv5 = ''
		set @nstr_inv6 = ''
		set @nstr_inv_disc = ''
		set @nstr_inv_disc1 = ''
		set @nstr_inv_disc2 = ''
		set @nstr_inv_disc3 = ''
		set @nstr_inv_disc4 = ''
		set @nstr_inv_disc5 = ''
		set @nstr_inv_disc6 = ''
		set @nstr_inv_detail = ''
		set @nstr_inv_detail1 = ''
		set @nstr_inv_detail2 = ''
		set @nstr_inv_detail3 = ''
		set @nstr_inv_detail4 = ''
		set @nstr_inv_detail5 = ''
		set @nstr_inv_detail6 = ''
		set @nstr_inv_itemdisc= ''
		set @nstr_inv_itemdisc1 = ''
		set @nstr_inv_itemdisc2 = ''
		set @nstr_inv_itemdisc3 = ''
		set @nstr_inv_itemdisc4 = ''
		set @nstr_inv_itemdisc5 = ''
		set @nstr_inv_itemdisc6 = ''		

		set @nstr_inv_modi = ''
		set @nstr_inv_modi1 = ''
		set @nstr_inv_modi2 = ''	
		set @nstr_inv_modi3 = ''	
		set @nstr_inv_modi4 = ''	
		set @nstr_inv_modi5 = ''	
		set @nstr_inv_modi6 = ''	
			
		set @nstr_inv_pay = ''
		set @nstr_inv_pay1 = ''
		set @nstr_inv_pay2 = ''	
		set @nstr_inv_pay3 = ''	
		set @nstr_inv_pay4 = ''	
		set @nstr_inv_pay5 = ''	
		set @nstr_inv_pay6 = ''	

		set @ninvName = 'inv_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		set @ninvName = 'inv_disc_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		set @ninvName = 'inv_detail_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		set @ninvName = 'inv_itemdisc_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		
		set @ninvName = 'inv_modi_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
				
		set @ninvName = 'inv_pay_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	


		declare query_inv_divide cursor for 
		select name from inv_divide (nolock) where 
			not (@dStart_Date > start_time and @dStart_Date > end_time) and
			not (@dEnd_Date < start_time and @dEnd_Date <end_time) order by id
		
		open query_inv_divide
		fetch next from query_inv_divide into @name
		while @@fetch_status = 0
		begin					
			set @nstr_inv = ' union all select * from dbo.hinv_' + rtrim(ltrim(@name)) + ' '		
			set @nstr_inv_disc = ' union all select * from dbo.hinv_disc_' + rtrim(ltrim(@name)) + ' '
			set @nstr_inv_detail = ' union all select * from hinv_detail_' + rtrim(ltrim(@name)) + ' '
			set @nstr_inv_itemdisc = ' union all select * from hinv_itemdisc_' + rtrim(ltrim(@name)) + ' '
			set @nstr_inv_modi = ' union all select * from hinv_modi_' + rtrim(ltrim(@name)) + ' '	
			set @nstr_inv_pay = ' union all select * from hinv_pay_' + rtrim(ltrim(@name)) + ' '	
			
			if @index between 1 and 40
			begin				
				set @nstr_inv1 = @nstr_inv1 + @nstr_inv
				set @nstr_inv_disc1 = @nstr_inv_disc1 + @nstr_inv_disc
				set @nstr_inv_detail1 = @nstr_inv_detail1 + @nstr_inv_detail
				set @nstr_inv_itemdisc1 = @nstr_inv_itemdisc1 + @nstr_inv_itemdisc
				set @nstr_inv_modi1 = @nstr_inv_modi1 + @nstr_inv_modi
				set @nstr_inv_pay1 = @nstr_inv_pay1 + @nstr_inv_pay

			end
			if @index between 41 and 80
			begin
				set @nstr_inv2 = @nstr_inv2 + @nstr_inv
				set @nstr_inv_disc2 = @nstr_inv_disc2 + @nstr_inv_disc
				set @nstr_inv_detail2 = @nstr_inv_detail2 + @nstr_inv_detail
				set @nstr_inv_itemdisc2 = @nstr_inv_itemdisc2 + @nstr_inv_itemdisc
				set @nstr_inv_modi2 = @nstr_inv_modi2 + @nstr_inv_modi
				set @nstr_inv_pay2 = @nstr_inv_pay2 + @nstr_inv_pay
				
			end
			if @index between 81 and 120
			begin
				set @nstr_inv3 = @nstr_inv3 + @nstr_inv
				set @nstr_inv_disc3 = @nstr_inv_disc3 + @nstr_inv_disc
				set @nstr_inv_detail3 = @nstr_inv_detail3 + @nstr_inv_detail
				set @nstr_inv_itemdisc3 = @nstr_inv_itemdisc3 + @nstr_inv_itemdisc
				set @nstr_inv_modi3 = @nstr_inv_modi3 + @nstr_inv_modi
				set @nstr_inv_pay3 = @nstr_inv_pay3 + @nstr_inv_pay

			end
			if @index between 121 and 160
			begin
				set @nstr_inv4 = @nstr_inv4 + @nstr_inv
				set @nstr_inv_disc4 = @nstr_inv_disc4 + @nstr_inv_disc
				set @nstr_inv_detail4 = @nstr_inv_detail4 + @nstr_inv_detail
				set @nstr_inv_itemdisc4 = @nstr_inv_itemdisc4 + @nstr_inv_itemdisc
				set @nstr_inv_modi4 = @nstr_inv_modi4 + @nstr_inv_modi
				set @nstr_inv_pay4 = @nstr_inv_pay4 + @nstr_inv_pay
				
			end
			if @index between 161 and 200
			begin
				set @nstr_inv5 = @nstr_inv5 + @nstr_inv
				set @nstr_inv_disc5 = @nstr_inv_disc5 + @nstr_inv_disc
				set @nstr_inv_detail5 = @nstr_inv_detail5 + @nstr_inv_detail
				set @nstr_inv_itemdisc5 = @nstr_inv_itemdisc5 + @nstr_inv_itemdisc
				set @nstr_inv_modi5 = @nstr_inv_modi5 + @nstr_inv_modi
				set @nstr_inv_pay5 = @nstr_inv_pay5 + @nstr_inv_pay
				
			end
			if @index between 201 and 240
			begin
				set @nstr_inv6 = @nstr_inv6 + @nstr_inv
				set @nstr_inv_disc6 = @nstr_inv_disc6 + @nstr_inv_disc
				set @nstr_inv_detail6 = @nstr_inv_detail6 + @nstr_inv_detail
				set @nstr_inv_itemdisc6 = @nstr_inv_itemdisc6 + @nstr_inv_itemdisc
				set @nstr_inv_modi6 = @nstr_inv_modi6 + @nstr_inv_modi
				set @nstr_inv_pay6 = @nstr_inv_pay6 + @nstr_inv_pay

				
			end
			set @index = @index + 1		
			fetch next from query_inv_divide into @name	
		end
		
		set @nstr_inv = 'create view ' + 'inv_view' + @nRandomStr +  ' as select * from dbo.inv '
		set @nstr_inv_disc = 'create view ' + 'inv_disc_view' + @nRandomStr +  ' as select * from dbo.inv_disc '
		set @nstr_inv_detail = 'create view ' + 'inv_detail_view' + @nRandomStr +  ' as select * from dbo.inv_detail '
		set @nstr_inv_itemdisc = 'create view ' + 'inv_itemdisc_view' + @nRandomStr +  ' as select * from dbo.inv_itemdisc '
		set @nstr_inv_modi = 'create view ' + 'inv_modi_view' + @nRandomStr +  ' as select * from dbo.inv_modi '
		set @nstr_inv_pay = 'create view ' + 'inv_pay_view' + @nRandomStr +  ' as select * from dbo.pay_detail'
		
		
		close query_inv_divide 
		deallocate query_inv_divide		
		execute(@nstr_inv + @nstr_inv1 + @nstr_inv2 + @nstr_inv3 + @nstr_inv4 + @nstr_inv5 + @nstr_inv6)
		if @@error <> 0
		begin
			goto ErrorHandle
		end
		execute(@nstr_inv_disc + @nstr_inv_disc1 + @nstr_inv_disc2 + @nstr_inv_disc3 + @nstr_inv_disc4 + @nstr_inv_disc5 + @nstr_inv_disc6)
		if @@error <> 0
		begin
			goto ErrorHandle
		end
		execute(@nstr_inv_detail + @nstr_inv_detail1 + @nstr_inv_detail2 + @nstr_inv_detail3 + @nstr_inv_detail4 + @nstr_inv_detail5 + @nstr_inv_detail6)
		if @@error <> 0
		begin		
			goto ErrorHandle
		end
		execute(@nstr_inv_itemdisc + @nstr_inv_itemdisc1 + @nstr_inv_itemdisc2 + @nstr_inv_itemdisc3 + @nstr_inv_itemdisc4 + @nstr_inv_itemdisc5 + @nstr_inv_itemdisc6)
		if @@error <> 0
		begin		
			goto ErrorHandle
		end
		execute(@nstr_inv_modi + @nstr_inv_modi1 + @nstr_inv_modi2 + @nstr_inv_modi3 + @nstr_inv_modi4 + @nstr_inv_modi5 + @nstr_inv_modi6)
		if @@error <> 0
		begin		
			goto ErrorHandle
		END 
		
		execute(@nstr_inv_pay + @nstr_inv_pay1 + @nstr_inv_pay2 + @nstr_inv_pay3 + @nstr_inv_pay4 + @nstr_inv_pay5 + @nstr_inv_pay6)
		if @@error <> 0
		begin		
			goto ErrorHandle
		END 
		
		ErrorHandle:
	end
ENDTEXT
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW TEXTMERGE 
	create procedure dbo.drop_inv_view as 
	begin
		ErrorHandle:
	end
ENDTEXT
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW TEXTMERGE 
	ALTER procedure [dbo].[drop_inv_view]
	@nRandomStr nvarchar(50)
	as
	begin
		declare @nstr nvarchar(4000)
		declare @ninvName nvarchar(1000)
		set @ninvName = 'inv_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		
		set @ninvName = 'inv_disc_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		
		set @ninvName = 'inv_detail_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		
		set @ninvName = 'inv_itemdisc_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	
		
		set @ninvName = 'inv_modi_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	

		set @ninvName = 'inv_pay_view' + @nRandomStr
		if exists(select * from sysobjects where name=@ninvName )
		begin
			set @nstr = 'drop view ' + @ninvName
			exec sp_executesql @nstr		
			if @@error <> 0
			begin
				goto ErrorHandle
			end
		end	

		ErrorHandle:
	end 
ENDTEXT
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW TEXTMERGE 
	CREATE TABLE inv_divide(
		id int,
		name nvarchar(50),
		start_time datetime,
		end_time datetime
	)				
ENDTEXT 
=SQLEXEC(nhand, cmd)

*- - - - - - - - - - - - - - - -


*frm_wait.showmessage("data auto update ..." + ALLTRIM(STR(LINENO( ))))



TEXT TO csql noshow																			&& 2011.02.22	sys_options 增加 askno2 用於快餐方式 問叫號第二套

	if not exists (select type from sys_options where type='askno2')
	insert into sys_options (defavalue,type,active,disporder) values (999,'askno2',1,0)

ENDTEXT

SQLEXEC(nhand,csql)


TEXT TO csql noshow
	update sys_options set defavalue=(select default_value from system_setting where pcode='__auto_askno_begin')
		where type='askno2' and defavalue=999
ENDTEXT
SQLEXEC(nhand,csql)



=SQLEXEC(nhand,"alter table item drop column askvm")
=SQLEXEC(nhand,"alter table item_backup drop column askvm")
=SQLEXEC(nhand,"alter table order_detail drop column vm")
=SQLEXEC(nhand,"alter table order_detail_bak drop column vm")


IF SQLEXEC(nhand,"alter table order_main add noautoDisc bit null")>0		&& 2011.03.16  

	=SQLEXEC(nhand,"update order_main set noautoDisc =0")


ENDIF

IF SQLEXEC(nhand,"alter table order_main_bak add noautoDisc bit null")>0		&& 2011.03.16  

	=SQLEXEC(nhand,"update order_main_bak set noautoDisc =0")
	

ENDIF

TEXT TO ssql noshow

delete from order_detail where id in (select id from order_main where split>0 and split not in (select split from tables))
delete  from order_main where split>0 and split not in (select split from tables)

ENDTEXT

=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow			&&2011.04.11


CREATE TABLE  [inv_reprint](
	[inv_id] [int] NULL,
	[invamt] [numeric] (12,2) null,
	[datetime] [datetime] NULL,
	[adduser] [nchar](20) NULL,
	[station] [nvarchar](30) null
	
	
) 

ENDTEXT

=SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table order_function alter column desccn nvarchar(50) ")
=SQLEXEC(nhand,"alter table order_function alter column descen nvarchar(50) ")

=SQLEXEC(nhand,"alter table table_function alter column desccn nvarchar(50) ")
=SQLEXEC(nhand,"alter table table_function alter column descen nvarchar(50) ")


IF SQLEXEC(nhand,"alter table modifier add price_m5 numeric(12,2) null")>0		&& 2011.04.26
	
	=SQLEXEC(nhand,"update modifier set price_m5=0.00")

ENDIF


IF SQLEXEC(nhand,"alter table modifier add price_m6 numeric(12,2) null")>0
	
	=SQLEXEC(nhand,"update modifier set price_m6=0.00")

ENDIF

TEXT TO ssql noshow

	if not exists (select id from modifier_def where id=6)
	insert into modifier_def (active,id,desccn,descen) values (1,6,'','')

ENDTEXT

=SQLEXEC(nhand,ssql)

IF SQLEXEC(nhand,"alter table item add price4 numeric(12,2) null")>0		&& 2011.05.03

	
	=SQLEXEC(nhand,"update item set price4=0.00")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add price4 numeric(12,2) null")>0		&& 2011.05.03

	=SQLEXEC(nhand,"update item_backup set price4=0.00")

ENDIF

IF SQLEXEC(nhand,"alter table item add joinitem bit null")>0		&& 2011.05.03

	
	=SQLEXEC(nhand,"update item set joinitem=0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add joinitem bit null")>0		&& 2011.05.03

	
	=SQLEXEC(nhand,"update item_backup set joinitem=0")

ENDIF


IF SQLEXEC(nhand,"alter table order_detail add pre_price numeric(12,2) null")>0		&& 2011.05.05

	
	=SQLEXEC(nhand,"update order_detail set pre_price =0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail_bak add pre_price numeric(12,2) null")>0		&& 2011.05.05

	
	=SQLEXEC(nhand,"update order_detail_bak set pre_price =0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add sub_amt numeric(12,2) null")>0		&& 2011.05.05

	
	=SQLEXEC(nhand,"update order_detail set sub_amt =0")

ENDIF

IF SQLEXEC(nhand,"alter table order_detail_bak add sub_amt numeric(12,2) null")>0		&& 2011.05.05

	
	=SQLEXEC(nhand,"update order_detail_bak set sub_amt =0")

ENDIF




*=SQLEXEC(nhand,"alter table cp_log add modi_id int null,modi_amount numeric(12,2) null")		&& 2011.06.08

=SQLEXEC(nhand,"alter table order_print_main alter column remark nvarchar(250) null ")		



IF SQLEXEC(nhand,"alter table item add outletSrv bit null")>0		&& 2011.06.10 item 是否按outlet收取服務費
	
	=SQLEXEC(nhand,"update item set outletSrv=1")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add outletSrv bit null")>0		&& 2011.06.10  是否按outlet收取服務費
	
	=SQLEXEC(nhand,"update item_backup set outletSrv=1")

ENDIF

=SQLEXEC(nhand,"alter table cp_log drop column modi_id")		&& 2011.06.14
=SQLEXEC(nhand,"alter table cp_log drop column modi_amount")		&& 2011.06.14


IF SQLEXEC(nhand,"alter table modi_clean add price_m5 numeric(12,2) null")>0		&& 2011.06.27
	
	=SQLEXEC(nhand,"update modi_clean set price_m5=0.00")

ENDIF


IF SQLEXEC(nhand,"alter table modi_clean add price_m6 numeric(12,2) null")>0
	
	=SQLEXEC(nhand,"update modi_clean set price_m6=0.00")

ENDIF


*=SQLEXEC(nhand,"alter table order_main alter column remark nvarchar(250) null ")			&&2011.07.12

*!*	=SQLEXEC(nhand,"alter table inv alter column remark nvarchar(250) null ")			&&2011.07.12

*!*	=SQLEXEC(nhand,"alter table inv_print_main alter column remark nvarchar(250) null ")			&&2011.07.12




IF SQLEXEC(nhand,"alter table member add updateno int null")>0		&& 2011.07.13

	=SQLEXEC(nhand,"update member set updateno=id")
	

ENDIF

IF SQLEXEC(nhand,"alter table member_point add updateno int null")>0

	=SQLEXEC(nhand,"update member_point set updateno=id")
	

ENDIF

IF SQLEXEC(nhand,"alter table member_type add updateno int null")>0

	=SQLEXEC(nhand,"update member_type set updateno=id")
	

ENDIF

IF SQLEXEC(nhand,"alter table member alter column id int null")<0

		=SQLEXEC(nhand,"ALTER table member ADD tmp int null")
		=SQLEXEC(nhand,"update member set tmp=id")
		=SQLEXEC(nhand,"drop index member.ix_id")
		=SQLEXEC(nhand,"ALTER table member drop column id")
		=SQLEXEC(nhand,"alter table member add id int null")
		=SQLEXEC(nhand,"CREATE NONCLUSTERED INDEX [ix_id] ON [dbo].[member] (	[id] ASC)")
		=SQLEXEC(nhand,"update member set id=tmp")
		=SQLEXEC(nhand,"alter table member drop column tmp")

ENDIF


IF SQLEXEC(nhand,"alter table member_type alter column id int null")<0
		=SQLEXEC(nhand,"ALTER table member_type ADD tmp int null")
		=SQLEXEC(nhand,"update member_type set tmp=id")
		=SQLEXEC(nhand,"ALTER table member_type drop column id")
		=SQLEXEC(nhand,"alter table member_type add id int null")
		=SQLEXEC(nhand,"update member_type set id=tmp")
		=SQLEXEC(nhand,"alter table member_type drop column tmp")

ENDIF


=SQLEXEC(nhand,"create table member_log (id bigint ,inv_id int,member_id int ,amount numeric(12,2),times int,point numeric(12,2),updateno int,[datetime] datetime)")	&& 2011.07.14

IF SQLEXEC(nhand,"alter table order_print_main alter column pid char(20) null")<0		&& 2011.07.15

	=SQLEXEC(nhand,"drop index order_print_main.ix_pid")
	=SQLEXEC(nhand,"alter table order_print_main alter column pid char(20) null")
	=SQLEXEC(nhand,"CREATE NONCLUSTERED INDEX [ix_pid] ON [order_print_main](	[pid] ASC )")
ENDIF


IF SQLEXEC(nhand,"alter table order_print_detail alter column pid char(20) null")<0		&& 2011.07.15

	=SQLEXEC(nhand,"drop index order_print_detail.ix_pid")
	=SQLEXEC(nhand,"alter table order_print_detail alter column pid char(20) null")
	=SQLEXEC(nhand,"CREATE NONCLUSTERED INDEX [ix_pid] ON [order_print_detail](	[pid] ASC )")
ENDIF

=SQLEXEC(nhand,"alter table member_type alter column desccn nvarchar(50) null")
=SQLEXEC(nhand,"alter table member_type alter column descen nvarchar(50) null")


=SQLEXEC(nhand,"alter table sys_log add auth_by nvarchar(200) null, auth_what nvarchar(200) null")		

TEXT TO ssql noshow
CREATE TABLE [pds_schedule](
	[Station_id] [int] NOT NULL,
	[Active] [bit] NULL,
	[Pds_upload] [bit] NULL,
	[Pds_download] [bit] NULL,
	[Run_every_second] [int] NULL,
	[Beep_error] [bit] NULL,
	[Last_pds] [datetime] NULL,
	[StartTime] [char](5) NOT NULL,
	[EndTime] [char](5) NOT NULL,
	[Octopus_from_time] [char](5) NOT NULL,
	[Octopus_to_time] [char](5) NOT NULL,
	[current_table] [nvarchar](50) NULL,
	[last_backup_time] [datetime] NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow

CREATE TABLE [pds_upload_flag](
	[station_id] [int] NULL,
	[station_flag] [int] NULL,
	[hq_flag] [int] NULL,
	[station_edit_time] [datetime] NULL,
	[hq_edit_time] [datetime] NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow

CREATE TABLE [Pre_Tran](
	[TableName] [nvarchar](100) NOT NULL,
	[Direction] [smallint] NOT NULL,
	[Priority] [smallint] NOT NULL,
	[updateno] [int] NOT NULL,
	[RelatedTables] [nvarchar](200) NULL,
	[station_id] [int] NULL,
	[tabledesc] [nvarchar](50) NULL,
	[chk_updateno] [int] NULL,
	[fix_shop_qty] [int] NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow		&& 2011.07.27

CREATE TABLE [dbo].[expense_remark](
	[exp_id] [int] NULL,
	[descdisp] [nvarchar](50) NULL,
	[dispord] [int] NULL
)

ENDTEXT

=SQLEXEC(nhand,ssql)


** for andriod rms6 2011.08.06

IF SQLEXEC(nhand,"Create table tables_flag(id bigint, date datetime)")>0

	=SQLEXEC(nhand,"insert into tables_flag values(1, getdate())")

ENDIF


TEXT TO ssql noshow	
Create Trigger truTables 
       On tables                        
       for Update, insert, delete        
     As                                          

	update tables_flag set id = id + 1, date = GETDATE()


ENDTEXT

=SQLEXEC(nhand,ssql)

*----------------------- for android 




TEXT TO ssql noshow

CREATE TABLE [dbo].[exec_android_data](
	[mark_id] [nvarchar](15) NULL,
	[style] [nvarchar](50) NULL,
	[addtime] [datetime] NULL,
	[station_id] [int] NULL,
	[station_name] [nvarchar](50) NULL,
	[tableno1] [nvarchar](10) NULL,
	[tableno2] [nvarchar](10) NULL,
	[tableno3] [nvarchar](10) NULL,
	[order_id] [int] NULL,
	[inv_id] [int] NULL,
	[flag] [int] NULL,
	[remark1] [nvarchar](200) NULL,
	[remark2] [nvarchar](200) NULL,
	[remark3] [nvarchar](200) NULL,
	[remark4] [nvarchar](200) NULL,
	[language] [nvarchar](10) NULL
) 


ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE TABLE [dbo].[android_order_main](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[inv_id] [int] NOT NULL,
	[tableno] [char](8) NOT NULL,
	[askno] [char](10) NOT NULL,
	[pplcnt] [int] NOT NULL,
	[begintime] [datetime] NOT NULL,
	[orgamt] [numeric](12, 2) NULL,
	[amount] [numeric](12, 2) NOT NULL,
	[modiamt] [numeric](12, 2) NOT NULL,
	[itemdiscamt] [numeric](12, 2) NOT NULL,
	[srvamt] [numeric](12, 2) NOT NULL,
	[taxamt] [numeric](12, 2) NOT NULL,
	[rndamt] [numeric](12, 2) NOT NULL,
	[discamt] [numeric](12, 2) NOT NULL,
	[invamt] [numeric](12, 2) NOT NULL,
	[cost] [numeric](12, 2) NOT NULL,
	[recused] [bit] NOT NULL,
	[printed] [bit] NULL,
	[printtime] [datetime] NULL,
	[memberno] [int] NULL,
	[barcode] [bit] NULL,
	[mincharge_mode] [int] NULL,
	[tel] [nvarchar](20) NULL,
	[address] [nvarchar](250) NULL,
	[used_station] [nvarchar](20) NULL,
	[outlet_id] [int] NULL,
	[void_id] [int] NULL,
	[remark] [varchar](20) NULL,
	[split] [int] NULL,
	[noautoDisc] [bit] NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow

CREATE TABLE [dbo].[android_order_detail](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[uid] [numeric](10, 5) NOT NULL,
	[parent_id] [numeric](10, 5) NULL,
	[item_id] [int] NOT NULL,
	[item_code] [char](8) NULL,
	[cate_id] [int] NULL,
	[descdisp] [nvarchar](50) NOT NULL,
	[qty] [numeric](8, 3) NULL,
	[price] [numeric](12, 2) NOT NULL,
	[orgamt] [numeric](12, 2) NULL,
	[amount] [numeric](12, 2) NOT NULL,
	[real_amount] [numeric](12, 2) NULL,
	[round_amount] [numeric](12, 2) NULL,
	[modi_amount] [numeric](12, 2) NOT NULL,
	[disc_amount] [numeric](12, 2) NOT NULL,
	[srv_per] [numeric](8, 3) NULL,
	[srv_amount] [numeric](12, 2) NOT NULL,
	[tax_per] [numeric](8, 3) NULL,
	[tax_amount] [numeric](12, 2) NOT NULL,
	[xdisc] [numeric](12, 2) NULL,
	[sitem] [bit] NOT NULL,
	[sitem_sub] [bit] NOT NULL,
	[mitem] [bit] NOT NULL,
	[mustmodi] [bit] NOT NULL,
	[hold] [numeric](8, 2) NULL,
	[printed] [bit] NOT NULL,
	[printtime] [datetime] NOT NULL,
	[adduser] [nvarchar](20) NOT NULL,
	[modi_list] [text] NOT NULL,
	[level_id] [int] NOT NULL,
	[drink_qty] [int] NOT NULL,
	[recused] [bit] NULL,
	[xid] [int] NULL,
	[sprinter] [char](4) NULL,
	[remin_times] [int] NULL,
	[remintime] [datetime] NULL,
	[level_disc] [bit] NULL,
	[onlysave] [bit] NULL,
	[ordertime] [datetime] NULL,
	[handwriting] [bit] NULL,
	[hhqty] [int] NULL,
	[hhprice] [numeric](12, 2) NULL,
	[undefine] [bit] NULL,
	[srv_free] [bit] NULL,
	[tax_free] [bit] NULL,
	[mitem_id] [int] NULL,
	[timer_active] [bit] NULL,
	[timer_style] [int] NULL,
	[free_hours] [int] NULL,
	[free_style] [int] NULL,
	[timer_begtime] [char](5) NULL,
	[timer_endtime] [char](5) NULL,
	[timer_mincharge] [int] NULL,
	[timer_disc] [bit] NULL,
	[printer] [varchar](50) NULL,
	[material] [bit] NULL,
	[org_price] [numeric](12, 2) NULL,
	[turnup] [bit] NULL,
	[orgsrv] [bit] NULL,
	[price0] [numeric](12, 2) NULL,
	[tax2] [numeric](6, 2) NULL,
	[pointed] [bit] NULL,
	[points] [numeric](12, 2) NULL,
	[askdept] [bit] NULL,
	[item_warning] [bit] NULL,
	[warning_begtime] [char](5) NULL,
	[warning_endtime] [char](5) NULL,
	[warning_inMinute] [int] NULL,
	[pre_price] [numeric](12, 2) NULL,
	[sub_amt] [numeric](12, 2) NULL,
	[gift] [bit] NULL,
	[giftred] [bit] NULL
	
)

ENDTEXT

=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
CREATE TABLE [dbo].[android_order_modi](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[item_id] [numeric](10, 5) NOT NULL,
	[modi_id] [int] NOT NULL,
	[modi_qty] [int] NULL,
	[modi_price] [numeric](12, 2) NULL,
	[modi_per] [numeric](8, 3) NULL,
	[def_id] [int] NOT NULL,
	[descdisp] [nvarchar](50) NULL,
	[modi_amount] [numeric](12, 2) NULL,
	[dispord] [int] NOT NULL,
	[multqty] [bit] NOT NULL,
	[open_modi] [bit] NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
CREATE TABLE [dbo].[android_order_disc](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[member_id] [int] NULL,
	[disc_id] [int] NOT NULL,
	[disc_type] [int] NULL,
	[disc_per] [numeric](6, 2) NOT NULL,
	[disc_amount] [numeric](12, 2) NULL,
	[dispord] [int] NOT NULL,
	[adduser] [nvarchar](20) NULL,
	[disc_reason] [int] NULL,
	[disc_level] [nvarchar](200) NULL,
	[disc_qty] [int] NULL,
	[autodisc] [bit] NULL,
	[points] [numeric](12, 2) NULL,
	[member_number] [char](10) NULL,
	[member_name] [varchar](30) NULL,
	[minamt] [numeric](12, 2) NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
CREATE TABLE [dbo].[android_order_itemdisc](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[item_id] [numeric](10, 5) NOT NULL,
	[member_id] [int] NULL,
	[disc_id] [int] NOT NULL,
	[disc_type] [int] NULL,
	[disc_per] [numeric](6, 2) NOT NULL,
	[disc_amount] [numeric](12, 2) NULL,
	[dispord] [smallint] NOT NULL,
	[adduser] [nvarchar](20) NULL,
	[disc_reason] [int] NULL,
	[disc_qty] [int] NULL,
	[minamt] [numeric](12, 2) NULL
) 

ENDTEXT

=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow
CREATE TABLE [dbo].[android_order_itemdept](
	[mark_id] [varchar](50) NULL,
	[order_id] [int] NULL,
	[Parent_id] [numeric](10, 5) NULL,
	[item_id] [int] NOT NULL,
	[dept_id] [int] NOT NULL,
	[amount] [numeric](12, 2) NULL,
	[srvamt] [numeric](12, 2) NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE TABLE [dbo].[android_order_tax](
	[mark_id] [varchar](50) NULL,
	[id] [int] NOT NULL,
	[item_id] [numeric](10, 5) NOT NULL,
	[tax_id] [int] NULL,
	[tax_per] [numeric](6, 2) NULL,
	[tax_amount] [numeric](12, 2) NULL
)
ENDTEXT
=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow
CREATE TABLE [dbo].[android_update](
	[type] [nvarchar](10) NULL,
	[verno] [int] NULL,
	[del_table] [int] NULL,
	[update_date] [datetime] NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table android_update add type nvarchar(10)")


=SQLEXEC(nhand,"select top 0 space(50) as mark_id, * into android_pay_detail from pay_detail ")		&& 2012.03.08


*-------------------



IF SQLEXEC(nhand,"alter table tables add id int null")>0			&& tables   2011.08.18

	IF SQLEXEC(nhand,"alter table  tables add id2 int identity not null")>0
	
	
		=SQLEXEC(nhand,"update tables set id=id2")
		=SQLEXEC(nhand,"alter table tables drop column id2")
	
	ENDIF
	

ENDIF


TEXT TO ssql noshow

ALTER   TABLE   tables   ADD   CONSTRAINT 
DF_tables_inv_id   DEFAULT   (0)   FOR   inv_id 

ENDTEXT

=SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table order_function add for_android bit null")>0		&& modifier

	=SQLEXEC(nhand,"UPDATE order_function  SET for_android =1")

ENDIF




IF SQLEXEC(nhand,"alter table modifier add updateno int null")>0		&& modifier

	=SQLEXEC(nhand,"UPDATE modifier SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table modifier_def add updateno int null")>0		&& modifier_def

	=SQLEXEC(nhand,"UPDATE modifier_def SET updateno=id")

ENDIF





IF SQLEXEC(nhand,"alter table holi add updateno int null")>0			&&  holi

	=SQLEXEC(nhand,"UPDATE holi SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table message add updateno int null")>0			&& message

	=SQLEXEC(nhand,"UPDATE message SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table item add updateno int null")>0			&& item

	=SQLEXEC(nhand,"UPDATE item SET updateno=id+100")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add updateno int null")>0			&& item

	=SQLEXEC(nhand,"UPDATE item_backup SET updateno=id+100")

ENDIF



IF SQLEXEC(nhand,"alter table system_setting add updateno int null")>0		&&system_setting


	=SQLEXEC(nhand,"update system_setting set updateno = id")
	
	
ENDIF


IF SQLEXEC(nhand,"alter table outlet add updateno int null")>0			&& outlet

	=SQLEXEC(nhand,"UPDATE outlet SET updateno=id+10")

ENDIF

IF SQLEXEC(nhand,"alter table itemprice add updateno int null")>0		&& itemprice

	=SQLEXEC(nhand,"UPDATE itemprice SET updateno=1")

ENDIF

IF SQLEXEC(nhand,"alter table system_period add updateno int null")>0		&&system_period 

	=SQLEXEC(nhand,"UPDATE system_period SET updateno=id")

ENDIF


IF SQLEXEC(nhand,"alter table item_mcate add updateno int null")>0			&&item_mcate 

	=SQLEXEC(nhand,"UPDATE item_mcate SET updateno=id")

ENDIF


IF SQLEXEC(nhand,"alter table cate add updateno int null")>0			&& cate

	=SQLEXEC(nhand,"UPDATE cate SET updateno=id")

ENDIF



IF SQLEXEC(nhand,"alter table printerset add updateno int null")>0			&& printerset 

	=SQLEXEC(nhand,"UPDATE printerset SET updateno=id")

ENDIF


IF SQLEXEC(nhand,"alter table void_reason add updateno int null")>0			&& void_reason

	=SQLEXEC(nhand,"UPDATE void_reason SET updateno=id+10")

ENDIF

IF SQLEXEC(nhand,"alter table srv add updateno int null")>0			&& srv

	=SQLEXEC(nhand,"UPDATE srv SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table tax add updateno int null")>0			&& tax

	=SQLEXEC(nhand,"UPDATE tax SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table setitem add updateno int null")>0			&& setitem 

	=SQLEXEC(nhand,"UPDATE setitem SET updateno=id")

ENDIF


IF SQLEXEC(nhand,"alter table mitem add updateno int null")>0			&& mitem

	=SQLEXEC(nhand,"UPDATE mitem SET updateno=id+1")

ENDIF


IF SQLEXEC(nhand,"alter table disc add updateno int null")>0			&& disc

	=SQLEXEC(nhand,"UPDATE disc SET updateno=id+10")

ENDIF

IF SQLEXEC(nhand,"alter table disc_main add updateno int null")>0			&& disc_main

	=SQLEXEC(nhand,"UPDATE disc_main SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table disc_reason add updateno int null")>0			&& disc_reason

	=SQLEXEC(nhand,"UPDATE disc_reason SET updateno=id")

ENDIF



IF SQLEXEC(nhand,"alter table order_function add updateno int null")>0			&& order_function

	=SQLEXEC(nhand,"UPDATE order_function SET updateno=id")

ENDIF

IF SQLEXEC(nhand,"alter table table_function add updateno int null")>0			&& table_function

	=SQLEXEC(nhand,"UPDATE table_function SET updateno=id")

ENDIF


IF SQLEXEC(nhand,"alter table role add updateno int null")>0			&& role

	=SQLEXEC(nhand,"UPDATE role SET updateno=id+10")

ENDIF

IF SQLEXEC(nhand,"alter table roleaccess add updateno int null")>0			&& roleaccess 

	=SQLEXEC(nhand,"UPDATE roleaccess SET updateno=roleaccess_id +1")

ENDIF

IF SQLEXEC(nhand,"alter table item_cp add updateno int null")>0			&& item_cp 

	=SQLEXEC(nhand,"UPDATE item_cp SET updateno=item_id +1")

ENDIF


IF SQLEXEC(nhand,"alter table cp add updateno int null")>0			&& cp 

	=SQLEXEC(nhand,"UPDATE cp SET updateno=id +1")

ENDIF



IF SQLEXEC(nhand,"alter table order_function add onlyandroid bit null")>0			&& order_function add-->>onlyandroid

	=SQLEXEC(nhand,"UPDATE order_function SET onlyandroid =0")

ENDIF

IF SQLEXEC(nhand,"alter table station add clear_item_db bit null")>0			&& station add-->>clear_item_db 

	=SQLEXEC(nhand,"UPDATE station SET clear_item_db=0")

ENDIF


IF SQLEXEC(nhand,"alter table tables add android_page int null")>0			&& tables add-->>android_page

	=SQLEXEC(nhand,"UPDATE tables  SET android_page =page_no")

ENDIF


IF SQLEXEC(nhand,"alter table station add update_item_db bit")>0			&& station add-->>update_item_db 

	=SQLEXEC(nhand,"update station set update_item_db =0")

ENDIF

IF SQLEXEC(nhand,"alter table order_function add android_order int null") > 0		&& 2011.09.05
	=SQLEXEC(nhand, "update order_function set android_order = dispord")
ENDIF 	


IF SQLEXEC(nhand,"alter table item add gift bit null") > 0		&& 2011.09.05
	=SQLEXEC(nhand, "update item set gift = 0")
ENDIF 	

IF SQLEXEC(nhand,"alter table item_backup add gift bit null") > 0		&& 2011.09.05
	=SQLEXEC(nhand, "update item_backup set gift = 0")
ENDIF 	


IF SQLEXEC(nhand,"alter table order_detail add gift bit null,giftred bit null") > 0		&& 2011.09.06
	=SQLEXEC(nhand, "update order_detail set gift = 0,giftred=0")
	
ENDIF 	

IF SQLEXEC(nhand,"alter table order_detail_bak add gift bit null,giftred bit null") > 0		&& 2011.09.06
	=SQLEXEC(nhand, "update order_detail_bak set gift = 0,giftred=0")
	
ENDIF 	


IF SQLEXEC(nhand,"alter table inv_detail add gift bit null,giftred bit null") > 0		&& 2011.09.06
	=SQLEXEC(nhand, "update inv_detail set gift = 0,giftred=0")
	
ENDIF 	



IF SQLEXEC(nhand,"alter table android_order_detail add gift bit null,giftred bit null") > 0		&& 2011.09.06
	=SQLEXEC(nhand, "update android_order_detail  set gift = 0,giftred=0")
	
ENDIF 	

IF SQLEXEC(nhand,"alter table item add asktel bit null") > 0		&& 2011.09.14
	=SQLEXEC(nhand, "update item set asktel = 0")
ENDIF 	

IF SQLEXEC(nhand,"alter table item_backup add asktel bit null")>0
	=SQLEXEC(nhand,"update item_backup set asktel=0")


ENDIF

IF SQLEXEC(nhand,"alter table order_detail add tel varchar(20) null ") > 0		&& 2011.09.15
	=SQLEXEC(nhand, "update order_detail set tel='' ")
	
ENDIF 	

IF SQLEXEC(nhand,"alter table order_detail_bak add tel varchar(20) null") > 0	
	=SQLEXEC(nhand, "update order_detail_bak  set tel=''")
	
ENDIF 	


IF SQLEXEC(nhand,"alter table item add onlymember bit null") > 0		&& 2011.09.17
	=SQLEXEC(nhand, "update item set onlymember = 0")
ENDIF 	

IF SQLEXEC(nhand,"alter table item_backup add onlymember bit null") > 0		&& 2011.09.17
	=SQLEXEC(nhand, "update item_backup set onlymember = 0")
	
ENDIF 	


IF SQLEXEC(nhand,"alter table order_detail add transNumber varchar(20) null") > 0		&& 2011.09.19
	=SQLEXEC(nhand, "update order_detail set transNumber = '' ")
	
ENDIF 	

IF SQLEXEC(nhand,"alter table order_detail_bak add transNumber varchar(20) null") > 0		
	=SQLEXEC(nhand, "update order_detail_bak set transNumber = '' ")
	
ENDIF


IF SQLEXEC(nhand,"alter table inv add transNumber varchar(20) null") > 0		
	=SQLEXEC(nhand, "update inv set transNumber = '' ")
	
ENDIF

IF SQLEXEC(nhand,"alter table inv_detail add transNumber varchar(20) null ") > 0		
	=SQLEXEC(nhand, "update inv_detail set transNumber = '' ")
	
ENDIF



*!*	IF SQLEXEC(nhand,"alter table android_order_detail add transNumber varchar(20)") > 0		&& 2011.09.06
*!*		=SQLEXEC(nhand, "update android_order_detail  set transNumber='' ")
*!*		
*!*	ENDIF
 


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2011.09.19   hinv  add transnumber
	
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add transNumber varchar(20) null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set gift=0,giftred=0,transNumber='' ")
			
		ENDIF
		

		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add gift bit null,giftred bit null,transNumber varchar(20) null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set gift=0,giftred=0,transNumber='' ")
			
		ENDIF
		
		
	
	ENDSCAN

ENDIF

IF SQLEXEC(nhand,"alter table order_detail add member_number varchar(20) null ") > 0		&& 2011.09.20
	=SQLEXEC(nhand, "update order_detail set member_number ='' ")
	
ENDIF 	

IF SQLEXEC(nhand,"alter table order_detail_bak add member_number varchar(20) null") > 0	
	=SQLEXEC(nhand, "update order_detail_bak  set member_number =''")
	
ENDIF 	


IF SQLEXEC(nhand,"alter table android_order_detail add tel varchar(20) null,transNumber varchar(20) null ,member_number varchar(20) null ") > 0		&& 2011.09.27
	=SQLEXEC(nhand, "update android_order_detail set tel='',transNumber ='',member_number=''  ")
	
ENDIF 

		
IF SQLEXEC(nhand,"alter table modifier add custmodi bit null")>0		&&2011.09.28	自定義特別處理

	=SQLEXEC(nhand,"update modifier set custmodi=0")

ENDIF

IF SQLEXEC(nhand,"alter table modifier_clean add custmodi bit null")>0		&&2015.11.17	自定義特別處理

	=SQLEXEC(nhand,"update modifier_clean set custmodi=0")

ENDIF


IF SQLEXEC(nhand,"alter table roleaccess add android bit null")>0		&&2011.10.03

	=SQLEXEC(nhand,"UPDATE roleaccess SET android=0")


ENDIF

TEXT TO ssql noshow

UPDATE roleaccess SET android=1 
WHERE code='dinein_split'
 or code='dinein_prninv'            
 or code='dinein_reprint_inv' 
 or code='dinein_change_tbl'
 or code='dinein_change_tbl_after_inv'
 or code='dinein_edit_ppl'
 or code='order_soldout'
 or code='dinein_ordlist'
 or code='order_order_after_inv'
 or code='order_call_hold'
 or code='order_chase'
 or code='order_change_prn'
 or code='order_change_price'
 or code='order_void_after_print'
 or code='order_change_qty_after_print'
 or code='order_item_disc'
 or code='order_show_all_cate'
 or code='order_item_change_tbl'
 or code='order_whole_disc'
 or code='order_back_order'
 or code='setup_cp'
 or code='_order_disc_after_inv'
 or code='_order_disc_after_inv'

ENDTEXT 

=SQLEXEC(nhand,ssql)



IF SQLEXEC(nhand,"alter table item add asktel2 bit null,onlyone bit null") > 0		&& 2011.10.06
	=SQLEXEC(nhand, "update item set asktel2 = 0,onlyone=0")
ENDIF 	

IF SQLEXEC(nhand,"alter table item_backup add asktel2 bit null,onlyone bit null") > 0		&& 2011.10.06
	=SQLEXEC(nhand, "update item_backup set asktel2 = 0,onlyone=0")
ENDIF 	

IF SQLEXEC(nhand,"alter table tel_order  add address_id int null")>0			&& 2011.10.10
	
	=SQLEXEC(nhand,"update tel_order set address_id=0")

ENDIF

IF SQLEXEC(nhand,"alter table station add clear_cache bit null")>0

	=SQLEXEC(nhand,"update station set clear_cache =0 ")

ENDIF

IF SQLEXEC(nhand,"alter table disc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update disc set dedu_srv =0 ")

ENDIF


*--------------------------------------------------------------

IF SQLEXEC(nhand,"alter table order_disc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update order_disc set dedu_srv =0 ")

ENDIF

IF SQLEXEC(nhand,"alter table order_itemdisc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update order_itemdisc set dedu_srv =0 ")

ENDIF

IF SQLEXEC(nhand,"alter table order_disc_bak add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update order_disc_bak set dedu_srv =0 ")

ENDIF

IF SQLEXEC(nhand,"alter table order_itemdisc_bak add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update order_itemdisc_bak set dedu_srv =0 ")

ENDIF



IF SQLEXEC(nhand,"alter table inv_disc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update inv_disc set dedu_srv =0 ")

ENDIF

IF SQLEXEC(nhand,"alter table inv_itemdisc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update inv_itemdisc set dedu_srv =0 ")

ENDIF



IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2011.10.18   hinv_disc,hinv_itemdisc  add dedu_srv
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_disc_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add dedu_srv bit null")>0
			
				=SQLEXEC(nhand,"update "+cname+" set dedu_srv =0")
			
		ENDIF
		
		cName="hinv_itemdisc_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add dedu_srv bit null")>0
			
				=SQLEXEC(nhand,"update "+cname+" set dedu_srv =0")
			
		ENDIF
		
	
	ENDSCAN

ENDIF


IF SQLEXEC(nhand,"alter table android_order_disc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update android_order_disc set dedu_srv =0 ")


ENDIF


IF SQLEXEC(nhand,"alter table android_order_itemdisc add dedu_srv bit null")>0

	=SQLEXEC(nhand,"update android_order_itemdisc set dedu_srv =0 ")


ENDIF


&& 2011.11.23

IF SQLEXEC(nhand,"alter table cate add day1 bit null,day2 bit null,day3 bit null,day4 bit null,day5 bit null,day6 bit null,day7 bit null,holiday bit null,ex_holiday bit null")>0

	SQLEXEC(nhand,"UPDATE cate set day1=1,day2=1,day3=1,day4=1,day5=1,day6=1,day7=1,holiday=1,ex_holiday=0")

ENDIF


IF SQLEXEC(nhand,"alter table item add custom bit null")>0		&& 2011.11.23

	SQLEXEC(nhand,"update item set custom=0")
	

ENDIF


IF SQLEXEC(nhand,"alter table item_backup add custom bit null")>0		&& 2011.11.23

	SQLEXEC(nhand,"update item_backup set custom=0")
	

ENDIF


IF SQLEXEC(nhand,"alter table item add custom_modi_id varchar(100) null")>0		&& 2011.11.23

	SQLEXEC(nhand,"update item set custom_modi_id ='' ")
	

ENDIF


IF SQLEXEC(nhand,"alter table item_backup add custom_modi_id varchar(100) null")>0		&& 2011.11.23

	SQLEXEC(nhand,"update item_backup set custom_modi_id ='' ")
	

ENDIF



IF SQLEXEC(nhand,"alter table item add custom_keep_name bit null")>0		&& 2011.12.19

	SQLEXEC(nhand,"update item set custom_keep_name =0 ")
	

ENDIF


IF SQLEXEC(nhand,"alter table item_backup add custom_keep_name bit null")>0		&& 2011.12.19

	SQLEXEC(nhand,"update item_backup set custom_keep_name =0 ")
	

ENDIF


IF SQLEXEC(nhand,"alter table area add updateno int null")>0		&& 2012.01.09

	SQLEXEC(nhand,"update area set updateno =id ")
	

ENDIF


IF SQLEXEC(nhand,"alter table address add updateno int null")>0		&& 2012.01.09

	SQLEXEC(nhand,"update address set updateno =id ")

ENDIF

IF SQLEXEC(nhand,"alter table payway add updateno int null")>0		&& 2012.03.01

	SQLEXEC(nhand,"update payway set updateno =id + 2 ")

ENDIF


IF SQLEXEC(nhand,"alter table fastfood_info add updateno int null")>0		&& 2012.03.22

	SQLEXEC(nhand,"update fastfood_info set updateno =id + 2 ")

ENDIF







IF SQLEXEC(nhand,"alter table inv_detail add tel varchar(20) null ") > 0			&& inv_detail add tel  ... 2012.01.30
	=SQLEXEC(nhand, "update inv_detail set tel = '' ")
	
ENDIF





IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2012.01.30  hinv_detail ad tel
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add tel varchar(20) null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set tel='' ")
			
		ENDIF
		
		
	
	ENDSCAN

ENDIF



TEXT TO ssql noshow

CREATE TABLE [direct_printer](
	[id] [int] NULL,
	[s_printer] [int] NULL,
	[d_printer] [int] NULL,
	[dispord] [int] NULL
) 

ENDTEXT
=SQLEXEC(nhand,ssql)



IF SQLEXEC(nhand,"alter table item add timer_begtrigger bit null")>0		&& 2012.03.05

	SQLEXEC(nhand,"update item set timer_begtrigger=0 ")
	

ENDIF


IF SQLEXEC(nhand,"alter table item_backup add timer_begtrigger bit null")>0		&& 2012.03.05

	SQLEXEC(nhand,"update item_backup set timer_begtrigger=0 ")
	

ENDIF

IF FILE("sysinfo.dat")

	Local cstr,ms
	cstr=Filetostr("sysinfo.dat")
	cstr=crstr(cstr,"RMS6")		&&unpack

	Dimension ms(1)
	getmstring(cstr,@ms,"@")

	cstr=Trim(ms(__nServer))

	getmstring(cstr,@ms,";")

	_db_name = Trim(ms(6))
	
	=SQLEXEC(nhand, "ALTER DATABASE "+ _db_name  +"SET AUTO_CLOSE OFF WITH NO_WAIT")
	=SQLEXEC(nhand, "ALTER DATABASE "+ _db_name +" SET AUTO_SHRINK ON WITH NO_WAIT")	
		

ENDIF



* 2012-07-11

lcStation = getcomputername()


TEXT TO ssql noshow
	IF NOT exists (select type from sys_options where type='octopus'  AND defavalue_char=?lcStation )
	insert into sys_options (defavalue_char,type,active,disporder,update_date) values (?lcStation ,'octopus',1,0,'1900-01-01')

ENDTEXT

=SQLEXEC(nhand,ssql)



_desccn=getmessage("_member_card","cn")														&& 2012-07-16 	payway 增加 member card 付款方式  id=-2
ssql="if not exists (select id from payway where id=-2 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-2,?_desccn,'Member Card',1,1,0,0,0,'1990-1-1','2099-1-1',0,99,0,1,'',0,'',0)"


=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table pay_print_detail add price numeric(8,2) null")	&& 2012.07.24


IF SQLEXEC(nhand,"alter table item add reprice numeric(12,2) null")>0	&& 2012.07.27

	=SQLEXEC(nhand,"update item set reprice = 0 ")

ENDIF


IF SQLEXEC(nhand,"alter table item_backup add reprice numeric(12,2) null")>0	&& 2012.07.27

	=SQLEXEC(nhand,"update item_backup set reprice = 0 ")

ENDIF

=SQLEXEC(nhand,"alter table order_disc alter column member_number char(20) null")		&& 2012.07.31

=SQLEXEC(nhand,"alter table order_disc_bak alter column member_number char(20) null")

=SQLEXEC(nhand,"alter table inv_disc alter column member_number char(20) null")


ssql="if not exists (select id from payway where id=-5 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-5,'eCoupon','eCoupon',3,1,0,0,0,'1990-1-1','2099-1-1',0,99,0,1,'',0,'',0)"


=SQLEXEC(nhand,ssql)		&& 2012-08-08


TEXT TO ssql noshow			&& 2012-08-16

alter table item alter column timer_mincharge numeric (6,1) null
alter table item_backup alter column timer_mincharge numeric (6,1) null

alter table order_detail alter column timer_mincharge numeric (6,1) null
alter table order_detail_bak alter column timer_mincharge numeric (6,1) null



ENDTEXT

=SQLEXEC(nhand,ssql)



=SQLEXEC(nhand,"alter table item add ecoupon bit null")
=SQLEXEC(nhand,"alter table item_backup add ecoupon bit null")

=SQLEXEC(nhand,"alter table order_detail  add ecoupon bit null")
=SQLEXEC(nhand,"alter table order_detail_bak add ecoupon bit null")


=SQLEXEC(nhand,"alter table android_order_detail alter column timer_mincharge numeric (6,1) null")


TEXT TO ssql noshow

CREATE TABLE [dbo].[edit_log] (
		[datetime] datetime NOT NULL, 
		[id] [int] NOT NULL )

ENDTEXT

=SQLEXEC(nhand,ssql)





*----------------------------	 2012.09.11

IF SQLEXEC(nhand,"alter table inv_print_main alter column pid char(20) null")<0

	=SQLEXEC(nhand,"drop index inv_print_main.ix_pid")
	
	=SQLEXEC(nhand,"alter table inv_print_main alter column pid char(20) null")
	=SQLEXEC(nhand,"alter table inv_print_main alter column username nvarchar(20) null")	
	
	TEXT TO ssql noshow
	CREATE NONCLUSTERED INDEX [ix_pid] ON [dbo].[inv_print_main] 
	(
		[pid] ASC
	)


	ENDTEXT
	=SQLEXEC(nhand,ssql)


ENDIF


IF SQLEXEC(nhand,"alter table slip_print_main alter column pid char(20) null")<0

	=SQLEXEC(nhand,"drop index slip_print_main.ix_pid")
	
	=SQLEXEC(nhand,"alter table slip_print_main alter column pid char(20) null")
	=SQLEXEC(nhand,"alter table slip_print_main alter column username nvarchar(20) null")

	TEXT TO ssql noshow
	CREATE NONCLUSTERED INDEX [ix_pid] ON [dbo].[slip_print_main] 
	(
		[pid] ASC
	)

	ENDTEXT
	=SQLEXEC(nhand,ssql)


ENDIF


IF SQLEXEC(nhand,"alter table pay_print_main alter column pid char(20) null")<0


	=SQLEXEC(nhand,"drop index pay_print_main.ix_pid")
	=SQLEXEC(nhand,"drop index pay_print_main.ix_id")

	=SQLEXEC(nhand,"alter table pay_print_main alter column pid char(20) null")
	=SQLEXEC(nhand,"alter table pay_print_main alter column username nvarchar(20) null")

	TEXT TO ssql noshow

	CREATE NONCLUSTERED INDEX [ix_pid] ON [dbo].[pay_print_main] 
	(
		[pid] ASC
	)


	ENDTEXT
	=SQLEXEC(nhand,ssql)


ENDIF


=SQLEXEC(nhand,"alter table inv_print_detail alter column item nvarchar(100) null")
=SQLEXEC(nhand,"alter table inv_print_detail alter column adduser nvarchar(20) null ")
=SQLEXEC(nhand,"alter table slip_print_detail alter column item nvarchar(100) null ")
=SQLEXEC(nhand,"alter table pay_print_detail alter column item nvarchar(100) null ")
=SQLEXEC(nhand,"alter table pay_print_detail alter column adduser nvarchar(20) null")





IF SQLEXEC(nhand,"alter table order_main add isForeign bit default 0 null")>0	&& order add isForeign ... 2012.10.18

	=SQLEXEC(nhand, "update order_main set isForeign = 0")

ENDIF

IF SQLEXEC(nhand,"alter table order_main_bak add isForeign bit default 0 null")>0

	=SQLEXEC(nhand, "update order_main_bak set isForeign = 0")

ENDIF



IF SQLEXEC(nhand,"alter table inv  add isForeign bit default 0 null ") > 0			&& inv add isForeign ... 2012.10.18

	=SQLEXEC(nhand, "update inv set isForeign = 0")



ENDIF

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add isForeign bit default 0 null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  isForeign = 0 ")
			
		ENDIF
		
		
	
	ENDSCAN

ENDIF


*--2012.11.01

TEXT TO ssql noshow

if exists( select id from outlet where price_style is null)
UPDATE outlet SET price_style=1,updateno=updateno+1 WHERE price_style is null


ENDTEXT


=SQLEXEC(nhand,ssql)


* 2012.11.05 解決 in_divide 表中不完整的日期

TEXT TO ssql noshow

	Declare @name varchar(100)
	declare @sdate datetime
	declare @edate datetime
	declare @nid int

	DECLARE inv_cursor CURSOR FOR 

	select right(table_name,6) as name,
	  DATEADD(MONTH, DATEDIFF(MONTH, 0, 
		convert(datetime,  substring(table_name,6,4)+'.'+substring(table_name,10,2)+'.01' )), 0) as start_time,
	DATEADD(MONTH, DATEDIFF(MONTH, -1, convert(datetime,  substring(table_name,6,4)+'.'+substring(table_name,10,2)+'.01' ) ), -1) as end_time
	  
	 from INFORMATION_SCHEMA.tables
	 where  table_type='BASE TABLE' and left(table_name,4)='hinv'
	 and ascii(substring(table_name,6,1)) between 48 and 57 
	 and right(table_name,6) not in (select name from inv_divide)
	 order by name
	 
	 OPEN inv_cursor

	FETCH NEXT FROM inv_cursor 
	INTO @name, @sdate ,@edate

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		select @nid=isnull(max(id),0)+1 from inv_divide
		insert into inv_divide (id,name,start_time,end_time) values (@nid,@name,@sdate,@edate)

	FETCH NEXT FROM inv_cursor 
	    INTO @name, @sdate ,@edate

	END

	 
	 CLOSE inv_cursor;
	DEALLOCATE inv_cursor;

	--Lihong 2021.07.05 will be done later exec create_inv_view '', '1900-01-01', '2050-01-1'

ENDTEXT

=SQLEXEC(nhand,ssql)




*-------------------------------------- 2012.11.20 


IF SQLEXEC(nhand,"select cvalue from system_setting where pcode='__special_customer'","cun_tmp")>0



	IF  "redant"$ LOWER(cun_tmp.cvalue)
	
		
			=SQLEXEC(nhand,"delete from item where  id=-5")
			=SQLEXEC(nhand,"delete from itemdept where iem_id=-5")
			
			=SQLEXEC(nhand,"update payway set change_type=1  where descen='MASTER' or descen='VISA' ")


			TEXT TO ssql noshow
			

				if not exists (select id from payway where descen='CardTips' ) 
				
				BEGIN 
				
					DECLARE @nid int
					DECLARE @updateno int
					
					SELECT @nid=MAX(id)+1 FROM payway
					SELECT @updateno =MAX(updateno)+1 FROM payway
					

					INSERT INTO [payway]
					           ([active]
					           ,[id]
					           ,[desccn]
					           ,[descen]
					           ,[change_type]
					           ,[rate]
					           ,[dispwithpic]
					           ,[image]
					           ,[coupon]
					           ,[askqty]
					           ,[payvalue]
					           ,[startdate]
					           ,[enddate]
					           ,[opendraw]
					           ,[dispord]
					           ,[system_record]
					           ,[allow_tips]
					           ,[allow_cardno]
					           ,[file_exp]
					           ,[lock]
					           ,[mark]
					           ,[updateno])
					     VALUES
					           (1
					           ,@nid
					           ,'信用卡小費'
					           ,'CardTips'
					           ,1
					           ,1
					           ,0
					           ,''
					           ,0
					           ,0
					           ,0
					           ,'1900-01-01'
					           ,'2099-01-01'
					           ,0
					           ,@nid
					           ,1
					           ,0
					           ,0
					           ,''
					           ,1
					           ,''
					           ,@updateno)

					END 
			
			
			
			ENDTEXT
			
			
			=SQLEXEC(nhand,ssql)
			
			

			lcStation=""

			IF SQLEXEC(nhand,"select id from station with (nolock) order by id","cun_tmp")>0

				SELECT cun_tmp
				SCAN
					
					lcStation = lcStation +ALLTRIM(STR(id)) +","
				
				ENDSCAN

			ELSE

				lcStation="1,2,3,4,5,6,7,8,9,10,"
				

			ENDIF


			TEXT TO ssql noshow


			if not exists(select id from [department] where descen='TIPS')

			begin

			declare @nid int

			select @nid=max(isnull(id,0) )+1 from [department]


			INSERT INTO [department]
			           ([active]
			           ,[id]
			           ,[desccn]
			           ,[descen]
			           ,[disporder])
			     VALUES
			           (1
			           ,@nid
			           ,'各項小費'
			           ,'TIPS'
			           ,@nid)

			end



			ENDTEXT


			=SQLEXEC(nhand,ssql)



			TEXT TO ssql noshow



			if not exists(select id from cate where descen='TIPS')

			begin

			declare @nid int

			select @nid=max(isnull(id,0) )+1 from cate

			declare @updateno int
			select @updateno=max(isnull(updateno,0) )+1 from cate


			INSERT INTO [cate]
			           ([active]
			           ,[id]
			           ,[desccn]
			           ,[descen]
			           ,[display]
			           ,[dispord]
			           ,[forecolor]
			           ,[backcolor]
			           ,[active_section]
			           ,[active_shop]
			           ,[active_outlet]
			           ,[startdate]
			           ,[enddate]
			           ,[updateno]
			           ,[blank]
			           ,[desc_other]
			           ,[active_station]
			           ,[day1]
			           ,[day2]
			           ,[day3]
			           ,[day4]
			           ,[day5]
			           ,[day6]
			           ,[day7]
			           ,[holiday]
			           ,[ex_holiday])
			     VALUES
			           (1
			           ,@nid
			           ,'小費'
			           ,'TIPS'
			           ,1
			           ,@nid
			           ,0
			           ,16777215
			           ,'1,2,3,4,5,'
			           ,''
			           ,'0,1,2,3,4,5,'
			           ,'2000-01-01'
			           ,'2099-01-01'
			           ,@updateno
			           ,0
			           ,''
			           ,?lcStation 
			           ,1
			           ,1
			           ,1
			           ,1
			           ,1
			           ,1
			           ,1
			           ,1
			           ,0)

			end




			endtext

			=SQLEXEC(nhand,ssql)



			TEXT TO ssql noshow

			if not exists (select id from item where code='CASHTIPS')

			begin
			declare @nid int
			select @nid=max(isnull(id,0) )+1 from item

			declare @updateno int
			select @updateno=max(isnull(updateno,0) )+1 from item

			declare @cate_id int

			select @cate_id=(select id from cate where descen='TIPS')

			INSERT INTO [item]
			           ([active]
			           ,[menu_id]
			           ,[cate_id]
			           ,[level_id]
			           ,[id]
			           ,[code]
			           ,[mcate_id]
			           ,[modi_id]
			           ,[mustmodi_id]
			           ,[sitem]
			           ,[disc]
			           ,[price0]
			           ,[price1]
			           ,[priceset]
			           ,[desccn]
			           ,[descen]
			           ,[descpole]
			           ,[desckit]
			           ,[descinvcn]
			           ,[descinven]
			           ,[printer]
			           ,[autoppl]
			           ,[mustitem]
			           ,[srv_id]
			           ,[tax_id]
			           ,[hold]
			           ,[askqty]
			           ,[askprice]
			           ,[cost]
			           ,[handwriting]
			           ,[limitqty]
			           ,[qtymax]
			           ,[qtyremain]
			           ,[soldout]
			           ,[autoqty]
			           ,[onhandqty]
			           ,[turnup]
			           ,[turnup_price]
			           ,[dayend]
			           ,[drink_qty]
			           ,[OnlyPeriod]
			           ,[soldoutdate]
			           ,[used]
			           ,[slip_Print]
			           ,[mincharge]
			           ,[timer_active]
			           ,[timer_style]
			           ,[free_hours]
			           ,[free_style]
			           ,[timer_begtime]
			           ,[timer_endtime]
			           ,[timer_mincharge]
			           ,[timer_disc]
			           ,[Desc_other]
			           ,[warning_qty]
			           ,[use_material]
			           ,[tax2]
			           ,[points]
			           ,[barcode]
			           ,[kilo]
			           ,[askdept]
			           ,[gram]
			           ,[invlst_print]
			           ,[invlst_noprint]
			           ,[item_warning]
			           ,[warning_begtime]
			           ,[warning_endtime]
			           ,[warning_inMinute]
			           ,[price4]
			           ,[joinitem]
			           ,[updateno]
			           ,[outletSrv]
			           ,[gift]
			           ,[asktel]
			           ,[onlymember]
			           ,[asktel2]
			           ,[onlyone]
			           ,[custom]
			           ,[custom_modi_id]
			           ,[custom_keep_name]
			           ,[timer_begtrigger]
			           ,[reprice]
			           ,[ecoupon])
			     VALUES
			           (1
			           ,0
			           ,@cate_id
			           ,0
			           ,@nid
			           ,'CASHTIPS'
			           ,@cate_id
			           ,''
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,'現金小費'
			           ,'CASHTIPS'
			           ,'CASHTIPS'
			           ,'CASHTIPS'
			           ,'現金小費'
			           ,'CASHTIPS'
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,1
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,1
			           ,0
			           ,0
			           ,'1900-01-01'
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,''
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,''
			           ,0
			           ,0
			           ,0
			           ,@updateno
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0)

				
				declare @updateno2 int
				select @updateno2 = max(isnull(updateno,0) )+1 from item_mcate
				
				
				INSERT INTO [item_mcate]
			           ([id]
			           ,[cate_id]
			           ,[dispord]
			           ,[forecolor]
			           ,[backcolor]
			           ,[updateno])
			     VALUES
			           (@nid
			           ,@cate_id
			           ,1
			           ,0
			           ,14215660
			           ,@updateno2 )




			 END


			ENDTEXT

			IF SQLEXEC(nhand,ssql)<0
				AERROR(err)
				
				SET STEP ON 
				
				
			ENDIF



			TEXT TO ssql noshow

			IF NOT exists ( select item_id from itemdept where item_id = (select id from item where descen='CASHTIPS') )

				BEGIN 
				
					DECLARE @item_id int
					declare @dept_id int

					set  @item_id=(select id from item  where  code='CASHTIPS')
					set  @dept_id=(select id from department where descen='TIPS')


					insert into itemdept (item_id,dept_id,price,price_per) 
					values (@item_id , @dept_id ,0,100)

				END


			ENDTEXT

			IF SQLEXEC(nhand,ssql)<0
				AERROR(err)
				
				SET STEP ON 
				
				
			ENDIF



			*------ 2012.11.21

			TEXT TO ssql noshow

			if not exists (select id from item where code='CARDTIPS')

			begin
			declare @nid int
			select @nid=max(isnull(id,0) )+1 from item

			declare @updateno int
			select @updateno=max(isnull(updateno,0) )+1 from item

			declare @cate_id int

			select @cate_id=(select id from cate where descen='TIPS')

			INSERT INTO [item]
			           ([active]
			           ,[menu_id]
			           ,[cate_id]
			           ,[level_id]
			           ,[id]
			           ,[code]
			           ,[mcate_id]
			           ,[modi_id]
			           ,[mustmodi_id]
			           ,[sitem]
			           ,[disc]
			           ,[price0]
			           ,[price1]
			           ,[priceset]
			           ,[desccn]
			           ,[descen]
			           ,[descpole]
			           ,[desckit]
			           ,[descinvcn]
			           ,[descinven]
			           ,[printer]
			           ,[autoppl]
			           ,[mustitem]
			           ,[srv_id]
			           ,[tax_id]
			           ,[hold]
			           ,[askqty]
			           ,[askprice]
			           ,[cost]
			           ,[handwriting]
			           ,[limitqty]
			           ,[qtymax]
			           ,[qtyremain]
			           ,[soldout]
			           ,[autoqty]
			           ,[onhandqty]
			           ,[turnup]
			           ,[turnup_price]
			           ,[dayend]
			           ,[drink_qty]
			           ,[OnlyPeriod]
			           ,[soldoutdate]
			           ,[used]
			           ,[slip_Print]
			           ,[mincharge]
			           ,[timer_active]
			           ,[timer_style]
			           ,[free_hours]
			           ,[free_style]
			           ,[timer_begtime]
			           ,[timer_endtime]
			           ,[timer_mincharge]
			           ,[timer_disc]
			           ,[Desc_other]
			           ,[warning_qty]
			           ,[use_material]
			           ,[tax2]
			           ,[points]
			           ,[barcode]
			           ,[kilo]
			           ,[askdept]
			           ,[gram]
			           ,[invlst_print]
			           ,[invlst_noprint]
			           ,[item_warning]
			           ,[warning_begtime]
			           ,[warning_endtime]
			           ,[warning_inMinute]
			           ,[price4]
			           ,[joinitem]
			           ,[updateno]
			           ,[outletSrv]
			           ,[gift]
			           ,[asktel]
			           ,[onlymember]
			           ,[asktel2]
			           ,[onlyone]
			           ,[custom]
			           ,[custom_modi_id]
			           ,[custom_keep_name]
			           ,[timer_begtrigger]
			           ,[reprice]
			           ,[ecoupon])
			     VALUES
			           (1
			           ,0
			           ,@cate_id
			           ,0
			           ,@nid
			           ,'CARDTIPS'
			           ,@cate_id
			           ,''
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,'信用卡小費'
			           ,'CARDTIPS'
			           ,'CARDTIPS'
			           ,'CARDTIPS'
			           ,'信用卡小費'
			           ,'CARDTIPS'
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,1
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,1
			           ,0
			           ,0
			           ,'1900-01-01'
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,''
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,''
			           ,0
			           ,0
			           ,0
			           ,@updateno
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,0
			           ,''
			           ,0
			           ,0
			           ,0
			           ,0)




				declare @updateno2 int
				select @updateno2 = max(isnull(updateno,0) )+1 from item_mcate
				
				
				INSERT INTO [item_mcate]
			           ([id]
			           ,[cate_id]
			           ,[dispord]
			           ,[forecolor]
			           ,[backcolor]
			           ,[updateno])
			     VALUES
			           (@nid
			           ,@cate_id
			           ,2
			           ,0
			           ,14215660
			           ,@updateno2 )




			end


			ENDTEXT

			=SQLEXEC(nhand,ssql)


			TEXT TO ssql noshow
				
			IF NOT exists ( select item_id from itemdept where item_id in ( select id from item where descen='CARDTIPS')  )

			BEGIN

				DECLARE @item_id int
				declare @dept_id int

				set  @item_id=(select id from item  where  code='CARDTIPS')
				set  @dept_id=(select id from department where descen='TIPS')


				insert into itemdept (item_id,dept_id,price,price_per) 
				values (@item_id , @dept_id ,0,100)

			END

			ENDTEXT

			IF SQLEXEC(nhand,ssql)<0
				AERROR(err)
				
				SET STEP ON 
				
				
			ENDIF
			
			
	ENDIF
	

ENDIF


=SQLEXEC(nhand,"alter table sys_log add station_time datetime null")

IF SQLEXEC(nhand,"alter table sys_user add dblcheck bit null ")>0		&& 用戶加入雙重認證

	=SQLEXEC(nhand,"update sys_user set dblcheck=0")

ENDIF



TEXT TO ssql noshow

CREATE TABLE [dbo].[item_move](
	[id] [int] NULL,
	[datetime] [datetime] NULL,
	[adduser] [nvarchar](30) NULL,
	[station] [nvarchar](30) NULL,
	[table_from] [char](10) NULL,
	[table_to] [char](10) NULL,
	[item_id] [int] NULL,
	[qty] [numeric](12, 2) NULL,
	[price] [numeric](12, 2) NULL,
	[amount] [numeric](12, 2) NULL,
	[inv_id] [int] NULL,
	[cln] [int] NULL,
	[belongdate] [datetime] NULL	
) 


ENDTEXT

=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table item_move add cln int null")
=SQLEXEC(nhand,"alter table item_move add belongdate datetime null")




TEXT TO ssql noshow		&&少收現金

CREATE TABLE [dbo].[less_cash](
	[id] [int] NULL,
	[adduser] [nvarchar](30) NULL,
	[station] [nvarchar](30) NULL,
	[datetime] [datetime] NULL,
	[cln] [int] NULL,
	[belongdate] [datetime] NULL,
	[amount] [numeric](12, 2) NULL
)

ENDTEXT
=SQLEXEC(nhand,ssql)



IF SQLEXEC(nhand,"alter table payway add pax_type int null")>0		&& 2012.12.06

	=SQLEXEC(nhand,"update payway set pax_type=0")
	

ENDIF



IF SQLEXEC(nhand,"alter table tables add bigname bit null")>0		&& 2013.01.02

	=SQLEXEC(nhand,"update tables set bigname=0")
	

ENDIF


IF SQLEXEC(nhand,"alter table tables add unlimit_time bit null")>0		&& 2013.01.24  加入不限制時間

	=SQLEXEC(nhand,"update tables set unlimit_time =0")
	

ENDIF

=SQLEXEC(nhand,"alter table tel_order alter column address nvarchar(100) null ")


IF SQLEXEC(nhand,"alter table sys_user add order_language char (2) null")>0		&& 2013.02.18  加入用戶的點菜界面語言 CN /EN /UN

	=SQLEXEC(nhand,"update SYS_USER set order_language = user_language")	
	

ENDIF



IF SQLEXEC(nhand,"alter table  outlet_print_mode add split bit null")>0		&& 2013.03.14  加入打印拆分

	=SQLEXEC(nhand,"update outlet_print_mode set split = 0")	
	

ENDIF


IF SQLEXEC(nhand,"alter table  station add android_key varchar(100) null")>0		&& 2013.03.18  加入android_key

	=SQLEXEC(nhand,"update station set android_key  = '' ")	
	

ENDIF

IF SQLEXEC(nhand,"alter table  payway add lms  bit null")>0		&& 2013.03.28  加入會員卡充值外貨

	=SQLEXEC(nhand,"update payway set lms  = 0 ")	
	

ENDIF


IF SQLEXEC(nhand,"alter table order_detail add price_mc numeric(12,2) null")>0		&& 2013.04.02

	
	=SQLEXEC(nhand,"update order_detail set price_mc =0")

ENDIF

=SQLEXEC(nhand,"alter table android_order_detail add price_mc numeric(12,2) null")

IF SQLEXEC(nhand,"alter table order_detail_bak add price_mc numeric(12,2) null")>0	

	
	=SQLEXEC(nhand,"update order_detail_bak set price_mc =0")

ENDIF

IF SQLEXEC(nhand,"alter table modifier add linkppl bit  null")>0		&& 2013.04.16

	
	=SQLEXEC(nhand,"update modifier set linkppl =0")

ENDIF

IF SQLEXEC(nhand,"alter table modifier_clean add linkppl bit  null")>0		&& 2015.11.17

	
	=SQLEXEC(nhand,"update modifier_clean  set linkppl =0")

ENDIF



IF SQLEXEC(nhand,"alter table modifier add ppl int  null")>0		&& 2013.04.16

	
	=SQLEXEC(nhand,"update modifier set ppl =0")

ENDIF

IF SQLEXEC(nhand,"alter table modifier_clean add ppl int  null")>0	&& 2015.11.17

	
	=SQLEXEC(nhand,"update modifier_clean set ppl =0")

ENDIF



IF SQLEXEC(nhand,"alter table item add amtinv bit null")>0		&& 2013.04.17 item 表加入零金額不允許印發票

	=SQLEXEC(nhand,"UPDATE item SET amtinv=0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add amtinv bit null")>0

	=SQLEXEC(nhand,"UPDATE item_ackup SET amtinv=0")

ENDIF



*2013.04.23

=SQLEXEC(nhand,"alter table order_detail add modi_need char(254) null ,modi_must char(254) null ,modi_def char(254) null")
=SQLEXEC(nhand,"alter table order_detail_bak add modi_need char(254) null ,modi_must char(254) null ,modi_def char(254) null")

=SQLEXEC(nhand,"alter table android_order_detail add modi_need char(254) null ,modi_must char(254) null ,modi_def char(254) null")


=SQLEXEC(nhand,"alter table order_modi add modi_need bit null,modi_must bit null,modi_idx numeric(12,6) null,def_idx char(100)")
=SQLEXEC(nhand,"alter table order_modi_bak add modi_need bit null,modi_must bit null,modi_idx numeric(12,6) null,def_idx char(100)")
=SQLEXEC(nhand,"alter table android_order_modi add modi_need bit null,modi_must bit null,modi_idx numeric(12,6) null,def_idx char(100)")


=SQLEXEC(nhand,"alter table order_detail add amtinv bit null")
=SQLEXEC(nhand,"alter table order_detail_bak add amtinv bit null")
=SQLEXEC(nhand,"alter table android_order_detail add amtinv bit null")


=SQLEXEC(nhand,"alter table order_detail add   save_type varchar(20) null")
=SQLEXEC(nhand,"alter table order_detail_bak add save_type varchar(20) null")
=SQLEXEC(nhand,"alter table android_order_detail add save_type varchar(20) null")

=SQLEXEC(nhand,"alter table order_detail alter column save_type varchar(20) null")
=SQLEXEC(nhand,"alter table order_detail_bak alter column save_type varchar(20) null")
=SQLEXEC(nhand,"alter table android_order_detail  alter column save_type varchar(20) null")


IF SQLEXEC(nhand,"alter table tables add updateno int null")>0

	=SQLEXEC(nhand,"update tables set updateno=1")
	

ENDIF



IF SQLEXEC(nhand,"alter table item add dispwithpic bit null")>0		&& 2013.05.09  item 表加入是否顯示圖片（android)

	=SQLEXEC(nhand,"UPDATE item SET dispwithpic =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add dispwithpic bit null")>0		

	=SQLEXEC(nhand,"UPDATE item_ackup SET dispwithpic=0")

ENDIF


IF SQLEXEC(nhand,"alter table station add self_order_table_id int null")>0		

	=SQLEXEC(nhand,"UPDATE station SET self_order_table_id=0")

ENDIF


TEXT TO ssql noshow

CREATE TABLE [dbo].[warn_reason](
	[active] [bit] NOT NULL,
	[id] [int] NOT NULL,
	[desccn] [nvarchar](30) NOT NULL,
	[descen] [nvarchar](30) NOT NULL,
	[dispord] [int] NOT NULL,
	[updateno] [int] NULL
) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow

CREATE TABLE [dbo].[warn_log](
	[id] [int] NULL,
	[warn_reason_id] [int] NULL,
	[tableno] [char](10) NULL,
	[station_id] [int] NULL,
	[addtime] [datetime] NULL,
	[click_time] [datetime] NULL,
	[click_user] [nchar](10) NULL,
	[click_station] [nchar](20) NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow		&& 2013.05.22 

CREATE TABLE [dbo].[subarea](
	[active] [bit] NOT NULL,
	[id] [int] NOT NULL,
	[area_id] [int] NULL,
	[desccn] [nvarchar](50) NULL,
	[descen] [nvarchar](50) NULL,
	[dispord] [int] NULL,
	[updateno] [int] NULL
) ON [PRIMARY]

ENDTEXT
= SQLEXEC(nhand,ssql)

IF SQLEXEC(nhand,"alter table address add subarea_id int null")>0

	=SQLEXEC(nhand,"update address set subarea_id=0")

ENDIF


=SQLEXEC(nhand,"alter table tel_order add linkman varchar(20) null")		&& 2013.05.23 


*=SQLEXEC(nhand,"alter table sys_user alter column password varchar(200) null")	&& 2013.05.31
*=SQLEXEC(nhand,"alter table sys_user alter column cardno varchar(200) null")


=SQLEXEC(nhand,"alter table sys_user alter column password nvarchar(200) COLLATE Chinese_Taiwan_Stroke_CS_AS")		&& 記密碼區分大寫  2013.12.31   FIX	
=SQLEXEC(nhand,"alter table sys_user alter column cardno nvarchar(200) COLLATE Chinese_Taiwan_Stroke_CS_AS")		&& 記卡號區分大小寫



TEXT TO ssql noshow

CREATE TABLE [dbo].[modi_soldout](
	[id] [int] NULL,
	[modi_id] [int] NULL,
	[name_match] [bit] NULL,
	[adduser] [nchar](20) NULL,
	[addtime] [datetime] NULL,
	[updateno] [int] NULL
) ON [PRIMARY]


ENDTEXT
= SQLEXEC(nhand,ssql)


=SQLEXEC(nhand," alter table outlet alter column defaultitem varchar(254) null")		&& 2013.07.03


*!*	TEXT TO ssql noshow														&& 2013.07.11
*!*		IF NOT exists (select type from sys_options where type='inv_id'   )
*!*		begin
*!*		declare @nid int
*!*		select @nid=max(id) from inv_view
*!*		insert into sys_options (defavalue,type,active,disporder,update_date) values (@nid ,'inv_id',1,0,'1900-01-01')

*!*		end

*!*	ENDTEXT

*!*	= SQLEXEC(nhand,ssql)


IF SQLEXEC(nhand,"alter table cate add active_modi varchar(200) null")>0		&& 2013.07.26

	=SQLEXEC(nhand,"update cate set active_modi='all' ")

ENDIF



IF SQLEXEC(nhand,"alter table item add delay_minute int null")>0		&& 2013.08.06 item 表加入延遲列印（分鐘）

	=SQLEXEC(nhand,"UPDATE item SET delay_minute =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add delay_minute int null")>0

	=SQLEXEC(nhand,"UPDATE item_ackup SET delay_minute =0")

ENDIF


=SQLEXEC(nhand,"alter table order_print_main add delay_minute int null")

=SQLEXEC(nhand,"alter table order_detail add  delay_minute int null")			&& 2013.08.07
=SQLEXEC(nhand,"alter table order_detail_bak add  delay_minute int null")
=SQLEXEC(nhand,"alter table android_order_detail add delay_minute int null")

=SQLEXEC(nhand,"alter table table_booking alter column tableno char(8)")  	&& 2013.09.10



IF SQLEXEC(nhand,"alter table inv  add inv_type int default 0 null ") > 0			&& inv add isForeign ... 2012.10.18

	=SQLEXEC(nhand, "update inv set inv_type = 0")



ENDIF

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& 2013.09.30		inv add inv_type  加入發票種類，預設為0(銷售)， 1為進倉 ，2 退貨
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add  inv_type int default 0 null  ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  inv_type = 0 ")
			
		ENDIF
		
		
	
	ENDSCAN

ENDIF

TEXT TO ssql noshow

	CREATE TABLE [dbo].[item_in_main](
		[id] [int] NULL,
		[in_id] [varchar](20) NULL,
		[date] [datetime] NULL,
		[adduser] [nchar](20) NULL,
	) ON [PRIMARY]

ENDTEXT

= SQLEXEC(nhand,ssql)


TEXT TO ssql noshow

CREATE TABLE [dbo].[item_in_detail](
	[id] [int] NULL,
	[item_id] [int] NULL,
	[qty] [numeric](9, 2) NULL,
	[dispord] [int] NULL
) ON [PRIMARY]


ENDTEXT
= SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table item_in_detail add price numeric(12,2) null,amount numeric (12,2) null")


=SQLEXEC(nhand,"alter table item_in_main drop column rem")

=SQLEXEC(nhand,"alter table item_in_main add amount numeric (12,2) null")


** 

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [ix_id] ON [dbo].[item_in_main] 
(
	[id] ASC
)


ENDTEXT
=SQLEXEC(nhand,ssql)



TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [ix_id] ON [dbo].[item_in_detail] 
(
	[id] ASC
)


ENDTEXT
=SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table inv_print_main  alter column address varchar(200) null")	&& 2013.12.05


=SQLEXEC(nhand,"alter table expense  alter column rem  nvarchar(150) null")	&& 2013.12.13




IF SQLEXEC(nhand,"alter table inv  add inv_remark  nvarchar(100)  default '' null ") > 0			&& inv add inv_remark  ... 2013.12.18

	=SQLEXEC(nhand, "update inv set inv_remark  = '' ")



ENDIF

IF SQLEXEC(nhand,"alter table inv  add inv_remark2  nvarchar(100)  default '' null ") > 0			&& inv add inv_remark  ... 2013.12.18

	=SQLEXEC(nhand, "update inv set inv_remark2  = '' ")



ENDIF





IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& 2013.12.18		inv add inv_remark  加入發票備注
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add  inv_remark  nvarchar(100)  default '' null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  inv_remark  = '' ")
			
		ENDIF
		

		IF SQLEXEC(nhand,"alter table "+cname+" add  inv_remark2  nvarchar(100)  default '' null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  inv_remark2 = '' ")
			
		ENDIF

		
	
	ENDSCAN

ENDIF


=SQLEXEC(nhand,"alter table inv_print_main  add inv_remark  nvarchar(100)  default '' null ") 			&& inv add inv_remark  ... 2013.12.18
=SQLEXEC(nhand,"alter table inv_print_main  add inv_remark2  nvarchar(100)  default '' null ") 			&& inv add inv_remark  ... 2013.12.18

=SQLEXEC(nhand,"alter table inv_reprint_main  add inv_remark  nvarchar(100)  default '' null ") 			&& inv add inv_remark  ... 2016.02.26
=SQLEXEC(nhand,"alter table inv_reprint_main  add inv_remark2  nvarchar(100)  default '' null ") 			&& inv add inv_remark  ... 2016.02.26


=SQLEXEC(nhand,"alter table fastfood_info add  slip_printer int default 0 null ")		&& 2013.12.30  

=SQLEXEC(nhand,"alter table tables  add  ready_pay bit default 0 null ")		&& 2014.03.17  


TEXT TO ssql noshow

CREATE TABLE [dbo].[booking](
	[id] [int] NOT NULL,
	[member_cardno] [nvarchar](100) null,
	[name] [nvarchar](50) NULL,
	[sex] [char](2) NULL,
	[booking_date] [datetime] NULL,
	[booking_time] [char](10) NULL,
	[arrival_time] [datetime] NULL,
	[ppl] [char](10) NULL,
	[tel] [varchar](50) NULL,
	[tableno] [char](10) NULL,
	[remark] [nvarchar](200) NULL,
	[adduser] [nvarchar](20) NULL,
	[addtime] [datetime] NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)		&& 2014.03.26

TEXT TO ssql noshow
CREATE NONCLUSTERED INDEX [ix_id] ON [dbo].[booking] 
(
	[id] ASC
)

ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO ssql noshow

CREATE NONCLUSTERED INDEX [ix_date] ON [dbo].[booking] 
(
	[booking_date] ASC
)
ENDTEXT
=SQLEXEC(nhand,ssql)



=SQLEXEC(nhand,"update system_setting set updateno=uid where updateno is null")

IF SQLEXEC(nhand,"select updateno ,COUNT(0)    from system_setting group by updateno having COUNT(0)>1","cun_tmp")>0

	
	IF !EOF("cun_tmp")
	
		 a=SQLEXEC(nhand,"alter table system_setting add pid timestamp null")
	
	ENDIF
	

	SELECT cun_tmp
	SCAN
		
		IF SQLEXEC(nhand,"select master.sys.fn_varbintohexstr(cast(pid as varbinary(8))) as pid from system_setting where updateno=?cun_tmp.updateno","cun_tmp1")>0
		
			SELECT cun_tmp1
			SCAN
			
				_updateno=getupdateno("system_setting")
				
				b=SQLEXEC(nhand,"update system_setting set updateno=?_updateno where pid ="+ cun_tmp1.pid)
		
			ENDSCAN
			
			USE IN cun_tmp1
			
		
		ENDIF
		
	
	ENDSCAN

	 c=SQLEXEC(nhand,"alter table system_setting drop column pid")


ENDIF


IF SQLEXEC(nhand,"select top 1 invlst_zeroNoprint from item","cun_tmp")<0		&& 2014.05.23

	TEXT TO ssql noshow

		EXEC sp_rename N'item.invlst_noprint', N'invlst_zeroNoprint', 'Column'
		EXEC sp_rename N'item.invlst_print', N'invlst_noprint', 'Column'

		EXEC sp_rename N'item_backup.invlst_noprint', N'invlst_zeroNoprint', 'Column'
		EXEC sp_rename N'item_backup.invlst_print', N'invlst_noprint', 'Column'

	ENDTEXT
	=SQLEXEC(nhand,ssql)


ENDIF

IF SQLEXEC(nhand,"alter table sys_user add autoexit_main bit null")>0		&&2014.06.18

=SQLEXEC(nhand,"update sys_user set autoexit_main=0")


ENDIF

IF SQLEXEC(nhand,"alter table sys_user add Commission bit null")>0		&&2014.06.18

=SQLEXEC(nhand,"update sys_user set Commission=0")


ENDIF


IF SQLEXEC(nhand,"alter table item add Commission bit null")>0		&& 2014.06.18 item 表加入計算佣金

	=SQLEXEC(nhand,"UPDATE item SET Commission =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add Commission  bit null")>0

	=SQLEXEC(nhand,"UPDATE item_backup SET Commission =0")

ENDIF

IF SQLEXEC(nhand,"alter table item add kilo2 bit null")>0		&& 2014.06.30 item 表加入按兩計算

	=SQLEXEC(nhand,"UPDATE item SET kilo2 =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add kilo2  bit null")>0

	=SQLEXEC(nhand,"UPDATE item_backup SET kilo2 =0")

ENDIF




IF SQLEXEC(nhand,"alter table inv  add seller nvarchar(20)  null ") > 0			&& inv add seller  ... 2014.06.25

	=SQLEXEC(nhand, "update inv set Seller = '' ")



ENDIF



IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& inv add seller  ... 2014.06.25
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add  seller nvarchar(20)  null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  seller = '' ")
			
		ENDIF
		

	
	ENDSCAN

ENDIF



TEXT TO ssql noshow	&&  2014-07-07   菜式級別加入日期時間等條件

alter table itemlevel_rule add 
	[startdate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[begtime] [char](5) Null,
	[endtime] [char](5) NULL,
	[day1] [bit] NULL,
	[day2] [bit] NULL,
	[day3] [bit] NULL,
	[day4] [bit] NULL,
	[day5] [bit] NULL,
	[day6] [bit] NULL,
	[day7] [bit] NULL,
	[holiday] [bit] NULL,
	[ex_holiday] [bit] NULL

ENDTEXT

IF  SQLEXEC(nhand,ssql)>0
	
	=SQLEXEC(nhand,"update itemlevel_rule set startdate='2000-01-01',enddate='2059-01-01',begtime='00:00' ,endtime='23:59',day1=1,day2=1,day3=1,day4=1,day5=1,day6=1,day7=1,holiday=1 ")



ENDIF

IF SQLEXEC(nhand,"alter table member  add agency nvarchar(20)  null ") > 0			&& member add agency  ... 2014.08.13

	=SQLEXEC(nhand, "update member set agency = '' ")



ENDIF

IF SQLEXEC(nhand,"alter table member  add nickname nvarchar(20)  null ") > 0			&& member add nickname ... 2014.08.13

	=SQLEXEC(nhand, "update member set nickname = '' ")



ENDIF

= SQLEXEC(nhand,"alter table tables  add timer_endtime datetime  null ")			&& tables  add timer_endtime ... 2014.08.18	加入計鐘的到鐘時間

=SQLEXEC(nhand,"alter table order_print_main alter column move_from varchar(30) null")		&& 2014.08.21

=SQLEXEC(nhand,"alter table order_print_main alter column move_to  varchar(30) null")


=SQLEXEC(nhand,"alter table inv_print_void alter column descdisp  nvarchar(200) null")		&&2014.08.28


=SQLEXEC(nhand,"update itemprice  set ex_holiday=0 where ex_holiday is null")		&& 2014.09.11



IF SQLEXEC(nhand,"alter table payway  add reader bit  null ") > 0			&&  ... 2014.10.30

	=SQLEXEC(nhand, "update payway  set reader = 0" )

ENDIF


IF SQLEXEC(nhand,"alter table payway  add card_noshow bit  null ") > 0			&&  ... 2014.10.30

	=SQLEXEC(nhand, "update payway  set card_noshow= 0" )

ENDIF






IF SQLEXEC(nhand,"alter table payway_print_detail add  card_name nvarchar(30)  null ") > 0			&&  ... 2014.10.30

	=SQLEXEC(nhand, "update payway_print_detail set card_name = '' " )

ENDIF

IF SQLEXEC(nhand,"alter table pay_detail  add  card_name nvarchar(30)  null ") > 0			&& 

	=SQLEXEC(nhand, "update pay_detail set card_name = '' " )

ENDIF


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& pay_detail add  cardname ... 2014.10.30
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add  card_name nvarchar(30)  null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  card_name = '' ")
			
		ENDIF
		

	
	ENDSCAN

ENDIF


TEXT TO ssql noshow			&& 2014.12.10

CREATE TABLE [dbo].[remin_reason](
	[active] [bit] NOT NULL,
	[id] [int] NOT NULL,
	[desccn] [nvarchar](30) NOT NULL,
	[descen] [nvarchar](30) NOT NULL,
	[dispord] [int] NOT NULL,
	[updateno] [int] NULL
) ON [PRIMARY]


ENDTEXT

=SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table order_print_main add remin_reason int null")

=SQLEXEC(nhand,"delete from order_tax where id not in (select id from order_main)")

IF SQLEXEC(nhand,"alter table inv  add  liked  bit null ") > 0			&& inv add liked  ... 2015.06.09

	=SQLEXEC(nhand,"update inv set  liked = 0 ")

ENDIF


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& inv add liked  ... 2015.06.09
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add  liked  bit null ")>0
			
*				=SQLEXEC(nhand,"update "+cname+" set  liked = 0 ")
			
		ENDIF
		

	
	ENDSCAN

ENDIF


IF SQLEXEC(nhand,"alter table order_detail  add  disc  bit null ") > 0			&& inv add liked  ... 2015.06.18

	=SQLEXEC(nhand,"update order_detail set disc = (select disc from item where id=order_detail.item_id)")
	

ENDIF

=SQLEXEC(nhand,"alter table atte alter column voided bit null")	&& 2015.06.22

IF SQLEXEC(nhand,"alter table order_detail_bak  add  disc  bit null ") > 0			&& inv add liked  ... 2015.07.07

*	=SQLEXEC(nhand,"update order_detail_bak set disc = (select disc from item where id=order_detail.item_id)")
	
ENDIF


IF SQLEXEC(nhand,"alter table payway add kis bit null")>0		&& 2015.08.12

	=SQLEXEC(nhand,"update payway set kis=0")
	

ENDIF



IF SQLEXEC(nhand,"alter table pay_detail  add  kisstxid varchar(20)  null ") > 0			&& 2015.08.17

	=SQLEXEC(nhand, "update pay_detail set kisstxid = '' " )

ENDIF


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& pay_detail add  kisstxid ... 2015.08.17
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+" add   kisstxid varchar(20)   null ")>0
			
				=SQLEXEC(nhand,"update "+cname+" set  kisstxid = '' ")
			
		ENDIF
	
	ENDSCAN

ENDIF

=SQLEXEC(nhand,"alter table pay_print_main  add  kisstxid varchar(20)  null ") 			&& 2015.08.18


=SQLEXEC(nhand,"alter table pay_detail  add  txrefno varchar(30)  null,kisspay varchar(20) , authcode varchar(30) ,kiss_dollor numeric(12,2) ,kiss_rrd numeric(12,2) ,kiss_payamt numeric(12,2) ") 			&& 2015.08.20


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& pay_detail add  kisstxid ... 2015.08.20
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
		
		SQLEXEC(nhand,"alter table "+cname+" add txrefno varchar(30)  null,kisspay varchar(20) , authcode varchar(30) ,kiss_dollor numeric(12,2) ,kiss_rrd numeric(12,2) ,kiss_payamt numeric(12,2)")
	
	ENDSCAN

ENDIF

=SQLEXEC(nhand,"alter table pay_print_main  add  txrefno varchar(30)  null,kisspay varchar(20) , authcode varchar(30) ,kiss_dollor numeric(12,2) ,kiss_rrd numeric(12,2) ,kiss_payamt numeric(12,2)") 			&& 2015.08.20




TEXT TO csql noshow																			&& 2015.12.14  加入會員卡機更新編號

	if not exists (select type from sys_options where type='member_update')
	insert into sys_options (defavalue,type,active,disporder) values (0,'member_update',1,0)

ENDTEXT
=SQLEXEC(nhand,csql)


IF SQLEXEC(nhand,"alter table item add iqchar bit null")>0		&& 2016.03.03 item 表加入叫號機

	=SQLEXEC(nhand,"UPDATE item SET iqchar =0")

ENDIF

IF SQLEXEC(nhand,"alter table item_backup add iqchar bit null")>0

	=SQLEXEC(nhand,"UPDATE item_backup SET iqchar =1")

ENDIF


IF SQLEXEC(nhand,"alter table outlet add cleannotice bit null ")>0		&&區域 加入顯示清理中狀態
	=SQLEXEC(nhand,"update outlet set cleannotice=0")
	

ENDIF

IF SQLEXEC(nhand,"alter table system_period add slip_print bit null")>0		&&營業時段加入列印上菜紙 2016.03.23
	
	=SQLEXEC(nhand,"update system_period set slip_print =1")


ENDIF


*2016-4-7 for sai chuen report
IF SQLEXEC(nhand, "alter table payway add commission numeric (12,2)") > 0
	=SQLEXEC(nhand, "update payway set commission = 0")
ENDIF 
=SQLEXEC(nhand, "alter table payway add pay_group_id int")


*SQLEXEC(nhand,"ALTER TABLE inv_reprint_detail drop column id")		&&2016.02.27

 =SQLEXEC(nhand,"alter table payway_print_detail add pay_id int null")	&&2016.04.28
 
=SQLEXEC(nhand,"alter table slip_print_main add sittime datetime null")		&&2016.08.05


=SQLEXEC(nhand,"alter table order_main add crm_member_no varchar(20) null")	&&2018.07
=SQLEXEC(nhand,"alter table order_main add crm_member_name varchar(50) null")	&&2018.07



TEXT TO ssql  noshow

CREATE TABLE [dbo].[inv_crm](
	[inv_id] [int] NULL,
	[imvamt] [numeric](12, 2) NULL,
	[belongdate] [date] NULL,
	[member_no] [varchar](20) NULL,
	[shop_code] [char](10) NULL,
	[station_id] [int] NULL,
	[createtime] [datetime] NULL
) ON [PRIMARY]

ENDTEXT

=SQLEXEC(nhand, ssql)

TEXT TO ssql noshow

CREATE CLUSTERED INDEX [idx_inv_crm_inv_id] ON [dbo].[inv_crm]
(
	[inv_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

ENDTEXT

=SQLEXEC(nhand, ssql)


*------------------------------------  

IF SQLEXEC(nhand,"alter table inv  add u_hq bit null ") > 0			&& inv add u_hq ... 2018.08.08

	=SQLEXEC(nhand, "update inv set u_hq = 0 ")



ENDIF



IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&& inv add u_hq ...  2018.08.08
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		IF SQLEXEC(nhand,"alter table "+cname+"   add u_hq bit null ")>0
			
				* =SQLEXEC(nhand,"update "+cname+" set u_hq = 0 ")
			
		ENDIF
		

	
	ENDSCAN

ENDIF

=SQLEXEC(nhand,"alter table order_detail add fix_price bit  null")	&&2018.07
=SQLEXEC(nhand,"alter table android_order_detail add fix_price bit  null")	&&2018.07

=SQLEXEC(nhand,"alter table tables  add crm_member bit null")  && 2018.08.19

=SQLEXEC(nhand,"alter table android_order_main alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_order_detail alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_order_modi alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_order_disc alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_order_itemdisc alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_order_tax alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table android_pay_detail alter column mark_id nvarchar(50)")  && 2018.08.22
=SQLEXEC(nhand,"alter table tables add check_valid varchar(10) null") &&2018.08.
=SQLEXEC(nhand,"alter table exec_android_data alter column mark_id nvarchar(50)")

=SQLEXEC(nhand,"alter table android_order_detail add source int  null")	&&2018.09
=SQLEXEC(nhand,"alter table order_detail add source int  null")	&&2018.09
=SQLEXEC(nhand,"alter table inv_detail add source int  null")	&&2018.09


IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		
		 SQLEXEC(nhand,"alter table "+cname+" add source int   null ")
	
	
	ENDSCAN

ENDIF



IF SQLEXEC(nhand,"CREATE TABLE  inv_lock (edit_time datetime NOT NULL )")  >0   &&2018.09
	
		=SQLEXEC(nhand,"insert into inv_lock (edit_time) values(getdate())")
		
ENDIF


=SQLEXEC(nhand,"update item set updateno = (select max(updateno) from item) + id + 100 where updateno is null")
=SQLEXEC(nhand,"update payway set updateno = (select max(updateno) from payway) + id + 100 where updateno is null")
=SQLEXEC(nhand,"update message set updateno = (select max(updateno) from message) + id where updateno is null")
=SQLEXEC(nhand,"update roleaccess set updateno = (select max(updateno) from roleaccess) + roleaccess_id where updateno is null")


ssql="if not exists (select id from payway where id=-88 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-88,'保雅自助落單','保雅自助落單',3,1,0,0,0,'1990-1-1','2099-1-1',0,99,0,1,'',0,'',0)"

=SQLEXEC(nhand,ssql)

ssql="if not exists (select id from payway where id=-99 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-99,'保雅外賣','保雅外賣',3,1,0,0,0,'1990-1-1','2099-1-1',0,99,0,1,'',0,'',0)"

=SQLEXEC(nhand,ssql)

&&Lihong 2020.06.23
ssql="if not exists (select id from payway where id=-66 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-66,'保雅自助落單(信用卡)','保雅自助落單(信用卡)',3,1,0,0,0,'1990-1-1','2099-1-1',0,66,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)
ssql="if not exists (select id from payway where id=-77 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-77,'保雅外賣(信用卡)','保雅外賣(信用卡)',3,1,0,0,0,'1990-1-1','2099-1-1',0,77,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table booking add name2 nvarchar(50) null , remark2 nvarchar(100) , is_void bit null")  && 2018.11.06

=SQLEXEC(nhand,"alter table cate add sync_order_dine bit null, sync_order_fastfood bit null")	&& 2019.01.22



** 2019.02.15
*--proan_order_sync_table 
TEXT TO ssql noshow

if not exists (select name from sysobjects (nolock) where type = 'u' and name = 'proan_order_sync_table')
begin
		CREATE TABLE [dbo].[proan_order_sync_table](
		[table_name] [varchar](50) NOT NULL,
		[updateno] [int] NULL,
		[table_desc] [nvarchar](100) NULL,
	 CONSTRAINT [pk_proan_order_sync_table] PRIMARY KEY CLUSTERED 
	(
		[table_name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
end

ENDTEXT
IF SQLEXEC(nhand,ssql)<0
	AERROR(err)
	
	SET STEP ON 
ENDIF


TEXT TO ssql noshow
if not exists (select name from sysobjects (nolock) where type = 'u' and name = 'proan_order_flag')
begin
	CREATE TABLE [dbo].[proan_order_flag](
		[table_name] [varchar](50) NOT NULL,
		[flag] [int] NULL,
		[edit_date] [datetime] NULL,
	 CONSTRAINT [PK_proan_order_flag] PRIMARY KEY CLUSTERED 
	(
		[table_name] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
end

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
create Trigger [dbo].[tr_itemlevel] 
       On [dbo].[itemlevel]                        
       for Update, insert, delete        
     As                                          
	if exists(select * from proan_order_flag (nolock) where table_name = 'itemlevel')
	begin
		update proan_order_flag set flag = isnull(flag, 0) + 1, edit_date = getdate() where table_name = 'itemlevel'
	end
	else
	begin
		insert into proan_order_flag(table_name, flag, edit_date) values('itemlevel', 1, getdate())
	end

ENDTEXT
=SQLEXEC(nhand,ssql)


TEXT TO ssql noshow
create Trigger [dbo].[tr_itemlevel_rule] 
       On [dbo].[itemlevel_rule]                        
       for Update, insert, delete        
     As                                          
	if exists(select * from proan_order_flag (nolock) where table_name = 'itemlevel_rule')
	begin
		update proan_order_flag set flag = isnull(flag, 0) + 1, edit_date = getdate() where table_name = 'itemlevel_rule'
	end
	else
	begin
		insert into proan_order_flag(table_name, flag, edit_date) values('itemlevel_rule', 1, getdate())
	end

ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table sys_user add finger1 varchar(1000) null, finger2 varchar(1000) null, finger3 varchar(1000) null, finger4 varchar(1000) null")

=SQLEXEC(nhand,"alter table payway add check_code bit")

TEXT TO ssql noshow

CREATE TABLE [dbo].[coupon](
	[id] [int] NULL,
	[payway_id] [int] NULL,
	[code] [nvarchar](50) NULL,
	[create_date] [datetime] NULL,
	[used_inv_id] [int] NULL)

ENDTEXT
=SQLEXEC(nhand,ssql)


=SQLEXEC(nhand,"alter table pay_detail add coupon bit null")

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2019.03.19
	
	SELECT cun_tmp
	SCAN
		

		cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
		
		 SQLEXEC(nhand,"alter table "+cname+" add coupon bit  null ")
	
	
	ENDSCAN

ENDIF


=SQLEXEC(nhand,"alter table cate add dispwithpic bit null")	&& 2019.03.26 

TEXT TO ssql noshow
create table android_lock_info (
   station_id           int                  null,
   check_valid          uniqueidentifier     null,
   tableno              nvarchar(50)         null,
   add_time             datetime             null
)

ENDTEXT 
=SQLEXEC(nhand,ssql)	&& 2019.04.08

=SQLEXEC(nhand,"alter table tables add timer_minutes int null")

=SQLEXEC(nhand,"alter table order_main add sn int null")
=SQLEXEC(nhand,"alter table order_main_bak add sn int null")

=SQLEXEC(nhand,"alter table inv add sn int null,is_edit bit null")

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	
	SELECT cun_tmp
	SCAN
		
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		 SQLEXEC(nhand,"alter table "+cname+" add sn  int   null, is_edit bit null")
	
	
	ENDSCAN

ENDIF

IF SQLEXEC(nhand,"select defavalue  from sys_options where type='auto_sn' ","cun_tmp")>0

	
	IF EOF("cun_tmp")
	
		=SQLEXEC(nhand," insert into sys_options(defavalue,type,desccn) values (0,'auto_sn','')")
		
	ENDIF
ENDIF

**  ECASH
ssql="if not exists (select id from payway where id=-4 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-4,'eCash','eCash',1,1,0,0,0,'1990-1-1','2099-1-1',0,99,0,1,'',0,'',0)"


=SQLEXEC(nhand,ssql)

&&Lihong 2020.05.19
=SQLEXEC(nhand, "update payway set desccn='積分兌換', descen='積分兌換' where id=-4 and desccn='eCash' ")

*=SQLEXEC(nhand,"alter table member add ecash numeric(12,2) null ") && 2019.05

&&Lihong2019.09.09 保雅外賣(後收款)
ssql="if not exists (select id from payway where id=-98 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue,updateno)"+;
" values(1,-98,'保雅外賣(後收款)','保雅外賣(後收款)',3,1,0,0,0,'1990-1-1','2099-1-1',0,103,0,1,'',0,'',0, (select ISNULL(MAX(updateno),0)+1 from payway) )"
=SQLEXEC(nhand,ssql)

&&Lihong2019.10.11
=SQLEXEC(nhand,"alter table exec_android_data add apitime datetime null")

&&Lihong2019.10.12
=SQLEXEC(nhand,"alter table payway add additional_fee_type Int null")
=SQLEXEC(nhand,"alter table payway add additional_fee_rate numeric(18, 5) null")

** 澳門通
TEXT TO cmd NOSHOW 
		create table inv_macau_pass (
		   id                   int               not null,
		   inv_id               int               not null,
		   type                 varchar(100)         null,
		   pay_type             varchar(100)         null,
		   status               varchar(20)          null,
		   terminal_id          varchar(50)          null,
		   invoice_no           varchar(50)          null,
		   txnno                varchar(20)          null,
		   pan                  varchar(100)         null,
		   txndate              varchar(100)         null,
		   txntime              varchar(100)         null,
		   origbalance          varchar(100)         null,
		   total_amt            varchar(100)         null,
		   pay_mode             varchar(100)         null,
		   txntype              varchar(100)         null,
		   discount_type        varchar(100)         null,
		   discount_amt         varchar(100)         null,
		   balance              varchar(100)         null,
		   coupon_type          varchar(100)         null,
		   coupon_dedamt        varchar(100)         null,
		   actual_amt           varchar(100)         null,
		   pay_account          varchar(100)         null,
		   pay_pruse_type       varchar(100)         null,
		   pay_total_amt        varchar(100)         null,
		   pay_invoice_no       varchar(100)         null,
		   coupons_code         varchar(100)         null,
		   coupons_name         varchar(100)         null,
		   coupons_amt          varchar(100)         null,
		   origtxn_amt          varchar(100)         null,
		   purse_type           varchar(100)         null,
		   charge               varchar(100)         null,
		   deposit              varchar(100)         null,
		   card_type            varchar(100)         null,
		   mptxn_type           varchar(100)         null,
		   merchant_id          varchar(100)         null,
		   log_no               varchar(100)         null,
		   m1_card_type         varchar(100)         null,
		   txntac               varchar(100)         null,
		   addtime              datetime             null,
		   updateno             int                  null,
		   constraint PK_INV_MACAU_PASS primary key (id)
		)
	ENDTEXT 
	=SQLEXEC(nhand, cmd)	
	
	TEXT TO cmd NOSHOW 
		create nonclustered index Index_inv_id on inv_macau_pass (inv_id ASC)
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
	
	
TEXT TO ssql noshow		&& 2019.06.17

create table item_upgrade (
   item_id              int                  not null,
   belong_to_item_id    int                  not null,
   constraint pk_item_upgrade primary key nonclustered (item_id, belong_to_item_id)
)


ENDTEXT

=SQLEXEC(nhand, ssql )

&&Lihong2019.07.17 __proan_web_so = .T. QrCode落單特別處理 點菜界面簡介 菜式信息
=SQLEXEC(nhand,"alter table item add modi_special_for_proan bit null,modi_id_for_proan nvarchar(100) null, ;
must_modi_id_for_proan nvarchar(100) null,small_info nvarchar(1000) null,info nvarchar(4000) null")

=SQLEXEC(nhand,"alter table item_backup add modi_special_for_proan bit null,modi_id_for_proan nvarchar(100) null, ;
must_modi_id_for_proan nvarchar(100) null,small_info nvarchar(1000) null,info nvarchar(4000) null")

&&Lihong2019.12.26 __proan_web_so = .T. QrCode落單特別處理 點菜界面簡介_en 菜式信息_en
=SQLEXEC(nhand,"alter table item add small_info_en nvarchar(1000) null,info_en nvarchar(4000) null")

=SQLEXEC(nhand,"alter table item_backup add small_info_en nvarchar(1000) null,info_en nvarchar(4000) null")

&&Lihong2019.07.17 __proan_web_so = .T. QrCode落單多選
=SQLEXEC(nhand,"alter table modifier add multi_choise int null")

&&Lihong2019.08.06 __proan_web_so = .T. 不同步到保雅自助落單
=SQLEXEC(nhand,"alter table item add not_sync_order bit null")
=SQLEXEC(nhand,"alter table item_backup add not_sync_order bit null")

&& 2019.07.30 inv add field
=SQLEXEC(nhand,"alter table inv add queue_type int null,check_valid varchar(20) null,is_web_inv bit null")

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	
	SELECT cun_tmp
	SCAN
		
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		 SQLEXEC(nhand,"alter table "+cname+"  add queue_type int null,check_valid varchar(20) null,is_web_inv bit null")
	
	ENDSCAN

ENDIF

&& 2019.08.08 inv add field
=SQLEXEC(nhand,"alter table inv add oc_ready_time datetime null, oc_finish_time datetime null")

IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	
	SELECT cun_tmp
	SCAN
		
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		
		 SQLEXEC(nhand,"alter table "+cname+" add oc_ready_time datetime null, oc_finish_time datetime null")
	
	ENDSCAN

ENDIF

&&Lihong 2019.08.16
TEXT TO ssql noshow 
CREATE TABLE [dbo].[item_cut_order](
	[item_id] [int] NOT NULL,
	[sub_id] [int] NOT NULL,
	[cut_order_min] [int] NULL,
	[sit_in_min] [int] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[day1] [bit] NULL,
	[day2] [bit] NULL,
	[day3] [bit] NULL,
	[day4] [bit] NULL,
	[day5] [bit] NULL,
	[day6] [bit] NULL,
	[day7] [bit] NULL,
	[holiday] [bit] NULL,
	[ex_holiday] [bit] NULL,
	[add_time] [datetime] NULL,
	[edit_time] [datetime] NULL,
	[suspend] [bit] NULL,
 CONSTRAINT [pk_merchant_item_cut_order] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC,
	[sub_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2019.08.21
TEXT TO ssql noshow 
CREATE TABLE [dbo].[proan_ctrl](
	[code] [nvarchar](100) NULL,
	[value] [nvarchar](100) NULL,
	[update_date] [datetime] NULL
) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2019.10.11
TEXT TO ssql noshow 
if not exists (select [code] from  [proan_ctrl] where [code] = 'rms6_update_rms86') 
INSERT INTO [proan_ctrl] ([code], [value], [update_date]) VALUES ('rms6_update_rms86', '1', GETDATE())
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2019.11.04
=SQLEXEC(nhand,"alter table outlet add so_print_slip bit null") 
=SQLEXEC(nhand,"alter table outlet add so_printerset_id int null") 
&&Lihong 2020.07.06
=SQLEXEC(nhand,"alter table outlet add so_printerset_id2 int null") 
=SQLEXEC(nhand,"alter table outlet add so_printerset_id3 int null") 

=SQLEXEC(nhand,"alter table item add so_disc bit null") 
=SQLEXEC(nhand,"alter table item add so_disc_amt numeric(18, 2) null") 
=SQLEXEC(nhand,"alter table item add so_disc_perc numeric(18, 2) null") 

=SQLEXEC(nhand,"alter table item add so_disc1 bit null") 
=SQLEXEC(nhand,"alter table item add so_disc_amt1 numeric(18, 2) null") 
=SQLEXEC(nhand,"alter table item add so_disc_perc1 numeric(18, 2) null") 

=SQLEXEC(nhand,"alter table item_backup add so_disc bit null") 
=SQLEXEC(nhand,"alter table item_backup add so_disc_amt numeric(18, 2) null") 
=SQLEXEC(nhand,"alter table item_backup add so_disc_perc numeric(18, 2) null") 

=SQLEXEC(nhand,"alter table item_backup add so_disc1 bit null") 
=SQLEXEC(nhand,"alter table item_backup add so_disc_amt1 numeric(18, 2) null") 
=SQLEXEC(nhand,"alter table item_backup add so_disc_perc1 numeric(18, 2) null") 
&&

&&Lihong 2020.02.21 雲points
=SQLEXEC(nhand,"alter table member add bmerchant_cust_id int null") 
&&Lihong 2020.02.21 雲points
=SQLEXEC(nhand,"alter table inv add cloud_check_valid uniqueidentifier null") 
&&Lihong 2020.02.21 雲points
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add cloud_check_valid uniqueidentifier null")
	ENDSCAN
ENDIF
&&Lihong 2020.02.21 雲points 	[qty] [numeric](8, 3) NULL,
TEXT TO ssql noshow
CREATE TABLE [dbo].[points_upload](
	[check_valid] [uniqueidentifier] NOT NULL,
	[action] [nvarchar](30) NOT NULL,
	[station_id] [int] NOT NULL,
	[pos_shop_id] [int] NOT NULL,
	[shop_code] [nvarchar](20) NOT NULL,
	[shop_name] [nvarchar](40) NOT NULL,
	[inv_id] [bigint] NOT NULL,
	[points] [numeric](12, 2) NULL,
	[points_used] [numeric](12, 2) NULL,
	[belongdate] [datetime] NULL,
	[member_id] [int] NULL,
	[invamt] [numeric](12, 2) NULL,
	[upcnt] [int] NULL,
	[inv_seq] [int] NULL,
	[create_date] [datetime] NULL,
	[up_date] [datetime] NULL
)
ENDTEXT 
=SQLEXEC(nhand,ssql) 

&&Lihong 2021.04.21
TEXT TO cmd noshow
	DELETE FROM itemdept WHERE dept_id= -100 OR item_id = -51
	insert into itemdept (item_id,dept_id,price,price_per) values (-101,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-102,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-103,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-104,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-110,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-111,-100,0,100)
	insert into itemdept (item_id,dept_id,price,price_per) values (-199,-100,0,100)

	insert into itemdept (item_id,dept_id,price,price_per) values (-51,-51,0,100)

	delete from department where id = -100 or id = -51
	insert into department (active, id, desccn, descen, disporder) values (0, -100, '保雅落單雜項', '保雅落單雜項', -100)
	insert into department (active, id, desccn, descen, disporder) values (0, -51, '禮券銷售' , 'Coupon Sell'  , -51)
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&Lihong 2020.03.16
TEXT TO cmd noshow
	delete from cate where id = -100
	DECLARE @updateno as int 
	SET @updateno = (select ISNULL(MAX(@updateno),0)+1 from cate with (nolock) )
	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate, updateno )
		values (0, -100, '保雅落單雜項' , '保雅落單雜項' , 0 , -100, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1', @updateno )

ENDTEXT 
=SQLEXEC(nhand, cmd)

&&Lihong 2021.04.21
TEXT TO cmd noshow
	delete from cate where id = -51
	DECLARE @updateno as int 
	SET @updateno = (select ISNULL(MAX(@updateno),0)+1 from cate with (nolock) )
	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate, updateno )
		values (0, -51, '禮券銷售' , 'Coupon Sell', 0 , -51, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1', @updateno )

ENDTEXT 
=SQLEXEC(nhand, cmd)

TEXT TO cmd NOSHOW && -106 -105改了
	IF NOT exists (select 1 from item where id=-110 OR id=-111) 
	DELETE from item WHERE id=-106 OR id=-105
ENDTEXT 
=SQLEXEC(nhand, cmd)
TEXT TO cmd NOSHOW && -106 -105改了
	delete from item where (id between -104 AND -101) OR id=-110 OR id=-111 OR id=-199
	
	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -101, -100, -101, -101, '-101', '配送費' , 'Delivery Fee' , 'Delivery Fee' , '配送費' , '配送費' , 'Delivery Fee', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -102, -100, -102, -102, '-102', '餐盒費' , 'Packing Fee' , 'Packing Fee' , '餐盒費' , '餐盒費' , 'Packing Fee', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -103, -100, -103, -103, '-103', '餐具數量' , 'Tableware Qty.' , 'Tableware Qty.' , '餐具數量' , '餐具數量' , 'Tableware Qty.', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -104, -100, -104, -104, '-104', '膠袋費' , 'Plastic Bag Fee' , 'Plastic Bag Fee' , '膠袋費' , '膠袋費' , 'Plastic Bag Fee', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -110, -100, -110, -110, '-110', '最低消費加收' , 'Min Charge Add' , 'Min Charge Add' , '最低消費加收' , '最低消費加收' , 'Min Charge Add', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')

	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -111, -100, -111, -111, '-111', '自助落單折扣' , 'Self Order Discount' , 'Self Order Discount' , '自助落單折扣' , '自助落單折扣' , 'Self Order Discount', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')


	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(1, -199, -100, -199, -199, '-199', '平臺折扣' , ' Proan Discount' , 'Proan Discount' , '平臺折扣' , '平臺折扣' , 'Proan Discount', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '')
		
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&Lihong 2020.03.31 升級餐
=SQLEXEC(nhand,"alter table item add upgrade_multi_qty bit null") 
=SQLEXEC(nhand,"alter table item_backup add upgrade_multi_qty bit null") 

&&Lihong 2020.04.24
=SQLEXEC(nhand, "alter table item add po_packing_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item add po_plastic_bag_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item add pot_packing_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item add pot_plastic_bag_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item add po_delivery_fee_add numeric(18, 1) ") 

=SQLEXEC(nhand, "alter table item_backup add po_packing_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item_backup add po_plastic_bag_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item_backup add pot_packing_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item_backup add pot_plastic_bag_fee_add numeric(18, 1) ") 
=SQLEXEC(nhand, "alter table item_backup add po_delivery_fee_add numeric(18, 1) ") 

&&Lihong 2020.07.07 額外積分
=SQLEXEC(nhand,"alter table item add pointrate numeric(12, 2) null, pointfix numeric(12, 2) null") 
=SQLEXEC(nhand,"alter table item_backup add pointrate numeric(12, 2) null, pointfix numeric(12, 2) null") 

TEXT TO ssql noshow
	

	IF NOT exists(select [pcode] from order_function where pcode='_qrcode_order' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function

		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'Qrcode Order'
		           ,'Qrcode Order'
		           ,0
		           ,14215660
		           ,'_qrcode_order'
		           ,1
		           ,1
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,0)
	END 
	
	
	

ENDTEXT

 SQLEXEC(nhand,ssql)

** 2020.03.28
TEXT TO ssql noshow

CREATE TABLE [dbo].[sauna_index](
	[user_id] [int] NULL,	
	[is_active] [bit] NULL,
	[createtime] [datetime] NULL
) ON [PRIMARY]

ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand," alter table tables add remark varchar(10) null")	&&加入remark 用於 匙
=SQLEXEC(nhand," alter table tables add  remark2 varchar(20) null")	&&加入remark2 用於技師LIST 

** 2020.04.06  


IF SQLEXEC(nhand,"select uid from system_setting where pcode='__custom_item_as_modifier'","cun_tmp")>0

	IF EOF("cun_tmp")

		TEXT TO ssql noshow

			declare @uid int
			declare @dispord int
			declare @updateno int

			select @uid=max(uid)+1 from system_setting 
			select @dispord= max(dispord)+1 from  system_setting where id=21
			select @updateno= max(updateno)+1 from  system_setting 

			INSERT INTO [dbo].[system_setting]
			           ([active]
			           ,[id]
			           ,[uid]
			           ,[desccn]
			           ,[descen]
			           ,[pcode]
			           ,[type]
			           ,[cvalue]
			           ,[default_value]
			           ,[clistcn]
			           ,[clisten]
			           ,[clist_value]
			           ,[nvaluemax]
			           ,[nvaluemin]
			           ,[intvalue]
			           ,[dispord]
			           ,[show]
			           ,[station_id]
			           ,[forprint]
			           ,[applyall]
			           ,[password]
			           ,[updateno])
			     VALUES
			           (1
			           ,21
			           ,@uid
			           ,'自定菜式（執字粒）當特別處理'
			           ,'自定菜式（執字粒）當特別處理'
			           ,'__custom_item_as_modifier'
			           ,1
			           ,'0'
			           ,'0'
			           ,''
			           ,''
			           ,''
			           ,0
			           ,0
			           ,0
			           ,@dispord
			           ,1
			           ,0
			           ,0
			           ,1
			           ,0
			           ,@updateno)

		ENDTEXT
		
		=SQLEXEC(nhand,ssql)

	ENDIF


ENDIF

=SQLEXEC(nhand,"alter table sauna_index drop column code")
=SQLEXEC(nhand,"alter table sauna_index add marker nvarchar(20) null, mark_time datetime null,tel nvarchar(20) null, remark nvarchar(100)")


*2020-05-28 chris
=SQLEXEC(nhand,"alter table sauna_index add is_working bit")

&&Lihong 2020-05-29 coupon
*!*	TEXT TO ssql NOSHOW 
*!*	create table cloud_coupon (
*!*	   id                   int                  not null,
*!*	   code                 varchar(100)         null,
*!*	   name_cn              nvarchar(200)        null,
*!*	   name_en              nvarchar(200)        null,
*!*	   type                 int                  null,
*!*	   active               bit                  null,
*!*	   suspend              bit                  null,
*!*	   add_time             datetime             null,
*!*	   updateno             int                  null,
*!*	   constraint PK_CLOUD_COUPON primary key (id)
*!*	)
*!*	ENDTEXT 
*!*	=SQLEXEC(nhand,ssql)

&&Lihong 2020-05-29 coupon
TEXT TO cmd NOSHOW && -106 -105改了
	IF NOT exists (select 1 from item where id=-51) 
	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer,  slip_print,mincharge,timer_active,timer_style,free_hours ,free_style,timer_begtime,
		timer_endtime,timer_mincharge,timer_disc) 
		values 
		(1, -51, -51, -51, -51, '-51', '禮券銷售' , 'Coupon Sell' , 'Coupon Sell' , '禮券銷售' , '禮券銷售' , 'Coupon Sell', 0  , 0, 0 , 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '',  0,0,0,0,0,0,'','',	0.0,0)
ENDTEXT 
=SQLEXEC(nhand, cmd)


&&Lihong 2020-06-01 coupon
=SQLEXEC(nhand,"alter table order_detail add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table order_detail_bak add fix_price bit  null")	&&2018.07 現補全bak
=SQLEXEC(nhand,"alter table order_detail_bak add source int  null")	&&2018.09 現補全bak
=SQLEXEC(nhand,"alter table order_detail_bak add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table order_itemdisc add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table order_itemdisc_bak add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table android_order_detail add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table android_order_itemdisc add coupon_lock_valid uniqueidentifier null,cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")

&&Lihong 2020-06-01 coupon
=SQLEXEC(nhand,"alter table inv_detail add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table inv_itemdisc add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")
=SQLEXEC(nhand,"alter table pay_detail add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null")

&&Lihong 2020-06-01 coupon
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2012.01.30  hinv_detail ad tel
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null ")>0
		cName="hinv_itemdisc_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null ")>0
		cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add cloud_coupon_id int null,web_coupon_id uniqueidentifier null,web_coupon_code varchar(100) null ")>0
	ENDSCAN
ENDIF 


&&Lihong 2020-06-01 coupon
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_coupon_sell' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'禮券銷售'
		           ,'Coupon Sell'
		           ,0
		           ,14215660
		           ,'_coupon_sell'
		           ,1
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,0)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)


&&Lihong 2020-06-01 coupon
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_coupon_redeem' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'禮券兌換'
		           ,'Coupon redeem'
		           ,0
		           ,14215660
		           ,'_coupon_redeem'
		           ,1
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,0)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2020-06-01 coupon
TEXT TO ssql NOSHOW 
IF NOT exists(select id from disc_main where id=-8) begin 
DECLARE @updateno int 
SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM disc_main 
INSERT INTO [disc_main]
           ([active]
           ,[id]
           ,[desccn]
           ,[descen]
           ,[dispord]
           ,[forecolor]
           ,[backcolor]
           ,[updateno])
     VALUES
           (0
           ,-8
           ,'禮券折扣'
           ,'coupon discount'
           ,0
           ,0
           ,0
           ,@updateno)
 end
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2020-06-01 coupon
TEXT TO ssql NOSHOW 
IF NOT exists(select id from disc where id=-8) begin 
DECLARE @updateno int 
SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM disc 
INSERT INTO [disc]
           ([active]
           ,[id]
           ,[desccn]
           ,[descen]
           ,[discper]
           ,[discamt]
           ,[begdate]
           ,[enddate]
           ,[disclevel]
           ,[dispord]
           ,[disc_type]
           ,[forecolor]
           ,[backcolor]
           ,[parent_id]
           ,[askqty]
           ,[points],active_user,begtime,endtime,day1,day2,day3,day4,day5,day6,day7,holiday,ex_holiday,minamt,updateno,dedu_srv)
     VALUES
           (1
           ,-8
           ,'禮券折扣'
           ,'coupon discount'
           ,0
           ,0
           ,'2008-01-10 00:00:00.000'
           ,'2099-12-31 00:00:00.000'
           ,'all'
           ,0
           ,0
           ,0
           ,0
           ,-8
           ,0
           ,0,'all','00:00','23:59',1,1,1,1,1,1,1,1,0,0.00,@updateno,0)
end
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2020-06-01 coupon
TEXT TO ssql NOSHOW 
CREATE TABLE coupon_upload (
	[check_valid] [uniqueidentifier] NOT NULL,
	[action] [nvarchar](30) NOT NULL,
	[bn_type] [int] NOT NULL,
	[lock_valid] [uniqueidentifier] NULL,
	[station_id] [int] NOT NULL,
	[pos_shop_id] [int] NOT NULL,
	[shop_code] [nvarchar](20) NOT NULL,
	[shop_name] [nvarchar](40) NOT NULL,
	[sell_date_time] [datetime] NULL,
	[order_id] [int] NULL,
	[inv_id] [int] NULL,
	[cloud_coupon_id] [int] NULL,
	[web_coupon_id] [uniqueidentifier] NULL,
	[web_coupon_code] [varchar](100) NOT NULL,
	[redeem_amt] [numeric](12, 2) NULL,
	[upcnt] [int] NULL,
	[coupon_seq] [int] NULL,
	[create_date] [datetime] NULL,
	[up_date] [datetime] NULL
) ON [PRIMARY]
ENDTEXT 
=SQLEXEC(nhand,ssql)

&&Lihong 2020-06-01 coupon
ssql="if not exists (select id from payway where id=-8 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-8,'現金禮券','Cash Coupon',3,1,0,0,0,'1990-1-1','2099-1-1',0,104,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

&&coupon

&&Lihong 2020.07.07 額外積分
=SQLEXEC(nhand,"alter table inv_detail add pointrate numeric(12, 2) null, pointfix numeric(12, 2) null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2012.01.30  hinv_detail ad tel
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add pointrate numeric(12, 2) null, pointfix numeric(12, 2) null ")>0
	ENDSCAN
ENDIF 


&&Lihong 2020-06-01 
=SQLEXEC(nhand,"alter table exec_android_data add remark5 varchar(4000) null")

&&Lihong 2020-07-13
=SQLEXEC(nhand,"alter table payway add split_pay bit null,split_pay_code varchar(200) null")

&&Lihong 2020-06-03 新桌同桌多人（微信）點菜會丟菜
TEXT TO ssql TEXTMERGE NOSHOW 
create table exec_android_table_lock(tableno nvarchar(100), mark_id nvarchar(100), addtime datetime)
ENDTEXT 
=SQLExec(nhand,ssql)

&&Lihong 2020.07.20
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 200)
	insert into message_log values (200, '餐檯鎖定成功', 'Table locked successfully', '_table_locked', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 201)
	insert into message_log values (201, '餐檯解鎖成功', 'Table unlocked successfully', '_table_unlocked', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&Lihong 2020.09.03
=SQLEXEC(nhand,"alter table outlet add qrcode_option bit null")

&&Lihong 2020.10.15
=SQLEXEC(nhand,"alter table warn_log add mark_id varchar(50) null")

&&Lihong 2020-11-16 modi售罄
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_modi_soldout' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'特別處理售罄'
		           ,'Modifier soldout'
		           ,0
		           ,14215660
		           ,'_modi_soldout'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
*modifier
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from table_function where pcode='_modi_soldout' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = ISNULL(MAX(id),0)+1 FROM table_function 
		SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM table_function 
		
		INSERT INTO [dbo].[table_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[updateno])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'特別處理售罄'
		           ,'Modifier soldout'
		           ,0
		           ,14215660
		           ,'_modi_soldout'
		           ,@updateno)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)


&&Lihong 2020.11.23
TEXT TO ssql NOSHOW 
if exists (select name from sysobjects (nolock) where type = 'u' and name = 'modi_soldout') and
	                            not exists (select name from sysobjects (nolock) where type = 'tr' and name = 'tr_modi_soldout')
                            begin
	                            exec ('create Trigger [dbo].[tr_modi_soldout] On [dbo].[modi_soldout] 
					                    for Update, insert, delete As
					                    begin
						                if exists(select * from proan_order_flag (nolock) where table_name = ''modi_soldout'')
						                begin
							                update proan_order_flag set flag = isnull(flag, 0) + 1, edit_date = getdate() where table_name = ''modi_soldout''
						                end
						                else
						                begin
							                insert into proan_order_flag(table_name, flag, edit_date) values(''modi_soldout'', ((select isnull(max(updateno), 0) + 1 from modi_soldout (nolock))), getdate())
						                end
					                end')	
                            end 
ENDTEXT
=SQLEXEC(nhand,ssql)


&&Lihong 20201.02.01 分級計時價
*timer_by = 0 按入座時間開始計算,  1 按菜式加入的時間開始計算
TEXT TO csql TEXTMERGE NOSHOW 
	alter table item add timer_item bit null, timer_min int null,timer_by int null,timer_level_1 numeric(18, 2) null,timer_level_2 numeric(18, 2) NULL 
	,timer_level_3 numeric(18, 2) NULL ,timer_level_4 numeric(18, 2) NULL 
	,timer_level_5 numeric(18, 2) NULL ,timer_level_6 numeric(18, 2) NULL 
	,timer_level_7 numeric(18, 2) NULL ,timer_level_8 numeric(18, 2) NULL 
	,timer_level_9 numeric(18, 2) NULL ,timer_level_10 numeric(18, 2) NULL 

	alter table item_backup add timer_item bit null, timer_min int null,timer_by int null,timer_level_1 numeric(18, 2) null,timer_level_2 numeric(18, 2) NULL 
	,timer_level_3 numeric(18, 2) NULL ,timer_level_4 numeric(18, 2) NULL 
	,timer_level_5 numeric(18, 2) NULL ,timer_level_6 numeric(18, 2) NULL 
	,timer_level_7 numeric(18, 2) NULL ,timer_level_8 numeric(18, 2) NULL 
	,timer_level_9 numeric(18, 2) NULL ,timer_level_10 numeric(18, 2) NULL 

ENDTEXT 
=SQLEXEC(nhand,csql)
*=SQLEXEC(nhand,"alter table order_main add endtime datetime null")


&&Lihong 20201.02.04 堂座自動落單數量限制
TEXT TO csql TEXTMERGE NOSHOW 
	alter table item add so_qr_order_count int null, so_tables_count_plus_ppl int null
	alter table item_backup add so_qr_order_count int null, so_tables_count_plus_ppl int null
ENDTEXT 
=SQLEXEC(nhand,csql)
&&Lihong 20201.02.04 堂座自動落單數量限制
TEXT TO csql TEXTMERGE NOSHOW 
	alter table item add so_tables_count_limit_type int null
	alter table item_backup add so_tables_count_limit_type int null
ENDTEXT 
=SQLEXEC(nhand,csql)

&&Lihong 20201.05.13 自動落單菜式落單間隔時間
TEXT TO csql TEXTMERGE NOSHOW 
	alter table item add so_item_diff_second int null
	alter table item_backup add so_item_diff_second int null
ENDTEXT 
=SQLEXEC(nhand,csql)

&&2021.03.15 Lihong 折扣備註
=SQLEXEC(nhand,"alter table disc add askremark int null")
=SQLEXEC(nhand,"alter table android_order_disc add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table android_order_itemdisc add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table order_disc add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table order_disc_bak add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table order_itemdisc add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table order_itemdisc_bak add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table inv_disc add disc_remark nvarchar(30) null")
=SQLEXEC(nhand,"alter table inv_itemdisc add disc_remark nvarchar(30) null")
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_disc_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add disc_remark nvarchar(30) null")
		cName="hinv_itemdisc_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add disc_remark nvarchar(30) null")
	ENDSCAN
ENDIF

&&Lihong 2021.04.23 印單後折扣
=SQLEXEC(nhand,"alter table android_order_disc add after_inv bit null")
=SQLEXEC(nhand,"alter table android_order_itemdisc add after_inv bit null")
=SQLEXEC(nhand,"alter table order_disc add after_inv bit null")
=SQLEXEC(nhand,"alter table order_disc_bak add after_inv bit null")
=SQLEXEC(nhand,"alter table order_itemdisc add after_inv bit null")
=SQLEXEC(nhand,"alter table order_itemdisc_bak add after_inv bit null")
=SQLEXEC(nhand,"alter table inv_disc add after_inv bit null")
=SQLEXEC(nhand,"alter table inv_itemdisc add after_inv bit null")
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_disc_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add after_inv bit null")
		cName="hinv_itemdisc_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add after_inv bit null")
	ENDSCAN
ENDIF
TEXT TO csql TEXTMERGE NOSHOW 
ALTER PROCEDURE [dbo].[p_delinv] AS

truncate table pay_print_detail
truncate table inv_print_detail
truncate table inv_print_main
truncate table pay_print_main
truncate table inv_print_void
truncate table table_booking
truncate table inv_reprint_void
truncate table print_tmp
truncate table order_barcode_temp


truncate table order_main
truncate table order_detail
truncate table order_modi
truncate table order_disc
truncate table order_itemdisc
	
truncate table inv
truncate table inv_detail
truncate table inv_modi
truncate table inv_disc
truncate table inv_itemdisc

truncate table inv_reprint_main 
truncate table inv_reprint_detail
truncate table inv_reprint_disc

truncate table order_print_main
truncate table order_print_detail
truncate table inv_print_job
truncate table pay_print_job
truncate table pay_detail

truncate table inv_html
truncate table order_html
truncate table pay_html
truncate table slip_print_main
truncate table slip_print_detail
truncate table inv_problem
truncate table order_void
truncate table print_job

truncate table payway_print_detail  
truncate table inv_print_disc     
truncate table print_finish      
truncate table print_server_log

truncate table inv_reprint_main
truncate table inv_reprint_detail
truncate table inv_reprint_disc

--Lihong 2021.04.23
truncate table disc_log

delete from tables where parent_table<>''
delete from tables where row=0 and col=0
update tables set order_id=0,status='',pre_status='',ppl=0,nsubtable=0,parent_table='',nshare_order=0,sit_too_long=0,inv_id='',have_unfinish=0,used_station='',inv_lock=0
ENDTEXT 
=SQLEXEC(nhand,csql)

&&Lihong 2021.05.07 條碼輸入價格數量
=SQLEXEC(nhand,"alter table system_setting ALTER COLUMN pcode nvarchar(40) not null")
=SQLEXEC(nhand,"alter table item add print_single bit  null")	
=SQLEXEC(nhand,"alter table item_backup add print_single bit  null")	
=SQLEXEC(nhand,"alter table order_detail add print_single bit  null")	
=SQLEXEC(nhand,"alter table order_detail_bak add print_single bit  null")	
=SQLEXEC(nhand,"alter table android_order_detail add print_single bit  null")	
=SQLEXEC(nhand,"alter table inv_detail add print_single bit  null")	
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add print_single bit  null")
	ENDSCAN
ENDIF

&&Lihong 2021.07.05 避免不同station同時執行create_inv_view 
IF lForceUpdate=.f.
	lstart_time = SECONDS()
	llwait_update = .T. 
	auto_update_msg = ""
	DO WHILE llwait_update 
		TEXT TO ssql TEXTMERGE NOSHOW
			delete sys_options where Type='autoupdate_lock' AND datediff(second, update_date, getdate()) > 30 
			IF exists (select 1 from sys_options where Type='autoupdate_lock') 
			SELECT cast(0 as int) as  lockok
			else 
			begin 
			INSERT INTO sys_options (Type, update_date) VALUES ('autoupdate_lock', getdate() )
			SELECT cast(1 as int) as  lockok
			end
		ENDTEXT 
		IF SQLExec(nhand,ssql, "exec_autoupdate_lock") < 0
			Aerror(err)
			auto_update_msg="check exec_autoupdate_lock fail : " + Trim(err(2))
			EXIT 
		ENDIF 
		lnlock = exec_autoupdate_lock.lockok
		USE IN SELECT("exec_autoupdate_lock")
		IF lnlock = 0 
		ELSE
			llwait_update = .F.
			EXIT 
		ENDIF 
		=inkey(1)
		IF SECONDS() - lstart_time > 20 &&最多等20S
			auto_update_msg="check exec_autoupdate_lock time out "
			EXIT 
		ENDIF 
	ENDDO 
	IF llwait_update = .T.
*!*			IF !EMPTY(auto_update_msg ) AND VARTYPE(frm_wait)="O"
*!*				frm_wait.showmessage("data auto update fail") 
*!*			ENDIF 
		Return .F.
	ENDIF 
ENDIF 

*
*!*	&&Lihong 2022.01.10 PSO_ORDER_SAVE_INV_ONLINE上菜紙打印電話地址外賣付款信息 保存到inv for 重打
*!*	=SQLEXEC(nhand,"alter table inv add fastfood_info varchar(30) null") 
*!*	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
*!*		SELECT cun_tmp
*!*		SCAN
*!*			cName="hinv_"+ALLTRIM(cun_tmp.name)
*!*			=SQLEXEC(nhand,"alter table "+cname+" add fastfood_info varchar(30) null")
*!*		ENDSCAN
*!*	ENDIF
*

*=SQLEXEC(nhand,"exec create_inv_view '', '1900-01-01', '2099-12-31' ")


&&Lihong 2021.05.20 雲會員積分即時扣減
=SQLEXEC(nhand,"alter table points_upload add redeem int  null")	
=SQLEXEC(nhand,"alter table points_upload ALTER COLUMN action nvarchar(40) not null")

&&Lihong 2021.07.30 堂座自動落單數量限制是否乘人數
TEXT TO csql TEXTMERGE NOSHOW 
	alter table item add so_qr_order_count_ppl bit null
	alter table item_backup add so_qr_order_count_ppl bit null
ENDTEXT 
=SQLEXEC(nhand,csql)

&&Lihong 2021.08.16 多價格
TEXT TO csql TEXTMERGE NOSHOW 
create table cate_item_price (
   id                   uniqueidentifier     not null,
   cate_id              int                  null,
   item_id              int                  null,
   price0               numeric(18, 5)       null,
   price1               numeric(18, 5)       null,
   updateno             int                  null,
   active               bit                  null,
   create_by            int                  null,
   create_date          datetime             null,
   edit_by              int                  null,
   edit_date            datetime             null,
   void_by              int                  null,
   void_date            datetime             null,
   constraint PK_CATE_ITEM_PRICE primary key (id)
)
ENDTEXT 
=SQLEXEC(nhand,csql)
=SQLEXEC(nhand,"alter table itemprice add cate_id_list nvarchar(100) null")
TEXT TO csql TEXTMERGE NOSHOW 
if not exists(select * from syscolumns where id=object_id('cate') and name='allow_kb_search') begin
alter table cate add allow_kb_search bit default 1 not null
--update cate set allow_kb_search=1
end
ENDTEXT 
=SQLEXEC(nhand, csql)
TEXT TO csql TEXTMERGE NOSHOW 
ALTER PROCEDURE [dbo].[p_delitem] AS
truncate table department
truncate table item_mcate
truncate table item_outlet_printer
truncate table itemdept

truncate table item
truncate table cate
truncate table soldout
truncate table outlet_print_mode
truncate table outlet_printer

truncate table itemlevel_rule
truncate table itemmodi
truncate table itemprice
truncate table cate_item_price
truncate table mitem
truncate table itemlevel

INSERT INTO itemlevel VALUES (1,1, 'Level1', 'Level1')
INSERT INTO itemlevel VALUES (1,2, 'Level2', 'Level2')
INSERT INTO itemlevel VALUES (1,3, 'Level3', 'Level3')
INSERT INTO itemlevel VALUES (1,4, 'Level4', 'Level4')
INSERT INTO itemlevel VALUES (1,5, 'Level5', 'Level5')
INSERT INTO itemlevel VALUES (1,6, 'Level6', 'Level6')
INSERT INTO itemlevel VALUES (1,7, 'Level7', 'Level7')
INSERT INTO itemlevel VALUES (1,8, 'Level8', 'Level8')
INSERT INTO itemlevel VALUES (1,9, 'Level9', 'Level9')
INSERT INTO itemlevel VALUES (1,10, 'Level10', 'Level10')

truncate table menu
truncate table itemdept
truncate table setitem
ENDTEXT 
=SQLEXEC(nhand,csql)


&&Lihong 2021.08.23 foodpanda
ssql="if not exists (select id from payway where id=-111 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-111,'foodpanda外賣','foodpanda外賣',3,1,0,0,0,'1990-1-1','2099-1-1',0,120,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand, "alter table cate add for_foodpanda bit null")

ssql="if not exists (select id from payway where id=-122 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-122,'Online-微信','Online-微信',3,1,0,0,0,'1990-1-1','2099-1-1',0,122,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

ssql="if not exists (select id from payway where id=-123 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-123,'Online-支付寶香港','Online-支付寶香港',3,1,0,0,0,'1990-1-1','2099-1-1',0,123,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

ssql="if not exists (select id from payway where id=-124 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-124,'Online-支付寶中國','Online-支付寶中國',3,1,0,0,0,'1990-1-1','2099-1-1',0,124,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

ssql="if not exists (select id from payway where id=-125 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-125,'Online-八達通','Online-八達通',3,1,0,0,0,'1990-1-1','2099-1-1',0,125,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)

TEXT TO csql TEXTMERGE NOSHOW 
if exists (select id from payway where id=-77 AND desccn='保雅外賣(信用卡)' ) 
UPDATE payway SET desccn='Online-信用卡', descen='Online-信用卡' where id=-77 
ENDTEXT 
=SQLEXEC(nhand,csql)

&&Lihong 2022.03.08
ssql="if not exists (select id from payway where id=-126 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-126,'Online-銀聯支付','Online-銀聯支付',3,1,0,0,0,'1990-1-1','2099-1-1',0,126,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)
ssql="if not exists (select id from payway where id=-127 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-127,'Online-轉數快','Online-轉數快',3,1,0,0,0,'1990-1-1','2099-1-1',0,127,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)


TEXT TO ssql NOSHOW 
IF NOT exists(select id from disc_main where id=-101) begin 
DECLARE @updateno int 
SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM disc_main 
INSERT INTO [disc_main]
           ([active]
           ,[id]
           ,[desccn]
           ,[descen]
           ,[dispord]
           ,[forecolor]
           ,[backcolor]
           ,[updateno])
     VALUES
           (0
           ,-101
           ,'foodpanda'
           ,'foodpanda discount'
           ,0
           ,0
           ,0
           ,@updateno)
 end
ENDTEXT
=SQLEXEC(nhand,ssql)

TEXT TO csql TEXTMERGE NOSHOW 
IF NOT exists(select id from disc where id=-101) begin 
DECLARE @updateno int
SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM disc

insert into  disc (active,id,parent_id,desccn,descen,discper,discamt,begdate,enddate,disclevel,disc_type,forecolor,backcolor,dispord,askqty,askremark ,points,active_user,
day1,day2,day3,day4,day5,day6,day7,holiday,ex_holiday,begtime,endtime,minAmt,updateno,dedu_srv) 
values (1, -101,-101,'foodpanda折扣','foodpanda discount',0,0,'1990-01-01','2099-12-31','all',3,0,0, 0,0,0,0,'all',
1,1,1,1,1,1,1,1,0,'00:00','23:59',0.00,@updateno,0) 
end
ENDTEXT 
=SQLEXEC(nhand,csql)
&&


&&Lihong 2021.09.16 foodpanda
=SQLEXEC(nhand, "alter table cate add foodpanda_channel int null")
=SQLEXEC(nhand, "alter table cate add foodpanda_add_rate numeric(18, 2) null")
=SQLEXEC(nhand, "alter table cate add foodpanda_add_rounding int null")

&&Lihong 2021.10.08 &&營業區域是否列印上菜紙/發票/付款清單
IF SQLEXEC(nhand, "alter table outlet add slip_print bit null" ) > 0
	=SQLEXEC(nhand, "UPDATE outlet set slip_print=1" )
ENDIF 
IF SQLEXEC(nhand, "alter table outlet add inv_print bit null" ) > 0
	=SQLEXEC(nhand, "UPDATE outlet set inv_print=1" )
ENDIF 
IF SQLEXEC(nhand, "alter table outlet add paylist_print bit null" ) > 0
	=SQLEXEC(nhand, "UPDATE outlet set paylist_print=1" )
ENDIF 
=SQLEXEC(nhand, "UPDATE system_setting set desccn='上菜紙打印機跟 營業區域的設定', descen='上菜紙打印機跟 營業區域的設定' where desccn='上菜紙跟 營業區域的設定' and pcode='__android_print_slip_outlet' ")
*

&&Lihong 2021.10.08 
=SQLEXEC(nhand,"alter table cate ALTER COLUMN active_outlet varchar(4000) not null") &&原varchar(100)
=SQLEXEC(nhand,"alter table cate ALTER COLUMN active_station varchar(4000) null") &&原varchar(100)->4000
=SQLEXEC(nhand,"alter table cate ALTER COLUMN active_modi varchar(4000) null") &&原varchar(200)->4000

=SQLEXEC(nhand,"alter table disc ALTER COLUMN disclevel nvarchar(254) null") &&原nvarchar(200) varchar能存更多勞? （大於254要varchar）
=SQLEXEC(nhand,"alter table disc ALTER COLUMN active_user varchar(4000) null") &&原varchar(200)
=SQLEXEC(nhand,"alter table disc add active_role varchar(4000) null")
=SQLEXEC(nhand,"alter table order_disc ALTER COLUMN disc_level varchar(254) null") &&原nvarchar(200)
=SQLEXEC(nhand,"alter table order_disc_bak ALTER COLUMN disc_level varchar(254) null") &&原nvarchar(200)

&&Lihong 2021.10.12 自助下單備註 
=SQLEXEC(nhand,"alter table cate add so_info_cn nvarchar(1000) null") 
=SQLEXEC(nhand,"alter table cate add so_info_en nvarchar(1000) null") 

&&Lihong 2021.10.12 必選特別處理時，全部選擇
IF SQLEXEC(nhand,"alter table modifier add must_all_select_option bit null") > 0 
	TEXT TO csql TEXTMERGE NOSHOW 
		update modifier set must_all_select_option=1 where ISNULL(parent_id,0)=0 
		--update modifier set updateno = (select max(updateno) from modifier) + 1 + id where ISNULL(parent_id,0)=0 

		declare @updateno int
		declare @id int
		declare @maxid int

		set @updateno = (select isnull(max(updateno), 0) from modifier)
		select @id = MIN(id)-1, @maxid = max(id) from modifier where ISNULL(parent_id,0)=0 

		while(@id is not null and @id < @maxid)
		begin
			select top 1 @id = id from modifier where ISNULL(parent_id,0)=0 and id > @id order by id
			set @updateno = @updateno + 1
			update modifier set updateno = @updateno where id = @id
		end

	ENDTEXT 
	=SQLEXEC(nhand, csql)
ENDIF 

&&Lihong 2021.10.18 電子標簽
=SQLEXEC(nhand,"alter table tables_qrcode_info add bind_esl bit null ")
=SQLEXEC(nhand,"alter table tables_qrcode_info add esl_id varchar(100) null ")
TEXT TO csql TEXTMERGE NOSHOW 
CREATE TABLE [esl_tables_wait_for_update](
	[id] [int] NOT NULL,
	[table_no] [varchar](100) NULL,
	[add_time] [datetime] NULL
)
ENDTEXT 
=SQLEXEC(nhand, csql)

&&Lihong 2021.10.19
=SQLEXEC(nhand,"alter table item add upgrade_type int null ")
=SQLEXEC(nhand,"alter table item add upgrade_limit_qty int null ")
=SQLEXEC(nhand,"alter table item_backup add upgrade_type int null ")
=SQLEXEC(nhand,"alter table item_backup add upgrade_limit_qty int null ")
IF SQLEXEC(nhand,"alter table item_upgrade add cate_id int default -1 not null ") > 0
	*IF SQLEXEC(nhand,"update item_upgrade set cate_id = -1 ") > 0 
		TEXT TO csql TEXTMERGE NOSHOW 
			Declare @Pk varChar(100) 
			Select @Pk=Name from sysobjects where Parent_Obj=OBJECT_ID('item_upgrade') and xtype='PK' 
			if @Pk is not null 
			  begin
			    exec('Alter table item_upgrade Drop '+ @Pk) 
			  end
			  ALTER Table item_upgrade ADD constraint pk_item_upgrade PRIMARY KEY nonclustered (item_id, belong_to_item_id, cate_id )
		ENDTEXT 
		IF SQLEXEC(nhand, csql) > 0
			=SQLEXEC(nhand,"alter table item_upgrade add limit_qty int null ")
		ENDIF 
	*ENDIF 
ENDIF 


&&Lihong 2021.11.24 cutorder
=SQLEXEC(nhand,"alter table item_cut_order add calc_mode int null ")
=SQLEXEC(nhand,"alter table tables add cut_time datetime null ")
=SQLEXEC(nhand,"alter table tables add off_time datetime null ")
*=SQLEXEC(nhand,"alter table tables_h add cut_time datetime null ")
*=SQLEXEC(nhand,"alter table tables_h add off_time datetime null ")

&&Lihong 2021.12.22 茶芥
=SQLEXEC(nhand," alter table outlet add item_id_cup_list varchar(254) null")
&&Lihong 2021.12.29 同檯
TEXT TO csql TEXTMERGE NOSHOW 
	create table same_table_detail (
	   same_table_id        uniqueidentifier     not null,
	   tableno              nvarchar(50)         not null,
	   constraint PK_SAME_TABLE_DETAIL primary key (same_table_id, tableno)
	)
ENDTEXT 
=SQLEXEC(nhand, csql)
TEXT TO csql TEXTMERGE NOSHOW 
	create table same_table (
	   id                   uniqueidentifier     not null,
	   remark               nvarchar(200)        null,
	   merge_to_tableno              nvarchar(50)         null,
	   add_by               int                  null,
	   add_time             datetime             null,
	   edit_by              int                  null,
	   edit_time            datetime             null,
	   constraint PK_SAME_TABLE primary key (id)
	)
ENDTEXT 
=SQLEXEC(nhand, csql)
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from table_function where pcode='_same_table' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = ISNULL(MAX(id),0)+1 FROM table_function 
		SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM table_function 
		
		INSERT INTO [dbo].[table_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[updateno])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'同檯設定'
		           ,'Setup Same Table'
		           ,0
		           ,14215660
		           ,'_same_table'
		           ,@updateno)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_same_table' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'同檯設定'
		           ,'Setup Same Table'
		           ,0
		           ,14215660
		           ,'_same_table'
		           ,1
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
=SQLEXEC(nhand,"alter table order_detail add same_tableno char(8) null")	
=SQLEXEC(nhand,"alter table order_detail_bak add same_tableno char(8) null")	
=SQLEXEC(nhand,"alter table android_order_detail add same_tableno char(8) null")	


&&Lihong 2022-01-12 套餐子項替換
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_sitem_sub_repl' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'套餐子項替換'
		           ,'Set Item replace'
		           ,0
		           ,14215660
		           ,'_sitem_sub_repl'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2022-01-12 套餐子項替換還原
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_sitem_sub_unrepl' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'套餐子項替換還原'
		           ,'Set Item replace undo'
		           ,0
		           ,14215660
		           ,'_sitem_sub_unrepl'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2022-02-15 售罄
 =SQLEXEC(nhand,"alter table item add soldout_qty numeric(18, 5) null ")
 =SQLEXEC(nhand,"alter table item add set_sub_item_sold_out bit null ")
 =SQLEXEC(nhand,"alter table item_backup add soldout_qty numeric(18, 5) null ")
 =SQLEXEC(nhand,"alter table item_backup add set_sub_item_sold_out bit null ")

&&Lihong 2021.02.21 PDS調用升級Rms6數據庫結構
TEXT TO ssql noshow 
if object_id(N'system_file_rms6') is not null 
alter table system_file_rms6 add file1_base64 varchar(max) null, checksum char(20), null 

ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2021.02.22
=SQLEXEC(nhand,"alter table points_upload add upresult varchar(250) null ")
=SQLEXEC(nhand,"alter table coupon_upload add upresult varchar(250) null ")

&&Lihong 2022.03.09
IF SQLEXEC(nhand, "alter table outlet add kit_print bit null" ) > 0
	=SQLEXEC(nhand, "UPDATE outlet set kit_print=1" )
ENDIF 


&&sam. 2022-03-08  每日部門人數

TEXT TO csql TEXTMERGE NOSHOW 
	create table department_section (   
		id                   uniqueidentifier     not null,   
		belongdate           datetime             null,   
		create_by            int                  null,   
		create_date          datetime             null,   
		edit_by              int                  null,   
		edit_date            datetime             null,   
		void_by              int                  null,   
		void_date            datetime             null,   
		u_hq				 bit				  null,   
		constraint PK_DEPARTMENT_SECTION primary key (id)
		)
		
	create table department_section_detail (   
		id                   uniqueidentifier     not null,   
		department_section_id uniqueidentifier    null,   
		department_id        int                  null,   
		section_id           int                  null,   
		ppl                  int                  null,   
		constraint PK_DEPARTMENT_SECTION_DETAIL primary key (id)
		)
		
	create nonclustered index Index_key on department_section_detail (
		department_section_id ASC,  
		department_id ASC,  
		section_id ASC
		)
ENDTEXT 
=SQLEXEC(nhand, csql)


TEXT TO cmd NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = '_dept_section_ppl')
		insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) values (@roleaccess_id,'_dept_section_ppl', '          每日部門人數', '          Department Section ppl', 251,1,1)
ENDTEXT
=SQLEXEC(nhand, cmd)


&&Lihong 2022.03.17 例席
=SQLEXEC(nhand,"alter table modifier add case_mat int null") 
=SQLEXEC(nhand,"alter table modifier add case_mat_Multiple numeric(8,2) null") 
=SQLEXEC(nhand,"alter table order_detail add orgqty_case_mat numeric(8,3) null")	
=SQLEXEC(nhand,"alter table order_detail_bak add orgqty_case_mat numeric(8,3) null")	
=SQLEXEC(nhand,"alter table android_order_detail add orgqty_case_mat numeric(8,3) null")	
=SQLEXEC(nhand,"alter table inv_detail add orgqty_case_mat numeric(8,3) null")	
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add orgqty_case_mat numeric(8,3) null")
	ENDSCAN
ENDIF

&&Lihong 2022.03.23 轉服務費率
TEXT TO csql TEXTMERGE NOSHOW 
create table srv_tran (
   active               bit                  null,
   srv_id               int                  not null,
   sub_id               int                  not null, /* min優先 */
   name               varchar(100)         null,
   outlet_id_list       varchar(100)         null,
   cate_id_list       varchar(800)         null,
   calc_type               int                  null, /* 1:by加入菜式時間 2:by入座時間 */
   start_date           datetime             null,
   end_date             datetime             null,
   start_time           char(5)              null,
   end_time             char(5)              null,
   tran_srv_id               int                  null,
   constraint PK_SRV_TRAN primary key (srv_id, sub_id)
)
ENDTEXT 
=SQLEXEC(nhand, csql)


&&sam.qr_code 營業區及時段設定
=SQLEXEC(nhand,"alter table cate add qr_time bit null ")

=SQLEXEC(nhand,"alter table cate add qr_active_section varchar(100) null ")
=SQLEXEC(nhand,"alter table cate add qr_active_outlet varchar(4000) null ")
 

IF SQLEXEC(nhand,"alter table cate add qr_day1 bit null,qr_day2 bit null,qr_day3 bit null,qr_day4 bit null,qr_day5 bit null,qr_day6 bit null,qr_day7 bit null,qr_holiday bit null,qr_ex_holiday bit null")>0

	SQLEXEC(nhand,"UPDATE cate set qr_day1=1,qr_day2=1,qr_day3=1,qr_day4=1,qr_day5=1,qr_day6=1,qr_day7=1,qr_holiday=1,qr_ex_holiday=0")

ENDIF

&&分部門營業報表
TEXT TO ssql NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'dept_sales_report')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'dept_sales_report', '          分部門營業報表', '         Department sales Report', 4100, 1,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)
TEXT TO ssql noshow
	if not exists (select * from report_lookup where cmd = 'do form form\dept_sales_report')
		insert into report_lookup values ('分部門營業報表', 'Department sales Report', 'do form form\dept_sales_report', 1, 58000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)

*!*	&&菜式種類 增加時段類型及時段 by sam 2022.04.06
*!*	=SQLEXEC(nhand,"alter table cate add section_type int null ")
*!*	=SQLEXEC(nhand,"alter table cate add begtime char(5) null, endtime char(5) null ")
*!*	=SQLEXEC(nhand,"alter table cate add qr_section_type int null ")
*!*	=SQLEXEC(nhand,"alter table cate add qr_begtime char(5) null, qr_endtime char(5) null ")
=SQLEXEC(nhand,"alter table cate add section_type int null, begtime char(5) null, endtime char(5) null")
=SQLEXEC(nhand,"alter table cate add qr_section_type int null,qr_begtime char(5) null, qr_endtime char(5) null")

&&Lihong 2022.04.12 時段轉價
TEXT TO csql TEXTMERGE NOSHOW 
create table change_price_lookup (
   id                   int                  not null,
   name                 nvarchar(100)        null,
   calc_time            char(5)              null,
   start_time           char(5)              null,
   end_time             char(5)              null,
   dispord              int                  null,
   constraint PK_CHANGE_PRICE_LOOKUP primary key (id)
)
ENDTEXT 
=SQLEXEC(nhand, csql)


*2022/04/12 by sam 部門人數
=SQLEXEC(nhand,"alter table department_section add voided bit null")
=SQLEXEC(nhand,"alter table department_section_detail alter column ppl numeric(12, 2) null") 	

&& 2022/04/15 合并單
TEXT TO ssql noshow		

	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'invinfo_merge_inv')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno,android)
		 values (@roleaccess_id, 'invinfo_merge_inv', '          合并單', '           merge inv info', 865, 1,0,1323,0) 

ENDTEXT

=SQLEXEC(nhand,ssql)

*qrcode_remind_mins 2022/04/18
=SQLEXEC(nhand, "alter table cate add qrcode_remind_mins int null")

&&Lihong 2022.04.19 上傳inv到storellet
TEXT TO ssql noshow	
CREATE TABLE [storellet_upload](
	[check_valid] [uniqueidentifier] NOT NULL,
	[action] [nvarchar](40) NOT NULL,
	[station_id] [int] NOT NULL,
	[pos_shop_id] [int] NOT NULL,
	[shop_code] [nvarchar](20) NOT NULL,
	[shop_name] [nvarchar](40) NOT NULL,
	[inv_id] [bigint] NOT NULL,
	[invamt] [numeric](12, 2) NULL,
	[paidtime] [datetime] NULL,
	[belongdate] [datetime] NULL,
	[upcnt] [int] NULL,
	[inv_seq] [int] NULL,
	[create_date] [datetime] NULL,
	[up_date] [datetime] NULL,
	[upresult] [varchar](250) NULL
) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)


*disporder by sam 2022/04/21
=SQLEXEC(nhand, "alter table itemlevel_rule add disporder int null")
&&在茶芥頁面上改數量
IF SQLEXEC(nhand,"alter table item add show_in_cup_mode bit null")>0		
	SQLEXEC(nhand,"update item set show_in_cup_mode = 0")
ENDIF
&&重點關注菜式
IF SQLEXEC(nhand,"alter table item add focus_item bit null")>0		
	SQLEXEC(nhand,"update item set focus_item = 0")
ENDIF
=SQLEXEC(nhand,"alter table item_backup add show_in_cup_mode bit null")	
=SQLEXEC(nhand,"alter table item_backup add focus_item bit null")	


&&重點菜式
TEXT TO ssql noshow	
	create table focus_item_list (   
		id                   uniqueidentifier     not null,   
		belongdate           datetime             null,   
		item_id              int                  null,   
		constraint PK_FOCUS_ITEM_LIST primary key (id))
	
	create nonclustered index Index_belongdate on focus_item_list (belongdate ASC)
ENDTEXT
=SQLEXEC(nhand,ssql)

&&2022/04/23 by sam 銷售額歸納到部門
=SQLEXEC(nhand, "alter table department add calc_to_department_id int null")


&&2022/04/23 by sam 按整條記算數量
=SQLEXEC(nhand, "alter table item add by_entity_for_calc_qty bit null")
=SQLEXEC(nhand, "alter table item_backup add by_entity_for_calc_qty bit null")	


&&Lihong 2022.04.20 同檯發票付款單分桌號
=SQLEXEC(nhand,"alter table inv_detail add same_tableno char(8) null")
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add same_tableno char(8) null")
	ENDSCAN
ENDIF
=SQLEXEC(nhand,"alter table inv_print_detail add same_tableno char(8) null")
=SQLEXEC(nhand,"alter table inv_reprint_detail add same_tableno char(8) null")
=SQLEXEC(nhand,"alter table inv_print_void add same_tableno char(8) null")
=SQLEXEC(nhand,"alter table inv_reprint_void add same_tableno char(8) null")
=SQLEXEC(nhand,"alter table pay_print_detail add same_tableno char(8) null")

&&Lihong 2022.04.24 價格類型
=SQLEXEC(nhand,"alter table order_detail add price_type int null")	
=SQLEXEC(nhand,"alter table order_detail_bak add price_type int null")	
=SQLEXEC(nhand,"alter table android_order_detail add price_type int null")	
=SQLEXEC(nhand,"alter table inv_detail add price_type int null")	
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add price_type int null")
	ENDSCAN
ENDIF

&&Lihong 2022.04.24 entity Qty
=SQLEXEC(nhand,"alter table order_detail add qty_entity numeric(8,3) null")	
=SQLEXEC(nhand,"alter table order_detail_bak add qty_entity numeric(8,3) null")	
=SQLEXEC(nhand,"alter table android_order_detail add qty_entity numeric(8,3) null")	
=SQLEXEC(nhand,"alter table inv_detail add qty_entity numeric(8,3) null")	
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0 
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table " + cname + " add qty_entity numeric(8,3) null")
	ENDSCAN
ENDIF

&&加入"套餐子項替換"取消原因
TEXT TO csql noshow	
	IF NOT exists (select id from void_reason where id=-2)
	insert into void_reason (active,id,desccn,descen,dispord)
	values(0,-2,'套餐子項','Item Sub',-2)
ENDTEXT
=SQLEXEC(nhand,csql)

&&Lihong 2022-04-27 菜式複製
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_order_item_copy' OR pcode='_COPY' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'菜式複製'
		           ,'Re-Order'
		           ,0
		           ,14215660
		           ,'_order_item_copy'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)


*=SQLEXEC(nhand,"exec create_inv_view '', '1900-01-01', '2099-12-31' ")


&& 補操作log
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 202)
	insert into message_log values (202, '菜式設定保存', 'setup item save', '_setup_item_save', 1, 1)
	
	if not exists (select id from message_log where id = 203)
	insert into message_log values (203, '菜式設定刪除菜式', 'del setup item', '_del_setup_item', 1, 1)
	
	if not exists (select id from message_log where id = 204)
	insert into message_log values (204, '保存售罄設定', 'Save soldout setting', '_save_item_soldout', 1, 1)
	
	if not exists (select id from message_log where id = 205)
	insert into message_log values (205, '同檯設定加檯', 'order enter same table', '_same_table_add_table', 1, 1)
	
	if not exists (select id from message_log where id = 206)
	insert into message_log values (206, '同檯設定減檯', 'order exit same table', '_same_table_del_table', 1, 1)
	
ENDTEXT 
=SQLEXEC(nhand, cmd)


 
&&顯示 更改發票內容的權限設定
TEXT TO ssql noshow		

	DECLARE @updno int
	SET @updno = (select ISNULL(max(updateno), 0)+1 from roleaccess)
	
	UPDATE roleaccess SET visible = 1, updateno = @updno where code = 'invinfo_edit_content'

ENDTEXT
=SQLEXEC(nhand,ssql)

&&顯示 更改發票鎖腳的權限設定 By Waston 17/05/2022
TEXT TO ssql noshow		

	DECLARE @updno int
	SET @updno = (select ISNULL(max(updateno), 0)+1 from roleaccess)
	
	UPDATE roleaccess SET visible = 1, updateno = @updno where code = 'invinfo_edit_cashier'
	
ENDTEXT
=SQLEXEC(nhand,ssql)


&&Lihong 2022.05.05 info log
=SQLEXEC(nhand,"alter table order_detail add add_user_id int null, add_user_station_id int null")	
=SQLEXEC(nhand,"alter table order_detail_bak add add_user_id int null, add_user_station_id int null")	
=SQLEXEC(nhand,"alter table android_order_detail add add_user_id int null, add_user_station_id int null")
*!*	=SQLEXEC(nhand,"alter table inv add add_login_user_id int null, add_cashier_user_id int null, add_time datetime null, edit_user_id int null, edit_station_id int null, edit_time datetime null, void_user_id int null, void_station_id int null, void_time datetime null") 
*!*	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
*!*		SELECT cun_tmp
*!*		SCAN
*!*			cName="hinv_"+ALLTRIM(cun_tmp.name)
*!*			=SQLEXEC(nhand,"alter table "+cname+" add add_login_user_id int null, add_cashier_user_id int null, add_time datetime null, edit_user_id int null, edit_station_id int null, edit_time datetime null, void_user_id int null, void_station_id int null, void_time datetime null")
*!*		ENDSCAN
*!*	ENDIF
=SQLEXEC(nhand,"alter table inv_detail add add_user_id int null, add_user_station_id int null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add add_user_id int null, add_user_station_id int null")
	ENDSCAN
ENDIF
*=SQLEXEC(nhand,"exec create_inv_view '', '1900-01-01', '2099-12-31' ") 

&&節假日 2022/04/28
TEXT TO ssql noshow	
	CREATE TABLE [dbo].[festival](
		[id] [int] NOT NULL,
		[active] [bit] NOT NULL,
		[name] [nvarchar](50) NOT NULL,
		[begdate] [datetime] NOT NULL,
		[enddate] [datetime] NOT NULL,
		[recur] [bit] NOT NULL,
		[chi_mess1] [nvarchar](50) NULL,
		[chi_mess2] [nvarchar](50) NULL,
		[chi_mess3] [nvarchar](50) NULL,
		[en_mess1] [nvarchar](50) NULL,
		[en_mess2] [nvarchar](50) NULL,
		[en_mess3] [nvarchar](50) NULL,
		[createdate] [datetime] NOT NULL,
		[pbegdate] [datetime] NULL,
		[penddate] [datetime] NULL,
		[updateno] [int] NULL,
		constraint PK_FESTIVAL primary key nonclustered (id)
	) ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

&&菜式種類setting 節日
TEXT TO ssql noshow
	alter table cate add festival bit null
	alter table cate add ex_festival bit null
	alter table cate add qr_festival bit null
	alter table cate add qr_ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)

&&折扣setting 節日
TEXT TO ssql noshow
	alter table disc add festival bit null
	alter table disc add ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)


&&菜式時段售價setting 節日
TEXT TO ssql noshow
	alter table itemprice add festival bit null
	alter table itemprice add ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)

&&會員積分setting 節日
TEXT TO ssql noshow
	alter table member_point add festival bit null
	alter table member_point add ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)

&&自動折扣setting 節日
TEXT TO ssql noshow
	alter table autoDisc add festival bit null
	alter table autoDisc add ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)

&&截單時間setting 節日
TEXT TO ssql noshow
	alter table item_cut_order add festival bit null
	alter table item_cut_order add ex_festival bit null
ENDTEXT
=SQLEXEC(nhand,ssql)

&&節假日菜單權限
TEXT TO ssql NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'setup_festival')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'setup_festival', '          節假日設定', '         Setup festival', 1250, 1,1) 
ENDTEXT
=SQLEXEC(nhand,ssql)  

*!*	查看修改發票日志權限 by waston 09/05/2022
TEXT TO ssql NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'Invinfo_editinvlog')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'Invinfo_editinvlog', '          查看修改發票日志', '         View invoice modified log', 877, 1,1) 
ENDTEXT
=SQLEXEC(nhand,ssql)

&& addb dy donald 05/05/2022
TEXT TO ssql noshow	
	create table edit_inv_log (
	   id                   uniqueidentifier     not null,
	   inv_id               int                  null,
	   message_log_id       int                  null,
	   old_record           nvarchar(800)        null,
	   new_record           nvarchar(800)        null,
	   add_user_id          int                  null,
	   add_station_id       int                  null,
	   add_time             datetime             null,
	   constraint PK_EDIT_INV_LOG primary key nonclustered (id)
	)
	
	create clustered index Index_inv_id_c on edit_inv_log (inv_id ASC)
ENDTEXT
=SQLEXEC(nhand,ssql)

*時間售價 +itemlevel_id 2022/05/07
=SQLEXEC(nhand,"alter table itemprice add itemlevel_id int null")
=SQLEXEC(nhand,"alter table itemprice alter column item_id int null")

*售罄 2022/05/08
=SQLEXEC(nhand,"alter table item add soldout_user_id int null")
=SQLEXEC(nhand,"alter table item add soldout_station_id int null")

&&Lihong 2022.05.09 info log
TEXT TO csql TEXTMERGE NOSHOW 
if not exists(select * from syscolumns where id=object_id('inv') and name='inv_prt_login_user_id') begin
	alter table inv drop column add_login_user_id
	alter table inv drop column add_cashier_user_id
	alter table inv drop column add_time
end
ENDTEXT 
=SQLEXEC(nhand, csql) 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		TEXT TO csql TEXTMERGE NOSHOW 
		if not exists(select * from syscolumns where id=object_id('<<cName>>') and name='inv_prt_login_user_id') begin
			alter table <<cName>> drop column add_login_user_id
			alter table <<cName>> drop column add_cashier_user_id
			alter table <<cName>> drop column add_time
		end
		ENDTEXT 
		=SQLEXEC(nhand, csql) 
	ENDSCAN
ENDIF
=SQLEXEC(nhand,"alter table inv add edit_user_id int null, edit_station_id int null, edit_time datetime null, void_user_id int null, void_station_id int null, void_time datetime null") 
=SQLEXEC(nhand,"alter table inv add inv_prt_time datetime null, inv_prt_station_id int null, inv_prt_login_user_id int null, inv_prt_cashier_user_id int null, pay_station_id int null, pay_login_user_id int null, pay_cashier_user_id int null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add edit_user_id int null, edit_station_id int null, edit_time datetime null, void_user_id int null, void_station_id int null, void_time datetime null") 
		=SQLEXEC(nhand,"alter table "+cname+" add inv_prt_time datetime null, inv_prt_station_id int null, inv_prt_login_user_id int null, inv_prt_cashier_user_id int null, pay_station_id int null, pay_login_user_id int null, pay_cashier_user_id int null") 
	ENDSCAN
ENDIF

*加大一點cate_id_list 2022/05/10 by sam
=SQLEXEC(nhand,"alter table itemprice ALTER COLUMN cate_id_list nvarchar(254) null")

*多分店統一碼
=SQLEXEC(nhand,"alter table item add pr_index_code nvarchar(100) null")

&&Lihong 2022-06-13 
=SQLEXEC(nhand,"alter table order_main alter column remark varchar(250) null")
=SQLEXEC(nhand,"alter table order_main_bak alter column remark varchar(250) null")
=SQLEXEC(nhand,"alter table android_order_main alter column remark varchar(250) null")

=SQLEXEC(nhand,"alter table inv alter column remark varchar(250) null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" alter column remark varchar(250) null") 
	ENDSCAN
ENDIF

&&Lihong 2022.05.15
=SQLEXEC(nhand,"alter table order_main add primary key(id)")


&&Lihong 2022.05.18 work_table_xinvprinted log
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 207)
	insert into message_log values (207, '進入發票列表', 'Enter inv list', '_enter_inv_list', 1, 1)

	if not exists (select id from message_log where id = 208)
	insert into message_log values (208, '發票列表操作', 'Operate inv list', '_operate_inv_list', 1, 1)
	
	if not exists (select id from message_log where id = 209)
	insert into message_log values (209, '退出發票列表', 'Exit  inv list', '_exit_inv_list', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&結帳后更改分帳 2022/05/23 by sam
IF SQLEXEC(nhand,"alter table item add modi_dept_after_inv bit default 0 ") > 0			
	=SQLEXEC(nhand, "update item set modi_dept_after_inv = 0 ")
ENDIF

&&鎖腳模式，直接綁定工作站 add by donald 23/05/2022
IF SQLEXEC(nhand, "alter table station add lock_pay_cashier_id int default -1") > 0			
	=SQLEXEC(nhand, "update station set lock_pay_cashier_id = -1 ")
ENDIF

=SQLEXEC(nhand, "alter table station add lock_pay_cashier_datetime datetime null")


&&店長休息 席數
=SQLEXEC(nhand, "alter table department_section add manager_rest bit default 0 not null ") 
=SQLEXEC(nhand, "alter table department_section add feast_qty numeric(12,2) default 0 not null")

&&Lihong 2022-05-30 菜式複製From Table
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_table_item_copy')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'複製全檯菜式'
		           ,'Copy Table Item'
		           ,0
		           ,14215660
		           ,'_table_item_copy'
		           ,0
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
TEXT TO cmd NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'table_item_copy')
	insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) VALUES 
	( @roleaccess_id, 'table_item_copy', '          複製全檯菜式', '          Copy Table Item' , 537 , 1 ,1 )
ENDTEXT 
=SQLEXEC(nhand, cmd)

=SQLEXEC(nhand, "alter table storellet_upload add member_id int null")
=SQLEXEC(nhand, "alter table storellet_upload add coupon_id varchar(50) null")
=SQLEXEC(nhand, "alter table storellet_upload add member_carno varchar(50) null")

&&add soldout_expiry_date 有效期至
=SQLEXEC(nhand,"alter table item add soldout_expiry_date datetime null")

&&補item_backup by sam 2022/06/02
=SQLEXEC(nhand,"alter table item_backup add soldout_user_id int null")
=SQLEXEC(nhand,"alter table item_backup add soldout_station_id int null")
=SQLEXEC(nhand,"alter table item_backup add pr_index_code nvarchar(100) null")
=SQLEXEC(nhand,"alter table item_backup add modi_dept_after_inv bit default 0 ")
=SQLEXEC(nhand,"alter table item_backup add soldout_expiry_date datetime null")	
 
&&乘人數 by sam 2022/06/02 
=SQLEXEC(nhand, "alter table item add so_tables_count_plus_ppl_active bit default 1 not null ") 
=SQLEXEC(nhand, "alter table item_backup add so_tables_count_plus_ppl_active bit default 1 not null ") 

&&茶芥日誌
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 210)
	insert into message_log values (210, '茶芥', 'Tea fee', '_tea_fee', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

&&數量 by sam 2022/06/15
=SQLEXEC(nhand,"alter table item add pr_index_qty numeric(18, 5) null")
=SQLEXEC(nhand,"alter table item_backup add pr_index_qty numeric(18, 5) null")
&&是否參與分帳 by sam 2022/06/16
=SQLEXEC(nhand, "alter table department add is_itemdept bit default 1 not null ") 


&&部門vs分市報表 by sam 
TEXT TO ssql NOSHOW 
	DECLARE @roleaccess_id int
	SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
	if not exists (select * from roleaccess where code = 'fr_dept_vs_section')
		insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add)
		 values (@roleaccess_id, 'fr_dept_vs_section', '          部門VS分市報表', '         Department vs section Report', 4200, 1,1) 
ENDTEXT
c=SQLEXEC(nhand,ssql)
TEXT TO ssql noshow
	if not exists (select * from report_lookup where cmd = 'do form form\fr_dept_vs_section')
		insert into report_lookup values ('部門VS分市報表', 'Department vs section Report', 'do form form\fr_dept_vs_section', 1, 59000 , '', '1,2,3,4,5,6,7,8,9')
ENDTEXT
c=SQLEXEC(nhand,ssql)


&&Lihong 2022-06-20 轉價
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_set_price_period')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'時段轉價'
		           ,'Price By Period'
		           ,0
		           ,14215660
		           ,'_set_price_period'
		           ,0
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
=SQLEXEC(nhand,"alter table order_main add price_period_id int null")
=SQLEXEC(nhand,"alter table order_main_bak add price_period_id int null")
=SQLEXEC(nhand,"alter table android_order_main add price_period_id int null")

&&Lihong 2022-06-24 更改部門分帳
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_change_itemdept')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'更改部門分帳'
		           ,'Change dept breakdown'
		           ,0
		           ,14215660
		           ,'_change_itemdept'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2022.06.28 本機打印廚房單
=SQLEXEC(nhand,"alter table item add local_print_kit bit null")
=SQLEXEC(nhand,"alter table item_backup add local_print_kit bit null")
=SQLEXEC(nhand,"alter table outlet add qr_android_local_kit_printer_id int null") 

=SQLEXEC(nhand,"alter table inv_print_main alter column remark nvarchar(250) null ")
=SQLEXEC(nhand,"alter table inv_print_main alter column inv_remark nvarchar(250) null ")
=SQLEXEC(nhand,"alter table inv_print_main alter column inv_remark2 nvarchar(250) null ")
=SQLEXEC(nhand,"alter table inv_reprint_main alter column remark nvarchar(250) null ")
=SQLEXEC(nhand,"alter table inv_reprint_main alter column inv_remark nvarchar(250) null ")
=SQLEXEC(nhand,"alter table inv_reprint_main alter column inv_remark2 nvarchar(250) null ")

&& add dy sam 08/07/2022
TEXT TO ssql noshow	
	CREATE TABLE [dbo].[item_pos_material_list](
		[item_id] [int] NOT NULL,
		[sub_id] [int] NOT NULL,
		[pos_item_code] [nvarchar](30) NOT NULL,
		[pos_item_name] [nvarchar](50) NULL,
		[qty] [numeric](18, 5) NULL,
		[pos_unit_name] [nvarchar](20) NULL
	) 
ENDTEXT
=SQLEXEC(nhand,ssql)

&&Lihong 2022.07.07 非HQ版自動升級
TEXT TO ssql noshow 
if object_id(N'system_file_rms6') is not null 
alter table system_file_rms6 add update_datetime64 datetime NULL 

ENDTEXT
=SQLEXEC(nhand,ssql)
TEXT TO ssql NOSHOW 
if object_id(N'system_file_rms6') is null 
CREATE TABLE [system_file_rms6_single](
	[filename] [char](50) NOT NULL,
	[filepath] [char](50) NOT NULL,
	[file1] [text] NULL,
	[file2] [text] NULL,
	[update_datetime] [datetime] NULL,
	[update_station] [nvarchar](100) NULL,
	[file1_base64] varchar(max) NULL,
	[checksum] char(20) NULL,
	[update_datetime64] [datetime] NULL,
 CONSTRAINT [PK_system_file_rms6_single] PRIMARY KEY CLUSTERED 
(
	[filename] ASC,
	[filepath] ASC
) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
ENDTEXT
=SQLEXEC(nhand,ssql)

&&更改入座時間日誌
TEXT TO cmd noshow
	if not exists (select id from message_log where id = 211)
	insert into message_log values (211, '更改入座時間', 'Change sit time', '_change_sit_time', 1, 1)
ENDTEXT 
=SQLEXEC(nhand, cmd)

ENDIF   &&  End of  first time runing  (_last_run_step = 0 ) By Waston  20/07/2022


* chris 2021-06-16
* add sys_user.code
IF _last_run_step < 2  
	WAIT WINDOW "2 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, " ALTER table sys_user ADD code varchar(30) ")

	=SQLEXEC(nhand,"update disc set desccn='無折扣', descen='No Discount',updateno=(select ISNULL(MAX(updateno),0)+1 from disc ) where id=-1 and descen='member discount' ")
ENDIF 
&&2022.01.18
IF _last_run_step < 3
	WAIT WINDOW "3 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table warn_log ALTER COLUMN click_user nchar(20) null") &&原nchar(10)
	=SQLEXEC(nhand,"alter table warn_log ALTER COLUMN click_station nvarchar(50) null") &&原nchar(20)
ENDIF 


&&Lihong 2022.07.20 點菜站點，追單點菜時間
IF _last_run_step < 4
	=SQLEXEC(nhand,"alter table order_print_main add order_station nvarchar(50) NULL")
	=SQLEXEC(nhand,"alter table order_print_main add remin_order_time datetime null")
ENDIF 

&&2022.07.18
IF _last_run_step < 5

	WAIT WINDOW "5 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table item_pos_material_list add pos_item_id int not null default -1") 
ENDIF

&&2022-08-01
IF _last_run_step < 7

	WAIT WINDOW "7 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table department add allow_pos6_report_calc_to bit not null default 1") 
ENDIF 

&&2022-08-08
IF _last_run_step < 8

	WAIT WINDOW "8 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	TEXT TO ssql noshow	
		CREATE TABLE [dbo].[pos_department](
			[id] [int] NOT NULL,
			[code] [nvarchar](20) NOT NULL,
			[name] [nvarchar](100) NOT NULL,
			[active] [bit] NOT NULL,
			[updateno] [int] NULL 
		) 
	ENDTEXT
	=SQLEXEC(nhand,ssql)
	
ENDIF 

&&Autodisc add begdate and enddate By Waston 09/08/2022
IF _last_run_step < 9
	WAIT WINDOW "9 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		ALTER table Autodisc ADD begdate datetime NOT NULL DEFAULT '1900-01-01'
		ALTER table Autodisc ADD enddate datetime NOT NULL DEFAULT '2099-12-31'
	ENDTEXT 
	=SQLEXEC(nhand,ssql)

ENDIF 

&& 種類計算時間
IF _last_run_step < 10
	WAIT WINDOW "10 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

	=SQLEXEC(nhand, "alter table cate add calc_time_by int not null default 0 ") 
ENDIF 

&&Lihong 2022-08-03 
IF _last_run_step < 11
	WAIT WINDOW "11 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd noshow
		CREATE TABLE [esl_ap](
		 [id] [int] NOT NULL,
		 [name] [varchar](100) NULL,
		 [sn] [varchar](100) NULL,
		 CONSTRAINT [PK_esl_ap] PRIMARY KEY CLUSTERED 
		(
		 [id] ASC
		)) ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
	=SQLEXEC(nhand,"alter table tables_qrcode_info add esl_ap varchar(100) null ")
ENDIF 

&& sam 2022-08-16 會員消費分析報錯  無table
IF _last_run_step < 12
	WAIT WINDOW "12 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

	TEXT TO cmd noshow		
		CREATE TABLE [member_check_item](
			[id] [int] NOT NULL,
			[start_time] [char](5) NULL,
			[end_time] [char](5) NULL,
			[item_id] [int] NULL,
			 CONSTRAINT [pk_language_id] PRIMARY KEY CLUSTERED 
			(
				[id] ASC
			)
			) ON [PRIMARY]
	ENDTEXT 

	=SQLEXEC(nhand, cmd)

ENDIF 

&&Lihong 2022.08.16 
IF _last_run_step < 13
	WAIT WINDOW "13 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

	=SQLEXEC(nhand,"alter table inv add same_table_count int null") 
	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
		SELECT cun_tmp
		SCAN
			cName="hinv_"+ALLTRIM(cun_tmp.name)
			=SQLEXEC(nhand,"alter table "+cname+" add same_table_count int null")
		ENDSCAN
	ENDIF
ENDIF 

&&分帳用的臨時表 By Waston 18/08/2022
IF _last_run_step < 14
	WAIT WINDOW "14 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE  
		CREATE TABLE [dbo].[INV_SPLIT](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[inv_id] [int] NOT NULL,
		[sub_id] [varchar](30) NOT NULL,
		[member_id] [int] NULL,
		[cust_name] [varchar](30) NULL,
		[cust_amt] [numeric](12, 2) NOT NULL,
		[paid_amt] [numeric](12, 2) NULL,
		[is_paid] [bit] NOT NULL Default 0 ,
		[is_selected] [bit] NOT NULL Default 0 ,
		[split_mode] [int] NOT NULL Default 1
		) 
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF 

&&節假日設置增加字段 By Waston 19/08/2022
IF _last_run_step < 15
	WAIT WINDOW "15 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		ALTER TABLE [dbo].[festival] ADD 
			date_start_time char(5) NOT NULL  Default '00:00' ,
			date_end_time char(5)   NOT NULL Default '23:59',
			start_time char(5) NOT NULL  Default '00:00',
			end_time char(5) NOT NULL Default '23:59' 
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF 	

&&會員積分更改權限 By Waston 24/08/2022

IF _last_run_step < 16
	WAIT WINDOW "16 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		If not Exists (Select * From roleaccess Where code = 'points_change')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id, 'points_change', '          更改會員積分', '          Change member points' , 1405 , 1 ,1 )
	ENDTEXT 

	=SQLEXEC(nhand, cmd)
ENDIF 	


&&更改會員積分日志ID  By Waston 24/08/2022
IF _last_run_step < 17
	WAIT WINDOW "17 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		IF Not Exists (Select id From message_log Where id = 212)
			Insert Into message_log (
			ID ,
			desccn ,
			descen , 
			pcode , 
			log_level ,
			updated 
			) 
			Values (
			212 , 
			'更改會員積分' ,
			 'Change member points' , 
			 '_change_member_points' , 
			 1 , 
			 1
			 )
	ENDTEXT 
	
	=SQLEXEC(nhand, cmd)
ENDIF 	

&&Lihong 2022.08.19 分帳
IF _last_run_step < 18
	WAIT WINDOW "18 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table pay_detail add aa_sub_id varchar(30) null")
	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2019.03.19
		SELECT cun_tmp
		SCAN
			cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
			SQLEXEC(nhand,"alter table "+cname+" add aa_sub_id varchar(30) null ")
		ENDSCAN
	ENDIF
ENDIF

&&Lihong 2022.08.19 分帳
IF _last_run_step < 19
	WAIT WINDOW "19 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql noshow 
		alter table pay_detail add aa_sub_add_fee_uid numeric(10,5), aa_sub_paidtime datetime null, aa_sub_adduser nvarchar(20) null, aa_sub_station_id int null, aa_sub_octopus bit null, aa_sub_oct_invID int null, 
			aa_sub_pay_station_id int null, aa_sub_pay_login_user_id int null, aa_sub_pay_cashier_user_id int null
	ENDTEXT 
	=SQLEXEC(nhand, ssql)
	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		&&2019.03.19
		SELECT cun_tmp
		SCAN
			cName="hinv_pay_"+ALLTRIM(cun_tmp.name)
			TEXT TO ssql TEXTMERGE noshow 
				alter table <<cname>> add aa_sub_add_fee_uid numeric(10,5), aa_sub_paidtime datetime null, aa_sub_adduser nvarchar(20) null, aa_sub_station_id int null, aa_sub_octopus bit null, aa_sub_oct_invID int null, 
					aa_sub_pay_station_id int null, aa_sub_pay_login_user_id int null, aa_sub_pay_cashier_user_id int null
			ENDTEXT 
			=SQLEXEC(nhand, ssql)
		ENDSCAN
	ENDIF
ENDIF

&&Lihong 2022.08.19 分帳
IF _last_run_step < 20
	WAIT WINDOW "20 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table pay_print_main add aa_sub_id varchar(30) null") 			
ENDIF 

&&Lihong 2022.09.02 
IF _last_run_step < 21
	WAIT WINDOW "21 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table tables alter column used_station char(50) not null") 
	=SQLEXEC(nhand,"alter table tables_h alter column used_station char(50) not null") 

	=SQLEXEC(nhand,"alter table order_main alter column used_station nvarchar(50) null") 
	=SQLEXEC(nhand,"alter table order_main_h alter column used_station nvarchar(50) null") 
	=SQLEXEC(nhand,"alter table order_main_bak alter column used_station nvarchar(50) null") 

	=SQLEXEC(nhand,"alter table order_barcode_temp alter column used_station char(50) null") 
	
	=SQLEXEC(nhand,"alter table android_order_main alter column used_station nvarchar(50) null") 

ENDIF 

IF _last_run_step < 22  && Atte增加字段 By Waston 06/09/2022
	WAIT WINDOW "22 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table atte add updateno int not null default 1 ") 
	=SQLEXEC(nhand,"alter table atte add u_hq bit not null default 0 ") 
ENDIF 	

&&Lihong 2022.08.19 分帳
IF _last_run_step < 23
	WAIT WINDOW "23 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql noshow 
		CREATE TABLE [inv_print_split](
			[pid] [char](20) NULL,
			[split_desc] [nvarchar](100) NULL,
			[cust_amt] [numeric](12, 2) NULL
		) ON [PRIMARY]
	ENDTEXT
	=SQLEXEC(nhand, ssql)
ENDIF 


&&2022-09-09 by sam 特別處理至少選擇
IF _last_run_step < 24
	WAIT WINDOW "24 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	=SQLEXEC(nhand,"alter table modifier add min_choise int null")
ENDIF 

&&Lihong 2022.09.08 拆數
IF _last_run_step < 25
	WAIT WINDOW "25 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table inv_split add split_num bit null")
ENDIF 


IF _last_run_step < 26  &&菜式增加最低點菜數量 By Waston 22/09/2022
	WAIT WINDOW "26 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table item add qr_min_order_qty int null")
	=SQLEXEC(nhand,"alter table item_backup add qr_min_order_qty int null")
ENDIF 	


&&Lihong 2022-09-16 fastfood hold
IF _last_run_step < 27
WAIT WINDOW "27 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_fastfood_hold')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'外賣暫存'
		           ,'Hold Order'
		           ,0
		           ,14215660
		           ,'_fastfood_hold'
		           ,1
		           ,1
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand, ssql)
ENDIF 

IF _last_run_step < 28   &&By Waston 26/09/2022
	WAIT WINDOW "28 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	ssql = "Alter table department add srv_to_dept bit not null default 0 "
	=SQLEXEC(nhand, ssql)
ENDIF 	

IF _last_run_step < 29  &&By Waston 28/09/2022
	WAIT WINDOW "29 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	ssql = "Alter table sys_user add is_cashier bit not null default 1 "
	=SQLEXEC(nhand, ssql)
ENDIF 	


IF _last_run_step < 30  &&By Waston 28/09/2022
	WAIT WINDOW "30 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		Alter Table srv_tran add day1 bit NOT NULL DEFAULT 1
		Alter Table srv_tran add day2 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add day3 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add day4 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add day5 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add day6 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add day7 bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add festival bit NOT NULL DEFAULT 1 
		Alter Table srv_tran add ex_festival bit NOT NULL DEFAULT 0 
		Alter Table srv_tran add holiday bit NOT NULL DEFAULT 1
		Alter Table srv_tran add ex_holiday bit NOT NULL DEFAULT 0 
	ENDTEXT 
	=SQLEXEC(nhand, ssql)	
ENDIF 	

&&Lihong 2022.09.28 
IF _last_run_step < 31  
	WAIT WINDOW "31 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table tables add still_sitting bit null")
	*=SQLEXEC(nhand,"alter table tables_h add still_sitting bit null")
ENDIF 	

&&Lihong 2022.09.28 
IF _last_run_step < 32  
	WAIT WINDOW "32 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO csql TEXTMERGE NOSHOW 
	if NOT exists(select * from syscolumns where id=object_id('order_main_bak') and name='crm_member_name') 
	alter table order_main_bak add crm_member_no varchar(20) null, crm_member_name varchar(50) null
	ENDTEXT 
	=SQLEXEC(nhand, csql)
ENDIF 


&&打印機設置增加同組類型 By Waston 10/10/2022
IF _last_run_step < 33  
	WAIT WINDOW "33 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		ALTER Table Printerset Add brother_type int not Null Default 1 
		ALTER Table Printerset Add max_jobs int NOT Null Default 3
	ENDTEXT 
	=SQLEXEC(nhand,ssql)
ENDIF 	

&&Lihong 2022.10.10 默認分帳
IF _last_run_step < 34   &&By Waston 26/09/2022
	WAIT WINDOW "34 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		insert into department (active, id, desccn, descen, disporder) values (0, -888, '未分帳部門', 'Unallocated Dept', -888)
	ENDTEXT 
	=SQLEXEC(nhand, ssql)
ENDIF 	

&& Sam  2022-10-17 重點菜式按子項計算
IF _last_run_step < 35   
	WAIT WINDOW "35 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table item add focus_item_qty_calc_by_subitem bit default 0 not null ") 
	=SQLEXEC(nhand, "alter table item_backup add focus_item_qty_calc_by_subitem bit default 0 not null ") 
ENDIF 	

&&Lihong 2022-09-26 fastfood preorder
IF _last_run_step < 36  
WAIT WINDOW "36 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_fastfood_preorder')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'外賣預點'
		           ,'Preorder'
		           ,0
		           ,14215660
		           ,'_fastfood_preorder'
		           ,1
		           ,1
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand, ssql)
ENDIF 


&&Print_server標記 By Waston 24/10/2022
IF _last_run_step < 37
	WAIT WINDOW "37 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO lcSqlCmd NOSHOW TEXTMERGE 
		if not exists(select code from proan_ctrl where code = 'tpono')
			begin
				insert into proan_ctrl (code, value) values ('tpono', 0)
			end
	ENDTEXT 
	=SQLEXEC(nhand, lcSqlCmd)
ENDIF 	

&&增加打印機類型,1-針式  2-熱敏式 By Waston 04/11/2022
&&此處增加字段同時加到data_auto_update以及print_server里 ,以免RMS沒有同時更新的情況
IF _last_run_step < 38
	WAIT WINDOW "38 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql noshow
		ALTER Table Printerset ADD printer_type int NOT NULL DEFAULT 0
	ENDTEXT 

	=SQLEXEC(nhand,ssql)
ENDIF 

&&增加廚房單打印間隔kit_interval By Waston 11/11/2022
IF _last_run_step < 39
	WAIT WINDOW "39 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql noshow
		ALTER Table Printerset ADD kit_interval INT NOT NULL DEFAULT 0  
	ENDTEXT 
	=SQLEXEC(nhand,ssql)
ENDIF 	

&&Lihong 2022.10.27 限選
IF _last_run_step < 40   
	WAIT WINDOW "40 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table item add custom_mustmodi_id nvarchar(50) null ") 
	=SQLEXEC(nhand, "alter table item_backup add custom_mustmodi_id nvarchar(50) null ") 
ENDIF 	


&&增加訂金
IF _last_run_step < 41
	WAIT WINDOW "41 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		CREATE TABLE [dbo].[deposit](
		[id] [int] NOT NULL,
		[deposit_no] [int] NULL,
		[member_id] [int] NULL,
		[add_by] [int] NULL,
		[amount] [numeric](18, 2) NULL,
		[add_time] [datetime] NULL,
		[order_main_id] [int] NULL,
		[inv_id] [int] NULL,
		[type] [int] NULL,
		[add_station] [int] NULL,
		[status] [int] NULL,
		[edit_by] [int] NULL,
		[edit_station] [int] NULL,
		[edit_time] [datetime] NULL,
		[contact_name] [nvarchar](100) NULL,
		[contact_tel] [nvarchar](100) NULL,
		[pick_time] [datetime] NULL,
		[remark1] [nvarchar](200) NULL,
		[remark2] [nvarchar](200) NULL,
		constraint PK_DEPOSIT primary key (id)
		)
	ENDTEXT 
	=SQLEXEC(nhand,ssql)
	
	TEXT TO ssql NOSHOW 
		CREATE TABLE [dbo].[deposit_member](
		[member_id] [int] NOT NULL,
		[deposit_amt] [numeric](18, 2) NULL,
		constraint PK_DEPOSIT_MEMBER primary key (member_id)
		)
	ENDTEXT 	
	=SQLEXEC(nhand,ssql)
	
ENDIF 	

&&Lihong 2022.11.18 一次性訂金
IF _last_run_step < 42  
WAIT WINDOW "42 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
TEXT TO ssql noshow
CREATE TABLE [deposit_pay_detail](
	[Id] [int] NOT NULL,
	[pay_id] [int] NULL,
	[payway] [nvarchar](30) NULL,
	[qty] [int] NULL,
	[cardno] [nvarchar](50) NOT NULL,
	[payamt] [numeric](12, 2) NULL,
	[netamt] [numeric](12, 2) NULL,
	[changes] [numeric](12, 2) NULL,
	[tips] [numeric](12, 2) NULL,
	[dispord] [int] NULL,
	[rate] [numeric](8, 2) NULL,
	[changes_id] [int] NULL,
	[pay_others] [numeric](12, 2) NULL,
	[oct_device_id] [char](10) NULL,
	[oct_card_id] [char](10) NULL,
	[oct_remain] [numeric](10, 2) NULL,
	[card_name] [nvarchar](30) NULL,
	[kisstxid] [varchar](20) NULL,
	[txrefno] [varchar](30) NULL,
	[kisspay] [varchar](20) NULL,
	[authcode] [varchar](30) NULL,
	[kiss_dollor] [numeric](12, 2) NULL,
	[kiss_rrd] [numeric](12, 2) NULL,
	[kiss_payamt] [numeric](12, 2) NULL,
	[coupon] [bit] NULL,
	[cloud_coupon_id] [int] NULL,
	[web_coupon_id] [uniqueidentifier] NULL,
	[web_coupon_code] [varchar](100) NULL,
	[aa_sub_id] [varchar](30) NULL,
	[aa_sub_add_fee_uid] [numeric](10, 5) NULL,
	[aa_sub_paidtime] [datetime] NULL,
	[aa_sub_adduser] [nvarchar](20) NULL,
	[aa_sub_station_id] [int] NULL,
	[aa_sub_octopus] [bit] NULL,
	[aa_sub_oct_invID] [int] NULL,
	[aa_sub_pay_station_id] [int] NULL,
	[aa_sub_pay_login_user_id] [int] NULL,
	[aa_sub_pay_cashier_user_id] [int] NULL
) ON [PRIMARY]
ENDTEXT 
=SQLEXEC(nhand,ssql)
ENDIF 
IF _last_run_step < 42  
WAIT WINDOW "42 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from table_function where pcode='_deposit_collection' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = ISNULL(MAX(id),0)+1 FROM table_function 
		SELECT  @updateno= ISNULL(MAX(updateno),0)+1 FROM table_function 
		
		INSERT INTO [dbo].[table_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[updateno])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'收訂金'
		           ,'Deposit Collection'
		           ,0
		           ,14215660
		           ,'_deposit_collection'
		           ,@updateno)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)
TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_deposit' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'訂金'
		           ,'Deposit'
		           ,0
		           ,14215660
		           ,'_deposit'
		           ,0
		           ,0
		           ,0
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

=SQLEXEC(nhand,"alter table order_main add deposit_id int null")
=SQLEXEC(nhand,"alter table order_main_bak add deposit_id int null")
=SQLEXEC(nhand,"alter table android_order_main add deposit_id int null")

=SQLEXEC(nhand,"alter table inv add deposit_id int null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add deposit_id int null")
	ENDSCAN
ENDIF

ENDIF 

&&Lihong 2022.11.28 最低 加收服務費
IF _last_run_step < 43  
WAIT WINDOW "43 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

=SQLEXEC(nhand,"alter table order_main add inv_srv_type int null, inv_srv_perc numeric(8, 3) null") &&inv_srv_type, int, 0 加收, 1 最低
=SQLEXEC(nhand,"alter table order_main_bak add inv_srv_type int null, inv_srv_perc numeric(8, 3) null")
=SQLEXEC(nhand,"alter table android_order_main add inv_srv_type int null, inv_srv_perc numeric(8, 3) null")

=SQLEXEC(nhand,"alter table inv add inv_srv_type int null, inv_srv_perc numeric(8, 3) null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add inv_srv_type int null, inv_srv_perc numeric(8, 3) null")
	ENDSCAN
ENDIF

=SQLEXEC(nhand,"alter table order_detail add srv_per_org numeric(8, 3) null")	
=SQLEXEC(nhand,"alter table order_detail_bak add srv_per_org numeric(8, 3) null")	
=SQLEXEC(nhand,"alter table android_order_detail add srv_per_org numeric(8, 3) null")
=SQLEXEC(nhand,"alter table inv_detail add srv_per_org numeric(8, 3) null") 
IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		=SQLEXEC(nhand,"alter table "+cname+" add srv_per_org numeric(8, 3) null")
	ENDSCAN
ENDIF

TEXT TO ssql NOSHOW  
	IF NOT exists(select [pcode] from order_function where pcode='_inv_srv_fee' )
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'修改發票服務費'
		           ,'Edit Service Fee'
		           ,0
		           ,14215660
		           ,'_inv_srv_fee'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand,ssql)

ENDIF 


&&Add so_hold_on By Waston 14/12/2022
IF _last_run_step < 44 
	WAIT WINDOW "44 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		ALTER Table item ADD so_hold_on bit DEFAULT 0 NOT NULL 
		ALTER Table item_backup ADD so_hold_on bit DEFAULT 0 NOT NULL 
	ENDTEXT 
	=SQLEXEC(nhand,ssql)
ENDIF 	
&&Lihong 2022.12.14 storellet inv item 臨時 下次檢如時刪除
IF _last_run_step < 45 
	WAIT WINDOW "45 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table storellet_upload add inv_item_jsonstr varchar(8000) null")
ENDIF 	

&&Lihong 2022.11.18 一次性訂金 付款
IF _last_run_step < 46  
WAIT WINDOW "46 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
ssql="if not exists (select id from payway where id=-14 ) insert into payway "+;
"(active,id,desccn,descen,change_type,rate,dispwithpic,coupon,askqty,startdate,enddate,opendraw,dispord,allow_tips,lock,image,allow_cardno,mark,payvalue)"+;
" values(1,-14,'預付訂金','Prepaid Deposit',3,1,0,0,0,'1990-1-1','2099-1-1',0,14,0,1,'',0,'',0)"
=SQLEXEC(nhand,ssql)
ENDIF 

&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 47  
WAIT WINDOW "47 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
TEXT TO ssql NOSHOW  
	if not exists (select item_id from itemdept where item_id=-7 )
	insert into itemdept (item_id,dept_id,price,price_per) values (-7,-7,0,100)
	
	if not exists (select id from department where id=-7 )
	insert into department (active, id, desccn, descen, disporder) values (0, -7, ' 訂金沒收', 'deposit forfeiture' , -7)
	
	if not exists (select id from cate where id=-7 )
	insert into cate (active, id, desccn, descen, display, dispord, forecolor, backcolor, active_section, active_shop, active_outlet, startdate, enddate)
		values (0, -7, '訂金沒收' , 'deposit forfeiture' , 0 , -7, 0, 0, 0, 0, 0, '2000-1-1', '2099-1-1')
	
	if not exists (select id from item where id=-7 )
	insert into item (active, menu_id, cate_id, level_id, id, code, desccn, descen, descpole, desckit, descinvcn, descinven, drink_qty , onhandqty, qtyremain,
		qtymax, autoqty, soldout, limitqty, handwriting, dayend, turnup, onlyperiod, cost, tax_id, srv_id, priceset, price0, price1, askprice, hold, mustitem, disc,
		sitem, autoppl, askqty, mcate_id, modi_id, mustmodi_id, printer) 
		values 
		(0, -7, -7, -7, -7, '-7', '訂金沒收' , ' deposit forfeiture' , ' deposit forfeiture' , '訂金沒收' , '訂金沒收' , 'deposit forfeiture', 0  , 0, 0 , 0, 0, 0, 0, 0 , 1, 0, 0, 0, 0,0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		'', '', '', '') 
ENDTEXT
=SQLEXEC(nhand,ssql)
ENDIF 

&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 48  
WAIT WINDOW "48 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
TEXT TO ssql NOSHOW 
	alter table deposit add 
	use_type int null
	,tips numeric(12,2) null
	,paidamt numeric(12,2) null
	,pay_fee numeric(12,2) null
	,cln int null
	,clntime datetime null
	,void bit null
	,voidreason nvarchar(50) null
	,voidtime datetime null
	,voiduser nvarchar(20) null
	,paidtime datetime null
	,belongdate datetime null
	,adduser nvarchar(20) null
	,updateno int null
	,oct_invid int null
	,void_user_id int null
	,void_station_id int null
	,void_time datetime null
	,pay_station_id	int null
	,pay_login_user_id int null
	,pay_cashier_user_id int null
ENDTEXT 
=SQLEXEC(nhand,ssql)
ENDIF 

&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 49  
WAIT WINDOW "49 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table pay_print_main add deposit_msg varchar(30) null")
ENDIF 

&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 50
	WAIT WINDOW "50 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		IF Not Exists (Select id From message_log Where id = 213)
			Insert Into message_log (
			ID ,
			desccn ,
			descen , 
			pcode , 
			log_level ,
			updated 
			) 
			Values (
			213 , 
			'一次性訂金' ,
			 'One time deposit' , 
			 '_one_time_deposit' , 
			 1 , 
			 1
			 )
	ENDTEXT 
	
	=SQLEXEC(nhand, cmd)
ENDIF 	
IF _last_run_step < 51
	WAIT WINDOW "51 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		CREATE TABLE [deposit_h](
		h_add_time [datetime] NULL,
		h_add_user_id [int] NULL,
		h_add_station_id [int] NULL,
		[id] [int] NOT NULL,
		[deposit_no] [int] NULL,
		[member_id] [int] NULL,
		[add_by] [int] NULL,
		[amount] [numeric](18, 2) NULL,
		[add_time] [datetime] NULL,
		[order_main_id] [int] NULL,
		[inv_id] [int] NULL,
		[type] [int] NULL,
		[add_station] [int] NULL,
		[status] [int] NULL,
		[edit_by] [int] NULL,
		[edit_station] [int] NULL,
		[edit_time] [datetime] NULL,
		[contact_name] [nvarchar](100) NULL,
		[contact_tel] [nvarchar](100) NULL,
		[pick_time] [datetime] NULL,
		[remark1] [nvarchar](200) NULL,
		[remark2] [nvarchar](200) NULL,
		use_type int null
		,tips numeric(12,2) null
		,paidamt numeric(12,2) null
		,pay_fee numeric(12,2) null
		,cln int null
		,clntime datetime null
		,void bit null
		,voidreason nvarchar(50) null
		,voidtime datetime null
		,voiduser nvarchar(20) null
		,paidtime datetime null
		,belongdate datetime null
		,adduser nvarchar(20) null
		,updateno int null
		,oct_invid int null
		,void_user_id int null
		,void_station_id int null
		,void_time datetime null
		,pay_station_id	int null
		,pay_login_user_id int null
		,pay_cashier_user_id int null)
	ENDTEXT 
	=SQLEXEC(nhand,ssql)

ENDIF 	

IF _last_run_step < 52
	WAIT WINDOW "52 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		CREATE TABLE [dbo].[deposit_item](
		[ID] [Uniqueidentifier] Not Null Default NEWSEQUENTIALID() ROWGUIDCOL,
		[sub_id] [int] NOT NULL, 
		[deposit_id] [int] NOT NULL,
		[item_id] [int] NOT NULL,
		[qty] [numeric](18, 2) NOT NULL,
		[create_by] [int] NULL,
		[create_date] [datetime] NOT NULL default GETDATE(),
		[Updateno] [int] NULL
		CONSTRAINT deposit_item_guid_PK PRIMARY KEY (id) ) 
		ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nhand,ssql)
ENDIF 		

&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 53
	WAIT WINDOW "53 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		If not Exists (Select * From roleaccess Where code = 'deposit_once')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id, 'deposit_once', '一次性訂金', 'One time deposit' , 7200 , 1 ,1 )
		
		If not Exists (Select * From roleaccess Where code = 'deposit_once_new')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id+1, 'deposit_once_new', '          新增', '          New' , 7201 , 1 ,1 )

		If not Exists (Select * From roleaccess Where code = 'deposit_once_edit')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id+2, 'deposit_once_edit', '          修改', '          Edit' , 7202 , 1 ,1 )

		If not Exists (Select * From roleaccess Where code = 'deposit_once_del')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id+3, 'deposit_once_del', '          刪除', '          Delete' , 7203 , 1 ,1 )

		If not Exists (Select * From roleaccess Where code = 'deposit_once_repaylist')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) Values ( @roleaccess_id+4, 'deposit_once_repaylist', '          重印訂金付款單', '          Reprint deposit pay list' , 7204 , 1 ,1 )

	ENDTEXT 

	=SQLEXEC(nhand, cmd)
ENDIF 	
&&Lihong 2022.12.08 一次性訂金
IF _last_run_step < 54
	WAIT WINDOW "54 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table deposit add booking_time datetime null")
	=SQLEXEC(nhand, "alter table deposit_h add booking_time datetime null")
ENDIF 

&&添加菜式級別規則設定日志ID=214 By Waston 12/01/2023
IF _last_run_step < 55
	WAIT WINDOW "55 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		IF Not Exists (Select id From message_log Where id = 214)
			Insert Into message_log (
			ID ,
			desccn ,
			descen , 
			pcode , 
			log_level ,
			updated 
			) 
			Values (
			214 , 
			'菜式級別規則設定' ,
			 'Item level rules setup' , 
			 '_item_level_rules_setup' , 
			 1 , 
			 1
			 )
	ENDTEXT 
	
	=SQLEXEC(nhand, cmd)
ENDIF 
&&add setup discount distribution By Waston 1/2/2023
IF _last_run_step < 56
	WAIT WINDOW "56 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	*-set roleaccess
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int,@updateno int 
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		If not Exists (Select * From roleaccess Where code = 'setup_disc_distribution')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) Values ( @roleaccess_id, 'setup_disc_distribution', '          折扣分配設定', '          Disc. Distribution Setup' , 1430 , 1 ,1 ,@updateno )
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
	*-create table disc_mm
	TEXT TO cmd NOSHOW 
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
		[mm_by] [int] NULL,	
		/*Method1,2,3...*/ 
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
		[void_date] [datetime] NULL   
		CONSTRAINT [pk_disc_mm] PRIMARY KEY NONCLUSTERED ([id] ASC)  )  
		ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
	*-create table disc_mm_h
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[disc_mm_h](
		[h_add_time] [datetime] NOT NULL,
		[h_add_user_id] [int] NOT NULL,
		[h_add_station_id] [int] NULL, 
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
		[mm_by] [int] NULL,	
		/*Method1,2,3...*/ 
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
		[void_date] [datetime] NULL 
		)
		ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
	*-create table disc_mm_type_list
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[disc_mm_type_list](
		[disc_mm_id] [int] NOT NULL,
		[sub_id] [int] NOT NULL,
		[type_a] [varchar](100) NULL,
		[type_a_id] [int] NULL,
		[type_b] [varchar](100) NULL,
		[type_b_id] [int] NULL,
		[type_c] [varchar](100) NULL,
		[type_c_id] [int] NULL,
		[dispord] [int] NULL
		CONSTRAINT [PK_disc_mm_type_list] PRIMARY KEY CLUSTERED ([disc_mm_id] ASC,[sub_id] ASC)
		)
		ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
	*-create table disc_mm_type_list_h
	TEXT TO cmd NOSHOW 
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
		[dispord] [int] NULL
		 ) 
		ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
ENDIF 

&& 改價增加改價的菜式數量
IF _last_run_step < 57 
	WAIT WINDOW "57 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

	=SQLEXEC(nhand,"alter table change_price add qty numeric(8, 3) null")
ENDIF 

&&Lihong 2023.02.17 load_order 日誌
IF _last_run_step < 58 
	WAIT WINDOW "58 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd noshow
		if not exists (select id from message_log where id = 215)
		insert into message_log values (215, 'Load Order', 'Load Order', '_load_order', 1, 1)
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF 

&&Lihong 2023-02-22 取秤數
IF _last_run_step < 59  
WAIT WINDOW "59 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT

TEXT TO ssql NOSHOW 
	IF NOT exists(select [pcode] from order_function where pcode='_elec_qty')
	BEGIN 
		DECLARE @id int
		DECLARE @updateno int
		
		SELECT  @id = MAX(id)+1 FROM order_function
		SELECT  @updateno= MAX(updateno)+1 FROM order_function
		
		INSERT INTO [dbo].[order_function]
		           ([active]
		           ,[id]
		           ,[dispord]
		           ,[desccn]
		           ,[descen]
		           ,[forecolor]
		           ,[backcolor]
		           ,[pcode]
		           ,[fastfood]
		           ,[onlyfastfood]
		           ,[barcode]
		           ,[for_android]
		           ,[updateno]
		           ,[onlyandroid]
		           ,[android_order])
		     VALUES
		           (1
		           ,@id
		           ,@id
		           ,'取秤數'
		           ,'Elec Qty.'
		           ,0
		           ,14215660
		           ,'_elec_qty'
		           ,1
		           ,0
		           ,1
		           ,0
		           ,@updateno
		           ,0
		           ,null)
	END 
ENDTEXT
=SQLEXEC(nhand, ssql)
ENDIF 

&&部門人數報表 add field 雀會 
IF _last_run_step < 60 
	WAIT WINDOW "60 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	=SQLEXEC(nhand, "alter table department_section add sparrow_club_qty int default 0 ")
ENDIF 

&&使用者設定增加Create,edit,void標誌,同時增加操作日誌 By Waston 13/03/2023
IF _last_run_step < 61
	WAIT WINDOW "61 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		IF COL_LENGTH('sys_user', 'create_by') IS NULL
			BEGIN
				Alter table sys_user add Create_by int Null
				Alter table sys_user add Create_date datetime Null
			END
			
		IF COL_LENGTH('sys_user', 'edit_by') IS NULL
			BEGIN
				Alter table sys_user add edit_by int Null
				Alter table sys_user add edit_date datetime Null
			END		
			
		IF COL_LENGTH('sys_user', 'void_by') IS NULL
			BEGIN
				Alter table sys_user add void_by int Null
				Alter table sys_user add void_date datetime Null
			END				
		
		
		IF Not Exists (Select id From message_log Where id Between 216 AND 283 ) 
			BEGIN
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (216, '新增地址成功', 'Add New Address Succeed', '_add_new_address_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (217, '修改地址成功', 'Update Address Succeed', '_update_address_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (218, '刪除地址成功', 'Delete Address Succeed', '_delete_address_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (219, '新增自動折扣成功', 'Add New Auto-Disc Succeed', '_add_new_auto-disc_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (220, '修改自動折扣成功', 'Update Auto-Disc Succeed', '_update_auto-disc_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (221, '刪除自動折扣成功', 'Delete Auto-Disc Succeed', '_delete_auto-disc_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (222, '資料數據庫備份設定成功', 'Setup Database Backup Succeed', '_setup_database_backup_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (223, '新增種類成功', 'Add New Cate Succeed', '_add_new_cate_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (224, '修改種類成功', 'Update Cate Succeed', '_update_cate_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (225, '刪除種類成功', 'Delete Cate Succeed', '_delete_cate_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (226, '新增部門成功', 'Add New Department Succeed', '_add_new_department_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (227, '修改部門成功', 'Update Department Succeed', '_update_department_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (228, '刪除部門成功', 'Delete Department Succeed', '_delete_department_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (229, '新增折扣成功', 'Add New Discount Succeed', '_add_new_discount_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (230, '修改折扣成功', 'Update Discount Succeed', '_update_discount_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (231, '刪除折扣成功', 'Delete Discount Succeed', '_delete_discount_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (232, '新增折扣原因成功', 'Add New Discount Reason Succeed', '_add_new_discount_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (233, '修改折扣原因成功', 'Update Discount Reason Succeed', '_update_discount_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (234, '刪除折扣原因成功', 'Delete Discount Reason Succeed', '_delete_discount_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (235, '新增外賣信息成功', 'Add New Fastfood Info Succeed', '_add_new_fastfood_info_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (236, '修改外賣信息成功', 'Update Fastfood Info Succeed', '_update_fastfood_info_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (237, '刪除外賣信息成功', 'Delete Fastfood Info Succeed', '_delete_fastfood_info_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (238, '新增節假日成功', 'Add New Festival Succeed', '_add_new_festival_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (239, '修改節假日成功', 'Update Festival Succeed', '_update_festival_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (240, '刪除節假日成功', 'Delete Festival Succeed', '_delete_festival_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (241, '新增公眾假期成功', 'Add New Holiday Succeed', '_add_new_holiday_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (242, '修改公眾假期成功', 'Update Holiday Succeed', '_update_holiday_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (243, '刪除公眾假期成功', 'Delete Holiday Succeed', '_delete_holiday_succeed', 1, 1)
								
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (244, '新增菜式級別成功', 'Add New Itemlevel Succeed', '_add_new_itemlevel_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (245, '修改菜式級別成功', 'Update Itemlevel Succeed', '_update_itemlevel_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (246, '刪除菜式級別成功', 'Delete Itemlevel Succeed', '_delete_itemlevel_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (247, '新增特別處理成功', 'Add New Modifier Succeed', '_add_new_modifier_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (248, '修改特別處理成功', 'Update Modifier Succeed', '_update_modifier_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (249, '刪除特別處理成功', 'Delete Modifier Succeed', '_delete_modifier_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (250, '新增營業區域成功', 'Add New Outlet Succeed', '_add_new_outlet_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (251, '修改營業區域成功', 'Update Outlet Succeed', '_update_outlet_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (252, '刪除營業區域成功', 'Delete Outlet Succeed', '_delete_outlet_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (253, '新增付款方式成功', 'Add New Payway Succeed', '_add_new_payway_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (254, '修改付款方式成功', 'Update Payway Succeed', '_update_payway_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (255, '刪除付款方式成功', 'Delete Payway  Succeed', '_delete_payway__succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (256, '新增打印機成功', 'Add New Printer Succeed', '_add_new_printer_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (257, '修改打印機成功', 'Update Printer Succeed', '_update_printer_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (258, '刪除打印機成功', 'Delete Printer Succeed', '_delete_printer_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (259, '新增追單原因成功', 'Add New Remin Reason Succeed', '_add_new_remin_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (260, '修改追單原因成功', 'Update Remin Reason Succeed', '_update_remin_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (261, '刪除追單原因成功', 'Delete Remin Reason Succeed', '_delete_remin_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (262, '新增服務費成功', 'Add New Service Succeed', '_add_new_service_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (263, '修改服務費成功', 'Update Service Succeed', '_update_service_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (264, '刪除服務費成功', 'Delete Service Succeed', '_delete_service_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (265, '系統設定成功', 'System Setup Succeed', '_system_setup_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (266, '新增餐檯QRCODE成功', 'Add New Table QRCODE Succeed', '_add_new_table_qrcode_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (267, '修改餐檯QRCODE成功', 'Update Table QRCODE Succeed', '_update_table_qrcode_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (268, '刪除餐檯QRCODE成功', 'Delete Table QRCODE Succeed', '_delete_table_qrcode_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (269, '新增稅項成功', 'Add New Tax Succeed', '_add_new_tax_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (270, '修改稅項成功', 'Update Tax Succeed', '_update_tax_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (271, '刪除稅項成功', 'Delete Tax Succeed', '_delete_tax_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (272, '新增使用者/角色成功', 'Add New User/Role Succeed', '_add_new_user_role_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (273, '修改使用者/角色成功', 'Update User/Role Succeed', '_update_user_role_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (274, '刪除使用者/角色成功', 'Delete User/Role Succeed', '_delete_user_role_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (275, '新增取消原因成功', 'Add New Void Reason Succeed', '_add_new_void_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (276, '修改取消原因成功', 'Update Void Reason Succeed', '_update_void_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (277, '刪除取消原因成功', 'Delete Void Reason Succeed', '_delete_void_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (278, '新增客戶按警鐘原因成功', 'Add New Warn Reason Succeed', '_add_new_warn_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (279, '修改客戶按警鐘原因成功', 'Update Warn Reason Succeed', '_update_warn_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (280, '刪除客戶按警鐘原因成功', 'Delete Warn Reason Succeed', '_delete_warn_reason_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (281, '新增區域成功', 'Add New Area Succeed', '_add_new_area_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (282, '修改區域成功', 'Update Area Succeed', '_update_area_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (283, '刪除區域成功', 'Delete Area Succeed', '_delete_area_succeed', 1, 1)

			 END
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF

&&Lihong 2023-03-07 菜式複製To Tables
IF _last_run_step < 62 
	WAIT WINDOW "62 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO ssql NOSHOW 
		IF NOT exists(select [pcode] from order_function where pcode='_item_copy_to_tables')
		BEGIN 
			DECLARE @id int
			DECLARE @updateno int
			
			SELECT  @id = MAX(id)+1 FROM order_function
			SELECT  @updateno= MAX(updateno)+1 FROM order_function
			
			INSERT INTO [dbo].[order_function]
			           ([active]
			           ,[id]
			           ,[dispord]
			           ,[desccn]
			           ,[descen]
			           ,[forecolor]
			           ,[backcolor]
			           ,[pcode]
			           ,[fastfood]
			           ,[onlyfastfood]
			           ,[barcode]
			           ,[for_android]
			           ,[updateno]
			           ,[onlyandroid]
			           ,[android_order])
			     VALUES
			           (1
			           ,@id
			           ,@id
			           ,'複製選中菜式到'
			           ,'Copy Item To'
			           ,0
			           ,14215660
			           ,'_item_copy_to_tables'
			           ,0
			           ,0
			           ,0
			           ,0
			           ,@updateno
			           ,0
			           ,null)
		END 
	ENDTEXT
	=SQLEXEC(nhand,ssql)
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		if not exists (select * from roleaccess where code = 'table_item_copy')
		insert into roleaccess	(roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add) VALUES 
		( @roleaccess_id, 'item_copy_to_tables', '          複製選中菜式到', '          Copy Item To' , 538 , 1 ,1 )
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF 


&&MM增加營業區域 By Waston 31/03/2023
IF _last_run_step < 63
	WAIT WINDOW "63 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		ALTER table disc_mm ADD active_outlet varchar(200) Null
		ALTER table disc_mm_h ADD active_outlet varchar(200) Null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
	
ENDIF 	

&&Lihong 2023-04-14
IF _last_run_step < 64
	WAIT WINDOW "64 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		ALTER table printerset ADD physical_printer nvarchar(30) Null, physical_printer_multi_pc bit null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 	

&&Lihong 2023-04-28 function多語言
IF _last_run_step < 65
	WAIT WINDOW "65 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		update Table_function set descen='Removing Table Occupation (Android)' where pcode='_android_free_table' and desccn='解除餐檯占用(Android)' and descen='解除餐檯占用(Android)'
		update Table_function set descen='Download Menu Again (Android)' where pcode='_android_clear_cache' and desccn='重新下載餐牌(Android)' and descen='重新下載餐牌(Android)'
		update Table_function set descen='Check / Edit Booking' where pcode='_table_booking_brow' and desccn='查看/修改餐檯預訂' and descen='查看/修改餐檯預訂'
		update Table_function set descen='Check Octopus' where pcode='_octopus_info' and desccn='八達通查詢' and descen='八達通查詢'
		update Table_function set descen='Check table change information' where pcode='_show_table_move' and desccn='查看轉檯情況' and descen='查看轉檯情況'
		update Table_function set descen='Eng. Order List' where pcode='_print_slip_en' and desccn='列印英文上菜紙' and descen='列印英文上菜紙'

		update order_function set descen='Reset Timer' where pcode='_reset_timer' and desccn='重新計時' and descen='重新計時'
		update order_function set descen='Query Total Amount' where pcode='_check_amount' and desccn='查詢總金額' and descen='查詢總金額'
		update order_function set descen='Join Item Set' where pcode='_join_itemset' and desccn='生成組合套餐' and descen='生成組合套餐'
		update order_function set descen='Leave Item Set' where pcode='_cancel_itemset' and desccn='取消組合套餐' and descen='取消組合套餐'
		update order_function set descen='Tel Address Mode 2' where pcode='_TEL_ADDRESS2' and desccn='電話地址模式2' and descen='電話地址模式2'
		update order_function set descen='Cancel Period Discounts' where pcode='_cancal_hh_disc' and desccn='取消時段組合優惠' and descen='取消時段組合優惠'
		update order_function set descen='Setup for printer forward' where pcode='_dprinter_setup' and desccn='打印機轉向設定' and descen='打印機轉向設定'
		update order_function set descen='Member Points Exchange' where pcode='_MEMBER_POINT_PAY' and desccn='會員積分換購' and descen='會員積分換購'
		update order_function set descen='Cancel Member Point Exchange' where pcode='_ROLLBACK_POINTS' and desccn='取消會員積分換購' and descen='取消會員積分換購'
		update order_function set descen='Change dept breakdown' where pcode='_change_itemdept' and desccn='更改部門分帳' and descen='更改部門分帳'
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 	

&&Lihong 2023-04-28 報表多語言
IF _last_run_step < 66
	WAIT WINDOW "66 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		update report_lookup set en='Date Period Report (Excel)' where cmd='do form form\fr_section_daily' and cn='日期時段統計報表(Excel)' and en='日期時段統計報表(Excel)'
		update report_lookup set en='Department Daily Report' where cmd='do form form\fr_dept_daily' and cn='部門按日統計報表' and en='部門按日統計報表'
		update report_lookup set en='Take Away Address Report' where cmd='do form form\fr_takeaway' and cn='外賣地址報表' and en='外賣地址報表'
		update report_lookup set en='Member Group Report' where cmd='do form form\fr_membinvg' and cn='會員分組統計報表' and en='會員分組統計報表'
		update report_lookup set en='Commission Report' where cmd='do form form\fr_commission' and cn='佣金統計報表' and en='佣金統計報表'
		update report_lookup set en='Booking Report' where cmd='do form form\fr_booking' and cn='訂檯統計報表' and en='訂檯統計報表'
		update report_lookup set en='Business Report of Yearly' where cmd='do form form\fr_yearly' and cn='全年營業報表' and en='全年營業報表'
		update report_lookup set en='Daily Bill Details Report' where cmd='do form form\fr_invl_saichuen' and cn='每日賬單明細報表' and en='每日賬單明細報表'
		update report_lookup set en='Sales Ranking Report' where cmd='do form form\fr_sa_cate_saichuen' and cn='銷售排行報表' and en='銷售排行報表'
		update report_lookup set en='Summary Report of Hourly' where cmd='do form form\fr_sa_hourly_saichuen' and cn='分時營業之總結報表' and en='分時營業之總結報表'
		update report_lookup set en='Summary Report of Daily' where cmd='do form form\fr_sa_daily_saichuen' and cn='每日營業之總結報表' and en='每日營業之總結報表'
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 	

&&sam 2023-05-05 排隊種類
IF _last_run_step < 67
	WAIT WINDOW "67 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	TEXT TO cmd NOSHOW 
		create table queue_cate (   
			id					int                  	not null,   
			long_name            	nvarchar(200)   	null,   
			short_name           	nvarchar(200)       	null,   
			start_date           	datetime             	null,   
			end_date             	datetime             	null,   
			start_time           	char(5)             		null,   
			end_time             	char(5)             	 	null,   
			date_start_time      	char(5)              	null,   
			date_end_time        char(5)              	null,   
			start_ppl            	 int                  		null,   
			end_ppl              	 int                  		null,   
			fore_color          	 int                 	 	null,
			only_one_self_show bit                   	null,   
			dispord              	 int                  		null,   
			constraint PK_QUEUE_CATE primary key (id))
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
	
	*-set roleaccess
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int,@updateno int 
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		
		If not Exists (Select * From roleaccess Where code = 'setup_queue_cate')
			Insert Into roleaccess (roleaccess_id, code, name_cn, name_en, disporder, visible, fly_add, updateno) Values ( @roleaccess_id, 'setup_queue_cate', '          排隊種類', '          Queue Cate Setup' , 1440 , 1 ,1 ,@updateno )
	ENDTEXT 
	=SQLEXEC(nHand,cmd)
ENDIF 

&&sam 2023-05-06 add field item.alway_print_0_amt 
IF _last_run_step < 68
	WAIT WINDOW "68 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	=SQLEXEC(nhand, "alter table item add alway_print_0_amt bit default 0 not null ") 
	=SQLEXEC(nhand, "alter table item_backup add alway_print_0_amt bit default 0 not null ") 
ENDIF 

&&Lihong 2023.04.27 同時用白武士
IF _last_run_step < 69
	WAIT WINDOW "69 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table member add cloud_plat varchar(15) null") 
ENDIF 
IF _last_run_step < 70
*!*		WAIT WINDOW "70 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
*!*		TEXT TO cmd NOSHOW TEXTMERGE 
*!*		if exists (select uid from system_setting where pcode='__storellet' and active=1 and cvalue='1') AND NOT exists (select id from member where ISNULL(cloud_plat,'')<>'' )
*!*		update member set cloud_plat='storellet' 
*!*		--update a set cloud_plat='storellet' from member a left join member_type b on a.type_id=b.id where a.id in (select isnull(memberno,0) from order_main union select isnull(memberno,0) from inv_view) AND b.desccn='VIP'
*!*		ENDTEXT 
*!*		=SQLEXEC(nHand, cmd) 
ENDIF 

&&Lihong 2023.05.25
IF _last_run_step < 71
	WAIT WINDOW "71 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table system_setting ALTER COLUMN pcode nvarchar(100) not null") 
	=SQLEXEC(nhand,"alter table system_setting ALTER COLUMN cvalue nvarchar(250) not null") 
ENDIF 

&&sam 2023-05-30
IF _last_run_step < 72
	WAIT WINDOW "72 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand,"alter table item_pos_material_list add dept_id int") 
ENDIF 


&&建立入座紙打印主表 By Waston 02/06/2023
IF _last_run_step < 73
	WAIT WINDOW "73 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[seat_print_main](
		[pid] [char](20) NOT NULL,
		[place] [char](20) NULL,
		[username] [char](20) NULL,
		[tableno] [char](30) NOT NULL,
		[pplcnt] [int] NOT NULL,
		[printed] [bit] NOT NULL,
		[printer] [char](20) NOT NULL,
		[def_printer] [char](20) NOT NULL,
		[act_printer] [char](20) NOT NULL,
		[sendtime] [datetime] NOT NULL,
		[seattime] [datetime] NOT NULL,
		[printtime] [datetime] NOT NULL,
		[npage] [int] NULL,
		[pages] [int] NULL,
		[order_id] [int] NULL,
		[outlet_id] [int] NULL,
		[langue] [char](4) NULL,
		[order_station] [nvarchar](50) NULL,
		[item_upgrade_ids] [varchar](200) NOT NULL,
		[remark] [nvarchar](250) NULL
		) ON [PRIMARY]
	ENDTEXT 

	=SQLEXEC(nHand, cmd)
ENDIF 	


&&print_tmp增加字段printer By Waston 02/06/2023
IF _last_run_step < 74
	WAIT WINDOW "74 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nHand, "ALTER Table print_tmp ADD printer varchar(30) NULL ")	
ENDIF

&& 新八達通模式需要顯示多兩個字段信息
IF _last_run_step < 75
	WAIT WINDOW "75 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	=SQLEXEC(nhand, "alter table pay_detail add oct_extra_info varchar(50) null, oct_card_avd varchar(20) null")
	IF SQLEXEC(nhand, "select name from inv_divide","cun_tmp") > 0		&&2019.03.19
		SELECT cun_tmp
		SCAN
			cName = "hinv_pay_" + ALLTRIM(cun_tmp.name)
			= SQLEXEC(nhand, "alter table " + cname + " add oct_extra_info varchar(50) null, oct_card_avd varchar(20) null ")
		ENDSCAN
	ENDIF
	=SQLEXEC(nhand, "alter table pay_print_main add oct_extra_info varchar(50) null, oct_card_avd varchar(20) null")
	
ENDIF 	 	

&&營業區域增加字段 By Waston 05/06/2023
IF _last_run_step < 76
	WAIT WINDOW "76 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nHand, "ALTER Table outlet ADD so_print_seat bit NULL ")	
	=SQLEXEC(nHand, "ALTER Table outlet ADD so_printer_seat_id int NULL ")	
ENDIF 	

IF _last_run_step < 77
	WAIT WINDOW "77 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table deposit_pay_detail add oct_extra_info varchar(50) null, oct_card_avd varchar(20) null")
ENDIF 

&&Lihong 2023.05.26 Kitchen display
IF _last_run_step < 78
	WAIT WINDOW "78 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		ALTER table station ADD with_kit_disp bit null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)	
ENDIF 	

&&Lihong 2023.05.26 Kitchen display
IF _last_run_step < 79
	WAIT WINDOW "79 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		ALTER table printerset ADD kit_disp_station_id int Null, kit_disp_also_print bit null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)	
ENDIF 	

&&Lihong 2023.05.26 Kitchen display
IF _last_run_step < 80
	WAIT WINDOW "80 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		CREATE TABLE [dbo].[order_kit_print](
		 [kit_disp_uid] [uniqueidentifier] NOT NULL,
		 [order_id] [int] NOT NULL,
		 [tableno] [char](8) NOT NULL,
		 [descdisp] [nvarchar](50) NULL,
		 [modi_list] [nvarchar](max) NULL,
		 [status] [int] NULL,
		 [complete_time] [datetime] NULL,
		 [void_time] [datetime] NULL,
		 [type] [int] NULL,
		 CONSTRAINT [PK_order_kit_print] PRIMARY KEY CLUSTERED 
		(
		 [kit_disp_uid] ASC
		)) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]	
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 	

&&Lihong 2023-06-02 廚顯
IF _last_run_step < 80
WAIT WINDOW "80 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_detail add kit_disp_uid uniqueidentifier null")
=SQLEXEC(nhand,"alter table order_detail_bak add kit_disp_uid uniqueidentifier null")
=SQLEXEC(nhand,"alter table android_order_detail add kit_disp_uid uniqueidentifier null")
ENDIF 

&&Lihong 2023-06-02 廚顯
IF _last_run_step < 82
WAIT WINDOW "82 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_detail add to_printer varchar(50) NULL")
=SQLEXEC(nhand,"alter table order_detail_bak add to_printer varchar(50) NULL")
=SQLEXEC(nhand,"alter table android_order_detail add to_printer varchar(50) NULL")
ENDIF 

&&Lihong 2023-06-15 廚顯
IF _last_run_step < 83
WAIT WINDOW "83 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_detail add has_hold bit NULL")
=SQLEXEC(nhand,"alter table order_detail_bak add has_hold bit NULL")
=SQLEXEC(nhand,"alter table android_order_detail add has_hold bit NULL")
ENDIF 

&&Lihong 2023-06-15 廚顯
IF _last_run_step < 84
WAIT WINDOW "84 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_kit_print add call_qty numeric(8, 2) null,complete_call_qty numeric(8, 2) null,void_reason int NULL")
ENDIF 

&&Lihong 2023-06-29 廚顯
IF _last_run_step < 85
WAIT WINDOW "85 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_kit_print add to_printer varchar(50) NULL")
ENDIF 

&&Lihong 2023-06-30 廚顯
IF _last_run_step < 86
WAIT WINDOW "86 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table item_move add kit_disp_uid uniqueidentifier null, to_printer varchar(50) NULL")
ENDIF 

&&Lihong 2023.07.13 item desc 50->100
IF _last_run_step < 87 
	WAIT WINDOW "87 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table item alter column desccn nvarchar(100) not null
		alter table item alter column descen nvarchar(100) not null
		alter table item alter column descpole nvarchar(100) not null
		alter table item alter column desckit nvarchar(100) not null
		alter table item alter column descinvcn nvarchar(100) not null
		alter table item alter column descinven nvarchar(100) not null

		alter table item_backup alter column desccn nvarchar(100) not null
		alter table item_backup alter column descen nvarchar(100) not null
		alter table item_backup alter column descpole nvarchar(100) not null
		alter table item_backup alter column desckit nvarchar(100) not null
		alter table item_backup alter column descinvcn nvarchar(100) not null
		alter table item_backup alter column descinven nvarchar(100) not null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 
IF _last_run_step < 88 
	WAIT WINDOW "88 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table order_detail alter column descdisp nvarchar(100) not null
		alter table order_detail_bak alter column descdisp nvarchar(100) not null
		alter table android_order_detail alter column descdisp nvarchar(100) not null
		
		alter table order_kit_print alter column descdisp nvarchar(100) null
		alter table order_void alter column descdisp nvarchar(100) null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)		
ENDIF 
IF _last_run_step < 89 
	WAIT WINDOW "89 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table inv_detail alter column descdisp nvarchar(100) not NULL 
	ENDTEXT 
	USE IN SELECT("cun_tmp")
	=SQLEXEC(nhand,"select name from inv_divide","cun_tmp")
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		TEXT TO cmd ADDITIVE NOSHOW TEXTMERGE 
			alter table <<cName>> alter column descdisp nvarchar(100) not NULL 
		ENDTEXT 
	ENDSCAN

	=SQLEXEC(nHand, cmd)	
ENDIF 
IF _last_run_step < 90 
	WAIT WINDOW "90 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table slip_print_detail alter column item nvarchar(120) NULL 
		alter table order_print_detail alter column item varchar(120) NULL 
		alter table inv_print_detail alter column item nvarchar(120) NULL 
		alter table inv_reprint_detail alter column item char(120) NULL 
		alter table pay_print_detail alter column item nvarchar(120) NULL 
	ENDTEXT 
	=SQLEXEC(nHand, cmd)	
ENDIF 
&&Lihong 2023.07.13 cate desc 50->100
IF _last_run_step < 91 
	WAIT WINDOW "91 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table cate alter column desccn nvarchar(100) not null
		alter table cate alter column descen nvarchar(100) not null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)	
ENDIF 

&&菜式大類開窗 By Waston 18/07/2023
IF _last_run_step < 92
	WAIT WINDOW "92 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	
	TEXT TO cmd NOSHOW 
		IF Not Exists (Select id From message_log Where id Between 284 AND 286 ) 
			BEGIN
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (284, '新增菜式大類成功', 'Add Item Main Category Succeed', '_add_main_cate_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (285, '修改菜式大類成功', 'Update Item Main Category Succeed', '_update_main_cate_succeed', 1, 1)
				
				Insert Into message_log (ID, desccn, descen, pcode, log_level, updated)     
				Values (286, '刪除菜式大類成功', 'Delete Item Main Category Succeed', '_delete_main_cate_succeed', 1, 1)	
			END TRANSACTION
	ENDTEXT 
	=SQLEXEC(nHand, cmd)			
	
	
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[main_cate](
			[active] [bit] NOT NULL,
			[id] [int] NOT NULL,
			[desccn] [nvarchar](50) NOT NULL,
			[descen] [nvarchar](50) NOT NULL,
			[dispord] [int] NOT NULL,
			[updateno] [int] NULL,
			[logo] [text] NULL,CONSTRAINT [PK_main_cate] PRIMARY KEY CLUSTERED ([id] ASC)
			)
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
	
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[main_mcate](
			[maincate_id] [int] NOT NULL,
			[cate_id] [int] NOT NULL,
			[dispord] [int] NOT NULL
			)
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
	
	
	TEXT TO cmd noshow
		DECLARE @roleaccess_id int,@updateno int 
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		If not Exists (Select * From roleaccess Where code = 'setup_main_category')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) 
				Values ( @roleaccess_id, 'setup_main_catetory', '          菜式大類設定', '          Main Catetory Setup' , 970 , 1 ,1, @updateno)
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
ENDIF 

&&Lihong 2023.07.17
IF _last_run_step < 93 
	WAIT WINDOW "93 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
	alter table roleaccess add ask_again bit default 0 not null
	ENDTEXT 
	=SQLEXEC(nHand, cmd)	
ENDIF 


&&Lihong 2023.07.14 invinfo 加權限
IF _last_run_step < 94
	WAIT WINDOW "94 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int, @updateno  int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		if not exists (select * from roleaccess where code = 'invinfo_count_inv')
		begin
			insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) values (@roleaccess_id , 'invinfo_count_inv', '          是否顯示發票張數', '          Display number of invoices', 883, 1,1,@updateno)
			
			DECLARE @rcid VARCHAR(16)
			SET @rcid=CONVERT(varchar(16),@roleaccess_id)+','
			DECLARE @ptr binary(16)
			DECLARE cursor1 CURSOR LOCAL SCROLL FOR Select TEXTPTR(access) as access from role where access is NOT null AND datalength(access)>0 AND charINDEX(','+CONVERT(varchar(4),@roleaccess_id)+',', ','+cast(access as varchar(max)) )=0
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ptr
			WHILE @@FETCH_STATUS=0 BEGIN
			updatetext role.access @ptr null 0 @rcid 
			FETCH NEXT FROM cursor1 INTO @ptr
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		end
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
ENDIF 
IF _last_run_step < 95
	WAIT WINDOW "95 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int, @updateno  int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		if not exists (select * from roleaccess where code = 'invinfo_count_ppl')
		begin
			insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) values (@roleaccess_id , 'invinfo_count_ppl', '          是否顯示發票人數', '          Display people number of invoices', 884, 1,1,@updateno)
			
			DECLARE @rcid VARCHAR(16)
			SET @rcid=CONVERT(varchar(16),@roleaccess_id)+','
			DECLARE @ptr binary(16)
			DECLARE cursor1 CURSOR LOCAL SCROLL FOR Select TEXTPTR(access) as access from role where access is NOT null AND datalength(access)>0 AND charINDEX(','+CONVERT(varchar(4),@roleaccess_id)+',', ','+cast(access as varchar(max)) )=0
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ptr
			WHILE @@FETCH_STATUS=0 BEGIN
			updatetext role.access @ptr null 0 @rcid 
			FETCH NEXT FROM cursor1 INTO @ptr
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		end
	ENDTEXT 
	=SQLEXEC(nhand, cmd)
	
ENDIF 
IF _last_run_step < 96
	WAIT WINDOW "96 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		DECLARE @roleaccess_id int, @updateno  int
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		if not exists (select * from roleaccess where code = 'invinfo_count_deposit')
		begin
			insert into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) values (@roleaccess_id , 'invinfo_count_deposit', '          是否顯示訂金單未清機數量和金額', '          Display not closed info of deposit', 885, 1,1,@updateno)
			
			DECLARE @rcid VARCHAR(16)
			SET @rcid=CONVERT(varchar(16),@roleaccess_id)+','
			DECLARE @ptr binary(16)
			DECLARE cursor1 CURSOR LOCAL SCROLL FOR Select TEXTPTR(access) as access from role where access is NOT null AND datalength(access)>0 AND charINDEX(','+CONVERT(varchar(4),@roleaccess_id)+',', ','+cast(access as varchar(max)) )=0
			OPEN cursor1
			FETCH NEXT FROM cursor1 INTO @ptr
			WHILE @@FETCH_STATUS=0 BEGIN
			updatetext role.access @ptr null 0 @rcid 
			FETCH NEXT FROM cursor1 INTO @ptr
			END
			CLOSE cursor1
			DEALLOCATE cursor1
		end
	ENDTEXT 
	=SQLEXEC(nhand, cmd)

ENDIF 

&&Lihong 2023.07.19 void item show
IF _last_run_step < 97
	WAIT WINDOW "97 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW
	alter table [tables] add order_uid uniqueidentifier null
	alter table order_void add order_uid uniqueidentifier null,uid numeric(10,5) default 0 not null, item_code char(8) default '' not null, sitem_dele bit default 0 not null, modi_list text default '' not null

	alter table order_main add order_uid uniqueidentifier null
	alter table order_main_bak add order_uid uniqueidentifier null
	alter table android_order_main add order_uid uniqueidentifier null

	alter table inv add order_uid uniqueidentifier null
	ENDTEXT 
	IF SQLEXEC(nhand,"select name from inv_divide","cun_tmp")>0		
		SELECT cun_tmp
		SCAN
			cName="hinv_"+ALLTRIM(cun_tmp.name)
			cmd = cmd +CHR(13) + "alter table "+cname+" add order_uid uniqueidentifier null"
		ENDSCAN
	ENDIF
	=SQLEXEC(nhand, cmd)
ENDIF 

&&Lihong 2023-06-02 廚顯
IF _last_run_step < 98
	WAIT WINDOW "98 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW TEXTMERGE 
		alter table inv_detail add kit_disp_uid uniqueidentifier null, to_printer varchar(50) NULL
	ENDTEXT 
	USE IN SELECT("cun_tmp")
	=SQLEXEC(nhand,"select name from inv_divide","cun_tmp")
	SELECT cun_tmp
	SCAN
		cName="hinv_detail_"+ALLTRIM(cun_tmp.name)
		TEXT TO cmd ADDITIVE NOSHOW TEXTMERGE 
			alter table <<cName>> add kit_disp_uid uniqueidentifier null, to_printer varchar(50) NULL
		ENDTEXT 
	ENDSCAN
	=SQLEXEC(nHand, cmd)	
ENDIF 

&&Lihong 2023-07-28 廚顯
IF _last_run_step < 99
WAIT WINDOW "99 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
=SQLEXEC(nhand,"alter table order_kit_print add add_time datetime default getdate() not null")
ENDIF 

&&Lihong 2023-08-10 先達會員折扣
IF _last_run_step < 100
WAIT WINDOW "100 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
TEXT TO ssql noshow		

IF NOT exists(select id from disc where id=-99)
INSERT INTO [disc]
           ([active]
           ,[id]
           ,[desccn]
           ,[descen]
           ,[discper]
           ,[discamt]
           ,[begdate]
           ,[enddate]
           ,[disclevel]
           ,[dispord]
           ,[disc_type]
           ,[forecolor]
           ,[backcolor]
           ,[parent_id]
           ,[askqty]
           ,[points])
     VALUES
           (0
           ,-99
           ,'會員折扣'
           ,'member discount'
           ,0
           ,0
           ,''
           ,''
           ,''
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0
           ,0)

ENDTEXT
=SQLEXEC(nhand,ssql)

ENDIF 

&&Lihong 2023.08.14 storellet inv pay detail 
IF _last_run_step < 101 
	WAIT WINDOW "101 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "alter table storellet_upload add inv_pay_jsonstr varchar(8000) null")
ENDIF 	


&&printerset增加printer_status印表機狀態 By Waston 16/08/2023 
IF _last_run_step < 102
	WAIT WINDOW "102 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	=SQLEXEC(nhand, "ALTER table printerset ADD printer_status int NULL ")
ENDIF 	

&&餐牌更新計劃管理 By Waston 17/08/2023
IF _last_run_step < 103 
	WAIT WINDOW "103 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[menu_tran_data](
		[id] [uniqueidentifier] NOT NULL,
		[transid] [int] NOT NULL,
		[tablename] [varchar](20) NULL,
		[records] [int] NULL,
		[xmlfile] [varchar](max) NULL,
		[uploaddate] [datetime] NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
	
	TEXT TO cmd NOSHOW 
		CREATE TABLE [dbo].[menu_tran_sch](
		[id] [int] NOT NULL,
		[transname] [varchar](30) NOT NULL,
		[transdate] [datetime] NULL,
		[warndate] [datetime] NULL,
		[is_finish] [bit] NULL,
		[active] [bit] NULL
		) ON [PRIMARY]
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
	
	TEXT TO cmd noshow
		DECLARE @roleaccess_id int,@updateno int 
		SET @roleaccess_id = (select ISNULL(max(roleaccess_id), 0)+1 from roleaccess )
		SET @updateno = (select ISNULL(max(updateno), 0)+1 from roleaccess )
		If not Exists (Select * From roleaccess Where code = 'setup_menutrans')
			Insert Into roleaccess (roleaccess_id,code,name_cn,name_en,disporder,visible,fly_add,updateno) 
				Values ( @roleaccess_id, 'setup_menutrans', '          餐牌更新計劃管理', '          Menu Transaction Management' , 980 , 1 ,1, @updateno)
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
	
ENDIF 




IF _last_run_step < 104 
	WAIT WINDOW "104 / " + ALLTRIM(STR(_total_step)) + "...." NOWAIT
	TEXT TO cmd NOSHOW 
		Alter table deposit add refund_id int
		Alter table deposit_h add refund_id int
	ENDTEXT 
	=SQLEXEC(nHand, cmd)
ENDIF

 	
*高助已用：payway.id  -128 至 -144
&&&&&&&&&&&&&&&&&&&&&&______________________以下部分不參考上面任何 step 


*=SQLEXEC(nhand,"alter table system_setting drop column pid")
&&Lihong 2022.05.09 始終放後面
=SQLEXEC(nhand,"exec create_inv_view '', '1900-01-01', '2099-12-31' ") 

*--------------
check_payway_pic()			&& 檢查付款方式的圖標文件,本地化以優化結帳界面載入速度  *----- ddd


build_index()

IF lForceUpdate=.f.

	&&Lihong 2021.07.05
	TEXT TO ssql TEXTMERGE NOSHOW 
	delete sys_options where Type='autoupdate_lock' 
	ENDTEXT 
	=SQLExec(nhand,ssql)

	=SQLEXEC(nhand," update  sys_options  set defavalue_char= ?lcTime where type='autoupdate' ")

ENDIF

&&Update verno and steps on proan_ctrl  by Waston 20/07/2022
TEXT TO lcSqlCmd NOSHOW TEXTMERGE 
	if not exists(select code from proan_ctrl where code = 'data_auto_update_verno')
	begin
		insert into proan_ctrl (code, value) values ( 'data_auto_update_verno', ?lcTime)
	end
		
	UPDATE proan_ctrl set value = ?lcTime where code = 'data_auto_update_verno'
ENDTEXT 
=SQLEXEC(nhand, lcSqlCmd)


TEXT TO lcSqlCmd NOSHOW TEXTMERGE 
	if not exists(select code from proan_ctrl where code = 'data_auto_update_step')
	begin
		insert into proan_ctrl (code, value) values ( 'data_auto_update_step', ?_total_step)
	end
		
	UPDATE proan_ctrl set value = ?_total_step where code = 'data_auto_update_step'
ENDTEXT 
=SQLEXEC(nhand, lcSqlCmd)




WAIT CLEAR 

ENDFUNC






