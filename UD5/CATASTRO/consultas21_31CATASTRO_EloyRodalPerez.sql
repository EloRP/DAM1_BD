--ELOY RODAL P�REZ

--21. Haz una consulta que muestre el 25% de los pisos con m�s habitaciones. En el caso de haber m�s pisos con ese n�mero de habitaciones deber�an visualizarse tambi�n.
SELECT TOP 25 PERCENT WITH TIES *
FROM PISO
ORDER BY NUMHABITACIONES DESC;
--22. Haz una consulta que muestre toda la informaci�n de los garajes con al menos 14 metros. En caso de no tener propietario deber� mostrar desconocido.

SELECT *,
CASE WHEN DNIPROPIETARIO IS NULL THEN 'Desconocido' ELSE DNIPROPIETARIO END AS Propietario
FROM HUECO
WHERE TIPO = 'GARAJE' AND METROS >= 14;

--23. Haz una consulta que muestre el nombre completo (p.e. Javier L�pez D�az) de los propietarios cuyo nombre no empiece por a, b, c, d o e cuyo apellido1 tenga m�s de 4 letras ordenados por sexo , nombre y apellidos.

SELECT NOMBRE + ' ' + APELLIDO1 + ' ' + APELLIDO2  AS "Nombre completo"
FROM PROPIETARIO;

--24. Muestra informaci�n de las viviendas de la calle Damasco o General Mola cuyos metros solar empiecen por 2.

SELECT *
FROM VIVIENDA
WHERE (CALLE LIKE 'Damasco' OR CALLE LIKE 'General Mola') 
AND METROSSOLAR LIKE '2%';

--25. Haz una consulta que muestre para cada propietario el nombre, apellido1, sexo y un identificador que se crear� concatenando el sexo con las 3 primeras letras del nombre y las dos �ltimas del apellido1.

SELECT NOMBRE, APELLIDO1, SEXO, SEXO + LEFT(NOMBRE, 3) + RIGHT(APELLIDO1, 2) AS IDENTIFICADOR
FROM PROPIETARIO;

--26. Haz una consulta que muestre los distintos tipos de huecos que hay en la calle Sol o Luca de Tena.

SELECT CALLE, TIPO 
FROM HUECO
WHERE CALLE LIKE 'Sol' OR CALLE LIKE 'Luca de Tena';

--27. Haz una consulta que muestre informaci�n de los 5 huecos m�s peque�os. En el caso de que haya m�s cuyo tama�o sea igual deber�n visualizarse todos.

SELECT TOP 5 METROS
FROM HUECO
ORDER BY METROS ASC;

--28. Muestra los nombres de las mujeres con los caracteres invertidos.

SELECT REVERSE(NOMBRE) AS NOMBRE_INVERTIDO
FROM PROPIETARIO
WHERE SEXO LIKE 'M';

--29. Muestra los trasteros o garajes sin mostrar los decimales de los metros.

SELECT TIPO, round(METROS, 0)
FROM HUECO
WHERE TIPO LIKE 'GARAJE' OR TIPO LIKE 'TRASTERO';

--30. Muestra los distintos tipos de huecos de manera que se visualice la primera letra en may�sculas y las siguientes en min�sculas.
SELECT UPPER(LEFT(TIPO, 1)) + LOWER(SUBSTRING(TIPO, 2, LEN(TIPO))) AS Tipos
FROM HUECO
GROUP BY TIPO;

--31. Haz una consulta que muestre nombre completo de los propietarios y sexo, indicando los valores Masculino o Femenino en funci�n del valor del campo sexo.
SELECT NOMBRE + ' ' + APELLIDO1 + ' ' + APELLIDO2  AS "Nombre completo",
CASE 
	WHEN SEXO = 'H' THEN 'Masculino'
	WHEN SEXO = 'M' THEN 'Femenino'
	END AS SEXO
FROM PROPIETARIO;
