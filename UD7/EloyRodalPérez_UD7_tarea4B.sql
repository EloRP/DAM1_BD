--ELOY RODAL P�REZ
USE SOCIEDADE_CULTURAL
GO


--10)  NIF dos empregados cuxos salarios mensuais son maiores que a suma dos prezos das actividades que imparte.
SELECT * FROM EMPREGADO
WHERE salario_mes > (SELECT SUM(PREZO) FROM ACTIVIDADE
					 WHERE num_profesorado_imparte=EMPREGADO.numero)
					 
--11)  NIF, nome completo e o cargo de todos os empregados, xunto co nome das actividades que cursan. A�nda que un empregado non curse ningunha actividade tam�n debe aparecer.
SELECT NIF, E.NOME+ ' '+APE1+ ' '+ ISNULL(APE2,' ') [NOME COMPLETO],
CARGO, A.nome AS [NOME ACTIVIDADE]
FROM EMPREGADO E LEFT JOIN PROFE_CURSA_ACTI PACT
ON E.numero = PACT.num_profesorado
LEFT JOIN ACTIVIDADE A ON PACT.id_actividade=A.identificador				--EN ESTE CASO EL LEFT JOIN PILLA A LOS QUE NO HAGAN ACTIVIDADES TMB


--12)  NIF e gasto en actividades realizadas dos socios que levan gastado en actividades m�is do valor da cota m�xima.
SELECT NIF, SUM(PREZO)
FROM SOCIO S INNER JOIN SOCIO_REALIZA_ACTI SACT
ON S.numero = SACT.num_socio
				INNER JOIN ACTIVIDADE ACT
				ON SACT.id_actividade=ACT.identificador
GROUP BY nif
HAVING SUM(prezo) > (SELECT MAX(IMPORTE) FROM COTA)

--13)  Numero, descrici�n, superficie e estado das aulas xunto co nome, prezo  das actividades e n�mero de aula na que se imparten. Faino das seguintes maneiras (Repasa a combinaci�n de tablas e os posibles casos de combinaci�n):

--a)Deben aparecer todas as actividades independentemente de te�en ou non asignadas unha aula
SELECT aula.descricion, aula.numero, AULA.superficie,
ACTIVIDADE.nome,ACTIVIDADE.prezo,ACTIVIDADE.num_aula
FROM AULA RIGHT JOIN ACTIVIDADE
ON AULA.numero = ACTIVIDADE.num_aula

--b)Deben aparecer todas as aulas a�nda que non te�an asociada ningunha actividade

SELECT AULA.descricion, AULA.numero, AULA.superficie,
ACTIVIDADE.nome,ACTIVIDADE.prezo,ACTIVIDADE.num_aula
FROM AULA LEFT JOIN ACTIVIDADE
ON AULA.numero=ACTIVIDADE.num_aula
--c)Deben aparecer todas as actividades independentemente de te�en ou non asignadas unha aula, e todas as aulas a�nda que non te�an asociada ningunha actividade.   

SELECT AULA.descricion, AULA.numero, AULA.superficie,
ACTIVIDADE.nome,ACTIVIDADE.prezo,ACTIVIDADE.num_aula
FROM AULA FULL JOIN ACTIVIDADE
ON AULA.numero=ACTIVIDADE.num_aula

-- 14)  Obt�n as datas de inicio e fin, e duraci�n en d�as, meses, semanas e horas de todas as actividades.
SELECT IDENTIFICADOR, DATA_INI, DATA_FIN,
DATEDIFF(DAY, DATA_INI,DATA_FIN) [DURACION EN DIAS],
DATEDIFF(MONTH, DATA_INI, DATA_FIN) [DURACI�N EN MESES] ,
DATEDIFF(WEEK,DATA_INI,DATA_FIN) [DURACION EN SEMANAS],
DATEDIFF(HOUR,DATA_INI,DATA_FIN) [DURACION EN HORAS]
FROM ACTIVIDADE

--15)  Listaxe coa data de inicio das actividades na primeira columna. Nas seguintes aparecer�n: a data de inicio adiantada 1 ano, a data de inicio adiantada 3 meses, a data de inicio retrasada 4 d�as e a data de inicio retrasada 2 horas.

SELECT data_ini, DATEADD(YEAR,-1,DATA_INI) [FECHA INICIO ADELANTADA 1 A�O],
DATEADD(MONTH,-3,DATA_INI) [FECHA INICIO ADELANTADA 3 MESES],
DATEADD(DAY,4,DATA_INI) [FECHA INICIO RETRASADA 4 D�AS],
DATEADD(HOUR,2,DATA_INI) [FECHA INICIO RETRASADA DOS HORAS]
FROM ACTIVIDADE

--16)  Queremos crear unha t�boa de nome INFO_TELEFONOS co nome, apelidos e tel�fono de todos os socios. Deber� visualizarse o tel�fono1, se o ten, sen�n o tel�fono2, e se non ten tel�fono amosarase a frase 'Sen tel�fono'.

IF OBJECT_ID ('INFO_TELEFONOS') IS NOT NULL
DROP TABLE INFO_TELEFONOS
GO

SELECT NOME+' '+ APE1+' '+ISNULL(APE2,'') AS NOMBRECOMPLETO,
COALESCE(TELEFONO1, TELEFONO2, 'SIN TELEFONO') AS TELEFONO		--METE TODO LO QUE PIDE SI HAY EN LA TABLA
INTO INFO_TELEFONOS FROM SOCIO

--17)  �Quen son os socios  que est�n apuntados a m�is actividades? faino  de dous maneiras: 1.-con top e 2.- de forma est�ndar ( sin utilizar top)

--CON TOP

SELECT TOP 1 WITH TIES NUMERO, NOME+' '+APE1+' ' + ISNULL(APE2, '') AS NOMECOMPLETO
FROM SOCIO S INNER JOIN SOCIO_REALIZA_ACTI SACT ON S.numero = SACT.num_socio
GROUP BY numero,nome,ape1,ape2
ORDER BY COUNT(*) DESC

--18)  Reformase a  aula de coci�a para que o seu estado sexa Bo e ampl�ase en 20 metros m�is dos que ti�a. Actualiza a informaci�n na base de datos.
SELECT * FROM AULA
--
UPDATE AULA
SET estado='B', superficie=superficie+20
WHERE descricion='coci�a'


--19)  Ap�ntase un novo socio � sociedade. O seu nif � 90897867B e o seu nome � Peter Smith.  
--Naceu o 19 de febreiro de 1990 e o seu tel�fono � 690112233. Vive na r�a Paz n�15 15444 Milladoiro (A Coru�a). 
--Entra por recomendaci�n de Jorge del Carmen L�rez  e vai  ser do mesmo tipo de socio que �ste. 
-- Abona ao apuntarse a cota habitual e vai realizar a actividade de Zumba, que xa deixa pagada. 
--Introduce esta informaci�n na base de datos tendo en conta que  queremos asegurarnos de que a informaci�n da base de datos quede consistente. 
-- (Non quede a operaci�n a medias e faino das maneiras que co�ezas)

--CON TRAN
BEGIN TRAN
BEGIN TRY
	DECLARE @NUMSOCIO INT
	SET @NUMSOCIO=(SELECT MAX(NUMERO) + 1 FROM SOCIO)
	
	INSERT INTO SOCIO
	VALUES(@NUMSOCIO,'90897867B',NULL,'Peter','Smith',NULL,
		  '690112233',NULL,'19-02-1990', 'R�A', 'PAZ', 15,
		  NULL, 'MILLADORIO', '15444',
		  (SELECT CODIGO FROM PROVINCIA WHERE NOME='A Coru�a'),
		  (SELECT TIPO FROM SOCIO WHERE NOME='Jorge' AND APE1='del Carmen'
		  AND APE2='L�rez'),NULL, 'S',
		  (SELECT CODIGO FROM COTA WHERE NOME='HABITUAL'),
		  (SELECT NUMERO FROM SOCIO WHERE NOME='Jorge' AND APE1='del Carmen' and APE2='L�rez')
		  )
	INSERT INTO SOCIO_REALIZA_ACTI
	VALUES(@numsocio,(SELECT IDENTIFICADOR
					  FROM ACTIVIDADE WHERE NOME='ZUMBA'),'S')
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	PRINT 'ERROR'
END CATCH
GO

SET IMPLICIT_TRANSACTIONS ON
BEGIN TRY
	DECLARE @numsocio INT
	SET @numsocio = (SELECT MAX(NUMERO)+ 1 FROM SOCIO)
	
	INSERT INTO SOCIO
	VALUES(@NUMSOCIO,'90897867B',NULL,'Peter','Smith',NULL,
		  '690112233',NULL,'19-02-1990', 'R�A', 'PAZ', 15,
		  NULL, 'MILLADORIO', '15444',
		  (SELECT CODIGO FROM PROVINCIA WHERE NOME='A Coru�a'),
		  (SELECT TIPO FROM SOCIO WHERE NOME='Jorge' AND APE1='del Carmen' AND APE2='L�rez'),NULL, 'S',
		  (SELECT CODIGO FROM COTA WHERE NOME='HABITUAL'),
		  (SELECT NUMERO FROM SOCIO WHERE NOME='Jorge' AND APE1='del Carmen' and APE2='L�rez')
		  )
		  
		  INSERT INTO SOCIO_REALIZA_ACTI
		  VALUES(@numsocio,(SELECT IDENTIFICADOR FROM ACTIVIDADE WHERE NOME='ZUMBA'),'S')
	COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
		PRINT 'ERROR'
	END CATCH
	SET IMPLICIT_TRANSACTIONS OFF