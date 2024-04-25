select * from custbalance;

update custbalance set cust_bal = 110
where cust_id = 1;
commit;