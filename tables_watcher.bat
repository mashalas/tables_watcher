echo off
cls

set db_user=watcher
set password=Secret1
set db_name=instance

set NLS_LANG=AMERICAN_AMERICA.RU8PC866

sqlplus %db_user%/%password%@%db_name% @call_counting.sql

pause
