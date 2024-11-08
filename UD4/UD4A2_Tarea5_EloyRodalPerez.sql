IF DB_ID ('DB_Ejemplo6') IS NOT NULL
DROP DATABASE DB_Ejemplo6;
GO
CREATE DATABASE DB_Ejemplo6
ON PRIMARY
( NAME = 'DB_Ejemplo6_dat',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat.mdf',
SIZE = 10MB,
MAXSIZE = 31457380KB,
FILEGROWTH = 15% ),

( NAME = 'DB_Ejemplo61_dat',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat1.ndf',
SIZE = 5MB,
MAXSIZE = 5242800KB,
FILEGROWTH = 15% ),

FILEGROUP Grupo1DB_Ejemplo6
( NAME = 'DB_Ejemplo6_dat2',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat2.ndf',
SIZE = 20MB,
MAXSIZE = 512MB,
FILEGROWTH = 5MB ),

( NAME = 'DB_Ejemplo6_dat3',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat3.ndf',
SIZE = 10MB,
MAXSIZE = 512MB,
FILEGROWTH = 192KB ),

FILEGROUP Grupo2DB_Ejemplo6
( NAME = 'DB_Ejemplo6_dat4',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat4.ndf',
SIZE = 10MB,
MAXSIZE = 512MB,
FILEGROWTH = 18% ),

( NAME = 'DB_Ejemplo6_dat5',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat5.ndf',
SIZE = 10MB,
FILEGROWTH = 128KB ),

FILEGROUP Grupo3DB_Ejemplo6
( NAME = 'DB_Ejemplo6_dat6',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat6.ndf',
SIZE = 10MB,
MAXSIZE = 512MB,
FILEGROWTH = 25% ),

( NAME = 'DB_Ejemplo6_dat7',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat7.ndf',
SIZE = 20MB,
FILEGROWTH = 192KB ),

( NAME = 'DB_Ejemplo6_dat8',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6dat8.ndf',
SIZE = 20MB,
FILEGROWTH = 10% )
LOG ON
( NAME = 'DB_Ejemplo6_log1',
FILENAME ='C:\basedatos\Tarea5\5.3\DB_Ejemplo6log1.ldf',
SIZE = 5MB,
MAXSIZE = 256000KB,
FILEGROWTH = 5MB )