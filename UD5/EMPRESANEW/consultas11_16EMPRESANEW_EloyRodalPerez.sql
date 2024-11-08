--ELOY RODAL PEREZ

USE EMPRESANEW
GO

--11 Mostra unha relaci�n de departamento (nome) y persoal (nome completo) asociados a este, ordeados por departamento e dentro deste por nome  completo en orden descendente.

SELECT D.NomeDepartamento,  E.Nome + ' ' + E.Apelido1 + ' ' + E.Apelido2 AS "Nome completo"
FROM DEPARTAMENTO D JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece
ORDER BY NomeDepartamento, [Nome completo];

--12  Selecciona todas as empregadas fixas que viven en Pontevedra, Santiago ou Vigo ou aqueles empregados fixos que cobran m�is de 3000 euros.

SELECT E.*
FROM EMPREGADO E JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario > 3000 AND Localidade IN ('Pontevedra', 'Santiago', 'Vigo') AND Sexo = 'M';

--13 Fai unha consulta que seleccione todas as empregadas (NSS, nome e apelido1) que viven en Pontevedra ou Vigo e que te�en alg�n familiar dado de alta na empresa.
SELECT DISTINCT E.NSS, E.Nome, E.Apelido1
FROM EMPREGADO E JOIN FAMILIAR F ON E.NSS = F.NSS_empregado 
WHERE E.Localidade IN ('Pontevedra', 'Vigo')
AND F.NSS_empregado IS NOT NULL;

--14 Fai unha relaci�n (nome do departamento e nome completo do empregado e do fillo/filla) de todos os empregados do departamento t�cnico ou de inform�tica e que son pais dun neno (de calquera sexo).
SELECT E.Nome + ' ' + E.Apelido1 + ' ' + E.Apelido2 AS "Nome completo", D.NomeDepartamento, F.Nome + ' ' + F.Apelido1 + ' ' + F.Apelido2 AS "Nome completo neno/nena"
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento JOIN FAMILIAR F ON F.NSS_empregado = E.NSS
WHERE D.NomeDepartamento IN ('T�CNICO', 'INFORM�TICA') AND F.Parentesco IN ('Hijo', 'Hija')

--15 Fai unha consulta que amose o 20% dos homes que traballan no departamento de Inform�tica, Estad�stica ou Innovaci�n.
SELECT TOP 20 PERCENT E.*
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE D.NomeDepartamento IN ('INFORM�TICA', 'ESTAD�STICA', 'INNOVACI�N') AND Sexo = 'H';

--16 Mostra todos os datos da t�boa empregado xunto co nome e n�mero de horas dos proxectos nos que participou o empregado e salario, pero s� para aqueles empregados fixos dos departamentos de Inform�tica e T�cnico que cobran entre 1500 e 3000 euros e que naceron con anterioridade ao ano 1980.
SELECT E.*, P.NomeProxecto, EP.Horas
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento JOIN PROXECTO P ON P.NumDepartControla = D.NumDepartamento JOIN EMPREGADO_PROXECTO EP ON EP.NSSEmpregado = E.NSS JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario > 1500 AND Salario < 3000 AND YEAR(DataNacemento) < 1980 AND D.NomeDepartamento IN ('INFORM�TICA', 'T�CNICO') AND E.NSS IN (SELECT NSS FROM EMPREGADOFIXO);