--INCLUIMOS UNA RESTRICCION PRIMARY KEY EN EL CAMPO
--DEPT_NO DE DEPARTAMENTOS PARA QUE NO PUEDA ADMITIR NULOS
alter table DEPT
add constraint PK_DEPT
primary key (DEPT_NO);

alter table EMP
add constraint FK_EMP_DEPT
foreign key (DEPT_NO)
references DEPT (DEPT_NO);



delete from DEPT where dept_no=10;
commit;
--TODAS LAS RESTRICCIONES DEL USUARIO SE ENCUENTRAN EN EL DICCIONARIO
--USER_CONSTRAINTS
select * from USER_CONSTRAINTS;
--INTENTAMOS INSERTAR UN DEPARTAMENTO REPETIDO
insert into DEPT values (10, 'REPE', 'REPE');
select * from DEPT;
--ELIMINAMOS LA RESTRICCION DE PRIMARY KEY DE DEPARTAMENTOS
alter table DEPT
drop constraint PK_DEPT;


-----------------------------EMPLEADOS---------------------------
--CREAMOS UNA PRIMARY KEY PARA EL CAMPO EMP_NO
alter table EMP
add constraint PK_EMP
primary key (EMP_NO);


--CREAMOS UNA RESTRICCION PARA COMPROBAR QUE EL SALARIO SIEMPRE SEA POSITIVO
--CH_TABLA_CAMPO
alter table EMP
add constraint CH_EMP_SALARIO
check (SALARIO >= 0);


--PONEMOS UN VALOR NEGATIVO A UN EMPLEADO
update EMP set SALARIO = null where EMP_NO=7782;


alter table EMP
drop constraint CH_EMP_SALARIO;


select * from EMP;
-----------------------------------------ENFERMO


--PK
alter table ENFERMO
add constraint PK_ENFERMO
primary key (INSCRIPCION);
--UNIQUE PARA EL DATO DE NSS, SEGURIDAD SOCIAL
alter table ENFERMO
add constraint U_ENFERMO_NSS
unique (NSS);


--no podemos repetir PK
insert into ENFERMO values
(10995, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '123');
--no podemos repetir Unique
insert into ENFERMO values
(10999, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '280862482');
--nulos en pk?? NO
insert into ENFERMO values
(null, 'Nuevo', 'Calle nueva', '01/01/2000', 'F', '123');
--nulos en unique?? POR SUPUESTO SI LA COLUMNA LO ADMITE
insert into ENFERMO values
(12346, 'Nuevo null', 'Calle nueva', '01/01/2000', 'F', null);


select * from ENFERMO;
describe enfermo;


select * from ENFERMO;

insert into ENFERMO VALUES
('11995', 'Languia M', 'Goya 20', '16/05/1956', 'M','280862482')
--en este caso tenemos un paciente que ha ingresado el dia 16/05, si creamos solo una clave primaria asociada 
--al num. de la SS, no meva a permitir insertar al mismo paciente. Para solucionarlo se cree una primary key doble

--ELIMINAMOS LAS DOS RESTRICCIONES ANTERIORES
--QUITAMOS LOS NULL PARA REALIZAR LA INSCRIPCION

delete from ENFERMO where NSS is null;
commit;

--eliminamos las dos restricciones anteriores

alter table ENFERMO
drop constraint PK_ENFERMO;
alter table ENFERMO
drop constraint U_ENFERMO_NSS;

--CREAMOS UNA PRIMARY KEY DE DOS COLUMNAS

alter table ENFERMO
add constraint PK_ENFERMO
primary key (INSCRIPCION, NSS);

--INTENTAMOS CREAR UN REGISTRO CON LOS DATOS IGUALESDE INSCRIPCION Y NSS

select * from ENFERMO;

insert into ENFERMO VALUES
('12995', 'Languia M', 'Goya 20', '16/05/1956', 'M','280862482');

insert into ENFERMO VALUES
('11995', 'Languia M', 'Goya 20', '16/05/1956', 'M','280862482');

--LA FOREIGN KEY SIEMPRE SE APLICA A LA TABLA DE MUCHOS
--EJEMPLO MUCHOS PEDIDOS PARA UN CLIENTE, ENTONCES FOREIGN KEY SE APLICARIA A LA TABLA DE PEDIDOS
-----------------------------------------------------------------------------------

-----------------------------FOREIGN KEY--------------------------------------------

--CREAMOS UNA RELACION ENTRE EMPLEADOS Y DEPARTAMENTOS
--EL CAMPO DE RELACION ES DEPT_NO

alter table EMP
add constraint FK_EMP_DEPT
foreign key (DEPT_NO)
references DEPT (DEPT_NO);

--PARA QUE ESTO FUNCIONE ES NECESARIO CREAR PRIMARY KEY O UNIQUE

select * from DEPT;
delete from DEPT where dept_no=60;

insert into DEPT values(10, 'CONTABILIDAD', 'ELCHE');

--INSERTAMOS UN EMPLEADO EN UN DEPARTAMENTO QUE NO EXISTE

insert into EMP values (1111, 'nulo', 'EMPLEADO', 7902, '02/04/2025', 1, 1, null);
select * from EMP;
rollback;

--VAMOS A PROBAR LAELIMINACION EN CASCADA Y SET NULL EN CASCADA

delete from DEPT where DEPT_NO=10;

alter table EMP
drop constraint FK_EMP_DEPT;


alter table EMP
add constraint FK_EMP_DEPT
foreign key (DEPT_NO)
references DEPT (DEPT_NO)
on delete CASCADE; ---NUNCA HAY QUE USARLO PORQUE SE ELIMINAN TODOS LOS DATOS RELACIONADOS
--EN ESTE CASO HEMOS ELIMANADO A TODOS LOS EMPLEADOS QUE PERTENECEN AL DEP. 10

--OTRA OPCION ES ESTA
--EN ESTE CASO PONDRA UN NULL EN VEZ DEL DEP. 10

alter table EMP
add constraint FK_EMP_DEPT
foreign key (DEPT_NO)
references DEPT (DEPT_NO)
on delete set null;

select * from EMP;