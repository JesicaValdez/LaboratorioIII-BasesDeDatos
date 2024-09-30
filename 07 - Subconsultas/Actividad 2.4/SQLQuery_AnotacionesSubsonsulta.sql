--                                                        SUBCONSULTAS Anataciones 


-- CLAUSULA "WHERE"

--ALL : Pedir una mochila donde su tamaño sea mayor o igual a TODAS/CUALQUIERA las portatiles disponibles , 
--ANY : Comprar una mochila donde su tamaño sea mayor o igual a ALGUNA/AL MENOS UNA las portatiles disponibles , 
-- Obtener aquellos alumnos que no hayan realizado ningun curso
-- = ANY -> in
-- <> ALL -> not in

-- Obtener aquellos alumnos que no hayan realizado NINGUN curso
--1.Primero obtenemos el listado completo de alumnos:
SELECT * FROM Alumnos
-- 2.Traemos los IDalumnos sin repeticiones de aquellos que realizaron algun curso
SELECT DISTINCT IDAlumnos FROM Alumnos_X_Curso
-- 3. Por ultimo filtramos por los alumnos que no realizaron algun curso, es decir, que el IDAlumno del listado principal no deberia encontrarse en el listado de alumnos que si realizaron
SELECT * FROM Alumnos
WHERE IDAlumno NOT IN (
    SELECT DISTINCT IDAlumno FROM Alumnos_X_Curso
)

-- Obtener aquellos cursos que sean mas caros que CUALQUIER curso presencial
--1.Primero obtenemos los datos de todos los cursos de la tabla
SELECT * FROM Cursos
--2.Segundo obtenemos los datos con la condicion de que los cursos sean presenciales
SELECT * FROM Cursos WHERE Presencial = 1
--3.Por ultimo, lo que tenemos que hacer dentro del listado de cursos presenciales verificar cual es el de mayor precio de cualquier curso presencial:
--Entonces la subconsulta tendra el costo de los cursos que sean presenciales y la consulta principal va tener el listado de cursos siempre y cuando la condicion se cumpla donde el costo es mayor a CUALQUIER curso obtenido de la subconsulta
SELECT * 
FROM Cursos
WHERE Costo > ANY (
    SELECT Costo FROM Cursos WHERE Presencial = 1
)

-- Obtener aquellos cursos que sean mas caros que AL MENOS un curso a distancia 
--1.Primero obtenemos los datos de todos los cursos de la tabla
SELECT * FROM Cursos
--2.Segundo obtenemos los datos con la condicion de que los cursos SE dicten a distancia
SELECT * FROM Cursos WHERE Presencial = 0
--3.Por ultimo, lo que tenemos que hacer dentro del listado de cursos a distancia verificar cual es el de menor precio de cualquier curso
--Entonces la subconsulta tendra el costo de los cursos que sean a distancia y la consulta principal va tener el listado de cursos siempre y cuando la condicion se cumpla donde el costo sea mayor  a AL MENOS UN curso obtenido de la subconsulta
--Para eso vamos a tener que ver en la tabla de cursos a distancia cual es el de menor costo, y si algun curso tiene un costo mayor a ese valor estaria cumpliendo la condicion de que sea mas caro que al menos uno
SELECT * 
FROM Cursos
WHERE Costo > ANY (
    SELECT Costo FROM Cursos WHERE Presencial = 0
) AND Presencial = 1 -- Para agregar la condicion de que se listen solo presenciales


-- Las mediciones que tengan una temperatura mayor al promedio de temperatura general
SELECT *
FROM Mediciones 
WHERE Temperatura > (SELECT AVG(Temperatura) FROM Mediciones)

-- Las ciudades que tengan más temperatura promedio
SELECT 
    IDCiudad,
    Temperatura
FROM Mediciones
WHERE Temperatura > (SELECT AVG(Temperatura) FROM Mediciones)

-- Las mediciones que tengan una temperatura menor al promedio de temperatura general del año actual
SELECT *
FROM Mediciones 
WHERE Temperatura < (SELECT AVG(Temperatura) FROM Mediciones WHERE YEAR(FechaHora) = Year(GETDATE()) ) 

-- Las ciudades que no cumplen una condicion: (que no tengan mediciones en el año 2024)
--CONJUNTO CIUDADES
--       -  
--CONJUNTO CIUDADES CON MEDICIONES EN 2024 (LINEA 32)
------------------------------------------
--CONJUNTO CIUDADES SIN MEDICIONES EN 2024

SELECT 
--    C.IDCiudad,
    C.Nombre
--    YEAR(M.FechaHora) 
FROM Ciudades AS C
--INNER JOIN Mediciones AS M ON C.IDCIudad = M.IDCiudad
WHERE C.IDCiudad NOT IN (SELECT DISTINCT IDCiudad FROM Mediciones WHERE YEAR(FechaHora) = 2024) 

-- Las mediciones en las que se hayan registrado una temperatura mayor a la de cualquier ciudad Italia (a la temp mas alta registrada alli)
SELECT M1.*, C1.Nombre  
FROM Mediciones AS M1
INNER JOIN Ciudades C1 ON M1.IDCiudad = C1.IDCiudad
WHERE M1.Temperatura > (SELECT IDCIudad, MAX(M.Temperatura) FROM Mediciones INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad INNER JOIN Paises P ON P.IDPais = C.IDPais WHERE P.Nombre = 'Italia' ORDER BY M.Temperatura ASC )



--  EN LA CLAUSULA FROM - COMO COLUMNA DE LA CONSULTA PRINCIPAL 
-- Obtener todas las categorias y para cada una de ellas el costo del curso mas barato que le corresponda , en este caso vamos a querer obtener el valor minimo para cada una de las categorias
-- 1.Obtener el listado de las categorias, la subconsulta va representar la columna de costos
SELECT CAT.CATEGORIA FROM CATEGORIAS AS CAT
--2.Generamos una nueva columna que va contener el costo mas bajo
SELECT CAT.CATEGORIA, (
    SELECT MIN(CUR.COSTO) FROM CURSOS AS CUR WHERE CUR.IDCATEGORIA = CAT.IDCATEGORIA
) AS 'COSTO MAS BAJO'
FROM CATEGORIAS AS CAT 

-- Nombre Pais, Promedio Temperatura 2022
SELECT 
    P.Nombre, 
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2022 AND C.IDPais = P.IDPais
    )  AS Promedio2022,
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2022 AND C.IDPais = P.IDPais
    )  AS Promedio2023,
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2024 AND C.IDPais = P.IDPais
    )  AS Promedio2024
From Paises P 

-- Obtener todos los alumnos que hayan realizado mas cursos a distancia que presenciales pero que AL MENOS hayan realizado un curso presencial
--1.Primero obtenemos una tabla parcial para ver los cursos que toman los alumnos ordenado por apellido y si son presenciales o a distancia
SELECT A.APELLIDO, C.IDCURSO, C.PRESENCIAL
FROM ALUMNOS AS A
INNER JOIN ALUMNOS_x_CURSO AS AXC ON A.IDALUMNO = AXC.IDALUMNO 
INNER JOIN CURSOS AS C ON C.IDCURSO = AXC.IDCURSO
ORDER BY APELLIDO ASC
--2.DESARROLLAMOS LAS SUBCONSULTAS
SELECT AUX.APELLIDO
    FROM
    (SELECT A.APELLIDO,
        (SELECT COUNT(*) FROM ALUMNOS_x_CURSO AS AXC
            INNER JOIN CURSOS AS C ON AXC.IDCURSO = C.IDCURSO
            WHERE C.PRESENCIAL = 1 AND AXC.IDALUMNO = A.IDALUMNO) AS CANTP,
        (SELECT COUNT(*) FROM ALUMNOS_x_CURSO AS AXC
            INNER JOIN CURSOS AS C ON AXC.IDCURSO = C.IDCURSO
            WHERE C.PRESENCIAL = 0 AND AXC.IDALUMNO = A.IDALUMNO) AS CANTD
        FROM ALUMNOS AS A) AS AUX
WHERE AUX.CANTD > AUX.CANTP AND AUX.CANTP > 0

-- Nombres de paises que el promedio de temperatura 2022 sea mayor al 2023 y el del 2023 mayor al 2024
SELECT Est.Anuales.Nombre FROM (
SELECT 
    P.Nombre, 
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2022 AND C.IDPais = P.IDPais
    )  AS Promedio2022,
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2022 AND C.IDPais = P.IDPais
    )  AS Promedio2023,
    (
        SELECT AVG(Temperatura) FROM Mediciones AS M
        INNER JOIN Ciudades AS C ON M.IDCiudad = C.IDCiudad
        WHERE Year(M.FechaHora) = 2024 AND C.IDPais = P.IDPais
    )  AS Promedio2024
From Paises P 
) AS EstAnuales 
WHERE EstAnuales.Prom2022 > EstAnuales.Prom2023 AND EstAnuales.Prom2023 > EstAnuales.Prom2024

