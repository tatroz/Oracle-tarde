

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
