IF DB_ID ('BDCreateDB3') IS NOT NULL
 DROP DATABASE BDCreateDB3;
CREATE DATABASE BDCreateDB3
ON PRIMARY
(NAME = 'BDCreateDB3_root',
FILENAME = 'C:\basedatos\BDCreateDB3_root.mdf',
SIZE = 8MB,
MAXSIZE = 9MB,
FILEGROWTH = 100KB),
FILEGROUP GrupoSecundario
( NAME = 'BDCreateDB3_data1',
FILENAME = 'C:\basedatos\BDCreateDB3_data1.ndf',
SIZE = 10MB,
MAXSIZE = 15MB,
FILEGROWTH = 1MB)
LOG ON
(NAME= 'BDCreateDB3_Log',
FILENAME = 'C:\basedatos\BDCreateDB3_Log.ldf',
SIZE = 10MB,
MAXSIZE = 15MB,
FILEGROWTH = 1MB)