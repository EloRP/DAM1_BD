-- EJERCICIO 1
-- Crear la base de datos BD_TiposUsuario1
IF DB_ID ('BD_TiposUsuario1') IS NOT NULL
DROP DATABASE BD_TiposUsuario1;
CREATE DATABASE BD_TiposUsuario1;

-- Comprobar si los tipos de datos existen y borrarlos si es necesario
IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoCodigo')
    DROP TYPE TipoCodigo;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNum')
    DROP TYPE TipoNum;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoTelefono')
    DROP TYPE TipoTelefono;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNombreCorto')
    DROP TYPE TipoNombreCorto;

-- Crear tipos de datos
CREATE TYPE TipoCodigo FROM CHAR(10);
CREATE TYPE TipoNum FROM INT;
CREATE TYPE TipoTelefono FROM VARCHAR(9) NULL;
CREATE TYPE TipoNombreCorto FROM VARCHAR(15);


-- Consulta para obtener tipos definidos por el usuario
SELECT name AS TipoDefinidoPorUsuario
FROM sys.types
WHERE is_user_defined = 1;

-- Consulta para obtener tipos definidos por el usuario desde information_schema.domains
SELECT domain_name, data_type, character_maximum_length
FROM information_schema.domains
ORDER BY domain_name;

-- Ejecutar sp_help
exec sp_help 'BD_TiposUsuario1'
exec sp_help 'TipoCodigo'

-- EJERCICIO 2
-- Comprobar si los tipos de datos existen y borrarlos si es necesario
IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoCodigo')
    DROP TYPE TipoCodigo;

IF EXISTS (SELECT * FROM sys.types WHERE name = 'TipoNum')
    DROP TYPE TipoNum;

-- Verificar que los tipos de datos han sido eliminados
SELECT name AS TipoEliminado
FROM sys.types
WHERE name IN ('TipoCodigo', 'TipoNum');