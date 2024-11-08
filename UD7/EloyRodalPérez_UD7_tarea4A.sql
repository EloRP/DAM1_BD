--ELOY RODAL PÉREZ
USE SOCIEDADE_CULTURAL
GO

--2)Indica o número  de aulas que hai nos distintos estados . Nunha columna aparecerá cada estado diferente (co texto Ben, Mal ou Regular) e noutra o número de aulas de cada estado. Faino de dúas maneiras e ver  cal é máis óptima.  
SELECT CASE ESTADO
	   WHEN 'B' THEN 'Ben'
	   WHEN 'R' THEN 'Regular'
	   ELSE 'Mal'
	   END AS ESTADO, COUNT(*) AS [Número de aulas]
FROM AULA
GROUP BY ESTADO
ORDER BY 2

--SI SE PONE EN ALL EN UNION MEJORA BASTANTE EL RENDIMIENTO.

SELECT 'Ben' AS ESTADO, COUNT(*) AS [Número de aulas]
FROM AULA AS [Número de aulas] WHERE ESTADO='B'
UNION ALL
SELECT 'Regular', COUNT(*) FROM AULA WHERE ESTADO='R'
UNION ALL
SELECT 'Mal', COUNT(*) FROM AULA WHERE ESTADO='M'
ORDER BY 2;

--3)Nome, data de inicio ( formato: dd de mes de yyyy), hora (hh:mm), prezo daquelas actividades non gratuítas do mes de febreiro de calquera ano. Faino de dúas maneiras  e ver  cal é máis óptima ( ou mes ten que ir en letras,  exemplo,  xaneiro,etc..   

--                nome                           data inicio                                          hora            prezo

--			  TENIS PARA PRINCIPIANTES		Lunes, 10 de Febrero de 2014							  16:00            301.55

--Hazla consulta de dos manera y ver cúal es la más optima

SELECT nome, DATENAME(WEEKDAY,data_ini)+', '+
DATENAME(DAY,data_ini)+' de '+ DATENAME(month,data_ini)+' de ' +
DATENAME(YEAR,data_ini) as [data inicio],
DATENAME(hour,data_ini) + ':'+CASE DATEPART(MINUTE,data_ini)
							  WHEN '0' THEN '00'
							  ELSE DATENAME(MINUTE,data_ini) END
as HORA,PREZO
FROM ACTIVIDADE
WHERE PREZO>0 AND MONTH(data_ini)=2


--4)     a)Indica o nome e a aula das actividades nas que participan menos de dous socios.
SELECT NOME, num_aula ,COUNT(*) [NUMERO DE SOCIO]
FROM SOCIO_REALIZA_ACTI SACT INNER JOIN ACTIVIDADE ACT ON SACT.id_actividade=ACT.identificador
GROUP BY nome,num_aula
HAVING COUNT(*) < 2
-- b)Para las actividades nas que participan máis de 1 socio, visualizar nome, aula e o número de profesoresque a cursan
SELECT NOME, num_aula ,COUNT(*) [NUMERO DE PROFESORADO]
FROM PROFE_CURSA_ACTI PACTI INNER JOIN ACTIVIDADE ACT ON PACTI.id_actividade = ACT.identificador
WHERE id_actividade IN
				(SELECT id_actividade
				 FROM SOCIO_REALIZA_ACTI
				 GROUP BY id_actividade
				 HAVING COUNT(*)>1)
GROUP BY nome, num_aula

--5)     Visualiza o  NIF ( formato dd.ddd.dd-letra), nome completo e teléfono fixo xunto á localidade con formato:(localidad)ddd-dd-dd-dd)  dos empregados que non asisten a actividades e dos que temos o teléfono fixo.

--Faino das seguintes maneiras:  subconsultas,  text de existencia e  multitabla. Ver cales son as máis óptimas.

SELECT LEFT(NIF,2) + '.'+ SUBSTRING(NIF,3,3)+'.'+
SUBSTRING(NIF,6,3)+'-'+RIGHT(NIF,1) AS [TELEFONO FIXO]
,NOME+' '+APE1+' '+ISNULL(APE2,'') AS [NOME COMPLETO],'('+
LOCALIDADE_ENDEREZO+') '+LEFT(TEL_FIXO,3)+'-'+
SUBSTRING(TEL_FIXO,4,2)+'-'+SUBSTRING(TEL_FIXO,6,2)+
'-'+RIGHT(TEL_FIXO,2)
FROM EMPREGADO
WHERE numero NOT IN
(SELECT NUM_PROFESORADO FROM PROFE_CURSA_ACTI)
AND tel_fixo IS NOT NULL

--TEST DE EXISTENCIA NOT EXISTS
SELECT LEFT(NIF,2)+'.'+SUBSTRING(NIF,3,3)+'.'+SUBSTRING(NIF,6,3)+RIGHT(NIF,1) AS [TELEFONO FIXO]
,NOME+' '+APE1+' '+ISNULL(APE2,'') AS [NOME COMPLETO],'('+
LOCALIDADE_ENDEREZO+') '+LEFT(TEL_FIXO,3)+'-'+
SUBSTRING(TEL_FIXO,4,2)+'-'+SUBSTRING(TEL_FIXO,6,2)+
'-'+RIGHT(TEL_FIXO,2)
FROM EMPREGADO
WHERE NOT EXISTS (SELECT * FROM PROFE_CURSA_ACTI WHERE num_profesorado=numero)
AND tel_fixo IS NOT NULL

--MULTITABLA
SELECT LEFT(NIF,2)+'.'+SUBSTRING(NIF,3,3)+'.'+SUBSTRING(NIF,6,3)+RIGHT(NIF,1) AS [TELEFONO FIXO]
,NOME+' '+APE1+' '+ISNULL(APE2,'') AS [NOME COMPLETO],'('+
LOCALIDADE_ENDEREZO+') '+LEFT(TEL_FIXO,3)+'-'+
SUBSTRING(TEL_FIXO,4,2)+'-'+SUBSTRING(TEL_FIXO,6,2)+
'-'+RIGHT(TEL_FIXO,2)
FROM EMPREGADO LEFT JOIN PROFE_CURSA_ACTI ON num_profesorado = numero
WHERE num_profesorado is null and tel_fixo is not null

--6)     a)Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades con prezo menor que a cota máis cara existente. Se é menor que algunha será menor q a máis cara. 

--          NOTA -Podes utilizar a función  convert para o formato de data, mira na axuda cal é o código que tes que poñer para saír con este formato.   

--CONVERT ( tipo de datos, expresión [ , código del estilo ] 
-- - Para filtrar o comparar los datos, faino das seguintes maneiras:  -1.- utilizando solo un operador de comparación ( <,>,=,...)  e 2- utilizando operador comparación máis operador de conxunto (>some, <some,>all ,=in, etc....)

SELECT NOME,CONVERT(varchar(8), data_ini, 103) datainicio,
convert(varchar(8),data_fin,103) datafin,
DATEDIFF(WEEK, data_ini,data_fin) [Duración en semanas]
FROM ACTIVIDADE
WHERE prezo < (SELECT MAX(importe) from COTA)
----------------------------------------------------------------------
SELECT NOME, CONVERT(VARCHAR(8),DATA_INI,103) DATAINICIO, 
CONVERT(varchar(8),data_fin,103) datafin,
DATEDIFF(WEEK,DATA_INI,DATA_FIN) [DURACIÓN EN SEMANAS] FROM ACTIVIDADE
WHERE PREZO < SOME (SELECT IMPORTE FROM COTA)



--    b)  Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades  que superar la media de la duración en semanas de todas las actividades
SELECT NOME,CONVERT(varchar(8), data_ini,103) datainicio, CONVERT(varchar(8),data_fin,103) datafin,
DATEDIFF(WEEK,DATA_INI,DATA_FIN) [DURACIÓN EN SEMANAS] FROM ACTIVIDADE
WHERE DATEDIFF(WEEK,DATA_INI,DATA_FIN) >
(SELECT AVG(DATEDIFF(WEEK,DATA_INI,DATA_FIN) * 1.0) [DURACIÓN EN SEMANAS]
FROM ACTIVIDADE)


--   c) Nome, data de inicio e fin (solo fecha formato dd/mm/aaaa) e duración en semanas das actividades  que superan a media da duración en semanas  só tendo en conta as actividades con igual o menor prezo.
SELECT NOME,CONVERT(varchar(8), data_ini,103) datainicio, CONVERT(varchar(8),data_fin,103) datafin,
DATEDIFF(WEEK,DATA_INI,DATA_FIN) [DURACIÓN EN SEMANAS] 
FROM ACTIVIDADE A1
WHERE DATEDIFF(WEEK,DATA_INI,DATA_FIN)>
(SELECT AVG(DATEDIFF(WEEK,DATA_INI,DATA_FIN)*1.0) [DURACIÓN EN SEMANAS]
FROM ACTIVIDADE A2
WHERE A1.prezo > A2.PREZO)
--7)     Nome e importe das cotas que están asignadas a un socio polo menos e cuxo prezo está entre 40 e 100€.

--- Resólvea de TRES maneiras: utilizando  joins ( multitabla), con  subconsultas, e con test de existencia. Ver  cal é a máis óptima
--MULTITABLA
SELECT DISTINCT COTA.nome, IMPORTE
FROM COTA INNER JOIN SOCIO ON codigo=cod_cota
WHERE importe BETWEEN 40 AND 100

--SUBCONSULTA
SELECT NOME,IMPORTE FROM COTA
WHERE codigo IN(SELECT COD_COTA FROM SOCIO)
AND importe BETWEEN 40 AND 100

--TEST DE EXISTENCIA
SELECT NOME,IMPORTE FROM COTA
WHERE EXISTS(SELECT * FROM SOCIO WHERE cod_cota = codigo)
AND importe BETWEEN 40 AND 100


--8)     NIF e nome completo dos socios que realizan actividades impartidas por profesores que cursan algunha actividade. - Resólvea de dúas maneiras: utilizando  joins ( multitabla), con  subconsultas sin utilizar joins, Ver  cal é a máis óptima

--CON MULTITABLAS (JOINS)
SELECT DISTINCT S.NIF,S.NOME,S.APE1,S.APE2 FROM SOCIO S
INNER JOIN SOCIO_REALIZA_ACTI SACT ON S.numero = SACT.num_socio
INNER JOIN ACTIVIDADE ACT ON SACT.id_actividade = ACT.identificador
INNER JOIN PROFE_CURSA_ACTI PACT ON PACT.num_profesorado=ACT.num_profesorado_imparte

--CON SUBCONSULTAS ANIDADAS
SELECT NIF,NOME,APE1,APE2 FROM SOCIO
WHERE numero IN (SELECT num_socio FROM SOCIO_REALIZA_ACTI
				 WHERE id_actividade IN
									(SELECT IDENTIFICADOR
									 FROM ACTIVIDADE
									 WHERE num_profesorado_imparte IN 
									 (SELECT num_profesorado
									  FROM PROFE_CURSA_ACTI)))



--9)     a) Para cada socio que recomendou a outro socio, visualiza  nif,  nombrecompleto, numero de socios recomendados, numero de actividades que cursa.
SELECT DISTINCT SOCRECOM.NIF, SOCRECOM.NOME + ' '+
SOCRECOM.APE1+' '+ISNULL(SOCRECOM.APE2,' ') AS [Nombre completo],
(SELECT COUNT(*) FROM SOCIO S2 WHERE S2.socio_recomienda=SOCRECOM.NUMERO) [NUMERO DE SOCIOS RECOMENDADO],
(SELECT COUNT(*) FROM SOCIO_REALIZA_ACTI 
		WHERE SOCRECOM.NUMERO=num_socio) [NUMERO ACTIVIDADES]
FROM SOCIO S1 INNER JOIN SOCIO SOCRECOM
ON S1.SOCIO_RECOMIENDA=SOCRECOM.NUMERO
--b) Para cada socio, visualiza o seu  nif , nome completo, idade e nome completo,  nif e idade do socio que lle recomendou. Se non foi recomendado mostrarase esta información en branco.
SELECT S1.NIF,S1.NOME + ' ' +S1.APE1+ ' ' +ISNULL(S1.APE2,' ')
AS [NOMBRE COMPLETO],

DATEDIFF(yy,S1.data_nac,GETDATE())+ CASE
				WHEN (MONTH(GETDATE())<MONTH(S1.data_nac))
				OR (MONTH(GETDATE()) = MONTH(S1.data_nac) AND
				DAY(GETDATE())<DAY(S1.DATA_NAC))
				THEN -1 ELSE 0 END [EDAD SOCIO],
				
ISNULL(SOCRECOM.nif,' ') AS [NIF SOCIO RECOMIENDA]
,ISNULL(SOCRECOM.nome + ' '+SOCRECOM.ape1+' '+
ISNULL(SOCRECOM.ape2,' '),'') AS [NOMBRE COMPLETO SOCIO RECOMIENDA],

DATEDIFF(yy, SOCRECOM.DATA_NAC,GETDATE()) + CASE
					WHEN (MONTH(GETDATE()) < MONTH(SOCRECOM.data_nac))
					OR (MONTH(GETDATE()) = MONTH(SOCRECOM.data_nac) AND
					DAY(GETDATE()) < DAY(SOCRECOM.data_nac))
					THEN -1 ELSE 0 END [EDAD SOCIO RECOMIENDA]
					
FROM SOCIO S1 LEFT JOIN SOCIO SOCRECOM
ON S1.socio_recomienda= SOCRECOM.numero


--c) Para cada socio que realiza máis dunha actividade, visualiza a súa  nif , nome completo, idade e nome completo do socio que lle recomendou. Se non foi recomendado mostrarase esta información en branco.
SELECT NIF, S.NOME + ' ' + APE1 + ' ' + ISNULL(APE2, ' ') AS NOME_COMPLETO,
DATEDIFF(DD, DATA_NAC, GETDATE()) / 365 AS IDADE,
ISNULL(CAST((SELECT NIF FROM SOCIO R1
			 WHERE S.SOCIO_RECOMIENDA = R1.numero) AS VARCHAR(9)), '') AS [NIF SOCIO RECOMIENDA],
ISNULL(CAST((SELECT DATEDIFF(DD, DATA_NAC, GETDATE()) / 365
			FROM SOCIO R
			WHERE S.SOCIO_RECOMIENDA = R.numero) AS VARCHAR(3)), '')
FROM SOCIO S
WHERE 1 < (SELECT COUNT(NUM_SOCIO)
		   FROM SOCIO_REALIZA_ACTI SRA
		   WHERE S.numero = SRA.num_socio)