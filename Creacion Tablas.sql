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
	nombre nvarchar(20)unique not null,
	contadorAcciones int not null,
	precioInicial float not null,
	variacion float not null,
	porcentajeComision float not null,
	habilitado bit not null default 1
);

create table TipoCliente(
	id int identity primary key,
	nombre nvarchar(20)unique not null,
	habilitado bit not null default 1
);

create table Agente(
	id int identity primary key,
	nombre nvarchar(20)unique not null,
	saldo float not null,
	habilitado bit not null default 1
);

create table TipoOperacion(
	id int identity primary key,
	nombre nvarchar(20)unique not null,
	habilitado bit not null default 1
);

create table TipoMovimiento(
	id int identity primary key,
	nombre nvarchar(20)unique not null,
	habilitado bit not null default 1
);

--ahora empezaré a crear todas las tablas que requieren un FK
create table Cliente (
	id int identity primary key,
	FKTipoCliente int constraint FKCliente_TipoCliente references TipoCliente(id) not null,
	nombre nvarchar(20) not null,
	habilitado bit not null default 1
);

create table ClienteXEmisor(
	id int identity primary key,
	FKCliente int constraint FKClienteXEmisor_Cliente references Cliente(id) not null,
	FKEmisor int constraint FKClienteXEmisor_Emisor references Emisor(id) not null,
	contadorAcciones int not null check (contadorAcciones >= 0),
	habilitado bit not null default 1
);

create table Acciones(
	id int identity primary key,
	FKEmisor int constraint FKAcciones_Emisor references Emisor(id) not null,
	--precioActual int not null,--se eliminó por redundancia
	codigo int unique not null,
	habilitado bit not null default 1
);

create table ClienteXAcciones(
	id int identity primary key,
	FKCliente int constraint FKClienteXAcciones_Cliente references Cliente(id) not null,
	FKAccion int constraint FKClienteXAcciones_Accion references Acciones(id) not null,
	contadorAcciones int not null
);

create table Operacion(
	id int identity primary key,
	FKClienteComprador int constraint FKOperacion_ClienteComprador references Cliente(id) not null,
	FKClienteVendedor int constraint FKOperacion_ClienteVendedor references Cliente(id) not null,
	FKTipoOperacion int constraint FKOperacion_TipoOperacion references TipoOperacion(id) not null,
	FKAgente int constraint FKOperacion_Agente references Agente(id),
	fecha date not null,
	precio float not null,
	cantidadAcciones int not null,
	total float not null,
	porcentajeComision float not null,
	habilitado bit not null default 1
);

create table MovimientoAcciones(
	id int identity primary key,
	FKAccion int constraint FKMovimientoAcciones_Acciones references Acciones(id),
	FKCliente int constraint FKMovimientoAcciones_Cliente references Cliente(id),
	FKOperacion int constraint FKMovimientoAcciones_Operacion references Operacion(id),
	cantidad int not null,
	precio float not null,
	isCompra bit not null,
	habilitado bit not null default 1
);

create table ComisionMovimiento(
	id int identity primary key,
	FKOperacion int constraint FKComisionMovimiento_Operacion references Operacion(id),
	FKTipoMovimiento int constraint FKComisionMovimiento_TipoMovimiento references TipoMovimiento(id),
	FKAgente int constraint FKComisionMovimiento_Agente references Agente(id),
	fecha date not null,
	monto float not null,
	habilitado bit not null default 1
);

use master