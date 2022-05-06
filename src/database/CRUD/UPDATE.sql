
-- USUARIIOS --

create or replace function fun_actualizar_usuario(codigo varchar,
                                                  nclave varchar,
                                                  nnombre varchar, 
                                                  nappater varchar, 
                                                  napmat varchar,
                                                  nnrodoc varchar,
                                                  nnrotelf varchar,
                                                  ndirec varchar)
returns void
language plpgsql
as
$$
declare 
req varchar;
needand bool;
begin
req ='UPDATE public.usuarios_usu SET ';
needand = false;

IF nclave <> '' THEN
select concat_ws(' ',req,'usu_clave=',nclave) into req;
needand=true;
end IF;

IF nnombre <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_nombres=',nnombre) into req;
needand=true;
end IF;

IF nappater <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_apellidopaterno=',nappater) into req;
needand=true;
end IF;


IF napmat <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_apellidomaterno=',napmat) into req;
needand=true;
end IF;

IF nnrodoc <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_nrodocumento=',nnrodoc) into req;
needand=true;
end IF;

IF nnrotelf <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_telefono=',nnrotelf) into req;
needand=true;
end IF;

IF ndirec <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_direccion=',ndirec) into req;
needand=true;
end IF;

select concat(req,' usu_usumodificacion=''admin'', usu_fecmodificacion=CURRENT_DATE ') into req;
select concat(req,' WHERE usu_codigo=',codigo) into req;

execute req;

end;
$$