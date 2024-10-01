SELECT DISTINCT
  OS.NOMBRE
FROM
    TURNOS AS T
INNER JOIN MEDICOS AS M ON T.IDMEDICO = M.IDMEDICO
INNER JOIN ESPECIALIDADES AS E ON M.IDESPECIALIDAD = E.IDESPECIALIDAD
INNER JOIN PACIENTES AS P ON T.IDPACIENTE = P.IDPACIENTE 
INNER JOIN OBRAS_SOCIALES AS OS ON P.IDOBRASOCIAL = OS.IDOBRASOCIAL
WHERE
  E.NOMBRE = 'ODONTOLOGÍA'

SELECT  
    COUNT(DISTINCT P.IDPACIENTE) AS CANTIDAD
FROM PACIENTES AS P
INNER JOIN TURNOS AS T ON P.IDPACIENTE = T.IDPACIENTE
WHERE T.DURACION > 
(
    SELECT   
        AVG(DURACION)
    FROM TURNOS
)

select COUNT(DISTINCT T.IDPACIENTE) as TurnosDistintos
from TURNOS as T
where T.DURACION > (Select AVG(T2.DURACION) from Turnos T2)


SELECT 
    AVG(M.COSTO_CONSULTA)
FROM MEDICOS AS M
INNER JOIN ESPECIALIDADES AS E ON M.IDESPECIALIDAD = E.IDESPECIALIDAD
WHERE E.NOMBRE = 'Oftalmología'

SELECT 
    COUNT(IDPACIENTE) AS CantPacientes
FROM PACIENTES
WHERE IDPACIENTE NOT IN 
(
    SELECT 
        T.IDPACIENTE
    FROM TURNOS AS T
    WHERE YEAR(T.FECHAHORA) = 2019
)

SELECT 
    COUNT(distinct IDPACIENTE) AS CantPacientes
FROM PACIENTES
WHERE IDPACIENTE NOT IN 
(
    SELECT 
        T.IDPACIENTE
    FROM TURNOS AS T
    WHERE YEAR(T.FECHAHORA) = 2019
)


SELECT TOP 1
    M.APELLIDO
FROM MEDICOS AS M
WHERE M.SEXO = 'M'
ORDER BY M.FECHAINGRESO ASC
