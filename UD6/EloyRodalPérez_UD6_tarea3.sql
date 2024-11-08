--ELOY RODAL P�REZ
USE EMPRESANEW
GO



--1.- El empleado con NSS 1122331 va a trabajar 3 horas en el proyecto 'Melloras sociais'.

INSERT INTO EMPREGADO_PROXECTO
VALUES ('1122331', (SELECT NumProxecto FROM PROXECTO WHERE NomeProxecto='Melloras sociais'),3)

--2.- Elimina los salarios de los empleados del departamento de INNOVACI�N.

UPDATE EMPREGADOFIXO
SET SALARIO=NULL
WHERE NSS IN (
SELECT EF.NSS
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE NomeDepartamento = 'INNOVACI�N')

--3.- Todas las personas que no son jefas de ning�n departamento, de las que no tenemos registrado su salario pasan a cobrar 1900.

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

--4.- La empresa va a realizar un ajuste, con lo cual decide eliminar el departamento de estad�stica, pasando a depender del departamento de Innovaci�n los empleados que pertenec�an a este departamento. Haz los cambios que consideres necesarios teniendo en cuenta que :
--el que era jefe del departamento de estad�stica pasa a depender del jefe de departamento de Innovaci�n y tiene a su cargo al resto de empleados que cambiaron de departamento.
--Los proyectos que depend�an de este departamento pasan a depender del departamento de Innovaci�n.


UPDATE EMPREGADO
SET NSSSupervisa = (SELECT NSSDirector
					FROM DEPARTAMENTO
					WHERE NomeDepartamento='Estad�stica')
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D
ON E.NumDepartamentoPertenece=D.NumDepartamento
WHERE NomeDepartamento='Estad�stica' AND NSS<>NSSDirector


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


--5.- El jefe de departamento de Innovaci�n pasa a cobrar 3900.

UPDATE EMPREGADOFIXO
SET SALARIO = 3900
WHERE NSS IN (
	SELECT NSSDirector
	FROM DEPARTAMENTO
	WHERE NomeDepartamento = 'Innovaci�n'
);


--6.- Haz una consulta que cree una tabla (DPTO_CONTA) con el nombre, apellidos y proyectos (nombre) en los que est�n trabajando todos los empleados que trabajan en el departamento de contabilidad.

SELECT NOME, APELIDO1, APELIDO2, NomeProxecto
INTO DPTO_CONTA
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN PROXECTO P ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE NomeDepartamento = 'Contabilidad'

SELECT *
FROM DPTO_CONTA

--7.- Elimina el contenido de la tabla DPTO_CONTA.

DELETE DPTO_CONTA

--8.- El departamento T�CNICO decide que ning�n empleado del departamento deber�a cobrar menos del "actual" salario medio del departamento, con lo cual decide subir el sueldo a aquellos empleados que cobran menos de este salario para pasar a cobrar esta cantidad.

UPDATE EMPREGADOFIXO
SET Salario=(SELECT AVG(SALARIO)
			 FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			 WHERE NomeDepartamento ='T�cnico')
WHERE NSS IN (
			  SELECT E.NSS
			  FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON E.NumDepartamentoPertenece = D.NumDepartamento INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			  WHERE NomeDepartamento ='T�cnico' AND Salario 
			  < (SELECT AVG(SALARIO)
			     FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
			     WHERE NomeDepartamento ='T�cnico'))
			 
--9.- Introduce en la DPTO_CONTA el nombre y los apellidos de los empleados del departamento de Contabilidad que son de Vigo, tienen alg�n hijo (o hija) y cobran un salario mayor que la media del salario de todos los empleados de la empresa.

INSERT INTO DPTO_CONTA
SELECT E.Nome, E.Apelido1 , E.Apelido2, NULL
FROM DEPARTAMENTO D INNER JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece INNER JOIN FAMILIAR F ON E.NSS = F.NSS INNER JOIN EMPREGADOFIXO EF ON EF.NSS = E.NSS
WHERE Salario < (SELECT AVG(SALARIO)
				 FROM EMPREGADOFIXO)
AND F.Parentesco = 'Hij%' and D.NomeDepartamento = 'Contabilidad' AND E.Localidade = 'Vigo'
