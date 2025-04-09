----------CAMPOS DE AUTOINCREMENTACION-----------

--INSER ALL sirve solo para los valores estaticos

--CREAMOS SECUENCIA PARA DEPARTAMENTOS

create sequence seq_dept
increment by 10
start with 50;


--UNA SECUENCIA NO SE PUEDE MODIFICAR, SOLO ELIMINAR Y CREAR DE NUEVO
--TODAVIA NO HEMOS UTILIZADO LA SECUENCIA

select seq-dept.nextval as SIGUIENTE from DUAL;--LA PRIMERA VEZ QUE LO EJECUTO ME VA A DAR EL VALOR DE START WITH

--NO PODEMOS ACCEDER A CURRVAL HASTA QUENO HEMOS EJECUTADO NEXVAL

select seq_dept.currval as ACTUAL from DUAL;

--SI LO QUEREMOS PARA INSERT DEBEMOS LLAMARLO DE FROMA EXPLICITA

insert into DEPT values (seq_dept.nextval, 'NUEVO', 'NUEVO');
select * from DEPT;

DELETE FROM DEPT WHERE DEPT_NO>40;
--EN CASO DE QUE LA SEQUENCIA NO ES CORRECTA HAY QUE ELIMAR LA SEQUENCIA Y VOLVER A  CREARLA

drop sequence seq_dept;

--SI CURRVAL ESTA EN 5 Y INCREMENT BY ES 11, NEXTVAL VA A SER 16

--UNA SECUENCIA NO ESTA ASOCIADA A NINGUNA TABLA

select * from HOSPITAL;
insert into HOSPITAL values (SEQ_DEPT.nextval, 'El Carmen', 'Calle Pex', '12345', 125);

---------------------------PRACTICA ----------------------------------------------------------------------------

1) NECESITAMOS UNA CLAVE PRIMARIA (PK) EN HOSPITAL

alter table HOSPITAL
add constraint PK_HOSPITAL
primary key (HOSPITAL_COD);

2) NECESITAMOS UNA CLAVE PRIMARIA (PK) EN DOCTOR

alter table DOCTOR
add constraint PK_DOCTOR
primary key (DOCTOR_NO);

3) RELACIONAR DOCTORES CON HOSPITALES

alter table DOCTOR
add constraint FK_DOCTOR_HOSPITAL
foreign key(HOSPITAL_COD)
references HOSPITAL (HOSPITAL_COD);

4) LAS PERSONAS DE LA PLANTILLA SOLAMENTE PUEDEN TRABAJAR EN TURNOS DE MAÑANA, TARDE O NOCHE (T, N, M)

alter table PLANTILLA
add constraint CH_PLANTILLA_TURNO
check (TURNO IN ('T', 'M', 'N')); --CHECK ES UN WHERE

-----------

DROP TABLE DEPT cascade CONSTRAINTS; -- permite eliminar las tablas con las restricciones


------------------------------DATA MODELER--------------------------------------------
--ARCHIVO->DAA MODELER -->IMPORTAR -->DICCIONARIO DE DATOS-->seleccino la base de dato--> siguiente-->selec. SYSTEM

---------------------------------------EJERCICIOS-------------------------------------------------

---1) Crear la tabla COLEGIOS con los siguientes campos

--Campos			Tipo de dato		Restricción 

Cod_colegio		Numérico		Clave Principal e Identidad 

Nombre			Texto	20 letras	No permite nulos. 

Localidad			Texto 15 letras 

Provincia			Texto 15 letras 

Año_Construcción	Fecha 

Coste_Construcción	Numérico 

Cod_Region		Numérico 

Unico			Numérico		Clave Unica 

 

----Utilizar una secuencia para insertar Colegios 

CREATE TABLE COLEGIOS 
    (COD_COLEGIO number(*,0)
    ,NOMBRE varchar2(20) not null
    ,LOCALIDAD varchar2(15)
    ,PROVINCIA varchar(15)
    ,ANYO_CONSTRUCCION date 
    ,COSTE_CONSTRUCCION number(*,0)
    ,COD_REGION number(*,0)
    ,UNICO number(*,0)
    );

    alter table COLEGIOS
    add constraints PK_COLEGIOS
    primary key (COD_COLEGIO);

    alter table COLEGIOS
    add constraint U_COLEGIOS_UNICO
    UNIQUE (UNICO);

    create sequence seq_colegios
    increment by 1
    start with 1;

select SEQ_COLEGIOS.nextval as siguiente from DUAL;

drop sequence seq_colegios;
select SEQ_COLEGIOS.currval as ACTUAL from DUAL;

INSERT INTO COLEGIOS values 
(SEQ_COLEGIOS.nextval, 'NUEVO', 'NUEVO','NUEVO', '12/12/1960', 30000, 300, 3000);

select * from COLEGIOS;
    
-----2) Crear la tabla PROFESORES con los siguientes campos
    CREATE TABLE PROFESORES
        (COD_PROFE varchar2(3) not null
        ,NOMBRE varchar2(60) not null
        ,APELLIDO1 varchar2(50)
        ,APELLIDO2 varchar(50)
        ,DNI varchar2(9)
        ,LOCALIDAD varchar2(50)
        ,PROVINCIA varchar2(50)
        ,SALARIO number(*,0)
        ,COD_COLEGIO number(*,0)
        ,SEXO varchar2(1)
        ,ESTADOCIVIL varchar(20)
        ,FECHA_NACIMIENTO date
        );

    alter table PROFESORES
        drop column SEXO;

            alter table PROFESORES
        drop column ESTADOCIVIL;

            alter table PROFESORES
        drop column FECHA_NACIMIENTO;

    select * from PROFESORES;

        alter table PROFESORES
        add constraints PK_PROFESORES
        primary key (COD_PROFE);

        alter table PROFESORES
        add constraint U_PROFESORES_UNICO
        UNIQUE (DNI);

        alter table PROFESORES
        add constraint FK_PROFESORES_COLEGIOS
        foreign key (COD_COLEGIO)
        references COLEGIOS (COD_COLEGIO);


---3) Crear la tabla REGIONES con los siguientes campos: 

CREATE TABLE REGIONES
    (COD_REGION number(*,0)
    ,REGIONES varchar(20) not null
    );

    alter table REGIONES
    add constraint PK_REGIONES
    primary key (COD_REGION);

--4) Crear la tabla ALUMNOS con los siguientes campos: 

CREATE TABLE ALUMNOS
    (DNI varchar2(9) not null
    ,NOMBRE varchar(50) not null
    ,APELLIDOS varchar (50)
    ,FECHA_INGRESO date
    ,FECHA_NAC date
    ,LOCALIDAD varchar(15)
    ,PROVINCIA varchar(30)
    ,COD_COLEGIO number(*,0)
    );

    drop table ALUMNOS;

    alter table ALUMNOS
    add constraint PK_ALUMNOS
    primary key (DNI);

    alter table ALUMNOS
    add constraint FK_ALUMNOS_COLEGIOS
    foreign key (COD_COLEGIO)
    references COLEGIOS (COD_COLEGIO);

--5) Crear una nueva relación entre el campo Cod_Region de la tabla 
--REGIONES y Cod_Region de la tabla colegios. 

    alter table COLEGIOS
    add constraint FK_COLEGIOS_REGIONES
    foreign key (COD_REGION)
    references REGIONES (COD_REGION);

--6) Añadir el campo Sexo, Fecha de nacimiento y Estado Civil a la tabla Profesores. 

ALTER TABLE PROFESORES
ADD (SEXO varchar2(20)
, ESTADO CIVIL (20)
, FECHA_NACIMIENTO date);