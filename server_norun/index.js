const express = require('express');
//solve cors issue
const cors = require("cors");
const app = express();
app.use(cors());
const port = 5000;
const Pool = require('pg').Pool;
  //Enter here your Postres database details
  const pool = new Pool({
    user: 'integra',
    host: '51.222.25.71',
    database: 'garcal-db-test',
    password: 'integra',
    dialect: 'postgres',
    port: 5432
});
  
  //Database connection and also please create postgres database first
pool.connect((err, client, release) => {
  if (err) {
    return console.error(
      'Error conectando al cliente \n', err.stack)
  }
  client.query('SELECT NOW()', (err, result) => {
    release()
    if (err) {
      return console.error(
        'Error ejecutando conmsulta \n', err.stack)
    }
    console.log("Connectado a la Base de datos !")
  })
})
  
app.get('/usuarios_a', (req, res, next) => {
  console.log("Datos de usuarios :");
  pool.query('Select * from fun_get_usuarios_all()')
    .then(testData => {
      console.log(testData);
      res.send(testData.rows);
    })
})

app.get('/usuarios', (req, res, next) => {
  console.log("Datos de usuarios 2 :");
  nam=req.query.name;
  
  qu="Select * from fun_get_usuarios('"+String(nam)+"','','')"
  pool.query(qu)
    .then(testData => {
      res.send(testData.rows);
    })
})

app.get('/vehiculos', (req, res, next) => {
  console.log("Datos de usuarios :");
  pool.query('SELECT veh_id, emp_razonsocial, veh_placa, vcl_nombre, vti_nombre, vma_nombre, vmo_nombre, veh_anno, veh_serie, veh_mtc, veh_cargautil, veh_kilometraje FROM ((((operaciones.vehiculos_veh INNER JOIN operaciones.vehiculosmarcas_vma USING (vma_id)) INNER JOIN operaciones.vehiculostipos_vti USING (vti_id)) INNER JOIN operaciones.vehiculosclases_vcl USING (vcl_id)) INNER JOIN operaciones.vehiculosmodelos_vmo USING (vmo_id)) INNER JOIN (select emp_id,emp_razonsocial from public.empresas_emp ) as part1 USING (emp_id)')
    .then(testData => {
      console.log(testData);
      res.send(testData.rows);
    })
})

app.get('/clientes', (req, res, next) => {
  console.log("Datos de usuarios :");
  pool.query('SELECT *,concat_ws(" ",ent_nombre,ent_apellidopaterno, ent_apellidomaterno) as nnombre FROM (public.entidadestiposxentidades_exe inner join public.entidades_ent using (ent_id)) inner join public.entidadestipos_ext using (ext_id) WHERE ext_id="cli" order by ent_feccreacion desc')
    .then(testData => {
      console.log(testData);
      res.send(testData.rows);
    })
})

app.get('/trabajadores', (req, res, next) => {
  console.log("Datos de usuarios :");
  pool.query('SELECT * FROM (rrhh.trabajadores_tra inner join rrhh.puestos_pue using (pue_id)) inner join (select emp_id,emp_razonsocial from public.empresas_emp ) as empresas using (emp_id) order by tra_feccreacion desc')
    .then(testData => {
      console.log(testData);
      res.send(testData.rows);
    })
})

app.listen(port, () => {
  console.log(`Aplicacion corriendo en puerto ${port}.`);
});