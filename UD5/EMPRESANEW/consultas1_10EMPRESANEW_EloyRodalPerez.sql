--ELOY RODAL PEREZ

USE EMPRESANEW
GO

--1 Selecciona todas las empleadas que viven en Pontevedra, Santiago o Vigo.
SELECT *
FROM EMPREGADO
WHERE Sexo = 'M' AND Localidade IN ('Pontevedra','Santiago','Vigo');
go

--2 Haz una consulta que devuelva los nombres y fecha de nacimiento de los hijos e hijas de modo que aparezcan en primer lugar los hijos de empleados y a continuación las hijas y dentro de esto ordenados por edad.
SELECT Nome, DataNacemento
FROM FAMILIAR
WHERE Parentesco IN ('Hijo', 'Hija')
ORDER BY Parentesco DESC, DataNacemento

--3 Haz una consulta que muestre el nombre del curso y el número de horas de los dos cursos que más duran, En el caso de haber un empate deben visualizarse todos.
SELECT TOP 2 WITH TIES NOME, Horas
FROM CURSO
ORDER BY Horas DESC;

--4 ¿En qué localidades se desarrollan proyectos? Muéstralas por orden alfabético.  
SELECT DISTINCT LUGAR
FROM PROXECTO
ORDER BY LUGAR ASC
 
 --5 Muestra los datos de las tareas que están sin terminar.
SELECT *
FROM TAREFA
WHERE data_fin IS NULL;

--6 Muestra el nombre completo y NSS de los empleados que tienen un supervisor, de Lugo o Monforte, que nacieron entre el año 1970 y 1990.
SELECT Nome, Apelido1, Apelido2, NSS, DataNacemento
FROM EMPREGADO
WHERE NSSSupervisa IS NOT NULL AND Localidade IN ('Vigo', 'Monforte') AND (YEAR(DataNacemento) > 1970 AND YEAR(DataNacemento) < 1990);

--7 Obtén una relación de localidades de empleados junto con sus gentilicios teniendo en cuenta que no deben aparecer valores duplicados y las siguientes correspondencias (en caso de no tener correspondencia deberá indicar "Otro").
SELECT Localidade,
CASE Localidade 
WHEN 'Lugo' THEN 'Lucense'
WHEN 'Pontevedra' THEN 'Pontevedrés'
WHEN 'Santiago' THEN 'Compostelano'
WHEN 'Monforte' THEN 'Monfortino'
END AS Gentilicio
FROM EMPREGADO

--8 Vamos a mejorar la consulta anterior para que tenga en cuenta si se trata de un hombre o una mujer y de este modo ponga:
SELECT Localidade,
CASE 
WHEN Localidade = 'Lugo' THEN 'Lucense'
WHEN Localidade = 'Pontevedra' AND Sexo = 'H' THEN 'Pontevedrés'
WHEN Localidade = 'Pontevedra' AND Sexo = 'M' THEN 'Pontevedresa'
WHEN Localidade = 'Santiago' AND Sexo = 'H' THEN 'Compostelano'
WHEN Localidade = 'Santiago' AND Sexo = 'M' THEN 'Compostelana'
WHEN Localidade = 'Monforte' AND Sexo = 'H' THEN 'Monfortino'
WHEN Localidade = 'Monforte' AND Sexo = 'M' THEN 'Monfortina'
END AS Gentilicio
FROM EMPREGADO

--9 Muestra el nombre completo de los empleados y la fecha de nacimiento de la siguiente manera:
SELECT 
    Nome + ' ' + Apelido1 + ' ' + Apelido2 AS "Nome completo",
    DATENAME(dw, DataNacemento) + ', ' + 
    CAST(DAY(DataNacemento) AS varchar) + ' de ' + 
    DATENAME(month, DataNacemento) + ' de ' + 
    CAST(YEAR(DataNacemento) AS varchar) AS "Data de nacemento"
FROM EMPREGADO

--10 Muestra el nombre completo de los familiares que tienen un apellido (cuaquiera de los dos) de menos de 5 letras, ordenados por primer apellido y dentro de este por segundo apellido.
SELECT Nome + ' ' + Apelido1 + ' ' + Apelido2 AS "Nome completo"
FROM FAMILIAR
WHERE LEN(Apelido1) < 5 OR LEN(Apelido2) < 5
ORDER BY Apelido1 DESC, Apelido2 DESC