----------------------FUNCIONES EN PL/SQL (05/05/2025)---------------------------------
--Realiza ua función para sumar dos números

create or replace function f_sumar_numeros
(p_numero1 number, p_numero2 number)--indicamos los parametros si lo queremos
return number --es obligatorio indicar return y su tipo de dato
as
    v_suma number;
begin
    v_suma := p_numero1 + p_numero2;
    --SIEMPRE UN RETURN, SI NO LO PONGO NO VA A FUNCIONAR
    return v_suma;
end;

--llamada con códigopl/sql

DECLARE
    v_resultado number;
BEGIN
    v_resultado := F_SUMAR_NUMEROS(22,55);
    DBMS_OUTPUT.put_line('La suma es ' || v_resultado);
end;
--llamada con select

select F_SUMAR_NUMEROS(22,99) as SUMA from DUAL;
select F_SUMAR_NUMEROS(salario, comision) as TOTAL from EMP;


create or replace function f_sumar_numeros
(p_numero1 number, p_numero2 number)--indicamos los parametros si lo queremos
return number --es obligatorio indicar return y su tipo de dato
as
    v_suma number;
begin
    v_suma := NVL(p_numero1, 0) + NVL(p_numero2, 0); --Para que los valores nulos no nos devuelvan los nulos 
    --ejemplo: (rey no tiene la comision y al sumar null con el salario el resultado que obtenemos es null y con esta funcion lo evitamos)
    --SIEMPRE UN RETURN, SI NO LO PONGO NO VA A FUNCIONAR
    return v_suma;
end;

--llamada con select
select apellido, F_SUMAR_NUMEROS(salario, comision) as TOTAL from EMP;
select F_SUMAR_NUMEROS(null, null) as suma from dual;

--FUNCION PARA SABER EL NUMERO DE PERSONAS DE UN OFICIO

create or replace function num_personas_oficio
(p_oficio EMP.OFICIO%TYPE)
RETURN number
as
    v_personas int;
begin
    select count(EMP_NO) into v_personas from EMP
    where lower(OFICIO) = LOWER(p_oficio);
    return v_personas;
end;

select num_personas_oficio('analista') as PERSONAS from DUAL;

--Realizar una funcion para devolver el mayor de dos números

create or replace function num_mayor
(p_numero1 number, p_numero2 number)
return NUMBER
as
    v_mayor number;
BEGIN
    if (p_numero1 > p_numero2) THEN
    v_mayor := p_numero1;
    ELSE    
    v_mayor := p_numero2;
    end if;
    return v_mayor;
end;

select num_mayor(8, 99) as MAYOR from DUAL;

--Realizar una funcion para devolver el mayor de tres números
--No quiero utilizar if
--Buscar (Google) una funcion de Oracle que nos devuelva el mayor

CREATE OR REPLACE FUNCTION mayor_de_tres (
    p_num1 NUMBER,
    p_num2 NUMBER,
    p_num3 NUMBER
) RETURN NUMBER IS
BEGIN
    RETURN GREATEST(p_num1, p_num2, p_num3);
END;

select mayor_de_tres(8, 18, 99) as MAYOR from DUAL;
--otra forma seria

create or replace function mayor_tres_numeros
(p_numero1 number, p_numero2 number, p_numero3 number)
return NUMBER
as
    v_mayor number;
BEGIN
   v_mayor := greatest(p_numero1, p_numero2, p_numero3);
    return v_mayor;
end;

select MAYOR_TRES_NUMEROS (8, 3, 55) as MAYOR from DUAL;

--Tenemos los parametros por defecto dentro de las funciones
select 100*1.21 as IVA from DUAL;
select importe, iva(importe)  as iva from productos;

select importe, iva(importe, 21) as iva from productos;

CREATE OR REPLACE FUNCTION calcular_iva
(p_precio number, p_iva number := 1.18)
return NUMBER
AS --tb podria poner IS
BEGIN
    return p_precio*p_iva;
end;

select CALCULAR_IVA(100, 1.21) as IVA from DUAL;

---------VIEWS (VISTAS)-------------------------------------
--VAMOS A CREAR UNA VISTA PARA TENER TODOS LOS DATOS DE LOS EMPLEADOS
--SIN EL SALARIONI COMISION, NI DIR.CALCULAR_IVA

create or replace view V_EMPLEADOS
AS
    SELECT EMP_NO, APELLIDO, OFICIO, FECHA_ALT, DEPT_NO FROM EMP;
--UNA VISTA ES SOLO UNA CONSULTA QUE SE EJECUTA DE NUEVO
--LA VISTA TIENE UNA ESTRUCTURA FIJA
SELECT * FROM V_EMPLEADOS;
--una vista simplifica las consultas
--Mostrar el APELLIDO, OFICIO, SALARIIO
--NOMBRE DEPARTAMENTO Y LOCALIDAD DE TODOS LOS EMPLEADOS
CREATE OR REPLACE VIEW V_EMP_DEPT
AS
select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO,
DEPT.DNOMBRE, DEPT.LOC
from EMP
inner join DEPT
on EMP.DEPT_NO =DEPT.DEPT_NO;

select * from V_EMP_DEPT where LOC='MADRID';

--PUEDO AÑADIR UN ALIAS

CREATE OR REPLACE VIEW V_EMP_DEPT
AS
select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO,
DEPT.DNOMBRE, DEPT.LOC as LOCALIDAD
from EMP
inner join DEPT
on EMP.DEPT_NO =DEPT.DEPT_NO;

select * from V_EMP_DEPT where LOCALIDAD='MADRID';

--PARAVCONSULTAR QUE PUEDAN VER LOS USUARIOS
SELECT * FROM USER_VIEWS where view_name = 'V_EMP_DEPT';

--PODEMOS TENER LOS CAMPOS VIRTUALES

CREATE OR REPLACE VIEW V_EMPLEADOS_VIRTUAL
AS
select EMP_NO, APELLIDO, OFICIO,
SALARIO + COMISION as TOTAL
,DEPT_NO from EMP;

SELECT * FROM V_EMPLEADOS WHERE oficio = 'ANALISTA';



CREATE OR REPLACE VIEW V_EMPLEADOS
AS
select EMP_NO, APELLIDO, OFICIO,
SALARIO, FECHA_ALT
,DEPT_NO from EMP;

SELECT * FROM V_EMPLEADOS WHERE oficio = 'ANALISTA';
--modificar el salario de los empleados ANALISTA
--tabla

update EMP set SALARIO = SALARIO +1 WHERE OFICIO ='ANALISTA';
--VISTA
update V_EMPLEADOS set SALARIO = SALARIO + 1 WHERE OFICIO ='ANALISTA';
select * from EMP;
--ELIMINAMOS AL EMPLEADO CON ID 7917
delete from V_EMPLEADOS where EMP_NO = 7917;
--INSERTAMOS EN LA VISTA

insert into V_EMPLEADOS VALUES
(1111, 'LUNES', 'LUNES',0,  SYSDATE, 40);

--MODIFICAR ELSALARIO DE LOS EMPLEDOS DE MADRID

update V_EMP_DEPT set SALARIO = SALARIO +1 where LOCALIDAD ='MADRID';

--ELIMINAR A LOSEMPLEADOS DE BARCELONA
DELETE FROM V_EMP_DEPT where LOCALIDAD = 'BARCELONA';
select * from EMP;
ROLLBACK;

CREATE OR REPLACE VIEW V_EMP_DEPT
AS
select EMP.EMP_NO, EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO, 
DEPT.DNOMBRE, DEPT.LOC as LOCALIDAD
from EMP
inner join DEPT
on EMP.DEPT_NO =DEPT.DEPT_NO;

insert into V_EMP_DEPT VALUES (3333, ' LUNES3', 'LUNES3', 250000, 
'CONTABILIDAD', 'SEVILLA');
ROLLBACK;


create or replace view V_VENDEDORES
AS
SELECT EMP_NO, APELLIDO, OFICIO, SALARIO, DEPT_NO FROM EMP
where OFICIO ='VENDEDOR'
WITH CHECK OPTION; --ESTO GENERA UN ERROR SI LAS CONSULTAS POSTERIORES VIOLAN LA SELECCION QUE HE ESTABLECIDO, EN ESTE CASO EL OFICIO =VENDEDORES
--MODIFICAMOS EL SALARIO  DE LOS VENDEDORES

update V_VENDEDORES set SALARIO = SALARIO +1;
update V_VENDEDORES set OFICIO ='VENDIDOS';
select * from V_VENDEDORES;
ROLLBACK;

