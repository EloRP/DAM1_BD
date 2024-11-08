--ELOY RODAL PÉREZ
USE CATASTRO
GO

--73._ ¿Quién es el propietario que posee más pisos de más de 2 habitaciones que no están situados en la zona centro?

SELECT TOP 1 P.DNIPropietario, PR.Nombre, PR.Apellido1, PR.Apellido2, COUNT(*) AS NumPisos
FROM PISO P
JOIN VIVIENDA V ON P.Calle = V.Calle AND P.Numero = V.Numero
JOIN PROPIETARIO PR ON P.DNIPropietario = PR.DNI
WHERE P.NumHabitaciones > 2 AND V.NombreZona = 'Centro'
GROUP BY P.DNIPropietario, PR.Nombre, PR.Apellido1, PR.Apellido2
ORDER BY COUNT(*) DESC;

--74._ Indica para cada bloque de pisos (calle y número) el máximo de metros útiles y máximo de número de habitaciones, pero sólo para aquellos bloques en los que tenemos almacenados más de 3 pisos.

SELECT Calle, Numero, MAX(MetrosUtiles) AS MaxMetrosUtiles, MAX(NumHabitaciones) AS MaxNumHabitaciones
FROM PISO
GROUP BY Calle, Numero
HAVING COUNT(*) > 3;

--75._ Obtén el DNI, nombre y apellidos de las personas que tenemos en nuestra base de datos. En el caso de que posean una vivienda de cualquier tipo deberá visualizarse la calle y número de la vivienda de la que son propietarios. Deberá ir ordenado por apellidos y nombre ascendentemente
SELECT DISTINCT PR.DNI, PR.Nombre, PR.Apellido1, PR.Apellido2, V.Calle, V.Numero
FROM PROPIETARIO PR LEFT JOIN VIVIENDA V ON PR.DNI = V.DNIPropietario
ORDER BY PR.Apellido1 ASC, PR.Apellido2 ASC, PR.Nombre ASC;


--76._ ¿Quién es el propietario de la bodega más pequeña? Debe visualizarse nombre y apellidos.

SELECT TOP 1 PR.Nombre, PR.Apellido1, PR.Apellido2
FROM HUECO H INNER JOIN PROPIETARIO PR ON H.DNIPropietario = PR.DNI
WHERE H.Tipo = 'BODEGA'
ORDER BY H.Metros ASC;

--77._ Obtén el nombre completo y DNI de las mujeres que tenemos en nuestra base de datos. En el caso de que posean un trastero de más de 10 metros o un garaje de menos de 13 metros deberá visualizarse la calle , número, tipo y metros de la propiedad que poseen.

--78._ Muestra el nombre de la zona urbana que más “propiedades” posee. Entendiendo como propiedades tanto los pisos, como las viviendas unifamiliares como huecos.