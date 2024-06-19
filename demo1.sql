
use my_database1;
create table provinces (
	id int auto_increment primary key,
    name varchar (50),
    description varchar(255)
);

create table customers (
    id int auto_increment primary key,
    name varchar(50),
    email varchar(100),
    province_id int,
    foreign key (province_id) references provinces(id)
    );

insert into provinces(name, description) value ('Thanh Hoa', '');
insert into provinces(name, description) value ('Hai Duong', '');
