CREATE DATABASE zoologico;
GO
USE zoologico;
GO

CREATE TABLE continentes(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre varchar(150) NOT NULL UNIQUE
);

CREATE TABLE paises(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR (150) NOT NULL UNIQUE,
	idContinente INT NOT NULL,
	FOREIGN KEY (idContinente) REFERENCES continentes (id)
);


CREATE TABLE ciudades(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(150) NOT NULL,
	idPais INT NOT NULL,
	FOREIGN KEY(idPais) REFERENCES paises (id)
);

CREATE TABLE familiasEspecies(
	id INT PRIMARY KEY IDENTITY (1,1),
	nombre VARCHAR (150) NOT NULL UNIQUE
);

CREATE TABLE estatusConservacion(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR (150) NOT NULL UNIQUE,
	enPeligro CHAR (1) NOT NULL CHECK (enPeligro IN ('S', 'N'))
);



CREATE TABLE especies(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombreCientifico VARCHAR (150) NOT NULL UNIQUE, 
	nombreVulgar VARCHAR (150) NOT NULL,
	idFamilia INT NOT NULL,
	idEstatusConservacion INT NOT NULL,
	FOREIGN KEY (idFamilia) REFERENCES familiasEspecies (id),
	FOREIGN KEY (idEstatusConservacion) REFERENCES estatusConservacion (id)
);


CREATE TABLE zoologicos(
	id INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR (150) NOT NULL UNIQUE,
	aream2 DECIMAL (15,2) NOT NULL CHECK (aream2 > 0),
	presupuestoAnual DECIMAL (15,2) NOT NULL CHECK (presupuestoAnual >= 0),
	idCiudad INT NOT NULL,
	FOREIGN KEY (idCiudad) REFERENCES ciudades (id)
);

CREATE TABLE animales(
	id INT PRIMARY KEY IDENTITY (1,1),
	nombre VARCHAR (150) NOT NULL,
	sexo CHAR (1) NOT NULL CHECK (sexo IN ('M', 'H')),
	anoDeNacimiento INT NOT NULL CHECK (anoDeNacimiento > 1900),
	idEspecie INT NOT NULL,
	idPais INT NOT NULL,
	idZoologico INT NOT NULL,
	FOREIGN KEY (idZoologico) REFERENCES zoologicos (id),
	FOREIGN KEY (idEspecie) REFERENCES especies (id),
	FOREIGN KEY (idPais) REFERENCES paises (id)
);