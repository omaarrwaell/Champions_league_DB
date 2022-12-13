create database Champions_league_Db1;
go;
drop database Champions_league_Db1;
go;

create procedure createAllTables as

create table System_User2 ( username varchar(20), password varchar(20) , primary key (username))

create table Fan (national_ID int, name varchar(20), birth_date DATE, address varchar(20), 
phone_no int, staus bit, username varchar(20), 
primary key (national_id), 
foreign key(username) references System_User2(username) )

create table Stadium (ID int identity, name varchar(20), location varchar(20), capacity int,
status bit , primary key (ID) )

create table Stadium_Manager(ID int identity , name varchar(20), stadium_ID int, username varchar(20),
primary key (ID) , foreign key (stadium_ID) references Stadium (ID) ,
foreign key (username) references System_User2(username) )

create table Club_Representative(ID   int identity, name varchar(20), club_ID int, username varchar(20)
, primary key (ID) ,foreign key (username) references System_User2 (username) )

create table Sports_association_manager(ID int identity, name varchar(20), username varchar(20) ,primary key(ID) , foreign key(username) references System_User2(username))

create table System_Admin(ID int identity, name varchar(20), username varchar(20)
, primary key (ID) ,foreign key (username) references System_User2 (username))


create table Host_Request (ID int identity,  representative_ID int, manager_ID int, status varchar(20) 
,primary key (ID) , foreign key (representative_ID) references club_Representative (ID) ,
foreign key (manager_ID) references Stadium_Manager (ID) )

create table Club (club_ID int identity, name varchar(20), location varchar(20),primary key (club_ID))

create table Match(match_ID int identity , start_time datetime, end_time datetime , host_club_ID int, guest_club_ID int, 
stadium_ID int , primary key (match_ID) , foreign key (host_club_ID) references club(ID) ,
foreign key (stadium_ID) references Stadium (ID) , foreign key (guest_club_ID)references club (ID) )

create table Ticket (ID int identity , status bit, match_ID int, primary key (ID) ,
foreign key (match_ID)references Match(ID))

create table Ticket_Buying_Transactions (fan_national_ID int, ticket_ID int 
,foreign key (fan_national_ID )references Fan(national_ID) , foreign key (ticket_ID) references ticket (ID))


go;
exec  createAllTables ;
go ;
drop proc createAllTables;
go;
create procedure dropAllTables
as
drop table System_User2
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
exec dropAllTables;
go;

create procedure clearAllTables 
as
truncate table System_User2
truncate table Fan
truncate table Stadium_Manager
truncate table Club_Representative
truncate table Sports_association_manager
truncate table System_Admin
truncate table Ticket_Buying_Transactions
truncate table Stadium
truncate table Host_Request
truncate table Club
truncate table Ticket
truncate table Match

go;
create view allAssocManagers
as
select s.username, su.password, s.name 
from Sports_association_manager s , System_User2  su
where s.username = su.username

go;

create view allClubRepresentatives
AS
select cr.username,su.password , cr.name , c.name 
from Club_Representative cr ,  System_User2  su ,club c
where cr.username = su.username and cr.club_ID = c.ID 





go;

create view allStadiumManagers
AS
select  sm.username, su.password, sm.name, s.name
from Stadium_Manager sm , System_User2  su , Stadium s 
where sm.username = su.username and s.ID = sm.Stadium_ID

go;

create view allFans
AS
select f.username , su.password , f.name , f.national_ID , f.birth_date, f.status
from Fan f , System_User2  su 
where f.username= su.username 

go;

create view allMatches 
AS
select c.name , c2.name  ,m.start_time 
from MATCH m , club c ,club c2 
where m.host_club_ID = c.club_ID and 
m.guest_club_ID = c2.club_ID 


go;
create view allTickets
AS
select c.name ,c2.name ,s.name ,m.start_time
from match m , club c, club c2 ,stadium s 
where m.stadium_ID =s.ID 
and m.host_club_ID = c.club_ID and 
m.guest_club_ID = c2.club_ID 
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
select cr.username ,sm.username , h.status
from Host_Request h , Club_Representative cr , Stadium_Manager sm
where h.representative_ID = cr . ID and h.manager_ID = sm.ID

go;

create procedure addAssociationManager
@name varchar(20),@username varchar(20) , @password varchar(20)
as 
insert into System_Useer1 values (@username ,  @password ) 
insert into Sports_association_manager values (@name , @username)

go;
create procedure addNewMatch 
@host_club_name varchar(20) , @guest_club_name varchar(20),@start_time datetime ,@end_time datetime 
as
insert into club (name) values (@host_club_name),(@guest_club_name)
declare @id1 int 
select @id1 =id 
from club 
where name = @host_club_name 

insert into match values (@start_time,@end_time,dbo.retId(@host_club_name),dbo.retId(@guest_club_name))

go;
create function [retId](@name varchar(20))
returns int 
as 
begin
declare @id int 

select @id= id 
from club 
where name = @name
 
return @id
end

go;

create view clubsWithNoMatches
as
select c.name 
from club c
where c.club_ID  not in ((select host_club_ID from match ) 
union 
(select guest_club_ID from match)
)



go;