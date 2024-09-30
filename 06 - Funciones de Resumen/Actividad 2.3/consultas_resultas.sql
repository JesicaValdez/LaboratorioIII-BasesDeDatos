--1 La cantidad de archivos con extensión zip.
SELECT 
    COUNT(*) AS Contador
FROM Archivos AS A 
WHERE A.Extension =  'zip' 

-- 2 La cantidad de archivos que fueron modificados y, por lo tanto, su fecha de última modificación no es la misma que la fecha de creación.
SELECT 
    COUNT(A.IDArchivo) AS 'Modificados'
From Archivos AS A
WHERE A.FechaUltimaModificacion <> A.FechaCreacion

-- 3 La fecha de creación más antigua de los archivos con extensión pdf.
SELECT
    MIN(FechaCreacion) AS 'Fecha'
FROM Archivos 
WHERE Extension = 'pdf'
--INNER JOIN TiposArchivos AS TA ON A.IDTipoArchivo = TA.IDTipoArchivo
--WHERE TA.TipoArchivo LIKE '%pdf%'

-- 4 La cantidad de extensiones distintas cuyos archivos tienen en su nombre o en su descripción la palabra 'Informe' o 'Documento'.
SELECT 
    COUNT(DISTINCT Extension) AS 'Extensiones'
From Archivos 
WHERE Descripcion LIKE '%Informe%' OR Descripcion LIKE '%Documento%'

-- 5 El promedio de tamaño (expresado en Megabytes) de los archivos con extensión 'doc', 'docx', 'xls', 'xlsx'.
SELECT 
    AVG(CAST(Tamaño AS float) / 1048576)
FROM Archivos 
WHERE Extension IN ('doc', 'docx', 'xls', 'xlxs')

-- 6 La cantidad de archivos que le fueron compartidos al usuario con apellido 'Clarck'
SELECT 
    count(*) as CantArchivosCompartidos 
FROM ArchivosCompartidos AS ac
INNER JOIN Usuarios AS u ON ac.IDUsuario = u.IDUsuario
WHERE u.Apellido = 'Clarck'

-- 7 La cantidad de tipos de usuario que tienen asociado usuarios que registren, como dueños, archivos con extensión pdf.
SELECT 
    COUNT(DISTINCT tu.TipoUsuario) AS CantTiposUsuarios 
FROM Usuarios AS u
INNER JOIN Archivos AS a ON u.IDUsuario = a.IDUsuarioDueño
INNER JOIN TiposUsuario AS tu ON u.IDTipoUsuario = tu.IDTipoUsuario
WHERE a.Extension = 'pdf'

-- 8 El tamaño máximo expresado en Megabytes de los archivos que hayan sido creados en el año 2024.
SELECT 
    MAX(CAST(A.Tamaño AS FLOAT) / 1048576) AS 'Tamaño Max MB' 
FROM Archivos AS A
WHERE YEAR(FechaCreacion) = 2024

-- 9 El nombre del tipo de usuario y la cantidad de usuarios distintos de dicho tipo que registran, como dueños, archivos con extensión pdf.
SELECT
    TU.TipoUsuario,
    COUNT(DISTINCT A.IDUsuarioDueño) AS 'Cantidad Usuarios'
FROM Archivos AS A
INNER JOIN Usuarios AS U ON A.IDUsuarioDueño = U.IDUsuario
INNER JOIN TiposUsuario AS TU ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE A.Extension = 'pdf'
GROUP BY TU.TipoUsuario

-- 10 El nombre y apellido de los usuarios dueños y la suma total del tamaño de los archivos que tengan compartidos con otros usuarios. 
--Mostrar ordenado de mayor sumatoria de tamaño a menor.
SELECT 
    U.Nombre,
    U.Apellido,
    SUM(A.Tamaño) AS Compartidos
FROM Archivos AS A 
INNER JOIN Usuarios AS U ON A.IDUsuarioDueño = U.IDUsuario
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
GROUP BY U.Nombre, U.Apellido
ORDER BY Compartidos DESC 

-- 11 El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo.
SELECT 
    TA.TipoArchivo,
    AVG(A.Tamaño)
FROM Archivos AS A 
INNER JOIN TiposArchivos AS TA ON A.IDTipoArchivo = TA.IDTipoArchivo
GROUP BY TA.TipoArchivo

-- 12 Por cada extensión, indicar la extensión, la cantidad de archivos con esa extensión y el total acumulado en bytes. 
--Ordenado por cantidad de archivos de forma ascendente.
SELECT 
    A.Extension,
    COUNT(A.Extension) AS 'Total Archivos',
    SUM(A.Tamaño) AS 'Bytes'
FROM Archivos AS A 
GROUP BY A.Extension
ORDER BY [Total Archivos] ASC

-- 13 Por cada usuario, indicar IDUSuario, Apellido, Nombre y la sumatoria total en bytes de los archivos que es dueño. 
--Si algún usuario no registra archivos indicar 0 en la sumatoria total.
SELECT 
    U.IDUsuario,
    U.Apellido,
    U.NOMBRE,
    ISNULL (SUM(A.Tamaño), 0) AS 'TotalBytes'
FROM Usuarios AS U
LEFT JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
GROUP BY U.IDUSuario, U.Apellido, U.Nombre

-- 14 Los tipos de archivos que fueron compartidos más de una vez con el permiso con nombre 'Lectura'
SELECT 
    TA.TipoArchivo
FROM TiposArchivos AS TA
INNER JOIN Archivos AS A ON A.IDTipoArchivo = TA.IDTipoArchivo
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Permisos AS P ON P.IDPermiso = AC.IDPermiso
WHERE P.Nombre = 'Lectura'
GROUP BY TA.TipoArchivo
HAVING count(*) > 1

-- 16 Por cada tipo de archivo indicar el tipo de archivo y el tamaño del archivo de dicho tipo que sea más pesado.
SELECT 
    TA.TipoArchivo,
    MAX(A.Tamaño)
FROM Archivos AS A
INNER JOIN TiposArchivos AS TA ON A.IDTipoArchivo = TA.IDTipoArchivo
GROUP BY TA.TipoArchivo

-- 17 El nombre del tipo de archivo y el promedio de tamaño de los archivos que corresponden a dicho tipo de archivo. 
--Solamente listar aquellos registros que superen los 50 Megabytes de promedio.
SELECT
    TA.TipoArchivo,
    AVG(CAST(A.Tamaño AS float))
FROM Archivos AS A
INNER JOIN TiposArchivos AS TA ON A.IDTipoArchivo = TA.IDTipoArchivo
GROUP BY TA.TipoArchivo
HAVING AVG(CAST(A.Tamaño as float) / 1048576) > 50

-- 18 Listar las extensiones que registren más de 2 archivos que no hayan sido compartidos.
SELECT 
    A.Extension,
    COUNT(A.IDArchivo) AS 'Cant Extensiones'
FROM Archivos AS A
LEFT JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
WHERE AC.IDArchivo IS NULL
GROUP BY A.Extension
HAVING COUNT(A.IDArchivo) > 2