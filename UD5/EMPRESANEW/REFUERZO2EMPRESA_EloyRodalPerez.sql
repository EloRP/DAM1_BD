--ELOY RODAL PÉREZ
USE EMPRESANEW
GO
/*1._ Listado de sueldo medio y número de empleados por localidad ordenado por provincia y dentro de esta por localidad.   
	La localidad debe verse de la forma Localidad (Provincia) Por ejemplo: Ribadeo (Lugo).*/
	
SELECT Localidade + ' (' + Provincia + ')' AS "Localidad (Provincia)",
	   ROUND(AVG(Salario), 2) AS SalarioMedio,
	   COUNT(*) AS NumeroTotalEmpregados
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
GROUP BY Localidade, Provincia
ORDER BY Localidade, Provincia;

--2. ¿En qué año nacieron más empleados?
SELECT TOP 1 YEAR(DataNacemento) AS AnoNacemento, COUNT(*) AS NumEmpregados
FROM EMPREGADO
GROUP BY YEAR(DataNacemento)
ORDER BY NumEmpregados DESC;

--3. Muestra, para la fecha actual: el año, el mes (su nombre), el día, el día del año, la semana, el día de la semana (nombre), la hora, los minutos y los segundos.
SELECT 
    YEAR(GETDATE()) AS Año,
    DATENAME(MONTH, GETDATE()) AS Mes,
    DAY(GETDATE()) AS "Día del mes",
    DATEPART(DAYOFYEAR, GETDATE()) AS "Día del año",
    DATEPART(WEEK, GETDATE()) AS Semana,
    DATENAME(WEEKDAY, GETDATE()) AS "Día de la semana",
    DATEPART(HOUR, GETDATE()) AS Hora,
    DATEPART(MINUTE, GETDATE()) AS Minuto,
    DATEPART(SECOND, GETDATE()) AS Segundo;

--4. Indica cuantos días, meses, semanas y años faltan para tu próximo cumpleaños.
SELECT 
    DATEDIFF(DAY, GETDATE(), 
        DATEADD(YEAR, 
            CASE WHEN MONTH(GETDATE()) > 12 THEN 1 ELSE 0 END, 
            CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-06'
        )
    ) AS Dias,
    DATEDIFF(MONTH, GETDATE(), 
        DATEADD(YEAR, 
            CASE WHEN MONTH(GETDATE()) > 12 THEN 1 ELSE 0 END, 
            CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-06'
        )
    ) AS Meses,
    DATEDIFF(WEEK, GETDATE(), 
        DATEADD(YEAR, 
            CASE WHEN MONTH(GETDATE()) > 12 THEN 1 ELSE 0 END, 
            CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-06'
        )
    ) AS Semanas,
    DATEDIFF(YEAR, GETDATE(), 
        DATEADD(YEAR, 
            CASE WHEN MONTH(GETDATE()) > 12 THEN 1 ELSE 0 END, 
            CAST(YEAR(GETDATE()) AS VARCHAR) + '-12-06'
        )
    ) AS Años;
/*5. Haz una lista (nombre de departamento y nombre completo de empleado) de todos los departamentos junto con los empleados que pertenecen a ellos,
  incluyendo aquellos departamentos que no tienen empleados asignados. La información debe estar ordenada por departamento y dentro de esto por empleado.*/
  
SELECT NomeDepartamento, Nome + ' ' + Apelido1 + ' ' + Apelido2 AS "Nome completo"
FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece
ORDER BY NomeDepartamento, [Nome completo];

--6. Consulta que muestra el número de caracteres del nombre de departamento y el nombre en formato inverso.
  
SELECT 
    LEN(NomeDepartamento) AS NumCaracteresNomDep,
    REVERSE(NomeDepartamento) AS NombreInverso
FROM 
    DEPARTAMENTO;
    
--7.  Consulta para obtener el nombre del departamento y la cantidad total de proyectos que controla. Haz dos versiones:

 --a) sólo se muestran los departamentos que controlan proyectos.
 
SELECT NomeDepartamento, COUNT(NumProxecto) AS CantidadeProxectos
FROM DEPARTAMENTO D INNER JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla
GROUP BY NomeDepartamento;

 --b) se muestran todos los departamentos, y en caso de no controlar ninguno pondrá 'No tiene' 
 
SELECT NomeDepartamento, CASE 
        WHEN COUNT(NumProxecto) = 0 THEN 'No tiene'
        ELSE CAST(COUNT(NumProxecto) AS VARCHAR(10))
    END AS CantidadeProxectos
FROM DEPARTAMENTO D LEFT JOIN PROXECTO P ON D.NumDepartamento = P.NumDepartControla
GROUP BY NomeDepartamento;

--8. Consulta que cuente el número de espacios que tienen los nombres de proyecto.

SELECT NomeProxecto, SUM(LEN(NomeProxecto) - LEN(REPLACE(NomeProxecto, ' ', ''))) AS NumeroEspacios
FROM PROXECTO
GROUP BY NomeProxecto;

--9. Consulta para obtener todos los empleados (nss y nombre completo) y los proyectos (nombre) en los que están asignados, incluso si no tienen proyectos asignados.

SELECT NSS, Nome + ' ' + Apelido1 + ' ' + Apelido2 AS "Nome completo", NomeProxecto
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto;

--10. Consulta para obtener todos los proyectos y los empleados asignados a ellos, incluso si no hay empleados asignados a algún proyecto:

SELECT COUNT(NOME) AS NumEmpregados, NomeProxecto
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
GROUP BY NomeProxecto;

--11. Consulta para obtener los cinco proyectos con la cantidad total de horas semanales más alta asignadas a ellos. En caso de empate deben verse todos

SELECT DISTINCT TOP 5 Horas, NomeProxecto
FROM EMPREGADO_PROXECTO EP INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto
GROUP BY NomeProxecto, Horas
ORDER BY Horas DESC;

--12. Consulta para obtener los dos departamentos con el menor número de caracteres en sus nombres (sin tener en cuenta empates).

SELECT TOP 2 NomeDepartamento
FROM DEPARTAMENTO
ORDER BY LEN(NomeDepartamento) ASC;

--13. Consulta para obtener los empleados (NSS) que no están asignados a ningún proyecto.

SELECT E.NSS
FROM EMPREGADO E LEFT JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
WHERE EP.NSSEmpregado IS NULL;