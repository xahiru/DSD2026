-- Exercise Set 1: Basic INSERT Operations
-- ROY070, MySQL

-- 1.1 insert one record
insert into staff (staff_id, first_name, last_name, position, salary, dob)
values ('S001', 'John', 'Smith', 'Manager', 45000.00, '1980-05-15');

select * from staff;

-- 1.2 insert 5 at once
insert into staff (staff_id, first_name, last_name, position, salary, dob) values
    ('S002', 'Sarah',   'Johnson',  'Analyst',   32000.00, '1990-03-22'),
    ('S003', 'Michael', 'Brown',    'Developer', 42000.00, '1988-11-02'),
    ('S004', 'Emily',   'Davis',    'Developer', 40000.00, '1992-07-25'),
    ('S005', 'David',   'Wilson',   'Trainee',   20000.00, '2000-01-30'),
    ('S006', 'Laura',   'Martinez', 'Analyst',   34000.00, '1989-09-09');

select * from staff order by staff_id;

-- 1.3 salary is null
insert into staff (staff_id, first_name, last_name, position, salary, dob)
values ('S007', 'Peter', 'Miller', 'Trainee', null, '1999-04-18');

select * from staff where salary is null;

-- 1.4 different column order, values just match the names
insert into staff (last_name, staff_id, first_name, position, salary, dob)
values ('Thompson', 'S008', 'Jessica', 'Supervisor', 38000.00, '1991-06-20');

select * from staff where staff_id = 'S008';

-- 1.5 copy staff earning 35000+ into high_earners
insert into high_earners (staff_id, first_name, last_name, position, salary, dob)
select staff_id, first_name, last_name, position, salary, dob
from   staff
where  salary >= 35000;

select * from high_earners order by salary desc;

-- 1.6 default values
insert into product (name, category, price, quantity)
values ('Laptop', 'Electronics', 899.99, 10);

insert into product (name)
values ('Notebook');

insert into product (name, price)
values ('Mouse', 19.50);

insert into product (name, category, price, quantity)
values ('Pen', default, default, default);

select * from product;

-- 1.7 don't insert a duplicate
insert ignore into staff (staff_id, first_name, last_name, position, salary, dob)
values ('S001', 'John', 'Smith', 'Manager', 45000.00, '1980-05-15');

-- or update the existing row instead
insert into staff (staff_id, first_name, last_name, position, salary, dob)
values ('S001', 'John', 'Smith', 'Senior Manager', 50000.00, '1980-05-15') as new
on duplicate key update
    position = new.position,
    salary   = new.salary;

select count(*) as total_staff from staff;

-- 1.8 department first, then staff that links to it
insert into department (dept_id, dept_name) values
    ('D1', 'Management'),
    ('D2', 'Analytics'),
    ('D3', 'Engineering');

insert into staff (staff_id, first_name, last_name, position, salary, dob, department_id)
values ('S009', 'Daniel', 'Green', 'Analyst', 33000.00, '1993-08-21', 'D2');

-- match existing staff to a department by position
update staff
set department_id = case
    when position in ('Manager', 'Supervisor') then 'D1'
    when position = 'Analyst'                  then 'D2'
    when position = 'Developer'                then 'D3'
    else department_id
end
where staff_id is not null;

select s.staff_id, s.first_name, s.last_name, s.position, d.dept_name
from   staff s
left join department d on d.dept_id = s.department_id
order  by s.staff_id;

-- 1.9 only insert if salary is in range
insert into staff (staff_id, first_name, last_name, position, salary, dob)
select 'S010', 'Tom', 'Baker', 'Analyst', 22000.00, '1995-02-14'
where 22000.00 between 20000.00 and 100000.00;

-- this one is too low, so nothing gets inserted
insert into staff (staff_id, first_name, last_name, position, salary, dob)
select 'S011', 'Too', 'Low', 'Analyst', 5000.00, '1996-01-01'
where 5000.00 between 20000.00 and 100000.00;

select staff_id, first_name, salary from staff where staff_id in ('S010', 'S011');

-- 1.10 single vs bulk insert timing
drop procedure if exists perf_test_proc;

delimiter $$

create procedure perf_test_proc()
begin
    declare i int default 1;
    declare t0 datetime(6);
    declare t1 datetime(6);
    declare t2 datetime(6);
    declare t3 datetime(6);

    -- 10000 single inserts
    set t0 = now(6);
    while i <= 10000 do
        insert into perf_test (id, info) values (i, concat('row ', i));
        set i = i + 1;
    end while;
    set t1 = now(6);

    delete from perf_test;

    -- same 10000 rows in one bulk insert
    set t2 = now(6);
    insert into perf_test (id, info)
    with recursive nums (seq) as (
        select 1
        union all
        select seq + 1 from nums where seq < 10000
    )
    select seq, concat('row ', seq) from nums;
    set t3 = now(6);

    select timestampdiff(microsecond, t0, t1) as single_insert_micros,
           timestampdiff(microsecond, t2, t3) as bulk_insert_micros;
end$$

delimiter ;

call perf_test_proc();
drop procedure perf_test_proc;
drop table perf_test;

select * from staff order by staff_id;
