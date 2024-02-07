create database library;
use library;


create table publisher(
PublisherName varchar(255) primary key ,
PublisherAddress varchar(255),
PublisherPhone varchar(255));

create table borrower(
CardNo int primary key auto_increment,
BorrowerName varchar(255),
BorrowerAddress varchar(255),
BorrowerPhone varchar(255))auto_increment=100;


create table library_branch(
BranchID int primary key auto_increment,
BranchName varchar(255),
BranchAddress varchar(255))auto_increment=1;


create table book(
BookID int primary key auto_increment,
Title varchar(255),
publisherName varchar(255),
foreign key (publisherName) references publisher(publisherName));


create table Authors(
AuthorID int primary key auto_increment,
BookID int,
foreign key (BookID) references book(BookID) ,
AuthorName varchar(255))auto_increment=1;

create table book_copies(
copiesID int primary key auto_increment,
BookID int,
foreign key (BookID) references book(BookID),
BranchID int,
foreign key (BranchID) references library_branch(BranchID),
No_Of_Copies int);

create table book_loans(
LoanID int primary key auto_increment,
BookID int,
foreign key (BookID) references book(BookID),
BranchID int,
foreign key (BranchID) references library_branch(BranchID),
CardNo int , 
foreign key (CardNo) references borrower(CardNo),
DateOut Date,
DueDate Date);


select * from publisher;
select * from borrower;
select * from library_branch;
select * from book;
select * from authors;
select * from book_copies;
select * from book_loans;








-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select bc.branchid,b.title,lb.branchname,sum(bc.No_of_copies) as copies
from book as b
join book_copies as bc
on b.bookid= bc.bookid
join library_branch as lb
on bc.branchid = lb.branchid
where title = "The Lost Tribe" and lb.BranchName= "sharpstown"
group by bc.branchid,b.title,lb.branchname,bc.No_of_copies;

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?
select bc.branchid,b.title,lb.branchname,sum(bc.No_of_copies) as copies
from book as b
join book_copies as bc
on b.bookid= bc.bookid
join library_branch as lb
on bc.branchid = lb.branchid
where title = "The Lost Tribe"
group by bc.branchid,b.title,lb.branchname,bc.No_of_copies;

-- 3. Retrieve the names of all borrowers who do not have any books checked out.
 select BorrowerName from borrower as b
left join book_loans as bl
on b.cardno= bl.cardno
where dateout is  null;
 
 
 
 
-- 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18,  retrieve the book title, the borrower's name, and the borrower's address. 
select Title,BorrowerName,BorrowerAddress from book_loans as bl
join book as bk
on bl.bookid = bk.bookid
join library_branch as lb
on bl.BranchID = lb.BranchID
join borrower as b
on bl.cardno= b.cardno
where bl.Duedate = "2018-03-02" and lb.branchname= "Sharpstown";

-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
select lb.branchname , count(*) as number_of_books from library_branch as lb
join book_loans as bl
on lb.branchid= bl.branchid
group by lb.branchname;




-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
with cte as 
(select br.BorrowerName,br.BorrowerAddress,count(*) as number_of_books from borrower as br
join book_loans as bl
on br.cardno= bl.cardno
group by br.BorrowerName,br.BorrowerAddress)
select * from cte
where cte.number_of_books>5
;



-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select b.title,No_Of_Copies from authors as a
join book_copies as bc
on a.bookid=bc.bookid
join book as b
on bc.bookid=b.bookid
join library_branch as lb
on bc.branchid=lb.branchid
where Authorname= "Stephen King" and lb.branchname="central";
