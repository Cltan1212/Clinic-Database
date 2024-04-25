drop table custbalance;
create table custbalance(
cust_id number(2) not null,
cust_bal number(4) not null,
constraint custbalance_pk primary key (cust_id)
);
 
insert into custbalance values(1,100);
insert into custbalance values(2,200);
commit;

select * from custbalance;

update custbalance set cust_bal = 110
where cust_id = 1;

commit;
