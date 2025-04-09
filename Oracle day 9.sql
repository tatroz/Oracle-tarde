--https://baseinfo.es/cursos/24029_oracle/alumno/ df5234sqQw ---SIN PACO
--https://computerhoy.20minutos.es/tutoriales/llevo-toda-vida-utilizando-windows-todavia-sigo-descubriendo-funciones-sorprendentes-1452360
--https://computerhoy.20minutos.es/tecnologia/26-cursos-gratis-inteligencia-artificial-no-te-puedes-perder-1442007

select * from user_tables; --me permite consultar a que tablas tengo el acceso

-------------DICCIONARIO DE DATOS------------------------------

/* Prefijos

USER_ - Los objetos del esquema (=usuario)
ALL_ - Los objetos del esquema /usuario y de otros esquemas en los que el usuario tiene algun privilegio
DBA_ - Todos los objetos de la instancia (esto solo lo puede hacer el administrador)

select * from dba_tables; --Error para un usuario no administrador
select * from all_tables;

select count (*) from dba_tables;

----Multitenant---

---en un entorno multitenant  hay un prefijo adicional

CBD_ -Todos losobjetos de todos los contenedores si la sesion esta en el contenedor: cbd$root
     Todos los objetos del contenedor en el que se encuentra la sesion, si es una PDB (Pluggable Database).
     PDBs es lo que utiliza el desarrollador
DBA_ - Todos los objetos del contenedor en el que se encuentra la sesion

Contenedor 1 > cdb$root
Contenedor 2 >pdb$seed
Contenedores 3+ > PDBs

*/

show con_id;
show pdbs;

select * from dictionary;
select * from dict;

select * from dict where table_name like '%IND%';

SELECT COUNT (*) FROM DICT;

--------------------TABLAS PRINCIPALES PARA CONSULTA/DESARROLLO--------------------------------------



/*
*_objects       - Todos los objetos
*_tables        - Tablas
*_tab_columns   -Lista de columnas
*_constraints   - Restricciones
*_cons_columns  - Columnas de las restricciones
*_views         - Vistas (no tienen subtablas)
*_index         - Indices
*_ind_columns   - Columnas de los indices
*_synonyms      - Sinónimos
*_sequences     - Secuencias
*_tab_comments   - Comentario de las tablas
*_col_comments   - Comentario de las columnas

*/
select * from user_objects; --es lo primero que hay que hacer para conocer que hay en mi esquema
select * from user_tables; --obtengo todas las tablas a las que tengo el acceso
select * from user_tab_columns; --obtengo las columnas de las tablas a las que tengo el acceso
select * from user_tab_columns where table_name= 'EMP' order by COLUMN_ID;
select * from user_constraints;
select * from user_constraints where table_name='EMP';
select * from user_cons_columns where table_name ='EMP';
select * from user_views;
select * from user_tab_comments;
select * from user_col_comments;

---v$: son las vistas-tablas especiales, estan en la memoria pero no estan almacenados en el disco
--son vistas de rendimiento
--cuando paramos la base de datos estas vistas se pierden

select * from v$session;
select * from v$instance;
select * from v$database;
select * from v$sql;

--Comentarios

create table t1(c1 number(3));
comment on table t1 is 'Es una tabla de prueba';
comment on column t1.c1 is 'Es la columna c1 de la tabla de prueba';

select * from user_tab_comments where table_name='T1';
select * from user_col_comments where table_name='T1';


-------------------------PRACTICA 12-1 (pag. 116 from D108644GC10_ag.pdf)-------------------------
 --1.Query the USER_TABLES data dictionary view to see information about the tables that you own.

 select  * from user_tables;

 --2. Query the ALL_TABLES data dictionary view to see information about all the tables that you
--can access. Exclude the tables that you own.


select table_name, owner
from all_tables
where owner <>'u18_ora21';


--3. For a specified table, create a script that reports the column names, data types, and data
--types’ lengths, as well as whether nulls are allowed. Prompt the user to enter the table
--name. Give appropriate aliases to the DATA_PRECISION and DATA_SCALE columns.
--Save this script in a file named lab_12_03.sql.


SELECT column_name, data_type, data_length,
 data_precision PRECISION, data_scale SCALE, nullable
FROM user_tab_columns
WHERE table_name = UPPER('&tab_name');

--4. Create a script that reports the column name, constraint name, constraint type, search
--condition, and status for a specified table. You must join the USER_CONSTRAINTS and
--USER_CONS_COLUMNS tables to obtain all this information. Prompt the user to enter the
--table name. Save the script in a file named lab_12_04.sql.

SELECT ucc.column_name, uc.constraint_name, uc.constraint_type,
 uc.search_condition, uc.status
FROM user_constraints uc JOIN user_cons_columns ucc
ON uc.table_name = ucc.table_name
AND uc.constraint_name = ucc.constraint_name
AND uc.table_name = UPPER('&tab_name'); 

--5. Add a comment to the DEPARTMENTS table. Then query the USER_TAB_COMMENTS view to
--verify that the comment is present.

COMMENT ON TABLE departments IS
 'Company department information including name, code, and
location.';
SELECT COMMENTS
FROM user_tab_comments
WHERE table_name = 'DEPARTMENTS';


--6. Run the lab_02_06_tab.sql script as a prerequisite for exercises 6 through 9.
--Alternatively, open the script file to copy the code and paste it into your SQL Worksheet.
--Then execute the script. This script:
--Drops the existing DEPT2 and EMP2 tables
-- Creates the DEPT2 and EMP2 tables 

--drops tables so that they cannot be restored
DROP TABLE EMP2 PURGE;
DROP TABLE dept2 PURGE;
--creates tables and adds constraints
CREATE TABLE dept2
       (id NUMBER(7),
        name VARCHAR2(25));
INSERT INTO dept2
      SELECT  department_id, department_name
      FROM    departments;
CREATE TABLE  emp2
  (id           NUMBER(7),
   last_name     VARCHAR2(25),
   first_name    VARCHAR2(25),
   dept_id       NUMBER(7));
ALTER TABLE emp2
      MODIFY (last_name   VARCHAR2(50));
ALTER TABLE    emp2
      ADD CONSTRAINT my_emp_id_pk PRIMARY KEY (id);
ALTER TABLE    dept2
     ADD CONSTRAINT my_dept_id_pk PRIMARY KEY(id);
ALTER TABLE emp2
      ADD CONSTRAINT my_emp_dept_id_fk
      FOREIGN KEY (dept_id) REFERENCES dept2(id);



--7. Confirm that both the DEPT2 and EMP2 tables are stored in the data dictionary.

select TABLE_NAME
from user_tables
where table_name in ('DEPT2', 'EMP2');


--8. Confirm that the constraints were added, by querying the USER_CONSTRAINTS view. Note
--the types and names of the constraints.

select constraint_name, constraint_type
from user_constraints
where table_name in ('DEPT2', 'EMP2');


--9. Display the object names and types from the USER_OBJECTS data dictionary view for the
--EMP2 and DEPT2 tables.

SELECT OBJECT_NAME, OBJECT_TYPE
FROM USER_OBJECTS
WHERE OBJECT_NAME IN('EMP2', 'DEPT2');

--OTRA MANERA
SELECT object_name, object_type
FROM user_objects
WHERE object_name= 'EMP2'
OR object_name= 'DEPT2';


---------------------------TEMA 13: SECUENCIAS, SINÓNIMOSE INDICES-------------------------------

-------SECUENCIAS---------

DROP TABLE E PURGE
CREATE TABLE E AS SELECT EMPLOYEE_ID, FIRST_NAME, SALARY, SALARY*12 AS ANN_SAL
FROM EMPLOYEES
WHERE EMPLOYEE_ID<>105;

SELECT * FROM E;

SELECT* FROM u00_ora2.e;

----ESQUEMAS/USUARIOS

---SECUENCIAS
--LA SECUENCIS NOS DA LOS NUMEROS SECUENCIALES

create sequence seq1;

select * from user_sequences; 