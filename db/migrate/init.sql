create user administrator createdb createrole;
create database iron_octopus encoding='UTF8' owner = administrator;
alter database iron_octopus set timezone = 'UTC';