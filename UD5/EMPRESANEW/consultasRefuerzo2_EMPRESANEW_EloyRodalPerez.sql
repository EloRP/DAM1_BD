--ELOY RODAL P�REZ
USE EMPRESANEW
GO

--1.-Selecciona todos los empleados varones que nacieron despu�s del a�o 1970 y que tengan a Sara Plaza Mar�n como jefa.
SELECT COUNT(*)
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento 
WHERE Sexo = 'H' AND YEAR(DataNacemento) > 1970 AND NSSDirector = 4444444

--2.-Muestra nombre, apellidos y tel�fono de los empleados que son jefes ordenado primero por apellidos y luego por nombre. Solo se visualiza un tel�fono, cuando existan los dos, se visualiza el primero y si no tienen ninguno en blanco.
SELECT Apelido1, ISNULL(Apelido2, ' '), Nome, telefono1
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento

--3- Muestra nombre junto a los apellidos y la edad de los empleados que no son jefes y mayores de 30 a�os, ordenado primero por apellidos descendentemente y luego por nombre ascendentemente. Hazlo de varias maneras.              

--4.- Para los empleados que se conoce solo un tel�fono, visualizar el nombre completo, el tel�fono que tenemos,  junto al nombre completo de su jefe. Para los que no tienen jefe se visualizar� el texto "Sin Jefe".

--5.-Visualizar el nombre y apellidos de los empleados jefes que no dirigen ning�n departamento.

--6.- Muestra el nombre de los empleados que viven en una localidad en la que existe una sede del departamento al que pertenecen.

--7.- La cree una consulta que muestre para todos los empleados su nombre completo, calle, n�mero, piso, localidad y nombre de departamento. La informaci�n debe estar ordenada por localidad en el caso de tratarse de mujeres y por nombre de departamento en el caso de tratarse de hombres.