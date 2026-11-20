#!/usr/bin/sh

cd /lnk/tc_backup/scripts/watcher

#NLS_LANG=AMERICAN_AMERICA.CL8MSWIN1251; export NLS_LANG
NLS_LANG=AMERICAN_AMERICA.UTF8; export NLS_LANG

ORACLE_HOME=/oracle/product/19.3; export ORACLE_HOME
PATH=$PATH:$ORACLE_HOME/bin; export PATH

sqlplus watcher/Secret1@instance @call_counting.sql
