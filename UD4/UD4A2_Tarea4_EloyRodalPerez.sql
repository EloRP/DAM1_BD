IF DB_ID ('Ventas') IS NOT NULL
 DROP DATABASE Ventas;
CREATE DATABASE Ventas
ON PRIMARY
(NAME = ventas_root,
FILENAME = 'C:\basedatos\ventas_root.mdf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 15%),
FILEGROUP ClienteData
( NAME = cliente_data1,
FILENAME = 'C:\basedatos\cliente_data1.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 15%),
( NAME = cliente_data2,
FILENAME = 'C:\basedatos\cliente_data2.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 15%),
( NAME = cliente_data3,
FILENAME = 'C:\basedatos\cliente_data3.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 15%),
FILEGROUP ProductoData
( NAME = producto_data1,
FILENAME = 'C:\basedatos\producto_data1.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 0),
( NAME = producto_data2,
FILENAME = 'C:\basedatos\producto_data2.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 0),
( NAME = producto_data3,
FILENAME = 'C:\basedatos\producto_data3.ndf',
SIZE = 10MB,
MAXSIZE = 50MB,
FILEGROWTH = 0)
LOG ON
(NAME= 'log_data1',
FILENAME = 'C:\basedatos\log_data1.ldf',
SIZE = 5MB,
MAXSIZE = 25MB,
FILEGROWTH = 5MB)

exec sp_helpdb 'Ventas'