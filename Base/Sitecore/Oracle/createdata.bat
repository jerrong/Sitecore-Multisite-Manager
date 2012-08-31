SETLOCAL

if "%DATABASE%" == "" set DATABASE=%1
if "%PASSWORD%" == "" set PASSWORD=%2
if "%PREFIX%" == ""   set PREFIX=%3
if "%TBS%" == ""      set TBS=%4

if "%DATABASE%" == "" set DATABASE=sitecore
if "%PASSWORD%" == "" set PASSWORD=manager
if "%TBS%" == ""      set TBS=sitecore
if "%PREFIX%" == ""   set PREFIX=sc

sqlplus system/%PASSWORD%@%DATABASE% @createrole.sql
sqlplus system/%PASSWORD%@%DATABASE% @createuser.sql %PREFIX%core %TBS%
sqlplus system/%PASSWORD%@%DATABASE% @createuser.sql %PREFIX%master %TBS%
sqlplus system/%PASSWORD%@%DATABASE% @createuser.sql %PREFIX%web %TBS%

sqlplus %PREFIX%core/%PREFIX%core@%DATABASE% @security.sql %PREFIX%core %TBS%

sqlplus %PREFIX%core/%PREFIX%core@%DATABASE% @schema.sql %PREFIX%core %TBS%
sqlplus %PREFIX%master/%PREFIX%master@%DATABASE% @schema.sql %PREFIX%master %TBS%
sqlplus %PREFIX%web/%PREFIX%web@%DATABASE% @schema.sql %PREFIX%web %TBS%

imp system/%PASSWORD%@%DATABASE% fromuser=sccore touser=%PREFIX%core file=sitecore.dmp ignore=y log=%DATABASE%_%PREFIX%corelog.txt
imp system/%PASSWORD%@%DATABASE% fromuser=scmaster touser=%PREFIX%master file=sitecore.dmp ignore=y log=%DATABASE%_%PREFIX%masterlog.txt
imp system/%PASSWORD%@%DATABASE% fromuser=scweb touser=%PREFIX%web file=sitecore.dmp ignore=y log=%DATABASE%_%PREFIX%weblog.txt

ENDLOCAL
