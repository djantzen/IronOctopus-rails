create user administrator createdb createrole with password 'administrator';
alter user administrator set timezone = 'UTC';

create role writer;
create role reader;
grant writer to administrator;
grant reader to administrator;
comment on role writer is 'Role that can delete, insert, update.';
comment on role reader is 'Role that can select.';

create role application with password 'application' login in role reader, writer;
alter role application set timezone = 'UTC';
comment on role application is 'Operational user for the application';

create role reporter with password 'reporter' login in role reader;
alter role reporter set timezone = 'UTC';
comment on role reporter is 'Read only user for building reports';

create database iron_octopus encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';

create database iron_octopus_test encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';
