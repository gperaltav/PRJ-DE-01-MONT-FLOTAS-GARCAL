--**** Selecciones avanzadas ****

-- Seleccionar vehiculos
SELECT
veh_id,
emp_razonsocial,
veh_placa,
vcl_nombre,
vti_nombre,
vma_nombre,
vmo_nombre,
veh_anno,
veh_serie,
veh_mtc,
veh_cargautil,
veh_kilometraje,
veh_feccreacion
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
order by veh_feccreacion desc

--
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

-- Seleccionar clientes
SELECT
*
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
order by ent_feccreacion desc

--

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

-- Seleccionar proveedores
SELECT
*,concat_ws(' ',ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre
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

--


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

-- Seleccionar trabajadores

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

-- todos los trabajadores

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

-- buscar trabajadores

create or replace function fun_get_trabajadorestst(rsa int ,nom varchar, doc varchar, puesto varchar, contrato varchar, f_in date, f_out date) 
returns table(
	tid integer,
	rs varchar,
	tnombre text,
	ndoc varchar,
	npuesto varchar,
	tcontrato varchar,
	fechin date,
	fechout date
)
LANGUAGE 'plpgsql'
as
$$
declare 
req varchar;
needand bool;
begin


needand = false;
req = 'SELECT tra_id, emp_razonsocial, concat_ws('' '',tra_nombres,tra_apellidopaterno,tra_apellidomaterno) as tnommbre, tra_nrodocumento, pue_nombre, tra_tipocontrati, tra_fechaingreso, tra_fechacese FROM ((rrhh.trabajadores_tra inner join rrhh.puestos_pue using (pue_id)) inner join (select emp_id,emp_razonsocial from public.empresas_emp ) as empresas using (emp_id))';
select concat_ws(' ',req, 'WHERE') into req;
RAISE INFO 'parte 1';

IF nom <> '' THEN
RAISE INFO 'nombre';
select concat_ws(' ',req,'concat_ws('' '',tra_nombres,tra_apellidopaterno,tra_apellidomaterno) ilike') into req;
select concat(req,'''','%',nom,'%','''') into req;
needand=true;
end IF;

IF doc <> '' THEN
RAISE INFO 'documento';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'tra_nrodocumento ilike') into req;
select concat(req,'''','%',doc,'%','''') into req;
needand=true;
end IF;

IF puesto <> '' THEN
RAISE INFO 'puesto';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'pue_nombre ilike') into req;
select concat(req,'''','%',puesto,'%','''') into req;
needand=true;
end IF;

IF contrato <> '' THEN
RAISE INFO 'contrato';
if needand = true then
select concat_ws(' ',req,'and ') into req;
end if;
select concat_ws(' ',req,'tra_tipocontrati ilike') into req;
select concat(req,'''','%',contrato,'%','''') into req;
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



--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--

--Constructor Funcion para crear usuarios

create or replace function fun_insertar_usuario(ncodigo varchar,
												nclave varchar,
												nnombre varchar, 
												nappater varchar, 
												napmat varchar,
												nnrodoc varchar,
												nnrotelf varchar,
												ndirec varchar,
												nuscreat varchar
											   )
returns void
language plpgsql
as
$$
declare 
begin
INSERT INTO 
public.usuarios_usu
(
  usu_codigo,
  usu_clave,
  usu_nombre,
  usu_apepaterno,
  usu_apematerno,
  usu_nrodocumento,
  usu_telefono,
  usu_direccion,
  usu_usucreacion,
  usu_feccreacion
)
VALUES (
  ncodigo,
  nclave,
  nnombre,
  nappater ,
  napmat ,
  nnrodoc ,
  nnrotelf ,
  ndirec ,
  nuscreat ,
  CURRENT_DATE
);
end;
$$

-- Constructor: Funcion para crear vehiculos

CREATE OR REPLACE FUNCTION public.fun_insertar_vehiculo( nrs integer,
                                                        nplaca character varying,
                                                        nvmaid integer,
                                                        nvmoid integer,
                                                        nvtiid character varying,
                                                        nvclid character varying,
                                                        nvanno integer,
                                                        nusucrea character varying
                                                        )

RETURNS void
LANGUAGE 'plpgsql'
COST 100
VOLATILE PARALLEL UNSAFE
AS
$$
declare 
begin
INSERT INTO 
operaciones.vehiculos_veh (
  emp_id,
  veh_placa,
  vma_id,
  vmo_id,
  vti_id,
  vcl_id,
  veh_anno,
  veh_usucreacion
)
VALUES (
  nrs,
  nplaca,
  nvmaid, 
  nvmoid, 
  nvtiid,
  nvclid,
  nvanno,
  nusucrea 
);
end;
$$
--select fun_insertar_vehiculo(1,'n4a-1234',2,2,'smr','sem',2002,'admin')




--Constructor: Funcion para crear empresas

create or replace function fun_insertar_empresa(ncodigo varchar,
                                                nrazon varchar, 
                                                nruc varchar, 
                                                ndireccion varchar,
                                                ndepartamneto varchar,
                                                ndistrito varchar,
                                                nprovincia varchar,
                                                nubigeo varchar,
                                                ntelefono varchar,
                                                ncorreo varchar,
                                                npaginaweb varchar,
                                                ncelular varchar)

returns void
language plpgsql
as
$$
declare 
begin
INSERT INTO 
public.empresas_emp
(
  emp_codigo,
  emp_razonsocial,
  emp_ruc,
  emp_direccion,
  emp_departamento,
  emp_distrito,
  emp_provincia,
  emp_ubigeo,
  emp_telefono,
  emp_correo,
  emp_paginaweb,
  emp_celular
)
VALUES (
  ncodigo,
  nrazon, 
  nruc, 
  ndireccion,
  ndepartamneto,
  ndistrito,
  nprovincia,
  nubigeo,
  ntelefono,
  ncorreo,
  npaginaweb,
  ncelular
);
end;
$$

--Constructor: Funcion para crear entidades

create or replace function fun_insertar_entidad(nempid integer,
                                                nubicodigo varchar, 
                                                nnombre varchar, 
                                                nappaterno varchar,
                                                napmaterno varchar,
                                                nnrodoc varchar,
                                                ndtiid varchar,
                                                nzonid integer,
                                                ndireccion varchar,
                                                ntelefono varchar,
                                                ncorreo varchar,
                                                npaginaweb varchar,
                                                ncelular varchar,
                                                ncontacto varchar,
                                                nsexo char)

returns void
language plpgsql
as
$$
declare 
begin
INSERT INTO 
public.entidades_ent
(
  emp_id,
  ubi_codigo, 
  ent_nombre, 
  dti_id,
  ent_nrodocumento,
  ent_apellidopaterno,
  ent_apellidomaterno,
  zon_id,
  ent_direccion,
  ent_telefono,
  ent_correo,
  ent_paginaweb,
  ent_celular,
  ent_contacto,
  ent_sexo
)
VALUES (
  nempid,
  nubicodigo, 
  nnombre, 
  ndtiid,
  nnrodoc,
  nappaterno,
  napmaterno,
  nzonid,
  ndireccion,
  ntelefono,
  ncorreo,
  npaginaweb,
  ncelular,
  ncontacto,
  nsexo
);
end;
$$



--||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||--

--Constructor Funcion para editar usuarios

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
begin

IF nclave <> '' THEN
UPDATE public.usuarios_usu SET usu_clave=nclave WHERE usu_codigo=codigo;
END IF;
IF nnombre <> '' THEN
UPDATE public.usuarios_usu SET usu_nombre=nnombre WHERE usu_codigo=codigo;
END IF;
IF nappater <> '' THEN
UPDATE public.usuarios_usu SET usu_apepaterno=nappater WHERE usu_codigo=codigo;
END IF;
IF napmat <> '' THEN
UPDATE public.usuarios_usu SET usu_apematerno=napmat WHERE usu_codigo=codigo;
END IF;
IF nnrodoc <> '' THEN
UPDATE public.usuarios_usu SET usu_nrodocumento=nnrodoc WHERE usu_codigo=codigo;
END IF;
IF nnrotelf <> '' THEN
UPDATE public.usuarios_usu SET usu_telefono=nnrotelf WHERE usu_codigo=codigo;
END IF;
IF ndirec <> '' THEN
UPDATE public.usuarios_usu SET usu_direccion=ndirec WHERE usu_codigo=codigo;
END IF;
UPDATE public.usuarios_usu SET usu_usumodificacion='admin', usu_fecmodificacion=CURRENT_DATE WHERE usu_codigo=codigo;
end;
$$

--fix

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
select concat_ws(' ',req,'usu_nombre=',nnombre) into req;
needand=true;
end IF;

IF nappater <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_apepaterno=',nappater) into req;
needand=true;
end IF;


IF napmat <> '' THEN
if needand = true then
select concat_ws(' ',req,', ') into req;
end if;
select concat_ws(' ',req,'usu_apematerno=',napmat) into req;
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


--Constructor Funcion para editar entidades

create or replace function fun_actualizar_entidad(codigo integer,
                                                  nempid integer,
                                                  nubicodigo varchar, 
                                                  nnombre varchar, 
                                                  nappaterno varchar,
                                                  napmaterno varchar,
                                                  nnrodoc varchar,
                                                  ndtiid varchar,
                                                  nzonid integer,
                                                  ndireccion varchar,
                                                  ntelefono varchar,
                                                  ncorreo varchar,
                                                  npaginaweb varchar,
                                                  ncelular varchar,
                                                  ncontacto varchar,
                                                  nsexo char)
returns void
language plpgsql
as
$$
declare 
begin

IF nempid <> '-1' THEN
UPDATE public.entidades_ent SET emp_id=nempid WHERE ent_id=codigo;
END IF;
IF nubicodigo <> '' THEN
UPDATE public.entidades_ent SET ubi_codigo=nubicodigo WHERE ent_id=codigo;
END IF;
IF nnombre <> '' THEN
UPDATE public.entidades_ent SET ent_nombre=nnombre WHERE ent_id=codigo;
END IF;
IF nappaterno <> '' THEN
UPDATE public.entidades_ent SET ent_apellidopaterno=nappaterno WHERE ent_id=codigo;
END IF;
IF napmaterno <> '' THEN
UPDATE public.entidades_ent SET ent_apellidomaterno=napmaterno WHERE ent_id=codigo;
END IF;
IF nnrodoc <> '' THEN
UPDATE public.entidades_ent SET ent_nrodocumento=nnrodoc WHERE ent_id=codigo;
END IF;
IF ndtiid <> '' THEN
UPDATE public.entidades_ent SET dti_id=ndtiid WHERE ent_id=codigo;
END IF;
IF nzonid <> -1 THEN
UPDATE public.entidades_ent SET zon_id=nzonid WHERE ent_id=codigo;
END IF;
IF ndireccion <> '' THEN
UPDATE public.entidades_ent SET ent_direccion=ndireccion WHERE ent_id=codigo;
END IF;
IF ntelefono <> '' THEN
UPDATE public.entidades_ent SET ent_telefono=ntelefono WHERE ent_id=codigo;
END IF;
IF ncorreo <> '' THEN
UPDATE public.entidades_ent SET ent_correo=ncorreo WHERE ent_id=codigo;
END IF;
IF npaginaweb <> '' THEN
UPDATE public.entidades_ent SET ent_paginaweb=npaginaweb WHERE ent_id=codigo;
END IF;
IF ncelular <> '' THEN
UPDATE public.entidades_ent SET ent_celular=ncelular WHERE ent_id=codigo;
END IF;
IF ncontacto <> '' THEN
UPDATE public.entidades_ent SET ent_contacto=ncontacto WHERE ent_id=codigo;
END IF;

UPDATE public.entidades_ent SET usu_usumodificacion='admin', usu_fecmodificacion=CURRENT_DATE WHERE usu_codigo=codigo;
end;
$$


--rev
SELECT 
User_id, 
CASE WHEN (MIN(mode) <> MAX(mode))
THEN
    'Multiple' 
ELSE
    MIN(mode)
END
as "Start Mode"
FROM sessions
--Where condition here
GROUP BY user_id