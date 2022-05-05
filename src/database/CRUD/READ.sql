
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
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
order by veh_feccreacion desc ;
end;
$$


-- TODOS LOS CLIENTES --

create or replace function fun_get_clientes_all() 
returns table(
	rs varchar,
	nnombre text,
	pnatural bool,
	ndoc varchar
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
ent_personanatural,
ent_nrodocumento
FROM
(((select * from public.entidadestiposxentidades_exe WHERE ext_id='cli') as exe
inner join
public.entidades_ent
using (ent_id))
inner join
public.entidadestipos_ext
using (ext_id))
inner join 
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
order by ent_feccreacion desc;
end;
$$


-- TODOS LOS PROVEEDORES --

create or replace function fun_get_proveedores_all() 
returns table(
	rs varchar,
	nnombre text,
	pnatural bool,
	ndoc varchar
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
ent_personanatural,
ent_nrodocumento
FROM
(((select * from public.entidadestiposxentidades_exe WHERE ext_id='prv') as exe
inner join
public.entidades_ent
using (ent_id))
inner join
public.entidadestipos_ext
using (ext_id))
inner join 
(select emp_id,emp_razonsocial from public.empresas_emp ) as empresas
using (emp_id)
order by ent_feccreacion desc
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

