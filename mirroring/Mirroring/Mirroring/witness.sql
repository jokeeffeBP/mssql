USE [master];
 
---------------- T H I S   I S    O N   T H E    W I T N E S S   S E R V E R
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<password>';
GO
 
CREATE CERTIFICATE HOST_W_cert
   WITH SUBJECT = 'HOST_W certificate for database mirroring',
   EXPIRY_DATE = '01/01/2016';
Go
 
CREATE ENDPOINT [Mirroring]
    STATE=STARTED
    AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
    FOR DATA_MIRRORING (ROLE = all, AUTHENTICATION = certificate HOST_W_cert
, ENCRYPTION = REQUIRED ALGORITHM AES)
GO
backup certificate HOST_W_cert to file = 'z:\temp\HOST_W_cert.cer';
go
----On HOST W - the witness server
USE master;
--On HOST_W, create a login for HOST_A.
CREATE LOGIN HOST_A_login WITH PASSWORD = '<password>';
GO
--Create a user, HOST_A_user, for that login.
CREATE USER HOST_A_user FOR LOGIN HOST_A_login
GO
--Obtain HOST_A certificate. (See the note
--   preceding this example.)
--Asscociate this certificate with the user, HOST_A_user.
CREATE CERTIFICATE HOST_A_cert
   AUTHORIZATION HOST_A_user
   FROM FILE = 'z:\temp\HOST_A_cert.cer';
GO
--Grant CONNECT permission for the server instance on HOST_A.
GRANT CONNECT ON ENDPOINT::Mirroring TO HOST_A_login
GO
--On HOST_W, create a login for HOST_B.
CREATE LOGIN HOST_B_login WITH PASSWORD = '<password>';
GO
--Create a user, HOST_B_user, for that login.
CREATE USER HOST_B_user FOR LOGIN HOST_B_login
GO
--Obtain HOST_B certificate. (See the note
--   preceding this example.)
--Asscociate this certificate with the user, HOST_B_user.
CREATE CERTIFICATE HOST_B_cert
   AUTHORIZATION HOST_B_user
   FROM FILE = 'z:\temp\HOST_B_cert.cer';
GO
--Grant CONNECT permission for the server instance on HOST_A.
GRANT CONNECT ON ENDPOINT::Mirroring TO HOST_B_login
GO
 
-- if the logins get created wrong
--drop login HOST_A_login
--drop user HOST_A_user
--drop certificate HOST_A_cert
--drop login HOST_B_login
--drop user HOST_B_user
--drop certificate HOST_B_cert