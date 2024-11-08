--ELOY RODAL PEREZ

USE EMPRESANEW
GO

--17._ ¿Cánto suman os salarios dos empregados fixos? ¿E cal é a media? Fai unha consulta que devolva os dous valores.

SELECT SUM(Salario) as [SUMA SALARIO], AVG(Salario) as [MEDIA SALARIO]
FROM EMPREGADOFIXO

--18._ Fai unha consulta que devolva o número de empregados fixos que ten cada departamento e a media dos salarios.

SELECT 
    NumDepartamento,
    COUNT(*) AS [NUMERO DE EMPREGADOS FIXOS],
    ROUND(AVG(Salario), 2) AS [MEDIA DE SALARIOS]
FROM EMPREGADOFIXO EF INNER JOIN EMPREGADO E ON EF.NSS = E.NSS INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
GROUP BY NumDepartamento;


--19._ Fai unha consulta que nos diga cantos empregados naceron cada ano a partir de 1969.
SELECT COUNT(*) AS [NUM TOTAL EMPREGADOS]
FROM EMPREGADO
WHERE DataNacemento >= 1969

--20._Fai unha consulta que devolva o número de empregados de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de homes é 24 (e o mesmo para as mulleres).  
SELECT
    'O número de homes é ' + CAST(COUNT(CASE WHEN Sexo = 'H' THEN 1 END) AS VARCHAR) + '.',
    'O número de mulleres é ' + CAST(COUNT(CASE WHEN Sexo = 'M' THEN 1 END) AS VARCHAR) + '.'
FROM EMPREGADO; 
--21._Fai unha consulta que devolva o número de empregados temporales e fixos de cada sexo. Deberá visualizarse o texto do xeito seguinte: O número de empregados fixos de sexo masculino son 24 (e o mesmo para as mulleres e os empregados temporais). 
SELECT
    'O número de homes é ' + CAST(COUNT(CASE WHEN Sexo = 'H' THEN 1 END) AS VARCHAR) + '.',
    'O número de mulleres é ' + CAST(COUNT(CASE WHEN Sexo = 'M' THEN 1 END) AS VARCHAR) + '.',
    'O número de home fixos é ' + CAST(COUNT(CASE WHEN Sexo = 'H' AND EF.NSS IS NOT NULL THEN 1 END) AS VARCHAR) + '.',
    'O número de mulleres que son empregadas fixas é ' + CAST(COUNT(CASE WHEN Sexo = 'M' AND EF.NSS IS NOT NULL THEN 1 END) AS VARCHAR) + '.'
FROM EMPREGADO E LEFT JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS;

--22._Mostra o nome completo dos empregados que teñen máis dun fillo de calquera sexo.
SELECT DISTINCT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome completo]
FROM EMPREGADO E INNER JOIN FAMILIAR F ON F.NSS_empregado = E.NSS
WHERE F.Parentesco IN ('Hijo', 'Hija') AND F.Numero > 1

--23._Crea unha consulta que mostre para cada empregado (nome e apelido mostrados nun so campo chamado Nome_completo) as horas totais que traballa cada empregado en todos os proxectos.
SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome_completo], SUM(EP.Horas) AS [Horas totais]
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY E.Nome, E.Apelido1, E.Apelido2;

--24._ Supoñendo que as horas semanais que debe traballar un empregado son 40, modifica a consulta anterior para que amose os traballadores que teñen sobrecarga, indicando en cantas horas se pasan.
SELECT DISTINCT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome_completo], SUM(EP.Horas) AS [Horas totais],
CASE WHEN SUM(EP.Horas) > 40 THEN SUM(EP.Horas) - 40 ELSE ' ' END AS Sobrecarga
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado
GROUP BY E.Nome, E.Apelido1, E.Apelido2
HAVING SUM(EP.Horas) > 0