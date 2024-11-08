--ELOY RODAL P�REZ
USE EMPRESANEW2
GO

USE CATASTRO
GO
--1.-

--a)Crear un  procedimiento llamado prDatosDepartamentos que ejecute el procedimiento visualizardatosdepartamento (procedimiento creado en el ejercicio 4b de la tarea 1 ud8) para mostrar  los datos para cada uno de los departamentos de la empresa.  Para ello tienes que utilizar un cursor para que vaya recorriendo las filas y guardando en una variable cada nombre del departamento. Pon ejemplos de llamadas al procedimiento.

--Hazlo utilizando un cursor est�tico, es decir, el cursor no reflejar� los cambios producidos por otras conexiones.


IF OBJECT_ID('dbo.pr_DatosDepartamentos') IS NOT NULL
	DROP PROC dbo.pr_DatosDepartamentos
GO

	CREATE PROC pr_DatosDepartamentos
	AS
	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF
	
	--DECLARACI�N DEL CURSOR
	DECLARE Departamento_cursor CURSOR STATIC FOR
	
	--REALIZAMOS LA CONSULTA QUE QUEREMOS GUARDAR EN LA VARIABLE CURSOR
	SELECT nomeDepartamento FROM DEPARTAMENTO
	ORDER BY 1
	
	--DECLARACI�N DE VARIABLES PARA ALMACENAR LAS COLUMNAS 
	DECLARE @nomeDepartamento varchar(60)
	
	--APERTURA DEL CURSOR Y LLENA EL CONJUNTO DE RESULTADOS
	OPEN Departamento_cursor
	
	--LECTURA DE LA PRIMERA FILA DE UN CURSOR Y SE GUARDA EN LAS VARIABLES
	FETCH NEXT FROM Departamento_cursor INTO @nomeDepartamento
	
	--MIENTRAS EL CURSOR TENGA DATOS VISUALIZAMOS LAS VARIABLES Y LEEMOS
	--UTILIZAMOS UN CURSOR EST�TICO. SE HACE UNA COPIA A LA BASE DE DATOS
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'DEPARTAMENTO ' + @nomeDepartamento
		PRINT '------------------------------'
		EXEC pr_visualizardatosdepartamento @nomeDepartamento
		
	--LECTURA DE LA SIGUIENTE FILA DE UN CURSOR
		FETCH NEXT FROM Departamento_cursor INTO @nomeDepartamento
	END
	PRINT 'Estado de FETCH: ....' + CAST(@@FETCH_STATUS AS varchar(2))
	CLOSE Departamento_cursor --CERRAR EL CURSOR
	DEALLOCATE Departamento_cursor --LIBERAR LOS RECURSOS UTILIZADOS
	GO

--Hazlo utilizando un cursor din�mico, es decir, el cursor reflejar� los cambios producidos por otras conexiones.

CREATE PROCEDURE prDatosDepartamento2
AS
SET NOCOUNT ON
SET ANSI_WARNINGS OFF
DECLARE Departamento_cursor2 CURSOR DYNAMIC FOR
SELECT nomeDepartamento from Departamento
ORDER BY 1
DECLARE @nomeDepartamento varchar(60)
OPEN Departamento_cursor2
FETCH NEXT FROM Departamento_cursor2 INTO @nomeDepartamento
WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT 'DEPARTAMENTO ' + @nomeDepartamento
		PRINT '------------------------------'
		EXEC pr_visualizardatosdepartamento @nomeDepartamento
		
	--LECTURA DE LA SIGUIENTE FILA DE UN CURSOR
		FETCH NEXT FROM Departamento_cursor INTO @nomeDepartamento
	END
	PRINT 'Estado de FETCH: ....' + CAST(@@FETCH_STATUS AS varchar(2))
	CLOSE Departamento_cursor2 --CERRAR EL CURSOR
	DEALLOCATE Departamento_cursor2 --LIBERAR LOS RECURSOS UTILIZADOS
	GO

--b) Idem del anterior, pero ahora el procedimiento se llamar� prDatosDepartamentoNempleados que solo ejecute el procedimiento visualizardatosdepartamento solo para aquellos departamentos que tengan m�s de N empleados, siendo N un valor que se le pasa al procedimiento prDatosDepartamentoNempleados. Si no se le pasa ning�n valor en el par�metro, por defecto es 2
--No se reflejar�n los cambios producidos por otras conexiones.

IF OBJECT_ID('dbo.pr_DatosDepartamentos') IS NOT NULL
	DROP PROC dbo.pr_DatosDepartamentosNempleados
GO

	CREATE PROC pr_DatosDepartamentosNempleados
	AS
	SET NOCOUNT ON
	SET ANSI_WARNINGS OFF
	--DECLARACI�N DEL CURSOR
	DECLARE Departamento_cursor CURSOR STATIC FOR
	
	--REALIZAMOS LA CONSULTA QUE QUEREMOS GUARDAR EN LA VARIABLE CURSOR
	SELECT D.nomeDepartamento, count(*) FROM DEPARTAMENTO D
	INNER JOIN Empregado E ON D.numDepartamento = E.NumDepartamentoPertenece
	GROUP BY D.nomeDepartamento
	having count(*) > num
	

--2.- Crea un procedimiento llamado prlistarbasedatos que para todos las bases de datos existentes (excepto para las bases de datos del sistema) muestre informaci�n ejecutando el procedimiento sp_helpdb �base de datos�.  Se reflejar�n los cambios producidos por otras conexiones.

--Ejemplo de salida:


IF OBJECT_ID('dbo.pr_DatosDepartamentos') IS NOT NULL
	DROP PROC dbo.pr_DatosDepartamentosNempleados
GO

	CREATE PROC prlistarbasedatos
	AS
	
	SET NOCOUNT ON
	DECLARE basesdatos_cursor CURSOR FOR
		SELECT name FROM sys.databases
		WHERE name NOT IN ('tempdb', 'master', 'Model', 'msdb')
	OPEN basesdatos_cursor
	
	DECLARE @DBName sysname
	
	FETCH NEXT FROM basesdatos_cursor into @DBName
	WHILE @@FETCH_STATUS <> -1
	 BEGIN
	   IF (@@FETCH_STATUS = -2)
		 BEGIN
			FETCH NEXT FROM basesdatos_cursor INTO @DBName
		 CONTINUE
		END
	 SELECT @DBName 'BASE DE DATOS'
	 EXEC sp_helpdb @DBName
	 FETCH NEXT FROM basesdatos_cursor INTO @DBName
   END
   CLOSE basesdatos_cursor

   exec prlistarbasedatos
--****En la base de datos catastro:

--3.-A partir de los 8 n�meros del DNI, se quiere calcular la letra.

--El proceso para calcular la letra es : se utiliza el resto de la divisi�n del n�mero entre 23. El resto siempre ofrecer� un valor que se encuentra entre 0 y 22, y este n�mero determinar� cu�l es la letra correspondiente. Para saber cu�l es la letra que le corresponde debemos compararlo con la cadena TRWAGMYFPDXBNJZSQVHLCKE. El  resto que se obtiene marcar� la posici�n de la letra en el c�digo. Es decir, que si era el resto era 3, la letra del DNI ser� la W.

--Aqu� tenemos una tabla con las letras del DNI para saber cu�l es.

--a)      Crea una funci�n llamada fnLetraDNI que se le pase los n�meros de un dni y devuelva la letra. Pon ejemplo de llamada.


IF OBJECT_ID('DBO.fnLetraDNI') IS NOT NULL
	DROP FUNCTION DBO.fnLetraDNI
GO
CREATE FUNCTION dbo.fnLetraDNI (@numerosDNI VARCHAR(8))
RETURNS CHAR(1)
AS
BEGIN
    DECLARE @letras CHAR(23) = 'TRWAGMYFPDXBNJZSQVHLCKE'
    DECLARE @resto INT
    DECLARE @letra CHAR(1)

    SET @resto = CAST(@numerosDNI AS INT) % 23
    SET @letra = SUBSTRING(@letras, @resto + 1, 1)

    RETURN @letra
END


--b)     Haz los mismo pero ahora utilizando un procedimiento llamado prLetraDNI. Pon ejemplo de llamada

IF OBJECT_ID('dbo.pr_LetraDNI') IS NOT NULL
	DROP PROC dbo.pr_LetraDNI
GO

 CREATE PROCEDURE pr_LetraDNI
    @numerosDNI VARCHAR(8),
    @letraDNI CHAR(1) OUTPUT
AS
BEGIN
    DECLARE @letras CHAR(23) = 'TRWAGMYFPDXBNJZSQVHLCKE'
    DECLARE @resto INT

    SET @resto = CAST(@numerosDNI AS INT) % 23
    SET @letraDNI = SUBSTRING(@letras, @resto + 1, 1)
END

--4.- Se quiere visualizar una tabla con el nombre completo, dni incorrecto y dni correcto de aquellos propietarios  que tenga en su dni una letra incorrecta. Para ello se va a utilizar la funci�n fnLetraDNI

--a) crea una funci�n inline llamada fnTablaDNImal1 que devuelva la anterior tabla. A la hora de insertar se utilizar� la instrucci�n  INSERT ��SELECT. Nota: al insertar var�as filas en una �nica instrucci�n select, en este caso no se utilizan cursores. Pon ejemplo de llamada

--b) crea una funci�n inline llamada fnTablaDNImal3 que devuelva la anterior tabla. A la hora de insertar se utilizar� la instrucci�n INSERT ��VALUES. Nota: al insertar una fila cada vez, en este caso  es necesario utilizar un cursor. Pon ejemplo de llamada

-- Ejemplo de salida:

