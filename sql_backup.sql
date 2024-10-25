CREATE TABLE
  operaciones.tripulaciontiposdocumentos_ttd (
    ttd_id serial NOT NULL,
    emp_id integer NULL,
    ttd_nombre character varying NULL,
    ttd_avisovencimiento integer NULL,
    ttd_usucreacion character varying NULL,
    ttd_feccreacion timestamp without time zone NULL DEFAULT now(),
    ttd_usumodificacion character varying NULL,
    ttd_fecmodificacion timestamp without time zone NULL
  );

ALTER TABLE
  operaciones.tripulaciontiposdocumentos_ttd
ADD
  CONSTRAINT tripulaciontiposdocumentos_ttd_pkey PRIMARY KEY (ttd_id)

insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (2, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 1, 'LICENCIA A3', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (2, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 2, 'LICENCIA A4', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (2, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 3, 'SCTR', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (2, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 4, 'REV. MEDICA', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (2, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 5, 'SEGURO VIDA LEY', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (1, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 7, 'LICENCIA A3', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (1, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 8, 'LICENCIA A4', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (1, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 9, 'SCTR', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (1, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 10, 'REV. MEDICA', 'admin', 'admin');
insert into "tripulaciontiposdocumentos_ttd" ("emp_id", "ttd_avisovencimiento", "ttd_feccreacion", "ttd_fecmodificacion", "ttd_id", "ttd_nombre", "ttd_usucreacion", "ttd_usumodificacion") values (1, 0, '2024-09-30 15:27:14.768616', '2024-10-01 10:10:40.741353', 12, 'SEGURO VIDA LEY', 'admin', 'admin');


--------------------------------------------------------
CREATE TABLE
  operaciones.tripulaciontiposdocumentos_ttd (
    ttd_id serial primary key,
    ttd_nombre varchar(40) not null,
    ttd_avisovencimiento integer NULL,
    u_ti_id integer NULL,
    ttd_usumodificacion varchar(20) NULL,
    ttd_fecmodificacion timestamp without time zone NULL DEFAULT now(),

    FOREIGN KEY (u_ti_id)
        REFERENCES unidades.tiempo(u_ti_id)
  );

  ---------------------

  CREATE TABLE
  operaciones.tripulaciontiposdocumentos_ttd (
    ttd_id serial primary key,
    ttd_nombre varchar(40) not null,
    ttd_avisovencimiento integer NULL,
    u_ti_id integer NULL,
    ttd_usumodificacion varchar(20) NULL,
    ttd_fecmodificacion timestamp without time zone NULL DEFAULT now(),

    FOREIGN KEY (u_ti_id)
        REFERENCES unidades.tiempo(u_ti_id)
  );