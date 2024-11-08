IF DB_ID ('VIDEOJUEGOS') IS NOT NULL
 DROP DATABASE VIDEOJUEGOS;
GO
CREATE DATABASE VIDEOJUEGOS
ON PRIMARY
 ( NAME = 'videojuegos1_dat',
FILENAME ='C:\basedatos\videojuegos\videojuegosdatos1.mdf',
SIZE = 10MB,
MAXSIZE = 50,
FILEGROWTH = 15% ),
 ( NAME = 'videojuegos2_dat',
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos2.ndf',
 SIZE = 20MB,
FILEGROWTH = 2 ),
FILEGROUP Grupo1Videojuego
 ( NAME = 'videojuegos3_dat',
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos3.ndf',
SIZE = 15,
MAXSIZE = 40,
FILEGROWTH = 10 ),
 ( NAME = 'videojuegos4_dat',
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos4.ndf',
SIZE = 25,
FILEGROWTH = 0),
FILEGROUP Grupo2Videojuego
 ( NAME = 'videojuegos5_dat',
FILENAME = 'C:\basedatos\videojuegos\videojuegosdatos5.ndf'
 )
LOG ON
 ( NAME = 'videojuegos1_log',
FILENAME = 'C:\basedatos\videojuegos\videojuegoslog1.ldf',
SIZE = 15MB,
 MAXSIZE = 100MB,
FILEGROWTH = 15MB ),
 ( NAME = 'videojuegos2_log',
FILENAME = 'C:\basedatos\videojuegos\videojuegoslog2.ldf' )