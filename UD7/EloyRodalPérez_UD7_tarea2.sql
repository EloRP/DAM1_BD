--ELOY RODAL P�REZ
USE CATASTRO
USE EMPRESANEW2
GO

--Sobre la Base de datos CATASTRO

--1._ El propietario de la vivienda unifamiliar de la calle Pasi�n 3 decide dividir la vivienda en 3 apartamentos de una habitaci�n: uno por cada planta y no pone ascensor.

--Los del primero y segundo piso de 55 metros cuadrados  constru�dos (50 �tiles) y el del tercero de 50 metros cuadrados constru�dos (46 �tiles). Refleja este cambio en la base de datos utilizando transacciones expl�citas si fuera necesario.
BEGIN TRANSACTION
BEGIN TRY

DELETE FROM CASAPARTICULAR
WHERE CALLE='Pasi�n' AND NUMERO='3' AND DNIPROPIETARIO='33333344C'
COMMIT TRANSACTION

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION --O SOLO ROLLBACK
PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SELECT * FROM CASAPARTICULAR

BEGIN TRANSACTION
BEGIN TRY

INSERT INTO BLOQUEPISOS
VALUES('Pasi�n', 3, 3, 'N')


END TRY
BEGIN CATCH
ROLLBACK TRANSACTION --O SOLO ROLLBACK
PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SELECT * FROM BLOQUEPISOS

BEGIN TRANSACTION
BEGIN TRY

INSERT INTO PISO 
VALUES('Pasi�n',3,1,'A',1,50,55,'33333344C'), ('Pasi�n',3,2,'A',1,50,55,'33333344C'), ('Pasi�n',3,3,'A',1,46,50,'33333344C')
COMMIT TRANSACTION

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION --O SOLO ROLLBACK
PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

SELECT * FROM PISO

--Sobre la Base de datos EMPRESA

--2._ Utiliza transacciones expl�citas para garantizar que se realiza la operaci�n completa correspondiente al ejercicio 4 de la Tarea 3 de la UD6.
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRANSACTION --O SOLO BEGIN TRAN
BEGIN TRY

UPDATE EMPREGADO
SET NSSSupervisa = (SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento='Estad�stica')
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D
ON E.NumDepartamentoPertenece=D.NumDepartamento
WHERE NomeDepartamento='Estad�stica' AND NSS = NSSDirector


UPDATE EMPREGADO
SET NSSSupervisa=(	SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento='Innovaci�n')

WHERE NSS IN(		SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento = 'Estad�stica')


UPDATE EMPREGADO
SET NumDepartamentoPertenece = (	SELECT NumDepartamento
									FROM DEPARTAMENTO
									WHERE NomeDepartamento='innovaci�n')

WHERE NumDepartamentoPertenece IN (	SELECT NumDepartamento
									FROM DEPARTAMENTO
									WHERE NomeDepartamento='Estad�stica')

UPDATE PROXECTO
SET NumDepartControla=(	SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Innovaci�n')
WHERE NumDepartControla in (SELECT NumDepartamento
							FROM DEPARTAMENTO
							WHERE NomeDepartamento='Estad�stica')

UPDATE LUGAR
SET Num_departamento=(	SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Innovaci�n')
WHERE Num_departamento IN (
						SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Estad�stica'
						and LUGAR not IN (	SELECT LUGAR
											FROM LUGAR L inner join DEPARTAMENTO D
											ON L.Num_departamento= D.NumDepartamento
											WHERE NomeDepartamento='innovaci�n'))

DELETE FROM LUGAR
WHERE Num_departamento=(SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Estad�stica')


DELETE DEPARTAMENTO
WHERE NomeDepartamento ='Estad�stica'
COMMIT TRANSACTION

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH

--3.- Hubo un error en la asignaci�n de las horas semanales de los empleados del departamento Persoal en el proyecto PORTAL. En los que no hay registrado el n�mero de horas tiene que ser 15 y en los que si est� registrado tiene que aumentar el n�mero de horas en este valor, con l�mite 25 ( si supera el limite, se asigna este valor).
DECLARE @maxHoras tinyint
SET @maxHoras = 25
UPDATE EMPREGADO_PROXECTO
SET Horas = CASE WHEN ISNULL(Horas,0)+ 15 <= @maxHoras
		    THEN ISNULL(Horas,0) + 15 ELSE @maxHoras
		    END
WHERE Horas = NULL AND NumProxecto = (SELECT NumProxecto
									  FROM PROXECTO 
									  WHERE NomeProxecto = 'PORTAL') AND NSSEmpregado = (SELECT NSSEmpregado
																						 FROM DEPARTAMENTO 
																						 WHERE NomeDepartamento = 'Persoal')
									  
SELECT * FROM EMPREGADO_PROXECTO

--4._El departamento de PERSOAL crea un proyecto de nombre 'INFORMATIZACI�N DE PERMISOS' que se va a realizar en VIGO y en el que quiere que se implique todo el personal que pertenece a este departamento 
--Modifica el campo Nombre de Proyecto para poder permitir almacenar todos los caracteres del nombre del proyecto que se pretende crear.
SET IMPLICIT_TRANSACTIONS ON
BEGIN TRANSACTION --O SOLO BEGIN TRAN
BEGIN TRY

ALTER TABLE PROXECTO
ALTER COLUMN NomeProxecto varchar(50)

SELECT *
FROM PROXECTO

INSERT INTO PROXECTO
VALUES((SELECT MAX(NumProxecto) + 1
		FROM PROXECTO), 'INFORMATIZACI�N DE PERMISOS', 'VIGO', (SELECT NumDepartamento
																FROM DEPARTAMENTO
																WHERE NomeDepartamento='PERSOAL'));

SELECT * FROM PROXECTO

--El jefe de departamento le dedicar� 8 horas semanales.
UPDATE EMPREGADO_PROXECTO
SET Horas = 8, NumProxecto = 13
WHERE NSSEmpregado = (SELECT NSSDirector
					  FROM DEPARTAMENTO
					  WHERE NomeDepartamento = 'PERSOAL')

SELECT * FROM EMPREGADO_PROXECTO


--Los empleados le dedicar�n 5 horas semanales cada uno, teniendo en cuenta que no pueden superar 42 horas semanales dedicadas a proyectos 
--(En ese caso dedicar�an el n�mero de horas que tuviesen disponibles hasta llegar a 42 y si no tuvieran horas disponibles no se asignar�an al proyecto).  

DECLARE @limiteSemanalHoras tinyint
SET @limiteSemanalHoras = 42

DECLARE @horasTotalesProyectos INT
SET @horasTotalesProyectos = (
    SELECT SUM(Horas)
    FROM EMPREGADO_PROXECTO
)

DECLARE @horasDisponibles INT
SET @horasDisponibles = @limiteSemanalHoras - @horasTotalesProyectos

UPDATE EP
SET EP.Horas = CASE 
                    WHEN @horasDisponibles >= 5 THEN 5
                    ELSE @horasDisponibles
                END,
    EP.NumProxecto = 13
FROM EMPREGADO_PROXECTO EP
INNER JOIN EMPREGADOFIXO EF ON EP.NSSEmpregado = EF.NSS
WHERE @horasDisponibles > 0

SELECT * FROM EMPREGADO_PROXECTO

--A los empleados que pasen de 40 horas dedicadas a proyectos les incrementar� el sueldo, pag�ndoles 12 euros m�s a la semana por cada hora extra que hagan.

DECLARE @limiteHoras tinyint
SET @limiteHoras = 40
UPDATE EMPREGADOFIXO
SET Salario = (SELECT SALARIO
			   FROM EMPREGADOFIXO EF INNER JOIN EMPREGADO E ON EF.NSS = E.NSS INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado) + 12 * (SELECT HorasExtras
																																				   FROM HORASEXTRAS H INNER JOIN EMPREGADOFIXO EF ON H.NSS = EF.NSS)
WHERE (SELECT Horas
	   FROM EMPREGADO_PROXECTO EP INNER JOIN EMPREGADOFIXO EF ON EP.NSSEmpregado = EF.NSS)
	    > @limiteHoras

COMMIT TRANSACTION

--Utiliza transacciones impl�citas para garantizar que se realiza la operaci�n correctamente.

END TRY
BEGIN CATCH
ROLLBACK TRANSACTION
PRINT 'SE HA PRODUCIDO UN ERROR'
END CATCH