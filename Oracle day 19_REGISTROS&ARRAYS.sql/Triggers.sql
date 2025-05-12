--------------------------TRIGGERS------------------------
--es una herramienta para mantener la integridad de las tablas
--se dispara cuando quiero realizar update, delete or insert
--ejemplo de trigger capturando informacion
create or replace trigger tr_dept_before_insert
before insert
on DEPT
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before insert row');
    DBMS_OUTPUT.PUT_LINE(:new.DEPT_NO || ',' || :new.DNOMBRE --new es como un rowtype
    || ',' || :new.LOC);
end;

insert into DEPT VALUES (111, 'NUEVO', 'TOLEDO');
DROP TRIGGER tr_dept_before_insert;

--Hacemos otro trigger para DELETE
create or replace trigger tr_dept_before_delete
before delete
on DEPT
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before insert row');
    DBMS_OUTPUT.PUT_LINE(:old.DEPT_NO || ',' || :old.DNOMBRE --new es como un rowtype
    || ',' || :old.LOC);
end;
delete from DEPT where DEPT_NO=47;
select + from DEPT;
DROP TRIGGER tr_dept_before_delete;

--Para UPDATE
create or replace trigger tr_dept_before_update
before update
on DEPT
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger DEPT before update row');
    DBMS_OUTPUT.PUT_LINE(:old.DEPT_NO || ', Antigua LOC' || :old.DNOMBRE --new es como un rowtype
    || ', Nueva LOC' || :new.LOC);
end;
update DEPT set LOC='VICTORIA' where DEPT_NO=111;
DROP TRIGGER tr_dept_before_update;

--Trigger de control de doctor
create or replace trigger tr_doctor_control_salario_update
before update
on DOCTOR
for each ROW
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger DOCTOR before update row');
    DBMS_OUTPUT.PUT_LINE('Dr/Dra ' || :old.APELLIDO || 'cobra mucho dinero' ||:new.SALARIO --new es como un rowtype
    || ', Antes: ' || :old.SALARIO);
end;

update DOCTOR set SALARIO =151000 where DOCTOR_NO=386;
DROP TRIGGER tr_doctor_control_salario_update;

--Solo se ejecutara si se cumple la condicion: que el salario sea mayor a 250000
create or replace trigger tr_doctor_control_salario_update
before update
on DOCTOR
for each ROW
        when (new.SALARIO > 250000)
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger DOCTOR before update row');
    DBMS_OUTPUT.PUT_LINE('Dr/Dra ' || :old.APELLIDO || 'cobra mucho dinero' ||:new.SALARIO --new es como un rowtype
    || ', Antes: ' || :old.SALARIO);
end;
DROP TRIGGER tr_doctor_control_salario_update;

update DOCTOR set SALARIO =252000 where DOCTOR_NO=386;

--NO PODEMOS TENER DOS TRIGGERS DE MISMO TIPO EN UNA TABLA
DROP TRIGGER tr_dept_before_insert;

create or replace trigger tr_dept_control_barcelona
before insert
on DEPT
for each ROW --solo puede haber 1 trigger del mismo tipo, si se ha creado el 
--EACH ROW ya no puedo crear otro o tengo que eliminar el antiguo
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger Control Barcelona');
    if (upper(:new.LOC)= 'BARCELONA') then
    DBMS_OUTPUT.PUT_LINE('No se admiten departametos en Barcelona');
    raise_application_error(-20001, 'En Munich solo ganadores');
    end if;
end;

insert into DEPT values (5, 'MILAN', 'BARCELONA');

--Ahora le digo que entre solo cuando sea Barcelona
DA ERROR, REVISARLO EN LOS APUNTES
create or replace trigger tr_dept_control_barcelona
before insert
on DEPT
for each ROW --solo puede haber 1 trigger del mismo tipo, si se ha creado el 
--EACH ROW ya no puedo crear otro o tengo que eliminar el antiguo
    when (upper(new:LOC) ='BARCELONA') --ES MAS EFICIENTE UTILIZAR WHEN
DECLARE

BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger Control Barcelona');
    DBMS_OUTPUT.PUT_LINE('No se admiten departametos en Barcelona');
    raise_application_error(-20001, 'En Munich solo ganadores');
end;
DROP TRIGGER tr_dept_control_barcelona;

create or replace trigger tr_dept_control_localidades
before insert 
on DEPT
for each row
declare
    v_num number;
begin
    dbms_output.put_line('Trigger Control Localidades');
    select count(DEPT_NO) into v_num from DEPT 
    where UPPER(LOC)=UPPER(:new.loc);
    if (v_num > 0) then
        RAISE_APPLICATION_ERROR(-20001
        , 'Solo un departamento por ciudad ' || :new.LOC);
    end if;
end;


insert into DEPT values (6, 'MILANA', 'TERUEL');

DROP TRIGGER tr_dept_control_localidades;
-----------------------DIA 8 DE MAYO----------------

--Ejemplo integridad relacional con update
--si cambiamos un id de departamento que se modifiquen también 
--los empleados asociados

create or replace trigger tr_update_dept_cascade
before update ---aqui nos da igual usar un before o after
on DEPT
for each row
--quiero que salte este trigger solo cuando el id de departamento se ha cambiado
    when (new.DEPT_NO <> old.DEPT_NO)
declare

begin
    dbms_output.put_line('DEPT_NO cambiado');
    --modificar los datos asociados (EMP)
    update EMP set DEPT_NO =: new.DEPT_NO 
    where DEPT_NO =: old.DEPT_NO;
end;

select * from DEPT;
update DEPT set DNOMBRE ='PRODUCTORA' where dept_no=40;

update DEPT set DNOMBRE ='ZARAGOZA' where dept_no=30;
select * from EMP where DEPT_NO=31;
drop trigger tr_update_dept_cascade;

--Ejemplo: Impedir insertar un nuevo presidente si ya existe uno en la tabla EMP

create or replace trigger tr_dept_control_presidente
before insert 
on EMP
for each row
        when(upper(new.OFICIO) = 'PRESIDENTE')
declare
    v_num number;
begin
    dbms_output.put_line('Trigger Control Presidente');
    select count(EMP_NO) into v_num from EMP
    where UPPER(OFICIO)=UPPER(:new.oficio);
    if (v_num > 0) then
        RAISE_APPLICATION_ERROR(-20001
        , 'Solo un PRESIDENTE ');
    end if;
end;
DROP TRIGGER tr_dept_control_presidente;


insert into EMP VALUES (2222, 'GARCIA', 'PRESIDENTE', 
7566, SYSDATE, 12000, 2000, 20); 
insert into EMP VALUES (2222, 'GARCIA', 'PRESIDENTA', 
7566, SYSDATE, 12000, 2000, 20); 

select * from EMP;

--El resultado que da chatgpt
CREATE OR REPLACE TRIGGER evitar_segundo_presidente
BEFORE INSERT 
ON EMP
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    IF UPPER(:NEW.job) = 'PRESIDENTE' THEN
        SELECT COUNT(*) INTO v_count
        FROM EMP
        WHERE UPPER(job) = 'PRESIDENTE';
        
        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Ya existe un presidente en la tabla EMP.');
        END IF;
    END IF;
END;

--NO QUIERO QUE EXISTA MAS DE UNA LOCALIDAD SI HACEMOS UN UPDATE
create or replace trigger tr_dept_control_localidades
before UPDATE 
on DEPT
for each row
declare
    v_num number;
begin
    dbms_output.put_line('Trigger Control Localidades');
    select count(DEPT_NO) into v_num from DEPT 
    where UPPER(LOC)=UPPER(:new.loc);
    if (v_num > 0) then
        RAISE_APPLICATION_ERROR(-20001
        , 'Solo un departamento por ciudad ' || :new.LOC);
    end if;
end;

update DEPT SET LOC = 'CADIZ' where DEPT_NO=10;
--ME DA ERROR AL INSERTAR, PORQUE CON UPDATE O CON DELETE NO PUEDO USAR SELECT
SELECT * FROM dept;
rollback;
DROP TRIGGER tr_dept_control_localidades;

--SOLUCION:
--1) Necesito crear package para almacenar las variables entre triggers
create or replace package PK_TRIGGERS
as
    v_nueva_localidad DEPT.LOC%TYPE;
end PK_TRIGGERS;
--2) ALMACENO EN UN TRIGGER LA LOCALIDAD
create or replace trigger tr_dept_control_localidades
before UPDATE --en before he guardado la nueva localidad
on DEPT
for each row
declare
begin
  --almacenamos el valor de la nueva localidad
  PK_TRIGGERS.v_nueva_localidad := :new.LOC;
end;
--3) OTRO TRIGGER DE UPDATE PARA AFTER
create or replace trigger tr_dept_control_localidades_after
after UPDATE --en before he guardado la nueva localidad
on DEPT
declare
    v_numero NUMBER;
begin
    select count(DEPT_NO) into v_numero from DEPT
    where upper(LOC) = UPPER (PK_TRIGGERS.v_nueva_localidad);
    if (v_numero > 0) then
    RAISE_APPLICATION_ERROR(-20001, 'Solo un departamento por localidad');
    end if;
    dbms_output.put_line('Localidad nueva: ' || PK_TRIGGERS.v_nueva_localidad);
end;

update DEPT set LOC= 'CADIZ' where DEPT_NO=10;
DROP TRIGGER tr_dept_control_localidades_after;
DROP TRIGGER tr_dept_control_localidades;
-------------EXPLICACION:
--UPDATE FOR EACH ROW
    --PODEMOS USAR :NEW
    --NO PODEMOS USAR SELECT
--UPDATE
    --PODEMOS USAR SELECT
    --NO PODEMOS USAR :NEW
--PARA QUE RECORRA LA TABLA Y SABER SI ESTA O NO P.EJ LO LOCALIDAD NECESITAMOS FOR EACH ROW
--POR ELLO NECESITAMOS GURDAR LA VARIABLE :NEW PARA DESPUES USARLA EN UPDATE DONDE SI QUE PODEMOS USAR EL SELECT

--Creamos una vista con todos los datos de los departamentos
create or replace view vista_departamentos
AS
    select * from DEPT; 

--A partir de ahora solo trabajamos con la vista

select * from vista_departamentos;
insert into vista_departamentos values
(11, 'VISTA', 'SIN TRIGGER');

--Creamos un trigger sobre la vista
create or replace trigger tr_vista_dept
instead of insert
on vista_departamentos
declare
begin
    dbms_output.put_line('Insertado en vista DEPT');
end;
insert into vista_departamentos values
(11, 'VISTA', 'CON TRIGGER');

--VAMOS A CREAR UNA VISTA CON LOS DATOS DE LOS EMPLEADOS
--PERO SIN SUS DATOS SENSIBLES (salario, comision, fecha_alt)
create or replace view vista_empleados
as  
    select EMP_NO, APELLIDO, OFICIO, DIR, DEPT_NO from EMP;

select * from VISTA_EMPLEADOS;
insert into VISTA_EMPLEADOS values (5555, 'el nuevo', 'BECARIO', 7566, 31);

--si miramos en la tabla...
select * from EMP ORDER BY EMP_NO;
--CREAMOS UN TRIGGER RELLENANDO LOS HUECOS QUE QUEDAN DE EMP
create or replace trigger tr_vista_empleados
instead of insert
on vista_empleados
declare
begin
--con new capturamos los datos que vienen en la vista
--y rellenamos el resto
insert into EMP values (:new.EMP_NO, :new.APELLIDO, :new.OFICIO, 
:new.DIR, sysdate, 40000, 14000, :new.DEPT_NO);
end;
select * from EMP;

--Vamos a crear una vista para mostrar doctores
create or replace view vista_doctores
as  
    select DOCTOR.DOCTOR_NO, DOCTOR.APELLIDO, DOCTOR.ESPECIALIDAD,
    DOCTOR.SALARIO, HOSPITAL.NOMBRE
    from DOCTOR
    inner join HOSPITAL
    ON DOCTOR.HOSPITAL_COD = HOSPITAL.HOSPITAL_COD;

SELECT * FROM vista_doctores;

insert into VISTA_DOCTORES values (111, 'House2', 'Cardiologia', 40000, 'provincial');
--no podemos insertar porque los datos que queremos insertar estan en dos tablas distintas

CREATE OR REPLACE TRIGGER tr_vista_doctores
INSTEAD OF INSERT 
ON vista_doctores
FOR EACH ROW
DECLARE
    v_codigo HOSPITAL.HOSPITAL_COD%TYPE;
BEGIN
    select HOSPITAL_COD into v_codigo from HOSPITAL
    where upper(NOMBRE) = UPPER (:new.NOMBRE);
    INSERT INTO DOCTOR VALUES
    (v_codigo, :new.DOCTOR_NO, :new.APELLIDO, :new.ESPECIALIDAD, :new.SALARIO);
END;

drop trigger tr_vista_dept;
drop trigger tr_vista_empleados;
select * from DOCTOR;

