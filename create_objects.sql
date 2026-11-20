-- Таблица, в которой перечисляются наблюдаемые таблицы
create table tables_for_watching (
  table_name varchar2(128) not null unique,
  enabled number(1) default 1 not null,
  enabled_after date,
  enabled_before date
);


-- Триггер для перевода имени таблицы в верхний регистра
create or replace trigger trg__tables_for_watching__before_insert
before insert on tables_for_watching
for each row
begin
  :new.table_name := upper(:new.table_name);
end;
/


-- Таблица с историей изменения количества строк в наблюдаемых таблицах
create table tables_watcher (
  date_time char(16) not null,
  table_name varchar2(128) not null,
  rows_count number
);
create unique index idx__tables_watcher__uniq on tables_watcher(date_time, table_name);


-- Хранимая процедура подсчёта количества строк
create or replace procedure counting as
begin
  for cursor1 in (
    select
      tfw.table_name,
      dt.now,
      'insert into tables_watcher (date_time, table_name, rows_count) select to_char(sysdate, ''YYYY-MM-DD HH24:MI''), ''' || tfw.table_name || ''', (select count(*) from ' || tfw.table_name || ') from dual' as query1
--      tfw.*
    from
      watcher.tables_for_watching tfw,
      (select sysdate as now from dual) dt
    where 
      tfw.enabled=1 and
      (tfw.enabled_after  is null or dt.now > tfw.enabled_after) and
      (tfw.enabled_before is null or dt.now < tfw.enabled_before) and
      1=1
    order by
      tfw.table_name
  ) loop
    execute immediate cursor1.query1;
    commit;
  end loop;
end;
/
