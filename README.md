# tables_watcher (oracle)

Подсчёт количества строк для списка наблюдаемых таблиц перечисленных в таблице tables_for_watching

Все файлы предназначены для СУБД Oracle

Имя наблюдаемой таблицы должно указываться в том виде, в котором эта таблица доступна пользователю выполняющему подсчёт (т.е. может потребоваться указание имени схемы).

Имена таблиц записываемые в tables_for_watching автоматически приводятся к верхнему регистру

Пример задания списка наблюдаемых таблиц:
```
insert into watcher.tables_for_watching (table_name) values ('shop.sales');
insert into watcher.tables_for_watching (table_name) values ('shop.clients');
insert into watcher.tables_for_watching (table_name) values ('shop.departments');
insert into watcher.tables_for_watching (table_name) values ('shop.employees');
```

Пример изменения списка наблюдаемых таблиц:
```
-- отключить наблюдение за таблицей
update watcher.tables_for_watching set enabled=0 where table_name = 'shop.departments';

-- выполнять наблюдение за таблицей только после наступления указанного времени
update watcher.tables_for_watching set enabled_after = to_date('2026-11-20 10:48:00', 'YYYY-MM-DD HH24:MI:SS') where table_name = 'shop.clients';
```

Для реализации периодического автоматического подсчёта строк, использовать внешний планировщик заданий, который вызывает файл сценария операционной системы с примерно таким содержимым (пример для unix):
```
#!/usr/bin/env sh

# установка переменных среды необходимых для подключения к СУБД
NLS_LANG=AMERICAN_AMERICA.UTF8; export NLS_LANG
ORACLE_HOME=/oracle/product/19.3; export ORACLE_HOME
PATH=$PATH:$ORACLE_HOME/bin; export PATH

# подключиться к СУБД и выполнить sql-файл
sqlplus watcher/Secret1@instance @home/oracle/scripts/tables_watcher/call_counting.sql
```

Где файл call_counting.sql вызывает хранимую процедуру "counting" выполняющую подсчёт строк таблиц перечисленных в таблице "tables_for_watching" и имеет следующее содержмиое:
```
exec counting();
exit;
```

Посмотреть хронологию изменения количества строк в одной из наблюдаемых таблиц можно следующим запросом:
```
select * from watcher.tables_watcher where table_name = 'имя_таблицы' order by date_time desc;
```
