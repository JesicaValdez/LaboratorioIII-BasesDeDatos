USE BDArchivos

-- 1 Por cada usuario listar el nombre, apellido y el nombre del tipo de usuario.
SELECT 
    U.Nombre,
    U.Apellido,
    T.TipoUsuario
FROM Usuarios AS U 
INNER JOIN TiposUsuario AS T 
ON U.IDTipoUsuario = T.IdTipoUsuario 

-- 2 Listar el ID, nombre, apellido y tipo de usuario de aquellos usuarios que sean del tipo 'Suscripción Free' o 'Suscripción Básica'
SELECT 
    U.IDUsuario,
    U.Nombre,
    U.Apellido,
    T.TipoUsuario
FROM Usuarios AS U 
INNER JOIN TiposUsuario AS T
ON U.IDTipoUsuario = T.IDTipoUsuario
WHERE T.TipoUsuario IN ('Suscripción Free', 'Suscripción Básica')

-- 3 Listar los nombres de archivos, extensión, tamaño expresado en Megabytes y el nombre del tipo de archivo. NOTA: En la tabla Archivos el tamaño está expresado en Bytes.
SELECT 
    A.Nombre,
    A.Extension,
    CAST(A.Tamaño / 1048576.0 AS DECIMAL(10, 2)),
    TA.TipoArchivo
FROM Archivos AS A
INNER JOIN TiposArchivos AS TA
ON A.IDTipoArchivo = TA.IDTipoArchivo

-- 4 Listar los nombres de archivos junto a la extensión con el siguiente formato 'NombreArchivo.extension'. Por ejemplo, 'Actividad.pdf'. Sólo listar aquellos cuyo tipo de archivo contenga los términos 'ZIP', 'Word', 'Excel', 'Javascript' o 'GIF'

SELECT 
    CONCAT(A.Nombre, '.', A.Extension) AS NombreCompleto
FROM Archivos AS A
INNER JOIN TiposArchivos AS TA
ON A.IDTipoArchivo = TA.IDTipoArchivo
WHERE TA.TipoArchivo LIKE '%ZIP%' 
   OR TA.TipoArchivo LIKE '%Word%' 
   OR TA.TipoArchivo LIKE '%Excel%' 
   OR TA.TipoArchivo LIKE '%Javascript%' 
   OR TA.TipoArchivo LIKE '%GIF%';

-- 5 Listar los nombres de archivos, su extensión, el tamaño en megabytes y la fecha de creación de aquellos archivos que le pertenezcan al usuario dueño con nombre 'Michael' y apellido 'Williams'.
SELECT 
    A.Nombre,
    A.Extension,
    CAST(A.Tamaño / 1048576.0 AS DECIMAL(10, 2)),
    A.FechaCreacion
FROM Archivos AS A
INNER JOIN Usuarios AS U
ON A.IDUsuarioDueño = U.IDUsuario
WHERE U.Nombre = 'Michael' AND U.Apellido = 'Williams'

-- 6 Listar los datos completos del archivo más pesado del usuario dueño con nombre 'Michael' y apellido 'Williams'. Si hay varios archivos que cumplen esa condición, listarlos a todos.
SELECT TOP 1 WITH TIES
    A.IDArchivo,
    A.IDUsuarioDueño,
    A.Nombre,
    A.Extension,
    A.Descripcion,
    A.IDTipoArchivo,
    A.Tamaño,
    A.FechaCreacion,
    A.FechaUltimaModificacion,
    A.Eliminado
FROM Archivos AS A
INNER JOIN Usuarios AS U
ON A.IDUsuarioDueño = U.IDUsuario
WHERE (U.Nombre = 'Michael' AND U.Apellido = 'Williams')
ORDER BY Tamaño DESC 
  
--alternativa:
  --  AND A.Tamaño = (
   --     SELECT MAX(Tamaño)
   --     FROM Archivos
   --     WHERE IDUsuarioDueño = U.IDUsuario
    --)

--7 Listar nombres de archivos, extensión, tamaño en bytes, fecha de creación y de modificación, apellido y nombre del usuario dueño de aquellos archivos cuya descripción contengan el término 'empresa' o 'presupuesto'
SELECT 
    A.Nombre,
    A.Extension,
    A.Tamaño,
    A.FechaCreacion,
    A.FechaUltimaModificacion,
    U.Apellido,
    U.Nombre
FROM Archivos AS A
INNER JOIN Usuarios AS U
ON A.IDUsuarioDueño = U.IDUsuario
WHERE A.Descripcion LIKE '%empresa%' OR A.Descripcion LIKE '%presupuesto%'

-- 8 Listar las extensiones sin repetir de los 1archivos cuyos 2usuarios dueños tengan 3tipo de usuario 'Suscripción Plus', 'Suscripción Premium' o 'Suscripción Empresarial'
SELECT DISTINCT
    A.Extension
FROM Archivos AS A
INNER JOIN Usuarios AS U
ON A.IDUsuarioDueño = U.IDUsuario
INNER JOIN TiposUsuario AS TU
ON U.IDTipoUsuario = TU.IDTipoUsuario
WHERE TU.TipoUsuario IN ('Suscripción Plus', 'Suscripción Premium', 'Suscripción Empresarial')

-- 9 Listar los apellidos y nombres de los usuarios dueños y el tamaño del archivo de los tres archivos con extensión 'zip' más pesados. Puede ocurrir que el mismo usuario aparezca varias veces en el listado.
SELECT TOP 3
    U.Apellido,
    U.Nombre,
    A.Tamaño
FROM Usuarios AS U
INNER JOIN Archivos AS A
ON U.IDUsuario = A.IDUsuarioDueño
WHERE A.Extension = 'zip'  
ORDER BY A.Tamaño DESC

-- 10 Por cada archivo listar el nombre del archivo, la extensión, el tamaño en bytes, el nombre del tipo de archivo y el tamaño calculado en su mayor expresión y la unidad calculada. Siendo Gigabytes si al menos pesa un gigabyte, Megabytes si al menos pesa un megabyte, Kilobyte si al menos pesa un kilobyte o en su defecto expresado en bytes. Por ejemplo, si el archivo imagen.jpg pesa 40960 bytes entonces debe figurar 40 en la columna Tamaño Calculado y 'Kilobytes' en la columna unidad.
SELECT 
    A.Nombre,
    A.Extension,
    A.Tamaño,
    TA.TipoArchivo,
    CASE 
        WHEN A.Tamaño >= 1073741824 THEN CAST(A.Tamaño / 1073741824.0 AS decimal(10))  -- Gigabytes
        WHEN A.Tamaño >= 1048576 THEN CAST(A.Tamaño / 1048576.0 AS decimal(10)) -- Megabytes
        WHEN A.Tamaño >= 1024 THEN CAST(A.Tamaño / 1024.0 AS decimal(10)) -- Kilobytes
        ELSE A.Tamaño -- Bytes
    END AS TamañoCalculado,
    CASE 
        WHEN A.Tamaño >= 1073741824 THEN 'Gigabytes'
        WHEN A.Tamaño >= 1048576 THEN 'Megabytes'
        WHEN A.Tamaño >= 1024 THEN 'Kilobytes'
        ELSE 'Bytes'
    END AS Unidad
FROM Archivos AS A
INNER JOIN TiposArchivos AS TA
ON A.IDTipoArchivo = TA.IDTipoArchivo; 

--11 Listar los nombres de archivo y extensión de los archivos que han sido compartidos. 
SELECT DISTINCT
    A.Nombre,
    A.Extension
FROM Archivos AS A
INNER JOIN ArchivosCompartidos AS AC
ON A.IDArchivo = AC.IDArchivo

-- 12 Listar los nombres de archivo y extensión de los archivos que han sido compartidos a usuarios con apellido 'Clarck' o 'Jones'
SELECT 
    U.Apellido,
    A.Nombre,
    A.Extension
FROM Archivos AS A
INNER JOIN ArchivosCompartidos AS AC
ON A.IDArchivo = AC.IDArchivo
INNER JOIN Usuarios AS U
ON AC.IDUsuario = U.IDUsuario
WHERE U.Apellido IN ('Clarck', 'Jones')

-- 13 Listar los nombres de archivo, extensión, apellidos y nombres de los usuarios a quienes se le hayan compartido archivos con permiso de 'Escritura'
SELECT 
    A.Nombre,
    A.Extension,
    U.Apellido,
    U.Nombre
FROM Archivos AS A
INNER JOIN ArchivosCompartidos AS AC
ON A.IDArchivo = AC.IDArchivo
INNER JOIN Permisos AS P 
ON AC.IDPermiso = P.IDPermiso
INNER JOIN Usuarios AS U
ON U.IDUsuario = AC.IDUsuario
WHERE P.Nombre = 'Escritura'

-- 14 Listar los nombres de archivos y extensión de los archivos que no han sido compartidos.
SELECT 
    A.Nombre,
    A.Extension
FROM Archivos AS A
LEFT JOIN ArchivosCompartidos AS AC
ON A.IDArchivo = AC.IDArchivo
WHERE AC.FechaCompartido IS NULL 
ORDER BY AC.IDArchivo ASC

-- 15 Listar los apellidos y nombres de los usuarios dueños que tienen archivos eliminados.
SELECT DISTINCT
    U.Apellido,
    U.Nombre
FROM Usuarios AS U
INNER JOIN Archivos AS A
ON U.IDUsuario = A.IDUsuarioDueño
WHERE A.Eliminado = 1
ORDER BY Apellido

-- 16  Listar los nombres de los tipos de suscripciones, sin repetir, que tienen archivos que pesan al menos 120 Megabytes.
SELECT DISTINCT 
    TU.TipoUsuario
FROM TiposUsuario AS TU
INNER JOIN Usuarios AS U
ON TU.IDTipoUsuario = U.IDTipoUsuario
INNER JOIN Archivos AS A
ON U.IDUsuario = A.IDUsuarioDueño
WHERE A.Tamaño >= 120 * 1024 * 1024

-- 17 Listar los apellidos y nombres de los usuarios dueños, nombre del archivo,
--extensión, fecha de creación, fecha de modificación y la cantidad de días
--transcurridos desde la última modificación. Sólo incluir a los archivos que se
--hayan modificado (fecha de modificación distinta a la fecha de creación).
SELECT *, DATEDIFF(DAY, FechaUltimaModificacion, GETDATE()) AS DIAS_TRANSCURRIDOS
FROM Archivos AS A
INNER JOIN Usuarios AS U
ON A.IDUsuarioDueño = U.IDUsuario
WHERE A.FechaCreacion <> A.FechaUltimaModificacion
    

-- 18 Listar nombres de archivos, extensión, tamaño, apellido y nombre del usuario dueño del archivo, apellido y nombre del usuario que tiene el archivo compartido y el nombre de permiso otorgado.
SELECT 
    A.Nombre, 
    A.Extension, 
    A.Tamaño, 
    CONCAT(Ud.Apellido, ' ', Ud.Nombre) AS Usuario_Dueño,
    CONCAT(UC.Apellido, ' ', UC.Nombre) AS Usuarios_Compartidos,
    P.Nombre
FROM Archivos AS A
INNER JOIN Usuarios AS Ud ON A.IDUsuarioDueño = Ud.IDUsuario
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Usuarios AS Uc ON AC.IDUsuario = Uc.IDUsuario
INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso

-- 19 Listar nombres de archivos, extensión, tamaño, apellido y nombre del usuario dueño del archivo, apellido y nombre del usuario que tiene el archivo compartido y el nombre de permiso otorgado. 
--Sólo listar aquellos registros cuyos tipos de usuarios coincidan tanto para el dueño como para el usuario al que le comparten el archivo.
SELECT 
    A.Nombre, 
    A.Extension, 
    A.Tamaño, 
    CONCAT(Ud.Apellido, ' ', Ud.Nombre) AS Usuario_Dueño,
    CONCAT(UC.Apellido, ' ', UC.Nombre) AS Usuarios_Compartidos,
    P.Nombre
FROM Archivos AS A
INNER JOIN Usuarios AS Ud ON A.IDUsuarioDueño = Ud.IDUsuario
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Usuarios AS UC ON AC.IDUsuario = UC.IDUsuario
INNER JOIN Permisos AS P ON AC.IDPermiso = P.IDPermiso
WHERE Ud.IDTipoUsuario = UC.IDTipoUsuario 


-- 20 Apellido y nombre de los usuarios que tengan compartido o sean dueños del archivo con nombre 'Documento Legal'
SELECT 
    U.Apellido,
    U.Nombre
FROM Usuarios AS U
INNER JOIN Archivos AS A ON U.IDUsuario = A.IDUsuarioDueño
WHERE A.Nombre = 'Documento Legal' 
UNION
SELECT 
    U.Apellido, 
    U.Nombre 
FROM Archivos A
INNER JOIN ArchivosCompartidos AS AC ON A.IDArchivo = AC.IDArchivo
INNER JOIN Usuarios AS U ON U.IDUsuario = AC.IDUsuario
WHERE A.Nombre = 'Documento Legal'
