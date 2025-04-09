----PRACTICA 3

1. Seleccionar el apellido, oficio, salario, numero de departamento y su nombre de todos los empleados cuyo salario sea mayor de 300000 

select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO, EMP.DEPT_NO
,DEPT.DNOMBRE
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
where EMP.SALARIO >300000;

2. Mostrar todos los nombres de Hospital con sus nombres de salas correspondientes. 

select HOSPITAL.NOMBRE as NOMBRESALA--nunca podemosponer el mismo nombre de columna para cada tabl, en este caso tenemos que crear un alias
, SALA.NOMBRE as NOMBREHOSPITAL
from HOSPITAL
inner join SALA
on HOSPITAL.HOSPITAL_COD = SALA.HOSPITAL_COD;

3.Calcular cuántos trabajadores de la empresa hay en cada ciudad. 

select count(EMP.EMP_NO) as TRABAJADORES, DEPT.LOC
from EMP
right join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
group by DEPT.LOC;

4. Visualizar cuantas personas realizan cada oficio en cada departamento mostrando el nombre del departamento. 

select count(EMP.EMP_NO) as PERSONAS, EMP.OFICIO--group by tiene que agrupar todos loscampos que eneel select
,DEPT.DNOMBRE
from EMP
right join DEPT
on EMP.DEPT_NO =DEPT.DEPT_NO
group by EMP.OFICIO, DEPT.DNOMBRE;

5.Contar cuantas salas hay en cada hospital, mostrando el nombre de las salas y el nombre del hospital. 

select count(SALA.nombre)as SALAS, SALA.NOMBRE
,HOSPITAL.NOMBRE
from SALA
inner join HOSPITAL
on SALA.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD
group by SALA.NOMBRE, HOSPITAL.NOMBRE;

6. Queremos saber cuántos trabajadores se dieron de alta entre el año 1997 y 1998 y en qué departamento. 

select count(EMP.EMP_NO) as TRABAJADORES
,DEPT.DNOMBRE
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
group by DEPT.DNOMBRE
where FECHA_ALT between '01/01/1997' and '31/12/1998'; --SIEMPRE VA DESPUES DE GROUP BY


7. Buscar aquellas ciudades con cuatro o más personas trabajando. 

select count(EMP.EMP_NO) as PERSONAS
,DEPT.LOC
from EMP
left join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
group by DEPT.LOC
having count (*)>=4;

8. Calcular la media salarial por ciudad.  Mostrar solamente la media para Madrid y Elche. 

select avg(EMP.SALARIO) as MEDIA_SALARIAL
,DEPT.LOC
from EMP
inner join DEPT
on EMP.DEPT_NO = DEPT.DEPT_NO
group by DEPT.LOC
having LOC= 'MADRID' or LOC='SEVILLA';

9. Mostrar los doctores junto con el nombre de hospital en el que ejercen, la dirección y el teléfono del mismo. 

select DOCTOR.APELLIDO, HOSPITAL.NOMBRE, HOSPITAL.DIRECCION, HOSPITAL.TELEFONO
from DOCTOR
cross join HOSPITAL;

10. Mostrar los nombres de los hospitales junto con el mejor salario de los empleados de la plantilla de cada hospital. 

select HOSPITAL.NOMBRE, 
, max(SALARIO) as MAXSALARIO
from PLANTILLA


select FUNCION
,COUNT(*) as PERSONAS
,avg(SALARIO) as MEDIA
from PLANTILLA
where SALA_COD=6
group by FUNCION;


11.


12.

13.


                 -----TEORIA DIA 4------
                 
 --SUBCONSULTAS
 --SON CONSULTAS QUE NECESITAN DEL RESULTADO DE OTRA CONSULTA PARA PODER SER EJECUTADAS.
 --NO SON AUTONOMA, NECESITAN DE ALGUN VALOR
-- NO IMPORTA EL NIVEL DE ANIDAMIENTO DE SUBCONSULTAS, AUNQUE PUEDEN RALENTIZAR LA RESPUESTA.-
 --GENERAN BLOQUEOS EN CONSULTAS SELECT, LO QUE TAMBIEN RALENTIZA LAS RESPUESTAS
 -- DEBEMOSEVITARLAS EN LA MEDIDA DE LO POSIBLE CON SELECT
 --QUIERO VISUALIZAR LOS DATOS DEL EMPLEADO QUE MAS COBRA DE LA EMPRESA (EMP)
 
 select max(SALARIO) from EMP;
 
 --6500000
 
 select  from EMP where SALARIO=650000
 --SE EJECUTAN LAS DOS CONSULTAS A LA VEZ Y, SE ANIDA EL RESULTADO DE UNA CONSULTA
 --CON LAIGUALDAD DE LA RESPUESTA DE OTRA CONSULTA
 --LAS SUBCONSULTAS VAN ENTRE PARENTESIS
 
 select * from EMP where SALARIO = (select max(SALARIO) from EMP);
 
 --MOSTRAR LOS EMPLEADOS QUE TIENEN EL MISMO OFICIO QUE EL EMPLEDO gil
 -- Y QUE COBREN MENOS QUE jimenez
 
 select * from EMP where OFICIO = 
 (select OFICIO from EMP where APELLIDO ='gil')and
 SALARIO< (select SALARIO from EMP where APELLIDO='jimenez');

 
 --MOSTRAR LOS EMPLEADOS QUE TIENEN EL MISMO OFICIO QUE EL EMPLEDO gil
 -- Y QUE COBREN MENOS QUE jimenez
 
 select * from EMP where OFICIO = 
 (select OFICIO from EMP where APELLIDO ='gil'or APELLIDO = 'jimenez'); --este me da el error porque la consulta da como el resultado dos oficios           
 
 --SI LA CONSULTA DEVUELVE MAS DE UN VALOR USAREMOS EL OPERADOR in                
   
  select * from EMP where OFICIO in
 (select OFICIO from EMP where APELLIDO ='gil'or APELLIDO = 'jimenez');  
 
 -- POR SUPUESTO, PODEMOS UTILIZAR SUBCONSULTAS PARA OTRAS TABLAS
 --MOSTRAR EL APELLIDO Y EL OFICIO DE LOS EMPLEADOS DEL DEPARTAMENTO DE MADRID
 
 select APELLIDO, OFICIO from EMP where DEPT_NO =
 (select DEPT_NO from DEPT where LOC = 'MADRID');-- ES CORRECTO PERO ES MEJOR HACER ESTO CON UN join PORQUE LAS SUBCONSULTAS CREAN LOS BLOQUEOS
 
 -- LA CONSULTA CORRECTA SERIA ESTA
 
 select EMP.APELLIDO, EMP.OFICIO 
 from EMP
 inner join DEPT
 on EMP.DEPT_NO=DEPT.DEPT_NO
 where DEPT.LOC ='MADRID';--SI SERIAN VARIA OPCIONES PONDRIA where DEPT.LOC in ('MADRID', 'SEVILLA')
 
 -- CONSULTAS UNION
 -- MUESTRAN , EN UN MISMO CURSOR, UN MISMO CONUNTO DE RESULTADOS
 -- ESTAS CONSULTAS SE UTILIZAN COMO CONCEPTO, NO COMO RELACION
 -- DEBEMOS SEGUIRTRES NORMAS:
 --1) LA PRIMERA CONSULTA ES LA JEFA
 --2) TODAS LAS CONSULTAS DEBEN TENER EL MISMO NUMERO DE COLUMNAS
 --3) TODAS LAS COLUMNAS DEBEN TENER EL MISMO TIPO DE DATO ENTRE SI
 
 -- EN NUESTRA BASEDE DATOS,TENEMOS DATOS DE PERSONAS EN DIFERENTES TABLAS
 -- EMP, PLANTILLA YDOCTOR
 -- EN LAS CONSULTAS UNION DEBERIAMOS UTILIZAR SIEMPRE NUMERANDO
 -- COMO RECOMENDACION. SI PONEMOS UN ALIAS, NO FUNCIONA
 
 select APELLIDO, OFICIO, SALARIO as SUELDO from EMP --COMO LAPRIMERA MANDA SI QUIERO PONER UN ALIAS TIENE QUE  SER ENLAP RIMERA
 union
 select APELLIDO, FUNCION, SALARIO from PLANTILLA
 union 
 --select DNOMBRE, LOC, DEPT_NO from DEPT;--ESTO NO TIENE SENTIDO AÑADIRLO PERO SI CUMPLE LAS NORMAS SQL NOSDEJA AÑADIRLO
 select APELLIDO, ESPECIALIDAD, SALARIO from DOCTOR;
 --order by 3;--con el 3 estoy ordenando por SALARIO
-- order by SALARIO; --EN union ES RECOMEN ORDENAR POR NUMERANDOS
-- order by OFICIO; --NO FUNCIONA PORQUE EL NOMBRE DE LA SEGUNDA COLUMNA ES DIFERENTE EN LAS TRES TABLAS
 
 
 -- POR SUPUESTO, PODEMOS PERFECTAMENTE FILTRAR LOS DATOS DE LA CONSULTA
 -- POR EJEMPLO, MOSTRAR LOS DATOSDE LAS PERSONAS QUE COBREN MENOS DE 300.000
 select APELLIDO, OFICIO, SALARIO from EMP 
 union
 select APELLIDO, FUNCION, SALARIO from PLANTILLA
 union 
 select APELLIDO, ESPECIALIDAD, SALARIO from DOCTOR
 --where SALARIO<300000
 order by 1;--where se aplica solo a la consulta que esta justo arriba, por lo que cada consulta tienen que tener su where
 --CADA where ES INDEPENDIENTE DEL UNION

-- UNION ELIMINA LOS RESULTADOS REPETIDOS
-- SI QUEREMOS REPETIDOS, DEBEMOS UTILIZAR union all

select APELLIDO, OFICIO from EMP 
union all
select APELLIDO, OFICIO from EMP;                
