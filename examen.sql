--1)
CREATE TABLE Peliculas
  (IdPeliculas NUMBER(9) PRIMARY KEY
  ,idDistribuidor NUMBER(9)
  ,idGenero NUMBER(9)
  ,Titulo VARCHAR2(50)
  ,IdNacionalidad NUMBER(9)
  ,Argumento VARCHAR2(100)
  ,Foto VARCHAR2(30)
  ,Fecha_Estreno DATE
  ,Actores VARCHAR2(50)
  ,Director Varchar(10)
  ,Duracion NUMBER(5)
  ,Precio NUMBER(10)
);



CREATE TABLE Distribuidoras(
 IdDistribuidor NUMBER(9) PRIMARY KEY
 ,Distribuidor VARCHAR2(50)
 ,Direccion VARCHAR2(100)
 ,Email VARCHAR2(50)
 ,PaginaWeb VARCHAR2(50)
 ,Telefono NUMBER(9)
 ,Contacto VARCHAR2(50)
 ,Logo VARCHAR(50)
);

CREATE TABLE Pedidos(
    IdPedido NUMber(9) PRIMARY KEY
    ,IdCliente NUMber(9)
    ,IdPeliculas NUMber(9)
    ,Cantidad NUMber(9)
    ,Fecha DATE
    ,Precio NUMber(9)
);

CREATE TABLE Clientes(
    IdCliente NUMBER(9) PRIMARY KEY
    ,Nombre VARCHAR2(10)
    ,Direccion VARCHAR2(100)
    ,Email VARCHAR2(50)
    ,CPostal NUMBER(9)
    ,PaginaWeb VARCHAR2(100)
    ,Imagen_Cliente VARCHAR2(30)
);


CREATE TABLE Generos(
    IdGenero NUMBER(9) PRIMARY KEY
    ,Genero VARCHAR2(10)
);

CREATE TABLE Nacionalidad(
    IdNacionalidad NUMBER(9) PRIMARY KEY
    ,Nacionalidad varchar2(15)
    ,Bandera VARCHAR2(10)
);



    alter table Peliculas
add constraint FK_Peliculas_Distribuidoras
foreign key (IdDistribuidor) 
references Distribuidoras (IdDistribuidor);

alter table Peliculas
add constraint FK_Peliculas_Generos
foreign key (IdGenero) 
references Generos (IdGenero); 

alter table Peliculas
add constraint FK_Peliculas_Nacionalidad
foreign key (IdNacionalidad) 
references Nacionalidad (Nacionalidad); 

alter table Pedidos
add constraint FK_Pedidos_Peliculas
foreign key (IdPeliculas) 
references Peliculas (IdPeliculas); 

alter table Pedidos
add constraint FK_Pedidos_Clientes
foreign key (IdCliente) 
references Clientes (IdCliente); 

--2)
INSERT INTO CLIENTES VALUES (1, 'DELORIAN', 'C/Paseo Castellana 150', 'blockbuster@video.es', 28020, 
'http//www.delorian.es', 'delorian.jpg');

select * from CLIENTES;

INSERT INTO PEDIDOS VALUES ( 1, 1, 1, 10, TO_DATE('19/02/2007', 'DD-MM-YYYY'), 14);

INSERT INTO NACIONALIDAD VALUES (1, 'EEUU', 'EEUU.JPG');

INSERT INTO GENEROS VALUES (1, 'Accion');

insert into Distribuidoras values (1, '20th century box', 'c/miami vice, 19', 'sonnyckroket@century.es'
,'http//:www.fox.es', 915555555, 'Sonny Crocket', 'century.jpg');

insert into peliculas values (1, 1, 1, 'Cadena', 1, 'Acusado', 
'Cadena.jpg', TO_DATE('24/05/2005', 'DD-MM-YYYY'),
 'tim Robins', 'Frank', 142, 14);

 --3)
 CREATE OR PROCEDURE INSERTAR_CLIENTES
 ()

 create or replace procedure sp_insertar_clientes(

    p_id CLientES.IdCliente%TYPE
    ,p_nombre CLIENTES.NOMBRE%TYPE
    ,p_direccion CLIENTES.DIRECCION%TYPE
    ,p_email CLIENTES.EMAIL%TYPE
    ,P_postal Clientes.CPostal%type
    ,p_paginaWeb Clientes.PaginaWeb%type
    ,p_imagen CLIENTES.IMAGEN_Cliente%type
 )
as
begin
    insert into Clientes values (p_id, p_nombre, p_direccion, p_email, p_postal, p_paginaweb, p_imagen);
end;
--llamada al procediiento
BEGIN   
      p_insertar_clientes
END;


--4)

CREATE OR REPLACE FUNCTION PRECIO_PELICULA (
    p_IdPeliculas IN NUMBER
) RETURN NUMBER IS
    v_precio NUMBER;
BEGIN
    SELECT Precio
    INTO v_precio
    FROM Peliculas
    WHERE IdPeliculas = p_IdPeliculas;

    RETURN v_precio;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- o podrías devolver 0 o lanzar un error personalizado
END;

--5)

CREATE OR REPLACE PROCEDURE ACTUALIZAR_CLIENTE (
    p_IdCliente IN NUMBER,
    p_Email     IN VARCHAR2,
    p_Direccion IN VARCHAR2
) AS
BEGIN
    UPDATE Clientes
    SET Email = p_Email,
        Direccion = p_Direccion
    WHERE IdCliente = p_IdCliente;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Cliente no encontrado.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Datos actualizados correctamente.');
    END IF;
END;

--6)

CREATE OR REPLACE FUNCTION DURACION_PELICULA (
    p_Titulo IN VARCHAR2
) RETURN NUMBER IS
    v_duracion NUMBER;
BEGIN
    SELECT Duracion
    INTO v_duracion
    FROM Peliculas
    WHERE Titulo = p_Titulo;

    RETURN v_duracion;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL; -- o podrías devolver 0, -1 o lanzar un error
END;

--7)

CREATE OR REPLACE VIEW VistaPeliculasDetalle AS
SELECT
    P.Titulo,
    P.Fecha_Estreno AS Fecha,
    P.Actores,
    P.Argumento,
    G.Genero,
    N.Nacionalidad
FROM
    Peliculas P
    JOIN Generos G ON P.IdGenero = G.IdGenero
    JOIN Nacionalidad N ON P.IdNacionalidad = N.IdNacionalidad;

    select * from VistaPeliculasDetalle;

--8)

CREATE OR REPLACE PROCEDURE Mostrar_Peliculas AS
BEGIN
    FOR peli IN (SELECT Titulo, Genero, Nacionalidad FROM VistaPeliculasDetalle) LOOP
        DBMS_OUTPUT.PUT_LINE('Título: ' || peli.Titulo);
        DBMS_OUTPUT.PUT_LINE('Género: ' || peli.Genero);
        DBMS_OUTPUT.PUT_LINE('Nacionalidad: ' || peli.Nacionalidad);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;

