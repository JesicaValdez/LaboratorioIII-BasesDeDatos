-- Funciones de Agregado --

-- Funcion COUNT
-- Cantidad de cursos por categoria
SELECT 
    cat.IdCategoria,
    cat.Nombre,
    COUNT(cur.IdCategoria) AS contador
FROM Cursos as cur
INNER JOIN Categorias as cat 
ON cat.IdCategoria = cur.IdCategoria
GROUP BY
    cat.IdCategoria,
    cat.Categoria

-- Cantidad de alumnos que tomaron el curso de reposteria
--primero abrimos los datos de la tabla y leemos Y la tabla alumnosXcurso
SELECT 
    COUNT(DISTINCT axc.IdAlumno)
FROM Alumnos_X_Curso AS axc 
INNER JOIN Cursos AS cur 
ON axc.IdCurso = cur.IdCurso
WHERE cur.Nombre = 'REPOSTERIA' 

--Diferencia entre utilizar: COUNT * y COUNT de una COLUMNA: -- Contabilizar cantidad de inscripiciones que tuvo cada curso
--OPCION 1 : NO CONTABILIZA LOS DATOS NULOS
SELECT 
    cur.Nombre,
    COUNT (*) AS 'cant_inscripciones'
FROM Cursos AS cur
INNER JOIN  Alumnos_X_Curso AS axc 
ON axc.IdCurso = cur.IdCurso
GROUP BY cur.Nombre
ORDER BY COUNT (*) ASC

--OPCION 2: Contabilizando con CERO los datos nullos de la tabla
SELECT 
    cur.Nombre,
    COUNT (axc.IdCurso) AS 'cant_inscripciones'
FROM Cursos AS cur
LEFT JOIN  Alumnos_X_Curso AS axc 
ON axc.IdCurso = cur.IdCurso
GROUP BY cur.Nombre
ORDER BY COUNT (axc.IdCurso) ASC


-- FUNCION SUM
-- Total Facturado
SELECT 
    SUM(c.Costo) AS 'RECAUDACION'
FROM Cursos AS c
INNER JOIN Alumnos_X_Curso AS axc 
ON axc.IdCurso = cur.IdCurso

-- Cursos realizados por cada alumno
SELECT 
    A.IdAlumno,
    A.IdApellido,
    axc.IdCurso
FROM Alumnos AS A 
LEFT JOIN Alumnos_X_Curso AS axc 
ON A.IdAlumno = axc.IdAlumno
ORDER BY APELLIDO ASC

-- Total Facturado agrupado por Alumno
SELECT 
    A.Apellido,
    SUM(c.Costo) AS 'TOTAL FACTURADO'
FROM Alumnos AS A 
LEFT JOIN Alumnos_X_Curso AS axc 
ON axc.IdCurso = cur.IdCurso
LEFT JOIN Cursos AS c
ON axc.IdCurso = c.IdCurso
GROUP BY A.IdAlumno, A.Apellido
--Reemplazamos los null impresos gracias a la funcion ISNULL:
SELECT 
    A.Apellido,
    ISNULL(SUM(C.Costo),0) AS 'TOTAL FACTURADO'
FROM Alumnos AS A 
LEFT JOIN Alumnos_X_Curso AS axc ON axc.IdCurso = cur.IdCurso
LEFT JOIN Cursos AS C ON axc.IdCurso = c.IdCurso
GROUP BY A.IdAlumno, A.Apellido


-- Funcion AVG
-- Calcular el costo promedio del valor de un curso.
SELECT 
    SUM(c.Costo) / COUNT(*) AS 'Costo Promedio'
FROM Cursos AS C

------ CON FUNCION AVG SERIA -------
SELECT 
    AVG(c.Costo) AS 'Costo Promedio' 
FROM Cursos AS c

-- calcular el promedio de notas del curso agrupada por  alumno 
SELECT 
    A.Apellido,
    A.Nombre,
AVG (axc.Nota_Final) AS 'Promedio de Notas'
FROM Alumnos AS A
INNER JOIN Alumnos_X_Curso AS axc 
ON A.IdAlumno = axc.IdAlumno
GROUP BY A.Apellido, A.Nombre

-- calcular el promedio de notas del curso agrupada por  alumno SIN contabilizar los aplazos
SELECT 
    A.Apellido,
    A.Nombre,
AVG (axc.Nota_Final) AS 'Promedio de Notas'
FROM Alumnos AS A
INNER JOIN Alumnos_X_Curso AS axc 
ON A.IdAlumno = axc.IdAlumno
WHERE axc.Nota_Final >= 7
GROUP BY A.Apellido, A.Nombre


--Clausula HAVING. Donde queremos obtener en este listado los alunmos donde su promedio supere los 7 puntos solamente, no es un filtro sobre las filas sino en el total del calculo, 
--para ello aplicamos un filtro del calculo del promedio de notas cuando se haya realizado:
--Quiere decir que con HAVING vamos a poder aplicar filtros al resultado que nos devuelven las funciones de resumen
SELECT 
    A.Apellido,
    A.Nombre,
AVG (axc.Nota_Final) AS 'Promedio de Notas'
FROM Alumnos AS A
INNER JOIN Alumnos_X_Curso AS axc 
ON A.IdAlumno = axc.IdAlumno
GROUP BY A.Apellido, A.Nombre
HAVING AVG(axc.Nota_Final) >=7


--- Funcion MIN y MAX -- nota: NULL no puede ser obtenido ni para Min ni para MAX
--MIN-- El importe mas barato de una tabla de cursos
SELECT
    MIN(Costo_columna) 
FROM Cursos
WHERE Costo_columna >0

--MAX-- Para cada alumnno obtener la nota maxima obtenida en algun final, 
SELECT 
    A.IdAlumno,
    A.Apellido,
    MAX(axc.Nota_Final) FROM Alumnos AS A 
INNER JOIN Alumnos_X_Curso AS axc 
ON axc.IdAlumno = A.IdAlumno 
GROUP BY A.IdAlumno, A.Apellido
