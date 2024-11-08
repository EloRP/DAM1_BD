--ELOY RODAL P�REZ
USE EMPRESANEW
GO

--1)
--a) Crea un procedimiento almacenado MayorDeDosEnteros que se le pasan dos n�meros enteros y visualice un mensaje indicando si dichos n�meros son iguales o cu�l es el mayor.
--Pon un ejemplo de ejecuci�n de dicho procedimiento por valor y otro por referencia.

IF EXISTS(SELECT * FROM sys.objects
		  WHERE type = 'P' AND name= 'pr_MayorDeDosEnteros')
DROP PROC pr_MayorDeDosEnteros
GO

CREATE PROC pr_MayorDeDosEnteros (@Num1 int, @Num2 int)
AS
BEGIN
IF @Num1 < @Num2
			PRINT 'El n�mero ' + CAST(@Num1 as varchar(10)) + ' es menor que el n�mero ' + CAST(@Num2 as varchar(10))
ELSE IF @Num2 < @Num1
			PRINT 'El n�mero ' + CAST(@Num2 as varchar(10)) + ' es menor que el n�mero ' + CAST(@Num1 as varchar(10))
ELSE
			PRINT 'Los dos n�meros son iguales'
END
GO

--POR POSICI�N
EXEC pr_MayorDeDosEnteros 10, 5

--POR REFERENCIA @parametro = valor
EXEC pr_MayorDeDosEnteros @Num1=0, @Num2=0

--b) Modifica el anterior procedimiento, para que devuelva el mensaje en un par�metro de salida.  Pon un ejemplo de ejecuci�n de este procedimiento por valor y otro por referencia . 
GO
ALTER PROC pr_MayorDeDosEnteros @Num1 int, @Num2 int, @Mensaje VARCHAR(60) OUTPUT
AS
IF @Num1 < @Num2
	SET @Mensaje = 'El n�mero ' + CAST(@Num1 as varchar(10))  + ' es mayor que el n�mero ' + CAST(@Num2 AS VARCHAR(10))
ELSE IF @Num2 < @Num1
	SET @Mensaje = 'El n�mero ' + CAST(@Num2 as varchar(10)) + ' es menor que el n�mero ' + CAST(@Num1 as varchar(10))
ELSE 
SET @Mensaje = 'Los dos n�meros son iguales'
GO
DECLARE @Mensaje VARCHAR(60)

EXEC pr_MayorDeDosEnteros 10, 5, @Mensaje OUTPUT
PRINT @Mensaje



--2) Crea un procedimiento que se le pase un n�mero entero positivo y visualice la suma desde 1 hasta el n�mero introducido. Se tendr� que comprobar que el n�mero introducido sea un n�mero positivo, en caso de error el procedimiento retornar� -1 y si el n�mero es correcto retornar� 0. Ejecuta este procedimiento, visualizando tambi�n el valor retornado, poniendo ejemplos significativos.
IF EXISTS(SELECT * FROM sys.objects
		  WHERE type = 'P' AND name= 'pr_SumaNumeros')
DROP PROC pr_SumaNumeros
GO

CREATE PROC pr_SumaNumeros @numero int, @suma int OUTPUT
AS
BEGIN
IF (@numero < 0) RETURN -1
SET @suma = 0;
WHILE (@numero >= 1)
	BEGIN
		SET @suma = @suma + @numero;
		SET @numero = @numero - 1;
	END
	RETURN 0;
	END
	GO
	
DECLARE @VALOR INT
DECLARE @S INT
EXEC @VALOR= pr_SumaNumeros 7, @s output
PRINT @VALOR
PRINT @S
GO

--EJECUCI�N 2 --ERROR
DECLARE @VALOR INT
DECLARE @S INT
EXEC @VALOR = pr_SumaNumeros -7, @s output
SELECT @VALOR
--3) Crea un procedimiento almacenado MayorQueSueldoMin en la base de datos EMPRESA, para pasar un valor como par�metro (XXXX) y si ese valor es menor que el sueldo del empleado fijo que menos gana, se visualiza el mensaje �el valor XXXX es menor que el sueldo del empleado que menos gana: XXXX� sino visualiza �el valor XXXX no es menor que el sueldo del empleado que menos gana: XXXX�.

IF EXISTS(SELECT *
		FROM sys.objects
		WHERE type= 'P' AND name='pr_MayorQueSueldoMin')
DROP PROC pr_MayorQueSueldoMin
GO

CREATE PROC pr_MayorQueSueldoMin
@Valor FLOAT
as
BEGIN
DECLARE @sueldomin money
IF @Valor <= 0 RETURN -1

SELECT @sueldomin = MIN(salario) FROM EMPREGADOFIXO
IF @sueldomin > @Valor
PRINT CAST(@Valor AS varchar(10)) + ' es menor que el sueldo del empleado que menos gana: ' + CAST(@sueldomin AS VARCHAR(10))
ELSE
PRINT CAST(@Valor AS varchar(10)) + ' no es menor que el sueldo del empleado que menos gana: ' + CAST(@sueldomin AS VARCHAR(10))
RETURN 0
END
GO

DECLARE @RETORNO INT
EXEC @RETORNO = pr_MayorQueSueldoMin 5000
IF @RETORNO < 0 PRINT ' EL VALOR DEBE SER MAYOR QUE 0'
GO



--Se deber� comprobar que el Valor XXXX ser� positivo devolviendo -1 en caso de error y 0 en caso contrario.

--Ejecuta este procedimiento, poniendo varios ejemplos significativos.

--4)      

--a)Crea un procedimiento llamado DatosDepartamento  que se le pase el nombre de un departamento y devuelva en par�metros para ese departamento:  
--el n�mero de empleados de cualquier tipo, el n�mero de empleados fijos, 
--el total en salarios, 
--el nombre completo del director de dicho departamento.

--Tambi�n devolver� un valor de error -1 si no existe el departamento y 0 en caso contrario

IF EXISTS(SELECT *
		FROM sys.objects
		WHERE type= 'P' AND name='pr_DatosDepartamento')
DROP PROC pr_DatosDepartamento
GO

CREATE PROC pr_DatosDepartamento @NomeDepartamento varchar(50), @NumEmpleados int output, @NumEmpleadosFijos int output, @TotalSalarios float output, @nombreCompletoDirector varchar(100) output
AS 
BEGIN
IF NOT EXISTS(SELECT * FROM DEPARTAMENTO 
			  WHERE NomeDepartamento = @NomeDepartamento)
		RETURN -1
	
SELECT @NumEmpleados = COUNT(*), @TotalSalarios = SUM(salario), @NumEmpleadosFijos = COUNT(DISTINCT EF.NSS)
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D
ON E.NumDepartamentoPertenece = D.NumDepartamento
LEFT JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE D.NomeDepartamento = @NomeDepartamento 

SELECT @nombreCompletoDirector = Nome + ' ' + Apelido1 + ' ' + ISNULL(Apelido2, ' ')
FROM DEPARTAMENTO INNER JOIN EMPREGADO ON NSS=NSSDirector
WHERE NomeDepartamento = @NomeDepartamento
RETURN 0
END

--b)Crea un procedimiento llamado visualizardatosdepartamento  que se le pase un nombre de departamento y llame al procedimiento DatosDepartamento creando anteriormente. Debe visualizar la siguiente informaci�n tal como aparece en el siguiente ejemplo, teniendo en cuenta que si en la llamada no se le pasa ning�n departamento, por defecto se visualizar� el departamento T�cnico :

--DEPARTAMENTO: Persoal

-- DIRECTOR: Manuel Gal�n Gal�n

-- TOTAL SALARIO: 16695

-- NUMERO DE EMPLEADOS FIJOS 6 DE UN TOTAL DE 7 EMPLEADOS

IF EXISTS(SELECT *
		FROM sys.objects
		WHERE type= 'P' AND name='pr_visualizardatosdepartamento')
DROP PROC pr_visualizardatosdepartamento
GO

CREATE PROC pr_visualizardatosdepartamento @NOMBRE varchar(25) = 'T�cnico'
as
BEGIN
IF @NOMBRE = ' '
	SET @NOMBRE = 'T�cnico'

DECLARE @RETORNO INT, @TOTALSUELDOS FLOAT
DECLARE @NUMEMPREGADOS INT, @NUMEMPREGADOSFIXOS INT
DECLARE @DIRECTOR VARCHAR(100)

--EXEC DEL PROCEDIMIENTO
EXEC @RETORNO = pr_DatosDepartamento @NOMBRE,
@NUMEMPREGADOS OUTPUT, @NUMEMPREGADOSFIXOS OUT,
@TOTALSUELDOS OUTPUT, @DIRECTOR OUTPUT

--VISUALIZACI�N DE LA SALIDA
IF @RETORNO = -1 PRINT 'NO EXISTE EL DEPARTAMENTO CON NOMBRE ' + @NOMBRE
ELSE
BEGIN
 PRINT ' DEPARTAMENTO: ' + @NOMBRE
 PRINT ' DIRECTOR: ' + @DIRECTOR
 PRINT ' TOTAL SALARIO: ' + CAST(@TOTALSUELDOS AS VARCHAR(10))
 PRINT ' NUMERO DE EMPLEADOS FIJOS: ' + CAST(@NUMEMPREGADOSFIXOS AS VARCHAR(10)) + 'DE UN TOTAL DE' + CAST(@NUMEMPREGADOS AS VARCHAR(10))
END
END
GO

EXEC pr_visualizardatosdepartamento ' '
EXEC pr_visualizardatosdepartamento 'T�cnico'

--5)      

--a) Escribe un procedimiento InicialEmpleados que me devuelve todos los empleados (NSS, NombreCompleto, nombredepartamento, nombre completo del supervisor ) cuyo nombre empieza por una letra que se le pase por par�metro.  Teniendo en cuenta

--Si no tiene supervisor devolver� �Sin supervisor� .
-- Si no se le pasa ning�n par�metro me tiene que devolver los empleados cuyo nombre empieza por C. 
--El  par�metro debe ser una letra, devolviendo -1 en caso de fallo (que nos sea el par�metro una letra) y el n�mero de filas devueltas en caso de �xito.
-- Ejecuta este procedimiento, visualizando tambi�n el valor retornado, poniendo varios ejemplos significativos de funcionamiento.

IF EXISTS(SELECT *
		FROM sys.objects
		WHERE type= 'P' AND name='pr_InicialEmpleados')
DROP PROC pr_InicialEmpleados
GO

CREATE PROC pr_InicialEmpleados @CARACTER char(1) = 'C'
AS
BEGIN
	DECLARE @RESULTADO INT
	
	IF @CARACTER NOT LIKE '[a-zA-Z]'
	BEGIN
		SET @RESULTADO = -1
		SELECT @RESULTADO AS 'RESULTADO'
		RETURN
	END
	
	IF @CARACTER IS NULL OR @CARACTER = ''
	SET @CARACTER = 'C'
	
	
	
SELECT E.NSS, E.NOME + ' ' + E.APELIDO1 + ' ' + ISNULL(' ',E.APELIDO2) AS [NomeCompleto], NomeDepartamento, ISNULL((SELECT Nome + ' ' + Apelido1 + ISNULL('', Apelido2)
																													FROM EMPREGADO 
																													WHERE NSS = (SELECT NSSSupervisa
																																 FROM EMPREGADO
																																 WHERE Nome = E.Nome AND Apelido1 = E.Apelido1 AND Apelido2 = E.Apelido2)), 'Sin supervisor') AS [Supervisor]
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE Nome LIKE @CARACTER + '%'
END


DECLARE @Resultado INT

EXEC @Resultado = pr_InicialEmpleados 'M'
PRINT 'N�mero de filas devueltas: ' + CAST(@Resultado AS VARCHAR(10))

DECLARE @Resultado INT

EXEC @Resultado = pr_InicialEmpleados 'A'
PRINT 'N�mero de filas devueltas: ' + CAST(@Resultado AS VARCHAR(10))

DECLARE @Resultado INT

EXEC @Resultado = pr_InicialEmpleados '123'
PRINT 'Resultado: ' + CAST(@Resultado AS VARCHAR(10))

DECLARE @Resultado INT

EXEC @Resultado = pr_InicialEmpleados
PRINT 'N�mero de filas devueltas: ' + CAST(@Resultado AS VARCHAR(10))

------------------------------------------

--b) Escribe un procedimiento almacenado InsertarEmpleados, que reciba una inicial de una letra y  cree una tabla  llamada EmpregadoDepartamento con los campos NSS, NombreCompleto, nombredepartamento, supervisor e inserte los empleados cuyo nombre empieza por la letra que se le ha pasado por par�metro, utilizando para ello el procedimiento InicialEmpleados creado anteriormente ( nota: mira las sentencia INSERT �.EXECUTE  en UD6  o busca en la ayuda).

--Se deber� mostrar lo siguiente:

--Si la letra no es un car�cter se visualizar� el mensaje "par�metro incorrecto, no se insertar� ning�n registro",
-- Si no existe ning�n nombre con esa letra se visualizar� "no hay ning�n empleado cuyo nombre empiece por la letra X"
--Y en caso contrario, se insertar� los empleados en la tabla empregadoDepartamento visualizando tambi�n el n�mero de registros insertados.
--Ejecuta este procedimiento, visualizando tambi�n el valor retornado, poniendo varios ejemplos significativos de funcionamiento.
IF EXISTS(SELECT *
		FROM sys.objects
		WHERE type= 'P' AND name='pr_InsertarEmpleados')
DROP PROC pr_InsertarEmpleados
GO


CREATE PROC pr_InsertarEmpleados @caracter char(1) = 'C'
AS
BEGIN
SET NOCOUNT ON
IF EXISTS (SELECT table_name FROM information_schema.TABLES
		   WHERE TABLE_NAME= 'EmpleadosDepartamentos')
		BEGIN
		DROP TABLE EmpleadosDepartamentos
		END
		
CREATE TABLE EmpleadosDepartamentos
(
NSS varchar(15) constraint PK_NSSEmpleado PRIMARY KEY,
NombreCompleto varchar(75),
NombreDepartamento varchar(25),
Supervisor varchar(75)
)

DECLARE @VALOR INT

INSERT EmpleadosDepartamentos
EXEC @VALOR=pr_InicialEmpleados @Caracter

IF @VALOR=-1 PRINT 'PAR�METRO INCORRECTO, NO SE INSERTAR� NING�N REGISTRO'
ELSE IF @VALOR=0 PRINT 'NO EXISTE NING�N NOMBRE QUE EMPIECE POR ' + @Caracter
ELSE PRINT 'SE INSERTARON ' + CAST(@Valor AS VARCHAR(4))+' empleados'

END
GO

EXEC pr_InsertarEmpleados 'A'


--6) Crea una copia de la tabla EmpleadosFijos y utiliza la copia para realizar la operaci�n que se indica a continuaci�n. Codifica un procedimiento SubirSalario que reciba como par�metro un porcentaje y aumente en ese porcentaje el salario de  los empleados que tienen asignados m�s de 2 proyectos, teniendo en cuenta que si se trata de un empleado supervisor  ese porcentaje se le incrementa en un 5% m�s.  

-- El porcentaje de aumento debe estar comprendido entre el 1% y el 15%, en caso contrario, hay que visualizar un mensaje indicando el error.

--Si se realiza la actualizaci�n, se debe visualizar un mensaje  indicando el n�mero de filas que se han modificado ( �SE HA AUMENTADO EL SALARIO A X EMPLEADOS�).

IF EXISTS (SELECT table_name FROM information_schema.TABLES
		  WHERE TABLE_NAME = 'COPIAEMPREGADOFIXO' AND TABLE_TYPE = 'BASE TABLE')
		  DROP TABLE COPIAEMPREGADOFIXO
GO
SELECT * INTO COPIAEMPREGADOFIXO FROM EMPREGADOFIXO
GO

IF EXISTS (SELECT * FROM sys.objects
		   WHERE TYPE='P' AND name='AumentarSalario')
		   DROP PROCEDURE AumentarSalario
GO

CREATE PROC AumentarSalario(@porcentaje decimal(5,2))
AS
SET NOCOUTN ON
IF @porcentaje NOT BETWEEN 1 AND 15
BEGIN

UPDATE COPIAEMPREGADOFIXO
SET Salario = CASE
			  WHEN NSS IN (SELECT DISTINCT NSSSupervisa FROM EMPREGADO) THEN Salario * (1+(@porcentaje+5)/100)
			  ELSE Salario * (1+@porcentaje/100)
			  END
WHERE NSS IN (SELECT NSSEmpregado FROM EMPREGADO_PROXECTO
			  GROUP BY NSSEmpregado
			  HAVING COUNT(*)>2)
PRINT 'Se ha aumentado el salario a ' + CAST(@@ROWCOUNT AS varchar(6)) + 'empleados'
END
ELSE
PRINT 'El porcentaje de descuento debe ser un valor comprendido entre el 1% y el 15%.'
SET NOCOUNT OFF









-----------------------