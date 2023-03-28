*SET RESOURCE off
lSetMess = .T.

IF PCOUNT() = 1
	nMess_end_id = 10000000
ENDIF  
set talk off
*clea all
*set date to ansi
SET DATE TO american
SET DATE TO ymd

set esca off
set cent on
set safe off
set excl off
set exac on
set dele on 
set deci to 2
set hour to 24
SET NOTIFY off
CLEAR


HIDE WINDOW "Command"
PUBLIC runformname
runformname = ""

PUBLIC __pds_hq , __pds_shop , __pds_station , __exe_name 
__pds_hq = "fthq.no-ip.info"
__pds_shop = "ft121.no-ip.info"
__pds_station = 1002
__exe_name = ""

PUBLIC __dat
__dat = "local.dat"


*SET SYSMENU off
SET STATUS BAR OFF

set multilocks off
_screen.lockscreen=.f.

*_path=SYS(5)+SYS(2003)+"\"
*set default to "&_path"  &&
SET DEFAULT TO d:\work\pos6
SET PATH TO TO d:\work\class ADDITIVE 


SET PROCEDURE TO pub_proc
SET CLASSLIB TO class\invoice
SET PROCEDURE TO json ADDITIVE
SET PROCEDURE TO doc_proc ADDITIVE

public nhand,nHand_hk, nHQHand,_system_langue,_login_user_name,GL_training,__nserver,__admin__user,frm_wait,GL_DEMO, __SVR_IP_ADDRESS,__DATABASE_NAME , __training
__training = .f.
__SVR_IP_ADDRESS = ""
__DATABASE_NAME = ""

PUBLIC __wait_window_active 
__wait_window_active = .f.
_system_langue="CN"
_login_user_name="admin"


PUBLIC __shopid, __shopname, __shopcode, __stationid, __stationname && update in definvar.prg
PUBLIC gc_coname
PUBLIC report_main

gc_coname = "Proan computer testing"


PUBLIC __debug_mode,__email_smtp, __inv_hit_item_list2, __INV_SCAN_BC_NON_PRICE
__inv_hit_item_list2 = "abc"

__debug_mode=.t.
__email_smtp=""
__admin__user=.t.

PUBLIC __dat, __hq_dat
__dat		= "local.dat"
__hq_dat	= "hq.dat"

PUBLIC _login_user_id
_login_user_id = 1

PUBLIC shop_view, shop_view_cond
shop_view = "shop"
shop_view_cond = ""

*!*	PUBLIC shop_view, shop_view_cond
*!*	shop_view = "shop_view_1"
*!*	shop_view_cond = "(3, 4)"


PUBLIC __access_user_name
__access_user_name=""


*=sqlsetprop(0,"displogin",3)  &&do not display error warning


_string_hk = "driver=sql server;server=pds.poshk.com,7200;uid=sa;pwd=proanpossapwd;database=pos6_source"  && 200 ----香港
*_string = "driver=sql server;server=pds.poshk.com,7200;uid=sa;pwd=proanpossapwd;database=pos6_ciao_test"  && 200 ciao

*_string = "driver=sql server;server=pds.poshk.com,7200;uid=sa;pwd=proanpossapwd;database=pos6_source"  && 200 ----香港

_string = "driver=sql server;server=192.168.10.66;uid=sa;pwd=sa;database=pos6_source"  && ----本機
_info_string =  "driver=sql server;server=192.168.10.66;uid=sa;pwd=sa;database=RMS6"  && ----本機custinfo

*_string = "driver=sql server;server=127.0.0.1,2468;uid=sa;pwd=proanpossapwd;database=pos6"  && 




*_string = "driver=sql server;server=203.198.142.142,2468,2468;uid=sa;pwd=proanpossapwd;database=pos6" && inmu
*_string = "driver=sql server;server=ecliving.poshk.com,2468;uid=proan_sa;pwd=proanpossapwd_15599;database=pos6"

lcServer = STREXTRACT(_string,";",";",1)
lcServer = STREXTRACT(lcServer,"=","")
lcDB = STREXTRACT(_string,";","",4)
lcDB = STREXTRACT(lcDB,"=","")

IF lSetmess
	lcServer_hk = STREXTRACT(_string_hk,";",";",1)
	lcServer_hk = STREXTRACT(lcServer_hk,"=","")
	lcDB_hk = STREXTRACT(_string_hk,";","",4)
	lcDB_hk = STREXTRACT(lcDB_hk,"=","")
ENDIF 	

nhand=SQLSTRINGCONNECT(_string)

IF lSetmess 
	nhand_hk = SQLSTRINGCONNECT(_string_hk)
	IF nHand_hk < 0 
		WAIT WINDOW "不能連接到SQL SERVER服務器" + lcServer_hk + " / " + lcDB_hk + "，Message未更新！"   NOCLEAR TIMEOUT 3
	ELSE  
		WAIT WINDOW "成功連接到SQL SERVER服務器" + lcServer_hk + " / " + lcDB_hk + "，將更新Message..."   NOCLEAR TIMEOUT 3
	ENDIF 	
ENDIF 	

PUBLIC nInfohand
nInfohand = SQLSTRINGCONNECT(_info_string)
PUBLIC gl_login_from_login_form
gl_login_from_login_form = .t.

*nHQHand=SQLSTRINGCONNECT(_string)
*!*	spic1 = STRCONV(FILETOSTR("ico\company.JPG"), 13)
*!*	spic2 = STRCONV(FILETOSTR("ico\bg_commit.JPG"), 13)
*!*	spic3 = STRCONV(FILETOSTR("ico\bg_close_folder.JPG"), 13)
*!*	TEXT TO dbsql NOSHOW TEXTMERGE 
*!*		declare @id int
*!*	set @id = ISNULL((select MAX(id) from whatsapp_msg), 0) + 1
*!*	insert into whatsapp_msg
*!*	values(@id, 1, '85260638751', ?spic1, ?spic2, ?spic3, 'test' + STR(@id), 1, GETDATE(), 1, -1, '', GETDATE(), null)

*!*	ENDTEXT 
*!*	SQLEXEC(nhand, dbsql)

__nserver=1

if nhand<0
 =messagebox("connected  error!",48,"")
 retu
endif

PUBLIC __program
__program	= 'PROGRAM(PROGRAM(-1)-3) + " -> " + PROGRAM(PROGRAM(-1)-2) + " -> " + PROGRAM(PROGRAM(-1)-1) + " -> " + PROGRAM()'

__program	= 'PROGRAM(PROGRAM(-1)-1) + " -> " + PROGRAM()'
*ON ERROR error_catch(getmessage("_proc_error"),ERROR(),MESSAGE(),&__program,LINENO(1))	
ON ERROR error_catch(getmessage("_proc_error"),ERROR(),MESSAGE(),PROGRAM(),LINENO(1))	

*?SECONDS()
IF SQLEXEC(nhand,"select * from message","message_tmp")<0
	MESSAGEBOX("create message cursor error")
ENDIF


_station=getcomputername()				&&取工作站電腦名稱

ssql="select *  from station where computer=?_station"

IF SQLEXEC(nhand,ssql,"update_tmp1")<0
	_load_error = -1
	_permit=.F.
	RETURN .f. 
ENDIF

&&沒有工作站就添加一個
IF EOF("update_tmp1")
	TEXT TO ssql NOSHOW TEXTMERGE 
		Declare @ID int,@Updateno int
		Select @ID = max(id) + 1,@Updateno = max(updateno) + 1 from station 
		IF NOT EXISTS(SELECT 1 FROM STATION WHERE COMPUTER = ?_station)
		Insert  into station (id,shop_id,Computer,Language,updateno,active,attendance,price_level,invtype_id,Create_by,Create_date)
		Values (@id,1,?_station,'CN',@Updateno,1,0,1,1,1,getdate())
		Select *  from station where computer=?_station
	ENDTEXT 
	IF SQLEXEC(nhand,ssql,"update_tmp1") < 0
		_load_error = -1
		_permit=.F.
		RETURN .f. 	
	ENDIF 
ENDIF 	

_id=update_tmp1.ID
*!*	__ismain_server=update_tmp1.mainserver		&&是否主服務器
__station_id=update_tmp1.ID			&&當前工作站的ID
IF EMPTY(_id)	&&不存在的station ID
	_load_error = -1
	_permit=.F.
	RETURN 
ENDIF





update_system_setting()


*?SECONDS()
=create_shop_variable()
load_system_setting()

*!*	PUBLIC shop_view, shop_view_cond

*!*	shop_view_cond = ""
*!*	shop_view = "shop"
*!*	IF (VARTYPE(__new_deposit) <> "U" AND __new_deposit)
*!*		TEXT TO dbsql NOSHOW TEXTMERGE 
*!*			select a.id, ISNULL(b.include_shop, '*') as include_shop, ISNULL(b.exclude_shop, '') as exclude_shop  from shop a (nolock), sys_user b (nolock) where 
*!*				a.id > 0
*!*		ENDTEXT 

*!*		IF  SQLEXEC(nhand, dbsql, "cr_tmp11") > 0

*!*			shop_view = "shop_view_999999"
*!*			= SQLEXEC(nhand, " drop view " + shop_view)
*!*			
*!*			sShopId = ""
*!*			GO TOP IN "cr_tmp11"
*!*			DO WHILE !EOF("cr_tmp11")
*!*				IF !EMPTY(sShopId)
*!*					sShopId = sShopId + ","
*!*				ENDIF 
*!*				sShopId = sShopId + ALLTRIM(STR(cr_tmp11.id))	
*!*				SKIP IN "cr_tmp11"
*!*			ENDDO 
*!*			
*!*			shop_view_cond = " (" + sShopId + ") "
*!*			
*!*			IF USED("cr_tmp11")
*!*				USE IN "cr_tmp11"
*!*			ENDIF 	
*!*			
*!*			TEXT TO dbsql NOSHOW TEXTMERGE 
*!*				CREATE VIEW <<shop_view>> as 
*!*				SELECT * FROM shop WHERE id in <<shop_view_cond>>
*!*			ENDTEXT 
*!*			
*!*			= SQLEXEC(nhand, dbsql) 
*!*		ENDIF 
*!*	ENDIF 	

__shopid = 1
__shopCode = ""
__shopname = ""

*?SECONDS()
get_user_id_by_name()


*WAIT WINDOW ALLTRIM(STR(__stationid))

public back_main,report_main
gl_viewcost = .t.

*=check_internet()

	
IF VARTYPE(__Finger) # "U" AND __Finger
	PUBLIC oFinger
		oFinger	= CREATEOBJECT("fingerprint")
	IF TYPE("oFinger") != "O"
		
	ENDIF 
ENDIF 


IF lSetmess 
	SELECT * FROM message_tmp WHERE NVL(updated, .F.) = .f. ORDER BY ID INTO CURSOR cr_message_tmp 
	SELECT cr_message_tmp
	lnRec_Total = TRANSFORM(RECCOUNT())
	SCAN
		_m_code = ALLTRIM(cr_message_tmp.m_code)
		_mess_cn = ALLTRIM(cr_message_tmp.message_cn)
		_mess_en = ALLTRIM(cr_message_tmp.message_en)
		WAIT WINDOW "正在更新Message,進度:" + TRANSFORM(RECNO()) + "/" + lnRec_Total AT 6,120 NOWAIT 
		=setmessages(_m_code,_mess_cn,_mess_en)
		UPDATE message_tmp SET updated = .T. WHERE ALLTRIM(m_code) = _m_code
		=SQLEXEC(nHand, "Update message set updated = 1 where m_code = ?_m_code")
	ENDSCAN 
	USE IN cr_message_tmp 
	
	WAIT WINDOW "Message成功更新到HK SERVER！"  NOWAIT 
ENDIF 	




FUNCTION setmessages

LPARAMETERS cCode,cMess_cn,cMess_en

If Vartype(cCode)<>"C"
	Return ""
ENDIF

Local _code
_code=Lower(cCode)

IF !USED("message_tmp")
	RETURN cCode
ENDIF

If __debug_mode
	_m_code = _code
	_mess_cn = cMess_cn
	_mess_en = cMess_en

	If !Empty(_m_code)
		Local csql
		TEXT TO csql NOSHOW TEXTMERGE 	
			DECLARE @max_id int,@updateno int
			SELECT @max_id=ISNULL(MAX(id),0)+1,@updateno = ISNULL(MAX(updateno),0)+1 FROM message
			
			IF NOT exists(Select 1 from message where m_code = ?_m_code )
				Insert into MESSAGE(id,m_code,message_cn,message_en,updateno) values (@max_id,?_m_code,?_mess_cn,?_mess_en,@updateno)
		ENDTEXT

		If SQLExec(nhand_hk,csql)<0
			aerror(err)
			_error_line=LINENO(1)
			_error_code=ALLTRIM(STR(err(1)))
			_error_msg=TRIM(err(2))
			_error_prog=PROGRAM()
			_ctitle=getmessage("_sqlserver_error")
			error_catch(_ctitle,_error_code,_error_msg,_error_prog,_error_line)
			Return _code
		Endif
	ENDIF 	
ENDIF

ENDFUNC 

*__admin__user = .f.
*_login_user_id = 199

*user_access("_inv_hit_itemmo", "Y")



*DO FORM form\report_main NAME report_main
*DO FORM form\back_main NAME back_main




*!*	&&進入HQ精簡模式 by Waston 07/04/2022
*!*	DO FORM form\login.scx WITH "hq"

*!*	PUBLIC gl_viewvendor
*!*	gl_viewvendor = user_access("_view_vendor")

*!*	PUBLIC back_main
*!*	back_main = CREATEOBJECT("back_main")

*!*	PUBLIC __hq_simple_mode
*!*	IF SQLEXEC(nHand,"select hq_simple_mode from sys_user where id = ?_login_user_id ","cr_hq_simple")< 0 
*!*		MESSAGEBOX("get user right error")
*!*		RETURN 
*!*	ENDIF 

*!*	IF RECCOUNT("cr_hq_simple") > 0 
*!*		__he_simple_mode = cr_hq_simple.hq_simple_mode
*!*	ENDIF 

*!*	ON SHUTDOWN QUIT 

*!*	DO FORM form\hq_simple_mode NAME hq_simple_mode
*!*	READ EVENTS

*!*	QUIT  
*!*	DEFINE CLASS back_main AS Custom
*!*		lookup_code	= "" 
*!*	ENDDEFINE 



*__fancy_talent = .t.
*DO FORM form\report_main
*DO FORM form\back_main
