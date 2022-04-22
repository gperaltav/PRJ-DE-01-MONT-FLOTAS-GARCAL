
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