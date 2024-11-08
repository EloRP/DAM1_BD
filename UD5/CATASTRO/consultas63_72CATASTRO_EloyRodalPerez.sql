--ELOY RODAL P�REZ
USE CATASTRO
GO

--63._ Obt�n una relaci�n de pisos (calle, n�mero, planta, puerta, n�mero de habitaciones, metros �tiles y nombre y apellidos del propietario) cuyos metros �tiles superan la media de los metros construidos.

SELECT CALLE, NUMERO, PLANTA, PUERTA, NUMHABITACIONES, METROSUTILES, NOMBRE, APELLIDO1, APELLIDO2
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE METROSUTILES > (SELECT AVG(METROSCONSTRUIDOS) FROM PISO P)

--64._Haz una consulta que nos indique cual el tama�o medio de los solares en los que hay edificados bloques de pisos con m�s de 15 viviendas (pisos).

SELECT AVG(METROSSOLAR) AS [TAMA�O MEDIO SOLARES]
FROM VIVIENDA V INNER JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE AND V.NUMERO = B.NUMERO
WHERE NUMPISOS > 15

--65._ Haz una consulta que devuelva el n�mero de parques que hay en las zonas urbanas donde hay edificada alguna vivienda.

SELECT Z.NOMBREZONA, NUMPARQUES
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA
WHERE NUMERO IS NOT NULL

--66._ Haz una consulta que muestre todas las zonas (nombre y descripci�n) y las viviendas unifamiliares  (calle, n�mero y metros solar) que hay construidas en �stas.

SELECT Z.NOMBREZONA, DESCRIPCI�N, CALLE, NUMERO, METROSSOLAR
FROM ZONAURBANA Z INNER JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA

--67._ Haz una consulta que muestre DNI, nombre y apellidos de los propietarios de alg�n piso y/o vivienda, indicando cu�ntos pisos poseen y cuantas viviendas unifamiliares poseen.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO

--68._ Lista los pisos (calle, numero, planta y puerta) cuyo propietario es una mujer, que tienen el m�ximo n�mero de habitaciones.

SELECT CALLE, NUMERO, PLANTA, PUERTA
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE SEXO = 'M'

--69._ Lista las viviendas unifamiliares que no tienen piscina y en las que los metros construidos son menores que la media de los de todas las viviendas unifamiliares)

SELECT *
FROM CASAPARTICULAR
WHERE PISCINA='N' AND METROSCONSTRUIDOS < (SELECT AVG(METROSCONSTRUIDOS) FROM CASAPARTICULAR)

--70._ Muestra DNI, nombre, apellidos y n�mero de pisos de las personas que poseen m�s de un piso que tenga como m�nimo dos habitaciones.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO], COUNT(NUMERO) AS [NUM PISOS]
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO
WHERE NUMHABITACIONES > 2
GROUP BY DNI, NOMBRE, APELLIDO1, APELLIDO2

--71._ Muestra DNI, nombre y apellidos de las personas que no poseen ning�n piso.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO PR INNER JOIN PISO P 
ON PR.DNI = P.DNIPROPIETARIO INNER JOIN VIVIENDA V ON P.CALLE = V.CALLE and P.NUMERO = V.NUMERO
WHERE DNI NOT IN (SELECT DISTINCT DNIPROPIETARIO FROM PROPIETARIO PR INNER JOIN PISO P
ON PR.DNI = P.DNIPROPIETARIO
) 

--72._ Muestra DNI, nombre, apellidos y n�mero de pisos de las personas que poseen m�s de un piso y que no poseen ninguna vivienda unifamiliar.

SELECT DNI, NOMBRE+ ' ' + APELLIDO1 + ' ' + isnull (APELLIDO2,' ' ) as [NOME COMPLETO]
FROM PROPIETARIO PR