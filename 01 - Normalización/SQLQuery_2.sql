CREATE DATABASE TIENDALIBROS;

USE TIENDALIBROS;

CREATE TABLE LIBROS(
    ID_LIBRO INT NOT NULL PRIMARY KEY,
    TITULO VARCHAR(30) NOT NULL,
    AÑO_PUBLICACION DATE NOT NULL
);

CREATE TABLE GENEROS(
    ID_GENERO INT NOT NULL PRIMARY KEY,
    NOMBRE_G VARCHAR(30) NOT NULL
);

CREATE TABLE LIBROS_GENERO(
    ID_LIBRO INT NOT NULL,
    ID_GENERO INT NOT NULL,
    FOREIGN KEY (ID_LIBRO) REFERENCES LIBROS (ID_LIBRO),
    FOREIGN KEY (ID_GENERO) REFERENCES GENEROS(ID_GENERO)
);

CREATE TABLE PAISES (
    ID_PAIS INT NOT NULL PRIMARY KEY,
    NOMBRE_P VARCHAR(30) NULL
);

CREATE TABLE AUTORES (
    ID_AUTOR INT NOT NULL PRIMARY KEY,
    NOMBRE_A VARCHAR(30) NULL,
    ID_PAIS INT NOT NULL,
    FOREIGN KEY (ID_PAIS) REFERENCES PAISES (ID_PAIS)
);

CREATE TABLE LIBROS_X_AUTORES (
    ID_AUTOR INT NOT NULL,
    ID_LIBRO INT NOT NULL,
    FOREIGN KEY (ID_AUTOR) REFERENCES AUTORES (ID_AUTOR),
    FOREIGN KEY (ID_LIBRO) REFERENCES LIBROS (ID_LIBRO)
);

CREATE TABLE CLIENTES (
    ID_CLIENTE INT NOT NULL PRIMARY KEY,
    NOMBRE_C VARCHAR(30) NOT NULL,
    DNI INT NOT NULL UNIQUE,
    CORREO_ELECTRONICO VARCHAR(40) NOT NULL,
);

CREATE TABLE COMPRAS (
    ID_COMPRA INT NOT NULL PRIMARY KEY,
    ID_CLIENTE INT NOT NULL,
    ID_LIBRO INT NOT NULL,
    FECHA_ADQUISICION DATE NOT NULL,
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE),
    FOREIGN KEY (ID_LIBRO) REFERENCES LIBROS (ID_LIBRO)
);

CREATE TABLE PUNTAJES (
    ID_PUNTAJE INT NOT NULL PRIMARY KEY,
    PUNTAJE INT NOT NULL,
    ID_COMPRA INT NOT NULL,
    FOREIGN KEY (ID_COMPRA) REFERENCES COMPRAS (ID_COMPRA) 
);

DROP TABLE PAISES;

ALTER TABLE AUTORES
ADD COLUMN NOMBRE_PAIS VARCHAR(30) NULL;

ALTER TABLE AUTORES
ADD NOMBRE_PAIS VARCHAR(30) NULL;

ALTER TABLE AUTORES
DROP CONSTRAINT ID_PAIS; 

SELECT 
    CONSTRAINT_NAME 
FROM 
    INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS 
WHERE 
    CONSTRAINT_SCHEMA = 'dbo'
    AND CONSTRAINT_NAME IN (
        SELECT CONSTRAINT_NAME 
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
        WHERE TABLE_NAME = 'AUTORES' AND COLUMN_NAME = 'ID_PAIS'
    );


ALTER TABLE AUTORES
DROP CONSTRAINT FK__AUTORES__ID_PAIS__403A8C7D;

DROP TABLE PAISES;

EXEC sp_rename 'LIBROS.AÑO_PUBLICACION', 'ANO_PUBLICACION', 'COLUMN';
