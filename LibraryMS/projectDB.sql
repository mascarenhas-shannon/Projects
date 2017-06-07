create database DBProject;
use DBProject;

create table authors(
		author_id int(11) unsigned not null auto_increment,
    	author_name varchar(20) not null,
    	primary key(author_id)
);

create table publishers(
		publisher_id int(11) unsigned not null auto_increment,
    	publisher_name varchar(20) not null,
    	publisher_address varchar(50) not null,
		primary key(publisher_id)
);


create table book_details( 
		ISBN int(11) unsigned not null,        
		title varchar(20) not null,
        author_id int(11) unsigned not null, 
        publisher_id int(11) unsigned not null,
        publisher_date date not null,
        primary key(ISBN),
		foreign key (author_id) references authors(author_id),
        foreign key (publisher_id) references publishers(publisher_id)
);


create table book(
	book_id int(11) unsigned not null auto_increment, 
	ISBN int(11) unsigned not null,
	primary key(book_id),
	foreign key (ISBN) references book_details(ISBN)
);


create table branches(
	library_id int(11) unsigned not null auto_increment,
    	library_name varchar(20) not null,
    	library_location varchar(20) not null,
	primary key(library_id)
);

create table bookAssociation(
	book_id int(11) unsigned not null, 
	library_id int(11) unsigned not null,
	primary key(book_id,library_id),
	foreign key (book_id) references book(book_id),
	foreign key (library_id) references branches(library_id)
);

create table reader_details(
	reader_id bigint unsigned not null,
    	reader_name varchar(20) not null,
    	reader_address varchar(50) not null,
	phone_number int(10),	
	primary key(reader_id)
);



create table total_number_of_copies(
    	ISBN int(11) unsigned not null,
    	library_id int(11) unsigned not null,
    	no_of_copies int(5) unsigned not null,
	-- in_stock_copies int(5) unsigned not null,
    	primary key(ISBN, library_id),
    	foreign key (ISBN) references book(ISBN),
    	foreign key (library_id) references branches(library_id) 
);


create table reserve_a_book(
	reserve_id bigint unsigned unique not null,
	ISBN int(11) unsigned not null,        
	reader_id bigint unsigned not null,
	-- library_id int(11) unsigned not null,
	reserve_datetime datetime not null, 
	status varchar(20) not null,
	primary key(reserve_id,ISBN,reader_id),
	-- foreign key (book_id,copy_id,library_id) references copies(book_id,copy_id,library_id),
        foreign key (ISBN) references book(ISBN),
	foreign key (reader_id) references reader_details(reader_id)
	-- foreign key (library_id) references branches(library_id)
);



create table borrow_a_book(
	borrow_id bigint unsigned unique not null,
    	book_id int(11) unsigned not null,      
	reader_id bigint unsigned not null,
	library_id int(11) unsigned not null,
	borrow_datetime datetime not null, 
	due_date date not null,
	return_datetime datetime default null,
	fine_paid_by_reader float default 0.0,
	status varchar(20) not null,    	
	primary key(borrow_id,book_id,reader_id,library_id),
	foreign key (book_id) references book(book_id),
        foreign key (reader_id) references reader_details(reader_id),
	foreign key (library_id) references branches(library_id)
);


create table admin(
	admin_id int(11) unsigned not null,
	admin_password varchar(20) not null,
	primary key (admin_id)
);


