USE [master];
 
------------ T H I S    I S    T H E     A C T I V E     S E R V E R
 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '<password>';
GO
 
-------------------------------------------------------------------------------------------------
CREATE CERTIFICATE HOST_A_cert
   WITH SUBJECT = 'HOST_A certificate for database mirroring',
   EXPIRY_DATE = '01/01/2016';
GO
 
CREATE ENDPOINT [Mirroring]
    STATE=STARTED
    AS TCP (LISTENER_PORT = 5022, LISTENER_IP = ALL)
    FOR DATA_MIRRORING (ROLE = all, AUTHENTICATION = certificate HOST_A_cert
, ENCRYPTION = REQUIRED ALGORITHM AES)
GO
backup certificate HOST_A_cert to file = 'z:\temp\HOST_A_cert.cer';
go
 
----On HOST A - the active server
USE master;
--On HOST_A, create a login for HOST_B.
CREATE LOGIN HOST_B_login WITH PASSWORD = '<password>';
GO
--Create a user, HOST_B_user, for that login.
CREATE USER HOST_B_user FOR LOGIN HOST_B_login
GO
--Obtain HOST_B certificate. (See the note
--   preceding this example.)
-- Asscociate this certificate with the user, HOST_B_user.
CREATE CERTIFICATE HOST_B_cert
   AUTHORIZATION HOST_B_user
   FROM FILE = 'z:\temp\HOST_B_cert.cer';
GO
--Grant CONNECT permission for the server instance on HOST_A.
GRANT CONNECT ON ENDPOINT::Mirroring TO HOST_B_login
GO
--On HOST_A, create a login for HOST_W.
CREATE LOGIN HOST_W_login WITH PASSWORD = '<password>';
GO
--Create a user, HOST_W_user, for that login.
CREATE USER HOST_W_user FOR LOGIN HOST_W_login
GO
--Obtain HOST_W certificate. (See the note
--   preceding this example.)
--Asscociate this certificate with the user, HOST_W_user.
CREATE CERTIFICATE HOST_W_cert
   AUTHORIZATION HOST_W_user
   FROM FILE = 'z:\temp\HOST_W_cert.cer';
GO
--Grant CONNECT permission for the server instance on HOST_A.
GRANT CONNECT ON ENDPOINT::Mirroring TO HOST_W_login
GO