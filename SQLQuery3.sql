--'"mm" ->  §é¦©ºûÅ@  mm
--"payway" -> ¥I´Ú¤è¦¡ payway.is_coupon = 0
--"cash_coupon" -> ²{ª÷Â§¨é payway.iscoupon = 1
--"item_coupon" -> §I´«Â§¨é item.is_disc_coupon = 1
--''invoice_disc" -> µo²¼§é¦© invoice_disc
--"item_disc" -> ¶µ¥Ø§é¦© lookup.type = ''disc'' and item_disc = 1

Select * from payway  where is_coupon = 0 
Select * from payway  where is_coupon = 1
Select * from item where is_disc_coupon = 1
Select * from invoice_disc 
Select * from lookup where type = 'disc' and item_disc = 1