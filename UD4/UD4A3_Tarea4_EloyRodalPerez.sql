/* Eloy Rodal Pérez */
-- EJ1
--1.
use ProyectosdeInvestigacion

ALTER TABLE Proyectos
	DROP CONSTRAINT DF_GUID;
go
exec sp_help 'Proyectos'
go
ALTER TABLE Proyectos
	DROP COLUMN GuidProyecto
go
exec sp_help 'Proyectos'
go
--b
ALTER TABLE Programas
	ADD FechaFin datetime NOT NULL CONSTRAINT DF_FechaFinProgramas DEFAULT getDate();
go
--c
exec sp_help 'Profesores'
go

ALTER TABLE Profesores
	NOCHECK CONSTRAINT CK_AñoFechaFinInvest
exec sp_help 'Profesores'
go

--d
ALTER TABLE Profesores
	CHECK CONSTRAINT CK_AñoFechaFinInvest
go

exec sp_help 'Profesores'
go

-- e
ALTER TABLE Financiacion
	ADD CONSTRAINT CK_FinanciacionSobre2500 CHECK (Financiacion > 2500);
go
exec sp_help 'Financiacion'

-- f
ALTER TABLE Profesores
	WITH CHECK ADD CONSTRAINT CK_TitulacionProfesores CHECK (Titulacion IN ('Arquitecto', 'Diplomado', 
											'Doctor', 'Ingeniero', 'Ingeniero Técnico', 'Licenciado'))
go

exec sp_help 'Profesores'
go

-- EJERCICIO 2
--a
INSERT INTO Programas(NombrePrograma)
	VALUES ('Programa1')
go
SELECT * FROM Programas
go

--b
ALTER TABLE Programas
	ADD FechaInicio date null CONSTRAINT DF_FechaInicioProgramas DEFAULT getDate();
go
SELECT * FROM Programas
go

-- c
ALTER TABLE Programas
	DROP CONSTRAINT DF_FechaInicioProgramas;
ALTER TABLE Programas
	DROP COLUMN FechaInicio;
go
exec sp_help 'Programas'
go

ALTER TABLE Programas
	ADD FechaInicio smalldatetime null CONSTRAINT DF_FechaInicioProgramas DEFAULT getDate() WITH VALUES;
go
SELECT * FROM Programas
go


-- EJERCICIO 3
--a
exec sp_help 'Grupos'
go

DROP TABLE Grupos;

--B
exec sp_help 'Programas'
go

ALTER TABLE Programas
	DROP CONSTRAINT FR_FinanciacionCodigoPrograma
go

--c
ALTER TABLE Financiacion
	ADD CONSTRAINT DF_CodigoPrograma_Financiacion DEFAULT 'P00' FOR CodigoPrograma;
go

exec sp_helpconstraint Financiacion
go

--d
ALTER TABLE Financiacion
	ADD CONSTRAINT FK_Financiacion_CodigoPrograma FOREIGN KEY (CodigoPrograma)
	REFERENCES Programas(CodigoPrograma) 
	ON DELETE SET DEFAULT;
go

exec  sp_helpconstraint'Financiacion'
go

--e
exec sp_helpconstraint 'Proyectos'
go
ALTER TABLE Proyectos
	NOCHECK CONSTRAINT CK_NombreProyecto
go
ALTER TABLE Proyectos
	CHECK CONSTRAINT CK_NombreProyecto
go

-- EJERCICIO 4
--a
ALTER TABLE Profesores
	ADD SueldoBase money
go
ALTER TABLE Profesores
	ADD Complementos money
go

--b
ALTER TABLE Profesores
	DROP CONSTRAINT UK_Profesor
go

ALTER TABLE Profesores
	ALTER COLUMN Nombre nvarchar(6)
go

ALTER TABLE Profesores
	ALTER COLUMN Apellidos nvarchar(6)
go

ALTER TABLE Profesores
	ADD CONSTRAINT UK_Profesor UNIQUE (Nombre, Apellidos)
	
exec sp_help 'Profesores'
