  --ELOY RODAL PÉREZ
USE CATASTRO
GO

--1._ Haz una consulta que muestre las zonas urbanas (nombre y descripción) donde hay algún bloque de pisos sin ascensor.

SELECT Z.NOMBREZONA, DESCRIPCIÓN
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA INNER JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE
WHERE ASCENSOR = 'N';

--2._ Lo mismo que la anterior pero indicando cuantos bloques hay en cada zona, poniendo 0 en el caso de que no haya ningún bloque sin ascensor en esa zona.

SELECT Z.NOMBREZONA, DESCRIPCIÓN, COUNT(B.NUMERO) AS [NUMBLOQUESPISOS], CASE ASCENSOR 
													WHEN 'N' THEN '0'
													ELSE 'S'
													END AS ASCENSOR
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA INNER JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE
GROUP BY Z.NOMBREZONA, DESCRIPCIÓN, ASCENSOR
 
--3._ Haz una consulta que muestre las zonas urbanas en las que hay más de 2 piscinas.
SELECT NOMBREZONA
FROM ZONAURBANA
WHERE (
	SELECT COUNT(PISCINA)
    FROM CASAPARTICULAR) > 2;
    
--4._Haz una consulta que devuelva DNI, y nombre completo de las hombres que no poseen ningún piso y tienen algún garaje en la zona Centro o algún trastero en la zona Palomar.
SELECT DNI,NOMBRE+' '+APELLIDO1+' '+ isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO PR INNER JOIN PISO P 
ON PR.DNI = P.DNIPROPIETARIO INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE and P.NUMERO = V.NUMERO
WHERE SEXO='H' AND DNI NOT IN (SELECT DISTINCT DNIPROPIETARIO FROM PROPIETARIO PR INNER JOIN PISO P
ON PR.DNI = P.DNIPROPIETARIO
)
AND ((TIPOVIVIENDA='Garaje' AND NOMBREZONA='Centro')
OR (TIPOVIVIENDA='Trastero' AND NOMBREZONA='Palomar'))
--5._ ¿Cuántas mujeres tienen una casa con piscina y un piso con ascensor?.

SELECT NOMBRE+' '+APELLIDO1+' '+ isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO P INNER JOIN CASAPARTICULAR C ON P.DNI = C.DNIPROPIETARIO
WHERE SEXO='M' AND PISCINA='S'


--6._ Para los diferentes propietarios varones, visualiza el DNI, nombre completo y un mensaje que indique si posee alguna vivienda particular o en caso contrario indicando que no posee ninguna. Un ejemplo de salida sería:

SELECT DISTINCT DNI, NOMBRE + ' ' + APELLIDO1 + ' ' + ISNULL(APELLIDO2, ' ') AS [NOME COMPLETO],
CASE WHEN DNIPROPIETARIO IS NOT NULL THEN 'POSEE AL MENOS UNA CASA PARTICULAR'
	 WHEN DNIPROPIETARIO IS NULL THEN 'NO POSEE NINGUNA CASA PARTICULAR'
	 ELSE ''
	 END AS CASA
FROM PROPIETARIO P LEFT JOIN CASAPARTICULAR C ON P.DNI = C.DNIPROPIETARIO
WHERE SEXO='H'

--7._ Para los diferentes propietarios varones, visualiza el DNI, nombre completo, un mensaje que indique si posee alguna vivienda particular o en caso contrario indicando que no posee ninguna y un mensaje que indique si posee algún piso o en caso contrario indicando que no posee ninguno. Un ejemplo de salida sería:

SELECT DISTINCT DNI, NOMBRE + ' ' + APELLIDO1 + ' ' + ISNULL(APELLIDO2, ' ') AS [NOME COMPLETO],
CASE WHEN C.DNIPROPIETARIO IS NOT NULL THEN 'POSEE AL MENOS UNA CASA PARTICULAR'
	 WHEN C.DNIPROPIETARIO IS NULL THEN 'NO POSEE NINGUNA CASA PARTICULAR'
	 ELSE ''
	 END AS CASAS,
CASE WHEN P.DNIPROPIETARIO IS NOT NULL THEN 'POSEE AL MENOS UN PISO'
	 WHEN P.DNIPROPIETARIO IS NULL THEN 'NO POSEE NINGÚN PISO'
	 ELSE ''
	 END AS PISOS
FROM PROPIETARIO PR LEFT JOIN CASAPARTICULAR C ON PR.DNI = C.DNIPROPIETARIO LEFT JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE SEXO='H'


--8._ Haz una consulta que muestre cuantos propietarios varones hay en cada zona urbana. En el caso de que no haya ninguno debe visualizarse el nombre de la zona y 0 en la columna correspondiente al número de propietarios.

SELECT COALESCE (V.NOMBREZONA,'Cantarranas') AS NOMBREZONA, COUNT(*) as [CANTIDAD PROPIETARIOS]
FROM PROPIETARIO PR 
LEFT JOIN CASAPARTICULAR CP ON PR.DNI = CP.DNIPROPIETARIO
LEFT JOIN HUECO H ON PR.DNI = H.DNIPROPIETARIO
LEFT JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
INNER JOIN VIVIENDA V ON (CP.CALLE = V.CALLE AND CP.NUMERO = V.NUMERO)
					  OR (H.CALLE = V.CALLE AND H.NUMERO = V.NUMERO)
					  OR (P.CALLE = V.CALLE AND P.NUMERO = V.NUMERO)
WHERE PR.SEXO = 'H'
GROUP BY V.NOMBREZONA

--9._ Haz una consulta que devuelva los metros del solar, el total de metros útiles y metros construídos en cada bloque ordenados por metros construídos de mayor a menor y dentro de este por metros útiles de mayor a menor.

SELECT BP.CALLE,BP.NUMERO, V.METROSSOLAR, SUM(P.METROSUTILES) AS [TOTAL METROS UTILES],
		SUM(P.METROSCONSTRUIDOS) AS [TOTAL METROS CONSTRUIDOS],
		COUNT(DISTINCT DNIPROPIETARIO) AS [NUM PROPIETARIOS]
		FROM BLOQUEPISOS BP
		INNER JOIN VIVIENDA V ON V.CALLE = BP.CALLE AND V.NUMERO = BP.NUMERO
		INNER JOIN PISO P ON P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO
		GROUP BY BP.CALLE, BP.NUMERO, V.METROSSOLAR
		ORDER BY SUM(P.METROSCONSTRUIDOS) DESC, SUM(P.METROSUTILES) DESC;
		
--10._ Modifica la consulta anterior para que además de esa información indique cuantas viviendas (pisos) hay en cada bloque (usando la tabla piso) y cuantos propietarios distintos hay en cada bloque. En este caso ordénalos de menor a mayor por el número de viviendas y dentro de este por el número de propietarios distintos.
		
SELECT BP.CALLE,BP.NUMERO, V.METROSSOLAR, SUM(P.METROSUTILES) AS [TOTAL METROS UTILES],
		SUM(P.METROSCONSTRUIDOS) AS [TOTAL METROS CONSTRUIDOS], COUNT(P.PUERTA) AS [NUM PISOS],
		COUNT(DISTINCT DNIPROPIETARIO) AS [NUM PROPIETARIOS]
		FROM BLOQUEPISOS BP
		INNER JOIN VIVIENDA V ON V.CALLE = BP.CALLE AND V.NUMERO = BP.NUMERO
		INNER JOIN PISO P ON P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO
		GROUP BY BP.CALLE, BP.NUMERO, V.METROSSOLAR
		ORDER BY SUM(P.METROSCONSTRUIDOS) DESC, SUM(P.METROSUTILES) DESC;
		
--11._ Haz una consulta que devuelva el/los propietarios (nombre completo) que más metros cuadrados poseen en Trasteros y Bodegas.
SELECT TOP 1 WITH TIES NOMBRE+' '+APELLIDO1+' '+ ISNULL (APELLIDO2,' ' ) as [NOMBRE COMPLETO],
SUM(METROS) as TOTAL
FROM PROPIETARIO P INNER JOIN HUECO H
	ON P.DNI=H.DNIPROPIETARIO
WHERE TIPO IN ('Trastero','Bodega')
GROUP BY DNI,NOMBRE,APELLIDO1,APELLIDO2
ORDER BY TOTAL DESC

--12._ ¿Cuántos metros construídos posee cada propietario? Haz una consulta que muestre el total de metros construídos que posee cada uno. En el caso de no tener ningún piso o vivienda unifamiliar debes poner 0 en la columna correspondiente.
SELECT PR.DNI, (COALESCE(SUM(CP.METROSCONSTRUIDOS),0) + COALESCE(SUM(P.METROSCONSTRUIDOS),0)) AS [TOTAL METROS CONSTRUIDOS]
	FROM PROPIETARIO PR
	LEFT JOIN PISO P ON P.DNIPROPIETARIO = PR.DNI
	LEFT JOIN CASAPARTICULAR CP ON CP.DNIPROPIETARIO = PR.DNI
	GROUP BY PR.DNI
--13._ Haz un listado de las propietarias (DNI, nombre completo y teléfono) que tienen un garaje pero no tienen ningún piso con ascensor.
SELECT PR.DNI, PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + ISNULL(PR.APELLIDO2, '') AS [NOMBRE COMPLETO], PR.TELEFONO
FROM PROPIETARIO PR
WHERE PR.SEXO = 'M'
AND PR.DNI IN (
SELECT H.DNIPROPIETARIO FROM HUECO H WHERE H.TIPO = 'Garaje'
) AND PR.DNI NOT IN (
SELECT P.DNIPROPIETARIO FROM PISO P
INNER JOIN BLOQUEPISOS BP ON P.CALLE = BP.CALLE AND P.NUMERO = BP.NUMERO
WHERE BP.ASCENSOR = 'S'
);