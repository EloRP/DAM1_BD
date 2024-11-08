--ELOY RODAL PÉREZ
USE EMPRESANEW
GO



--1.- El empleado con NSS 1122331 va a trabajar 3 horas en el proyecto 'Melloras sociais'.

INSERT INTO EMPREGADO_PROXECTO
VALUES ('1122331', (SELECT NumProxecto FROM PROXECTO WHERE NomeProxecto='Melloras sociais'),3)

--2.- Elimina los salarios de los empleados del departamento de INNOVACIÓN.

UPDATE EMPREGADOFIXO
SET SALARIO=NULL
WHERE NSS IN (
SELECT EF.NSS
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE NomeDepartamento = 'INNOVACIÓN')

--3.- Todas las personas que no son jefas de ningún departamento, de las que no tenemos registrado su salario pasan a cobrar 1900.

UPDATE EMPREGADOFIXO
SET Salario = 1900
WHERE NSS IN (
	SELECT EF.NSS
	FROM EMPREGADOFIXO EF
	WHERE NSS NOT IN (
		SELECT NSS 
		FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
		WHERE NSS = NSSDirector AND Sexo = 'M')
		)
AND Salario IS NULL

--4.- La empresa va a realizar un ajuste, con lo cual decide eliminar el departamento de estadística, pasando a depender del departamento de Innovación los empleados que pertenecían a este departamento. Haz los cambios que consideres necesarios teniendo en cuenta que :
--el que era jefe del departamento de estadística pasa a depender del jefe de departamento de Innovación y tiene a su cargo al resto de empleados que cambiaron de departamento.
--Los proyectos que dependían de este departamento pasan a depender del departamento de Innovación.


UPDATE EMPREGADO
SET NSSSupervisa = (SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento='Estadística')
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D
ON E.NumDepartamentoPertenece=D.NumDepartamento
WHERE NomeDepartamento='Estadística' AND NSS<>NSSDirector


UPDATE EMPREGADO
SET NSSSupervisa=(	SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento='Innovación')

WHERE NSS IN(		SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento = 'Estadística')


UPDATE EMPREGADO
SET NumDepartamentoPertenece = (	SELECT NumDepartamento
									FROM DEPARTAMENTO
									WHERE NomeDepartamento='innovación')

WHERE NumDepartamentoPertenece IN (	SELECT NumDepartamento
									FROM DEPARTAMENTO
									WHERE NomeDepartamento='Estadística')

UPDATE PROXECTO
SET NumDepartControla=(	SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Innovación')
WHERE NumDepartControla in (SELECT NumDepartamento
							FROM DEPARTAMENTO
							WHERE NomeDepartamento='Estadística')

UPDATE LUGAR
SET Num_departamento=(	SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Innovación')
WHERE Num_departamento IN (
						SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Estadística'
						and LUGAR not IN (	SELECT LUGAR
											FROM LUGAR L inner join DEPARTAMENTO D
											ON L.Num_departamento= D.NumDepartamento
											WHERE NomeDepartamento='innovación'))

DELETE FROM LUGAR
WHERE Num_departamento=(SELECT NumDepartamento
						FROM DEPARTAMENTO
						WHERE NomeDepartamento='Estadística')


DELETE DEPARTAMENTO
WHERE NomeDepartamento ='Estadística'


--5.- El jefe de departamento de Innovación pasa a cobrar 3900.

UPDATE EMPREGADOFIXO
SET SALARIO = 3900
WHERE NSS IN (
	SELECT NSSDirector
	FROM DEPARTAMENTO
	WHERE NomeDepartamento = 'Innovación'
);


--6.- Haz una consulta que cree una tabla (DPTO_CONTA) con el nombre, apellidos y proyectos (nombre) en los que están trabajando todos los empleados que trabajan en el departamento de contabilidad.

SELECT NOME, APELIDO1, APELIDO2, NomeProxecto
INTO DPTO_CONTA
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN PROXECTO P ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE NomeDepartamento = 'Contabilidad'

SELECT *
FROM DPTO_CONTA

--7.- Elimina el contenido de la tabla DPTO_CONTA.

DELETE DPTO_CONTA

--8.- El departamento TÉCNICO decide que ningún empleado del departamento debería cobrar menos del "actual" salario medio del departamento, con lo cual decide subir el sueldo a aquellos empleados que cobran menos de este salario para pasar a cobrar esta cantidad.

UPDATE EMPREGADOFIXO
SET Salario=(SELECT AVG(SALARIO)
			 FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			 WHERE NomeDepartamento ='Técnico')
WHERE NSS IN (
			  SELECT E.NSS
			  FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			  WHERE NomeDepartamento ='Técnico' AND Salario 
			  < (SELECT AVG(SALARIO)
			     FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			     WHERE NomeDepartamento ='Técnico'))
			 
--9.- Introduce en la DPTO_CONTA el nombre y los apellidos de los empleados del departamento de Contabilidad que son de Vigo, tienen algún hijo (o hija) y cobran un salario mayor que la media del salario de todos los empleados de la empresa.

INSERT INTO DPTO_CONTA
SELECT E.Nome, E.Apelido1 , E.Apelido2, NULL
FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN FAMILIAR F ON E.NSS = F.NSS INNER JOIN EMPREGADOFIXO EF ON EF.NSS = E.NSS
WHERE Salario < (SELECT AVG(SALARIO)
				 FROM EMPREGADOFIXO)
AND F.Parentesco = 'Hij%' and D.NomeDepartamento = 'Contabilidad' AND E.Localidade = 'Vigo'
