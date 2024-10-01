-- 1 ¿Cuáles de los siguientes platos fueron servidos por mozos con más de 10 años de antigüedad y con nivel 9 de dificultad?
SELECT DISTINCT 
    P.Nombre,
    P.IDPlato
FROM Platos AS P
INNER JOIN ServiciosMesa AS SM ON P.IDPlato = SM.IDPlato
INNER JOIN Mozos AS M ON SM.IDMozo = M.IDMozo
WHERE P.NivelDificultad ='9' 
    AND M.IDMozo IN 
(
    SELECT 
        IDMozo
    FROM Mozos
    WHERE YEAR(AñoIngreso) > 10
)

-- 2 ¿Cuál fue el mozo/a que en promedio haya recibido la mayor cantidad de dinero en concepto de propinas?
SELECT TOP 1
    CONCAT(M.Apellidos, ' ', M.Nombres) AS Mozo,
    AVG(SM.Propina) AS PropinaPromedio
FROM ServiciosMesa AS SM
INNER JOIN Mozos AS M ON SM.IDMozo = M.IDMozo
GROUP BY M.Apellidos, M.Nombres
ORDER BY PropinaPromedio DESC

-- 3 ¿Que mozo fue el que sirvió mas veces el mismo plato?
SELECT TOP 1
    CONCAT(M.Apellidos, ' ', M.Nombres) AS Mozo,
    P.Nombre AS Plato,
    COUNT(*) AS VecesServido
FROM Mozos AS M
INNER JOIN ServiciosMesa AS SM ON M.IDMozo = SM.IDMozo
INNER JOIN Platos AS P ON SM.IDPlato = P.IDPlato
GROUP BY M.Apellidos, M.Nombres, P.Nombre
ORDER BY VecesServido DESC

-- 4 ¿Cuál de los siguientes platos tuvieron algún servicio con el puntaje más alto entre todos los servicios 
--pero también algún servicio con el puntaje más bajo entre todos los servicios? 
--Es decir, qué platos fueron puntuados con el puntaje más alto y también con el puntaje más bajo.
SELECT 
    P.Nombre AS Plato
FROM Platos P
JOIN ServiciosMesa SM ON P.IDPlato = SM.IDPlato
WHERE P.Nombre IN ('Morcilla', 'Pastel de Papa', 'Puchero', 'Asado')
GROUP BY P.IDPlato, P.Nombre
HAVING MIN(SM.PuntajeObtenido) = (SELECT MIN(PuntajeObtenido) FROM ServiciosMesa)
   AND MAX(SM.PuntajeObtenido) = (SELECT MAX(PuntajeObtenido) FROM ServiciosMesa)

-- 5 Agrega las tablas, columnas y restricciones que consideres necesario para poder registrar los cocineros del restaurant. 
--Debe poder registrarse el apellido, nombre, fecha de nacimiento y fecha de ingreso al restaurant. También se debe poder conocer qué cocineros participaron en cada servicio de mesa. Tener en cuenta que es posible que más de un cocinero haya trabajo en el mismo servicio de mesa.
CREATE TABLE Cocineros (
    IDCocinero BIGINT PRIMARY KEY IDENTITY(1,1),
    Apellidos NVARCHAR(20) NOT NULL,
    Nombres NVARCHAR(20) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    FechaIngreso DATE NOT NULL
)

CREATE TABLE Cocineros_X_ServiciosMesa (
    ID BIGINT PRIMARY KEY IDENTITY(1,1),
    IDCocinero BIGINT NOT NULL,
    IDServicioMesa BIGINT NOT NULL,
    CONSTRAINT FK_Cocineros FOREIGN KEY (IDCocinero) REFERENCES Cocineros(IDCocinero),
    CONSTRAINT FK_ServiciosMesa FOREIGN KEY (IDServicioMesa) REFERENCES ServiciosMesa(IDServicioMesa),
    CONSTRAINT u_CocineroServicio UNIQUE (IDCocinero, IDServicioMesa)
)
