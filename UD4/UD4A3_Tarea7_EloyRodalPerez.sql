--ELOY RODAL P�REZ // TAREA 7

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'BDFOTOGRAFIA')
DROP DATABASE BDFOTOGRAFIA ;
go

CREATE DATABASE BDFOTOGRAFIA

--CREACI�N DE GRUPOS DE ARCHIVOS DE LA BASE DE DATOS
ON PRIMARY
(
		NAME= 'ArchivoPrincipal',
		FILENAME='C:\ArquivosBD\BDFotografia\ArchivoPrincipal.mdf',
		SIZE = 15MB,
		FILEGROWTH = 0
		),
		FILEGROUP Datos_Fotograf�a DEFAULT (
		NAME= 'datosFotos1',
		FILENAME='C:\ArquivosBD\BDFotografia\datosFotos1',
		SIZE = 10MB,
		MAXSIZE = 50MB,
		FILEGROWTH = 10%
	), (
		NAME='datosFotos2',
		FILENAME='C:\ArquivosBD\BDFotografia\datosFotos2.ndf',
		SIZE = 10MB,
		MAXSIZE = 50MB,
		FILEGROWTH = 10%
	)
go

--CREACI�N DE TIPO DE DATOS //FECHA//
use BDFOTOGRAFIA
IF EXISTS (SELECT * FROM sys.types WHERE name = 'Fecha')
	DROP TYPE Fecha
go
CREATE TYPE Fecha FROM datetime NULL
go

--COMPROBACI�N CREACI�N DB
SELECT * FROM sys.databases
EXEC sp_helpdb 'BDFOTOGRAFIA'

--COMPROBACI�N ARCHIVOS
exec sp_helpfile

--COMPROBACI�N GRUPOS DE ARCHIVOS
select * from sys.filegroups
exec sp_helpfilegroup


--CREACI�N DE TABLA //EXPOSICIONES//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EXPOSICIONES')
	DROP TABLE EXPOSICIONES
go
CREATE TABLE EXPOSICIONES (
	CodExpo smallint identity(1,5) NOT NULL,
	NombreExpo varchar(40) NOT NULL,
	Descripci�nExpo varchar(70) NOT NULL,
	Tem�ticaExpo varchar(25) NOT NULL CONSTRAINT DF_Tematica_EXPO DEFAULT 'Fiestas',

	CONSTRAINT PK_EXPOSICIONES PRIMARY KEY (CodExpo),
	CONSTRAINT UK_NombreExpo_EXPOSICIONES UNIQUE (NombreExpo),
	CONSTRAINT CK_Tematica_Especifica CHECK (Tem�ticaExpo IN ('Naturaleza', 'Gentes', 'Fiestas', 'Tradiciones', 'Espacios', 'Edificios', 'Deportes'))
	
)
ON Datos_Fotograf�a
go
exec sp_help 'EXPOSICIONES'

--CREACI�N DE TABLA //SALAS//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SALAS')
	DROP TABLE SALAS
go
CREATE TABLE SALAS (
	NumSala smallint NOT NULL,
	SuperficieSala float NOT NULL 
                    CONSTRAINT CK_SuperficieSala 
                        CHECK (SuperficieSala >= 20 AND SuperficieSala <= 1000) DEFAULT 100,
	CONSTRAINT PK_SALAS PRIMARY KEY (NumSala),
)
ON Datos_Fotograf�a
go
exec sp_help 'SALAS'


--CREACI�N DE TABLA //EXPOSICIONESSALAS//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EXPOSICIONESSALAS')
	DROP TABLE EXPOSICIONESSALAS
go
CREATE TABLE EXPOSICIONESSALAS (
	CodExpo smallint identity(1,5) NOT NULL,
	NumSala smallint NOT NULL,
	FechaInicioExpo Fecha NOT NULL CONSTRAINT DF_FechaInicioExpo DEFAULT getDate(),
								   CONSTRAINT CK_DuracionExpoMinima CHECK (DATEDIFF(DAY, FechaInicioExpo, GETDATE()) > 20),
	FechaFinExpo Fecha NOT NULL CONSTRAINT DF_FechaFinExpo_EXPOSICIONESSALAS
									 DEFAULT dateAdd(day, -2, getDate()),
	
	
	CONSTRAINT PK_EXPOSICIONESSALAS PRIMARY KEY (CodExpo, NumSala),
	CONSTRAINT FK_CodExpo_EXPOSICIONES FOREIGN KEY (CodExpo) REFERENCES EXPOSICIONES(CodExpo) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_NumSala_SALAS FOREIGN KEY (NumSala) REFERENCES SALAS(NumSala) ON DELETE NO ACTION ON UPDATE NO ACTION,
	
)
ON Datos_Fotograf�a
go
exec sp_help 'EXPOSICIONESSALAS'


--CREACI�N DE TABLA  //CENTRO//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CENTRO')
	DROP TABLE CENTRO
go
CREATE TABLE CENTRO (
	CodCentro smallint identity (1,5) NOT NULL,
	NombreCentro varchar(40) NOT NULL,
	WebCentro varchar(70) NULL,
	TelefonoCentro char(9) NOT NULL,
	SuperficieCentro float NOT NULL,
	FechaInauguracionCentro Fecha NOT NULL CONSTRAINT DF_FechaInauguracionCentro_CENTRO
											DEFAULT dateAdd(year, -2, getDate()),
	DireccionCentro varchar(70) NOT NULL
	
	CONSTRAINT PK_CENTRO PRIMARY KEY (CodCentro),
	CONSTRAINT UK_NombreCentro_CENTRO UNIQUE (NombreCentro),
	CONSTRAINT CK_TelefonoCentro_Forma CHECK (TelefonoCentro LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CK_CodCentro_Forma CHECK (CodCentro LIKE '[A-Z][-][0-9][0-9][0-9]')
	--FK M�S ABAJO
)
on Datos_Fotograf�a
go
exec sp_help 'CENTRO'

--CREACI�N DE TABLA //LOCALIDAD//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'LOCALIDAD')
	DROP TABLE LOCALIDAD
go
CREATE TABLE LOCALIDAD(
	CodLocalidad smallint identity (1,1) NOT NULL,
	NombreLocalidad varchar(40) NOT NULL,
	WebLocalidad varchar(70) NULL,
	NumHabitantesLocalidad smallint NOT NULL CONSTRAINT CK_NumHabitantesLocalidad 
										  CHECK (NumHabitantesLocalidad >= 1000) DEFAULT 5000
	CONSTRAINT PK_LOCALIDAD PRIMARY KEY (CodLocalidad)
)
on Datos_Fotograf�a
go
exec sp_help 'LOCALIDAD'

--CREACI�N DE TABLA //PROVINCIA//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PROVINCIA')
	DROP TABLE PROVINCIA
go
CREATE TABLE PROVINCIA(
	CodProvincia smallint identity (1,1) NOT NULL,
	NombreProvincia varchar(40) NOT NULL
	
	CONSTRAINT PK_PROVINCIA PRIMARY KEY (CodProvincia),
	CONSTRAINT UK_NombreProvincia_PROVINCIA UNIQUE(NombreProvincia)
)
on Datos_Fotograf�a
go
exec sp_help 'PROVINCIA'

--CREACI�N DE TABLA //FOTOGRAFIA//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FOTOGRAFIA')
	DROP TABLE FOTOGRAFIA
go
CREATE TABLE FOTOGRAFIA(
	CodFotografia smallint NOT NULL,
	ColorFotografia char(1) NOT NULL,
	FechaRealizacionFotografia Fecha NOT NULL,
	NombreFotografia varchar(30) NOT NULL,
	MedidasFotografia varchar(15) NOT NULL,
	CodFot�grafo smallint identity (1,1) NOT NULL
	 
	CONSTRAINT PK_FOTOGRAFIA PRIMARY KEY (CodFotografia)
)
ON Datos_Fotograf�a
go

--CREACI�N DE TABLA //EXPOSICIONESFOTOGRAFIA//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EXPOSICIONESFOTOGRAFIA')
	DROP TABLE EXPOSICIONESFOTOGRAFIA
go
CREATE TABLE EXPOSICIONESFOTOGRAFIA(
	CodExpo smallint identity(1,5) NOT NULL,
	CodFotografia smallint NOT NULL
	
	CONSTRAINT PK_EXPOSICIONESSALAS PRIMARY KEY (CodExpo, CodFotografia),
	CONSTRAINT FK_CodExpo_EXPOSICIONES FOREIGN KEY (CodExpo) REFERENCES EXPOSICIONES(CodExpo) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT FK_CodFotografia_FOTOGRAFIA FOREIGN KEY (CodFotografia) REFERENCES FOTOGRAFIA(CodFotografia)
)
ON Datos_Fotograf�a
go
exec sp_help 'EXPOSICIONESFOTOGRAFIA'

--CREACI�N DE TABLA //ARTISTICA//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ARTISTICA')
	DROP TABLE ARTISTICA
go
CREATE TABLE ARTISTICA(
	CodFotografia smallint NOT NULL,
	EncuadreFotoArtistica varchar(25) NOT NULL CONSTRAINT DF_Tematica_EXPO DEFAULT 'Vertical',
	ComposicionFotoArtistica varchar(50) NOT NULL
	
	CONSTRAINT PK_ARTISTICA PRIMARY KEY (CodFotografia),
	CONSTRAINT FK_CodFotografia_FOTOGRAFIA FOREIGN KEY (CodFotografia) REFERENCES FOTOGRAFIA(CodFotografia) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT CK_Encuadre_Especifico CHECK (EncuadreFotoArtistica IN ('Horizontal', 'Vertical', 'Inclinado'))
)
ON Datos_Fotograf�a
go
exec sp_help 'ARTISTICA'

--CREACI�N DE TABLA //DOCUMENTAL//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'DOCUMENTAL')
	DROP TABLE DOCUMENTAL
go
CREATE TABLE DOCUMENTAL(
	CodFotografia smallint NOT NULL,
	TipoFotoDocumental varchar(25) NOT NULL
	
	CONSTRAINT PK_DOCUMENTAL PRIMARY KEY (CodFotografia),
	CONSTRAINT FK_CodFotografia_FOTOGRAFIA FOREIGN KEY (CodFotografia) REFERENCES FOTOGRAFIA(CodFotografia)ON DELETE CASCADE ON UPDATE CASCADE
)
ON Datos_Fotograf�a
go
exec sp_help 'DOCUMENTAL'

--CREACI�N DE TABLA //FOT�GRAFO//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FOT�GRAFO')
	DROP TABLE FOT�GRAFO
go
CREATE TABLE FOT�GRAFO(
	CodFot�grafo smallint identity (1,1) NOT NULL, --asumiendo que empieza en 1 y va de 1 en 1 
	NombreFot�grafo varchar(30) NOT NULL,
	Apellido1Fot�grafo varchar(30) NOT NULL,
	Apellido2Fot�grafo varchar(30) NULL,
	FechaNacimientoFot�grafo Fecha NOT NULL,
	NacionalidadFot�grafo varchar(25) NOT NULL,
	InfluencerDeFot�grafo smallint NOT NULL
		
	CONSTRAINT PK_FOT�GRAFO PRIMARY KEY (CodFot�grafo),
	CONSTRAINT FK_InfluencerDeFot�grafo_FOT�GRAFO FOREIGN KEY (InfluencerDeFot�grafo) REFERENCES FOT�GRAFO(CodFot�grafo),--RECURSIVIDAD DE LA RELACI�N.
	
)
ON Datos_Fotograf�a
go
exec sp_help 'FOTOGRAFO'

--CREACI�N DE TABLA //PREMIOSFOT�GRAFO//
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PREMIOSFOT�GRAFO')
	DROP TABLE PREMIOSFOT�GRAFO
go
CREATE TABLE PREMIOSFOT�GRAFO(
	CodFot�grafo smallint identity (1,1) NOT NULL,
	PremiosFot�grafo tinyint NOT NULL
	
	CONSTRAINT PK_PREMIOSFOT�GRAFO PRIMARY KEY (CodFot�grafo, PremiosFot�grafo),
	CONSTRAINT FK_CodFot�grafoFOT�GRAFO FOREIGN KEY (CodFot�grafo) REFERENCES FOT�GRAFO(CodFot�grafo)ON DELETE CASCADE ON UPDATE CASCADE
)
ON Datos_Fotograf�a
go
exec sp_help 'PREMIOSFOT�GRAFO'
	
--CREACI�N DE //CLAVES FOR�NEAS// Y //ALTERACIONES DE INTEGRIDAD REFERENCIAL//
ALTER TABLE EXPOSICIONESSALAS
	ADD CONSTRAINT FK_CodCentroSALA_CENTRO FOREIGN KEY (NumSala, CodCentro) 
	REFERENCES SALAS(NumSala, CodCentro) ON DELETE NO ACTION ON UPDATE NO ACTION		--MEDIANTE ESTOS ALTER ESTAR�AMOS A�ADIENDO TANTO LA CLAVE FOR�NEA COMO LA CONDICI�N DE INTEGRIDAD REFERENCIAL PEDIDA.
go
ALTER TABLE CENTRO
	ADD CONSTRAINT FK_CodLocalidad_LOCALIDAD FOREIGN KEY (CodLocalidad)
	REFERENCES LOCALIDAD(CodLocalidad) ON DELETE NO ACTION ON UPDATE CASCADE		--LAS CONSTRAINTS DE ESTAS TRES SE DEBEN AL MANTENIMIENTO DE LA INTEGRIDAD REFERENCIAL AL BORRAR O MODIFICAR UNA PROVINCIA O LOCALIDAD.
go
ALTER TABLE LOCALIDAD
	ADD CONSTRAINT FK_CodProvincia_PROVINCIA FOREIGN KEY (CodProvincia)
	REFERENCES PROVINCIA(CodProvincia) ON DELETE CASCADE ON UPDATE CASCADE
go
ALTER TABLE FOTOGRAFIA
	ADD CONSTRAINT FK_CodFot�grafo_FOT�GRAFO FOREIGN KEY (CodFot�grafo)
	REFERENCES FOT�GRAFO(CodFot�grafo) ON DELETE CASCADE ON UPDATE CASCADE
go

ALTER TABLE SALAS
	ADD CONSTRAINT FK_CodCentro FOREIGN KEY (CodCentro)
	REFERENCES CENTRO(CodCentro) ON DELETE NO ACTION ON UPDATE NO ACTION
--MODIFICACIONES DE LA BD.

--A.
/* A�ade una columna a la tabla centro de exposici�n para almacenar el c�digo postal formado por 5 d�gitos sin ser obligatorio introducirlo. 
Por defecto toma el valor 36005 y todos los registros que ya existan en la tabla tomar�n este valor. */

ALTER TABLE CENTRO
  ADD codPostal char(5) null,
  CONSTRAINT DF_codPostal_CENTRO
  DEFAULT '36005' FOR CodigoPostal WITH VALUES,
  CONSTRAINT CK_CPCENTRO CHECK (codPostal LIKE '[0-9][0-9][0-9][0-9][0-9]'
 go
  


--B.
/* Se ha cambiado el tiempo m�nimo que una exposici�n est� en una sala, pasando de 20 a 25 d�as. 
Haz que se cumpla esta nueva restricci�n y los registros que ya existan en la tabla no tiene que validar esta nueva restricci�n. */

USE BDFOTOGRAFIA
go
EXEC sp_help 'EXPOSICIONESSALAS'
go
ALTER TABLE EXPOSICIONESSALA
DROP CONSTRAINT DF_FechaFinExpo_EXPOSICIONESSALAS

--C

ALTER TABLE EXPOSICIONESSALAS
ADD EntradasVendidas smallint NULL,
	Precio tinyint NULL
	CONSTRAINT DF_PRECIOEXPSALA DEFAULT 5
	CONSTRAINT CK_PRECIOEXPSALA CHECK(Precio<=20),
	Recaudacion as EntradasVendidas * precio
go

--D

ALTER DATABASE BDFOTOGRAFIA
ADD FILEGROUP Datos_Estudios
go

GO
ALTER DATABASE BDFOTOGRAFIA
ADD FILE (NAME = datosestudios1,
	FILENAME = 'C:\ArquivosBD\BDFotografia\datosEstudios1.ndf',
	SIZE = 15MB,
	MAXSIZE =UNLIMITED,
	FILEGROWTH = 10),
	(NAME = datosestudios2,
	FILENAME = 'C:\ArquivosBD\BDFotografia\datosEstudios2.ndf',
	SIZE = 15MB,
	MAXSIZE =UNLIMITED,
	FILEGROWTH = 10),
	(NAME = datosestudios3,
	FILENAME = 'C:\ArquivosBD\BDFotografia\datosEstudios3.ndf',
	SIZE = 15MB,
	MAXSIZE =UNLIMITED,
	FILEGROWTH = 10)
	TO FILEGROUP Datos_Estudios
GO

ALTER DATABASE BDFOTOGRAFIA
MODIFY FILEGROUP Datos_Estudios DEFAULT
go

SELECT * FROM sys.databases
EXEC sp_helpdb 'BDFOTOGRAFIA'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ESTUDIO')
	DROP TABLE ESTUDIO
go

CREATE TABLE ESTUDIO
(Codigo CHAR(6) not null,
CIF varchar (10) not null,
Nombre varchar(40) not null,
Telefono1 char(9) not null,
Telefono2 char(9) not null,
localidad smallint not null,
CONSTRAINT PK_Estudio_codigo PRIMARY KEY(Codigo),
CONSTRAINT U_Estudio_cif UNIQUE(CIF),
CONSTRAINT CK_Estudio_Codigo CHECK
(Codigo LIKE('EST[13579][13579][13579')),
CONSTRAINT CK_Estudio_Telefono1 CHECK  (Telefono1
LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
CONSTRAINT CK_Estudio_Telefono2 CHECK
(Telefono2 LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
)
go

--TABLA ESTUDIO
--TABLA LABORATORIO


USE BDFOTOGRAFIA
GO
ALTER TABLE LOCALIDAD
ALTER COLUMN web varchar(100) NULL
go
ALTER TABLE CENTRO
ALTER COLUMN web varchar(100) NULL
