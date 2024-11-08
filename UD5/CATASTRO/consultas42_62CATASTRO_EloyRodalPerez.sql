--ELOY RODAL P�REZ
USE CATASTRO
GO

--42. �Cu�l es la m�xima altura que tienen los pisos que pertenecen a un propietario cuyo nombre empieza por M?
SELECT MAX(PLANTA) AS [ALTURA MAX]
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE NOMBRE LIKE 'M%'


--CON SUBCONSULTAS
SELECT DISTINCT MAX(PLANTA) AS [ALTURA MAX]
FROM PISO
WHERE DNIPROPIETARIO IN (SELECT DISTINCT DNI FROM PROPIETARIO WHERE NOMBRE LIKE 'M%')

--43. Haz una consulta que devuelva el total de parques que hay en la ciudad .
SELECT SUM(NUMPARQUES) AS [NUM TOTAL PARQUES]
FROM ZONAURBANA

--44. Haz una consulta que nos indique cual es el tama�o del solar m�s grande.
SELECT MAX(METROSSOLAR) AS [TAMA�O MAX SOLAR]
FROM VIVIENDA

--45. �Cu�l es la m�xima altura que tienen los pisos en la calle Damasco? (Utiliza la tabla piso).
SELECT MAX(PLANTA) AS [ALTURA MAX EN DAMASCO]
FROM PISO
WHERE CALLE = 'Damasco'

--46. Indica cual es el tama�o m�nimo y m�ximo (de metros �tiles) de los pisos situados en la calle Luca de Tena 22.
SELECT MIN(METROSUTILES) AS [MIN METROS UTILES], MAX(METROSUTILES) AS [MAX METROS UTILES] 
FROM PISO
WHERE CALLE = 'Luca de Tena' and NUMERO = '22'

--47. Obtener la media de parques por zona urbana.
SELECT AVG(CAST(NUMPARQUES AS FLOAT)) AS [MEDIA DE PARQUES X ZONA URBANA]
FROM ZONAURBANA

--48. Indica cuantas viviendas unifamiliares hay en la zona Palomar o Atocha.
SELECT COUNT(*) AS [NUM VIVIENDAS UNIFAMILIARES]
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'CASA' AND NOMBREZONA IN ('Palomar', 'Atocha')

--49. �Cu�l es el tama�o medio de una vivienda unifamiliar?.
SELECT AVG(CAST(METROSCONSTRUIDOS AS FLOAT)) AS [TAMA�O MEDIO VIVIENDA]
FROM CASAPARTICULAR

--50. �Cu�ntos bloques de pisos hay en la zona Centro o Cuatrovientos cuyo solar pasa de 300 metros cuadrados?.
SELECT COUNT(*) AS [NUM PISOS]
FROM VIVIENDA
WHERE TIPOVIVIENDA = 'Bloque' AND NOMBREZONA IN ('Centro', 'Cuatrovientos') AND METROSSOLAR > 300

--51. Haz una consulta que devuelva el n�mero de personas distintas que poseen una vivienda unifamiliar.
SELECT COUNT(DISTINCT DNIPROPIETARIO) AS [PERSONAS DISTINTAS]
FROM CASAPARTICULAR

--52. Haz una consulta que devuelva el n�mero de hombres que poseen un trastero en las zonas Palomar y Centro.
SELECT COUNT(DISTINCT DNIPROPIETARIO) AS [NUM HOMBRES]
FROM HUECO H INNER JOIN PROPIETARIO P ON H.DNIPROPIETARIO = P.DNI INNER JOIN BLOQUEPISOS B ON B.CALLE = H.CALLE INNER JOIN VIVIENDA V ON V.CALLE = B.CALLE 
WHERE TIPO = 'TRASTERO' AND SEXO = 'H' AND NOMBREZONA IN ('Palomar', 'Centro');

--CON SUBCONSULTAS
SELECT COUNT(DISTINCT DNI) FROM PROPIETARIO P
WHERE SEXO='H' AND
 DNI IN (SELECT DNIPROPIETARIO FROM HUECO
		 WHERE TIPO='Trastero'
		 AND CALLE+CAST(NUMERO AS VARCHAR(4))
		 IN	(SELECT CALLE+CAST(NUMERO AS VARCHAR(4))
			 FROM BLOQUEPISOS
			 WHERE CALLE+CAST(NUMERO AS VARCHAR(4)) IN
			   (SELECT CALLE+CAST(NUMERO AS VARCHAR(4))
			    FROM VIVIENDA
			    WHERE NOMBREZONA IN ('Palomar', 'Centro')
			    )
			)
		)
		
--53. Haz una consulta que devuelva el n�mero de viviendas (de cualquier tipo) que hay en cada zona urbana.
SELECT COUNT(*) AS [NUM VIVIENDAS]
FROM VIVIENDA
GROUP BY NOMBREZONA

--EXTRA. Haz una consulta que devuelva el n�mero de viviendas (de m�s de dos pisos) (de cualquier tipo) que hay en cada zona urbana.
SELECT COUNT(*) AS [NUM VIVIENDAS]
FROM VIVIENDA
GROUP BY NOMBREZONA
HAVING COUNT(*)>2

--54. Haz una consulta que devuelva el n�mero de bloques de pisos que hay en cada zona urbana.
SELECT NOMBREZONA, COUNT(*) AS [NUM BLOQUES]
FROM VIVIENDA V INNER JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE AND V.NUMERO = B.NUMERO
GROUP BY NOMBREZONA

--55. Indica para cada bloque de pisos (calle y n�mero) el n�mero de pisos que hay en este y cual es el piso m�s alto de cada uno de estos.
SELECT CALLE, NUMERO, NUMPISOS, MAX(NUMPISOS) AS [PISO M�S ALTO]
FROM BLOQUEPISOS
GROUP BY CALLE, NUMERO, NUMPISOS

--56. Muestra los bloques de pisos (calle y n�mero) que tienen m�s de 4 pisos.
SELECT CALLE, NUMERO, NUMPISOS
FROM BLOQUEPISOS
WHERE NUMPISOS > 4

--------------- CON HAVING
SELECT CALLE, NUMERO, COUNT(*) AS [NUMERO PISOS]
FROM PISO P
GROUP BY CALLE, NUMERO
HAVING COUNT(*) > 4

--57. Indica cual es el tama�o m�nimo y m�ximo (de metros �tiles) de los pisos de la zona Centro.
SELECT MIN(METROSUTILES) AS [MINIMO METROS UTILES], MAX(METROSUTILES) [MAX METROS UTILES]
FROM PISO P INNER JOIN BLOQUEPISOS B ON P.CALLE = B.CALLE INNER JOIN VIVIENDA V ON V.CALLE = B.CALLE
WHERE NOMBREZONA = 'Centro'

--58. Haz una consulta que muestre cuantos huecos hay de cada tipo en cada calle, teniendo en cuenta unicamente los huecos que est�n asociados a alg�n piso.
SELECT P.CALLE, H.TIPO, COUNT(*) AS [NUM HUECOS]
FROM HUECO H INNER JOIN PISO P ON H.CALLE = P.CALLE AND H.NUMERO = P.NUMERO AND H.PLANTA = P.PLANTA AND H.PUERTA = P.PUERTA
GROUP BY P.CALLE, H.TIPO
ORDER BY P.CALLE

--59. �Cu�ntos bloques de pisos hay en la zona Centro o Palomar que poseen pisos de m�s de 3 habitaciones y que est�n entre 100 y 180 metros cuadrados(�tiles)?
SELECT COUNT(*) AS [BLOQUES DE PISOS] 
FROM BLOQUEPISOS B INNER JOIN PISO P ON B.CALLE = P.CALLE INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE
WHERE NOMBREZONA IN ('Centro', 'Palomar') AND (METROSUTILES > 100 AND METROSUTILES < 180) AND NUMHABITACIONES > 3

--60. Indica cuantas viviendas unifamiliares de una o dos plantas hay en cada calle teniendo en cuenta unicamente aquellas calles en las que el total de metros construidos es mayor de 250.
SELECT COUNT(*) AS [VIVIENDAS UNIFAMILIARES]
FROM CASAPARTICULAR C
WHERE NUMPLANTAS > 1 AND NUMPLANTAS < 3 AND METROSCONSTRUIDOS > 250

--61. Haz una consulta que devuelva el n�mero de pisos de 3 o 4 habitaciones que hay en cada zona urbana, mostrando para cada zona su nombre, descripci�n y n�mero de parques, ordenado por n�mero de parques descendentemente.
SELECT COUNT(*) AS [NUM PISOS], Z.NOMBREZONA, Z.DESCRIPCI�N, Z.NUMPARQUES
FROM PISO P INNER JOIN BLOQUEPISOS B ON P.CALLE = B.CALLE INNER JOIN VIVIENDA V ON V.CALLE = B.CALLE INNER JOIN ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA
WHERE NUMHABITACIONES > 3 AND NUMHABITACIONES< 5
GROUP BY Z.NOMBREZONA, Z.DESCRIPCI�N, Z.NUMPARQUES
ORDER BY NUMPARQUES DESC

--62. Haz una consulta que nos diga cuantos propietarios de pisos hay de cada sexo, indicando los valores Hombres o Mujeres en funci�n del valor del campo sexo.
SELECT COUNT(*) AS [NUM PROPIETARIOS],
	CASE SEXO
	WHEN 'H' THEN 'Hombre'
	WHEN 'M' THEN 'Mujer'
	END AS SEXO
FROM PROPIETARIO
GROUP BY SEXO