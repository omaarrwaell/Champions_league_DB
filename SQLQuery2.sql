create database Champions_league_DB;
go;


create procedure createAllTables as

create table System_User1 ( username varchar(20), password varchar(20) , primary key (username))
create table Fan (national_ID int, name varchar(20), birth_date DATE, address varchar(20), phone_no int, staus bit, username varchar(20), primary key (national_id), foreign key(username) references System_User1(username) )
create table Stadium (ID int identity, name varchar(20), location varchar(20), capacity int, status bit , primary key (ID) )
create table Stadium_Manager(ID int identity , name varchar(20), stadium_ID int, username varchar(20), primary key (ID) , foreign key (stadium_ID) references Stadium (ID) , foreign key (username) references System_User1(username) )
create table Club_Representative(ID   int identity, name varchar(20), club_ID int, username varchar(20), primary key (ID) ,foreign key (username) references System_User1 (username) )
create table Sports_association_manager(ID int identity, name varchar(20), username varchar(20) )
create table System_Admin(ID int identity, name varchar(20), username varchar(20) , primary key (ID) ,foreign key (username) references System_User1 (username))


create table Host_Request (ID int identity,  representative_ID int, manager_ID int, status varchar(20) ,primary key (ID) , foreign key (representative_ID) references club_Representative (ID) , foreign key (manager_ID) references Stadium_Manager (ID) )
create table Club (club_ID int identity, name varchar(20), location varchar(20),primary key (club_ID))
create table Match(match_ID int, start_time datetime, end_time datetime, host_club_ID int, guest_club_ID int, stadium_ID int , primary key (match_ID) , foreign key (host_club_ID) references club(ID) ,foreign key (stadium_ID) references club (ID) )
create table Ticket (ID int identity , status bit, match_ID int, primary key (ID) , foreign key (match_ID)references Match(ID))
create table Ticket_Buying_Transactions (fan_national_ID int, ticket_ID int ,foreign key (fan_national_ID )references Fan(national_ID) , foreign key (ticket_ID) references ticket (ID))

go;
exec  createAlltables ;
go ;
create procedure dropAllTables
as
drop table System_User1
drop table Fan
drop table Stadium_Manager
drop table Club_Representative
drop table Sports_association_manager
drop table System_Admin
drop table Ticket_Buying_Transactions
drop table Stadium
drop table Host_Request
drop table Club
drop table Ticket
drop table Match
go;

create view allAssocManagers
as
select username, name from Sports_association_manager 
go;
create view allClubRepresentatives
AS
select username, name from Club_Representative
go;
create view allStadiumManagers
AS
select name, username, stadium_ID <<<
from Stadium_Manager
go;
create view allFans
AS
select name, national_ID, birth_date, status 
from Fan
go;
create view allMatches 
AS
select host_club_id, guest_club_id, stadium_id, TIME
from MATCH
go;
create view allClubs 
AS
select name, LOCATION
from Club
go;
create view allStadiums
as 
select name, location, capacity, status
from Stadium
go;
create view allRequests
as
select represntative_ID, manag_ID, status
from Host_Request<<
go;
