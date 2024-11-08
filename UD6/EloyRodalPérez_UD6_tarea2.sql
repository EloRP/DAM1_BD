--ELOY RODAL P�REZ
USE EMPRESANEW
GO

--1 El d�a de ayer el empleado Eligio Rodrigo y Xiao Vecino Vecino trabajaron 3 horas extra cada uno.
INSERT INTO HORASEXTRAS (Data, HorasExtras, NSS)
VALUES (DATEADD (DD,-1,GETDATE()),3,(SELECT E.NSS FROM EMPREGADO E INNER JOIN HORASEXTRAS H	ON E.NSS=H.NSS
WHERE E.Nome IN ('Eligio') AND Apelido1 IN ('Rodrigo')AND Apelido2 IS NULL));


INSERT INTO HORASEXTRAS (Data,HorasExtras,NSS)
VALUES (DATEADD (DD,-1,GETDATE()),3,(SELECT E.NSS FROM EMPREGADO E INNER JOIN HORASEXTRAS H ON E.NSS=H.NSS
WHERE E.Nome IN ('Xiao') AND Apelido1 IN ('Vecino') AND Apelido2 IN ('Vecino')))


--2 Se va a impartir un nuevo curso de "Dise�o Web" de 30 horas. La primera edici�n se va a realizar el 15 de abril en Pontevedra y su profesor va a ser el jefe de departamento  T�cnico.
SELECT *
FROM CURSO
INSERT INTO CURSO (Nome,Horas)
VALUES ('Dise�o web',30)

SELECT *
FROM EDICION

INSERT INTO EDICION
VALUES (
		(SELECT codigo
		FROM CURSO
		WHERE Nome LIKE ('Dise�o web'))
		,
		(SELECT ISNULL(MAX(Numero),0)
		FROM EDICION
		WHERE Codigo=9)+1,'2021-04-15','Pontevedra',
		(SELECT NSSDirector
		FROM DEPARTAMENTO
		WHERE NomeDepartamento LIKE ('T�cnico'))
		)

--3 A esta edici�n del curso asistir�n todos los empleados de este departamento (salvo el jefe).
SELECT *
FROM EDICIONCURSO_EMPREGADO

INSERT INTO EDICIONCURSO_EMPREGADO
SELECT (SELECT codigo
		FROM CURSO
		WHERE Nome LIKE ('Dise�o web')),
		(SELECT Numero
		FROM EDICION
		WHERE DATA='2021-04-15'), NSS
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece=d.NumDepartamento
WHERE NOT EXISTS (SELECT *
				FROM DEPARTAMENTO
				WHERE NSSDirector=NSS)
AND NomeDepartamento LIKE ('T�cnico')

--4 El departamento de contabilidad decide subir un 2% el salario a sus empleados. Realiza una consulta que incremente el sueldo de estos.
SELECT EF.Salario
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS= EF.NSS INNER JOIN DEPARTAMENTO D ON D.NumDepartamento=E.NumDepartamentoPertenece
WHERE d.NomeDepartamento LIKE ('Contabilidad')

UPDATE EMPREGADOFIXO
SET Salario=Salario*1.02
WHERE NSS IN (SELECT NSS
	FROM EMPREGADO E INNER JOIN DEPARTAMENTO D
	ON D.NumDepartamento=E.NumDepartamentoPertenece
WHERE D.NomeDepartamento LIKE ('Contabilidad'))

--5 Hubo un error en la asignaci�n de proyectos. La empleada con NSS=9900000 est� trabajando en el proyecto "Portal"  en lugar de trabajar en el proyecto "Xesti�n da calidade". Corr�gelo.
UPDATE EMPREGADO_PROXECTO
SET NumProxecto=(SELECT NumProxecto
					FROM PROXECTO p
					WHERE p.NomeProxecto LIKE ('Xestion da calidade'))
WHERE NSSEmpregado=9900000

SELECT *
FROM EMPREGADO_PROXECTO
WHERE NSSEmpregado=9900000

/*6 A�ade el proyecto "Dese�o nova WEB" que se levar� a cabo en Vigo e estar� controlado polo departamento T�cnico . De momento consta de d�as tareas:
"Definir o obxectivo da p�xina", que dar� comezo dentro de 15 d�as e ten unha duraci�n de 7 d�as. A s�a dificultade � media.
"Elexir o estilo e crear o mapa do sitio", que comezar� dentro de 20 d�as e ten unha dificultade media. */
SELECT *
FROM PROXECTO

INSERT INTO proxecto
VALUES ((SELECT MAX(NumProxecto) FROM PROXECTO)+1,'Dise�o nova web',
'Vigo',(SELECT NumDepartamento
		FROM DEPARTAMENTO
		WHERE NomeDepartamento='T�cnico'))


SELECT *
FROM TAREFA

INSERT INTO TAREFA
VALUES(
		(SELECT NumProxecto
		FROM PROXECTO
		WHERE NomeProxecto LIKE ('Dise�o nova web'))
		,
		(SELECT ISNULL(MAX(Numero),0)
		FROM TAREFA
		WHERE NumProxecto=13)+1
		,
		'Definir o obxectivo da paxina',

		DATEADD(dd,+15,GETDATE())
		,
		DATEADD(dd,+22,GETDATE())
		,'Media','Pendiente')

INSERT INTO TAREFA
VALUES(
		(SELECT NumProxecto
		FROM PROXECTO
		WHERE NomeProxecto LIKE ('Dise�o nova web'))
		,
		(SELECT ISNULL(MAX(Numero),0)
		FROM TAREFA
		WHERE NumProxecto=13)+1
		,'Elixir o estilo e crear o mapa do sitio',

		DATEADD(dd,+20,GETDATE()),NULL
		,'Media','Pendiente')
		
SELECT *
FROM EMPREGADO_PROXECTO

INSERT INTO EMPREGADO_PROXECTO
VALUES(
(SELECT NSSDirector
FROM DEPARTAMENTO
WHERE NomeDepartamento='T�cnico'),
(SELECT NumProxecto
FROM PROXECTO
WHERE NomeProxecto LIKE ('Dise�o nova web')),8)

INSERT INTO EMPREGADO_PROXECTO
VALUES (
(SELECT NSS
FROM EMPREGADO
WHERE Nome='Felix' AND Apelido1='Barreiro' AND Apelido2='Vali�a')
,
(SELECT NumProxecto
FROM PROXECTO
WHERE NomeProxecto LIKE ('Dise�o nova web')), 5)