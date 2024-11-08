--ELOY RODAL PÉREZ
USE CATASTRO

--32. Obtén el nombre y apellidos de las personas que poseen una vivienda unifamiliar.

SELECT P.NOMBRE, P.APELLIDO1, P.APELLIDO2
FROM PROPIETARIO P JOIN CASAPARTICULAR C ON P.DNI = C.DNIPROPIETARIO;

--33. Haz una consulta que muestre la zona, número de parques, calle, número y metros de solar de las viviendas que se encuentran en una zona que posea más de un parque.

SELECT Z.NOMBREZONA, Z.NUMPARQUES, V.CALLE, V.NUMERO, V.METROSSOLAR
FROM ZONAURBANA Z JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA
WHERE NUMPARQUES > 1;

--34. Haz una consulta que muestre para cada vivienda unifamiliar la calle, número, plantas, metros del solar y metros construidos.

SELECT V.CALLE, V.NUMERO, C.NUMPLANTAS, V.METROSSOLAR, C.METROSCONSTRUIDOS
FROM CASAPARTICULAR C JOIN VIVIENDA V ON C.CALLE = V.CALLE

--35. Obtén el nombre y descripción de las zonas urbanas que tienen más de 2 parques donde se hayan construido bloques de pisos.

SELECT Z.NOMBREZONA, Z.DESCRIPCIÓN, Z.NUMPARQUES
FROM ZONAURBANA Z JOIN VIVIENDA V ON Z.NOMBREZONA = V.NOMBREZONA 
JOIN BLOQUEPISOS B ON V.CALLE = B.CALLE
WHERE NUMPARQUES > 2

--36. Haz una consulta que muestre para cada piso la calle, número, planta, puerta, número de habitaciones, metros útiles, nombre de zona, número de parques existentes en la zona y nombre y apellidos del propietario.

SELECT PISO.CALLE, PISO.NUMERO, PISO.PLANTA, PISO.PUERTA, PISO.NUMHABITACIONES, PISO.METROSUTILES, Z.NOMBREZONA, Z.NUMPARQUES, P.NOMBRE, P.APELLIDO1, P.APELLIDO2
FROM PISO PISO JOIN PROPIETARIO P ON PISO.DNIPROPIETARIO = P.DNI JOIN CASAPARTICULAR C ON C.DNIPROPIETARIO = P.DNI JOIN VIVIENDA V ON V.CALLE = C.CALLE JOIN ZONAURBANA Z ON Z.NOMBREZONA = V.NOMBREZONA

--37. Haz una consulta que muestre el nombre y apellidos de las mujeres que tienen bodegas de más de 9 metros cuadrados.

SELECT P.NOMBRE, P.APELLIDO1, P.APELLIDO2, H.TIPO, H.METROS
FROM PROPIETARIO P JOIN HUECO H ON P.DNI = H.DNIPROPIETARIO
WHERE SEXO = 'M' AND TIPO = 'BODEGA'

--38. Haz una consulta que devuelva DNI, nombre y apellidos de las mujeres que poseen una vivienda unifamiliar.

SELECT P.DNI, P.NOMBRE, P.APELLIDO1, P.APELLIDO2
FROM PROPIETARIO P JOIN CASAPARTICULAR C ON P.DNI = C.DNIPROPIETARIO JOIN VIVIENDA V ON V.CALLE = C.CALLE
WHERE SEXO = 'M';

--39. Haz una consulta que muestre los pisos (toda la información de la tabla piso) y el nombre completo de los propietarios que se encuentran en una zona con dos parques que tienen entre 2 y 4 habitaciones o que se encuentran en la zona Centro, con ascensor y que tienen más de 70 y menos de 110 metros cuadrados útiles.

SELECT PISO.*, P.NOMBRE, P.APELLIDO1, P.APELLIDO2
FROM PISO PISO JOIN PROPIETARIO P ON PISO.DNIPROPIETARIO = P.DNI JOIN CASAPARTICULAR C ON C.DNIPROPIETARIO = P.DNI JOIN VIVIENDA V ON V.CALLE = C.CALLE JOIN ZONAURBANA Z ON Z.NOMBREZONA = V.NOMBREZONA
WHERE NUMPARQUES > 2

--40. Haz una consulta que muestre el nombre en minúsculas y las viviendas unifamiliares de una planta, que poseen los hombres de los cuales tenemos teléfono.

SELECT LOWER(P.NOMBRE) AS NOMBRE_MINUSC, CP.* 
FROM PROPIETARIO P JOIN CASAPARTICULAR CP ON P.DNI = CP.DNIPROPIETARIO 
WHERE P.SEXO = 'H' AND P.TELEFONO IS NOT NULL

--41. Haz una consulta que muestre las viviendas (calle, numero y tipovivienda) y la zona urbana en la que se encuentran (nombrezona y descripción).

SELECT V.CALLE, V.NUMERO, V.TIPOVIVIENDA, Z.NOMBREZONA, Z.DESCRIPCIÓN
FROM VIVIENDA V JOIN ZONAURBANA Z ON V.NOMBREZONA = Z.NOMBREZONA