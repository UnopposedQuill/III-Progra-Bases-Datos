if (db_id('III_Progra') is not null)--debo asegurarme de que existe
begin
	use [III_Progra]--la utilizo
	set nocount on;
	begin transaction
	begin try
		declare @datosXML xml = (select * from openrowset(bulk 'C:\BaseDatos\DataPrograIII.xml',single_blob) as x);
		commit;--cambios logrados correctamente
	end try
	begin catch
		rollback;
		select ERROR_MESSAGE() as MensajeError;
	end catch
--esto es para evitar problemas de que la base de datos esté en uso a la hora de borrarla
	use master;
end