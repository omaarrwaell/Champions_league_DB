
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
stadium_ID int , primary key (match_ID) , foreign key (host_club_ID) references club(club_ID) ,
foreign key (stadium_ID) references Stadium (ID) , foreign key (guest_club_ID)references club (club_ID) )

create table Ticket (ID int identity , status bit, match_ID int, primary key (ID) ,
foreign key (match_ID)references Match(match_ID))

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

declare @idh int
select @idh = club_id from club where name =@host_club_name
--exec @idh = dbo.retId @host_club_name

declare @idg int 
select @idg = club_id from club where name =@guest_club_name
--exec @idg = dbo.retId @guest_club_name

insert into match values (@start_time,@end_time,@idh,@idg,null)

go;
drop proc addNewMatch
exec addNewMatch 'barca' ,'real' ,null,null ;
select * from club;
select * from match;
declare @id int 
select @id =club_id from club where name = 'ahly'
print @id
go;

create function [retId](@name varchar(20))
returns int 
as 
begin
declare @id int 

select @id= club_id 
from club 
where name = @name
 
return @id
end

go;
declare @res int
exec @res = dbo.retId 'zamalek' 
select @res as id
go;

create proc deleteMatch @hostclub varchar(20) , @guestclub varchar(20) 
as 
delete from match where match.host_club_id = dbo.retId(@hostclub) and match.guest_club_ID =dbo.retId(@guestclub)

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

create proc deleteMatchesOnStadium @sname varchar(20) 
as
declare @id int 

select @id = id from Stadium where @sname = name 

delete from match  where match.stadium_Id = @id and match.start_date > CURRENT_TIMESTAMP



go;

create proc addClub @name varchar(20) , @location varchar(20) 
as 
insert into club values (@name,@location)

go;

create proc addTicket @hostClub varchar(20) , @guestclub varchar(20) , @starttime datetime 
as
declare @matId int 
exec @matid = dbo.retmatid @hostClub ,@guestclub , @starttime


insert into Ticket values (null,@matid)


go;
create function [retmatid] (@hostclub varchar(20) , @guestclub varchar(20) , @startime datetime )
returns int 
begin 
declare @matId int
select @matid = m.match_ID
from match m
where m.host_club_ID = (select c.club_ID
from club c where c.name= @hostclub) 
and m.guest_club_ID =
(select c1.club_ID from club c1 where c1.name = @guestclub)
and m.start_time = @startime
return @matId
end
go;
drop function  dbo.retmatid
drop proc addTicket
go;

create proc deleteClub @name varchar(20)
as 
delete from club where name =  @name 
go;

create proc  addStadium @name varchar(20) , @location varchar(20) , @capacity int 
as 
insert into Stadium values (@name, @location ,@capacity , null)
go;

create proc deleteStadium @name varchar(20)
as 
delete from Stadium where name = @name 

go;
create proc blockFan @id varchar(20)
as 
update fan set staus= 0 where national_ID=@id 
go;
create proc unblockFan @id varchar(20)
as 
update fan set staus= 1 where national_ID=@id 
go;
create proc addRepresentative @name varchar(20) , 
@clubname varchar(20) , @username varchar(20), @password varchar(20)
as
declare @id int 
exec @id = dbo.retId @clubname 
insert into System_User2 values (@username,@password)
insert into Club_Representative values (@name,@id,@username)

go;

create function[viewAvailableStadiumsOn]( @date datetime )
returns @T table (name varchar(20) , location varchar(20) , capacity int
)
as
begin
--declare @name varchar(20),@location varchar(20),@capacity int
insert into @T
select s.name, s.location, s.capacity
from stadium  s ,match m
where s.status=1 and m.stadium_ID = s.ID and m.start_time <> @date 

return
end 

go;
alter table host_request 
alter column status varchar(20)
go;
create proc addHostRequest @clubname varchar(20) ,@stadiumname varchar(20) , @starttime datetime
as

declare @repid int , @manid int ,@matid int
exec @repid = dbo.getrepid @clubname 

exec @manid= dbo.getmanid @stadiumname 

exec @matid = dbo.retmatid @clubname ,null ,@starttime



go;
create function [getmanid](@stadiumname varchar(20) )
returns int 
begin 
declare @ids int 
select @ids = id from stadium where name =@stadiumname 

declare @manid int
select @manid=id from Stadium_Manager where stadium_ID=@ids
return @manid
end


go;
create function [getrepid] (@clubname varchar(20))
returns int 
begin 
declare @idclub int

exec @idclub=dbo.retId @clubname

declare @id int
 select @id = id from Club_Representative where club_ID=@idclub


return @id

end

go;
create function [allUnassignedMatches ](@clubname varchar(20))
returns @T table (
guest_club varchar(20), start_time datetime )
as 
begin 
declare @id int
exec @id =  dbo.retId @clubname  
insert into @T 
select c.name , m.start_time
from club c , match m
where c.club_id = m.guest_club_ID and m.host_club_ID = @id  
and m.start_time = 
(select m1.start_time from match m1 where m1.host_club_ID =@id 
and c.club_ID = m1.guest_club_ID) and m.stadium_ID is null
return
end
go;
drop function [allUnassignedMatches ];
go;
create function [allPendingRequests] (@username varchar(20))
returns @T table(
club_rep_name varchar(20) , guest_club varchar(20) ,start_time datetime)
as 
begin 
declare @stdid int
select @stdid = id from Stadium_Manager where username=@username
insert into @T 
select cr.name , c.name , m.start_time 
from Club_Representative cr , club c , match m , Host_Request hr
where hr.manager_ID=@stdid and 
hr.representative_ID = cr.ID and hr.match_id =m.match_ID 
return 
end 
