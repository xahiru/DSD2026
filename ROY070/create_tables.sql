-- dreamhome schema (exercise set 1)
-- mysql

drop database if exists dreamhome;
create database dreamhome;
use dreamhome;

drop table if exists salary_audit;
drop table if exists staff;
drop table if exists high_earners;
drop table if exists product;
drop table if exists department;
drop table if exists perf_test;

-- staff
create table staff (
    staff_id      char(4)        primary key,
    first_name    varchar(50)    not null,
    last_name     varchar(50)    not null,
    position      varchar(50),
    salary        decimal(10,2)  check (salary >= 0),
    dob           date,
    department_id char(2)        null
);

-- high_earners
create table high_earners (
    staff_id    char(4)        primary key,
    first_name  varchar(50)    not null,
    last_name   varchar(50)    not null,
    position    varchar(50),
    salary      decimal(10,2),
    dob         date
);

-- product
create table product (
    product_id   int            auto_increment primary key,
    name         varchar(100)   not null,
    category     varchar(50)    default 'General',
    price        decimal(10,2)  default 0.00,
    quantity     int            default 0,
    created_at   timestamp      default current_timestamp
);

-- department
create table department (
    dept_id     char(2)        primary key,
    dept_name   varchar(50)    not null unique
);

alter table staff
    add constraint fk_staff_department
    foreign key (department_id) references department (dept_id);

-- salary_audit
create table salary_audit (
    audit_id    int           auto_increment primary key,
    staff_id    char(4),
    old_salary  decimal(10,2),
    new_salary  decimal(10,2),
    changed_at  timestamp     default current_timestamp
);

-- perf_test
create table perf_test (
    id    int          primary key,
    info  varchar(100)
);
