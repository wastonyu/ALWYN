PARAMETERS cexp
SET TALK OFF
*SET RESOURCE off




PUBLIC rms_express, _data_updated, _db_name,rms_report,rms_atte ,rms6_update
_data_updated = .F.
_db_name = ""			&& update in connect_sql()

IF !EMPTY(cexp)

	DO CASE


		CASE  LOWER(cexp)="express"
			rms_express=.T.

		CASE  LOWER(cexp)="report"
			rms_report=.T.

			PUBLIC __inv_printer

			__inv_printer=0

		CASE  LOWER(cexp)="atte"
			rms_atte	=.T.

		CASE  LOWER(cexp)="update"		&& Run Auto_update.fxp  must


			rms6_update=.T.

	ENDCASE


ENDIF


_SCREEN.VISIBLE =.T.




RUN /N0 regsvr32 rmpwebbrowser.ocx /s



PUBLIC __exe_name,__exe_version

__exe_name = LOWER(ALLTRIM(SYS(16)))
__exe_version=""


IF AGETFILEVERSION( ver , __exe_name ) > 0
	__exe_name = __exe_name + "  v" + ALLTRIM(ver(4))

	__exe_version=ALLTRIM(ver(4))

ENDIF



SET DATE TO YMD
*Set Date To ansi

SET ESCA OFF
SET CENT ON
SET SAFE OFF
SET EXCL OFF
SET EXAC ON
SET DELE ON
SET DECI TO 2
SET HOUR TO 24
SET NOTIFY OFF
SET CONFIRM ON
SET FIXED OFF


SET SYSMENU OFF
SET STATUS OFF
SET STATUS BAR OFF

SET NULLDISPLAY TO ""
_SCREEN.BORDERSTYLE=0

_SCREEN.MAXBUTTON =rms_express
_SCREEN.MINBUTTON =rms_express

_SCREEN.CLOSABLE =.F.
_SCREEN.CONTROLBOX =rms_express
_SCREEN.TITLEBAR= IIF(rms_express,1,0)
_SCREEN.MOVABLE =rms_express
_SCREEN.WINDOWSTATE= 2

SET NULLDISPLAY TO ""
_SCREEN.CAPTION="Restaurant Management System"

TRY
	COPY FILE "vfpzip.exe" TO "c:\windows\vfpzip.exe"
	COPY FILE "vfpcompression.fll" TO "c:\windows\vfpcompression.fll"
CATCH
FINALLY
ENDTRY


IF !FILE("vfpzip.exe")
	=MESSAGEBOX("vfpzip.exe not found!!", "Pro-An")
ENDIF
IF !FILE("vfpcompression.fll")
	=MESSAGEBOX("vfpcompression not found!!", "Pro-An")
ENDIF
IF !FILE("auto_update.fxp")
	=MESSAGEBOX("auto_update.fxp not found!!", "Pro-An")
ENDIF
IF !FILE("level_check.fxp")
	=MESSAGEBOX("level_check.fxp not found!!", "Pro-An")
ENDIF

IF !FILE("level_check_new.fxp")
	=MESSAGEBOX("level_check_new.fxp not found!!", "Pro-An")
ENDIF



IF !FILE("timer1.fxp")
	=MESSAGEBOX("timer1.fxp not found!!", "Pro-An")
ENDIF


IF !FILE("rmscalc.dll")
	=MESSAGEBOX("rmscalc.dll not found!!", "Pro-An")

ENDIF


PUBLIC _login_main,__debug_mode,__nserver,__training,__admin__user,GL_DEMO,__linkserver_active,__ismain_server,__station_id

__debug_mode=.F.
IF FILE("debug.txt")
	__debug_mode = .T.
ENDIF


__nserver=1

PUBLIC __access_user_name,_gbk_langue,__gbk_enabled
__access_user_name=""
__station_id=0

_SCREEN.ADDPROPERTY("setting","")

SET MULTILOCKS ON

_path=SYS(5)+SYS(2003)+"\"
_path1=_path+"class\"
SET DEFAULT TO "&_path"  && 自適應路徑
SET PATH TO _path ADDITIVE
SET PROCEDURE TO pub_proc2

SET PROCEDURE TO member_card ADDITIVE
*SET PROCEDURE TO definevar ADDITIVE

SET PROCEDURE TO vfpwinsock ADDITIVE

SET PROCEDURE TO cardrw.prg ADDITIVE 		&&2009.03.30  add API function for CARD RW

SET PROCEDURE TO update_itempic ADDITIVE 	&&2009.10.05

SET PROCEDURE TO ximage ADDITIVE

SET PROCEDURE TO chk_xml ADDITIVE


SET PROCEDURE TO gpimage2 ADDITIVE
SET PROCEDURE TO foxbarcode ADDITIVE

*Set Procedure To qrcode Additive

SET PROCEDURE TO crm_member ADDITIVE

SET PROCEDURE TO crm_api ADDITIVE


IF FILE("a4_inv.fxp")

	SET PROCEDURE TO a4_inv ADDITIVE

ENDIF

IF FILE("level_check.fxp")

	SET PROCEDURE TO level_check  ADDITIVE


ENDIF


IF FILE("level_check_new.fxp") AND FILE("rmscalc.dll")

	SET PROCEDURE TO level_check_new  ADDITIVE

ELSE

	PUBLIC __Level_check_disable
ENDIF

SET PROCEDURE TO gen_preview ADDITIVE

SET PROCEDURE TO local_print ADDITIVE

SET PROCEDURE TO check_octopus ADDITIVE

ON SHUTDOWN QUIT

LOCAL _permit,_data_error,_need_to_update, _load_error

_load_error = -1
_data_error=.F.
_need_to_update=.T.

IF !FILE("sysinfo.dat")
	=MESSAGEBOX("sysinfo.dat not found")
	CLEAR EVENTS
	QUIT

ELSE

	LOCAL cstr,ms
	cstr=FILETOSTR("sysinfo.dat")
	cstr=crstr(cstr,"RMS6")		&&unpack

	DIMENSION ms(1)
	getmstring(cstr,@ms,"@")

	cstr=TRIM(ms(1))

	getmstring(cstr,@ms,";")
	IF ALEN(ms)<6
		CLEAR EVENTS
		QUIT
	ENDIF

	IF ALEN(ms)>7
		_need_to_update=(VAL(ms(8))=0)

	ENDIF

ENDIF


PUBLIC  __shop_id


IF FILE("pds.ini")


	cfile=SYS(5)+SYS(2003)+"\pds.ini"		&&必須指定路徑
	__shop_id=VAL( Readini(cfile,"setting","shop_id"))


ELSE

	__shop_id = 1
ENDIF

IF FILE("rmscalc.dll")

	DECLARE STRING Rms_Calc IN RMSCalc.DLL STRING PParam1,STRING PParam2

ENDIF

DECLARE LONG  CreateMutexA IN kernel32 LONG p1,LONG p2,STRING StrName		&&防止重復運行
DECLARE LONG  GetLastError IN kernel32

DECLARE SHORT PostMessage IN user32;
	INTEGER   HWND,;
	INTEGER   Msg,;
	STRING  @ wParam,;
	INTEGER   LPARAM

DECLARE INTEGER ShellExecute IN shell32;
	INTEGER HWND,;
	STRING  lpOperation,;
	STRING  lpFile,;
	STRING  lpParameters,;
	STRING  lpDirectory,;
	INTEGER nShowCmd
*------------------------------------------------------------------

PUBLIC nhand,_system_langue,_login_user_name,GL_training,ntotalpage,frm_wait,__order_langue,nemailhand 		&&GL_training 訓練模式
_system_langue="CN"
__order_langue =_system_langue
_login_user_name=""
ntotalpage=0
nhand=0
nemailhand =-1

_permit=.T.

IF !DIRECTORY("backup")
	MD backup
ENDIF

IF !DIRECTORY("itempic")
	MD itempic
ENDIF


SET CLASSLIB TO CLASS\invoice_base.vcx ADDITIVE
SET CLASSLIB TO CLASS\crm.vcx ADDITIVE

IF TYPE("oMp") != "O"
	PUBLIC oMp
	oMp	= CREATEOBJECT("proan_mobile_pay_api")
ENDIF
*=sqlsetprop(0,"displogin",3)  &&do not display error warning
WAIT WINDOW "正在連接到SQL SERVER服務器..."  NOWAIT NOCLEAR 
*_string = "driver=sql server;server=pds.poshk.com,7200;uid=sa;pwd=proanpossapwd;database=rms6_source"  && 200 ----香港

_string = "driver=sql server;server=192.168.3.26;uid=sa;pwd=sa;database=RMS6"  && ----本機


nhand=SQLSTRINGCONNECT(_string)

PUBLIC gl_login_from_login_form
gl_login_from_login_form = .T.

__nserver=1

IF nhand<0
	=MESSAGEBOX("connected  error!",48,"")
	RETURN
ELSE 
	WAIT WINDOW "成功連接到SQL SERVER服務器，正在載入系統參數..." AT 20,80 NOWAIT NOCLEAR 
ENDIF

PUBLIC __program
__program	= 'PROGRAM(PROGRAM(-1)-3) + " -> " + PROGRAM(PROGRAM(-1)-2) + " -> " + PROGRAM(PROGRAM(-1)-1) + " -> " + PROGRAM()'

__program	= 'PROGRAM(PROGRAM(-1)-1) + " -> " + PROGRAM()'

IF SQLEXEC(nhand,"select * from message","message_tmp")<0
	MESSAGEBOX("create message cursor error")
ENDIF

update_system_setting()

load_system_setting()
PUBLIC __finger

__finger = .F.

IF __Finger
	PUBLIC oFinger
	oFinger	= CREATEOBJECT("fingerprint")
ENDIF

_station=getcomputername()	
SET STEP ON 			&&取工作站電腦名稱
ssql="select filename,updated_station from system_file where filename='rms6' "
IF SQLEXEC(nhand,ssql,"update_tmp")<0
	_load_error = -1
	_permit=.F.
	EXIT
ENDIF

ssql="select *  from station where computer=?_station"

IF SQLEXEC(nhand,ssql,"update_tmp1")<0
	_load_error = -1
	_permit=.F.
	EXIT
ENDIF

IF EOF("update_tmp1")

	_load_error = -1
	_permit=.F.
	EXIT

ELSE
	_id=update_tmp1.ID

	__ismain_server=update_tmp1.mainserver		&&是否主服務器
	__station_id=update_tmp1.ID			&&當前工作站的ID

	IF EMPTY(_id)	&&不存在的station ID

		_load_error = -1
		_permit=.F.
		EXIT

	ENDIF
ENDIF 
public_define()
SQLEXEC(nhand,"create table  dbo.updateno ( table_name char(30),max_updateno int )")		&&創建表updateno
Get_table_updateno()		&&初始化  table updateno
PUBLIC frm_wait 
frm_wait = CREATEOBJECT("form")
WAIT WINDOW "系統環境加載成功！" AT 20,80  TIMEOUT 1
