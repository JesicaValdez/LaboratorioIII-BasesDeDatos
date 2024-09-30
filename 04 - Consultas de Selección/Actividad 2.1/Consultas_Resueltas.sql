-- 1. Todos los clientes indicando Apellido, Nombre y Correo Electrónico.
SELECT 
    Apellido, 
    Nombre, 
    CorreoElectronico 
FROM Clientes

-- 2. Todos los clientes indicando Apellido y Nombre con el formato: [Apellido], [Nombre] (ordenados por Apellido en forma descendente). Por ejemplo: Martinez, Sofía.
SELECT 
    Concat(Apellido, ', ', Nombre) AS NombreCompleto 
FROM Clientes 
ORDER BY Apellido DESC 

-- 3. Los clientes cuya ciudad contenga la palabra ‘Jujuy’ (indicando Nombre, Apellido y Ciudad)
SELECT 
    Nombre,
    Apellido,
    Ciudad 
FROM Clientes 
WHERE Ciudad LIKE '%Jujuy%'

-- 4 Los clientes que no tengan registrado su correo electrónico (indicando IdCliente, Apellido y Nombre). Ordenar por Apellido en forma descendente y por Nombre en forma ascendente.
SELECT 
    IdCliente, 
    Apellido, 
    Nombre
FROM Clientes
WHERE CorreoElectronico IS NULL
ORDER BY Apellido DESC, Nombre ASC

-- 5 El último cliente del listado en orden alfabético (ordenado por Apellido y luego por Nombre). Indicar IdCliente, Apellido y Nombre
SELECT TOP 1 
    IdCliente, 
    Apellido, 
    Nombre
FROM Clientes
ORDER BY Apellido DESC, Nombre DESC

-- 6 Los clientes cuyo año de alta haya sido 2019 (Indicar Nombre, Apellido y Fecha de alta).
SELECT 
    Nombre, 
    Apellido, 
    FechaAlta 
FROM Clientes 
WHERE YEAR(FechaAlta) = 2019

-- 7 Todos los clientes indicando Apellido, Nombre y Datos de Contacto. La última columna debe contener el mail si el cliente tiene mail, de lo contrario el Celular, sino el Teléfono y en caso de no tener ninguno debe indicar 'Incontactable'.
SELECT 
    Apellido,
    Nombre,
    CASE 
        WHEN CorreoElectronico IS NOT NULL THEN CorreoElectronico
        WHEN Celular IS NOT NULL THEN Celular
        WHEN Telefono IS NOT NULL THEN Telefono
    ELSE 'Inconcatenable'
END AS DatosContacto
From Clientes 

-- 8 Todos los clientes, indicando el semestre en el cual se produjo su alta. Indicar Nombre, Apellido, Fecha de Alta y la frase “Primer Semestre” o “Segundo Semestre” según corresponda.
SELECT 
    Nombre,
    Apellido,
    FechaAlta,
    CASE 
        WHEN MONTH(FechaAlta) BETWEEN 1 AND 6 THEN 'Primer Semestre'
    ELSE 'Segundo Semestre'
END AS Semestre
From Clientes 

-- 9 Los clientes que tengan registrado teléfono pero no celular. Indicar IdCliente, Apellido y Nombre. Ordenar en forma descendente por fecha de alta
SELECT 
    IdCliente,
    Apellido,
    Nombre
FROM Clientes
WHERE Telefono IS NOT NULL AND Celular IS NULL
ORDER BY FechaAlta DESC;

-- 10 Todas las ciudades donde residen los clientes. NOTA: no se pueden repetir
SELECT DISTINCT 
    Ciudad 
From Clientes

-- 11 Todos los pedidos cuyo Estado no sea Rechazado. Indicar IdPedido, IdCliente, Fecha y Monto Total. Ordenar los resultados por fecha de pedido (del más reciente al más antigüo).
SELECT 
    IdPedido,
    IdCliente,
    FechaPedido,
    MontoTotal
From Pedidos
WHERE Estado != 'Rechazado'
ORDER BY FechaPedido DESC

-- 12 Todos los pedidos cuyo Estado sea “Pagado” o “En preparación” y su monto esté entre $500 y $1250 (ambos inclusive). Indicar el valor de todas las columnas.
SELECT 
    IdPedido,
    IdCliente,
    FechaPedido,
    MontoTotal,
    Estado
FROM Pedidos
WHERE (Estado = 'Pagado' OR Estado = 'En Preparacion')
    AND MontoTotal BETWEEN 500 AND 1250

-- 13 Listar los meses del año en los que se registraron pedidos en los años 2018 y 2019. NOTA: no indicar más de una vez el mismo mes.
Select DISTINCT 
    MONTH(FechaPedido) AS Mes,
    YEAR(FechaPedido) AS Año
FROM Pedidos 
WHERE YEAR(FechaPedido) = 2018 OR YEAR(FechaPedido) = 2019
ORDER BY Año ASC, Mes ASC

-- 14 Indicar los distintos ID de clientes que realizaron pedidos por un monto total mayor a $1000 y cuyo estado no sea Rechazado.
SELECT DISTINCT 
    IdCliente 
From Pedidos
WHERE MontoTotal > 1000 
    AND Estado != 'Rechazado'

-- 15 Listar todos los datos de los pedidos realizados por los clientes con ID 1, 8, 16, 24, 32 y 48. Los registros deben estar ordenados por IdCliente y Estado.
SELECT 
    IdPedido, 
    IdCliente, 
    FechaPedido, 
    Estado, 
    MontoTotal 
FROM Pedidos
WHERE IdCliente IN (1, 8, 16, 24, 32, 48)
ORDER BY IdCliente, Estado

-- 16 Listar todos los datos de los tres pedidos de más bajo monto que se encuentren en estado Pagado.
SELECT TOP 3 
    IdPedido, 
    IdCliente, 
    FechaPedido, 
    Estado, 
    MontoTotal 
FROM Pedidos
WHERE Estado = 'Pagado'
ORDER BY MontoTotal ASC

-- 17 Listar los pedidos que tengan estado Rechazado y un monto total menor a $500 o bien tengan estado En preparación y un monto total que supere los $1000. Indicar todas las columnas excepto Id de Cliente y Fecha del pedido. Ordenar por Id de pedido.
Select 
    IdPedido,
    Estado, 
    MontoTotal 
FROM Pedidos
WHERE (Estado = 'Rechazado' AND MontoTotal < 500) 
    OR (Estado = 'En Preparacion' AND MontoTotal > 1000)
ORDER BY IdPedido

-- 18 Listar los pedidos realizados en el año 2023 indicando todas las columnas y además una llamada “DiaSemana” que devuelva a qué día de la semana (1-7) corresponde la fecha del pedido. Ordenar los registros por la columna que contiene el día de la semana. DESAFÍO: crear otra columna llamada DiaSemanaEnLetras que contenga el día de la semana pero en letras (suponiendo que la semana comienza en 1-DOMINGO). Por ejemplo si la fecha del pedido es 20/07/2023, la columna DiaSemana debe contener 5 y la columna DiaSemanaEnLetras debe contener JUEVES.
Select 
    IdPedido,
    IdCliente,
    FechaPedido,
    Estado, 
    MontoTotal, 
    DATEPART(WEEKDAY, FechaPedido) AS DiaSemana,
    CASE DATEPART(WEEKDAY, FechaPedido)
        WHEN 1 THEN 'DOMINGO'
        WHEN 2 THEN 'LUNES'
        WHEN 3 THEN 'MARTES'
        WHEN 4 THEN 'MIERCOLES'
        WHEN 5 THEN 'JUEVES'
        WHEN 6 THEN 'VIERNES'
        WHEN 7 THEN 'SABADO'
    END AS DiaSemanaEnLetras
FROM Pedidos
WHERE YEAR(FechaPedido) = 2023
ORDER BY DiaSemana

-- 19 Listar los pedidos en estado Pendiente y cuyo mes de realización coincida con el mes actual (sin importar el año). NOTA: obtener el mes actual mediante una función, no forzar el valor.
Select 
    IdPedido,
    IdCliente,
    FechaPedido,
    Estado, 
    MontoTotal 
FROM Pedidos
WHERE Estado = 'Pendiente' AND MONTH(FechaPedido) = MONTH(GETDATE())

-- 20 La empresa que distribuye los pedidos desea otorgar una bonificación sobre el monto total en aquellos pedidos que estén en estado Pendiente o En preparación. Si el pedido fue realizado entre los años 2017 y 2019 la bonificación será del 50%. Si el pedido se realizó en los años 2020 o 2021, la bonificación será del 30%. Para los pedidos efectuados entre los años 2022 y 2023, la bonificación es del 10%. Calcular, dependiendo del estado de cada pedido y el año en que se realizó, el valor del monto total una vez efectuada la bonificación, informándolo en una columna llamada MontoTotalBonificado. Listar además todos las columnas de Pedidos, ordenadas por la fecha del pedido. No tener en cuenta los pedidos que no estén en los estados mencionados
Select 
    IdPedido,
    IdCliente,
    FechaPedido,
    Estado, 
    MontoTotal,
    CASE 
        WHEN YEAR(FechaPedido) BETWEEN 2017 AND 2019 THEN MontoTotal * 0.5
        WHEN YEAR(FechaPedido) BETWEEN 2020 AND 2021 THEN MontoTotal * 0.7
        WHEN YEAR(FechaPedido) BETWEEN 2022 AND 2023 THEN MontoTotal * 0.9
        ELSE MontoTotal
    END AS MontoTotalBonificado
FROM Pedidos
WHERE Estado = 'Pendiente' OR Estado = 'En Preparacion'
ORDER BY FechaPedido ASC

-- 21 Listar los pedidos que no hayan sido realizados por los clientes con ID 2, 9, 17, 25, 33 y 47. Indicar Id de cliente, Id de pedido, fecha de pedido, estado y monto total. Ordenar por Id de cliente.
Select 
    IdCliente,
    IdPedido,
    FechaPedido,
    Estado, 
    MontoTotal
FROM Pedidos
WHERE IdCliente NOT IN (2, 9, 17, 25, 33, 47)
ORDER BY IdCliente ASC

-- 22 Listar todos los datos de los clientes cuyos apellidos comienzan con O, no poseen correo electrónico y su año de alta es 2017. Hacer la misma consulta para los clientes con apellido que comienza con P y año de alta 2019 que no poseen teléfono ni celular. Ordenar los registros por fecha de alta.
Select 
    IdCliente,
    Nombre,
    Apellido,
    CorreoElectronico,
    Telefono,
    Celular,
    Ciudad,
    FechaAlta
FROM Clientes
WHERE (YEAR(FechaAlta) = 2017 AND Apellido LIKE 'O%' AND CorreoElectronico IS NULL)
    OR(YEAR(FechaAlta) = 2019 AND Apellido LIKE 'P%' AND Telefono IS NULL AND Celular IS NULL)
ORDER BY FechaAlta ASC

-- 23 Listar todos los datos del pedido que haya registrado el mayor monto total. En caso de empate se deben listar todos los pedidos con igual monto.
Select 
    IdPedido,
    IdCliente,
    FechaPedido,
    Estado,
    MontoTotal
FROM Pedidos
WHERE MontoTotal = (SELECT MAX(MontoTotal) FROM Pedidos)