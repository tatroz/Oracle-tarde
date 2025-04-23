


---CURSORES
--BLOQUE PARA CONSULTAS DE ACCION
--INSERTAR 5 DEPARTAMENTO EN UN BLOQUE PL/SQL

DECLARE
    v_nombre dept.dnombre%type; --que coje el tipo de la tabla dept, es decir que se adapte al tipo de esta tabla
    v_loc dept.loc%type; --que sea de tipo varchar, etc
BEGIN
    --vamos a realizar un bucle para insertar 5 departamentos
    for i in 1..5 loop
        v_nombre := 'Departamento' || i;
        v_loc := 'Localidad' || i;
        insert into DEPT values (i, v_nombre, v_loc);
    end loop;
    dbms_output.put_line ('Fin de programa');
end;

select * from DEPT;



DECLARE
    v_nombre dept.dnombre%type; --que coje el tipo de la tabla dept, es decir que se adapte al tipo de esta tabla
    v_loc dept.loc%type; --que sea de tipo varchar, etc
BEGIN
    --vamos a realizar un bucle para insertar 5 departamentos
    for i in 1..5 loop
        v_nombre := 'Departamento' || i;
        v_loc := 'Localidad' || i;
        insert into DEPT values (
            (SELECT MAX(DEPT_NO) + 1 FROM DEPT), v_nombre, v_loc);
    end loop;
    dbms_output.put_line ('Fin de programa');
end;
rollback;

--REALIZAR UN BLOQUE DE PL/SQL QUE PEDIRÁ UN NUMERO AL
--USUARIO Y MOSTRARÁ EL DEPARTAMENTO CON DICHO NUMERO

DECLARE
    v_id int;
BEGIN
    v_id := &numero;
    select * from DEPT where DEPT_NO=v_id; --NUNCA SE PUEDE HACER LA CONSULTA SELECT EN PL/SQL/ 
    --INSERT, DELETE, UPDATE SI QUE FUNCIONAN
end;
undefine numero;

--LA UNICA FORMA EN QUE PODRIAMOS USAR SELECTDENTRO PL/SQL ES GUARDANDOLO EN UNA VARIABLE
--FETCH NOS PERMITE MOVERSE DE UNA FILA A LA OTRA CON MICURSOR

--CURSORES IMPLICITOS SOLAMENTE PUEDEN DEVOLVER UNA FILA y siempre una fila
--recuperar el oficio del empleado REY

DECLARE
    v_oficio EMP.OFICIO%TYPE;
BEGIN
    select OFICIO into v_oficio from EMP where upper(APELLIDO) = 'REY';
    dbms_output.put_line ('El oficio de REY es...' || v_oficio);
end;

--CURSOR EXPLICITO
--PUEDEN DEVOLVER MAS DE UNA FILA Y ES NECESARIO DECLARARLOS
--mostrar el apellido y salario de todos los empleados

DECLARE
        v_ape EMP.APELLIDO%type;
        v_sal EMP.SALARIO%type;
        --declaramos nuestro cursor con una consulta (almacenar una consulta en una variable)
        --la consulta debe tener los mismos datos para luego hacer el fetch
        cursor CURSOREMP IS
        SELECT APELLIDO, SALARIO from EMP;
BEGIN
        -- 1)ABRIR EL CURSOR
        open CURSOREMP;
        --el bucle infinito
        LOOP
         --2) EXTRAEMOS LOS DATOS DEL CURSOR
         fetch CURSOREMP into v_ape, v_sal;
         --3) PREGUNTAMOS SI HEMOS TERMINADO
         exit when CURSOREMP%NOTFOUND;
         --DIBUJAMOS LOS DATOS
        dbms_output.put_line ('Apellido:' || v_ape || ', Salario:' || v_sal);
        end loop;
        --3) CERRAMOS EL CURSOR
        close CURSOREMP;
end;

select * from EMP where APELLIDO='GUTIERREZ';

--ROWCOUNT SE UTILIZA PARA LAS CONSULTAS DE ACCIÓN
--incrementar en 1 el salario de los empleados del departamento 10
--mostrar el numero de empleados modificados

BEGIN
    update EMP set SALARIO=SALARIO +1
    where DEPT_NO = 10;
    dbms_output.put_line('Empleados modificados:' || SQL%ROWCOUNT);
END;

--INCREMENTAR EN 10.000 AL EMPLEADO QUE MENOS COBRE EN LA EMPRESA
--1)¿que necesito para esto?
--minimo salario IMPLICITO (SOLO MODIFICO A UNO)
--2) ¿que más? update a ese salario


DECLARE
    v_minimo_salario EMP.SALARIO%TYPE;
BEGIN
    --realizamos una consulta para recuperar el mínimo salario
    select min(SALARIO) into v_minimo_salario from EMP;
    UPDATE EMP set SALARIO= SALARIO+10000
    where SALARIO= v_minimo_salario;
    --dbms_output.put_line ('Salario incrementado a ...' || SQL%ROWCOUNT || ' empleados');
end;



DECLARE
    v_minimo_salario EMP.SALARIO%TYPE;
    v_apellido EMP.APELLIDO%TYPE;
BEGIN
    --realizamos una consulta para recuperar el mínimo salario
    select min(SALARIO) into v_minimo_salario from EMP;
    select APELLIDO into v_apellido from EMP
    where SALARIO= v_minimo_salario;
    UPDATE EMP set SALARIO= SALARIO+10000
    where SALARIO= v_minimo_salario;
    dbms_output.put_line ('Salario incrementado a ...' || SQL%ROWCOUNT || ' empleados, ' || v_apellido);
end;

--Realizar un código de PL/SQL dónde pediremos 
--el número, nombre y localidad de un departamento
--Si el departamento existe modificamos su nombre y localidad
--si el departamento no existe, lo insetamos

select * from DEPT;
--
DECLARE
        v_id DEPT.DEPT_NO%TYPE;
        v_nombre DEPT.DNOMBRE%TYPE;
        v_localidad DEPT.LOC%TYPE;
        v_existe DEPT.DEPT_NO%TYPE;
        cursor CURSORDEPT IS
        SELECT DEPT_NO from DEPT
        where DEPT_NO =v_id;
BEGIN
        v_id := &iddepartamento;
        v_nombre:= '&nombre';
        v_localidad := '&localidad';    
        open CURSORDEPT;
         --2) EXTRAEMOS LOS DATOS DEL CURSOR
         fetch CURSORDEPT into v_existe;
            if (CURSORDEPT%NOTFOUND) then
                dbms_output.put_line ('Insert');
                insert into DEPT values (v_id, v_nombre, v_localidad);
            ELSE 
                dbms_output.put_line ('Update');
                update DEPT set DNOMBRE=v_nombre, LOC= v_localidad
                where DEPT_NO=v_id;
        end if; 
        close CURSORDEPT;
end;
ROLLBACK;
undefine iddepartamento;
undefine nombre;
undefine localidad;





     /*   select DEPT_NO into v_existe from DEPT --aqui vemos si existe o no y si insertamos el numero del dept que no existe 
        --el cursor implicito nos devuelve un error porque el implicito siempre tiene que devolver una fila
        where DEPT_NO= v_id;
        if  (v_existe is null) then 
            dbms_output.put_line ('Insert');
        else
            dbms_output.put_line ('Update');
        end if;
        end loop;
        close CURSORDEPT;
end;
        if CURSORDEPT%FOUND;
            update DEPT set v_nombre, v_loc
        ELSE CURSOREMP%NOTFOUND
            insert into v_dptno, v_nombre, v_loc;
        dbms_output.put_line ('Numero del departamento')
        end loop;
        --close CURSORDEPT;
END;*/

DECLARE
        v_id DEPT.DEPT_NO%TYPE;
        v_nombre DEPT.DNOMBRE%TYPE;
        v_localidad DEPT.LOC%TYPE;
        v_existe DEPT.DEPT_NO%TYPE;
BEGIN
        v_id := &iddepartamento;
        v_nombre:= '&nombre';
        v_localidad := '&localidad';   
        select COUNT(DEPT_NO) into v_existe from DEPT --aqui vemos si existe o no y si insertamos el numero del dept que no existe 
        --el cursor implicito nos devuelve un error porque el implicito siempre tiene que devolver una fila
        where DEPT_NO= v_id;
        if  (v_existe = 0) then 
            dbms_output.put_line ('Insert');
            insert into DEPT values (v_id, v_nombre, v_localidad);
        else
            dbms_output.put_line ('Update');
            update DEPT set DNOMBRE=v_nombre, LOC= v_localidad
                where DEPT_NO=v_id;
        end if;
end;


--REALIZAR UN CODIGO PL/SQL PARA MODIFICAR EL SALARIO DEL
--EMPLEADO ARROYO
--Si el empleado cobra más de 250.000, le bajamos el sueldo en 10.000
--Sino, le subimos el sueldo en 10.000


declare
    v_salario EMP.SALARIO%TYPE;
    v_idemp EMP.EMP_NO%TYPE;
BEGIN
    SELECT EMP_NO, SALARIO into v_idemp,  v_salario from EMP
    where UPPER(APELLIDO)='ARROYO';
if  v_salario > 250000 then
    v_salario := v_salario-10000; 
else 
    v_salario := v_salario +10000;
END IF;
    update EMP set SALARIO=v_salario
    where EMP_NO=v_idemp;
    dbms_output.put_line ('Salario modificado: ' || v_salario);
end;



/*DECLARE
        v_salario emp.salario%type;
        v_idemp EMP.EMP_NO%TYPE;
        v_existe emp.salario%type;
        cursor CURSOREMP IS
        SELECT SALARIO from EMP
        where SALARIO> v_salario;
BEGIN
       v_salario :=250000;
        open CURSOREMP;
         --2) EXTRAEMOS LOS DATOS DEL CURSOR
         fetch CURSOREMP into v_existe;
            if (v_existe is null) then
                dbms_output.put_line ('Subir en 10000');
                update EMP set salario=salario+10000 where SALARIO <250000;
            ELSE 
                dbms_output.put_line ('Bajar EN 10000');
                update EMP set SALARIO=SALARIO-10000;
        end if; 
        close CURSOREMP;
end;

select COUNT(SALARIO) from EMP WHERE SALARIO>250000;*/

--NECESITAMOS MODIFICAR EL SALARIO DE LOS DOCTORES DE LA PAZ
--Si la suma salarial supera 1.000.000 bajamos salarios en 10.000 a todos
--Si la suma salarial no supera el millón, subimos salarios en 10.000
--Mostrar el número de filasque hemos modificado (subir o bajar)
--Empleados con suerte: 6, Empleados más pobres:6

DECLARE
        v_salario 
BEGIN

end


select * from PLANTILLA;

kkkk