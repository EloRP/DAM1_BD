--ELOY RODAL PÉREZ
USE CATASTRO
GO


--1.-   Haz una consulta que muestre la calle, número, planta, puerta, número de habitaciones de los pisos de los propietarios que su letra del DNI sea A, B o H. Además también se visualizará junto a la anterior información, un comentario que dependerá del número de habitaciones. Si el número de habitaciones es 1 0 2 se visualizará 'Ideal Parejas sin o con 1 hijo', si tiene 3: 'Ideal Parejas con dos hijos' y si tiene más de tres: 'Ideal Parejas con más de dos hijos'
SELECT CALLE, NUMERO, PLANTA, PUERTA, NUMHABITACIONES, 
CASE
	WHEN P.NUMHABITACIONES <= 2 THEN 'Ideal parejas sin o con 1 hijo'
	WHEN P.NUMHABITACIONES = 3 THEN 'Ideal parejas con dos hijos'
	ELSE 'Ideal parejas con más de dos hijos'
	END AS COMENTARIO
FROM PISO P INNER JOIN PROPIETARIO PR ON P.DNIPROPIETARIO = PR.DNI
WHERE DNI LIKE '%A' OR DNI LIKE '%B' OR DNI LIKE '%H';
--2.-  Muestra información de los propietarios que tienen un teléfono que empiezan por los números 610 o 565, clasificados de manera que aparezcan primero aquellos cuyos nombres son más cortos y para los que coincidan por el nombre de forma descendente.    Pista( puedes poner en el order by una función)
SELECT *
FROM PROPIETARIO
WHERE TELEFONO LIKE '610%' OR TELEFONO LIKE '565%'
ORDER BY LEN(NOMBRE) ASC, NOMBRE DESC;
--3.-.  Idem del anterior pero ahora se debe crear una tabla llamada PropietariosClasif con la información de los propietarios que tienen un teléfono que empiezan por los números 610 o 565, clasificados de manera que aparezcan primero aquellos cuyos nombres son más cortos y para los que coincidan por el nombre de forma descendente.
SELECT * 
INTO PropietariosClasif
FROM PROPIETARIO
WHERE TELEFONO LIKE '610%' OR TELEFONO LIKE '565%'
ORDER BY LEN(NOMBRE) ASC, NOMBRE DESC;

SELECT *
FROM PropietariosClasif
--4.-.  Muestra información de las viviendas cuya calle no es compuesta, es decir, formada por una sola palabra. La información se mostrará ordenada por metrossolar de mayor a menor  en el caso de los bloques y para las casas. por los nombres de zonas de más cortos a más. Pista : mira la función  charindex.  En order by también puedes poner un case. 
SELECT V.*, Z.NOMBREZONA
FROM VIVIENDA V INNER JOIN ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA
WHERE CHARINDEX(' ', V.CALLE) = 0
ORDER BY 
    CASE 
        WHEN V.TIPOVIVIENDA = 'BLOQUE' THEN V.METROSSOLAR
        ELSE NULL
    END DESC,
    CASE 
        WHEN V.TIPOVIVIENDA = 'CASA' THEN V.METROSSOLAR
        ELSE NULL
    END DESC,
    CASE 
        WHEN V.TIPOVIVIENDA NOT IN ('BLOQUE', 'CASA') THEN Z.NOMBREZONA
        ELSE NULL
    END ASC;
    
--5.-.  Visualiza las zonas urbanas con más parques.
SELECT TOP 1 NOMBREZONA, NUMPARQUES
FROM ZONAURBANA
GROUP BY NOMBREZONA
ORDER BY MAX(NUMPARQUES) DESC;

--6.-.  De los pisos cuyos metros construídos están comprendidos entre 100 y 200, visualiza los que tienen más habitaciones. El formato de salida será una sola columna que contendrá:  calle, piso plantaº puerta.
SELECT CALLE + ',' + CAST(NUMERO AS VARCHAR) + ' ' + CAST(PLANTA AS VARCHAR) + 'º ' + PUERTA AS DIRECCION
FROM PISO
WHERE METROSCONSTRUIDOS > 100 AND METROSCONSTRUIDOS <= 200
ORDER BY NUMHABITACIONES DESC;

--7.-.  Visualiza la direccion del piso (compuesta por calle, piso plantaº puerta), metrosconstruidos, metrosutiles  y la diferencia entre metros construidos y metros útilies para los pisos que esta diferencia no supera los 8 metros. Se visualizará ordenado por esta diferencia de metros de
SELECT CALLE + ', piso ' + CAST(PLANTA AS VARCHAR) + 'º puerta ' + PUERTA AS DIRECCION,METROSCONSTRUIDOS,METROSUTILES, METROSCONSTRUIDOS - METROSUTILES AS DIFERENCIA
FROM PISO
WHERE METROSCONSTRUIDOS - METROSUTILES <= 8
ORDER BY DIFERENCIA;

--8-.  Para los pisos cuya diferencia entre metros construídos y metros útiles no supera los 8 metros, visualiza los pisos con menor diferencia. La información que se visualizará será la dirección del piso (compuesta por  calle, piso plantaº puerta), metrosconstruidos, metrosutiles y la diferencia entre metros construídos y metros útiles.
SELECT CALLE + ', piso ' + CAST(PLANTA AS VARCHAR) + 'º puerta ' + PUERTA AS DIRECCION, METROSCONSTRUIDOS, METROSUTILES, METROSCONSTRUIDOS - METROSUTILES AS DIFERENCIA
FROM PISO
WHERE METROSCONSTRUIDOS - METROSUTILES <= 8
ORDER BY DIFERENCIA
--9.-.  Para las propietarias, visualizar su nombre completo, dni y télefono de la siguiente manera:
SELECT 
    CASE
        WHEN TELEFONO IS NULL THEN ''
        ELSE APELLIDO1 + ' ' + APELLIDO2 + ', ' + NOMBRE + ' (' + DNI + ')'
    END AS "NOMBRE COMPLETO CON DNI",
    CASE 
        WHEN TELEFONO IS NULL THEN 'SIN TELEFONO'
        ELSE LEFT(TELEFONO, 3) + ' - ' + SUBSTRING(TELEFONO, 4, 2) + ' - ' + SUBSTRING(TELEFONO, 6, 2) + ' - ' + RIGHT(TELEFONO, 2)
    END AS "TELEFONO"
FROM PROPIETARIO
WHERE SEXO = 'M';