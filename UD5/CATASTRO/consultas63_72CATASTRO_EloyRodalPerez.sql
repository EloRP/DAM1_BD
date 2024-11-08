--ELOY RODAL PÉREZ
USE CATASTRO
GO

--63._ Obtén una relación de pisos (calle, número, planta, puerta, número de habitaciones, metros útiles y nombre y apellidos del propietario) cuyos metros útiles superan la media de los metros construidos.

SELECT CALLE, NUMERO, PLANTA, PUERTA, NUMHABITACIONES, METROSUTILES, NOMBRE, APELLIDO1, APELLIDO2
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE METROSUTILES > (SELECT AVG(METROSCONSTRUIDOS) FROM PISO P)

--64._Haz una consulta que nos indique cual el tamaño medio de los solares en los que hay edificados bloques de pisos con más de 15 viviendas (pisos).

SELECT AVG(METROSSOLAR) AS [TAMAÑO MEDIO SOLARES]
FROM VIVIENDA V INNER JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE AND V.NUMERO = B.NUMERO
WHERE NUMPISOS > 15

--65._ Haz una consulta que devuelva el número de parques que hay en las zonas urbanas donde hay edificada alguna vivienda.

SELECT Z.NOMBREZONA, NUMPARQUES
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA
WHERE NUMERO IS NOT NULL

--66._ Haz una consulta que muestre todas las zonas (nombre y descripción) y las viviendas unifamiliares  (calle, número y metros solar) que hay construidas en éstas.

SELECT Z.NOMBREZONA, DESCRIPCIÓN, CALLE, NUMERO, METROSSOLAR
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA

--67._ Haz una consulta que muestre DNI, nombre y apellidos de los propietarios de algún piso y/o vivienda, indicando cuántos pisos poseen y cuantas viviendas unifamiliares poseen.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO

--68._ Lista los pisos (calle, numero, planta y puerta) cuyo propietario es una mujer, que tienen el máximo número de habitaciones.

SELECT CALLE, NUMERO, PLANTA, PUERTA
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE SEXO = 'M'

--69._ Lista las viviendas unifamiliares que no tienen piscina y en las que los metros construidos son menores que la media de los de todas las viviendas unifamiliares)

SELECT *
FROM CASAPARTICULAR
WHERE PISCINA='N' AND METROSCONSTRUIDOS < (SELECT AVG(METROSCONSTRUIDOS) FROM CASAPARTICULAR)

--70._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso que tenga como mínimo dos habitaciones.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO], COUNT(NUMERO) AS [NUM PISOS]
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE NUMHABITACIONES > 2
GROUP BY DNI, NOMBRE, APELLIDO1, APELLIDO2

--71._ Muestra DNI, nombre y apellidos de las personas que no poseen ningún piso.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO PR INNER JOIN PISO P 
ON PR.DNI = P.DNIPROPIETARIO INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE and P.NUMERO = V.NUMERO
WHERE DNI NOT IN (SELECT DISTINCT DNIPROPIETARIO FROM PROPIETARIO PR INNER JOIN PISO P
ON PR.DNI = P.DNIPROPIETARIO
) 

--72._ Muestra DNI, nombre, apellidos y número de pisos de las personas que poseen más de un piso y que no poseen ninguna vivienda unifamiliar.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO PR