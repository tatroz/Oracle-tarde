---------------------------REGISTROS--------------------------
--bloque anónimo para recuperar el apellido, oficio y salario de empleados
--tengo opcion o declarar 3 variables o una variable que contiene estos tres campos
DECLARE
    --primero declaramos el tipo
    type type_empleado is record(
        v_apellido varchar2(50),
        v_oficio varchar2(50),
        v_salario number
    ); --solamente en encabezado de procedimientos y funciones tengo que indicar el tamaño de varchar2, 
        --pero en REGISTROS SI QUE LO TENGO QUE INDICAR
    --uso del tipo en una variable
    v_tipo_empleado type_empleado; --es cuando tengo una tabla y pongo DEPT%ROWTYPE 
    --pero en este caso pongo type_empleado
BEGIN
    select APELLIDO, OFICIO, SALARIO into v_tipo_empleado
    from EMP where EMP_NO=7839;
    dbms_output.put_line('Apellido ' || v_tipo_empleado.v_apellido 
    || ', Oficio ' || v_tipo_empleado.v_oficio
    || ', Salario ' || v_tipo_empleado.v_salario);
end;

------------------------ARRAYS---------------------------------

--Array es un tipo de dato, que es dinamic y la tabla 
--ARRAY table of es dinamico y el tamaño no es definido

--Por un lado tenemos la declaración del tipo
--por otro lado, tenemos la variable de dicho tipo

DECLARE
        --un tipo array para numeros
        type table_numeros IS TABLE OF NUMBER
        INDEX BY BINARY_INTEGER;
        --objeto para almacenar varios numeros
        lista_numeros table_numeros;
BEGIN
    --almacenamos datos en su interior
    lista_numeros(1) := 88;
    lista_numeros(2) := 99;
    lista_numeros(3) := 222; --si repito una posisción, la sustituye
    DBMS_OUTPUT.PUT_LINE('Numero elementos ' || lista_numeros.count);
    --podemos recorrer todos los registros(numeros) que tengamos
    for i IN 1..lista_numeros.count loop
            DBMS_OUTPUT.PUT_LINE('Numero: ' || lista_numeros(i));
    end loop;
end;

--almacenamos a la vez
--guardamos un tipo fila de departamento

DECLARE
    type table_dept is table of DEPT%ROWTYPE INDEX BY
    BINARY_INTEGER;
    --declaramos el objeto para almacenar filas
    lista_dept table_dept;
BEGIN
    select * into lista_dept(1) from DEPT where DEPT_NO=10;
    select * into lista_dept(2) from DEPT where DEPT_NO=30;
   for i in 1..lista_dept.count
   loop
        --DBMS_OUTPUT.PUT_LINE(lista_dept(1)); --en lista_dept(1) tengo almacenado toda la fila del departamento 10
        DBMS_OUTPUT.PUT_LINE(lista_dept(i).DNOMBRE || ' ,' || lista_dept(i).LOC);    
    end loop;
end;

--VARRAY es estatico y hay que indicar cuantos elementos vamos a tener, 
--por lo demas se parece al table of

DECLARE
    CURSOR cursorEmpleados IS
    SELECT apellido FROM EMP;
    type c_lista is varray (20) of EMP.APELLIDO%TYPE;
    lista_empleados c_lista := c_lista();
    contador integer := 0;
BEGIN
    FOR N IN cursorEmpleados 
    LOOP
        contador := contador +1; --quiero que el contador vaya de 1 en 1
        lista_empleados.extend;
        lista_empleados(contador) := n.apellido;
        DBMS_OUTPUT.PUT_LINE('Empleado(' || contador
        || ') :' || lista_empleados(contador));
    END LOOP;
end;




