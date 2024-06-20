create database salary_management;
use salary_management;

create table customers(
c_id int auto_increment primary key,
c_name varchar (50),
c_age int
);

create table orders(
o_id int auto_increment primary key,
c_id int,
o_date date,
o_total_price float(15),
foreign key fk_orders_customers(c_id) references customers(c_id)
);

create table products(
p_id int auto_increment primary key,
p_name varchar(100),
p_price float(15)
);

create table orders_detail(
o_id int,
p_id int,
foreign key orders_products(o_id) references orders(o_id),
foreign key orders_products2(p_id) references products(p_id)
);


