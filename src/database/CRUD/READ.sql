
-- TODOS LOS VEHICULOS --

create or replace function fun_get_vehiculos_all() 
returns table(
vid int,
rs varchar,
placa varchar,
clase varchar,
tipo varchar,
marca varchar,
modelo varchar,
anno int,
serie varchar,
mtc varchar,
cargautil numeric,
km numeric
)
LANGUAGE 'plpgsql'
as
$$
declare 
begin

RETURN QUERY SELECT
veh_id as vid,
emp_razonsocial as rs,
veh_placa as placa,
vcl_nombre as clase,
vti_nombre as tipo,
vma_nombre as marca,
vmo_nombre as modelo,
veh_anno as anno,
veh_serie as serie,
veh_mtc as mtc,
veh_cargautil as cargautil,
veh_kilometraje as km
FROM
((((operaciones.vehiculos_veh
inner join
operaciones.vehiculosmarcas_vma 
USING (vma_id))
inner join
operaciones.vehiculostipos_vti
USING (vti_id))
inner join
operaciones.vehiculosclases_vcl
USING (vcl_id))
inner join
operaciones.vehiculosmodelos_vmo
USING (vmo_id))
inner join
public.empresas_emp
using (emp_id)
order by veh_feccreacion desc ;
end;
$$
-- BUSCAR VEHICULOS --

create or replace function fun_get_vehiculostst(rsa int ,placa varchar, marca varchar, modelo varchar, f_in date, f_out date) 
returns table(
	v_id int,
	v_rs varchar,
	v_placa varchar,
	v_clase varchar,
	v_tipo varchar,
	v_marca varchar,
	v_modelo varchar,
	v_anno int,
	v_serie varchar,
	v_mtc varchar,
	v_cargautil numeric,
	v_km numeric
)
LANGUAGE 'plpgsql'
as
$$
declare 
req varchar;
needand bool;
begin

needand = false;
req = ' SELECT veh_id as vid, emp_razonsocial as rs, veh_placa as placa, vcl_nombre as clase, vti_nombre as tipo, vma_nombre as marca, vmo_nombre as modelo, veh_anno as anno, veh_serie as serie, veh_mtc as mtc, veh_cargautil as cargautil, veh_kilometraje as km FROM (((((operaciones.vehiculos_veh inner join operaciones.vehiculosmarcas_vma USING (vma_id)) inner join operaciones.vehiculostipos_vti USING (vti_id)) inner join operaciones.vehiculosclases_vcl USING (vcl_id)) inner join operaciones.vehiculosmodelos_vmo USING (vmo_id)) inner join public.empresas_emp using (emp_id))  ';   
select concat_ws(' ',req, 'WHERE') into req;

IF placa <> '' THEN
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'veh_placa ilike ') into req;
select concat(req,'''','%',placa,'%','''') into req;
needand=true;
end IF;

IF marca <> '' THEN
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'vma_nombre ilike ') into req;
select concat(req,'''','%',marca,'%','''') into req;
needand=true;
end IF;

IF modelo <> '' THEN
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'vmo_nombre ilike ') into req;
select concat(req,'''','%',modelo,'%','''') into req;
needand=true;
end IF;

IF rsa <> -1 THEN
RAISE INFO 'razon s';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'emp_id =',rsa) into req;
needand=true;
end IF;

IF f_in is not null THEN
RAISE INFO 'fecha in';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'tra_fechaingreso > ') into req;
select concat(req,'''',f_in,'''',' and ') into req;
select concat_ws(' ',req,'tra_fechacese > ') into req;
select concat(req,'''',f_in,'''') into req;
needand=true;
end IF;

IF f_out is not null THEN
RAISE INFO 'fecha out';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'tra_fechaingreso < ') into req;
select concat(req,'''',f_out,'''',' and ') into req;
select concat_ws(' ',req,'tra_fechacese < ') into req;
select concat(req,'''',f_out,'''') into req;
needand=true;
end IF;

RETURN QUERY 
execute req;

end;
$$



-- TODOS LOS CLIENTES --

create or replace function fun_get_clientes_all() 
returns table(
	cli_rs varchar,
	cli_nombre text,
	cli_pnatural bool,
	cli_ndoc varchar,
	cli_fpago varchar
)
LANGUAGE 'plpgsql'
as
$$
declare 
begin

RETURN QUERY 
SELECT
emp_razonsocial,
concat_ws(' ',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre,
ent_nrodocumento,
ent_personanatural,
fdp_id
FROM
((public.entidadestiposxentidades_exe
inner join 
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
inner join
public.entidades_ent
using (ent_id))
inner join
public.entidadestipos_ext
using (ext_id))
WHERE ext_id='cli'

order by ent_feccreacion desc;
end;
$$

-- BUSCAR CLIENTES --

create or replace function fun_get_clientestst(rsa int ,nom varchar, ndoc varchar, fpago varchar) 
returns table(
	cli_rs varchar,
	cli_nombre text,
	cli_ndoc varchar,
	cli_pnatural bool,
	cli_fpago varchar
)
LANGUAGE 'plpgsql'
as
$$
declare 
req varchar;
needand bool;
begin

needand = true;
req = 'SELECT emp_razonsocial, concat_ws('' '',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre, ent_nrodocumento, ent_personanatural, fdp_id FROM ((public.entidadestiposxentidades_exe inner join (select emp_id,emp_razonsocial from public.empresas_emp ) as empresas using (emp_id) inner join public.entidades_ent using (ent_id)) inner join public.entidadestipos_ext using (ext_id)) WHERE ext_id=''cli''';   

IF nom <> '' THEN
RAISE INFO 'nombre';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'concat_ws('' '',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) ilike') into req;
select concat(req,'''','%',nom,'%','''') into req;
needand=true;
end IF;

IF ndoc <> '' THEN
RAISE INFO 'documento';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'ent_nrodocumento ilike') into req;
select concat(req,'''','%',ndoc,'%','''') into req;
needand=true;
end IF;

IF fpago <> '' THEN
RAISE INFO 'forma de pago';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'fdp_id ilike') into req;
select concat(req,'''','%',fpago,'%','''') into req;
needand=true;
end IF;

IF rsa <> -1 THEN
RAISE INFO 'razon s';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'emp_id =',rsa) into req;
needand=true;
end IF;

RETURN QUERY 
execute req;

end;
$$

-- TODOS LOS PROVEEDORES --

create or replace function fun_get_proveedores_all() 
returns table(
	prv_rs varchar,
	prv_nombre text,
	prv_pnatural bool,
	prv_ndoc varchar,
	prv_fpago varchar
)
LANGUAGE 'plpgsql'
as
$$
declare 
begin

RETURN QUERY 
SELECT
emp_razonsocial,
concat_ws(' ',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre,
ent_nrodocumento,
ent_personanatural,
fdp_id
FROM
((public.entidadestiposxentidades_exe
inner join 
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
inner join
public.entidades_ent
using (ent_id))
inner join
public.entidadestipos_ext
using (ext_id))
WHERE ext_id='prv'

order by ent_feccreacion desc;
end;
$$

-- BUSCAR PROVEEDORES --

create or replace function fun_get_proveedorestst(rsa int ,nom varchar, ndoc varchar, fpago varchar) 
returns table(
	prv_rs varchar,
	prv_nombre text,
	prv_ndoc varchar,
	prv_pnatural bool,
	prv_fpago varchar
)
LANGUAGE 'plpgsql'
as
$$
declare 
req varchar;
needand bool;
begin

needand = true;
req = ' SELECT emp_razonsocial, concat_ws('' '',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre, ent_nrodocumento, ent_personanatural, fdp_id FROM ((public.entidadestiposxentidades_exe inner join (select emp_id,emp_razonsocial from public.empresas_emp ) as empresas using (emp_id) inner join public.entidades_ent using (ent_id)) inner join public.entidadestipos_ext using (ext_id)) WHERE ext_id=''prv'' ';   

IF nom <> '' THEN
RAISE INFO 'nombre';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'concat_ws('' '',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) ilike') into req;
select concat(req,'''','%',nom,'%','''') into req;
needand=true;
end IF;

IF ndoc <> '' THEN
RAISE INFO 'documento';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'ent_nrodocumento ilike') into req;
select concat(req,'''','%',ndoc,'%','''') into req;
needand=true;
end IF;

IF fpago <> '' THEN
RAISE INFO 'forma de pago';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'fdp_id ilike') into req;
select concat(req,'''','%',fpago,'%','''') into req;
needand=true;
end IF;

IF rsa <> -1 THEN
RAISE INFO 'razon s';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'emp_id =',rsa) into req;
needand=true;
end IF;

RETURN QUERY 
execute req;

end;
$$

-- TODOS LOS TRABAJADORES -

CREATE OR REPLACE FUNCTION public.fun_get_trabajadores_all(
	)
    RETURNS TABLE(tid integer, rs character varying, tnombre text, nrodoc character varying, puesto character varying, tipocontrato character varying, fechaingreso date, fechacese date) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
declare 
begin

RETURN QUERY 
SELECT
tra_id,
emp_razonsocial,
concat_ws(' ',tra_nombres,tra_apellidopaterno,tra_apellidomaterno) as tnommbre,
tra_nrodocumento,
pue_nombre,
tra_tipocontrati,
tra_fechaingreso,
tra_fechacese
FROM
(rrhh.trabajadores_tra
inner join
rrhh.puestos_pue
using (pue_id))
inner join
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
order by tra_feccreacion desc;

end;
$BODY$;

-- USUARIOS

