
--CUANDO SABEMOS EL INICIO Y EL FINAL

DECLARE
    suma int;
BEGIN
    suma := 0;
    dbms_output.put_line ('Inicio');
    goto codigo;
    dbms_output.put_line ('Antes del bucle');
    for contador in 1..100 loop
        suma := suma + contador;
    end loop;
    <<codigo>>
    dbms_output.put_line ('Despues del bucle');
    dbms_output.put_line('La suma de los primeros 100 númereos es' || suma);
end;

 -- null me permite finalizar una instruccion
        --debemos iniciar las variables

    i := 


   ----------------------- --EJEMPLOS----------------------------------------------------
--BUCLE PARA MOSTRAR LOS NUMEROS ENTRE 1 Y 10
--1) BUCLE WHILE

DECLARE
    i int;
BEGIN
    i := 1;
    while i <= 10 loop
        dbms_output.put_line(i);
      i := i+1;  
end loop;
        dbms_output.put_line('Fin del bucle while');
end;

--2) BUCLE FOR

declare

BEGIN
    for i in 1..10 loop
        dbms_output.put_line (i);
    end loop;
    dbms_output.put_line('Fin del bucle For');
end;

--PEDIR AL USUARIO UN NUMERO INICIO &inicio Y UN NUMERO FINAL
-- MOSTRAR LOS NUMEROS COMPRENDIDOS ENTRE DICHO RANGO

DECLARE
   inicio int;
   fin int;
BEGIN
    inicio := &inicial;
    fin := &final;
    for i in inicio..fin loop   
        dbms_output.put_line (i);
end loop;
    dbms_output.put_line ('fin de programa');
END;
undefine inicial;
undefine final;

--SI EL NUMERO ES MAYOR NO HACEMOS EL BUCLE

declare
   inicio int;
   fin int;
BEGIN
    inicio := &inicial;
    fin := &final;
   --PREGUNTAMOS POR LOS VALORE DE LOS NUMEROS
   if (inicio >= fin) Then
   dbms_output.put_line('El numero de inicio ('|| inicio ||
   ') debe ser menor al numero de fin ('|| fin ||')');
   else
        for i in inicio..fin loop
         dbms_output.put_line (i);
    end loop;
   end if;
        dbms_output.put_line ('fin de programa');
end;
undefine inicial;
undefine final;

--QUEREMOS UN BUCLE PIDIENDO UN INICIO Y UN FIN
--MOSTRAR LOS NUMEROS PARES COMPRENDIDOS ENTRE DICHO INICIO Y FIN

declare 
    inicio int;
    fin int;
begin 
    inicio := &inicial;
    fin := &final;
       for i in inicio..fin loop
       if (mod (i, 2) = 0) then -- para impares if MOD (i, 2) <>0 then
    dbms_output.put_line (i);
  end if;
end loop;
        dbms_output.put_line ('fin de programa');
end;
undefine inicial;


undefine final;

--CONJETURA DE COLLATS
--LA TEORIA INDICA QUE CUALQUIERNUMERO SIEMPRE LLEGARA A SER 1
--siguiendo una serie de instrucciones;
--Si el numero es par, se divide entre 2
--Si el numero es impar, se multiplica por 3 y sumamos 1
-- 6,3,10,5,16,8,4,2,1

declare 
        numero int;

begin   
        numero := &valor;
     while numero <> 1 loop
        --averiguamos si es par/impar
    if (mod (numero,2) =0) then
        numero := numero/2;
    else
       numero := numero*3+1;
    end if;
            dbms_output.put_line(numero);
    end loop;
    end;
undefine valor;

-- MOSTRAR LA TABLA DE MULTIPLICAR DE UN NUMERO QUE PIDAMOS AL USUARIO

declare
        numero int;
        operacion int;
begin
        numero := &valor;
for i in 1..10  loop
        operacion := numero*i;
        dbms_output.put_line (numero || '*' || i || '=' || operacion);
end loop;
        dbms_output.put_line ('Fin de programa');
end;
undefine valor;

--QUIERO UN PROGRAMA QUE NOS PEDIRÁ UN TEXTO
--DEBEMOS RECORRER DICHO TEXTO LETRA A LETRA, ES DECIR, MOSTRAMOS 
--cada una de las letras de forma individual

declare
    v_texto varchar2(50);
    v_longitud int;
    v_letra varchar2(1);
begin 
    v_texto := '&texto';
    --un elemento en oracle empieza en 1
    v_longitud :=length(v_texto);
    for i in 1..v_longitud loop
        v_letra := substr(v_texto,i,1); --con i indicamos que queremos todas las letras del texto y 1 que queremos solo un caracter
        dbms_output.put_line(v_letra);
    end loop;
        dbms_output.put_line('Fin de programa');
end;
undefine v_texto;

--NECESITO UN PROGRAMA DONDE EL USUARIO INTRODUCIRÁ UN TEXTO NUMÉRICO: 1234
--NECESITA MOSTRAR LA SUMA DE TODOS LOS CARACTERES NUMÉRICOS EN UN MENSAJE

DECLARE

    v_texto_numero varchar2(50);
    v_long int;
    v_letra char(1);
    v_numero int;
    v_suma int;  

BEGIN
    v_suma := 0;
    v_texto_numero := &texto;
    v_long := length(v_texto_numero);
for i in 1..v_long loop
    v_letra := substr(v_texto_numero,i,1);
    --'1' --> 1
    --dbms_output.put_line(v_letra);
    v_numero := to_number(v_letra);
    v_suma :=v_suma + v_numero;
end loop;
        dbms_output.put_line('La suma de' || v_texto_numero || 'es' || v_suma);
end; 

--Dropbox talentodigitaloraclee@outlook.es/  Oracle12345_

declare
    v_texto_numero varchar2(50);
    v_longitud int;
    v_letra char(1);
    v_numero int;
    v_suma int;
begin
    v_suma := 0;
    v_texto_numero := &texto;
    v_longitud := length(v_texto_numero);
    for i in 1..v_longitud loop
        v_letra := substr(v_texto_numero, i, 1);
        v_numero := to_number(v_letra);
        v_suma := v_suma + v_numero;
    end loop;
    dbms_output.put_line('La suma de ' || v_texto_numero || ' es ' || v_suma);
end;
undefine texto;