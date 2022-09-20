<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, Search, Delete} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'

</script>

<script lang="ts">

import modal from "../../components/modal.vue" 
export default {
  components: {
    modal
  },
  computed: {
    rs_disable() {
      return this.form_c.rs=='';
    },
    b_rs_disable() {
      return this.form_b.rs=='';
    },
    veh_disable() {
      return this.form_c.veh_id=='';
    },
    tarea_vacia() {
      return this.nueva_tarea=='' || this.nt_km=='' || this.nt_aviso_km=='' ;
    }
  },
  data(){
    return {
      editpointer:0,
      editpointer2:0,
      succes: false,
      datap: [],
      tareas:[],

      tareas_ins:[],
      tareas_edit:[],

      opt_rs: [],
      opt_veh:[],
      opt_tar:[],
      opt_pla:[],

      data_edit: [],
      data_edit2: [],

      wait:false,
      alert_mo:'',
      emp_cont:'1',
      alert_cause:'',

      nueva_tarea:'',
      nt_km:'',
      nt_aviso_km:'',

      form_b : reactive({
        rs: '',
        placa:'',
      }),

      form_c : reactive({
        rs: '',
        veh_id: '',
        plan_id:'',
        tarea_tmp:'',
      }),

      form_e : reactive({
        rs: '',
        veh_id: '',
        tarea_tmp:'',
      }),

      form_et : reactive({
        nom: '',
        km: '',
        avisokm:'',
      }),
    }
  },

  methods: {
    //controladores de modal
    open_succes(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado.open(); 
    },
    open_succes_ed(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado_ed.open();
    },
    open_confirmar(msg) {
      this.alert_mo=msg;
      this.$refs.mo_advertencia_eliim.open(); 
    },
    close_confirmar() {
      this.$refs.mo_advertencia_eliim.hide();
    },
    close_succes() {
      this.$refs.mo_realizado.hide();
      this.api_get_all();
    },
    close_succes_all() {
      this.$refs.mo_realizado.hide();
      this.clear_c();
      this.$refs.mo_create_per.hide();
      this.$refs.mo_editar_per.hide();
      
      this.api_get_all();
      this.search_rs_clear();
    },

    close_succes_ed() {
      this.$refs.mo_realizado_ed.hide(); 
      this.$refs.mo_editar_per.hide();
      this.api_get_all();
      this.search_rs_clear();
    },

    open_succes_ed2(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado_ed2.open();
    },
    close_succes_ed2() {
      this.$refs.mo_realizado_ed2.hide();
      this.$refs.mo_edit_tar.hide();
    },

    open_fail(msg) {
      this.alert_mo=msg;
      this.$refs.mo_error.open(); 
    },
    open_fail2(msg,msg2) {
      this.alert_mo=msg;
      this.alert_cause=msg2;
      this.$refs.mo_error.open(); 
    },
    close_fail() {
      this.alert_cause="";
      this.$refs.mo_error.hide(); 
    },
    openedit() {
      this.$refs.mo_editar_per.open();
    },
    closeedit() {
      this.$refs.mo_editar_per.hide();
      this.search_rs_clear();
    },
    opencrear() {
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
      this.search_rs_clear();
    },
    closeedittar() {
      this.$refs.mo_edit_tar.hide();
      this.form_et.nom="";
      this.form_et.km="";
      this.form_et.avisokm="";
    },

    //eventos

    rs_changer(val) {
      this.emp_cont=val;
    },

    clear_c() {
      this.form_c.rs='';
      this.form_c.tipo_doc='';
      this.form_c.nro_doc='';
      this.form_c.nombre='';
      this.form_c.c_pago='';
      this.form_c.plazo='';
      this.form_c.direccion='';
      this.form_c.correo='';
      this.form_c.telefono='';
      this.form_c.c_activo='';
      this.form_c.c_habido='';
    },

    //funciones de carga

    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },


    load_edit(id,rss) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/"+String(id),
        {
          "emp_id":String(rss),
          "ext_id":this.var_type
        })
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      this.err_code=false;
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/borrar/',
        {
          "ent_id":String(this.editpointer),
          "emp_id":String(this.form_e.rs),
          "ext_id":this.var_type
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Cliente eliminado correctamente");
            this.err_code = true;
          }
          else {
            this.open_fail2("Hubo un error con el servidor al ejecutar la operación","Código de error: "+resp.data.message);
          }
        })
        setTimeout(() => {
        if (this.err_code==false) {
          this.open_fail("Hubo un error al comunicarse con el servidor, revise su conexión");
        }
        }, 700)
        
        return this.err_code;
    },

    get_vehiculos(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/placa', 
      {
        "emp_id": this.emp_cont,
        "veh_placa":query
      })
      .then((resp) => {
        console.log(resp);
        this.opt_veh = resp.data;
      })
    },

    get_plantillas() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/agrupado', 
      {
        "emp_id":this.form_c.rs,
        "veh_id":this.form_c.veh_id
      })
      .then((resp) => {
        console.log(resp);
        this.opt_pla = resp.data;
      })
    },

    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    select_plantilla() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/'+String(this.form_c.plan_id))
      .then((resp) => {
        console.log(resp);
        this.tareas = resp.data;
      })
    },

    search_tareas(key) {
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas',{
          "tar_descripcion": key,
          "emp_id": this.emp_cont
        })
        .then((resp) => {
          console.log(resp.data);
          this.opt_tar=resp.data;
        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        });
    },

    send_descarga() {
      axios
        .post('http://51.222.25.71:8080/garcal-report-api/api/clientescsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_clientes')
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
            return false;
        });
    },

    api_get_all(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento', 
      {
        "emp_id":"",
        "veh_placa":""
      })
      .then((resp) => {
        console.log(resp);
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/obtener', 
        {
          "emp_id":this.form_b.rs,
          "veh_placa":this.form_b.placa
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },

    create_tarea(req) {
      return axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/nuevo',req)
    },
    
    create_usr(){
      var requests=[];

      for (let index = 0; index < this.tareas_ins.length; index++) {
        requests.push(this.create_tarea(this.tareas_ins[index]));
      }

      console.log(requests);
      Promise.all(requests)
      .then((results) => {
        console.log(results);
        var succesful=true;
        for (let index = 0; index < results.length; index++) {
          if(results[index].status===false) {
            succesful=false;
          }
        }
        if (succesful) {
          console.log("caso 1");
          this.open_succes("Operación realizada satisfactoriamente");
          return true;
        }
        else {
          console.log("caso 2");
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      .catch((e) => {
        console.log("caso 3");
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(e));
        return false;
      });
    },  
    create_pl2(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/nuevo', 
        {
          "emp_id": this.form_c.rs,
          "veh_id": this.form_c.veh_id,
          "detalle":this.tareas_ins,
          "pma_fechamantenimiento": null,
          "pma_ultimokm": 2,
          "pma_usucreacion": this.$store.state.username

        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Plan creado correctamente");
            this.err_code = true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación","Código de error: "+resp.data.message);
          }
        })
        .catch((e)=>{
          this.open_fail("Hubo un error con el servidor al ejecutar la operación. Detalles de error: "+String(e));
        })
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    insertar_tarea_act () {
      for (let tmp in this.opt_tar)  {
        console.log(tmp);
        if (this.opt_tar[tmp].tar_id == this.nueva_tarea) {
          this.tareas.push({
            "tar_descripcion":this.opt_tar[tmp].tar_descripcion,
            "pma_avisokm":this.nt_aviso_km,
            "pma_km":this.nt_km
          });
          this.tareas_ins.push({
            "tar_id": this.opt_tar[tmp].tar_id,
            "pma_avisokm":this.nt_aviso_km,
            "pma_km":this.nt_km
          });
          return;
        }
      }
    },

    insertar_tarea_act_fn () {      
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/nuevo', 
        {
          "emp_id": this.form_e.rs,
          "veh_id": this.editpointer,
          "detalle":{
            "tar_id": this.nueva_tarea,
            "pma_avisokm":Number(this.nt_aviso_km),
            "pma_km":Number(this.nt_km)
          },
          "pma_fechamantenimiento": null,
          "pma_ultimokm": 0,
          "pma_usucreacion": this.$store.state.username

        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed2("Tarea creada correctamente");
            this.button_handle(this.editpointer);
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación","Código de error: "+resp.data.message);
          }
        })
        .catch((e)=>{
          this.open_fail("Hubo un error con el servidor al ejecutar la operación. Detalles de error: "+String(e));
        })
    },

    eliminar_tarea_act(index) {
      this.tareas.splice(index, 1);
    },


    editar_ready() {
      this.tareas_edit=[];
      for (let index = 0; index < this.data_edit[0].detalle.length; index++) {   
        this.tareas_edit.push({
          "tar_id": this.data_edit[0].detalle[index].tar_id,
          "pma_avisokm":this.data_edit[0].detalle[index].nt_aviso_km,
          "pma_km":this.data_edit[0].detalle[index].nt_km
        });
      } 
    },

    get_tar(id) {
      for (let index = 0; index < this.data_edit[0].detalle.length; index++) {   
        if(this.data_edit[0].detalle[index].pma_id==id) {
          this.form_et.nom=this.data_edit[0].detalle[index].tar_descripcion;
          this.form_et.km=this.data_edit[0].detalle[index].pma_km;
          this.form_et.avisokm=this.data_edit[0].detalle[index].pma_avisokm;
        }
      } 
    },

    edit_tar() {
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/actualizar', 
        {
          "pma_id": this.editpointer2,
          "pma_avisokm": this.form_et.avisokm,
          "pma_km": this.form_et.km,
          "pma_usucreacion":this.$store.state.username
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed2("Tarea editada correctamente");
            this.button_handle(this.editpointer);
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          }
        })
        .catch((e)=>{
          this.open_fail("Hubo un error con el servidor al ejecutar la operación. Detalles de error: "+String(e));
        })
    },

    editar_pl(){
      //llamada a API
      this.editar_ready();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/nuevo', 
        {
          "emp_id": this.form_e.rs,
          "veh_id": this.form_e.veh_id,
          "detalle":this.tareas_edit,
          "pma_fechamantenimiento": null,
          "pma_ultimokm": 2,
          "pma_usucreacion": this.$store.state.username

        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Plan editado correctamente");
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          }
        })
        .catch((e)=>{
          this.open_fail("Hubo un error con el servidor al ejecutar la operación. Detalles de error: "+String(e));
        })
    },

    load_data_edit() {
      console.log(this.data_edit);
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.get_vehiculos('');
      this.form_e.veh_id=this.data_edit[0].veh_id;
      this.tareas=this.data_edit[0].detalle;
    },

    button_handle(number){
      console.log(number);
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/programacionmantenimiento/buscar',
      {
        "veh_id":number
      })
        .then((resp) => {
          this.data_edit = resp.data;
          this.load_data_edit();
          this.emp_cont=this.form_e.rs;
          this.wait = false;
        })
        .catch((e)=> {
          this.open_fail("Hubo un error con el servidor al cargar los datos, error: "+String(e));
          this.$refs.mo_editar_per.hide();
        })
    },

    button_handle2(number){
      console.log(number);
      this.editpointer2=number;
      this.$refs.mo_edit_tar.open();
      this.get_tar(number);
    }
  },

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
  },
}

</script>


<template>

<div class="main-container">
  <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
    <el-row>
      <el-col :span="21">
        <el-form-item label="Razón social">
          <el-select v-model="form_b.rs" @change="search_rs_ch" @clear="search_rs_clear" placeholder="Seleccionar" clearable>
            <el-option
              v-for="item in opt_rs"
              :key="item.emp_id"
              :label="item.emp_razonsocial"
              :value="item.emp_id"
            > </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="Nro. de placa">
          <el-input v-model="form_b.placa" clearable />
        </el-form-item>
      </el-col>

      <el-col :span="3">
        <div class="button-container">
          <el-row>
            <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
          </el-row>
          <el-row>
            <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
          </el-row>
        </div>
      </el-col>
    </el-row>

  </el-form>

  <div class="table-container" style="width:600px;margin-left: auto;margin-right: auto;padding-right:220px">
    <el-table :data="datap" border header-row-style="color:black;"  height="98%">
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="150" align="center"/>
      <el-table-column prop="veh_placa" label="Placa"  />
      <el-table-column prop="tar_cantidad" label="Nro. de tareas" width="180" align="center"/>
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.veh_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar plan de mantenimiento" width="600px" @ok="create_pl2" @cancel="closecrear" cancel-title="Atras" centered>
  
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >

    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select style="width:300px" v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item  label="Vehiculo">
      <el-select
        v-model="form_c.veh_id"
        filterable
        :remote-method="get_vehiculos"
        placeholder="Inserte ID de vehiculo"
        remote
        clearable
        :disabled=rs_disable
        @change="get_plantillas"
        style="width:300px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_veh"
          :key="item.veh_placa"
          :label="item.veh_placa"
          :value="item.veh_id"
        />
      </el-select>
    </el-form-item>

    <el-form-item  label="Plantilla ">
      <el-select
        v-model="form_c.plan_id"
        placeholder="Seleccione una plantilla"
        clearable
        :disabled=veh_disable
        style="width:300px"
        @change="select_plantilla"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_pla"
          :key="item.ppa_id"
          :label="item.ppa_descripcion"
          :value="item.ppa_id"
          
        />
      </el-select>
    </el-form-item>
    
    <div class="table-container" style="width:500px;margin-left: auto;margin-right: auto">
      <el-table :data="tareas" border header-row-style="color:black;"  height="98%" size="small">
        <el-table-column prop="tar_descripcion" label="Tarea" width="250" />
        <el-table-column prop="pma_avisokm" label="Aviso km." align="center" />
        <el-table-column prop="pma_km" label="Km."  align="center"/>
        <el-table-column fixed="right" label="" width="45" align="center">
          <template #default="scope">
            <el-button  type="text"  @click="eliminar_tarea_act(scope.$index)" ><el-icon :size="17"><Delete /></el-icon></el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>


    <el-row justify="center">

      <el-select
        v-model="nueva_tarea"
        filterable
        :remote-method="search_tareas"
        placeholder="Tarea"
        remote
        clearable
        :disabled=veh_disable
        style="width:150px;padding-right:5px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_tar"
          :key="item.tar_id"
          :label="item.tar_descripcion"
          :value="item.tar_id"
        />
      </el-select>
      <el-input
        v-model="nt_aviso_km"
        placeholder="Aviso km"
        clearable
        :disabled=veh_disable
        style="width:90px;padding-right:5px"
      />
      <el-input
        v-model="nt_km"
        placeholder="Km"
        clearable
        :disabled=veh_disable
        style="width:90px;padding-right:10px"
      />
      <el-button color="#0844a4" :icon="Plus" :disabled='tarea_vacia' @click="insertar_tarea_act">
        Agregar
      </el-button>
    </el-row>

  </el-form>
</modal>

<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de plan de mantenimiento" width="600px" @ok="editar_pl" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_edit_ref" :model="form_e" label-width="150px" >

    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select style="width:300px" v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar" disabled>
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item  label="Vehiculo ">
      <el-select
        v-model="form_e.veh_id"
        filterable
        :remote-method="get_vehiculos"
        placeholder="Inserte ID de vehiculo"
        remote
        clearable
        :disabled=rs_disable
        @change="get_plantillas"
        style="width:300px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_veh"
          :key="item.veh_id"
          :label="item.veh_placa"
          :value="item.veh_id"
        />
      </el-select>
    </el-form-item>
    
    <div class="table-container" style="width:500px;margin-left: auto;margin-right: auto">
      <el-table :data="tareas" border header-row-style="color:black;"  height="98%" size="small">
        <el-table-column prop="tar_descripcion" label="Tarea" width="250" />
        <el-table-column prop="pma_avisokm" label="Aviso km." align="center" />
        <el-table-column prop="pma_km" label="Km."  align="center"/>
        <el-table-column fixed="right" label="" width="45" align="center">
          <template #default="scope">
            <el-button  type="text"  @click="button_handle2(scope.row.pma_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>


    <el-row justify="center">

      <el-select
        v-model="nueva_tarea"
        filterable
        :remote-method="search_tareas"
        placeholder="Tarea"
        remote
        clearable

        style="width:150px;padding-right:5px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_tar"
          :key="item.tar_id"
          :label="item.tar_descripcion"
          :value="item.tar_id"
        />
      </el-select>
      <el-input
        v-model="nt_aviso_km"
        placeholder="Aviso km"
        clearable
        style="width:90px;padding-right:5px"
      />
      <el-input
        v-model="nt_km"
        placeholder="Km"
        clearable
        style="width:90px;padding-right:10px"
      />
      <el-button color="#0844a4" :icon="Plus" :disabled='tarea_vacia' @click="insertar_tarea_act_fn">
        Agregar
      </el-button>
    </el-row>

  </el-form>
</modal>

<modal ref="mo_edit_tar" no-close-on-backdrop title="Editar tarea" width="500px" @ok="edit_tar" @cancel="closeedittar" cancel-title="Atras" centered>
  <el-form  @submit.prevent ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >
    
    <el-form-item label="Nombre de ubigeo">
      <el-input disabled v-model="form_et.nom" />
    </el-form-item>

    <el-form-item label="Aviso km.">
      <el-input v-model="form_et.avisokm" />
    </el-form-item>

    <el-form-item label="Km.">
      <el-input v-model="form_et.km" />
    </el-form-item>

    

  </el-form>
</modal>

<modal ref="mo_advertencia_eliim" title="Confirmar" centered @ok="send_delete" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_ed" hide-cancel success title="Operacion completada" centered @ok="close_succes_ed" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_ed2" hide-cancel success title="Operacion completada" centered @ok="close_succes_ed2" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
  <br/> {{alert_cause}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
