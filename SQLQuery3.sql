--'"mm" ->  �馩���@  mm
--"payway" -> �I�ڤ覡 payway.is_coupon = 0
--"cash_coupon" -> �{��§�� payway.iscoupon = 1
--"item_coupon" -> �I��§�� item.is_disc_coupon = 1
--''invoice_disc" -> �o���馩 invoice_disc
--"item_disc" -> ���ا馩 lookup.type = ''disc'' and item_disc = 1

Select * from payway  where is_coupon = 0 
Select * from payway  where is_coupon = 1
Select * from item where is_disc_coupon = 1
Select * from invoice_disc 
Select * from lookup where type = 'disc' and item_disc = 1