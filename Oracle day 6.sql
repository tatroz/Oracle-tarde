
---------------------------RESTRICCIONES---------------------------------------
Inserta mas rápido que el resto de consultas, porque el motor de base
de datos
sabe que tiene que ejecutar un conjunto.
1) Insertar varios registros en una tabla que exista
SINTAXIS:
INSERT ALL
INTO TABLA VALUES (VALOR1, VALOR2)
INTO TABLA VALUES (VALOR1, VALOR2)
INTO TABLA (CAMPO1, CAMPO2) VALUES (VALOR1, VALOR2)
SELECT * FROM DUAL;--se utiliza para las pruebas

/*OTRA BASE DE DATOS 
select fecha actual --> devuelve la fecha actual
EN ORACLE
select fecha actual --> devuelve un error
select fecha actual from TABLE*/

Vamos a insertar dos departamentos en dept
insert all
    into DEPT values (50, 'ORACLE', 'BERNABEU')
    into DEPT values (60, 'I+D', 'ALICANTE')
SELECT * FROM DUAL;
SELECT * FROM DEPT;
ROLLBACK;

-------------INSERT ANSI SQL (MENOS RAPIDO)--------------------------------

insert into DEPT values ((select max(DEPT_NO) +1 from DEPT),'INTO', 'INTO');
insert into DEPT values ((select max(DEPT_NO) +1 from DEPT),'INTO2', 'INTO2');
insert into DEPT values ((select max(DEPT_NO) +1 from DEPT),'INTO3', 'INTO3');
ROLLBACK;

insert all
    into DEPT values ((select max(DEPT_NO) +1 from DEPT), 'ALL', 'ALL')
    into DEPT values ((select max(DEPT_NO) +1 from DEPT), 'ALL2', 'ALL2')
    into DEPT values ((select max(DEPT_NO) +1 from DEPT), 'ALL3', 'ALL3')
SELECT * FROM DUAL; ---EN ESTE CASO DEPT_NO SIEMPRE ES EL MISMO Y POR ELLO NO UTILIZAREMOS ESTE METODO PARA INSERTAR LOS DATOS
ROLLBACK;

describe DEPT;
create table DEPARTAMENTOS
as
select * from DEPT;

describe DEPARTAMENTOS;
select * from DEPARTAMENTOS;

select * from DEPT;
----------------TABLA CON REGISTROS DE VARIAS TABLAS Y DANDO ALISAS------------
create table DOCTORHOSPITAL
as
select DOCTOR.DOCTOR_NO as IDDOCTOR
, DOCTOR.APELLIDO, HOSPITAL.NOMBRE, HOSPITAL.TELEFONO
from DOCTOR
inner join HOSPITAL
on DOCTOR.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD;

select * from DOCTORHOSPITAL;

------------------------------------------------------------------------------
-----------------INSTRUCCION INSERT INTO SELECT------------------------------

---ESTA INSTRUCCION NOS PERMITE COPIAR DATOS DE UNA TABLA ORIGEN A UNA TABLA DESTINO.
--LA DIFERENCIA CON CREATE---SELECTESTÁ EN QUE LA TABLA DEBE DE EXISTIR
---SIN TABLA DE DESTINO NO PODEMOS EJECUTARESTA INSTRUCCIÓN.
--LA TABLA DE DESTINO TIENE QUE TENER LA MISMA ESTRUCTURA QUE LOS DATOS DEL SELECT DE ORIGEN.
--SINTAXIS:

insert into DESTINO
select * from ORIGEN;

--POR EJEMPLO, VAMOS A COPIAR LOS DATOS DE LA TABLA DEPT DENTRO DE LA TABLA DEPARTAMENTOS

insert into DEPARTAMENTOS 
select * from DEPT;

--------------VARIABLES DE SUSTITUCION-----------------------------------------
--CUANDO SE UTILIZA "&&" EL ENTORNO SOLO SOLICITALA VARIABLE UNAVEZ DURANTE UNA MISMA SESION

select APELLIDO, &&CAMPO1, SALARIO, COMISION, DEPT_NO
from EMP
where &CAMPO1='&DATO';

--EL VALOR DE CAMPO 1 LO PIDE UNA ÚNICAVEZ EN TODALA SESION

select APELLIDO, OFICIO, SALARIO, COMISION from EMP
where emp_no=&numero;

------------------NATURAL JOIN------------------------------------
--un natural jointoma las columnas de igual nombre entre dos tablas
--las utiliza para realizar un join
--el beneficio es que no hay que nombrar las columnas en el join

select apellido, loc from emp natural join dept;
select apellido, oficio, dnombre, loc, dept_no from emp natural join dept;
select * from emp natural join dept;


-------------------------USING--------------------------------------

--dice cual es el campo de coincidencia entre los dos

select apellido, loc, dnombre from emp inner join dept
using (dept_no);


-----------RECUPERACION JERARQUICA--------------------------------------------
--TENEMOS UN PRESIDENTE QUE ES EL JEFE DE LA EMPRESA: REY (7839)
--MOSTRAR TODOS LOS EMPLEADOS QUE TRABAJAN PARA REY DIRECTAMENTE

select * from EMP where DIR=7839;

--NECESITO SABER ÑOS EMPLEADOS QUETRABAJAN PARA NEGRO (7698)

select * from EMP where DIR=7698;

--LAS CONSULTAS DE RECUPERACION JERARQUICA

--MOSTRAMOS LOS EMPLEADOS SUBORDINADOS A PARTIR DEL DIRECTOR  JIMENEZ

select LEVEL as NIVEL, APELLIDO, DIR, OFICIO from EMP --LEVEL ES OPCIONAL
connect by prior EMP_NO=DIR
start with APELLIDO='jimenez'order by 1;

select LEVEL as NIVEL, APELLIDO, DIR, OFICIO from EMP --LEVEL ES OPCIONAL
connect by EMP_NO=prior DIR
start with APELLIDO='jimenez'order by 1;

--MANDAR EL LISTADO DE TODOS LOS JEFES DE ARROYOAREY

select LEVEL, APELLIDO, OFICIO from EMP
connect by EMP_NO=prior DIR
start with APELLIDO='arroyo';


----------------------SYS CONNECT BY PATH--------------------------------------

select LEVEL as NIVEL, APELLIDO, DIR, OFICIO--LEVEL ES OPCIONAL
, SYS_CONNECT_BY_PATH(apellido,'/') as RELACION
from EMP
connect by prior EMP_NO=DIR
start with APELLIDO='jimenez'order by 1;


--------------------OPERADORES DE CONJUNTOS------------------------------------

--INTERSEC: PERMITE REALIZAR LAS CONSULTAS ENTRE LAS TABLAS QUENO TIENEN NADA QUE VER ENTRE SI
--EJEMPLO: TABLA PLANTILLADE LOS PACIENTES QUE HAN PASADO VS PLANTILLA HISTORIAL DE LOS PACIENTES

--MINUS: COMBINA DOS CONSULTAS select DE FORMA QUE APARECERAN LOS REGISTROS DEL
--PRIMER SELECT QUE NO ESTEN PRESENTES EN EL SEGUNDO

select * from PLANTILLA where TURNO ='T'
MINUS
select * from PLANTILLA where FUNCION='ENFERMERA';

--------------------



