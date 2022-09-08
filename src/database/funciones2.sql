-- FUNCTION: caja.fun_comprobantescompraspagos_obtener_filtro(integer, character varying, character varying, character varying, character varying, date, date)

-- DROP FUNCTION IF EXISTS caja.fun_comprobantescompraspagos_obtener_filtro(integer, character varying, character varying, character varying, character varying, date, date);

CREATE OR REPLACE FUNCTION caja.fun_comprobantescompraspagos_obtener_filtro(
	par_emp_id integer,
	par_cct_codigo character varying,
	par_ccc_serienumero character varying,
	par_fdp_codigo character varying,
	par_ccp_nroreferencia character varying,
	par_ccp_fechacancelacioninicio date,
	par_ccp_fechacancelacionfin date)
    RETURNS TABLE(ccp_id bigint, ccc_id bigint, emp_razonsocial character varying, ccc_fechaemision date, cct_codigo character varying, cct_descripcion character varying, ccc_serienumero character varying, ent_nombre character varying, ccc_total double precision, cce_codigo character varying, cce_descripcion character varying, ccc_mon_codigo character varying, ccp_fechacancelacion date, fdp_codigo character varying, fdp_descripcion character varying, ccp_nroreferencia character varying, ccp_mon_codigo character varying, ccp_tipocambio double precision, ccp_monto double precision) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE


BEGIN
RETURN QUERY
SELECT 
  ccp.ccp_id,
  ccc.ccc_id,
  emp.emp_razonsocial,
  ccc.ccc_fechaemision,
  ccc.cct_codigo,
  cct.cct_descripcion,
  CONCAT_WS('-' ,ccc.ccc_serie,ccc.ccc_numero)::varchar,
  CONCAT_WS(' ',ent.ent_nombre,  ent.ent_apellidopaterno,ent.ent_apellidomaterno)::varchar,
  ccc.ccc_total,
  ccc.cce_codigo,
  cce.cce_descripcion,
  ccc.mon_codigo,
  ccp.ccp_fechacancelacion,
  fdp.fdp_id,
  fdp.fdp_descripcion,
  ccp.ccp_nroreferencia,
  ccp.mon_codigo,
  ccp.ccp_tipocambio,
  ccp.ccp_monto
  FROM 
  compras.comprobantescomprascab_ccc ccc
  INNER JOIN public.empresas_emp emp ON (ccc.emp_id=emp.emp_id)
  INNER JOIN compras.comprobantescomprasestados_cce cce ON (ccc.cce_codigo=cce.cce_codigo AND ccc.emp_id=cce.emp_id)
  INNER JOIN compras.comprobantescomprastipos_cct cct ON (ccc.cct_codigo=cct.cct_codigo AND ccc.emp_id=cct.emp_id)
  LEFT JOIN public.entidades_ent ent ON (ccc.ent_id=ent.ent_id)
  INNER JOIN caja.comprobantescompraspagos_ccp ccp ON (ccc.ccc_id=ccp.ccc_id)
  INNER JOIN caja.formasdepago_fdp fdp ON (ccp.fdp_codigo=fdp.fdp_id AND ccp.emp_id=fdp.emp_id)
  
  WHERE  CASE WHEN par_emp_id =0 THEN 1=1 ELSE ccc.emp_id=par_emp_id END
  
  AND CASE WHEN par_cct_codigo ='' THEN 1=1 ELSE ccc.cct_codigo=par_cct_codigo END
  AND CASE WHEN par_ccc_serienumero ='' THEN 1=1 ELSE CONCAT_WS('-' ,ccc.ccc_serie,ccc.ccc_numero) ILIKE CONCAT('%',par_ccc_serienumero,'%') END
  AND CASE WHEN par_fdp_codigo ='' THEN 1=1 ELSE ccp.fdp_codigo=par_fdp_codigo END
   AND CASE WHEN par_ccp_nroreferencia ='' THEN 1=1 ELSE ccp.ccp_nroreferencia ILIKE CONCAT('%', par_ccp_nroreferencia,'%') END
 
  AND CASE WHEN par_ccp_fechacancelacioninicio IS NOT NULL AND par_ccp_fechacancelacionfin IS NOT NULL THEN  ccp.ccp_fechacancelacion BETWEEN par_ccp_fechacancelacioninicio AND par_ccp_fechacancelacionfin ELSE 1=1   END
  AND CASE WHEN par_ccp_fechacancelacioninicio IS NOT NULL AND par_ccp_fechacancelacionfin IS NULL THEN ccp.ccp_fechacancelacion >= par_ccp_fechacancelacioninicio  ELSE 1=1   END
  AND CASE WHEN par_ccp_fechacancelacioninicio IS  NULL AND par_ccp_fechacancelacionfin IS NOT NULL THEN ccp.ccp_fechacancelacion <= par_ccp_fechacancelacionfin  ELSE 1=1   END;
 
END;
$BODY$;

ALTER FUNCTION caja.fun_comprobantescompraspagos_obtener_filtro(integer, character varying, character varying, character varying, character varying, date, date)
    OWNER TO integra;
