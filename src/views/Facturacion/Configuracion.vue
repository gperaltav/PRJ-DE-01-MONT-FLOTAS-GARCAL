<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, Search} from '@element-plus/icons-vue'

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
    }
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      datap: [],

      opt_rs: [],
      opt_veh:[],

      data_edit: [],
      data_edit2: [],

      wait:false,
      alert_mo:'',
      emp_cont:'1',
      alert_cause:'',

      form_b : reactive({
        rs: '',
        nro_doc: '',
        nombre: '',
        f_pago: '',
      }),

      form_c : reactive({
        rs: '',
        veh_id: '',
        gti:'',
        serie:'',
        n_min:'',
        n_max:'',
        estado:false,
      }),

      form_e : reactive({
        rs: '',
        veh_id: '',
        gti:'',
        serie:'',
        n_min:'',
        n_max:'',
        estado:false,
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
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
      this.search_rs_clear();
    },

    //eventos

    rs_changer() {
      this.emp_cont=this.form_c.rs;
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
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
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
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
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
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Cliente eliminado correctamente");
            this.err_code = true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          }
        })
        .catch((error) => {
          this.open_fail("Hubo un error interno al ejecutar la operación, error: "+String(error));
          return false;
        });
        
        return this.err_code;
    },

    get_vehiculos(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos', 
      {
        "emp_id": this.form_c.rs,
        "via_fechaviaje":query
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp);
        this.opt_veh = resp.data;
      })
    },

    load_data_edit() {
      console.log(this.data_edit);
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.get_vehiculos('');

      this.form_e.veh_id=this.data_edit[0].veh_id;
      this.form_e.gti=this.data_edit[0].gti_codigo;

      this.form_e.n_min=this.data_edit[0].gco_numeromin;
      this.form_e.n_max=this.data_edit[0].gco_numeromax;
      this.form_e.estado=this.data_edit[0].gco_activo;
      this.form_e.serie=this.data_edit[0].gco_serie;

    },

    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    send_descarga() {
      axios
        .post('http://51.222.25.71:8080/garcal-report-api/api/guiasconfiguracioncsv',{},{ 
          headers:{
          "x-api-key":this.$store.state.api_key1
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_configuracion_facturacion')
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch((error) => {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
            return false;
        });
    },

    api_get_all(){
     axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guiasconfiguracion', 
      {
        "veh_placa":""
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad', 
        {
          "emp_id": String(this.form_b.rs),
          "ext_id":this.var_type,
          "ent_nombre":this.form_b.nombre, 
          "ent_nrodocumento":this.form_b.nro_doc,
          "fdp_id":this.form_b.f_pago,
          "pro_descripcion":""
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guiasconfiguracion/nuevo', 
      { 
        "emp_id": Number(this.form_c.rs),
        "gti_codigo":this.form_c.gti,
        "gco_serie": this.form_c.serie,
        "veh_id": this.form_c.veh_id,
        "gco_activo": this.form_c.estado,
        "gco_numeromin": this.form_c.n_min,
        "gco_numeromax": this.form_c.n_max,
        "gco_usucreacion": this.$store.state.username
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          return true;
          
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      .catch((error) => {
        this.open_fail("Hubo un error interno al ejecutar la operación, error: "+String(error));
        return false;
      });
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guiasconfiguracion/actualizar', 
        { 
          "gco_id": Number(this.editpointer),
          "emp_id": Number(this.form_e.rs),
          "gti_codigo":this.form_e.gti,
          "gco_serie": this.form_e.serie,
          "veh_id": this.form_e.veh_id,
          "gco_activo": this.form_e.estado,
          "gco_numeromin": this.form_e.n_min,
          "gco_numeromax": this.form_e.n_max,
          "gco_usucreacion": this.$store.state.username
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Configuracion configurada satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
          console.log(resp);
        })
        .catch((error)=> {
          this.open_fail("Hubo un error interno al ejecutar la operación, error: "+String(error));
          return false;
        })
    },

    button_handle(number){
      console.log(number);
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/guiasconfiguracion/'+String(number),{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          this.data_edit = resp.data;
          this.load_data_edit();
          this.emp_cont=this.form_e.rs;
          this.wait = false;
        })
        .catch((error)=> {
          this.open_fail("Hubo un error con el servidor al cargar los datos, error: "+String(error));
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
      <el-form @submit.prevent :inline="true" :model="formInline" label-width="auto" size="small" >
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

        <el-form-item label="Nro. de placa">
          <el-input v-model="form_b.nombre" clearable />
        </el-form-item>

        
        <div class="button-container">
        <el-row class="mb-4">
          <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
        </el-row>
        <el-row class="mb-4">
          <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
        </el-row>
        <el-row class="mb-4">
          <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
        </el-row>
        </div>

    </el-row>

    </el-form>
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
    <el-form @submit.prevent :inline="true" :model="formInline" label-width="auto" :size="small" >
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
          <el-input v-model="form_b.nombre" clearable />
        </el-form-item>
      </el-col>

      <el-col :span="3">
        
        <div class="button-container">
        <el-row class="mb-4">
          <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
        </el-row>
        <el-row class="mb-4">
          <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
        </el-row>
        <el-row class="mb-4">
          <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
        </el-row>
        </div>
      
      </el-col>
    </el-row>

    </el-form>
  </div>
  

  <div class="table-container">
    <el-table :data="datap" border header-row-style="color:black;" height="98%" :size="$isMobile() ? 'small':'default'">
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="140" align="center"/>
      <el-table-column
        prop="gco_activo"
        label="Activo?"
        width="90"
        align="center"

        filter-placement="bottom-end"
      >
        <template #default="scope">
          <el-tag
            :type="scope.row.gco_activo === true ?'success' : 'danger'"
            disable-transitions
            >{{ scope.row.gco_activo === true ? "Si" : "No" }}</el-tag
          >
        </template>
      </el-table-column>

      <el-table-column prop="gti_descripcion" label="Tipo de guia" width="190" />
      <el-table-column prop="gco_serie" label="Serie" width="180" />
      <el-table-column prop="gco_numeromax" label="Nro. máximo" />  
      <el-table-column prop="gco_numeromin" label="Nro. mínimo" />  
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.gco_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
    </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar guia de configuración" width="500px" @ok="create_usr()" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form @submit.prevent  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >

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

    <el-form-item label="Serie">
      <el-input style="width:300px" v-model="form_c.serie" />
    </el-form-item>

    <el-form-item  label="Vehiculo ">
      <el-select
        v-model="form_c.veh_id"
        filterable
        :remote-method="get_vehiculos"
        placeholder="Inserte ID de vehiculo"
        remote
        clearable
        :disabled=rs_disable
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
    
    <el-form-item label="Tipo de guía">
      <el-select style="width:300px" v-model="form_c.gti">
        <el-option label="GUIA REMITENTE" value="GEM" />
        <el-option label="GUIA DE TRANSPORTISTA" value="GTR" />
      </el-select>
    </el-form-item>

    <el-form-item label="Nro. Minimo">
      <el-input style="width:300px" v-model="form_c.n_min" />
    </el-form-item>

    <el-form-item label="Nro. Máximo">
      <el-input style="width:300px" v-model="form_c.n_max" />
    </el-form-item>

    <div style="text-align:center">
      <el-checkbox v-model="form_c.estado" label="Guia activa" />
    </div>

  </el-form>
</modal>

<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Cliente" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form @submit.prevent v-loading="wait" ref="form_edit_ref" :model="form_e" label-width="150px" >

    <el-form-item  label="Razón soc. asoc." >
      <el-select disabled style="width:300px" v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Serie">
      <el-input style="width:300px" v-model="form_e.serie" />
    </el-form-item>

    <el-form-item  label="Vehiculo ">
      <el-select
        v-model="form_e.veh_id"
        filterable
        :remote-method="get_vehiculos"
        placeholder="Inserte ID de vehiculo"
        remote
        clearable
        disabled
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
    
    <el-form-item label="Tipo de guía">
      <el-select style="width:300px" v-model="form_e.gti">
        <el-option label="GUIA REMITENTE" value="GEM" />
        <el-option label="GUIA DE TRANSPORTISTA" value="GTR" />
      </el-select>
    </el-form-item>

    <el-form-item label="Nro. Minimo">
      <el-input style="width:300px" v-model="form_e.n_min" />
    </el-form-item>

    <el-form-item label="Nro. Máximo">
      <el-input style="width:300px" v-model="form_e.n_max" />
    </el-form-item>

    <div style="text-align:center">
      <el-checkbox v-model="form_e.estado" label="Guia activa" />
    </div>

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
