LPARAMETERS tcFile,sdate,edate

&&臨時視圖名稱
LOCAL lcview_random, lcview_inv, lcview_inv_disc, lcview_invitem, lcview_invitem_disc, lcview_invmm 
lcview_random = SYS(2015)
lcview_inv = "inv_view" + lcview_random
lcview_inv_disc = "inv_disc_view" + lcview_random
lcview_invitem = "invitem_view" + lcview_random
lcview_invitem_disc = "invitem_disc_view" + lcview_random
lcview_invmm = "invmm_view" + lcview_random


LOCAL dnewsDate
dnewsDate = sdate - 700


&&建立臨時視圖
IF SQLEXEC(nhand, "exec create_inv_view_all_shop ?lcview_random,?dnewsDate,?edate") < 0
	=AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))
	RETURN .F.
ENDIF


&&顯示成本
gl_tmpcost = .t.
&&所有門店
xshop ="all"
&&所有營業員
xsalesman = "all"

&&日期
cond = " where inv.belongdate between ?sdate and ?edate "
&&門店
cond = cond + " and (inv.shop_id > 0 or (inv.shop_id = -100 and inv.tran_type = 'A')) "

&&臨時表
_file1 = "##proantmp" + ALLTRIM(STR(__stationid)) + SYS(2015) 
_file2 = "##proantmp" + ALLTRIM(STR(__stationid)) + SYS(2015) 

item_cond1 = ""

cond3 = ""


IF VARTYPE(__new_deposit) <> "U" AND __new_deposit
	cond3 = " and a.inv_id in (select id from " + lcview_inv + " (nolock) where shop_id > 0 or (shop_id = -100 and voided = 0)) "
ENDIF 

lcPayway_cond = ""




TEXT TO cmd NOSHOW TEXTMERGE &&##tmp1
	select a.inv_id into <<_file1>> from <<lcview_invitem>> a WITH (nolock)
		left join <<lcview_inv>> as inv on a.inv_id = inv.id
		left join item on a.item_id = item.id
		left join shop on inv.shop_id = shop.id
		left join invpay on inv.id = invpay.inv_id
		left join inv_rem on inv.id = inv_rem.inv_id
		<<cond>> <<cond3>> <<lcPayway_cond>>
		group by a.inv_id 
ENDTEXT

IF SQLEXEC(nhand, cmd) < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))
	=SQLEXEC(nhand, "drop table " + _file1)
	RETURN .F.
ENDIF

IF VARTYPE(__rpt_item_name) #"U" 
	_name = "item.name" + ALLTRIM(STR(__rpt_item_name))
ELSE 	
	_name = "item.name1"
ENDIF 

cond = ""

=SQLEXEC(nhand, "select top 1 * from coupon_master", "cr_nouse")

* 2013-07-31
* 如有用 coupon 個 len 800 export to excel 時會出唔個 column
* 所以有 coupon 先 800 無就 250

IF EOF("cr_nouse")
	TEXT TO _coupon NOSHOW 
		SPACE(250) as payment, 
		99999.99 as vip_redeem_amt,
		SPACE(250) as coupon_no, 
		SPACE(250) as coupon_no2,
		SPACE(250) as item_disc_rem,
		SPACE(250) as disc_rem,
	ENDTEXT 
ELSE 
	TEXT TO _coupon NOSHOW 
		SPACE(250) as payment, 
		99999.99 as vip_redeem_amt,
		SPACE(250) as coupon_no,
  	    SPACE(250) as coupon_no2,
		SPACE(250) as item_disc_rem,
		SPACE(250) as disc_rem,
	ENDTEXT 
ENDIF 


_return_reason =  " return_item_reason = ISNULL( (select name from lookup where id = c.return_item_reason_id),  ''),  "

lcCond_chungshun = ""

Item_cond1 = ""

lcDeposit_column = ""
IF VARTYPE(__new_deposit) <> "U" AND __new_deposit
	**lcDeposit_column = ", case when ISNULL(d.deposit_type, '') <> '' then 1 else 0 end as is_deposit, ISNULL(d.deposit_type, '') as deposit_type "
	TEXT TO lcDeposit_column NOSHOW TEXTMERGE 
		, case when ISNULL(d.deposit_type, '') <> '' or inv.shop_id = -100 then 1 else 0 end as is_deposit
		, case when inv.shop_id = -100 then 'deposit' when ISNULL(d.deposit_type, '') = 'normal' then 'settled' else ISNULL(d.deposit_type, '') end as deposit_type 
	ENDTEXT 
ENDIF 



TEXT TO cmd NOSHOW TEXTMERGE &&##tmp2 from ##tmp1

	select a.id, a.tran_type as tran_type1, SPACE(20) as tran_type, 99999999 as return_no, 
		case when inv.shop_id = -100 then shop_100.code else shop.code end as shopcode, 
    	case when inv.shop_id = -100 then shop_100.name else shop.name end as shopname,
		station.computer as station, inv.addtime, convert(char(10), inv.belongdate, 23) as date, 
		ISNULL(lookup.name , '') as type,
		a.inv_id, inv.inv_no as inv , SPACE(30) as inv_no, a.rec_no, item.code as itemcode, 
		
		--(item.name1 + CASE when ISNULL(invoice_disc.name, disc_lookup.name) is null or ISNULL(invoice_disc.name, disc_lookup.name) = '' then '' else ' (' + LTRIM(RTRIM(ISNULL(invoice_disc.name, disc_lookup.name))) + ')'end)  as itemname,
		--ISNULL(invoice_disc.name, <<_name>> ) as itemname, 		
		(<<_name>> + CASE when invoice_disc.name is null or invoice_disc.name = '' then '' else ' (' + LTRIM(RTRIM(invoice_disc.name)) + ')'end)  as itemname,
		item.name3, 
		a.qty, a.amount, a.dis_amt, a.real_amt, ROUND(a.cost,5) as cost , ROUND(a.profit,5) as profit , item.price1, 
		void_reason = ISNULL( (select name from lookup where id = inv.void_reason_id), '') , 
		cate_code = isnull( (select code from lookup where id = item.cate_id), ''),
		category= isnull( (select name from lookup where id = item.cate_id), ''),
		sub_cate_code = isnull( (select code from lookup where id = item.subcate_id), ''),
		sub_cate = isnull( (select name from lookup where id = item.subcate_id), ''),
		brand = isnull( (select name from lookup where id = item.brand_id), ''),
		brand_code = isnull( (select code from lookup where id = item.brand_id), ''),
		color_code = isnull( (select code from lookup where id = item.color_id), ''),
		barcode = isnull( (select top 1 barcode from item_barcode where item_id = a.item_id and type = 'B'), ''),
		vendor_code = isnull( (select code from vendor where id = item.vendor_id), ''),
		vendor_name = isnull( (select co from vendor where id = item.vendor_id), ''),
		salesman_code = isnull( ( select code from sys_user where id = inv.sales_id ), ''), 
		salesman_name = isnull( ( select name from sys_user where id = inv.sales_id ), ''),
		isnull( ( select commission_percent from sys_user where id = inv.sales_id ) , 0)  as salesman_perc, 
		isnull(item.commission_percent, 0) as comm_perc, 
		isnull(item.commission_amount, 0) as comm_amt, 
		999999999.99 as commission,
		999999999.99 as pay_amt,
		cashier_code = isnull( ( select code from sys_user where id = inv.user_id ), ''), 
		cashier_name = isnull( ( select name from sys_user where id = inv.user_id ), ''),
		a.input_code, 
		isdeposit = ISNULL( (select COUNT(*) from inv_deposit where inv_id = inv.id), 0 ) , 

		<<_coupon>>

		isnull(cust.code,'') as cust_code, 

		isnull(cust.engname,'') as engname,
		ltrim(isnull(cust.chiname, '') + '   ' + isnull(cust.companyname, '')) as chiname,
		
		isnull( cast(cust.remark as nvarchar(200)) , '') as cust_remark ,
		ISNULL(travel.descen, '') as travel_code, ISNULL(travel.desccn, '') as travel_name,
		isnull(c.item_rem1, '') as item_rem1,
		isnull(c.item_rem2, '') as item_rem2,
		isnull( convert( char(250), c.item_rem3), '') as item_rem3,
		isnull(c.item_rem4, '') as item_rem4,
		isnull(c.item_rem5, '') as item_rem5,
		isnull(c.item_rem6, '') as item_rem6,
		isnull(d.rem_date1,'') as rem_date1,
		isnull(d.rem_date2,'') as rem_date2,
		isnull(d.rem_date3,'') as rem_date3,
		isnull(d.rem_date4,'') as rem_date4,
		SPACE(10) as deposit_date,
		SPACE(10) as deposit_time, 
		isnull(d.inv_rem1,'') as inv_rem1,
		isnull(d.inv_rem2,'') as inv_rem2,
		isnull(d.inv_rem3,'') as inv_rem3,
		isnull(d.inv_rem4,'') as inv_rem4,
		isnull(d.inv_rem5,'') as inv_rem5,
		isnull(d.inv_rem6,'') as inv_rem6,
		isnull(d.inv_rem7,'') as inv_rem7,
		isnull(d.inv_rem8,'') as inv_rem8,
		isnull(d.inv_rem9,'') as inv_rem9,
		isnull(d.inv_rem10,'') as inv_rem10,
		isnull(d.inv_rem11,'') as inv_rem11,
		isnull(d.inv_rem12,'') as inv_rem12,
		isnull(f.code, '') as tran_shop_code,
		isnull(f.name, '') as tran_shop_name,
		
		<<_return_reason>>
		
		isnull(e.dis_item, 0) as dis_item, isnull(e.dis_mm, 0) as dis_mm ,
		isnull(e.dis_member, 0) as dis_member, isnull(e.dis_edit, 0) dis_edit,
		isnull(a.gold_price, 0) as gold_price
		<<lcDeposit_column>>
		
		, a.mm_id
		
		into <<_file2>>
		from <<lcview_invitem>> a WITH (nolock)
		left join <<lcview_inv>> as inv on a.inv_id = inv.id
		left join item (nolock) on a.item_id = item.id
		left join shop (nolock) on inv.shop_id = shop.id

/*
-- chris 2021-03-29 ciao report server : error could not continue scan with nolock due to data movement
-- 先將 cust 改為 readpast, 其他 table 再留意下先
*/


--		left join cust (nolock) on inv.cust_id = cust.id
		left join cust (readpast) on inv.cust_id = cust.id

		left join invitem_rem c (nolock) on a.id = c.invitem_id
		left join inv_rem d (nolock) on inv.id = d.inv_id
		left join station (nolock) on inv.station_id = station.id
		left join shop as shop_100 on station.shop_id = shop_100.id
		left join lookup (nolock) on inv.invtype_id = lookup.id
		left join travel (nolock) on inv.travel_id = travel.id
		left join <<lcview_invitem_disc>> e on a.id = e.invitem_id
		left join shop f (nolock) on d.tran_shop_id = f.id
		left join invoice_disc (nolock) on e.item_discount_reason_id = invoice_disc.id and (a.input_code = 'INVOICE_DISC' or a.input_code <> 'INVOICE_DISC_AUTO_REDEEM')
		left join lookup disc_lookup (nolock) on e.item_discount_reason_id = disc_lookup.id and a.input_code <> 'INVOICE_DISC' and a.input_code <> 'INVOICE_DISC_AUTO_REDEEM'
		where a.inv_id in (select inv_id from <<_file1>> ) <<lcCond_chungshun>> <<cond>> 

		---<<lcPayway_cond>>

ENDTEXT

 && <<item_cond1>>

IF SQLEXEC(nhand, cmd) < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

TRY 
	= STRTOFILE(cmd, "sqlReport.txt")
CATCH TO loTmpError 
ENDTRY 


cmd = "select * from " + _file2

&&##tmp2
IF SQLEXEC(nhand, "select sell_inv_id, code from coupon_master (nolock) where sell_inv_id in (select inv_id from "+ _file2 +") and active = 1 order by sell_inv_id, code " , "cr_cou") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

SELECT * FROM cr_cou INTO CURSOR cr_cou READWRITE 

SELECT cr_cou
INDEX on sell_inv_id TAG id 
SET ORDER TO id



IF SQLEXEC(nhand, cmd, "cr_inv") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))
	RETURN .F.
ENDIF

SELECT * FROM cr_inv INTO CURSOR cr_inv READWRITE 
REPLACE ALL vip_redeem_amt WITH 0

* chris 2021-08-13
* sql 不用 FORMAT 向下兼容 sql 2008
*		convert(varchar(20), FORMAT(isnull(d.rem_date3, '1900-01-01 00:00'), 'yyyy-MM-dd')) as deposit_date,
*		convert(varchar(20), FORMAT(isnull(d.rem_date3, '1900-01-01 00:00'), '\HH:mm')) as deposit_time,

REPLACE ALL deposit_date WITH ALLTRIM(SUBSTR(TTOC(rem_date3),1,10)) 	FOR rem_date3 > {^2000-1-1}
REPLACE ALL deposit_time WITH ALLTRIM(SUBSTR(TTOC(rem_date3),11,10)) 	FOR rem_date3 > {^2000-1-1}


SELECT cr_inv
SCAN 
	SELECT cr_cou
	SET FILTER TO sell_inv_id = cr_inv.inv_id
	GO top
	DO WHILE .NOT. EOF()
		IF LEN(ALLTRIM(cr_inv.coupon_no) + "  " + ALLTRIM(cr_cou.code)) <= 250
			REPLACE cr_inv.coupon_no WITH ALLTRIM(cr_inv.coupon_no) + "  " + ALLTRIM(cr_cou.code)
		ELSE 
			REPLACE cr_inv.coupon_no2 WITH ALLTRIM(cr_inv.coupon_no2) + "  " + ALLTRIM(cr_cou.code)
		ENDIF 
		skip
	ENDDO
	
	SELECT cr_inv
ENDSCAN 

USE IN cr_cou





SELECT cr_inv
REPLACE ALL commission WITH 0, pay_amt WITH 0
replace all tran_type with "New" for tran_type1 = "AI"
replace all tran_type with "Return" for tran_type1 = "AR"
replace all tran_type with "Voided" for tran_type1 = "VI"
replace all tran_type with "Voided Return" for tran_type1 = "VR"


TEXT TO cmd NOSHOW TEXTMERGE &&##tmp2
	select y.*, inv.inv_no as return_no from (
	select z.* , invitem.inv_id as return_id from (
	select a.invitem_id, a.return_invitem_id from <<lcview_invitem_disc>> a left join <<lcview_inv>> as inv on a.inv_id = inv.id where a.invitem_id in 
	(select id from <<_file2>> where tran_type1 = 'ar' or tran_type1 = 'vr') ) z 
	left join <<lcview_invitem>> as invitem on z.return_invitem_id = invitem.id ) y left join <<lcview_inv>> as inv on y.return_id = inv.id
ENDTEXT 
IF SQLEXEC(nhand, cmd, "cr_ret") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

SELECT * FROM cr_ret INTO CURSOR cr_ret READWRITE 

SELECT cr_inv
INDEX on id TAG id 
REPLACE ALL return_no WITH 0
SET ORDER TO id 

SELECT cr_ret
REPLACE ALL return_no WITH -1 FOR ISNULL(return_no)

SCAN
	SELECT cr_inv
	SEEK cr_ret.invitem_id
	IF FOUND() 
		REPLACE cr_inv.return_no WITH cr_ret.return_no
	ENDIF 
	SELECT cr_ret
ENDSCAN 		
USE IN cr_ret 



TEXT TO cmd NOSHOW TEXTMERGE &&##tmp2

	select a.inv_id, a.payway_id, a.addtime, a.tender_amt, a.pay_amt,
		tender_code = (select name from payway (nolock) where id = a.payway_id),
		tender_sign  = (select cursign from payway (nolock) where id = a.payway_id),
		a.change_amt,
		change_code = (select name from payway (nolock) where id = a.change_id), 
		change_sign = (select cursign from payway (nolock) where id = a.change_id), 
		a.ref_no
		from invpay a (nolock) 
		left join payway (nolock) on a.payway_id = payway.id
		where a.inv_id in (select inv_id from <<_file2>> group by inv_id)
ENDTEXT

IF SQLEXEC(nhand, cmd, "cr_pay") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

SELECT * FROM cr_pay INTO CURSOR cr_pay READWRITE 

SELECT cr_inv

REPLACE ALL inv_no WITH ALLTRIM(station) + " / " + REPLICATE("0", 7-LEN(ALLTRIM(STR(inv)))) + ALLTRIM(STR(inv))

INDEX on inv_id TAG id
INDEX on inv_no TAG invno
SET ORDER TO invno

SELECT inv_no, void_reason FROM cr_inv INTO CURSOR cr1 WHERE !EMPTY(void_reason) GROUP BY inv_no, void_reason
SELECT cr1
SCAN
	SELECT cr_inv
	REPLACE ALL void_reason WITH cr1.void_reason FOR inv_no = cr1.inv_no
	SELECT cr1
ENDSCAN 
USE IN cr1

SELECT cr_pay
SCAN

	SELECT cr_inv
	SET ORDER TO id
	SEEK cr_pay.inv_id
	SET ORDER TO invno
	_tmpinv = cr_inv.inv_no

	SELECT cr_inv
			replace ALL pay_amt WITH pay_amt + cr_pay.pay_amt FOR inv_no = _tmpinv

			REPLACE ALL payment WITH ALLTRIM(payment) + IIF(!EMPTY(payment), ";", "") + ;
				ALLTRIM(cr_pay.tender_code) + "   " + ALLTRIM(cr_pay.tender_sign) + ALLTRIM(TRANSFORM(cr_pay.tender_amt , "99,999,999.99")) + ;
				IIF(cr_pay.change_amt = 0 , "" ,  ;
						"   " + rv_change + "   " + ALLTRIM(cr_pay.change_code) + "   -" + ALLTRIM(cr_pay.change_sign) + ALLTRIM(TRANSFORM(cr_pay.change_amt , "99,999,999.99")) ) + ;
				+ "   " + ;
				IIF( cr_inv.isdeposit = 0 , "", SUBSTR(TTOC(cr_pay.addtime),1,16) + "   " ) + IIF(EMPTY(cr_pay.ref_no), "",  "Ref : ") + ALLTRIM(cr_pay.ref_no) + ;
				IIF(__special_customer = "ciao", "  Station id : " + SUBSTR(id,1,4), "") + CHR(13) ;
				FOR inv_no = _tmpinv


	SELECT cr_pay
ENDSCAN 



SELECT tender_code as payway, SUM(tender_amt) as tender_amt FROM cr_pay INTO CURSOR cr3 READWRITE GROUP BY tender_code 
SELECT change_code as payway, SUM(-change_amt) as tender_amt from cr_pay INTO CURSOR cr4 READWRITE GROUP BY change_code 


SELECT cr3
SCAN
	SELECT cr4
	LOCATE FOR ALLTRIM(payway) == ALLTRIM(cr3.payway)
	IF !FOUND()
		APPEND blank
		REPLACE cr4.payway WITH cr3.payway
	ENDIF 	
		
	REPLACE cr4.tender_amt WITH cr4.tender_amt + cr3.tender_amt
	
	SELECT cr3
ENDSCAN 		


TEXT TO cmd NOSHOW TEXTMERGE &&##tmp2
	select invitem_id, a.dis_item as disc, lookup.name as name
	from <<lcview_invitem_disc>> a
	left join <<lcview_invitem>> b (nolock) on a.invitem_id = b.id	
	left join lookup (nolock) on a.item_discount_reason_id = lookup.id
	where a.inv_id in (select inv_id from <<_file2>> group by inv_id) and a.item_discount_reason_id <> -1 and b.input_code <> 'INVOICE_DISC' and b.input_code <> 'INVOICE_DISC_AUTO_REDEEM'
ENDTEXT 


IF SQLEXEC(nhand, cmd, "cr_disc") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

SELECT * FROM cr_disc INTO CURSOR cr_disc READWRITE 

SELECT cr_disc
SCAN

	SELECT cr_inv
	LOCATE FOR ALLTRIM(id) = ALLTRIM(cr_disc.invitem_id)
	IF FOUND()
		REPLACE item_disc_rem WITH ALLTRIM(item_disc_rem) + "      " + ALLTRIM(cr_disc.name) + " : " + ALLTRIM(TRANSFORM(cr_disc.disc , "99,999,999.99")) IN cr_inv
	ENDIF 
	
	SELECT cr_disc
ENDSCAN 

USE IN cr_disc 

=SQLEXEC(nhand, "select top 0 * from invmm", "cr1")
IF EMPTY( FIELD("mm_desc"))

	TEXT TO cmd NOSHOW TEXTMERGE &&2個##tmp2 
		select * from (
		select a.inv_id, a.dis_edit as disc,  ISNULL(b.code, '') as code, isnull(b.name, '') as name, 0 as hit, 1 as type , 0 as mm_id
		from <<lcview_inv_disc>> a
		left join lookup b (nolock) on a.discount_reason_id = b.id
		where a.dis_edit <> 0 and a.inv_id in (select inv_id from <<_file2>> group by inv_id)
		union
		select a.inv_id, a.less_amt as disc, ISNULL(b.mm_no, '') as code, isnull(b.mm_desc, '') as name, a.total_hit as hit, 2 as type , ISNULL(a.mm_id,0) as mm_id
		from <<lcview_invmm>> a
		left join mm b (nolock) on a.mm_id = b.id
		where a.less_amt <> 0 and a.inv_id in (select inv_id from <<_file2>> group by inv_id)
		) a order by type
	ENDTEXT


ELSE 

	TEXT TO cmd NOSHOW TEXTMERGE &&2個##tmp2
		select * from (
		select a.inv_id, a.dis_edit as disc, ISNULL(b.code, '') as code, isnull(b.name, '') as name, 0 as hit, 1 as type , 0 as mm_id
		from <<lcview_inv_disc>> a
		left join lookup b (nolock) on a.discount_reason_id = b.id
		where a.dis_edit <> 0 and a.inv_id in (select inv_id from <<_file2>> group by inv_id)
		union
		select a.inv_id, a.less_amt as disc, ISNULL(b.mm_no, '') as code, ISNULL(a.mm_desc, isnull(b.mm_desc, '')) as name, a.total_hit as hit, 2 as type
			, ISNULL(a.mm_id,0) as mm_id
		from <<lcview_invmm>> a
		left join mm b (nolock) on a.mm_id = b.id
		where a.less_amt <> 0 and a.inv_id in (select inv_id from <<_file2>> group by inv_id)
		) a order by type
	ENDTEXT

ENDIF

IF SQLEXEC(nhand, cmd, "cr_disc") < 0
	= AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))

	=SQLEXEC(nhand, "drop table " + _file1)
	=SQLEXEC(nhand, "drop table " + _file2)

	RETURN .F.
ENDIF

USE IN cr1 

SELECT * FROM cr_disc INTO CURSOR cr_disc READWRITE 

SELECT "cr_disc"
INDEX on inv_id TAG id

SELECT inv_id FROM cr_inv GROUP BY inv_id INTO CURSOR cr_tmp_invid
SELECT cr_tmp_invid
SCAN 
	SET FILTER TO inv_id = cr_tmp_invid.inv_id IN "cr_disc"
	
	_tmp_disc_rem = ""
	SELECT cr_disc
	SCAN 
		_tmp_disc_rem = _tmp_disc_rem + "    " + IIF(cr_disc.type = 1 AND EMPTY(cr_disc.name), lcDisc_order, ALLTRIM(cr_disc.code) + "-" + ALLTRIM(cr_disc.name)) + ;
			IIF(cr_disc.type = 2, " X " + ALLTRIM(STR(cr_disc.hit)), "" ) + " : " + ;
			ALLTRIM(TRANSFORM(cr_disc.disc , "99,999,999.99")) 
		SELECT cr_disc
	ENDSCAN 

	SELECT cr_inv
	REPLACE disc_rem WITH _tmp_disc_rem FOR inv_id = cr_tmp_invid.inv_id IN cr_inv 

	SELECT cr_tmp_invid
ENDSCAN 
USE IN cr_tmp_invid	
USE IN cr_disc 

SELECT cr_inv
REPLACE ALL disc_rem WITH ALLTRIM(disc_rem)
REPLACE ALL item_disc_rem WITH ALLTRIM(item_disc_rem)


=SQLEXEC(nhand, "drop table " + _file1)
=SQLEXEC(nhand, "drop table " + _file2)
		

USE IN cr3
USE IN cr4
USE IN cr_pay


SELECT cr_inv
REPLACE ALL payment WITH ALLTRIM(payment)

_field = ""


DO case
			
	CASE VARTYPE(__new_deposit) <> "U" AND __new_deposit AND VARTYPE(__new_deposit_order_info) <> "U" AND __new_deposit_order_info
		SELECT deposit_date, deposit_time, tran_type, shopcode, shopname, station, addtime, date, type, inv, inv_no, rec_no, itemcode, itemname, name3, input_code, qty, amount, dis_amt, 0000000.00 as disc_per, real_amt, ;
			return_no, cost, profit, price1, 0000000.00 as margin, payment, vip_redeem_amt, pay_amt, void_reason, cate_code, category, sub_cate_code, sub_cate, brand, vendor_code, vendor_name, ;
			salesman_code, salesman_name, &_field cashier_code, cashier_name, cust_code, engname, chiname, cust_remark, travel_code, travel_name, ;
			item_rem1, item_rem2, item_rem3, item_rem4, item_rem5, item_rem6, return_item_reason, ;
			rem_date1, rem_date2, rem_date3, rem_date4, inv_rem1, inv_rem2, inv_rem3, inv_rem4, inv_rem5, inv_rem6, inv_rem7, inv_rem8, inv_rem9, inv_rem10 , inv_rem11, inv_rem12 , coupon_no, coupon_no2, item_disc_rem, disc_rem, ;
			brand_code, color_code, barcode,  0000000.00 as org_unit_price, 0000000.00 as disc_unit_price, gold_price , is_deposit, deposit_type ;
			from cr_inv order by shopcode, inv_no, rec_no, is_deposit, deposit_type into cursor cr_out readwrite
			
	CASE VARTYPE(__new_deposit) <> "U" AND __new_deposit
		SELECT tran_type, shopcode, shopname, station, addtime, date, type, inv, inv_no, rec_no, itemcode, itemname, name3, input_code, qty, amount, dis_amt, 0000000.00 as disc_per, real_amt, ;
			return_no, cost, profit, price1, 0000000.00 as margin, payment, vip_redeem_amt, pay_amt, void_reason, cate_code, category, sub_cate_code, sub_cate, brand, vendor_code, vendor_name, ;
			salesman_code, salesman_name, &_field cashier_code, cashier_name, cust_code, engname, chiname, cust_remark, travel_code, travel_name, ;
			item_rem1, item_rem2, item_rem3, item_rem4, item_rem5, item_rem6, return_item_reason, ;
			rem_date1, rem_date2, rem_date3, rem_date4, inv_rem1, inv_rem2, inv_rem3, inv_rem4, inv_rem5, inv_rem6, inv_rem7, inv_rem8, inv_rem9, inv_rem10 , inv_rem11, inv_rem12 , coupon_no, coupon_no2, item_disc_rem, disc_rem, ;
			brand_code, color_code, barcode,  0000000.00 as org_unit_price, 0000000.00 as disc_unit_price, gold_price , is_deposit, deposit_type ;
			from cr_inv order by shopcode, inv_no, rec_no, is_deposit, deposit_type into cursor cr_out readwrite
	
	OTHERWISE 
		SELECT tran_type, shopcode, shopname, station, addtime, date, type, inv, inv_no, rec_no, itemcode, itemname, name3, input_code, qty, amount, dis_amt, 0000000.00 as disc_per, real_amt, ;
			return_no, cost, profit, price1, 0000000.00 as margin, payment, vip_redeem_amt, pay_amt, void_reason, cate_code, category, sub_cate_code, sub_cate, brand, vendor_code, vendor_name, ;
			salesman_code, salesman_name, &_field cashier_code, cashier_name, cust_code, engname, chiname, cust_remark, travel_code, travel_name, ;
			item_rem1, item_rem2, item_rem3, item_rem4, item_rem5, item_rem6, return_item_reason, ;
			rem_date1, rem_date2, rem_date3, rem_date4, inv_rem1, inv_rem2, inv_rem3, inv_rem4, inv_rem5, inv_rem6, inv_rem7, inv_rem8, inv_rem9, inv_rem10 , inv_rem11, inv_rem12 , coupon_no, coupon_no2, item_disc_rem, disc_rem, ;
			brand_code, color_code, barcode,  0000000.00 as org_unit_price, 0000000.00 as disc_unit_price, gold_price ;
			from cr_inv order by shopcode, inv_no, rec_no into cursor cr_out readwrite
		
ENDCASE 
USE IN cr_inv
USE IN cr_nouse

SELECT cr_out
REPLACE ALL disc_Per WITH ABS(dis_amt) / ABS(amount) * 100 FOR amount <> 0


SELECT "cr_out"


SELECT cr_out


REPLACE ALL engname WITH "" FOR engname = chiname
REPLACE ALL profit WITH real_amt - cost

REPLACE ALL margin WITH profit / real_amt * 100 FOR real_amt <> 0

SELECT cr_out
SELECT tran_type,shopcode,shopname,station,addtime,date,type,inv,inv_no,rec_no,itemcode,itemname,name3,input_code,qty,;
amount,dis_amt,disc_per,real_amt,return_no,cost,profit,price1,margin,payment,vip_redeem_amt,pay_amt,void_reason,cate_code,;
category,sub_cate,brand,vendor_code,vendor_name,salesman_code,salesman_name,cashier_code,cashier_name,cust_code,engname,chiname,;
cust_remark,travel_code,travel_name,item_rem1,item_rem2,item_rem3,item_rem4,item_rem5,item_rem6,return_item_reason,rem_date1,inv_rem1,;
inv_rem2,inv_rem3,inv_rem4,inv_rem5,inv_rem6,inv_rem7,inv_rem8,inv_rem9,inv_rem10,inv_rem11,inv_rem12,coupon_no,coupon_no2,item_disc_rem,;
disc_rem,brand_code,color_code,barcode,org_unit_price,disc_unit_price,gold_price FROM cr_out INTO CURSOR cr_out
SELECT cr_out

COPY TO &tcFile TYPE XLS 

USE IN cr_out


&&取消臨時視圖
IF SQLEXEC(nhand, "exec drop_inv_view ?lcview_random") < 0
	=AERROR(err)
	error_catch(getmessage("_sqlserver_error"),ALLTRIM(STR(err(1))),TRIM(err(2)),&__program, LINENO(1))
	RETURN .F.
ENDIF

=SQLIDLEDISCONNECT(0)
