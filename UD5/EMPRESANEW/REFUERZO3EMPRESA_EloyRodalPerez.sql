--ELOY RODAL PÉREZ
USE EMPRESANEW
GO


--1.- Hallar el número de empleados por departamento (visualiza el nombre) solo para aquellos departamentos que controlan más de 2 proyectos.

/*SELECT D.NomeDepartamento AS NombreDepartamento, COUNT(DISTINCT E.NSS) AS NumeroEmpleados
FROM DEPARTAMENTO D 
INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece 
INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY D.NomeDepartamento
HAVING COUNT(DISTINCT EP.NumProxecto) > 2;*/

SELECT NumDepartamentoPertenece, D.NomeDepartamento, COUNT(*) AS [Num EMPLEADOS]
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE NumDepartamento IN
					(	SELECT NumDepartControla FROM PROXECTO
						GROUP BY NumDepartControla
						HAVING COUNT(*)>2 )
GROUP BY NumDepartamentoPertenece, D.NomeDepartamento

--------------------------------------------------------------------

SELECT D.NomeDepartamento, (
		SELECT COUNT(*) FROM EMPREGADO E
		WHERE D.NumDepartamento = E.NumDepartamentoPertenece
		) AS [NUM EMPREGADOS]
FROM DEPARTAMENTO D
INNER JOIN PROXECTO P ON P.NumDepartControla = D.NumDepartamento
GROUP BY D.NomeDepartamento, D.NumDepartamento
HAVING COUNT(P.NumDepartControla) > 2;




SELECT NumDepartControla, COUNT(*) from PROXECTO
GROUP BY NumDepartControla
having COUNT(*) > 2;

--2.-
--a) ¿cuál es la media del número de empleados por departamento? redondea al número entero más alto

SELECT CEILING(AVG(1.0 * NumEmpleados)) AS MediaEmpleadosPorDepartamento
FROM (SELECT COUNT (*) AS NumEmpleados
    FROM EMPREGADO 
    GROUP BY NumDepartamentoPertenece
) AS EmpleadosPorDepartamento;

--b) Visualiza el nombre de departamento y número de proyectos que controlan para aquellos departamentos que el número de empleados asignados supera a la media del número de empleados por departamento
SELECT D.NomeDepartamento AS NombreDepartamento, 
       (SELECT COUNT(DISTINCT EP.NumProxecto) 
        FROM EMPREGADO E 
        INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado 
        WHERE E.NumDepartamentoPertenece = D.NumDepartamento) AS NumeroProyectos
FROM DEPARTAMENTO D
WHERE (
    SELECT COUNT(*) 
    FROM EMPREGADO 
    WHERE NumDepartamentoPertenece = D.NumDepartamento
) > (
    SELECT AVG(NumEmpleados) 
    FROM (
        SELECT COUNT(*) AS NumEmpleados 
        FROM EMPREGADO 
        GROUP BY NumDepartamentoPertenece
    ) AS EmpleadosPorDepartamento
);

-----------------------------------------------------------------
SELECT NomeDepartamento, (SELECT COUNT(*) FROM PROXECTO
						  WHERE NumDepartControla = NumDepartamento)
FROM PROXECTO P INNER JOIN DEPARTAMENTO D
ON P.NumDepartControla=D.NumDepartamento
WHERE NomeDepartamento IN (
					SELECT NumDepartamentoPertenece FROM EMPREGADO
					GROUP BY NumDepartamentoPertenece
					HAVING COUNT(*) >
							(SELECT CEILING(AVG(1.0 * NUMEMPLEADOS)) AS [ASD]
							 FROM (
								SELECT COUNT(*) AS NUMEMPLEADOS
								FROM EMPREGADO
								GROUP BY NumDepartamentoPertenece) AS ASDDD
								))

SELECT D.NomeDepartamento, (
		SELECT COUNT(*) FROM PROXECTO P WHERE P.NumDepartControla = NumDepartamento 
		) AS [NUM PROYECTOS CONTROLA]
FROM DEPARTAMENTO D
WHERE(
		SELECT COUNT(*) FROM EMPREGADO E
		WHERE D.NumDepartamento = E.NumDepartamentoPertenece 
		) > (
		SELECT CEILING(AVG(t)) AS [MEDIA EMPLEADOS POR DEPARTAMENTO]
		FROM (
		SELECT COUNT(*) AS t FROM EMPREGADO E GROUP BY E.NumDepartamentoPertenece
		) as t
	);

--3.-


--a) Para los departamentos que tienen más de 1 empleados con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan.

SELECT NumDepartControla, (SELECT NomeDepartamento FROM DEPARTAMENTO 
							WHERE NumDepartControla=NumDepartamento),
COUNT(*) as [Num Proxectos Controla]
FROM PROXECTO
WHERE NumDepartControla IN
		(SELECT NumDepartamentoPertenece FROM EMPREGADO
		 WHERE NSS IN (
			SELECT NSS_empregado FROM FAMILIAR
			GROUP BY NSS_empregado
			HAVING COUNT(*) < 3 )
GROUP BY NumDepartamentoPertenece
HAVING COUNT(*) > 1
	)
GROUP BY NumDepartControla


--b) Para los departamentos que tienen más de 1 empleado con menos de 3 familiares a su cargo, hallar el número de proyectos que controlan si estos representan más del 15% del número de proyectos que hay.

SELECT NumDepartControla, (SELECT NomeDepartamento FROM DEPARTAMENTO 
							WHERE NumDepartControla=NumDepartamento) AS [Nome Departamento],
COUNT(*) as [Num Proxectos Controla]
FROM PROXECTO
WHERE NumDepartControla IN
		(SELECT NumDepartamentoPertenece FROM EMPREGADO
		 WHERE NSS IN (
			SELECT NSS_empregado FROM FAMILIAR
			GROUP BY NSS_empregado
			HAVING COUNT(*) < 3 )
GROUP BY NumDepartamentoPertenece
HAVING COUNT(*) > 1
	)
GROUP BY NumDepartControla
HAVING COUNT(*) > --COMPROBACIÓN DEL 15%
	(SELECT COUNT(*) * 0.15 FROM PROXECTO)

--4 .-Haz una consulta para mostrar la siguiente información referente a los empleados:
SELECT 
    'ENTRE 40 Y 50 AÑOS' AS Edad,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) BETWEEN 40 AND 50 AND e.Sexo = 'M' THEN 1 ELSE 0 END) AS NumeroMujeres,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) BETWEEN 40 AND 50 AND e.Sexo = 'H' THEN 1 ELSE 0 END) AS NumeroHombres
FROM EMPREGADO e
WHERE DATEDIFF(YEAR, e.DataNacemento, GETDATE()) BETWEEN 40 AND 50
UNION ALL
SELECT 
    'MAYOR 50 AÑOS' AS Edad,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) > 50 AND e.Sexo = 'M' THEN 1 ELSE 0 END) AS NumeroMujeres,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) > 50 AND e.Sexo = 'H' THEN 1 ELSE 0 END) AS NumeroHombres
FROM EMPREGADO e
WHERE DATEDIFF(YEAR, e.DataNacemento, GETDATE()) > 50
UNION ALL
SELECT 
    'MENORES DE 40 AÑOS' AS Edad,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) < 40 AND e.Sexo = 'M' THEN 1 ELSE 0 END) AS NumeroMujeres,
    SUM(CASE WHEN DATEDIFF(YEAR, e.DataNacemento, GETDATE()) < 40 AND e.Sexo = 'H' THEN 1 ELSE 0 END) AS NumeroHombres
FROM EMPREGADO e
WHERE DATEDIFF(YEAR, e.DataNacemento, GETDATE()) < 40
UNION ALL
SELECT 
    'TOTAL' AS Edad,
    SUM(CASE WHEN e.Sexo = 'M' THEN 1 ELSE 0 END) AS NumeroMujeres,
    SUM(CASE WHEN e.Sexo = 'H' THEN 1 ELSE 0 END) AS NumeroHombres
FROM EMPREGADO e;

--5.-  Hallar la media de la edad ( se visualiza con dos decimales) de aquellos empleados que dirigen algún departamento con más 4 empleados.
SELECT 
    CAST(AVG(DATEDIFF(YEAR, e.DataNacemento, GETDATE())) AS DECIMAL(10,2)) AS MediaEdad
FROM EMPREGADO e
WHERE e.NSS IN (
    SELECT NSSDirector
    FROM DEPARTAMENTO
    GROUP BY NSSDirector
    HAVING COUNT(*) > 4
)
AND e.DataNacemento IS NOT NULL;

--6.-Para los proyectos que han tenido el mayor número de problemas, visualiza el nombre de proyecto, nombre del departamento que lo controla y número de empleados asignados

SELECT NomeProxecto,
	(SELECT NomeDepartamento FROM DEPARTAMENTO as D WHERE D.NumDepartamento = P.NumDepartControla) AS NombreDepartamento,
	(SELECT COUNT(*) FROM EMPREGADO_PROXECTO AS EP WHERE EP.NumProxecto = P.NumProxecto) AS NumeroEmpleadosAsignados
FROM PROXECTO AS P
WHERE P.NumProxecto IN (
    SELECT numProxecto
    FROM PROBLEMA
    GROUP BY numProxecto
    HAVING COUNT(*) = (
        SELECT MAX(NumeroProblemas)
        FROM (
            SELECT COUNT(*) AS NumeroProblemas
            FROM PROBLEMA
            GROUP BY numProxecto
        ) AS ProblemasPorProyecto
    )
)
