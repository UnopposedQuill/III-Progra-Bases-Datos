if (db_id('III_Progra') is not null)--debo asegurarme de que existe
	use [III_Progra]--la utilizo

--Comienzo procedimientos de insertado

go
if object_id('SPinsertarEmisor','P') is not null drop procedure SPinsertarEmisor;
go
create procedure SPinsertarEmisor @nombre nvarchar(20), @contadorAcciones int, @precioInicial float, @variacion float, @porcentajeComision float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Emisor(nombre, contadorAcciones, precioInicial,variacion,porcentajeComision) values (@nombre, @contadorAcciones, @precioInicial, @variacion, @porcentajeComision);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

go
if object_id('SPtipoCliente','P') is not null drop procedure SPtipoCliente;
go
create procedure SPtipoCliente @nombre nvarchar(20)
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into TipoCliente(nombre) values (@nombre);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go


go
if object_id('SPagente','P') is not null drop procedure SPagente;
go
create procedure SPagente @nombre nvarchar(20), @saldo float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Agente(nombre, saldo) values (@nombre, @saldo);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go


go
if object_id('SPtipoOperacion','P') is not null drop procedure SPtipoOperacion;
go
create procedure SPtipoOperacion @nombre nvarchar(20)
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into TipoOperacion(nombre) values (@nombre);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

go
if object_id('SPtipoMovimiento','P') is not null drop procedure SPtipoMovimiento;
go
create procedure SPtipoMovimiento @nombre nvarchar(20)
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into TipoMovimiento(nombre) values (@nombre);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go


go
if object_id('SPcliente','P') is not null drop procedure SPcliente;
go
create procedure SPcliente @nombre nvarchar(20), @idCliente int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Cliente(nombre,FKTipoCliente) values (@nombre,@idCliente);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go


go
if object_id('SPclienteXemisor','P') is not null drop procedure SPclienteXemisor;
go
create procedure SPclienteXemisor @idCliente int, @idEmisor int, @contadorAcciones int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into ClienteXEmisor(FKCliente,FKEmisor,contadorAcciones) values (@idCliente,@idEmisor,@contadorAcciones);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

go
if object_id('SPacciones','P') is not null drop procedure SPacciones;
go
create procedure SPacciones @idEmisor int, @codigo int
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Acciones(FKEmisor,codigo) values (@idEmisor,@codigo);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

go
if object_id('SPoperacion','P') is not null drop procedure SPoperacion;
go
create procedure SPoperacion @idClienteComprador int, @idClienteVendedor int,@idTipoOperacion int ,@idAgente int ,@fecha date,@precio float,@cantidadAcciones int ,@total float ,@porcentajeComision float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into Operacion(FKClienteComprador,FKClienteVendedor,FKTipoOperacion,FKAgente,fecha,precio,cantidadAcciones,total,porcentajeComision) values (@idClienteComprador,@idClienteVendedor,@idTipoOperacion,@idAgente,@fecha,@precio,@cantidadAcciones,@total,@porcentajeComision);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

go
if object_id('SPmovimientoAcciones','P') is not null drop procedure SPmovimientoAcciones;
go
create procedure SPmovimientoAcciones @idAccion int, @idCliente int,@idOperacion int ,@cantidad int , @precio float, @isCompra bit
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into MovimientoAcciones(FKAccion,FKCliente,FKOperacion,cantidad,precio,isCompra) values (@idAccion, @idCliente,@idOperacion ,@cantidad , @precio, @isCompra);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go


go
if object_id('SPcomisionMovimiento','P') is not null drop procedure SPcomisionMovimiento;
go
create procedure SPcomisionMovimiento @idOperacion int, @idTipoMovimiento int, @idAgente int, @fecha date, @monto float
as begin
	set nocount on;
	begin transaction;
	begin try
		insert into ComisionMovimiento(FKOperacion,FKTipoMovimiento,FKAgente,fecha,monto) values (@idOperacion,@idTipoMovimiento,@idAgente,@fecha,@monto);
		commit;
		return @@identity;
	end try
	begin catch
		rollback
		return -50001;
	end catch
end
go

--Comienzo para stores procedures de editar

go
create procedure SPeditarEmisorNombreEmisor @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from Emisor as E
	where E.id = 1;
end
go

go
create procedure SPeditarEmisorContadorAcciones @contadorAcciones int
as begin
	update E
	set E.contadorAcciones = @contadorAcciones
	from Emisor as E
	where E.id = 1;
end
go

go
create procedure SPeditarEmisorPrecioInicial @precioInicial float
as begin
	update E
	set E.precioInicial = @precioInicial
	from Emisor as E
	where E.id = 1;
end
go

go
create procedure SPeditarEmisorVariacion @variacion float
as begin
	update E
	set E.variacion = @variacion
	from Emisor as E
	where E.id = 1;
end
go

go
create procedure SPeditarEmisorPorcentajeComision @porcentajeComision float
as begin
	update E
	set E.porcentajeComision = @porcentajeComision
	from Emisor as E
	where E.id = 1;
end
go

go
create procedure SPeditarTipoClienteNombre @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from TipoCliente as E
	where E.id = 1;
end
go

go
create procedure SPeditarAgenteNombre @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from Agente as E
	where E.id = 1;
end
go

go
create procedure SPeditarAgenteSaldo @saldo float
as begin
	update E
	set E.saldo = @saldo
	from Agente as E
	where E.id = 1;
end
go

go
create procedure SPeditarTipoOperacionNombre @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from TipoOperacion as E
	where E.id = 1;
end
go

go
create procedure SPeditarTipoMovimientoNombre @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from TipoMovimiento as E
	where E.id = 1;
end
go

go
create procedure SPeditarClienteNombre @nombre nvarchar(20)
as begin
	update E
	set E.nombre = @nombre
	from Cliente as E
	where E.id = 1;
end
go

go
create procedure SPeditarClienteXemisorContadorAcciones @contadorAcciones int
as begin
	update E
	set E.contadorAcciones = @contadorAcciones
	from ClienteXEmisor as E
	where E.id = 1;
end
go


go
create procedure SPeditarAccionesCodigo @codigo int
as begin
	update E
	set E.codigo = @codigo
	from Acciones as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionFecha @fecha date
as begin
	update E
	set E.fecha = @fecha
	from Operacion as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionPrecio @precio float
as begin
	update E
	set E.precio = @precio
	from Operacion as E
	where E.id = 1;
end
go


go
create procedure SPeditarOperacionCantidadAcciones @cantidadAcciones int
as begin
	update E
	set E.cantidadAcciones = @cantidadAcciones
	from Operacion as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionTotal @total float
as begin
	update E
	set E.total = @total
	from Operacion as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionPorcentajeComision @porcentajeComision float
as begin
	update E
	set E.porcentajeComision = @porcentajeComision
	from Operacion as E
	where E.id = 1;
end
go


go
create procedure SPeditarMovimientoAccionesCantidad @cantidad int
as begin
	update E
	set E.cantidad = @cantidad
	from MovimientoAcciones as E
	where E.id = 1;
end
go

go
create procedure SPeditarMovimientoAccionesPrecio @precio float
as begin
	update E
	set E.precio = @precio
	from MovimientoAcciones as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionTotal @total float
as begin
	update E
	set E.total = @total
	from Operacion as E
	where E.id = 1;
end
go

go
create procedure SPeditarOperacionPorcentajeComision @porcentajeComision float
as begin
	update E
	set E.porcentajeComision = @porcentajeComision
	from Operacion as E
	where E.id = 1;
end
go


go
create procedure SPeditarMovimientoAccionesCantidad @cantidad int
as begin
	update E
	set E.cantidad = @cantidad
	from MovimientoAcciones as E
	where E.id = 1;
end
go

go
create procedure SPeditarMovimientoAccionesIsCompra @isCompra bit
as begin
	update E
	set E.isCompra = @isCompra
	from MovimientoAcciones as E
	where E.id = 1;
end
go

go
create procedure SPeditarComisionMovimientoFecha @fecha date
as begin
	update E
	set E.fecha = @fecha
	from ComisionMovimiento as E
	where E.id = 1;
end
go

go
create procedure SPeditarComisionMovimientoMonto @monto float
as begin
	update E
	set E.monto = @monto
	from ComisionMovimiento as E
	where E.id = 1;
end
go

--esto es para evitar problemas de que la base de datos esté en uso a la hora de borrarla
use master
go