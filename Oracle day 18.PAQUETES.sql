-------------------PAQUETES----------------------------------
--El parquete tiene que tener body(cuerpo) si tiene  procedimientos o funciones. 
--creamos nuestro primer packete de prueba
--header (la declaración)
create or replace package pk_ejemplo
as
    --en el header solamente se incluyen las declaraciones
    procedure mostrarmensaje;
end pk_ejemplo;
--body(la funcionalidad real)
create or replace package body pk_ejemplo
as
    procedure mostrarmensaje
    as
    begin
        dbms_output.put_line('Soy un paquete ');
        end;
end pk_ejemplo;


begin
    pk_ejemplo.mostrarmensaje;
end;

--vamos a realizar un paquete que contenga acciones de eliminar
--sobre EMP, DEPT, DOCTOR, ENFERMO
select * from EMP;
create or replace package pk_delete
AS
    procedure eliminaremp(p_empno EMP.EMP_NO%TYPE);
    procedure eliminardept (p_deptno DEPT.DEPT_NO%TYPE);
    procedure eliminardoctor (p_doctorno DOCTOR.DOCTOR_NO%TYPE);
    procedure eliminarenfermo(p_inscripcion ENFERMO.INSCRIPCION%TYPE);
END pk_delete;
--body
create or replace package body pk_delete
AS
    procedure eliminaremp(p_empno EMP.EMP_NO%TYPE)
    as
    begin   
        delete from EMP where EMP_NO= p_empno;
       commit;
    end; 
    procedure eliminardept (p_deptno DEPT.DEPT_NO%TYPE)
       as
    begin   
        delete from DEPT where DEPT_NO= p_deptno;
       commit;
    end;
    procedure eliminardoctor (p_doctorno DOCTOR.DOCTOR_NO%TYPE)
       as
    begin   
        delete from DOCTOR where DOCTOR_NO= p_doctorno;
       commit;
    end;
    procedure eliminarenfermo(p_inscripcion ENFERMO.INSCRIPCION%TYPE)
        as
    begin   
        DBMS_OUTPUT.PUT_LINE('Eliminando Departamento tambien')
        ---ELIMINARDEPT(45); --si estoy dentro del paquete no se indica 
        --el nombre del paquete
        delete from ENFERMO where INSCRIPCION= p_inscripcion;
       commit;
    end;
END pk_delete;

SELECT * FROM DEPT;
BEGIN
    PK_DELETE.ELIMINARDEPT(44);
END;

--creamos un paquete para devolver maximo, minimo y diferencia de
--todos los empleados (salario)
create or replace package pk_empleados_salarios
AS
    function minimo return number;
    function maximo return number;
    function diferencia return number;
end pk_empleados_salarios;
--body
create or replace package body pk_empleados_salarios
AS
    function minimo return number
    as
        v_minimo number; --declaramos una variable
    begin
        select min(SALARIO) into v_minimo from EMP;
        return v_minimo; --es imprescindible el return
    end;
    function maximo return number
    AS
        v_maximo number;
    begin
        select max(SALARIO) into v_maximo from EMP;
        return v_maximo;
    end;
    function diferencia return number
    AS
        v_diferencia number;
    begin
        v_diferencia := maximo - minimo; --maximo y minimo son los nombres de funicones
        return v_diferencia;
    end;
end pk_empleados_salarios;

select PK_EMPLEADOS_SALARIOS.MAXIMO as MAXIMO,
PK_EMPLEADOS_SALARIOS.MINIMO as MINIMO,
PK_EMPLEADOS_SALARIOS.DIFERENCIA as DIFERENCIA from DUAL;

--NECESITO UN PAQUETE PARA REALIZAR
--Update, Insert y Delete sobre Departamentos
--Llamamos al paquete pk_departamentos

create or replace package pk_departamentos
AS
    procedure updatedept (p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE);
    procedure insertdept (p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE);
    procedure deletedept (p_id DEPT.DEPT_NO%TYPE);
end pk_departamentos;
--body
create or replace package body pk_departamentos
AS
    procedure updatedept (p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE)
    as
    begin   
        update DEPT set DNOMBRE =p_nombre, LOC= p_localidad where DEPT_NO= p_id;
       commit;

    end; 
    procedure insertdept (p_id DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE)
    as
    begin   
        insert into DEPT values (p_id, p_nombre, p_localidad);
       commit;
    end; 
    procedure deletedept (p_id DEPT.DEPT_NO%TYPE)
    as
    begin   
        delete from DEPT where DEPT_NO= p_id;
       commit;
    end; 
end pk_departamentos;

select * from DEPT;

--Necesito una funcionalidad que nos devuelva
--el Apellido, el trabajo, salario y lugar de trabajo 
--de todas las personas de nuestra bbdd
--Necesito otra funcion que nos devuelva 
--el Apellido, el trabajo, salario y lugar de trabajo (departamento/hospital)
--dependiendo del salario

--1)CONSULTA GORDA y CONSULTA DENTRO DE VISTA

create or replace view V_TODOS_EMPLEADOS
as
select EMP.APELLIDO, EMP.OFICIO , EMP.SALARIO,
DEPT.DNOMBRE
from EMP
inner join DEPT
on EMP.DEPT_NO =DEPT.DEPT_NO
UNION
select PLANTILLA.APELLIDO, PLANTILLA.FUNCION, PLANTILLA.SALARIO,
HOSPITAL.NOMBRE
from PLANTILLA
inner join HOSPITAL
on PLANTILLA.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD
UNION
select DOCTOR.APELLIDO, DOCTOR.ESPECIALIDAD, DOCTOR.SALARIO,
HOSPITAL.NOMBRE
from DOCTOR
inner join HOSPITAL
on DOCTOR.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD;

select * from V_TODOS_EMPLEADOS



--3)PAQUETE CON DOS PROCEDIMIENTOS

create or replace package pk_vista_empleados
AS
    procedure todos_empleados;
    procedure todos_empleados_salario (p_salario EMP.SALARIO%TYPE);
end pk_vista_empleados;
--3A)PROCEDIMIENTO PARA DEVOLVER TODOS LOS DATOS EN UN CURSOR
create or replace package body pk_vista_empleados
AS
    procedure todos_empleados
as
    cursor c_empleados IS
    select * from V_TODOS_EMPLEADOS;
    begin
        for v_emp in c_empleados
        loop
            dbms_output.put_line(v_emp.APELLIDO || ' , Oficio' ||
            v_emp.OFICIO || ' ,Salario' || v_emp.SALARIO 
            || ' ,Lugar' || v_emp.DNOMBRE);
        end loop;
    end;
    procedure todos_empleados_salario (p_salario EMP.SALARIO%TYPE)
        AS
        cursor c_empleados IS
        select * from V_TODOS_EMPLEADOS
        where SALARIO >= p_salario;
    begin
        for v_emp in c_empleados
        loop
            dbms_output.put_line(v_emp.APELLIDO || ' , Oficio' ||
            v_emp.OFICIO || ' ,Salario' || v_emp.SALARIO 
            || ' ,Lugar' || v_emp.DNOMBRE);
        end loop;
    end;
end pk_vista_empleados;

begin
    pk_vista_empleados
end;

--3B)PROCEDIMIENTOS PARA DEVOLVER TODOS LOS DATOS EN UN CURSOR POR SALARIO
begin
PK_VISTA_EMPLEADOS.TODOS_EMPLEADOS;
PK_VISTA_EMPLEADOS.TODOS_EMPLEADOS_SALARIO(350000);
end;

--Necesitamos un paquete con procedimiento para modificar el salario de cada 
--Doctor de forma individual.
--La modificación de los datos de cada doctor será de forma aleatoria.
--Debemos comprobar el Salario de cada Doctor para ajustar el número aleatorio 
--del incremento.
--1) Doctor con menos de 200.000: Incremento aleatorio de 500
--2) Doctor entre de 200.000 y 300.000: Incremento aleatorio de 300
--3) Doctor mayor a 300.000: Incremento aleatorio de 50
--El incremento Random lo haremos con una función dentro del paquete.
update doctor set salario = salario + dbms_random.value(1,50);
select dbms_random.value(1,50) as aleatorio from DUAL;
select * from DOCTOR;

--bloque pl/sql

declare
    cursor c_doctores is
    select DOCTOR_NO, APELLIDO, SALARIO from DOCTOR;
    v_random number;
begin
    
    for v_doc in c_doctores
     loop 
     
        select trunc(dbms_random.value(1,50)) into v_random from DUAL;
         --queremos un incremento random por cada doctor
         --vamos a modificar el salario de cada doctor
         update DOCTOR set SALARIO= Salario + v_random
         where DOCTOR_NO=v_doc.DOCTOR_NO;
         dbms_output.put_line ('Doctor ' || v_doc.APELLIDO
         || ' tiene un incremento de ' || v_random);
    end loop;
end;

create or replace function random_doctor
(p_iddoctor DOCTOR.DOCTOR_NO%TYPE)
return number
as
    v_salario DOCTOR.SALARIO%TYPE;
    v_random number;
begin
    select SALARIO into v_salario from DOCTOR
    where DOCTOR_NO=p_iddoctor;
    if (v_salario< 200000) then
        v_random := trunc(dbms_random.value(1, 500));
    if (v_salario> 300000) then
        v_random := trunc(dbms_random.value (1,50));
    else
        v_random := trunc(dbms_random.value (1,300));
    end if;
    return v_random;
end;

---386 --> 500
--522 --> 50

select random_doctor(386) 

--header
create or replace package pk_doctores
AS  
    procedure incremento_random_doctores;
    function function_random_doctores (p_iddoctor DOCTOR.DOCTOR_NO%TYPE)
    return number;
end pk_doctores;
--body
create or replace package pk_doctores
AS  
    procedure incremento_random_doctores;
    function function_random_doctores (p_iddoctor DOCTOR.DOCTOR_NO%TYPE)
    return number;
end pk_doctores;