create user administrator createdb createrole;
create user application with password 'application';
comment on role application is 'Operational user for the application';
grant application to administrator;
create user reporter with password 'reporter';
comment on role reporter is 'Read only user for building reports';
grant reporter to administrator;

create database iron_octopus encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';


create database iron_octopus_test encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';
