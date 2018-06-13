use master
if exists(select * from sysdatabases where name = 'III_Progra')--si existe, la borra y luego la crea de nuevo
begin
	drop database [III_Progra];
end
create database [III_Progra];
go

use [III_Progra];
go

--primero crear un sitio donde pueda guardar banderas de la base de datos
create table DatosControlBase(
	datosSimulacionListos bit not null
);

--ahora crearé todas las tablas que no requieran FK's dentro de ellas
create table Emisor(
	id int identity primary key,
	nombre varchar(20)unique not null,
	contadorAcciones int not null,
	precioInicial float not null,
	variacion float not null,
	porcetanjeComision float not null
);

create table TipoCliente(
	id int identity primary key,
	nombre varchar(20)unique not null,
);

create table Agente(
	id int identity primary key,
	nombre varchar(20)unique not null,
	saldo float not null
);

create table TipoOperacion(
	id int identity primary key,
	nombre varchar(20)unique not null
);

create table TipoMovimiento(
	id int identity primary key,
	nombre varchar(20)unique not null
);


--ahora empezaré a crear todas las tablas que requieren un FK
create table Cliente (
	id int identity primary key,
	FKTipoClinte int constraint FKCliente_TipoCliente references TipoCliente(id),
	nombre varchar(20) not null
);

create table ClienteXEmisor(
	id int identity primary key,
	FKClinte int constraint FKClienteXEmisor_Cliente references Cliente(id),
	FKEmisor int constraint FKClienteXEmisor_Emisor references Emisor(id),
	contadorAcciones int not null
);

create table Acciones(
	id int identity primary key,
	FKEmisor int constraint FKAcciones_Emisor references Emisor(id),
	precioActual int not null,
	codigo int unique not null
);

create table Operacion(
	id int identity primary key,
	FKClienteComprador int constraint FKOperacion_ClienteC references Cliente(id),
	FKClienteVendedor int constraint FKOperacion_ClienteV references Cliente(id),
	FKTipoOperacion int constraint FKOperacion_TipoOperacion references TipoOperacion(id),
	FKAgente int constraint FKOperacion_Agente references Agente(id),
	fecha date not null,
	precio float not null,
	cantidadAcciones int not null,
	total float not null,
	porcentajeComision float not null
);


create table MovimientoAcciones(
	id int identity primary key,
	FKAccion int constraint FKMovimientoAcciones_Acciones references Acciones(id),
	FKClinte int constraint FKMovimientoAcciones_ClienteXEmisor references ClienteXEmisor(id),
	FKOperacion int constraint FKMovimientoAcciones_Operacion references Operacion(id),
	cantidad int not null,
	precio float not null
);


create table ComisionMovimiento(
	id int identity primary key,
	FKOperacion int constraint FKComisionMovimiento_Operacion references Operacion(id),
	FKTipoMovimiento int constraint FKComisionMovimiento_TipoMovimiento references TipoMovimiento(id),
	FKAgente int constraint FKComisionMovimiento_Agente references Agente(id),
	fecha date not null,
	monto float not null
);

use master