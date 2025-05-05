

--VCEPLAYER 24/04/2025
192.168.1.128
HTTPS://mylearnoracle.com/
T@lentoC@s25 (pasword de learn oracle)
https://education.oracle.com/raise-your-game-saas
oracle exam 71/149

/*exception significa un error
too many rows; si es implicito y hay ma de una fila*/

----EXCEPTION--
--CUANDO DA EL ERROR LA APLICACION FINALIZA SI NO LO TRATAMOS
--EXCEPTION VA ENTRE BEGIN Y END
--EJEMPLO: CAPTURAR UNA EXCEPCION DEL SISTEMA

declare
    v_numero1 number :=&numero1;
    v_numero2 number :=&numero2;
    v_division number;
begin
    v_division := v_numero1/v_numero2;
    DBMS_OUTPUT.PUT_LINE('La division es ' || v_division);
 exception 
    when ZERO_DIVIDE then --ZERO_DIVIDE es la exceprcion de Oracle
            dbms_output.put_line('Error al dividir entre 0');
end;
undefine numero1;
undefine numero2;

--CUANDO LOS EMPLEADOS TENGAN UNA COMISION CON VALOR 0,
--LANZAREMOS UNA EXCEPCION
--TENDREMOS UNA TABLA DONDE ALMACENAREMOS LOS EMPLEADOS 
--CON COMISION MAYOR A CERO

create table emp_comision (apellido varchar2(50), comision number(9));

declare
        cursor cursor_emp is
        select APELLIDO, COMISION from EMP order by COMISION DESC;
        exception_comision EXCEPTION;
begin
        for v_record in cursor_emp
        loop
            insert into emp_comision  values (v_record.APELLIDO, v_record.COMISION);
            if (v_record.COMISION = 0) then
             raise exception_comision;
            end if;
        end loop;
 exception
    -- quiero detener esto cuando la comision sea 0       
        when exception_comision then
            dbms_output.put_line('Comisiones a ZERO');
end;

--PRAGMA EXCEPTIONS
describe dept;

declare
    exception_nulos EXCEPTION;
    PRAGMA EXCEPTION_INIT(exception_nulos, -1400);
begin
    insert into DEPT values (null,'DEPARTAMENTO', 'PRAGMA');
 exception  
    when exception_nulos then
        dbms_output.put_line('No me sirven los nulos...');   
end;



declare 
    v_id number;

begin
    select DEPT_NO into v_id
    from DEPT
    where DNOMBRE ='BENTAS';
    dbms_output.put_line('Ventas es el número' || v_id);
exception
    when TOO_MANY_ROWS then 
        dbms_output.put_line('Demasiadas filas en cursor');
    when OTHERS then
        dbms_output.put_line(to_char(SQLCODE) || ' ' || SQLERRM); --con esto me saldra este mensaje 100 ORA-01403: no data found
end;

declare 
    v_id number;

begin
    RAISE_APPLICATION_ERROR (-20001)
    select DEPT_NO into v_id
    from DEPT
    where DNOMBRE ='BENTAS';
    dbms_output.put_line('Ventas es el número' || v_id);
exception
    when TOO_MANY_ROWS then 
        dbms_output.put_line('Demasiadas filas en cursor');
    when OTHERS then
        dbms_output.put_line(to_char(SQLCODE) || ' ' || SQLERRM); --con esto me saldra este mensaje 100 ORA-01403: no data found
end;

---------------------PROCEDIMIENTOS ALMACENADOS----------------------------
--EJEMPLO PROCEDIMIENTO PARA MOSTRAR UN MENSAJE


--LLAMADA AL PROCEDIMIENTO
begin
    sp_mensaje;
end;

--CREAMOS EL PROCEDIMIENTO

create or replace procedure sp_ejemplo_plsql
as
begin
declare
    v_numero number;
begin
        v_numero := 14;
        if v_numero > 0 then
            DBMS_OUTPUT.PUT_LINE('Positivo');
        else
            dbms_output.put_line('Negativo');
        end if;
    end;
end;

--LLAMADA

begin
    sp_ejemplo_plsql;
end;


/*--PROCEDIMIENTO CON BLOQUE PL/SQL

declare
    v_numero number;
begin
    v_numero := 14;
    if v_numero > 0 then
        DBMS_OUTPUT.PUT_LINE('Positivo');
    else
        dbms_output.put_line('Negativo');
    end if;
end;*/

--TENEMOS OTRA SINTAXIS PARA TENER VARIABLES
--DENTRO DE UN PROCEDIMIENTO
--EN ESTE CASO NO SE UTILIZA LA PALABRA declare

create or replace procedure sp_ejemplo_plsql2
as
    v_numero number :=14;
begin
    if v_numero > 0 then
            DBMS_OUTPUT.PUT_LINE('Positivo');
        else
            dbms_output.put_line('Negativo');
        end if;
end;

begin
    sp_ejemplo_plsql2;
end;

--PROCEDIMIENTO PARA SUMAR DOS NUMEROS

create or replace procedure sp_sumar_numeros
(p_numero1 number, p_numero2 number)
as
    v_suma number;
begin
    v_suma := p_numero1 + p_numero2;
        dbms_output.put_line('La suma de ' || p_numero1
        || ' ' || p_numero2 || ' es igual a ' || v_suma );
end;

--llamada al procedimiento
begin
        sp_sumar_numeros(5,6);
end;

--necesito un procedimiento para dividir dos numeros
--se llamara sp_dividir_numeros

create or replace procedure sp_dividir_numeros
(p_numero1 number, p_numero2 number)
as
    v_division number;
begin   
    v_division := p_numero1/p_numero2;
        dbms_output.put_line('La division ' || p_numero1
        || ' entre ' || p_numero2 || ' es igual ' || v_division);
exception
    when ZERO_DIVIDE then   
        dbms_output.put_line('Division entre cero PROCEDURE');
end;

--llamada procedimiento
begin
    sp_dividir_numeros(10,0);
 EXCEPTION
    when ZERO_DIVIDE then
        dbms_output.put_line('Division entre cero, PL/SQL outer');   
end;

--AUNQUE TENGAMOS VARIOS EXEPTION, EL QUE SE VA A EJECUTAR ES EL MÁS CERCANO
create or replace procedure sp_dividir_numeros
(p_numero1 number, p_numero2 number)
as
begin   
    declare
        v_division number;
    begin
         v_division := p_numero1/p_numero2;
         dbms_output.put_line('La division ' || p_numero1
        || ' entre ' || p_numero2 || ' es igual ' || v_division);
  EXCEPTION
       when ZERO_DIVIDE then
        dbms_output.put_line('Division entre cero, PL/SQL inner'); 
end;        
exception
    when ZERO_DIVIDE then   
        dbms_output.put_line('Division entre cero PROCEDURE');
end;


--REALIZAR  UN PROCEDIMIENTO PARA INSEERTAR UN NUEVO DEPARTAMENTO
create or replace procedure sp_insertardepartamento

(p_id  DEPT.DEPT_NO%TYPE, p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE) --al procedimiento no puedo indicar lalongitud del varchar2

as
begin
    insert into DEPT values (p_id, p_nombre, p_localidad);
end;
--llamada al procediiento

BEGIN   
        sp_insertardepartamento (11, '11', '11');
    --normalmente, dentro de los procedimientos se acción se incluye
    --commit o rollack si diera unaexcepcion(es opcional)
END;

select * from DEPT;
ROLLBACK;

--------------------------VERSION 2-----------------------------

--REALIZAR  UN PROCEDIMIENTO PARA INSEERTAR UN NUEVO DEPARTAMENTO
--GENERAMOS EL ID CONEL MAX AUTOMATICO DENTRO DEL PROCEDURE
create or replace procedure sp_insertardepartamento

(p_nombre DEPT.DNOMBRE%TYPE, p_localidad DEPT.LOC%TYPE) --al procedimiento no puedo indicar lalongitud del varchar2

as
        v_maxid DEPT.DEPT_NO%TYPE;
begin
    --realizamos un cursor implicitopar buscar el max id
    select max(DEPT_NO) +1 into v_maxid from DEPT;
    insert into DEPT values (v_maxid, p_nombre, p_localidad);
    --normalmente, dentro de los procedimientos se acción se incluye
    --commit o rollack si diera unaexcepcion(es opcional)
    commit;
exception
    when no_data_found then
        dbms_output.put_line('No existen datos');
        rollback;
end;
--llamada al procediiento

BEGIN   
        sp_insertardepartamento ('miercoles', 'miercoles');
    
END;

select * from DEPT;
ROLLBACK;

--REALIZAR UN PROCEDIMIENTO PARA INCREMENTAR EL SALARIO DE
--LOS EMPLEADOS POR UN OFICIO
--DEBEMOS ENVIAR EL OFICIO Y EL INCREMENTO

create or replace procedure sp_incremento_emp_oficio
(p_oficio EMP.OFICIO%TYPE, p_incremento number)--se crea el procedimiento porque tanto el oficio como el incremento nos lo van a indicar

as
   -- v_oficio EMP.OFICIO%TYPE; --sirve para recuperar algo que esta en la tabla por lo que aqui no nos sirve


BEGIN
    update EMP set SALARIO= SALARIO + p_incremento
    where upper(OFICIO) = upper(p_oficio);
    commit;
END;

begin
    sp_incremento_emp_oficio ('analista', 1);
end;

select * from EMP where lower(oficio) = 'analista';
rollback;

--NECESITO UN PROCEDIMIENTO PARA INSERTAR UN DOCTOR
--ENVIAREMOS TODOS LOS DATOS DEL DOCTOR, EXCEPTO EL ID
--DEBEMOS RECUPERAR EL MÁXIMO ID DOCTOR DENTRO DEL PROCEDIMIENTO

create or replace procedure sp_insertardoctor
(p_hospitalid DOCTOR.HOSPITAL_COD%TYPE, p_apellido DOCTOR.APELLIDO%TYPE, p_especialidad DOCTOR.ESPECIALIDAD%TYPE, p_salario DOCTOR.SALARIO%TYPE)

as
        v_max_iddoctor DOCTOR.DOCTOR_NO%TYPE;
begin
    --realizamos un cursor implicitopar buscar el max id
    select max(DOCTOR_NO) +1 into v_max_iddoctor from DOCTOR;
    insert into DOCTOR values (p_hospitalid, v_max_iddoctor, p_apellido, p_especialidad, p_salario);
    --normalmente, dentro de los procedimientos se acción se incluye
    --commit o rollack si diera unaexcepcion(es opcional)
    commit; --SI HAY UN COMMIT O ROLLBACK ENTRE MEDIAS NUNCA VAMOS A VER EL ROWCOUNT, POR TANTO LO PONDRIAMOS DESPUES DEL DBMS_OUTPUT.PUT_LINE....
    dbms_output.put_line('Insertados' || SQL%ROWCOUNT);
end;

select *from DOCTOR;

BEGIN
    sp_insertardoctor (19, 'Willson', 'Doctor', 280000);
END;

-----------------------VERSION 2-----------------------------

--NECESITO UN PROCEDIMIENTO PARA INSERTAR UN DOCTOR
--ENVIAREMOS TODOS LOS DATOS DEL DOCTOR, EXCEPTO EL ID
--DEBEMOS RECUPERAR EL MÁXIMO ID DOCTOR DENTRO DEL PROCEDIMIENTO
--ENVIAMOS EL NOMBRE DEL HOSPITAL EN LUGAR DEL ID DEL HOSPITAL
--CONTROLAR SI NO EXISTE EL HOSPITAL ENVIADO

create or replace procedure sp_insertar_doctor
( p_apellido DOCTOR.APELLIDO%TYPE, p_especialidad DOCTOR.ESPECIALIDAD%TYPE, p_salario DOCTOR.SALARIO%TYPE, p_hospitalname HOSPITAL.NOMBRE%TYPE)

as
        v_max_iddoctor DOCTOR.DOCTOR_NO%TYPE;
        v_hospitalid DOCTOR.HOSPITAL_COD%TYPE;
begin
    select HOSPITAL_COD into v_hospitalid from HOSPITAL
    where UPPER(NOMBRE) = UPPER(p_hospitalname);
    --realizamos un cursor implicitopar buscar el max id
    select max(DOCTOR_NO) +1 into v_max_iddoctor from DOCTOR;
    insert into DOCTOR values (v_hospitalid, v_max_iddoctor, p_apellido, p_especialidad, p_salario);
    --normalmente, dentro de los procedimientos se acción se incluye
    --commit o rollack si diera unaexcepcion(es opcional)
    dbms_output.put_line('Insertados' || SQL%ROWCOUNT);
    commit; --SI HAY UN COMMIT O ROLLBACK ENTRE MEDIAS NUNCA VAMOS A VER EL ROWCOUNT
exception
    when no_data_found then
    dbms_output.put_line('No existe el hospital ' || p_hospitalname);
end;

select *from DOCTOR;
select *from hospital;

BEGIN
    sp_insertar_doctor ('HOUSE', 'DIAGNOSTICO', 380000, 'la paz');
END;

--PODEMOS UTILIZAR CURSORES EXPLÍCITOS  DENTRO DE LOS PROCEDIMIENTOS
--Realizar un procedimiento para mostrar los empleados
--de un determinado número de departamentos

create or replace procedure sp_empleados_dept
(p_deptno EMP.DEPT_NO%TYPE)

as
    cursor cursor_emp is
    select * from EMP
    where DEPT_NO = p_deptno;
begin
    for v_reg_emp in cursor_emp
    loop
    dbms_output.put_line('Apellido: ' || v_reg_emp.APELLIDO
    || ' ,Oficio: ' || v_reg_emp.OFICIO);
    end loop;
end;

begin
    sp_empleados_dept (10);
end;
--al ser un cursor explícito no va a dar ningun error si el departamento que indico no esta. 
--En caso de cursores implícitos si que me devolvería un error en caso de que no tengamos este departamento

--VAMOS A REALIZAR UN PROCEDIMIENTO PARA ENVIAR EL
--NOMBRE DEL DEPARTAMENTO Y DEVOLVER EL NÚMERO DE DICHO DEPARTAMENTO

create or replace procedure sp_numerodepartamento
(p_nombre DEPT.DNOMBRE%TYPE, p_iddept out DEPT.DEPT_NO%TYPE) --por un lado me van a dar las ventas y por otro lado yo obtengo depart. 30, ya que la tengo como out
as
    v_iddept DEPT.DEPT_NO%TYPE;
begin
    select DEPT_NO into v_iddept from DEPT 
    where upper(DNOMBRE) = UPPER(p_nombre);
    p_iddept := v_iddept;
    dbms_output.put_line('El número de departamento es ' || v_iddept);
end;

BEGIN
        sp_numerodepartamento ('ventas');
END;


SELECT * FROM dept;

--NECESITO UNPROCEDIMIENTO PARA INCREMENTAR EN 1
--EL SALARIO DE LOS EMPLEADOS DE UN DEPARTAMENTO
--ENVIAREMOS AL PROCEDIMIENTO EL NOMBRE DEL DEPATAMENTO

create or replace procedure sp_incrementar_sal_dept
(p_nombre DEPT.DNOMBRE%TYPE)
as
    v_num DEPT.DEPT_NO%TYPE;
begin
    --recuperamos el id del departamento a partir del nombre
    --llamamos alprocedimiento de numero para recuperar el numero
    --a partir del nombre
    --sp_numerodepartamento
    --(P_nombre DEPT.DNOMBRE%TYPE, p_iddept out DEPT.DEPT_NO%TYPE)
    sp_numerodepartamento(p_nombre,v_num);
    update EMP set SALARIO = SALARIO +1
    where DEPT_NO =  v_num;
    dbms_output.put_line('Salarios modificados: ' || SQL%ROWCOUNT); 
end;

begin
    sp_incrementar_sal_dept ('ventas');
end;