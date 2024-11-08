--ELOY RODAL PÉREZ
USE EMPRESANEW
GO

--1 El día de ayer el empleado Eligio Rodrigo y Xiao Vecino Vecino trabajaron 3 horas extra cada uno.
INSERT INTO HORASEXTRAS (Data, HorasExtras, NSS)
VALUES (DATEADD (DD,-1,GETDATE()),3,(SELECT E.NSS FROM EMPREGADO E INNER JOIN HORASEXTRAS H	ON E.NSS=H.NSS
WHERE E.Nome IN ('Eligio') AND Apelido1 IN ('Rodrigo')AND Apelido2 IS NULL));


INSERT INTO HORASEXTRAS (Data,HorasExtras,NSS)
VALUES (DATEADD (DD,-1,GETDATE()),3,(SELECT E.NSS FROM EMPREGADO E INNER JOIN HORASEXTRAS H ON E.NSS=H.NSS
WHERE E.Nome IN ('Xiao') AND Apelido1 IN ('Vecino') AND Apelido2 IN ('Vecino')))


--2 Se va a impartir un nuevo curso de "Diseño Web" de 30 horas. La primera edición se va a realizar el 15 de abril en Pontevedra y su profesor va a ser el jefe de departamento  Técnico.
SELECT *
FROM CURSO
INSERT INTO CURSO (Nome,Horas)
VALUES ('Diseño web',30)

SELECT *
FROM EDICION

INSERT INTO EDICION
VALUES (
		(SELECT codigo
		FROM CURSO
		WHERE Nome LIKE ('Diseño web'))
		,
		(SELECT ISNULL(MAX(Numero),0)
		FROM EDICION
		WHERE Codigo=9)+1,'2021-04-15','Pontevedra',
		(SELECT NSSDirector
		FROM DEPARTAMENTO
		WHERE NomeDepartamento LIKE ('Técnico'))
		)

--3 A esta edición del curso asistirán todos los empleados de este departamento (salvo el jefe).
SELECT *
FROM EDICIONCURSO_EMPREGADO

INSERT INTO EDICIONCURSO_EMPREGADO
SELECT (SELECT codigo
		FROM CURSO
		WHERE Nome LIKE ('Diseño web')),
		(SELECT Numero
		FROM EDICION
		WHERE DATA='2021-04-15'), NSS
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece=d.NumDepartamento
WHERE NOT EXISTS (SELECT *
				FROM DEPARTAMENTO
				WHERE NSSDirector=NSS)
AND NomeDepartamento LIKE ('Técnico')

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

--5 Hubo un error en la asignación de proyectos. La empleada con NSS=9900000 está trabajando en el proyecto "Portal"  en lugar de trabajar en el proyecto "Xestión da calidade". Corrígelo.
UPDATE EMPREGADO_PROXECTO
SET NumProxecto=(SELECT NumProxecto
					FROM PROXECTO p
					WHERE p.NomeProxecto LIKE ('Xestion da calidade'))
WHERE NSSEmpregado=9900000

SELECT *
FROM EMPREGADO_PROXECTO
WHERE NSSEmpregado=9900000

/*6 Añade el proyecto "Deseño nova WEB" que se levará a cabo en Vigo e estará controlado polo departamento Técnico . De momento consta de dúas tareas:
"Definir o obxectivo da páxina", que dará comezo dentro de 15 días e ten unha duración de 7 días. A súa dificultade é media.
"Elexir o estilo e crear o mapa do sitio", que comezará dentro de 20 días e ten unha dificultade media. */
SELECT *
FROM PROXECTO

INSERT INTO proxecto
VALUES ((SELECT MAX(NumProxecto) FROM PROXECTO)+1,'Diseño nova web',
'Vigo',(SELECT NumDepartamento
		FROM DEPARTAMENTO
		WHERE NomeDepartamento='Técnico'))


SELECT *
FROM TAREFA

INSERT INTO TAREFA
VALUES(
		(SELECT NumProxecto
		FROM PROXECTO
		WHERE NomeProxecto LIKE ('Diseño nova web'))
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
		WHERE NomeProxecto LIKE ('Diseño nova web'))
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
WHERE NomeDepartamento='Técnico'),
(SELECT NumProxecto
FROM PROXECTO
WHERE NomeProxecto LIKE ('Diseño nova web')),8)

INSERT INTO EMPREGADO_PROXECTO
VALUES (
(SELECT NSS
FROM EMPREGADO
WHERE Nome='Felix' AND Apelido1='Barreiro' AND Apelido2='Valiña')
,
(SELECT NumProxecto
FROM PROXECTO
WHERE NomeProxecto LIKE ('Diseño nova web')), 5)