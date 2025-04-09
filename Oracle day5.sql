--MOSTRAR LAS CONSULTAS DE ACCION
--SON CONSULTAS PARA MODIFICAR LOS REGISTROS DE LA BASE DE DATOS
--EN ORACLE, LAS CONSULTAS DE ACCION SON TRANSACCIONALES
--SE ALMACENAN DE FORMA TEMPORAL POR SESION
--PARA DESHACER LOS CAMBIOS O PARA HACERLOS PERMANENTES TENEMOS DOS PALABRAS
--commit: HACE LOS CAMBIOS PERMANENETES
--rollback: DESHACE LOS CAMBIOS REALIZADOS
--1) INSERTO DOS REGISTROS NUEVOS
--2)COMMIT PERMANENTE
--3)INSERTO OTRO REGISTRO NUEVO (3)
--4) rollback: SOLAMENTE QUITA EL PUNTO 3
--TENEMOS 3 TIPOS DE CONSULTAS DE ACCION
--insert: Inserta un nuevo registro en la tabla
--update: Modifica uno o varios registros en la tabla
--delete: Elimina uno o varios registros en la tabla
------------------------------------------------------------------------------

    --INSERT
--CADA REGISTRO A INSERTAR ES UNA INSTRUCCION INSERT, ES DECIR, SI QUERMEOS
--INSERTAR 5 REGISTROS SON 5 INSERT
--TENEMOS DOS TIPOS DE SINTAXIS:
--1)INSERTAR TODOS LOS DATOS DE LA TABLA: Debemos indicar todas las columnas/campos
--del atabla y en el mismo orden que estén en la propia tabla.
--insert into TABLA values(valo1, valor2, valor3, valor4);

select * from DEPT;
insert into DEPT values (50, 'ORACLE', 'BERNABEU');
commit;
insert into DEPT values (51, 'BORRAR', 'BORRAR');
rollback; --nos permite eliminar la fila que acabamosde de insertar

--2)INSERTAR SOLAMENTE ALGUNOS DATOS DE LA TABLA: Debemos indicar el nombre de las columnas
--que deseamos insertar los valores irán en dicho orden, la tabla no tiene nada que ver.
--insert into TABLA(campo3, campo7) values (valor3,campo7);

--INSERTAR UN NUEVO DEPARTAMENTO EN ALMERIA, 
insert into DEPT(DEPT_NO, LOC) values(55, 'ALMERIA');
--insert into DEPT(LOC, DEPT_NO) values('ALMERIA', 55);
--LAS SUBCONSULTAS SON EVITABLES SI ESTAMOS EN CONSULTAS SELECT, PERO SON SUPER UTILES 
--SI ESTAMOS EN CONSULTAS DE ACCION
--NECESITO UN DEPARTAMENTO DE SIDRA EN GIJON
--GENERAR EL SIGUIENTE NUMERO DISPONIBLE EN LA CONSULTA DE ACCION

select max(DEPT_NO) from DEPT; -- PARA SABER EL NUMERO MAX QUE TENGO EN LA TABLA
select max(DEPT_NO)+1 from DEPT;
insert into DEPT values ((select max(DEPT_NO)+1 from DEPT), 'SIDRA', 'GIJON');
rollback;

        --DELETE
--ELIMINA UNA O VARIAS FILAS DE UNA TABLA. SI NO EXISTE NADA PARA ELIMINAR, NO HACE NADA
--SINTAXIS:
--delete from TABLA
--LA SINTAXIS ANTERIOR ELIMINA TODOS LOS REGISTROS DE LA TABLA
--OPCIONAL, INCLUIR WHERE
--ELIMINAR EL DEPARTAMENTO DE ORACLE

delete from DEPT where DNOMBRE='ORACLE';
rollback;
select * from DEPT;

--MUY UTIL UTILIZAR SUBCONSULTAS PARA DELETE
--ELIMINAR TODOS LOS EMPLEADOS DE GRANADA

delete from EMP where DEPT_NO=40;
delete from DEPT where DEPT_NO=
(select DEPT_NO from DEPT where LOC='GRANADA');
rollback;
delete from EMP where DEPT_NO=
(select DEPT_NO from DEPT where LOC='GRANADA');

        --UPDATE
--MODIFICA UNA O VARIAS FILAS  DE UNA TABLA. PUEDE MODIFICAR VARIAS COLUMNAS
--A LA VEZ

--update TABLA set CAMPO1=VALOR1, CAMPO2=VALOR2
--ESTA CONSULTA MODIFICA TODAS LAS FILAS DE LA TABLA
--ES CONVENIENTE UTILIZAR UN WHERE, SI LO QUEREMOS
--MODIFICAR EL SALARIO DE LA PLANTILLA DEL TURNO DE NOCHE, TODOS COBRARAN 315000

update PLANTILLA set SALARIO=315000 where TURNO='N';

--PODEMOS MODIFICAR MÁS DE UN CAMPO A LA VEZ
--MODIFICAR LA CIUDAD Y EL NOMBRE DEL DEPARTAMENTO 10.
--SE LLAMARA CUENTAS Y NOS VAMOS A TOLEDO

update DEPT set LOC='TOLEDO', DNOMBRE='CUENTAS'
where DEPT_NO=10;

--PODEMOS MANTANER EL VALOR DE UNA COLUMNA Y ASIGNAR "ALGO" CON OPERACIONES
--MATEMATICAS
--INCREMENTAR EN 1 EL SALARIO DE TODOS LOS EMPLEADOS

update EMP set SALARIO=SALARIO+1;
select * from EMP;

--PODEMOS UTILIZAR SUBCONSULTAS EN UPDATE
--1) SI LAS SUBCONSULTAS ESTAN EN EL SET, SOLAMENTE DEBEN DEVOLVER UN DATO

select * from EMP;

--PONER EL MISMO SALARIO A ARROYO QUE SALA

update EMP set SALARIO = (select SALARIO from EMP where APELLIDO='sala') 
where APELLIDO='arroyo';

--BAJAR EL SUELDO DE LOS CATALANES A LA MITAD
--PONER A LA MITADEL SALARIO DE LOS EMPLEADOS DE BARCELONA

update EMP set SALARIO=SALARIO/2
where DEPT_NO=(select DEPT_NO from DEPT where LOC='BARCELONA');
rollback;


---------------------PRACTIA 4-------------------------------------------------

--1.Dar de alta con fecha actual al empleado José Escriche Barrera como programador perteneciente al departamento de producción
--Tendrá un salario base de 70000 pts/mes y no cobrar á comisión.

SELECT * FROM EMP;
insert into EMP (EMP_NO, APELLIDO, OFICIO, SALARIO, FECHA_ALT) values((select max(EMP_NO)+1 from EMP), 'escriche', 'PROGRAMADOR', 70000, '31/03/2025');

--2.Se quiere dar ;de alta un departamento de informática situado en Fuenlabrada (Madrid).

SELECT * FROM DEPT;
insert into DEPT (DEPT_NO, DNOMBRE, LOC) values(60, 'INFORMATICA', 'FUENLABRADA');
--3.El departamento de ventas ,por motivos peseteros, se traslada a Teruel, realizar dicha modificación.

update DEPT set LOC = 'TERUEL' where DNOMBRE= 'VENTAS';

--4.En el departamento anterior(ventas),se dan de alta dos empleados: JuliánRomeral y LuisAlonso. Su salario base es el menor que cobre un empleado, 
--y cobrarán una comisión del 15% de dicho salario.
select * from EMP;
insert into EMP(EMP_NO, APELLIDO, SALARIO, OFICIO, COMISION) VALUES ((select max(EMP_NO)+1 from EMP), 'romeral', 
(select min(SALARIO) from EMP), 'VENDEDOR', (select min(SALARIO)*0.15 from EMP));

5.Modificar la comisión de los empleados de la empresa, de forma que todos tengan un incremento del 10% del salario.

update EMP set COMISION = COMISION+SALARIO*0.1;

select * from EMP;

--6.Incrementar un 5% el salario de los interinos de la plantilla que trabajen en el turno de noche.

select * from PLANTILLA;
update PLANTILLA set SALARIO= SALARIO*1.05 where FUNCION='INTERINO' AND TURNO='N';
rollback;

--7.Incrementar en 5000 Pts. el salario de los empleados del departamento de ventas y del presidente, tomando en cuenta los que
--se dieron de alta antes que el presidente de la empresa.

SELECT * FROM EMP;
update EMP set SALARIO= SALARIO+500 where OFICIO='PRESIDENTE' and OFICIO='VENDEDOR' 
and FECHA_ALT <(select FECHA_ALT from EMP where OFICIO='PRESIDENTE');

--8.El empleado Sanchez ha pasado por la derecha a un compañero. Debe cobrar de comisión 12.000 ptas más que el empleado Arroyo y su sueldo se
--ha incrementado un 10% respecto a su compañero.

update EMP set COMISION= (select COMISION from EMP where APELLIDO='arroyo')+12000
,SALARIO = (select SALARIO from EMP where APELLIDO='arroyo')*1.1 where APELLIDO='sanchez';
rollback;

--9.Se tienen que desplazar cien camas del Hospital SAN CARLOS para un
--Hospital de Venezuela. Actualizar el número de camas del Hospital SAN CARLOS.
SELECT * FROM HOSPITAL;

update HOSPITAL set NUM_CAMA= NUM_CAMA-100 where NOMBRE='san carlos';
rollback;

--10.Subir el salario y la comisión en 100000 pesetas y veinticinco mil pesetas 
--respectivamente a los empleados que se dieron de alta en este año.

select * from EMP;
update EMP set SALARIO = SALARIO+100000, COMISION = COMISION+25000 where FECHA_ALT between '01/01/2025' and '31/12/2025';
rollback;

--11.Ha llegado un nuevo doctor a la Paz. Su apellido es House y su especialidad es Diagnostico. 
--Introducir el siguiente número de doctor disponible.

select * from DOCTOR;
select * from HOSPITAL;
insert into DOCTOR(DOCTOR_NO, APELLIDO, ESPECIALIDAD,HOSPITAL_COD) values ((select max(DOCTOR_NO)+1 from DOCTOR), 'HOUSE', 'Diagnostico', 
(select HOSPITAL_COD from HOSPITAL where NOMBRE='la paz'));
rollback;
12.
Borrar todos los empleados dados de alta entre las fechas 01/01/80 y
31/12/82.

delete from EMP where FECHA_ALT between '01/01/1980' and '31/12/1982';
select * from EMP;

13.Modificar el salario de los empleados trabajen en la paz y estén destinados a
Psiquiatría. Subirles el sueldo 20000 Ptas. más que al señor Amigo R.

update DOCTOR set SALARIO=SALARIO+20000 
where HOSPITAL_COD=(select HOSPITAL_COD from HOSPITAL where NOMBRE='la paz') and ESPECIALIDAD='Psiquiatria';

SELECT * FROM DOCTOR;

14.Insertar un empleado con valores null (por ejemplo la comisión o el oficio), y
después borrarlo buscando como valor dicho valor null creado.

insert into EMP(EMP_NO, APELLIDO, OFICIO) values((select max(EMP_NO)+1 from EMP), 'garcia', 'SUBDIRECTOR'); 
select * from EMP;
delete from EMP where COMISION=(null);

15.Borrar los empleados cuyo nombre de departamento sea producción.

delete from EMP where DEPT_NO=(select DEPT_NO from DEPT where DNOMBRE='PRODUCCION');
SELECT * FROM DEPT;
select * from EMP;
16.Borrar todos los registros de la tabla Emp sin delete

drop table EMP;






