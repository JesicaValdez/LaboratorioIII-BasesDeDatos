--                                       EJERCICIOS  de Subconsulta 

USE BDArchivos

-- 1 Los nombres y extensiones y tamaño en Megabytes de los archivos que pesen más que el promedio de archivos.
SELECT 
    Nombre,
    Extension,
    CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2)) 
FROM Archivos
WHERE CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2))  > 
(
SELECT 
    (Select AVG(CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2))) 
FROM Archivos)
)

-- 2 Los usuarios indicando apellido y nombre que no sean dueños de ningún archivo con extensión 'zip'.
SELECT 
    U.Apellido,
    U.Nombre
FROM Usuarios AS U
WHERE U.IDUsuario NOT IN 
(
SELECT DISTINCT
    IDUsuarioDueño 
FROM Archivos 
WHERE Extension = 'zip'
) 

-- 3 Los usuarios indicando IDUsuario, apellido, nombre y tipo de usuario que no hayan creado ni modificado ningún archivo en el año actual.
SELECT 
    U.IDUsuario,
    U.Apellido,
    U.Nombre,
    TU.TipoUsuario
FROM Usuarios AS U
INNER JOIN TiposUsuario AS TU ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE U.IDUsuario NOT IN 
(
SELECT DISTINCT 
    IDUsuarioDueño
FROM Archivos
WHERE YEAR(FechaCreacion) = YEAR(GETDATE())
   OR YEAR (FechaUltimaModificacion) = YEAR(GETDATE())
)


-- 4 Los tipos de usuario que no registren .................... usuario con archivos eliminados.
SELECT
    TU.TipoUsuario
FROM TiposUsuario AS TU
WHERE TU.IDTipoUsuario NOT IN 
(
SELECT DISTINCT 
    U.IDTipoUsuario
FROM Usuarios U
INNER JOIN Archivos A ON U.IDUsuario = A.IDUsuarioDueño
WHERE A.Eliminado = 1 
)

-- 5 Los tipos de archivos que no se hayan compartido con el permiso de 'Lectura'
SELECT DISTINCT 
    TA.IDTipoArchivo,
    TA.TipoArchivo
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON TA.IDTipoArchivo = A.IDTipoArchivo 
WHERE A.IDArchivo NOT IN 
(
SELECT DISTINCT 
    P.IDPermiso
FROM Permisos P
INNER JOIN ArchivosCompartidos AS AC ON P.IDPermiso = AC.IDPermiso
WHERE P.Nombre = 'Lectura'
)

-- 6 Los nombres y extensiones de los archivos que tengan un tamaño mayor al del archivo con extensión 'xls' más grande.
SELECT 
    Nombre,
    Extension,
    Tamaño
FROM Archivos
WHERE Tamaño > 
(
SELECT 
    MAX(Tamaño) 
FROM Archivos 
WHERE Extension = 'xls'
)

-- 7 Los nombres y extensiones de los archivos que tengan un tamaño mayor al del archivo con extensión 'zip' más pequeño.
SELECT 
    Nombre,
    Extension
FROM Archivos
WHERE Tamaño > 
(
SELECT 
    MIN(Tamaño) 
FROM Archivos 
WHERE Extension = 'zip'
)

-- 8 Por cada tipo de archivo indicar el tipo y la cantidad de archivos eliminados y la cantidad de archivos no eliminados.
SELECT 
    TA.TipoArchivo, 
    (  
        SELECT COUNT(*) 
        FROM Archivos AS A
        WHERE TA.IDTipoArchivo = A.IDTipoArchivo 
            AND Eliminado = 0
    ) AS NoEliminados,
    (  
        SELECT COUNT(*) 
        FROM Archivos AS A
        WHERE TA.IDTipoArchivo = A.IDTipoArchivo 
            AND Eliminado = 1
    ) AS Eliminados
FROM TiposArchivos AS TA


-- 9 Por cada usuario indicar el IDUsuario, el apellido, el nombre, la cantidad de archivos pequeños (menos de 20MB) y la cantidad de archivos grandes (20MBs o más)
SELECT 
    U.IDUsuario,
    U.Apellido,
    U.Nombre,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2)) < 20
    ) AS Archivos_Pequeños,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2)) >= 20
    ) AS Archivos_Grandes
FROM Usuarios AS U

-- 10 Por cada usuario indicar el IDUsuario, el apellido, el nombre y la cantidad de archivos creados en el año 2022, la cantidad en el año 2023 y la cantidad creados en el 2024.
SELECT 
    U.IDUsuario,
    U.Apellido,
    U.Nombre,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND YEAR(FechaCreacion) = 2022
    ) AS AÑO2022,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND YEAR(FechaCreacion) = 2023
    ) AS AÑO2023,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND YEAR(FechaCreacion) = 2024
    ) AS AÑO2024
FROM Usuarios AS U


-- 11 Los archivos que fueron compartidos con permiso de 'Comentario' pero no con permiso de 'Lectura'
SELECT 
    A.Nombre
FROM Archivos AS A
WHERE A.IDArchivo IN 
(
    SELECT 
        AC.IDArchivo
    FROM ArchivosCompartidos AS AC
    INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
    WHERE P.Nombre = 'Comentario'
) 
AND A.IDArchivo NOT IN 
(
    SELECT 
        AC.IDArchivo
    FROM ArchivosCompartidos AS AC 
    INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
    WHERE P.Nombre = 'Lectura'
)

-- 12 CLAUSULA FROM-------------Los tipos de archivos que registran más archivos eliminados que no eliminados.
SELECT
    AUX.IDTipoArchivo, AUX.TipoArchivo, AUX.Eliminados, AUX.NoEliminados
FROM 
(
SELECT 
    TA.IDTipoArchivo,
    TA.TipoArchivo, 
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE TA.IDTipoArchivo = A.IDTipoArchivo
            AND Eliminado = 0
    ) AS NoEliminados,
    (
         SELECT COUNT(*)
        FROM Archivos AS A
        WHERE TA.IDTipoArchivo = A.IDTipoArchivo
            AND Eliminado = 1
    ) AS Eliminados
FROM TiposArchivos AS TA
) AS AUX
WHERE AUX.Eliminados > AUX.NoEliminados
        

-- 13 Los usuario que registren más archivos pequeños que archivos grandes (pero que al menos registren un archivo de cada uno)
SELECT
    AUX.Apellido, AUX.Nombre,  AUX.Archivos_Pequeños, AUX.Archivos_Grandes
FROM 
(
SELECT 
    U.Apellido,
    U.Nombre,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2)) < 20
    ) AS Archivos_Pequeños,
    (
        SELECT COUNT(*)
        FROM Archivos AS A
        WHERE U.IDUsuario = A.IDUsuarioDueño
            AND CAST(Tamaño / 1048576.0 AS DECIMAL(10, 2)) >= 20
    ) AS Archivos_Grandes
FROM Usuarios AS U
) AS AUX 
WHERE AUX.Archivos_Pequeños > AUX.Archivos_Grandes
    AND (AUX.Archivos_Pequeños >= 1 AND AUX.Archivos_Grandes >= 1)

-- 14 Los usuarios------- que hayan creado (CONDICION IN)---------más archivos en el 2022 que en el 2023 y en el 2023 que en el 2024.
-- Esta consulta selecciona los usuarios que cumplen con las condiciones definidas en la subconsulta,
SELECT 
    U.IDUsuario,
    U.Apellido,
    U.Nombre
FROM Usuarios U
WHERE U.IDUsuario IN 
(
SELECT 
    A.IDUsuarioDueño
FROM Archivos A
GROUP BY A.IDUsuarioDueño
HAVING COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2022 THEN 1 END) > COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2023 THEN 1 END)
   AND COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2023 THEN 1 END) > COUNT(CASE WHEN YEAR(A.FechaCreacion) = 2024 THEN 1 END)
)