---------------------------TEMA 13: SECUENCIAS, SINÓNIMOSE INDICES-------------------------------

-- TEMA 13. SECUENCIAS, SINÓNIMOS E ÍNDICES
-- SECUENCIAS


u00_ora21;

drop table e purge;
create table e as select employee_id, first_name, salary, salary*12 as ann_sal
from   employees
where  employee_id < 105;

select * from e;

select * from u00_ora21.e;

grant select on e to
u01_ora21,
u02_ora21,
u03_ora21,
u04_ora21,
u05_ora21,
u06_ora21,
u07_ora21,
u08_ora21,
u09_ora21,
u10_ora21,
u11_ora21,
u12_ora21,
u13_ora21,
u14_ora21,
u15_ora21,
u16_ora21,
u17_ora21,
u18_ora21,
u19_ora21,
u20_ora21;



-- ESQUEMAS/USUARIOS
-- Como SYSDBA
select * from dba_users;


select * from user_objects;



-- SECUENCIAS
create sequence seq1;

select * from user_sequences;

select seq1.nextval from dual;

select * from e;
insert into e values (seq1.nextval, 'fn', 1, 1);
insert into e values (seq1.nextval, 'fn2', 2, 2);
select * from e;
rollback;
select * from e;
  -- Filas nuevas desaparecen
insert into e values (seq1.nextval, 'fn', 1, 1);
select * from e;
  -- La secuencia no hace "rollback"
  
-- Se puede usar como valor por defecto de una columna de una tabla
drop sequence seq1;
create sequence seq1;

create table t1 (id number(3) default seq1.nextval, nombre varchar2(100));

insert into t1 (nombre) values ('Nombre 1');
insert into t1 (nombre) values ('Nombre 2');
select * from t1;

insert into t1 (id, nombre) values (4, 'Nombre 3');
select * from t1;
insert into t1 (nombre) values ('Nombre 4');
select * from t1;

insert into t1 (nombre) values ('Nombre 5');
select * from t1;
  -- Hay dos "cuatro"
  
  
drop sequence seq1;
create sequence seq1;
drop table t1 purge;
create table t1 (id number(3) default seq1.nextval primary key, nombre varchar2(100));

insert into t1 (nombre) values ('Nombre 1');
insert into t1 (nombre) values ('Nombre 2');
select * from t1;

insert into t1 (id, nombre) values (4, 'Nombre 3');
select * from t1;
insert into t1 (nombre) values ('Nombre 4');
select * from t1;

insert into t1 (nombre) values ('Nombre 5');
--select * from t1;
  -- Hay dos "cuatro"  
  

-- 
--select * from user_sequences
9999999999999999999999999999;

--



-- SINÓNIMOS

select * from u00_ora21.e;

create synonym te for u00_ora21.e;

select * from te;



create table d as select * from departments where department_id < 50;

select * from d;

create public synonym td for d;

select * from td;

--
select * from user_synonyms;

select * from all_synonyms;

select * from all_synonyms where synonym_name like '%DUAL%';
  -- dual -> sys.dual
  
select * from sys.dual;



select * from user_synonyms;
  -- aunque indique table_name, los sinónimos también se pueden hacer para
  -- vistas, etc.
  



-- ÍNDICES

select * from user_indexes;
select * from user_ind_columns;

-- ROWID


/*

TABLESPACE
DATAFILES
SEGMENTS   - El nombre de espacio que ocupa un objeto
EXTENTS    - Un conjunto de bloques contiguos en un data file
BLOCK      - Mínima unidad de almacenamiento

*/

select * from user_tables;


select rowid, employee_id, first_name
from   employees;
  -- rowid no existe en la tabla, se genera en tiempo de consulta
  -- ROWID: Primeros 15 caracteres -> data file y número de bloque
  --        Posición de la fila dentro del bloque
  
  
  