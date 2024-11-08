-- EJERCICIO 1
CREATE DATABASE ProyectosDeInvestigacion

CREATE TABLE Departamento (
	CodigoDpto tinyint Identity(1,1) not null,
	NombreDpto varchar not null,
	Telefono varchar null,
	Director varchar null
	CONSTRAINT PK_CodigoDpto PRIMARY KEY (CodigoDpto),
	CONSTRAINT CK_CodigoDpto CHECK (CodigoDpto <= 70),
	CONSTRAINT UK_NombreDpto UNIQUE (NombreDpto),
	CONSTRAINT CK_Telefono CHECK (Telefono LIKE '[0-9]{9}'),
	CONSTRAINT CK_Director CHECK (Director LIKE '[0-9]{8}[A-Z]')
)

-- EJERCICIO 2

CREATE TABLE Sedes (
	CodigoSede smallint Identity(1,1) not null,
	NombreSede varchar not null,
	Campus varchar null
	CONSTRAINT PK_CodigoSede PRIMARY KEY (CodigoSede),
	CONSTRAINT CK_CodigoSede CHECK (CodigoSede <= 70),
	CONSTRAINT UK_NombreSede UNIQUE (NombreSede),
)

exec sp_help 'Sedes'

-- EJERCICIO 3

CREATE TYPE TipoDNI
FROM char(9) not null 

CREATE TABLE Grupos (
	CodigoGrupo tinyint Identity(1,1) not null,
	NombreGrupo varchar not null,
	CodigoDpto tinyint null,
	AreaConocimiento varchar null,
	Lider TipoDNI null
	CONSTRAINT PK_CodigoGrupo PRIMARY KEY (CodigoGrupo),
	CONSTRAINT CK_Lider CHECK (Lider LIKE '[0-9]{8}[A-Z]'),
	CONSTRAINT FK_CodigoDpto FOREIGN KEY (CodigoDpto) REFERENCES Departamento(CodigoDpto)
)