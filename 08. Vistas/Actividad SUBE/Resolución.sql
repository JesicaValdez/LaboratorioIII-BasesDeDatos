--A) Realizar una función llamada TotalDebitosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo débito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.

--B) Realizar una función llamada TotalCreditosxTarjeta que reciba un ID de Tarjeta y registre el total
--acumulado en pesos de movimientos de tipo crédito que registró esa tarjeta. La función no debe
--contemplar el estado de la tarjeta para realizar el cálculo.

--C) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.
CREATE VIEW VW__USUARIOS_TARJETAS AS
SELECT 
    U.APELLIDO,
    U.NOMBRE,
    T.IDTARJETA,
    T.ESTADO,
    T.SALDO
FROM USUARIOS AS U
INNER JOIN TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO

--D) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. La misma
--debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje,
--número de interno y nombre de la línea.
GO
CREATE VIEW VW__USUARIOS_VIAJES AS
SELECT 
    U.APELLIDO,
    U.NOMBRE,
    T.IDTARJETA AS NRO_TARJETA_SUBE,
    V.FECHA,
    V.IMPORTE,
    V.NRO_INTERNO,
    L.NOMBRE AS NOMBRE_LINEA
FROM USUARIOS AS U
INNER JOIN TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO
INNER JOIN VIAJES AS V ON T.IDTARJETA = V.IDTARJETA
INNER JOIN LINEAS AS L ON V.IDLINEA = L.IDLINEA

--E) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. La misma debe
--contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de
--dinero acreditado (históricamente), cantidad de recargas, importe de recarga promedio (en pesos) y
--estado de la tarjeta
GO
CREATE VIEW VW_ESTADISTICA_TARJETAS AS
SELECT 
    U.APELLIDO,
    U.NOMBRE,
    T.IDTARJETA AS NRO_TARJETA_SUBE,
    COUNT(V.IDVIAJE) AS CANT_VIAJES_REALIZADOS,
    SUM(CASE WHEN M.TIPO = 'C' THEN M.TIPO ELSE 0 END) AS TOTAL_ACREDITADO,
    COUNT(CASE WHEN M.TIPO = 'C' THEN 1 ELSE NULL END) AS CANT_RECARGAS,
    AVG(CASE WHEN M.TIPO = 'C' THEN M.IMPORTE ELSE NULL END) AS IMPORTE_PROMEDIO_RECARGA,
    T.ESTADO AS ESTADO_TARJETA
FROM 
    USUARIOS AS U
INNER JOIN 
    TARJETAS AS T ON U.IDUSUARIO = T.IDUSUARIO
LEFT JOIN 
    VIAJES AS V ON T.IDTARJETA = V.IDTARJETA
LEFT JOIN 
    MOVIMIENTOS AS M ON T.IDTARJETA = M.IDTARJETA
GROUP BY 
    U.APELLIDO, U.NOMBRE, T.IDTARJETA, T.ESTADO