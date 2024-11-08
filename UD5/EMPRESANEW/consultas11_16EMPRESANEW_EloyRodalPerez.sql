--ELOY RODAL PEREZ

USE EMPRESANEW
GO

--11 Mostra unha relación de departamento (nome) y persoal (nome completo) asociados a este, ordeados por departamento e dentro deste por nome  completo en orden descendente.

SELECT D.NomeDepartamento,  E.Nome + ' ' + E.Apelido1 + ' ' + E.Apelido2 AS "Nome completo"
FROM DEPARTAMENTO D JOIN EMPREGADO E ON D.NumDepartamento = E.NumDepartamentoPertenece
ORDER BY NomeDepartamento, [Nome completo];

--12  Selecciona todas as empregadas fixas que viven en Pontevedra, Santiago ou Vigo ou aqueles empregados fixos que cobran máis de 3000 euros.

SELECT E.*
FROM EMPREGADO E JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario > 3000 AND Localidade IN ('Pontevedra', 'Santiago', 'Vigo') AND Sexo = 'M';

--13 Fai unha consulta que seleccione todas as empregadas (NSS, nome e apelido1) que viven en Pontevedra ou Vigo e que teñen algún familiar dado de alta na empresa.
SELECT DISTINCT E.NSS, E.Nome, E.Apelido1
FROM EMPREGADO E JOIN FAMILIAR F ON E.NSS = F.NSS_empregado 
WHERE E.Localidade IN ('Pontevedra', 'Vigo')
AND F.NSS_empregado IS NOT NULL;

--14 Fai unha relación (nome do departamento e nome completo do empregado e do fillo/filla) de todos os empregados do departamento técnico ou de informática e que son pais dun neno (de calquera sexo).
SELECT E.Nome + ' ' + E.Apelido1 + ' ' + E.Apelido2 AS "Nome completo", D.NomeDepartamento, F.Nome + ' ' + F.Apelido1 + ' ' + F.Apelido2 AS "Nome completo neno/nena"
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento JOIN FAMILIAR F ON F.NSS_empregado = E.NSS
WHERE D.NomeDepartamento IN ('TÉCNICO', 'INFORMÁTICA') AND F.Parentesco IN ('Hijo', 'Hija')

--15 Fai unha consulta que amose o 20% dos homes que traballan no departamento de Informática, Estadística ou Innovación.
SELECT TOP 20 PERCENT E.*
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE D.NomeDepartamento IN ('INFORMÁTICA', 'ESTADÍSTICA', 'INNOVACIÓN') AND Sexo = 'H';

--16 Mostra todos os datos da táboa empregado xunto co nome e número de horas dos proxectos nos que participou o empregado e salario, pero só para aqueles empregados fixos dos departamentos de Informática e Técnico que cobran entre 1500 e 3000 euros e que naceron con anterioridade ao ano 1980.
SELECT E.*, P.NomeProxecto, EP.Horas
FROM EMPREGADO E JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento JOIN PROXECTO P ON P.NumDepartControla = D.NumDepartamento JOIN EMPREGADO_PROXECTO EP ON EP.NSSEmpregado = E.NSS JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario > 1500 AND Salario < 3000 AND YEAR(DataNacemento) < 1980 AND D.NomeDepartamento IN ('INFORMÁTICA', 'TÉCNICO') AND E.NSS IN (SELECT NSS FROM EMPREGADOFIXO);