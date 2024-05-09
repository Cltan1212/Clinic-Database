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

update custbalance set cust_bal = 300
where cust_id = 1;

select * from custbalance;

commit;

update custbalance set cust_bal = 300
where cust_id = 1;

commit;

update custbalance2 set cust_bal = 300
where cust_id = 2;
update custbalance set cust_bal = 300
where cust_id = 1;
rollback;

SELECT
    username,
    sid,
    serial#,
    status,
    state,
    to_char(logon_time, 'MONdd hh24:mi') AS "Logon Time"
FROM
    v$session
WHERE
        type = 'USER'
    AND username = user
    AND upper(osuser)!= 'ORACLE'
ORDER BY
    "Logon Time";

begin
     kill_own_session(2312,7971);
end;
