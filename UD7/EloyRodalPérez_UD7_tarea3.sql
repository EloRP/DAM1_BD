--ELOY RODAL PÉREZ
USE CATASTRO
USE EMPRESANEW2

--Sobre la Base de datos CATASTRO

--1. a) El ayuntamiento desea poder conocer la edad de los propietarios, para ello va a incluir en la tabla propietario la fecha de nacimiento y un campo que mostrará la edad de éste. 
		--La edad se obtiene a partir de la fecha de nacimiento
ALTER TABLE PROPIETARIO
ADD FECHA_NACIMIENTO DATE NULL

ALTER TABLE PROPIETARIO
ADD EDAD AS DATEDIFF(yy,FECHA_NACIMIENTO,GETDATE())+CASE
	WHEN (MONTH(GETDATE()) < MONTH(FECHA_NACIMIENTO))
	OR (MONTH(GETDATE())= MONTH(FECHA_NACIMIENTO) AND DAY(GETDATE()) < DAY(FECHA_NACIMIENTO))
	THEN -1 ELSE 0 END;
	
SELECT * FROM PROPIETARIO

--b)Se sabe la fecha de nacimiento de los siguientes propietarios:

--Lucas López Sánchez nació el 12-03-1965, María Rodríguez Ramos 25-02-1980, María Galán Sánchez el 23-09-1990, Malena Franco Valiño el 07-07-1985 , 
-- Mónica Rodríguez Tena y  Manolo Ramos Galán nacieron el día de navidad del mismo año que Malena Franco Valiño y Jorge Juan Arranz Pérez nació dos meses antes que Lucas López Sánchez.

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '12-03-1965'
WHERE NOMBRE='Lucas' AND APELLIDO1='López' AND APELLIDO2='Sánchez'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-02-1980'
WHERE NOMBRE='María' AND APELLIDO1='Rodríguez' AND APELLIDO2='Ramos'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '23-09-1990'
WHERE NOMBRE='Malena' AND APELLIDO1='Franco' AND APELLIDO2='Valiño'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-12-1990'
WHERE NOMBRE='Mónica' AND APELLIDO1='Rodríguez' AND APELLIDO2='Tena'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-12-1990'
WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Galán'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = DATEADD(mm,-2,
	    			   (SELECT FECHA_NACIMIENTO
						FROM PROPIETARIO 
						WHERE NOMBRE='Lucas' AND APELLIDO1='López' AND APELLIDO2='Sánchez')					
WHERE NOMBRE='Jorge Juan' AND APELLIDO1='Arranz' AND APELLIDO2='Pérez'

SELECT * FROM PROPIETARIO

--2.- Se ha creado una nueva zona urbana llamada La capilla, con las mismas características que Cuatrovientos excepto que tiene un parque menos 
 -- y en ella se ha construido una calle urbanizable llamada ReaL  con el Código postal 27802.    
 -- En esta calle se ha construido una urbanización de 5 casas con piscina y todas con la misma estructura: 
 -- 400 metros de solar, tienen planta baja, primera y buhardilla y 300 metros construidos. Los números comienzan en 1 y solo se almacena números impares. 
 -- Se han vendido 3 casas a dos nuevos propietarios que son hermanos: Carolina y Juan Pérez Vila.  

INSERT INTO ZONAURBANA
VALUES('La capilla', 'Este', 2, NULL)

INSERT INTO VIVIENDA
VALUES('Real', 1, 'Casa', 27802, 400, 'La capilla'),
	  ('Real', 3, 'Casa', 27802, 400, 'La capilla'),
	  ('Real', 5, 'Casa', 27802, 400, 'La capilla'),
	  ('Real', 7, 'Casa', 27802, 400, 'La capilla'),
      ('Real', 9, 'Casa', 27802, 400, 'La capilla')

INSERT INTO CASAPARTICULAR
VALUES('Real', 1, 2, 'S', 300, '65656565M'),
	  ('Real', 3, 2, 'S', 300, (SELECT REVERSE(CAST(DNI as varchar(8)) + 'R')
								FROM PROPIETARIO
								WHERE NOMBRE='Ana' AND APELLIDO1='Alcalá' AND APELLIDO2='López')),
	  ('Real', 5, 2, 'S', 300, '65656565M'),
	  ('Real', 7, 2, 'S', 300, NULL),
	  ('Real', 9, 2, 'S', 300, NULL);
	  
SELECT * FROM CASAPARTICULAR

SELECT * FROM PROPIETARIO

--INSERT INTO PROPIETARIO
--VALUES ('65656565M', 'Carolina', 'Pérez', 'Vila', 'M', NULL, (SELECT FECHA_NACIMIENTO FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Galán'), (SELECT EDAD FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Galán'),
-- ((SELECT REVERSE(CAST(DNI as varchar(8)) + 'R')
--  FROM PROPIETARIO
--  WHERE NOMBRE='Ana' AND APELLIDO1='Alcalá' AND APELLIDO2='López')), 'Juan', 'Pérez', 'Vila', 'H', 996987876, (SELECT DATEADD(mm, 2, DATEADD(yy, -5, (SELECT FECHA_NACIMIENTO
--																																					FROM PROPIETARIO 
--																																					WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Galán')))), (SELECT EDAD FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Galán') - 5)

															 
--El DNI de Carolina es el 65656565M y el de Juan tiene los números al revés que el de Ana Alcalá López y Letra R.
--Carolina ha comprado las casas con el número 1 y 5 y Juan la vivienda 3. El resto están sin vender.

--Carolina nació el mismo día que Manolo Ramos Galán y Juan es 5 años más pequeño y cumple años el mismo día pero dos meses más tarde. 
--Solo sabemos el teléfono de Juan que es el 996987876.

--Utiliza transacciones explicitas para garantizar que se realiza las operaciones correctamente.

--Sobre la Base de datos EMPRESAnew2

--3.- Haz una copia de  la tabla  empleados fijos. Borra en la copia de los empleados fijos aquellos empleados que su salario supere a la media de los salarios de los empleados que trabajan en su departamento.
SELECT *
INTO EMPREGADOFIXO_copia 
FROM EMPREGADOFIXO

DELETE FROM EMPREGADOFIXO_copia
WHERE NSS IN (
	SELECT EFC.NSS
	FROM EMPREGADOFIXO_copia EFC INNER JOIN EMPREGADO E ON EFC.NSS = E.NSS INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
	GROUP BY EFC.NSS
	HAVING EFC.Salario > AVG(EFC.Salario));
	
--4.-Haz una copia todos los datos de la tabla empleado. Borra en la copia de los empleados aquellos empleados  que su edad esté entre las tres edades más pequeñas.
SELECT *
INTO EMPREGADO_copia 
FROM EMPREGADO
--5.-Crea una copia de la tabla empleado fijo con todos sus datos llamada CopiaEmpleadosfijos y aquí  actualiza el salario de todos los empleados fijos  teniendo en cuenta que si tienen asignado más de 2 proyectos se le aumenta un 25% y si no solo un 10%.
SELECT NSS, Salario, DataAlta, Categoria
INTO CopiaEmpleadosfijos
FROM EMPREGADOFIXO

-- 6.-  Hay un nuevo empleado en la empresa y que hay que toda la información relacionada con este empleado.
-- Se llama Manuel Galán Galán, con NSS 0000100, dirección calle Sol,5 36012 Redondela Pontevedra,Telf:699888777 y nació el día de 6 de enero de 1978 y va a comprar el salario máximo de la media de los salarios por departamento. 
-- Está asignado al departamento PERSOAL del que también va a ser el nuevo jefe. No va a tener un supervisor. 
-- Se le van asignar los proyectos XESTION DA CALIDADE y APLICACIÓN CONTABLE con 25 horas en cada uno.
INSERT INTO EMPREGADO
VALUES('Manuel','Galán','Galán',0000100,'Sol', 5, NULL, 36012, 'Redondela', 'Pontevedra', '1978-01-06', 'H', NULL, '1', '699888777', NULL)

INSERT INTO EMPREGADOFIXO
VALUES('0000100',)