--ELOY RODAL P�REZ


--1.- 
-- a) Crea una funci�n llama fnEdad que se le pase una  fecha de nacimiento y devuelva su edad.
IF OBJECT_ID('DBO.fn_Edad') IS NOT NULL
	DROP FUNCTION fn_Edad
GO

	CREATE FUNCTION fn_Edad (@FECHANACIMIENTO DATE)
	RETURNS INT
	AS
	BEGIN
		DECLARE @EDAD INT
		DECLARE @FECHA_ACTUAL DATE
		SET @FECHA_ACTUAL = GETDATE()
		
		SET @EDAD = YEAR(@FECHA_ACTUAL) - YEAR(@FECHANACIMIENTO)
		
		SET @EDAD = @EDAD -
		CASE
			WHEN MONTH(@FECHA_ACTUAL) < MONTH(@FECHANACIMIENTO) OR
				  (MONTH(@FECHA_ACTUAL) = MONTH(@FECHANACIMIENTO) AND DAY(@FECHA_ACTUAL) < DAY(@FECHANACIMIENTO))
			THEN 1
			ELSE 0
		END
	RETURN @EDAD
	END
	GO
	
-- Haz una consulta que devuelva el nombre completo y edad de los empleados fijos utilizando esta funci�n.

--b)Utilizando la anterior funci�n, crea un procedimiento llamado prFamiliarEdad que se le pase una edad y visualice los empleados (nombre, apellidos y n�mero familiares)  que tienen m�s de un familiar que supera a la edad pasada como par�metro.

--Hay que comprobar que el par�metro sea correcto, (no puede ser negativo ni superar los 150 a�os),  devolviendo -1 en caso de fallo (que nos sea correcto el par�metro) y el n�mero de filas devueltas en caso de �xito.

--Pon varios ejemplos de llamada ( �xito y caso de error)
IF OBJECT_ID('FamiliarEdad') IS NOT NULL
	DROP PROC FamiliarEdad
GO


CREATE PROC FamiliarEdad @edad int
AS
	SET NOCOUNT ON --DESACTIVAR MENSAJES
	IF (@edad < 0 OR @edad > 150) RETURN -1 --ERROR
	
	SELECT e.Nome, e.Apelido1, e.Apelido2, COUNT(*) AS FAMILIARES
	FROM EMPREGADO e INNER JOIN FAMILIAR F ON E.NSS = F.NSS_empregado
	WHERE DBO.fn_Edad(F.DataNacemento)>@edad	--LLAMO A FUNCI�N
	GROUP BY e.Nome, e.Apelido1, e.Apelido2
	HAVING COUNT(*)>1
	
	RETURN @@ROWCOUNT --DEVUELVE EL NUMERO DE FILAS DEVUELTAS
GO

DECLARE @SALIDA INT
EXEC @SALIDA=FamiliarEdad 20
IF @SALIDA = -1
	SELECT 'LA EDAD DEBE ESTAR COMPRENDIDA ENTRE 1 Y 150' AS MENSAJE
ELSE
	SELECT @SALIDA AS [NUMERO DE EMPLEADOS]
GO
--CASO ERROR
DECLARE @SALIDA INT
EXEC @SALIDA=FamiliarEdad 200
IF @SALIDA = -1
	SELECT 'LA EDAD DEBE ESTAR COMPRENDIDA ENTRE 1 Y 150' AS MENSAJE
ELSE
	SELECT @SALIDA AS [NUMERO DE EMPLEADOS]
--2.- Crea una funci�n llamada fnNumEmplMayorQueEdad, se le pasa el nombre del departamento y una edad y devuelve el n�mero de empleados de dicho departamento mayores de la edad. Si no existe el departamento se visualizar� devolver� -1 y si la edad es negativa -2. (Utiliza la funci�n fnEdad)

USE EMPRESANEW2
IF EXISTS(SELECT * FROM SYS.objects
		  WHERE type='FN' AND name='fnMayoresdeEdad')
		  DROP FUNCTION dbo.fn_MayoresdeEdad
go

CREATE FUNCTION fn_MayoresdeEdad(@nombreDepart varchar(25),@edad int)
RETURNS INT
AS
BEGIN
IF NOT EXISTS(SELECT * FROM DEPARTAMENTO 
			  WHERE NomeDepartamento=@nombreDepart)
BEGIN
	--NO SE PUEDE UTILIZAR PRINT PARA VISUALIZAR UN MENSAJE
	RETURN -1
END
IF @edad < 0
begin
	RETURN -2
END
	
	RETURN
	(
	SELECT COUNT(*) FROM EMPREGADO
	INNER JOIN DEPARTAMENTO ON NumDepartamentoPertenece=NumDepartamento
	WHERE NomeDepartamento=UPPER(@nombreDepart)
	AND DBO.fn_EDAD(DataNacemento)>@EDAD
	
	)
END
GO

SELECT dbo.fn_MayoresdeEdad('t�cnico',24) AS numempleados
SELECT dbo.fn_MayoresdeEdad('INFORM�TICA',20) AS numempleados
SELECT dbo.fn_MayoresdeEdad('DESARROLLO',20) AS numempleados
SELECT dbo.fn_MayoresdeEdad('T�cnico',-9) AS numempleados


--Pon varios ejemplos de llamada a la funci�n para comprobar todos los posibles  casos que se puedan dar.

--3.-Crea una funci�n que me devuelva el nombre del departamento, nombre completo del empleado director del departamento y n�mero de proyectos que controlan para aquellos departamentos que controlan m�s de N proyectos, siendo n un par�metro.

--Haz este ejercicio  de dos manera: 
 -- a) funci�n inline  Return (select �..)
 IF OBJECT_ID('DBO.fn_DepartamentoProyectos') IS NOT NULL
	DROP FUNCTION fn_DepartamentoProyectos
GO
  
 CREATE FUNCTION fn_DepartamentoProyectos (@nProxectos int)
 RETURNS TABLE
 AS
 RETURN
 (
 SELECT nome+' '+Apelido1+' '+ISNULL(Apelido2,' ') AS nombre, NomeDepartamento, COUNT(*) AS NUMPROYECTOS FROM EMPREGADO
 INNER JOIN DEPARTAMENTO ON NSS=NSSDirector INNER JOIN PROXECTO
 on NumDepartamento=NumDepartControla
 GROUP BY NumDepartamento,Nome,Apelido1,Apelido2,NomeDepartamento
 HAVING COUNT(*)>@nProxectos
 )
 GO
 
 SELECT * FROM dbo.fn_DepartamentoProyectos(2)
 
 -- b) funci�n inline m�ltiples sentencias Insert�select    return.
  IF OBJECT_ID('DBO.fn_DepartamentoProyectos') IS NOT NULL
	DROP FUNCTION fn_DepartamentoProyectos2
GO
  
CREATE FUNCTION fnDepartamentoProyectos2 (@n int)
RETURNS @DepartamentoProyectos TABLE
( nombrecompleto varchar(100),
  nombredepart varchar(25),
  numproyectos int
 )
AS
BEGIN
INSERT INTO @DepartamentoProyectos
	SELECT nome+' '+Apelido1+' '+ISNULL(Apelido2,' ') AS NOMBRE, NomeDepartamento
	FROM EMPREGADO INNER JOIN DEPARTAMENTO ON NSS=NSSDirector INNER JOIN PROXECTO ON NumDepartamento=NumDepartControla
	GROUP BY NumDepartamento, Nome, Apelido1, Apelido2, NomeDepartamento
	HAVING COUNT(*)>@n

--Pon ejemplos de llamada a la funci�n.

--4.-

--a)Crear una funci�n fnEsvocal que recibe una letra y devuelva  si se trata de si es o no una vocal (Se considera tambi�n las vocales acent�as).
IF OBJECT_ID('dbo.fn_Esvocal') IS NOT NULL
    DROP FUNCTION dbo.fn_Esvocal;
GO

CREATE FUNCTION dbo.fn_Esvocal (@LETRA CHAR(1))
RETURNS BIT
AS
BEGIN
    IF @LETRA LIKE '[aeiouAEIOU����������]'
        RETURN 1;
    ELSE
        RETURN 0;
END;
GO

--b)Crea una funci�n fnVocales que se le pase una cadena ( m�ximo 250 caracteres) y devuelva el n�mero de vocales que contiene. Utiliza la anterior funci�n.
IF OBJECT_ID('dbo.fnVocales') IS NOT NULL
    DROP FUNCTION dbo.fnVocales;
GO

CREATE FUNCTION dbo.fnVocales (@cadena VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @TOTAL INT = 0;
    DECLARE @CONT INT = 1;
    DECLARE @LONGITUD INT = LEN(@cadena);

    WHILE @CONT <= @LONGITUD
    BEGIN
        IF dbo.fn_Esvocal(SUBSTRING(@cadena, @CONT, 1)) = 1
        BEGIN
            SET @TOTAL = @TOTAL + 1;
        END
        SET @CONT = @CONT + 1;
    END

    RETURN @TOTAL;
END;
GO


--c)Crea una funci�n fnVocalesNombre que se le pase un nombre de departamento y devuelva el nombre completo y el n�mero de vocales que tiene este, de los empleados que no pertenezcan al departamento dado.

--Utilizando la funci�n fnVocalesNombre, haz una consulta que visualice el nombre de los empleados que tienen en su nombre y apellidos el m�ximo n�mero de vocales.

--Hazlo de dos formas: utilizando top y de forma est�ndar.

--5)Escribe un procedimiento almacenado prVisualizaTabla que reciba como par�metros de entrada el nombre de una base de datos, el esquema y el nombre de una tabla y visualice todas las filas de esa tabla. Si no se proporciona el esquema, ser� por defecto dbo. Comprueba que los par�metros proporcionados existan los objetos, visualizando un mensaje significativo en caso contrario (Por ejemplo, si no existe la base de datos, se puede visualizar �'No existe la base de datos  XXX�).

--Pon varios ejemplos de llamadas al procedimiento

IF EXISTS(SELECT *
          FROM sys.objects
          WHERE type = 'P' AND name = 'prVisualizaTabla')
    DROP PROCEDURE prVisualizaTabla;
GO

CREATE PROCEDURE prVisualizaTabla
    @BaseDatos VARCHAR(100),
    @Esquema VARCHAR(100) = 'dbo',
    @Tabla VARCHAR(100)
AS
BEGIN

    IF NOT EXISTS(SELECT *
                  FROM sys.databases
                  WHERE name = @BaseDatos)
    BEGIN
        PRINT 'No existe la base de datos ' + @BaseDatos;
        RETURN;
    END;

    IF NOT EXISTS(SELECT *
                  FROM INFORMATION_SCHEMA.SCHEMATA
                  WHERE SCHEMA_NAME = @Esquema)
    BEGIN
        PRINT 'No existe el esquema ' + @Esquema;
        RETURN;
    END;

    -- Verificar si la tabla existe
    IF NOT EXISTS(SELECT *
                  FROM INFORMATION_SCHEMA.TABLES
                  WHERE TABLE_SCHEMA = @Esquema AND TABLE_NAME = @Tabla)
    BEGIN
        PRINT 'No existe la tabla ' + @Tabla + ' en el esquema ' + @Esquema;
        RETURN;
    END;


    DECLARE @SQL NVARCHAR(MAX);
    SET @SQL = 'SELECT * FROM ' + QUOTENAME(@BaseDatos) + '.' + QUOTENAME(@Esquema) + '.' + QUOTENAME(@Tabla);


    EXEC sp_executesql @SQL;
END;
GO