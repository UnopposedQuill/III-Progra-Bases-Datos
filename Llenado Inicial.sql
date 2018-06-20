if (db_id('III_Progra') is not null)--debo asegurarme de que existe
begin
	use [III_Progra]--la utilizo
	set nocount on;
	begin transaction
	begin try
		declare @datosXMLAcciones xml = (select * from openrowset(bulk 'C:\BaseDatos\Acciones.xml',single_blob) as x),
				@datosXMLAgentes xml = (select * from openrowset(bulk 'C:\BaseDatos\Agentes.xml',single_blob) as x),
				@datosXMLClientes xml = (select * from openrowset(bulk 'C:\BaseDatos\Clientes.xml',single_blob) as x),
				@datosXMLEmisores xml = (select * from openrowset(bulk 'C:\BaseDatos\Emisores.xml',single_blob) as x),
				@datosXMLOperaciones xml = (select * from openrowset(bulk 'C:\BaseDatos\Operaciones.xml',single_blob) as x);

		--primero los tipos
		insert into TipoCliente(nombre) values('Emisor');--1
		insert into TipoCliente(nombre) values('No Emisor');--2

		insert into TipoMovimiento(nombre) values('Credito');--1
		insert into TipoMovimiento(nombre) values('Debito');--2

		insert into TipoOperacion(nombre) values('Oferta Inicial');--1
		insert into TipoOperacion(nombre) values('Venta');--2
		insert into TipoOperacion(nombre) values('Compra');--3

		--ahora cargo los emisores
		insert into Emisor(contadorAcciones, porcentajeComision, nombre, precioInicial, variacion)
			select a.value('@QAcciones[1]','int'),
				a.value('@Comision[1]','float'),
				a.value('@Nombre[1]','nvarchar(20)'),
				a.value('@PrecioInicial[1]','float'),
				a.value('@Variacion[1]','float')
			from @datosXMLEmisores.nodes('/dataset/') as x(Rec)
			cross apply @datosXMLEmisores.nodes('/dataset/Emisores') as i(a);

		--ahora los clientes
		insert into Cliente(nombre, FKTipoCliente)
			select a.value('@Nombre[1]','nvarchar(20)'),
				a.value('@TipoCliente[1]','int')
			from @datosXMLClientes.nodes('/dataset') as x(Rec)
			cross apply @datosXMLClientes.nodes('/dataset/Clientes') as i(a)

		--ahora instancio los ClientesXEmisores
		insert into ClienteXEmisor(FKEmisor, FKCliente, contadorAcciones)
			select E.id, C.id, E.contadorAcciones
			from Cliente C inner join Emisor E on E.nombre = C.nombre
			where C.FKTipoCliente = 1;
			
		--ahora los agentes
		insert into Agente(nombre, saldo)
			select a.value('@Nombre[1]','nvarchar(20)'),
				a.value('@Saldo[1]','float')
			from @datosXMLAgentes.nodes('/dataset') as x(Rec)
			cross apply @datosXMLAgentes.nodes('/dataset/Agentes') as i(a);

		--ahora las Acciones
		insert into Acciones(codigo, FKEmisor)
			select a.value('@Codigo[1]','int'),
				E.id
			from @datosXMLClientes.nodes('/dataset') as x(Rec)
			cross apply @datosXMLClientes.nodes('/dataset/Clientes') as i(a)
			inner join Emisor E on E.nombre = a.value('@NombreEmpresa[1]','nvarchar(20)');

		--finalmente las operaciones
		insert into Operacion(cantidadAcciones, fecha, FKAgente, FKClienteComprador, 
								FKClienteVendedor, FKTipoOperacion, porcentajeComision, precio)
			select a.value('@QAcciones[1]','int'),
				a.value('@Fecha[1]','date'),
				A.id,
				a.value('@ClienteCompra[1]','int'),
				a.value('@ClienteVende[1]','int'),
				a.value('@TipoOperacion[1]','int')
			from @datosXMLAgentes.nodes('/dataset') as x(Rec)
			cross apply @datosXMLAgentes.nodes('/dataset/Operaciones') as i(a)
			inner join Agente A on A.nombre = a.value('@Agente[1]','nvarchar(20)');

		--ahora tengo que colocar todos los datos relevantes de las operaciones, primero coloco las compras, y luego coloco las ventas
		insert into MovimientoAcciones(cantidad, FKAccion, FKCliente, FKOperacion, precio, isCompra)
			select O.cantidadAcciones, /*A implementar*/1, O.FKClienteComprador, O.precio, 1/*Estoy con las compras*/)
			from Operacion O 



		--ahora coloco el bit de control para indicar que todo en la simulación está cargado correctamente
		insert into DatosControlBase(datosSimulacionListos) values (1);
		commit;--cambios logrados correctamente
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE() as MensajeError;
	end catch
--esto es para evitar problemas de que la base de datos esté en uso a la hora de borrarla
	use master;
end