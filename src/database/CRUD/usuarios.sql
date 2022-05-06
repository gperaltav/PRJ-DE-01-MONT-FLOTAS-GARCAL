-- CREAR USUARIOS --

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
  usu_usucreacion
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
  nuscreat 
);
end;
$$