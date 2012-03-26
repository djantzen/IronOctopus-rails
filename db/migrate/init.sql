create user administrator createdb createrole with password 'administrator';
alter user administrator set timezone = 'UTC';

create user application with password 'application';
alter user application set timezone = 'UTC';
comment on role application is 'Operational user for the application';
grant application to administrator;

create user reporter with password 'reporter';
alter user reporter set timezone = 'UTC';
comment on role reporter is 'Read only user for building reports';
grant reporter to administrator;

create database iron_octopus encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';

create database iron_octopus_test encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';
