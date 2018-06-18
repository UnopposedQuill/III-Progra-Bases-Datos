if (db_id('III_Progra') is not null)--debo asegurarme de que existe
begin
	use [III_Progra]--la utilizo


--esto es para evitar problemas de que la base de datos esté en uso a la hora de borrarla
	use master;
end