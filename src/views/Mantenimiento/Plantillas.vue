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
      succes: false,
      datap: [],
      tareas:[],

      tareas_ins:[],
      tareas_edit:[],

      opt_rs: [],
      opt_veh:[],
      opt_tar:[],
      opt_pla:[],
      opt_mar:[],

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
        vma_id:'',
      }),

      form_c : reactive({
        rs: '',
        vma_id: '',
        nombre:'',

        tarea_tmp:'',
      }),

      form_e : reactive({
        rs: '',
        vma_id: '',
        nombre:'',

        tarea_tmp:'',
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
      this.clear_cr();
      this.clear_tar();
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
      this.search_rs_clear();
    },

    search_rs_clear() {
      this.form_b.rs='';
      this.form_b.vma_id='';
    },

    clear_tar() {
      this.tareas=[];
      this.nueva_tarea='';
      this.nt_aviso_km='';
      this.nt_km='';
    },

    clear_cr() {
      this.opt_tar=[];
      this.opt_mar=[];

      this.form_c.rs= '';
      this.form_c.vma_id= '';
      this.form_c.nombre='';

      this.form_c.tarea_tmp='';

    },

    clear_ed() {
      this.opt_tar=[];

      this.form_e.rs= '';
      this.form_e.vma_id= '';
      this.form_e.nombre='';

      this.form_e.tarea_tmp='';

    },

    //eventos

    rs_changer(val) {
      this.emp_cont=val;
    },

    search_rs_ch(val) {
      this.form_b.vma_id='';
      this.emp_cont=val
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/borrar',
        {
          "emp_id":this.data_edit[0].emp_id,
          "vma_id":this.data_edit[0].vma_id,
          "ppa_descripcion":this.data_edit[0].ppa_descripcion
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
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos', 
      {
        "emp_id": this.form_c.rs,
        "via_fechaviaje":query
      })
      .then((resp) => {
        console.log(resp);
        this.opt_veh = resp.data;
      })
    },

    buscar_marcas(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculosmarcas', 
      {
        "emp_id":this.emp_cont,
        "vma_nombre":query
      })
      .then((resp) => {
        console.log(resp);
        this.opt_mar = resp.data;
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
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla', 
      {
        "emp_id":"",
        "vma_id":""
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

    create_pl2(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/nuevo', 
        {
          "emp_id": this.form_c.rs,
          "vma_id": this.form_c.vma_id,
          "ppa_descripcion":this.form_c.nombre,
          "detalle":this.tareas_ins,
          "ppa_usucreacion": this.$store.state.username
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Plantilla creada correctamente");
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
        if (this.opt_tar[tmp].tar_codigo == this.nueva_tarea) {
          this.tareas.push({
            "tar_descripcion":this.opt_tar[tmp].tar_descripcion,
            "ppa_avisokm":this.nt_aviso_km,
            "ppa_km":this.nt_km
          });
          this.tareas_ins.push({
            "tar_id": this.opt_tar[tmp].tar_id,
            "ppa_avisokm":this.nt_aviso_km,
            "ppa_km":this.nt_km
          });
          return;
        }
      }
    },

    insertar_tarea_act2 () {
      for (let tmp in this.opt_tar)  {
        console.log(tmp);
        if (this.opt_tar[tmp].tar_codigo == this.nueva_tarea) {
          this.tareas.push({
            "tar_descripcion":this.opt_tar[tmp].tar_descripcion,
            "ppa_avisokm":this.nt_aviso_km,
            "ppa_km":this.nt_km
          });
          this.tareas_edit.push({
            "tar_id": this.opt_tar[tmp].tar_id,
            "ppa_avisokm":this.nt_aviso_km,
            "ppa_km":this.nt_km
          });
          return;
        }
      }
    },

    eliminar_tarea_act(index) {
      this.tareas.splice(index, 1);
    },

    editar_ready() {
      this.tareas_edit=[];
      for (let index = 0; index < this.data_edit[0].detalle.length; index++) {
        this.tareas_edit.push({
          "tar_id": this.data_edit[0].detalle[index].tar_id,
          "ppa_avisokm":this.data_edit[0].detalle[index].ppa_avisokm,
          "ppa_km":this.data_edit[0].detalle[index].ppa_km
        });
      } 
    },

    editar_pl(){
      //llamada a API
      
      console.log({
          "ppa_id": this.editpointer,
          "emp_id": this.form_e.rs,
          "vma_id": this.data_edit[0].detalle[0].vma_id,
          "ppa_descripcion":this.form_e.nombre,
          "detalle":this.tareas_edit,
          "ppa_usucreacion": this.$store.state.username

        });
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/actualizar', 
        {
          "ppa_id": this.editpointer,
          "emp_id": this.form_e.rs,
          "vma_id": this.data_edit[0].vma_id,
          "ppa_descripcion":this.form_e.nombre,
          "detalle":this.tareas_edit,
          "ppa_usucreacion": this.$store.state.username
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Plantilla editada correctamente");
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

      this.form_e.nombre=this.data_edit[0].ppa_descripcion;
      this.form_e.vma_id=this.data_edit[0].vma_nombre;
      this.tareas=this.data_edit[0].detalle;
      this.editar_ready();
    },


    button_handle(number,number2,number3){
      this.clear_ed();
      this.clear_tar();
      console.log(number);
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/preventivoplantilla/det_otro',
      {       
       "emp_razonsocial": number,
       "vma_id": number2,
       "ppa_descripcion": number3
      })
        .then((resp) => {
          this.data_edit = resp.data;
          this.load_data_edit();
          this.wait = false;
        })
        .catch((e)=> {
          this.open_fail("Hubo un error con el servidor al cargar los datos, error: "+String(e));
          this.$refs.mo_editar_per.hide();
        })
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

  <div v-if="$isMobile()">
  <el-collapse>
    <el-collapse-item title="Opciones">
      <el-form :inline="true" :model="formInline" label-width="auto" size="small" >

        <el-row justify="center">
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

            <el-form-item  label="Marca asoc. ">
              <el-select
                v-model="form_b.vma_id"
                filterable
                :remote-method="buscar_marcas"
                placeholder="Inserte nombre de marca"
                remote
                clearable
                :disabled=b_rs_disable

              >
                <template #prefix>
                  <el-icon><Search /></el-icon>
                </template>
                <el-option
                  v-for="item in opt_mar"
                  :key="item.vma_id"
                  :label="item.vma_nombre"
                  :value="item.vma_id"
                />
              </el-select>
            </el-form-item>

            <div class="button-container">
              <el-row>
                <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
              </el-row>
              <el-row>
                <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
              </el-row>
            </div>
        </el-row>
      </el-form>
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
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

        <el-form-item  label="Marca asoc. ">
          <el-select
            v-model="form_b.vma_id"
            filterable
            :remote-method="buscar_marcas"
            placeholder="Inserte nombre de marca"
            remote
            clearable
            :disabled=b_rs_disable
            style="width:300px"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
            <el-option
              v-for="item in opt_mar"
              :key="item.vma_id"
              :label="item.vma_nombre"
              :value="item.vma_id"
            />
          </el-select>
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
  </div>
  

  <div class="table-container" :style='$isMobile() ? "":"width:600px;margin-left: auto;margin-right: auto;padding-right:220px"'>
    <el-table :data="datap" border header-row-style="color:black;" height="98%" :size="$isMobile() ? 'small':'default'" :default-sort="{ prop: 'emp_razonsocial', order: 'ascending' }">
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="150" align="center"/>
      <el-table-column prop="ppa_descripcion" label="Nombre" />
      <el-table-column prop="vma_nombre" label="Marca asoc."  />
      
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.emp_razonsocial,scope.row.vma_id,scope.row.ppa_descripcion)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar plan de mantenimiento" width="600px" @ok="create_pl2" @cancel="closecrear" cancel-title="Atras" centered>
  
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" :size="$isMobile() ? 'small':'default'">

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

    <el-form-item  label="Marca asoc. ">
      <el-select
        v-model="form_c.vma_id"
        filterable
        :remote-method="buscar_marcas"
        placeholder="Inserte nombre de marca"
        remote
        clearable
        :disabled=rs_disable
        style="width:300px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
        <el-option
          v-for="item in opt_mar"
          :key="item.vma_id"
          :label="item.vma_nombre"
          :value="item.vma_id"
        />
      </el-select>
    </el-form-item>

    <el-form-item  label="Nombre">
      <el-input v-model="form_c.nombre" style="width:300px"/>
    </el-form-item>
    
    <div class="table-container" :style="$isMobile() ? 'small':'width:500px;margin-left: auto;margin-right: auto'">
      <el-table :data="tareas" border header-row-style="color:black;"  height="98%" size="small">
        <el-table-column prop="tar_descripcion" label="Tarea" width="250" />
        <el-table-column prop="ppa_avisokm" label="Aviso km." align="center" />
        <el-table-column prop="ppa_km" label="Km."  align="center"/>
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
          :key="item.tar_codigo"
          :label="item.tar_descripcion"
          :value="item.tar_codigo"
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

<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de plantilla" width="600px" @ok="editar_pl" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_edit_ref" :model="form_e" label-width="150px" :size="$isMobile() ? 'small':'default'">

    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select disabled style="width:300px" v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item  label="Marca asoc. ">
      <el-input v-model="form_e.vma_id" style="width:300px" disabled/>
    </el-form-item>

    <el-form-item  label="Nombre">
      <el-input v-model="form_e.nombre" style="width:300px"/>
    </el-form-item>
    
    <div class="table-container" :style="$isMobile() ? '':'width:500px;margin-left: auto;margin-right: auto'">
      <el-table :data="tareas" border header-row-style="color:black;"  height="98%" size="small">
        <el-table-column prop="tar_descripcion" label="Tarea" width="250" />
        <el-table-column prop="ppa_avisokm" label="Aviso km." align="center" />
        <el-table-column prop="ppa_km" label="Km."  align="center"/>
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
          :key="item.tar_codigo"
          :label="item.tar_descripcion"
          :value="item.tar_codigo"
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
      <el-button color="#0844a4" :icon="Plus" :disabled='tarea_vacia' @click="insertar_tarea_act2">
        Agregar
      </el-button>
    </el-row>
    <el-row style="text-align=center" >
      <el-button style="margin-top:30px;margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar esta plantilla?')">Eliminar</el-button>
    </el-row>
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

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
  <br/> {{alert_cause}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
