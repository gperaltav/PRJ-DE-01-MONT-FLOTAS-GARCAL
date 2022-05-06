
-- Constructor: Funcion para crear vehiculos
--select fun_insertar_vehiculo(1,'n4a-1234',2,2,'smr','sem',2002,'admin')

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
