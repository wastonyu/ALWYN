Function get_membercard_info
	Lparameters cMemberNumber

	If Vartype(cMemberNumber)#"C"


		Return  ""

	Endif


	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE
			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return  ""

	Endif



	loinf=olms.LmsGetMemberInfoFoxPro(cMemberNumber)

	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return ""

	ENDIF


	oMember_info=Createobject("empty")

	ADDPROPERTY(oMember_info,"member_number", loinf(2) )	&&會員number

	ADDPROPERTY(oMember_info,"bonus", loinf(3) )			&&會員積分
	ADDPROPERTY(oMember_info,"value", loinf(4) )			&&會員卡余額
	ADDPROPERTY(oMember_info,"EarnPoint", loinf(5) )		&&會員賺取積分

	ADDPROPERTY(oMember_info,"name_en", loinf(7) )			&&會員名稱
	ADDPROPERTY(oMember_info,"name_cn", loinf(8) )			&&會員名稱

	ADDPROPERTY(oMember_info,"remark", loinf(21) )			&&會員備注





	RETURN oMember_info		&& return info object

ENDFUNC



*------------------------------
*檢查會員卡余額

Function get_membercard_amount
	Lparameters cMemberNumber

	If Vartype(cMemberNumber)#"C"


		Return -1

	Endif


	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE
			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return -1

	Endif


	Local loinf

	loinf=olms.LmsGetMemberInfoFoxPro(cMemberNumber)

	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return -1

	Endif



	RETURN VAL(loinf(4))		&& amount

ENDFUNC


**************************
*檢查 ecoupon 換購
Function check_eCouponRed
	Lparameters nOrderId

	If SQLExec(nhand,"select member_number from order_disc where id=?nOrderID and member_number<>'' ","cun_tmp")<0
		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		Return -1
	Endif

	If Eof("cun_tmp")

		Return -1

	Endif


	If SQLExec(nhand,"select id from order_detail with (nolock) where id=?nOrderID and ecoupon=1  and giftred=0","cun_tmp")<0

		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		Return -1

	Endif

	If Eof("cun_tmp")

		Return -1

	Endif

	Return Reccount("cun_tmp")


Endfunc


*------------------------------

Function auto_eCouponRed

	Lparameters cMemberNumber,lonlyCheck,cTranNumber

	If Vartype(cMemberNumber)#"C"


		Return ""

	Endif

	IF VARTYPE(cTranNumber)#"C"

		cTranNumber	=""

	ENDIF



	LOCAL cCoupon_List

	cCoupon_List=Get_ecoupon_list(cMemberNumber)

	IF EMPTY(cCoupon_List)

		RETURN ""

	ENDIF



	CREATE CURSOR  member_ecoupon_tmp (cid c(10) ,code c(10) ,citem c(50) , amount n(12,2) ,qty int , enddate date)


	ALINES(cs,cCoupon_List,4,"|")

	LOCAL  i

	FOR i =1 TO ALEN(cs)

		ALINES(cs2 ,cs(i), 4, CHR(9) )

		IF VAL(cs2(4)) = 0		&& amount>0  -->payway  amount=0 -->gift

			INSERT INTO member_ecoupon_tmp ( cid , code ,citem , amount , qty , enddate ) VALUES (cs2(1) ,cs2(2), cs2(3) ,VAL(cs2(4)) , VAL(cs2(5)) ,CTOD(cs2(6)) )

		ENDIF


	ENDFOR

	IF lonlyCheck

		RETURN ""

	ENDIF



	LOCAL cList

	cList=""

	SELECT item_code,SUM(qty) as qty   FROM order_itemlist_tmp WHERE ecoupon AND giftred=.f.  GROUP BY item_code INTO CURSOR cun_tmp
	SELECT a.*,b.cid FROM cun_tmp a LEFT JOIN member_ecoupon_tmp b ON a.item_code=b.code INTO CURSOR cun_tmp


	SELECT cun_tmp
	SCAN



		cList= cList + TRIM(cun_tmp.cid)+CHR(9)+ALLTRIM(STR(cun_tmp.qty))+ CHR(124)

	ENDSCAN

	cList = TRIM(cList , CHR(124) )


	cTran= do_CouponComsumption(cMemberNumber ,cList ,cTranNumber)

	IF EMPTY(cTran)

		RETURN ""

	ENDIF


	UPDATE order_itemlist_tmp  SET price=reprice,giftred=.t. ,transnumber =cTran WHERE ecoupon=.t. AND giftred=.f.



	RETURN cTran



ENDFUNC

* ------------------------------- ecoupon 	付款 / 換購
FUNCTION do_CouponComsumption
	LPARAMETERS cMemberNumber,cDataList,cTranNumber


	If Vartype(cMemberNumber)#"C" OR Vartype(cDataList)#"C"

		Return ""

	ENDIF


	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE
			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return ""

	Endif


	Local loinf

	loinf=olms.LmsGetMemberInfoFoxPro(cMemberNumber)

	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return ""

	ENDIF

	IF olms.LmsCouponConsumption(cDataList, SYS(2015))<>0


		Release olms

		fmessagebox("_failed_to_update_member_card")

		_vfp.AutoYield=.t.


		RETURN ""

	ENDIF


	strTranNumber =IIF(EMPTY(cTranNumber), Ltrim(Sys(2015),"_") , cTranNumber)


	oRet=olms.lmsPurchaseFoxPro(strTranNumber ,0,0,0)

	If oRet(1)<>"0"

		cMess =getmessage("_failed_to_update_member_card") +CHR(13) +getmessage("_error_code") +oRet(1)+CHR(13) +IIF(!EMPTY( oRet(22) ),  oRet(22) ,"")


		fmessagebox(cMess)


		Return ""


	Endif



	RETURN strTranNumber


ENDFUNC

*----------------------------------
* get member card eCoupon List

FUNCTION Get_ecoupon_list
	Lparameters cMemberNumber

	If Vartype(cMemberNumber)#"C"

		Return ""

	Endif

	IF EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

		RETURN ""
	ENDIF


	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE

			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return ""

	Endif


	Local loinf

	loinf=olms.LmsGetMemberInfoFoxPro(cMemberNumber)

	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return ""

	Endif


	loinf= olms.LmsGetAllCouponFoxPro()

	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return ""

	ENDIF


	RETURN loinf(3)


ENDFUNC




*--------------------------
*檢查是否有未換購的禮品

Function check_giftRed
	Lparameters nOrderId

	If SQLExec(nhand,"select member_number from order_disc where id=?nOrderID and member_number<>'' ","cun_tmp")<0

		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		Return -1


	Endif

	If Eof("cun_tmp")

		Return -1

	Endif



	If SQLExec(nhand,"select id from order_detail with (nolock) where id=?nOrderID and gift=1 and giftred=0","cun_tmp")<0

		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		Return -1

	Endif

	If Eof("cun_tmp")

		Return -1

	Endif

	Return Reccount("cun_tmp")


Endfunc

*------------------------------
*禮品換購

Function auto_giftRed

	Lparameters cMemberNumber,nOrderId,LonlyGetGift

	If Vartype(cMemberNumber)#"C"


		Return ""

	Endif

	IF PCOUNT() < 4
		LnoCalcNow = .f.
	ENDIF 


	Local lnOrder_ID


	lnOrder_ID=Iif(Vartype(nOrderId)="N",nOrderId,0)

	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE
			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return ""

	Endif


	Local loinf

	loinf=olms.LmsGetMemberInfoFoxPro(cMemberNumber)


	If loinf(1)<>"0"


		Release olms

		_vfp.AutoYield=.t.


		Return ""

	Endif

	_total_points=Val(loinf(3))
	
	
	IF USED("member_gift_tmp")
		USE IN "member_gift_tmp"
	ENDIF

	If !Used("member_gift_tmp")

		If getGiftInfo() < 0

			olms.DisconnectPrinter

			Release olms
			
			_vfp.AutoYield=.t.

			Return ""

		Endif

		Select * From gift_info_tmp Into Cursor member_gift_tmp Readwrite


	Endif

	
	If Reccount("member_gift_tmp")=0		&&如果沒有可換購的禮品

		olms.DisconnectPrinter

		Release olms
		
		_vfp.AutoYield=.t.

		Return ""

	ENDIF
	
	IF LonlyGetGift

		olms.DisconnectPrinter

		Release olms
		
		_vfp.AutoYield=.t.


		RETURN ""

	ENDIF

		
*!*		IF LnoCalcNow

*!*			olms.DisconnectPrinter

*!*			Release olms
*!*			
*!*			_vfp.AutoYield=.t.


*!*			RETURN "NOCALC"

*!*		ENDIF
	
	
	
	Create Cursor giftred_tmp (uid N(10,5),gift_code c(30),gift_name c(50),item_code c(30),done L )

	Select  uid  From order_itemlist_tmp Where gift=.T. And giftred=.F. And item_code in (SELECT item_code FROM member_gift_tmp)  Into Cursor cun_tmp 		&&檢查是否有禮品可換購

	nGiftRed=_Tally
	
		
	IF nGiftRed=0

		olms.DisconnectPrinter
		Release olms

		fmessagebox("_redemption_gifts_failure")

		_vfp.AutoYield=.t.


		Return ""


	ENDIF

	

	Select member_gift_tmp
	Scan For isItem			&&只檢item

		_item_code=Trim(member_gift_tmp.item_code)

		nlimit=Val(member_gift_tmp.gift_limit)		&&限制換購數量


		nRequire_points =Val(require_points)		&&所需積分
		
		
		
		&&這里有問題,需要先確定ITEM是否是此次要處理的ITEM
*!*			If _total_points >= nRequire_points

			Select  uid,qty  From order_itemlist_tmp Where gift=.T. And giftred=.F. And  Trim(item_code) == _item_code Into Cursor cun_tmp 		&&檢查是否有禮品可換購

			If _Tally>0
				Select cun_tmp
				Scan FOR qty=1

					If  _total_points >= 0 And _total_points >= nRequire_points
						_total_points = _total_points - nRequire_points
						SELECT giftred_tmp
*!*							LOCATE FOR ALLTRIM(item_code) == ALLTRIM(member_gift_tmp.item_code)
*!*							IF !FOUND()
							Insert Into giftred_tmp (uid,gift_code,gift_name,item_code) Values (cun_tmp.uid,member_gift_tmp.gift_code , member_gift_tmp.gift_name,member_gift_tmp.item_code)
							nGiftRed=nGiftRed-1
*!*							ENDIF
					Else		&&必須全部成功

						olms.DisconnectPrinter
						Release olms
						fmessagebox("_not_enough_points_to_pay")
						_vfp.AutoYield=.t.
						Return ""
					Endif
				Endscan
			
			Endif

*!*			ELSE
*!*				olms.DisconnectPrinter
*!*				Release olms
*!*				fmessagebox("_not_enough_points_to_pay")
*!*				_vfp.AutoYield=.t.
*!*				
*!*				Return ""

*!*			Endif

	Endscan

	IF nGiftRed > 0

		olms.DisconnectPrinter
		Release olms
		fmessagebox("_not_enough_points_to_pay")
		_vfp.AutoYield=.t.
		Return ""
	ENDIF

	Local strTranNumber

	strTranNumber=""

	If Reccount("giftred_tmp")>0		&&有可以換購的

		strTranNumber =Ltrim(Sys(2015),"_")

		lcstrgifsData=""

		Select giftred_tmp
		Scan
			lcstrgifsData=lcstrgifsData+Allt(gift_code) +"	"+"1|"
		Endscan

		lcstrgifsData=Trim(lcstrgifsData,"|")
		
		llRet = giftred(lcstrgifsData,strTranNumber)
		
		
		IF llRet = .F. 
			olms.DisconnectPrinter
			Release olms
			_vfp.AutoYield=.t.
			Return ""
		ELSE  
			Update order_itemlist_tmp Set price=reprice, giftred = .t., transnumber = strTranNumber  Where gift=.T.
		ENDIF 	
		
	ENDIF
	
	olms.DisconnectPrinter

	Release olms

	

	Return strTranNumber
	
Endfunc

*--------------------------
Function getGiftInfo
	
	*顯示可換領的禮品信息
	*
	*--------------------------------

	Create Cursor gift_info_tmp (gift_name c(100),require_points c(20),gift_count c(20),gift_limit c(20),enddate c(20),item_code c(20),gift_code c(20),isItem L)


	Local cGiftInfo As String
	cGiftInfo=Space(1024)
	T1=Datetime()

	write_log(-88,"LMS:lmsIssueCardWithDetailFoxPro>start>>"+Ttoc(T1))

	olms.lmsgetAllGift(@cGiftInfo)

	write_log(-89,"LMS:lmsgetAllGift>end>>"+Alltrim(Str(Datetime()-T1)))

	If Empty(cGiftInfo)


		Return -1


	ENDIF


	Local cmark

	If At(cGiftInfo,";")=0

		cGiftInfo=Strtran(cGiftInfo,"|",";")

		cmark=";"

	Else

		If At(cGiftInfo,"#")=0
			cGiftInfo=Strtran(cGiftInfo,"|","#")

		Endif
		cmark="#"

	ENDIF


	If Alines(gift,cGiftInfo,4,cmark)=0


		Return  -1


	Endif



	Local i

	For i=1 To Alen(gift)

		If Alines(cinfo,gift(i),4,"	")>8

			_item_code=Alltrim(cinfo(2))
			_item_name=Alltrim(cinfo(3))


			If SQLExec(nhand,"select desccn,descen,reprice from item where code=?_item_code","cun_tmp")<0

				Aerror(err)

				error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))

				Return 		-1

			Endif

			ll_item=!Eof("cun_tmp")		&&是否RMS6的item
			
						
			
			IF LOWER(cinfo(6)) = "member rewards"  &&只取member rewards的進行換購 By Waston 20/17/2023
				
				Insert Into gift_info_tmp (gift_name,require_points,gift_count,gift_limit,enddate,item_code,gift_code,isItem) ;
					VALUES (_item_code+" "+_item_name,cinfo(4),cinfo(8),cinfo(5),cinfo(9),_item_code,cinfo(1),ll_item)
			ENDIF 

		Endif



	ENDFOR

	cMess =getmessage("_nnlimited")

	Update gift_info_tmp Set gift_count = cMess  Where Val(gift_count)=-1
	Update gift_info_tmp Set gift_limit = cMess  Where Val(gift_limit)=-1



	Return 1

Endfunc



*--------------------------
*換購禮品

Function giftred

	Lparameters lcstrgifsData ,lcStrTranNumber

	Local strgifsData As String
	Local strTranNumber As String


	strgifsData =lcstrgifsData
	strTranNumber =lcStrTranNumber



	T1=Datetime()

	write_log(-88,"LMS:lmsgiftRedemption>start>>"+Ttoc(T1) + strgifsData + " " + strTranNumber )

		
	lnRet=olms.lmsgiftRedemption(strgifsData,strTranNumber)

	write_log(-89,"LMS:lmsgiftRedemption>end>>"+Alltrim(Str(Datetime()-T1)))


	If  lnRet=0		&&成功換領

		write_log(-89,"LMS:lmsgiftRedemption Success")


		T1=Datetime()

		write_log(-88,"LMS:lmsPurchaseFoxPro>start>>" + Ttoc(T1))


		oRet=olms.lmsPurchaseFoxPro(strTranNumber ,0,0,0)

			
*!*			lcItemList = getgiftitemlist()
		
*!*			=STRTOFILE("Item List:" + lcItemList + CHR(13), "D:\points.txt", 1)
		
*!*			oRet=olms.lmspurchaseExFoxPro(strTranNumber, 0, 0, 0, .f., 0 , 0.00, lcItemList, "", TTOC(DATETIME()) )
		
	
		write_log(-89,"LMS:lmsPurchaseFoxPro>end>>"+Alltrim(Str(Datetime()-T1)))

		If oRet(1)="0"

			Return .T.

		Else

			write_log(-89,"LMS:lmsgiftRedemption Fail!")

			cMess =getmessage("_failed_to_update_member_card") +CHR(13) +getmessage("_error_code") +oRet(1) +CHR(13)+IIF( !EMPTY( oRet(22)) ,oRet(22),"")


			fmessagebox(cMess)

			Return .F.


		Endif


	Else


		Do Case


			Case lnRet=300

				fmessagebox("_gifts_qty_not_enough")
				RETURN .f.



			Case lnRet=301

				fmessagebox("_not_enough_points_to_pay")
				RETURN .f.

			Case lnRet=302

				fmessagebox("會員 Stamp 不足,未能成功換領!")
				RETURN .f.


			Case lnRet=303

				fmessagebox("gift already exchange!")
				RETURN .f.


			Case lnRet=304

				fmessagebox("_failed_to_update_member_card")
				RETURN .f.


			Otherwise

				fmessagebox("_redemption_gifts_failure")

				RETURN .f.



		Endcase


	Endif


	Return



Endfunc

*------------------

Function getmemberinfo

	Lparameters nOrderId

	*取會員卡相關記錄

	If SQLExec(nhand,"select ISNULL(member_number,'') as member_number from order_disc with (nolock) where id=?nOrderID ","cun_tmp")<0
		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))

		Return .F.



	Endif


	oInfo.member_number =Alltrim(cun_tmp.member_number )
	*thisform.lms_member_number=ALLTRIM(cun_tmp.member_number )

	If SQLExec(nhand,"select distinct ISNULL(transnumber,'') as transnumber from order_detail with (nolock) where id=?nOrderID and transnumber<>'' ","cun_tmp")<0

		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))

		Return .F.

	Endif

	oInfo.transnumber=Alltrim(cun_tmp.transnumber)			&& 換購的transnumber
	=STRTOFILE("TrnasNumber:" + oInfo.transnumber + CHR(13), "D:\Points.txt", 1)
	*thisform.lms_transnumber=ALLTRIM(cun_tmp.transnumber)			&& 換購的transnumber


	TEXT TO ssql noshow
		select b.item_code, item.desccn , b.qty,
		b.amount+b.srv_amount as org_amt,
		b.real_amount+b.round_amount+b.xdisc as net_amt,isnull(b.tel,'') as tel,ISNULL(b.member_number,'') as member_number ,
		ISNULL(b.price_mc,0)  as price_mc
		from order_detail b with (nolock)
		left join order_main a with(nolock) on b.id = a.id
		left join item  with(nolock) on b.item_id = item.id
		where a.id = ?nOrderID
		order by b.id, b.uid
	ENDTEXT

	If SQLExec(nhand,ssql,"cun_tmp")<0

		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))

		Return .F.

	Endif

	*total_number_of_items|^item_number1;item_basket1;quantity1;before_discount_amount1;amount1;remark1|^item_number2;item_basket2;quantity2;before_discount_amount2;amount2;remark2|^item_number3;item_basket3;quantity3;before_discount_amount3;amount3;remark3

	Local lcItems,lnOrgAmt

	Select cun_tmp
	Sum org_amt To lnOrgAmt

	lcItems=Alltrim(Str(Reccount("cun_tmp")))+"|^"


	Select cun_tmp
	SCAN

		IF price_mc>0		&&異幣充值

			lcItems=lcItems+Alltrim(cun_tmp.item_code)+";;"+Alltrim(Str(cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.price_mc * cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.price_mc * cun_tmp.qty,12,2))+";"+Alltrim(Nvl(cun_tmp.tel,""))+"|^"


		ELSE


			lcItems=lcItems+Alltrim(cun_tmp.item_code)+";;"+Alltrim(Str(cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.org_amt,12,2))+";"+Alltrim(Str(cun_tmp.net_amt,12,2))+";"+Alltrim(Nvl(cun_tmp.tel,""))+"|^"

		ENDIF


	Endscan

	lcItems=Trim(lcItems,"|^")


	oInfo.orgamt=lnOrgAmt
	oInfo.itemlist=lcItems

	*thisform.lms_orgamt=lnOrgAmt
	*thisform.lms_itemlist=lcItems

	Select tel,member_number From cun_tmp Where !Empty(tel) Into Cursor cun_tmp1

	If _Tally>0

		oInfo.cTel=Alltrim(cun_tmp.tel)

		If !Empty(cun_tmp1.member_number)

			oInfo.member_number=Alltrim(cun_tmp1.member_number)

		Endif


	Endif



	Return




Endfunc

*----------------------------

Function check_member
	Lparameters _inv_id,_curorder,lnoAsk
	
	
		Local lcTel
		ssql="select member_number from inv_disc with (nolock)  where id=?_inv_id and disc_id=-1"

		If SQLExec(nhand,ssql,"cun_tmp")<0
			Aerror(err)
			error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
			Return -1

		Endif

		If Eof("cun_tmp") 
			*!*		ssql="select * from order_detail where CHARINDEX('MEM',item_code)>0 and id=?_curorder "
			*!*		If SQLExec(nhand,ssql,"cun_tmp")<0
			*!*			Aerror(err)
			*!*			error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
			*!*			Return -1

			*!*		Endif

			*!*		If Eof("cun_tmp")

			*!*			Return 0


			*!*		Endif

			ssql="select ISNULL(tel,'') as tel,ISNULL(member_number,'') as member_number from order_detail where id=?_curorder and tel<>'' "
			If SQLExec(nhand,ssql,"cun_tmp")<0
				Aerror(err)
				error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
				Return -1

			Endif

			lcTel=Alltrim(cun_tmp.tel)
			_member_number=Alltrim(cun_tmp.member_number)

			IF EMPTY(_member_number)

				RETURN 0

			ENDIF


		Else
			lcTel=""
			_member_number=Trim(cun_tmp.member_number)

		Endif


	
	

	If  lnoAsk =.f.
		
		cMess =getmessage("_Write_to_member_card_confirm") +CHR(13)+CHR(13)+getmessage("_member_no") + _member_number
		
		nRet = fmessagebox(cMess  ,4)

		IF nRet =7

			RETURN 0

		ENDIF


	ENDIF



	Public  oInfo

	oInfo=Createobject("empty")

	AddProperty(oInfo,"Member_Number","")
	AddProperty(oInfo,"transnumber","")

	AddProperty(oInfo,"orgamt",0.00)

	AddProperty(oInfo,"itemlist","")
	AddProperty(oInfo,"ctel",lcTel)



	If getmemberinfo(_curorder)=.F.

		Release oInfo

		Return -1


	Endif

	ssql="select invamt,begintime from inv with (nolock) where id=?_inv_id"

	If SQLExec(nhand,ssql,"cun_tmp")<0
		Aerror(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		Release oInfo

		Return -1

	Endif
	_invamt=cun_tmp.invamt

	Local lcTran,lcDatetime

	lcDatetime=TTOC(cun_tmp.begintime,1)


	If Vartype(__member_card_mark)#"U"

		lcTran=Trim(Left(__member_card_mark,3))+Alltrim(Str(_inv_id))		&&加入編碼

	Else

		lcTran=Alltrim(Str(_inv_id))


	Endif


	IF !EMPTY(oInfo.transnumber)

		lcTran=lcTran+","+oInfo.transnumber

	ENDIF
	
	
	

	Public oinv

	oinv=Createobject("empty")

	AddProperty(oinv,"transactionNumber",lcTran)
	AddProperty(oinv,"transactionDatetime",Ttoc(Datetime(),1))

	AddProperty(oinv,"intEarnPointAmount",_invamt)
	AddProperty(oinv,"intTransactionAmount",_invamt)

	AddProperty(oinv,"orgAmt",oInfo.orgamt)

	AddProperty(oinv,"citems",oInfo.itemlist)

	AddProperty(oinv,"member_number",_member_number )		&&會員number

	AddProperty(oinv,"cTel", oInfo.cTel)		&&會員電話號碼

	AddProperty(oinv,"begintime",lcDatetime)


	Release oInfo


	Return 1




ENDFUNC
*---------------------------------------------------
*加會員積分  2016.04.25

FUNCTION add_inv_points
	Lparameters nInv_ID,nOrder_ID

	LOCAL ll_prePaid ,lnPrePaidAmt
	
	

	&&獲取oInv對象的屬性
	IF check_member(nInv_ID,nOrder_ID) < 0
		RETURN  -1
	ENDIF
	
	

	IF VARTYPE( oinv.prePaidAmount)#"U"

		ll_prePaid = (oinv.prePaidAmount>0)

		lnPrePaidAmt = oinv.prePaidAmount

	ELSE

		lnPrePaidAmt =0.00

	ENDIF



	Private  olms

	_vfp.AutoYield=.f.

	_error=.F.

	Try

		IF !EMPTY(Readini("c:\lms\lms.ini","CRW","starPrinterName"))

			olms = Createobject("LMSV3Star.LMSControlV3Star")

		ELSE
			olms=Createobject("LMSV3.LMSControlV3")

		ENDIF

		olms.storeNumber=__member_card_mark			&& shop code (must)

	Catch To oErr

		_error=.T.

	Endtry


	If _error

		fmessagebox("_cardrw_error_need_to_restart")

		_vfp.AutoYield=.t.

		Return  -1

	Endif

	olms.LmsGetMemberInfoFoxPro(oInv.member_number)

	If Vartype(oinv)#"U"
		T1=Datetime()

		write_log(-88,"LMS:lmsPurchaseFoxPro>start>>"+Ttoc(T1) + " / " + oinv.transactionNumber)

		
		=STRTOFILE("oinv.transactionNumber:" + TRANSFORM(oinv.transactionNumber) + CHR(13), "D:\Points.txt", 1)
		=STRTOFILE("oinv.intEarnPointAmount:" + TRANSFORM(oinv.intEarnPointAmount) + CHR(13), "D:\Points.txt", 1)
		=STRTOFILE("oinv.orgamt:" + TRANSFORM(oinv.orgamt) + CHR(13), "D:\Points.txt", 1)
		=STRTOFILE("oinv.intTransactionAmount:" + TRANSFORM(oinv.intTransactionAmount) + CHR(13), "D:\Points.txt", 1)
		
		=STRTOFILE("lnPrePaidAmt:" + TRANSFORM(lnPrePaidAmt) + CHR(13), "D:\Points.txt", 1)
		=STRTOFILE("oinv.citems:" + TRANSFORM(oinv.citems) + CHR(13), "D:\Points.txt", 1)
		=STRTOFILE("oinv.begintime:" + TRANSFORM(oinv.begintime) + CHR(13), "D:\Points.txt", 1)
		
			
		oRet=olms.lmspurchaseExFoxPro(oinv.transactionNumber,oinv.intEarnPointAmount,oinv.orgamt,oinv.intTransactionAmount, ll_prePaid ,lnPrePaidAmt ,0.00,oinv.citems,"",oinv.begintime)
		
			

		*	writ_lms_log(-89,"LMS:lmsPurchaseFoxPro>end>>"+Alltrim(Str(Datetime()-T1)))



		If oRet(1)="0"
			writ_lms_log(-89,"加會員積分",oinv.transactionNumber,oinv.intEarnPointAmount)
*!*				***************************start**********************
*!*				&&增加積分成功后處理換購 By Waston 21/07/2023
*!*				Local strTranNumber,lcstrgifsData
*!*				strTranNumber=""
*!*				lcstrgifsData = ""
*!*				
*!*				&&先用getgiftinfo取可換購貨品,生成臨時表gift_info_tmp
*!*				IF getgiftinfo() > 0 
*!*					&&再取本次的換購貨品,生成giftred的參數lcstrgifsData
*!*					ssql = "Select item_code,transnumber from order_detail (nolock) where id = ?nOrder_id and giftred = 0 and gift = 1 "
*!*					IF SQLEXEC(nHand, ssql , "cun_tmp") > 0 
*!*						IF !EOF("cun_tmp")
*!*							SCAN
*!*								SELECT gift_info_tmp
*!*								LOCATE FOR UPPER(ALLTRIM(item_code)) == UPPER(ALLTRIM(cun_tmp.item_code))
*!*								IF !EOF()
*!*									lcstrgifsData=lcstrgifsData+Allt(gift_info_tmp.gift_code) +"	" + "1|"
*!*									strTranNumber = cun_tmp.transnumber		
*!*								ENDIF 	
*!*							ENDSCAN 
*!*							
*!*							&&進行換購
*!*							IF !EMPTY(strTranNumber)
*!*								lcstrgifsData=Trim(lcstrgifsData,"|")
*!*								llRet = giftred(lcstrgifsData,strTranNumber) 
*!*							ENDIF 	
*!*							
*!*						ENDIF 	
*!*					ENDIF 
*!*				ENDIF 	
*!*				***********************end*************************	
		ELSE


			DO CASE



				CASE  oRet(1)="9"

					fmessagebox("同一張發票不能重復寫入積分!")


				CASE  oRet(1)="405"

					fmessagebox("卡類型不符合要求，請檢查會員卡是否正確！")

				OTHERWISE

					fmessagebox("資料更新失敗!,錯誤代碼："+oRet(1)+Chr(13)+ IIF(!EMPTY( oRet(22) ),  oRet(22) ,"") )


			ENDCASE


			RETURN -1


		Endif



	Endif


	RETURN 1

ENDFUNC

FUNCTION  writ_lms_log

	LPARAMETERS pid,cAction,cINV_no,nAmt		&&pcode 可以是編程代碼,也可以是ID,cAction 是

	IF PARAMETERS()=0
		RETURN
	ENDIF

	LOCAL _id,_action,_inv_no,_amt,_card_no,_shop,_access_user

	_action=IIF(VARTYPE(cAction)#"C","",TRIM(caction))
	_inv_no=IIF(VARTYPE(cINV_no)#"C","",TRIM(cINV_no))
	_amt=IIF(VARTYPE(nAmt)#"N",0,nAmt)

	IF ALINES(cs,_inv_no,4,",")>1

		_inv_no=cs(1)

	ENDIF

	IF VARTYPE(oInv)#"U" AND VARTYPE(oinv.begintime)="C"

		LOCAL c

		c=oinv.begintime


		dtime=CTOT(LEFT(c,4)+"."+SUBSTR(c,5,2)+"."+SUBSTR(c,7,2)+" "+SUBSTR(c,9,2)+":"+SUBSTR(c,11,2))

	ELSE

		dtime=DATETIME()


	ENDIF



	_card_No=oinv.member_number
	_member_type="NORMAL"



	_shop=__member_card_mark		&&先達會員卡店號


	IF VARTYPE(_member_card_access_user)="C"		&&如果有援權方式

		_access_user=_member_card_access_user
	ELSE

		_access_user=""

	ENDIF



	_id=pid
	IF VARTYPE(pid)="C"
		select id from message_log_tmp where pcode=_id INTO CURSOR log_tmp
		IF _tally=0
			SELECT log_tmp
			USE
			RETURN
		ENDIF
		SELECT log_tmp
		use
		_id=log_tmp.id
	ENDIF




	TEXT TO ssql noshow


INSERT INTO [dbo].[lms_Log]
			(
           [log_id]
           ,[datetime]
           ,[shop]
           ,[adduser]
           ,[card_no]
           ,[action]
           ,[inv_no]
           ,[amount]
           ,[member_type]
           ,[access_user]
           )
     VALUES
           (?_id
           ,?dtime
           ,?_shop
           ,?_login_user_name
           ,?_card_no
           ,?_action
           ,?_Inv_no
           ,?_Amt
           ,?_member_type
           ,?_access_user
           )


	ENDTEXT

	IF SQLEXEC(nhand,ssql)<0		&&寫入操作日誌,不論是否寫入成功

		AERROR(err)
		error_catch(getmessage("_sqlserver_error"),Alltrim(Str(err(1))),Trim(err(2)),Program(),Lineno(1))
		RETURN


	ENDIF

ENDFUNC


FUNCTION getgiftitemlist
	
	IF !USED("order_itemlist_tmp")
		RETURN ""
	ENDIF 
	
	SELECT item_code,desccn,qty,0.00 as org_amt,0.00 as net_amt,tel,member_number,transnumber,0.00 as price_mc ;
	FROM order_itemlist_tmp ;
	where gift INTO CURSOR "cun_tmp" 

	*total_number_of_items|^item_number1;item_basket1;quantity1;before_discount_amount1;amount1;remark1|^item_number2;item_basket2;quantity2;before_discount_amount2;amount2;remark2|^item_number3;item_basket3;quantity3;before_discount_amount3;amount3;remark3

	Local lcItems

	Select cun_tmp
	
	IF RECCOUNT("cun_tmp") = 0
		=STRTOFILE("沒有找到換購產品" + CHR(13), "D:\points.txt", 1)
		USE IN "cun_tmp"
		RETURN ""
	ENDIF 
	
	lcItems=Alltrim(Str(Reccount("cun_tmp")))+"|^"

	Select cun_tmp
	SCAN

		IF price_mc>0		&&異幣充值

			lcItems=lcItems+Alltrim(cun_tmp.item_code)+";;"+Alltrim(Str(cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.price_mc * cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.price_mc * cun_tmp.qty,12,2))+";"+Alltrim(Nvl(cun_tmp.tel,""))+"|^"
		ELSE
			lcItems=lcItems+Alltrim(cun_tmp.item_code)+";;"+Alltrim(Str(cun_tmp.qty,12,2))+";"+Alltrim(Str(cun_tmp.org_amt,12,2))+";"+Alltrim(Str(cun_tmp.net_amt,12,2))+";"+Alltrim(Nvl(cun_tmp.tel,""))+"|^"
		ENDIF
	Endscan
	lcItems=Trim(lcItems,"|^")
	IF USED("cun_tmp")
		USE IN "cun_tmp"
	ENDIF 	
	RETURN lcItems
ENDFUNC 	





