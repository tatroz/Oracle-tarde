7.
select count(*) as TRABAJADORES FUNCTION
from PLANTILLA
group by FUNCION
having FUNCION in ('ENFERMERO', 'ENFERMERA', 'INTERINO');

8.

select DEPT_NO, OFICIO, count(*) as PERSONAS
from EMP
group by DEPT_NO, OFICIO
having count(*)>=2;

10.

select avg(NUM_CAMA) as MEDIA_CAMAS, count(*) as NUMERO, NOMBRE
from SALA
group by NOMBRE;

11.

select FUNCION
,COUNT(*) as PERSONAS
,avg(SALARIO) as MEDIA
from PLANTILLA
where SALA_COD=6
group by FUNCION;

13. Mostrar el número de hombres y el número de mujeres que ha
entre los enfermos

SELECT COUNT(*) as ENFERMOS
,SEXO
from ENFERMO
group by SEXO;

15. Calcular el numero de salas que hay por cada hospital

select count(*) as NUMERO_SALAS
,HOSPITAL_COD
from SALA
group by HOSPITAL_COD;

16. El numero de enfermeras que exiatan por cada sala

select count(*) as  ENFERMERAS
,SALA_COD
from PLANTILLA
where FUNCION ='ENFERMERA'
group by SALA_COD;

--CONSULTAS dDE COMBINACION
--NOS PERMITEN MOSTRAR DATOS DE VARIAS TABLAS QUEDEBEN ESTAR
--RELACIONADAS ENTRE SI MEDIANTE ALGUNA CLAVE
--1) NECESITAMOS CAMPO/S DE RELACION ENTRE LAS TABLAS
--2) DEBEMOS PONER EL NOMBRE DE CADA TABLA Y CADA CAMPO DE LA CONSULTA
-- SINTAXIS:

select TABLA1.CAMPO1, TABLA1.CAMPO2
, TABLA2.CAMPO1, TABLA2.CAMPO2
from TABLA1
inner join TABLA2
on TABLA1.CAMPO_RELACION= TABLA2.CAMPO_RELACION;

--MOSTRAR EL APELLIDO, OFICIO DE EMPLEADOS JUNTO A SU NOMBRE
--DE DEPARTAMENTO Y LOCALIDAD

select EMP.APELLIDO, EMP.OFICIO
,DEPT.DNOMBRE, DEPT.LOC
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO;

-- TENEMOSOTRA SINTAXIS PARA REALIZAR LOS JOIN
-- PERO NO ES EFICIENTE Y SE UTILIZABA ANTES DE 1992

select EMP.APELLIDO, EMP.OFICIO
,DEPT.DNOMBRE, DEPT.LOC
from EMP, DEPT
where EMP.DEPT_NO  =DEPT.DEPT_NO;

-- PODEMOS REALIZAR POR SUPUESTO NUESTRO WHERE
-- QUEREMOS MOSTRAR LOS DATOS SOLO DE MADRID

select EMP.APELLIDO, EMP.OFICIO
,DEPT.DNOMBRE, DEPT.LOC
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
where DEPT.LOC = 'MADRID';

--NO ES OBLIGATORIO INCLUIR EL NOMBRE DE LA TABLA ANTES DEL CAMPO A MOSTRAR
-- EN EL SELECT

select EMP.APELLIDO, OFICIO
,DEPT.DNOMBRE, LOC
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
where DEPT.LOC = 'MADRID';

-- PODEMOS INCLUIR ALIAS A LOS NOMBRE DE LAS TABLAS
-- PPARA LLAMARLAS ASI A LO LARGO DE LA CONSULTA
-- ES UTIL CUANDO TENEMOS TABLAS CON NOMBRE MUY LARGOS
-- CUANDO TENMOS ALIAS, LA TABLA SE LLAMARA ASI PARA TODA LA CONSULTA

select e.APELLIDO, OFICIO
,d.DNOMBRE, LOC
from EMP e
inner join DEPT d
on e.DEPT_NO =d.DEPT_NO;

-- TENEMOS MULTIPLES TIPOS DE JOIN EN LAS BASES DE DATOS
-- innner: COMBINA LOS RESULTADOS DE LAS DOS TABLAS
-- left: COMBINA LAS DOS TABLAS Y TAMBIEN LA TABLA IZQUIERDA
-- righ. COMBINA LAS DOS TABLAS Y FUERZA LA TABLA DERECHA
-- full: COMBINA LAS DOS TABLAS Y FUERZA LAS DOS TABLAS
-- cross: PRODUCTO CARTESIANO, COMBINAR CADA DATO DE UNA TABLA CON LOS OTROS DATOS DE LA TABLA

select DISTINCT DEPT_NO from EMP;
select * from EMP;
select * from DEPT;

-- TENEMOSUN DEPARTAMENTO: 40, PRODUCCION,GRANADA SIN EMPLEADOS
-- VAMOS A CREAR UN NUEVO EMPLEADO QUE NO TENGA DEPARTAMENTO

INSERT INTO emp VALUES('7914', 'gutierrez', 'EMPLE919, TO_DATE('20-10-1986', 'DD-MM-YYYY'), 258500, 50000, 20);

INSERT INTO emp VALUES ('1111', 'sin dept', 'EMPLEADO', 7907, TO_DATE('04-04-1996', 'DD-MM-YYYY'), 162500, 0, 50);

--TENEMOS UN EMPLEADO SIN DEPARTAMENTO EN EL 50

select EMP.APELLIDO, DEPT.DNOMBRE, DEPT.LOC
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO;

-- LA TABLA DE LA IZQUIERDA ES ANTES DEL JOIN 

select EMP.APELLIDO, DEPT.DNOMBRE, DEPT.LOC
from EMP
LEFT join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO;


-- LA TABLA DE LA DERECHA ES ANTES DEL JOIN 

select EMP.APELLIDO, DEPT.DNOMBRE, DEPT.LOC
from EMP
right join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO;

-- full: COMBINA LAS DOS TABLAS Y TAMBIÉN LOS DATOS QUE NO COMBINEN

select EMP.APELLIDO, DEPT.DNOMBRE, DEPT.LOC
from EMP
FULL join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO;


-- cross: PRODUCTO CARTESIANO, NO LLEVA ON
-- cert. oracle: TENMOS LA TABLA DE COCHES Y LA TABLA DE COLORES. MOSTRAR DISTINTOS COCHES CON DISTINTOS COLORES

select EMP.APELLIDO, DEPT.DNOMBRE, DEPT.LOC
from EMP
cross join DEPT;

rollback;

-- MOSTRAR LA MEDIIA SALARIAL DE LOS DOCTORES POR HOSPITAL

select avg(SALARIO) as MEDIA, HOSPITAL_COD
from DOCTOR
group by HOSPITAL_COD;

-- MOSTRAR LA MEDIIA SALARIAL DE LOS DOCTORES POR HOSPITAL
-- MOSTRAR EL NOMBRE DELHOSPITAL

select avg(DOCTOR.SALARIO) as MEDIA, HOSPITAL.NOMBRE
from DOCTOR
inner join HOSPITAL
on DOCTOR.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
group by HOSPITAL.NOMBRE;

-- MOSTRAR EL NUMERO DE EMPLEADOS QUE EXISTE POR CADA  LOCALIDAD

select count(EMP.EMP_NO) as EMPLEADOS, DEPT.LOC
from EMP
right join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
group by DEPT.LOC;
