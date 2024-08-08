create database keycloak;
create user keycloak_user with password 'password';
grant all privileges on database keycloak to keycloak_user;