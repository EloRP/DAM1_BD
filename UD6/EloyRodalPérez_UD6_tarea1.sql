--ELOY RODAL PÉREZ
USE CATASTRO
GO


--Crea una tabla con información de los pisos que poseen las mujeres que tienen un nombre que empieza por M. La tabla debe llamarse PISOS_M y la información que debe contener es la calle, número, planta, puerta, numhabitaciones, DNIPropietario, nombrezona.

SELECT PISO.CALLE, PISO.NUMERO, PISO.PLANTA, PISO.PUERTA, PISO.NUMHABITACIONES, PISO.DNIPROPIETARIO, VIVIENDA.NOMBREZONA
INTO PISOS_M
FROM PISO INNER JOIN PROPIETARIO ON PISO.DNIPROPIETARIO = PROPIETARIO.DNI INNER JOIN VIVIENDA ON PISO.CALLE = VIVIENDA.CALLE AND PISO.NUMERO = VIVIENDA.NUMERO
WHERE PROPIETARIO.SEXO = 'M' AND PROPIETARIO.NOMBRE LIKE 'M%'

SELECT *
FROM PISOS_M PM INNER JOIN PROPIETARIO P ON PM.DNIPROPIETARIO = P.DNI

DROP TABLE PISOS_M

--Queremos añadir los datos de una nueva vivienda unifamiliar situada en la calle Ponzano 44 que se encuentra en la zona Centro. El código postal es 23701, tiene 2 plantas y el propietario es Malena Franco Valiño.

INSERT INTO VIVIENDA (CALLE, NUMERO, TIPOVIVIENDA, CODIGOPOSTAL, METROSSOLAR, NOMBREZONA)
VALUES ('Ponzano', 44, 'Casa', 23701, NULL, 'Centro');

DELETE FROM VIVIENDA
WHERE CALLE = 'Ponzano' AND NUMERO = 44 AND CODIGOPOSTAL = 23701;

INSERT INTO CASAPARTICULAR (CALLE, NUMERO, NUMPLANTAS, DNIPROPIETARIO)
VALUES ('Ponzano', 44, 2, '55999911R');

DELETE FROM CASAPARTICULAR
WHERE CALLE = 'Ponzano' AND NUMERO = 44;

INSERT INTO PROPIETARIO (DNI, NOMBRE, APELLIDO1, APELLIDO2, SEXO)
VALUES ('55999911R', 'Malena', 'Franco', 'Valiño', 'M');

DELETE FROM PROPIETARIO
WHERE DNI = '55999911R';

--El propietario de la vivienda situada en la calle Damasco, número 6 amplió su vivienda en 20 metros y constuyó una piscina. Actualiza la base de datos para que refleje estos cambio.

UPDATE CASAPARTICULAR
SET METROSCONSTRUIDOS = METROSCONSTRUIDOS + 20, PISCINA = 'S'
WHERE CALLE = 'Damasco' AND NUMERO = 6;

--Se instaló un enchufe en todas las bodegas de la calle Zurbarán 101. Refleja esta información en la base de datos. (en el campo observaciones.)

UPDATE HUECO SET OBSERVACIONES = 'Se ha instalado un enchufe'
WHERE CALLE = 'Zurbarán' AND NUMERO='101' AND TIPO='BODEGA';

SELECT *
FROM HUECO
WHERE CALLE = 'Zurbarán' AND NUMERO='101'

--Haz una consulta que devuelva el número de hombres y de mujeres que tienen un piso pero no tienen una vivienda unifamiliar.

SELECT SEXO, COUNT(*) AS [NUM PERSONAS]
FROM PROPIETARIO PR INNER JOIN PISO P ON PR.DNI = P.DNIPROPIETARIO LEFT JOIN CASAPARTICULAR C ON PR.DNI = C.DNIPROPIETARIO
WHERE C.DNIPROPIETARIO IS NULL
GROUP BY PR.SEXO

--Haz una consulta que devuelva el nombre completo de los propietarios que tienen un garaje o un trastero en las zonas Palomar o Centro y que no tienen ni pisos ni viviendas unifamiliares.
SELECT DISTINCT PR.NOMBRE + ' ' + PR.APELLIDO1 + ' ' + ISNULL(PR.APELLIDO2, '') AS [NOME COMPLETO]
FROM PROPIETARIO PR
INNER JOIN HUECO H ON PR.DNI = H.DNIPROPIETARIO
INNER JOIN VIVIENDA V ON H.CALLE = V.CALLE AND H.NUMERO = V.NUMERO
WHERE H.TIPO IN ('GARAJE', 'TRASTERO')
AND (V.NOMBREZONA = 'Palomar' OR V.NOMBREZONA = 'Centro')
AND PR.DNI NOT IN (
    SELECT DNIPROPIETARIO FROM PISO
    UNION
    SELECT DNIPROPIETARIO FROM CASAPARTICULAR
);