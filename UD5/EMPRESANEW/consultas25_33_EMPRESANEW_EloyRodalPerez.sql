--ELOY RODAL PÉREZ
USE EMPRESANEW
GO

--25. Realiza unha consulta que devolva o nome, apelidos e departamento dos empregados que teñan o soldo máis baixo.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome completo], NumDepartamentoPertenece, Salario
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
ORDER BY LEN(Salario) ASC;

--26. Fai unha consulta que devolva o número de fillos de calquera sexo que ten cada empregado, pero só para aqueles nos que a suma das idades dos fillos sexa maior de 40.

SELECT COUNT(*) AS NumFillos, NSS_empregado
FROM FAMILIAR 
WHERE Parentesco IN ('Hijo', 'Hija') 
GROUP BY NSS_empregado
HAVING SUM(DATEDIFF(YEAR, DataNacemento, GETDATE())) > 40;

--27. Crea unha consulta que devolva o nome do departamento, nome e apelidos dos empregados que teñen un nome que comeza por  J, M ou R e teña por segunda letra o A, ou a dos empregados que teñen como xefe unha persoa que ten un apelido que comeza por V e teña 6 letras.

SELECT D.NomeDepartamento, E.Nome, E.Apelido1, E.Apelido2
FROM EMPREGADO E INNER JOIN DEPARTAMENTO D ON E.NumDepartamentoPertenece = D.NumDepartamento
WHERE 
    (E.Nome LIKE 'J%A' OR E.Nome LIKE 'M%A' OR E.Nome LIKE 'R%A')
    OR
    (E.NSSSupervisa IN (SELECT NSS FROM EMPREGADO WHERE Apelido1 LIKE 'V_____' AND LEN(Apelido1) = 6));

--28. Queremos ter información dos lugares nos que se están desenvolvendo proxectos nos que participe algún empregado do departamento 1. Realiza unha consulta que devolva esta información.  

SELECT DISTINCT L.*
FROM LUGAR L 
WHERE L.Num_departamento = 1 

--29. Calcula canto deberá pagar o departamento 2 aos seus empregados este ano sen ter en conta as pagas extras. 

SELECT SUM(Salario) AS TotalSalario
FROM EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE NumDepartamentoPertenece = 2;

--30. ¿Cales  son os empregados fixos (nome e apelidos) que tienen más edad ?.

SELECT Nome, Apelido1, Apelido2
FROM EMPREGADOFIXO EF INNER JOIN EMPREGADO E ON EF.NSS = E.NSS
ORDER BY DataNacemento DESC;


--31. Fai unha consulta que devolva o salario medio, o salario mínimo e o salario máximo que teñen os empregados que non son xefes de departamento por sexo.

SELECT CASE WHEN E.Sexo = 'H' THEN 'Hombres'
        ELSE 'Mujeres'
    END AS Sexo,
    AVG(1.0*EF.Salario) AS SalarioMedio,
    MIN(EF.Salario) AS SalarioMinimo,
    MAX(EF.Salario) AS SalarioMaximo
FROM 
    EMPREGADO E INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE 
    E.NSSSupervisa != E.NSS
GROUP BY 
    E.Sexo;

--32. Realiza unha consulta que busque os nomes dos proxectos nos que participan aquelas persoas que teñen o salario Nulo.

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome completo], NomeProxecto
FROM EMPREGADO E INNER JOIN EMPREGADO_PROXECTO EP ON E.NSS = EP.NSSEmpregado INNER JOIN PROXECTO P ON EP.NumProxecto = P.NumProxecto INNER JOIN EMPREGADOFIXO EF ON E.NSS = EF.NSS
WHERE Salario IS NULL;

--33. Mostra o nome completo dos empregados que teñen máis familiares ao seu cargo

SELECT E.Nome + ' ' + E.Apelido1 + ' ' + ISNULL(E.Apelido2, ' ') AS [Nome completo]
FROM EMPREGADO E INNER JOIN FAMILIAR F ON E.NSS = F.NSS
