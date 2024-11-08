--ELOY RODAL P�REZ
USE CATASTRO
USE EMPRESANEW2

--Sobre la Base de datos CATASTRO

--1. a) El ayuntamiento desea poder conocer la edad de los propietarios, para ello va a incluir en la tabla propietario la fecha de nacimiento y un campo que mostrar� la edad de �ste. 
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

--Lucas L�pez S�nchez naci� el 12-03-1965, Mar�a Rodr�guez Ramos 25-02-1980, Mar�a Gal�n S�nchez el 23-09-1990, Malena Franco Vali�o el 07-07-1985 , 
-- M�nica Rodr�guez Tena y  Manolo Ramos Gal�n nacieron el d�a de navidad del mismo a�o que Malena Franco Vali�o y Jorge Juan Arranz P�rez naci� dos meses antes que Lucas L�pez S�nchez.

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '12-03-1965'
WHERE NOMBRE='Lucas' AND APELLIDO1='L�pez' AND APELLIDO2='S�nchez'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-02-1980'
WHERE NOMBRE='Mar�a' AND APELLIDO1='Rodr�guez' AND APELLIDO2='Ramos'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '23-09-1990'
WHERE NOMBRE='Malena' AND APELLIDO1='Franco' AND APELLIDO2='Vali�o'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-12-1990'
WHERE NOMBRE='M�nica' AND APELLIDO1='Rodr�guez' AND APELLIDO2='Tena'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = '25-12-1990'
WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Gal�n'

UPDATE PROPIETARIO
SET FECHA_NACIMIENTO = DATEADD(mm,-2,
	    			   (SELECT FECHA_NACIMIENTO
						FROM PROPIETARIO 
						WHERE NOMBRE='Lucas' AND APELLIDO1='L�pez' AND APELLIDO2='S�nchez')					
WHERE NOMBRE='Jorge Juan' AND APELLIDO1='Arranz' AND APELLIDO2='P�rez'

SELECT * FROM PROPIETARIO

--2.- Se ha creado una nueva zona urbana llamada La capilla, con las mismas caracter�sticas que Cuatrovientos excepto que tiene un parque menos 
 -- y en ella se ha construido una calle urbanizable llamada ReaL  con el C�digo postal 27802.    
 -- En esta calle se ha construido una urbanizaci�n de 5 casas con piscina y todas con la misma estructura: 
 -- 400 metros de solar, tienen planta baja, primera y buhardilla y 300 metros construidos. Los n�meros comienzan en 1 y solo se almacena n�meros impares. 
 -- Se han vendido 3 casas a dos nuevos propietarios que son hermanos: Carolina y Juan P�rez Vila.  

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
								WHERE NOMBRE='Ana' AND APELLIDO1='Alcal�' AND APELLIDO2='L�pez')),
	  ('Real', 5, 2, 'S', 300, '65656565M'),
	  ('Real', 7, 2, 'S', 300, NULL),
	  ('Real', 9, 2, 'S', 300, NULL);
	  
SELECT * FROM CASAPARTICULAR

SELECT * FROM PROPIETARIO

--INSERT INTO PROPIETARIO
--VALUES ('65656565M', 'Carolina', 'P�rez', 'Vila', 'M', NULL, (SELECT FECHA_NACIMIENTO FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Gal�n'), (SELECT EDAD FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Gal�n'),
-- ((SELECT REVERSE(CAST(DNI as varchar(8)) + 'R')
--  FROM PROPIETARIO
--  WHERE NOMBRE='Ana' AND APELLIDO1='Alcal�' AND APELLIDO2='L�pez')), 'Juan', 'P�rez', 'Vila', 'H', 996987876, (SELECT DATEADD(mm, 2, DATEADD(yy, -5, (SELECT FECHA_NACIMIENTO
--																																					FROM PROPIETARIO 
--																																					WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Gal�n')))), (SELECT EDAD FROM PROPIETARIO WHERE NOMBRE='Manolo' AND APELLIDO1='Ramos' AND APELLIDO2='Gal�n') - 5)

															 
--El DNI de Carolina es el 65656565M y el de Juan tiene los n�meros al rev�s que el de Ana Alcal� L�pez y Letra R.
--Carolina ha comprado las casas con el n�mero 1 y 5 y Juan la vivienda 3. El resto est�n sin vender.

--Carolina naci� el mismo d�a que Manolo Ramos Gal�n y Juan es 5 a�os m�s peque�o y cumple a�os el mismo d�a pero dos meses m�s tarde. 
--Solo sabemos el tel�fono de Juan que es el 996987876.

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
	
--4.-Haz una copia todos los datos de la tabla empleado. Borra en la copia de los empleados aquellos empleados  que su edad est� entre las tres edades m�s peque�as.
SELECT *
INTO EMPREGADO_copia 
FROM EMPREGADO
--5.-Crea una copia de la tabla empleado fijo con todos sus datos llamada CopiaEmpleadosfijos y aqu�  actualiza el salario de todos los empleados fijos  teniendo en cuenta que si tienen asignado m�s de 2 proyectos se le aumenta un 25% y si no solo un 10%.
SELECT NSS, Salario, DataAlta, Categoria
INTO CopiaEmpleadosfijos
FROM EMPREGADOFIXO

-- 6.-  Hay un nuevo empleado en la empresa y que hay que toda la informaci�n relacionada con este empleado.
-- Se llama Manuel Gal�n Gal�n, con NSS 0000100, direcci�n calle Sol,5 36012 Redondela Pontevedra,Telf:699888777 y naci� el d�a de 6 de enero de 1978 y va a comprar el salario m�ximo de la media de los salarios por departamento. 
-- Est� asignado al departamento PERSOAL del que tambi�n va a ser el nuevo jefe. No va a tener un supervisor. 
-- Se le van asignar los proyectos XESTION DA CALIDADE y APLICACI�N CONTABLE con 25 horas en cada uno.
INSERT INTO EMPREGADO
VALUES('Manuel','Gal�n','Gal�n',0000100,'Sol', 5, NULL, 36012, 'Redondela', 'Pontevedra', '1978-01-06', 'H', NULL, '1', '699888777', NULL)

INSERT INTO EMPREGADOFIXO
VALUES('0000100',)