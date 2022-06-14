<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'

const checkyear = (rule: any, value: any, callback: any) => {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!/^[0-9][0-9][0-9][0-9]/.test(value)) {
      callback(new Error('Sólo se permiten números'));
    }
    else {
      callback()
    }
  }, 500)
}

const form_cref = ref<FormInstance>();

const rules = reactive({
  rs:[{ 
      type: 'number',
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  placa: [{ 
      required: true,
      message: 'Por favor inserte un nro de placa o id',
      trigger: 'blur',
    },
  ],

  marca:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  modelo:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  clase:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  tipo:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  year:[
    {required: true, message: 'Inserte un año'},
    {validator: checkyear, trigger: 'blur' },
  ],
})
</script>

<script lang="ts">
import Sidebar from "../../components/Sidebar.vue"
import modal from "../../components/modal.vue"
export default {
  components: {
    Sidebar,
    modal
  },
  data(){
    return {
      editpointer:0,
      edit_rs:0,
      succes: false,
      operarios_id:[2,4],

      datap: [],
      opt_rs: [],
      placa_act:"",
      tipo_act:"",

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      open_op:false,
      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',

      form_b : reactive({
        rs: '',
        placa: '',
        marca: '',
        modelo: '',
        fecha_i: '',
        fecha_f: '',
      }),

      form_c : reactive({
        rs: '',
        placa: '',
        marca: '',
        modelo: '',
        tipo: '',
        clase: '',
        year: '',
        serie: '',
        mtc: '',
        carga_util:'',
        kilometraje: '',
      }),

      form_e : reactive({
        rs: '',
        placa: '',
        tipo_doc: '',
        ent_emisora: '',
        fech_emision: '',
        fech_venc: '',
      }),
    }
  },
 
  methods: {

    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.modelo="";
      this.form_b.marca="";

      //cargar listas
      this.load_mar();
      this.load_mod();
    },

    colorer(a,b,x,y) {
      
    },
    search_rs_clear() {
      this.form_b.contrato="";
      this.form_b.tipo="";
      this.opt_tc = [];
      this.opt_pues = [];
    },
    clear_c() {
      this.form_c.rs='';
      this.form_c.placa='';
      this.form_c.marca='';
      this.form_c.modelo='';
      this.form_c.tipo='';
      this.form_c.clase='';
      this.form_c.year='';
      this.form_c.serie='';
      this.form_c.mtc='';
      this.form_c.carga_uti='';
      this.form_c.kilometraje='';
    },

    clear_eop() {
      this.form_e_op.nro_lic= '';
      this.form_e_op.cat_lic= '';
      this.form_e_op.esp= '';
      this.form_e_op.ins_iqbf= null;
      this.form_e_op.venc_lic= null;
    },

    rs_changer() {
      this.emp_cont=this.form_c.rs;
      this.form_c.modelo="";
      this.form_c.marca="";
      this.form_c.clase="";
      this.form_c.tipo="";
      //cargar listas
      this.load_mar();
      this.load_mod();
      this.load_cla();
      this.load_ti();
    },

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
    close_fail() {
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
      this.open_op=false;
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
      this.search_rs_clear();
    },
    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },
    load_mar() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosmarcas/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mar = resp.data;
        })
    },
    load_mod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosmodelos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mod = resp.data;
        })
    },
    load_cla() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosclases/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_cla = resp.data;
        })
    },
    load_ti() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculostipos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_ti = resp.data;
        })
    },
    load_esp() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/especialidad/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_esp = resp.data;
        })
    },

    load_edit(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Vehiculo eliminado correctamente");
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        return false;
    },


    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.load_mar();
      this.load_mod();
      this.load_cla();
      this.load_ti();

      this.form_e.placa=this.data_edit[0].veh_placa;
      this.form_e.marca=this.data_edit[0].vma_id;
      this.form_e.modelo=this.data_edit[0].vmo_id;
      this.form_e.tipo=this.data_edit[0].vti_id;
      this.form_e.clase=this.data_edit[0].vcl_id;
      this.form_e.year=String(this.data_edit[0].veh_anno);
      this.form_e.serie=this.data_edit[0].veh_serie;
      this.form_e.mtc=this.data_edit[0].veh_mtc;
      this.form_e.carga_util=this.data_edit[0].veh_cargautil;
      this.form_e.kilometraje=this.data_edit[0].veh_kilometraje;
    },

    api_get_all(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos',
        {
          "emp_id": "",
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos', 
        {
          "emp_id": String(this.form_b.rs),
          "veh_placa":this.form_b.placa,
          "vma_nombre":this.form_b.marca,
          "vmo_nombre":this.form_b.modelo,
          "veh_anno_inicio":String(this.form_b.fecha_i),
          "veh_anno_fin":String(this.form_b.fecha_f)
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    async create_usr(){
      //llamada a API
      if (!this.form_cref) return
      await this.form_cref.validate((valid, fields) => {
        if (valid) {
          console.log(this.form_c.year);

          axios
          .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/nuevo', 
          { 
            "emp_id": String(this.form_c.rs),
            "veh_placa":this.form_c.placa,
            "vma_id": String(this.form_c.marca),
            "vmo_id": String(this.form_c.modelo),
            "vti_id": this.form_c.tipo,
            "vcl_id": this.form_c.clase,
            "veh_anno":this.form_c.year,
            "veh_usucreacion":"admin",
            "veh_serie":this.form_c.serie,
            "veh_mtc":this.form_c.mtc,
            "veh_cargautil":String(this.form_c.carga_util),
            "veh_kilometraje":String(this.form_c.kilometraje)
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
          return false;
          } 
        else {
          console.log('Error en campos', fields);
          return;
        }
      })
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    send_editar_doc(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/nuevo', 
        { 
          "veh_id":String(this.editpointer),
          "emp_id": String(this.edit_rs),
          "veh_placa":this.form_e.placa,
          "vtd_id":2,
          "vxd_entidademisora":this.form_e.ent_emisora,
          "vxd_fechaemision":this.form_e.fech_emision,
          "vxd_fechavencimiento":this.form_e.fech_venc,
          "vxd_usucreacion":"admin"
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Vehiculo modificado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
          console.log(resp);
        })
        return false;
    },

    button_handle(obj,index){
      console.log(obj);
      this.clear_eop;
      this.editpointer=obj.veh_id;
      this.edit_rs=obj.emp_id;
      this.edit_placa=obj.veh_placa;
      //this.editpointer=number;
      this.$refs.mo_editar_per.open();
      switch(index)
      {
      case 2:
        this.placa_act=this.edit_placa;
        this.tipo_act="CITV 6m";
        if(!obj.CITV6m) {
          return 
        }
        this.form_e.fech_venc=obj.CITV6m[0].fecha;

      break;
      case 3:
        if(!obj.row.CITV12m) {
          return 
        }
        if (obj.row.CITV12m[0].color=="#92d36e") {
          
          return "cell-1";
        }
        if (obj.row.CITV12m[0].color=="#ff3823") {
          
          return "cell-3";
        }


      break;
      case 4:
        if(!obj.row.SOAT) {
          return 
        }
        if (obj.row.SOAT[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 5:
        if(!obj.row.POLIZA) {
          return 
        }
        if (obj.row.POLIZA[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 6:
        if(!obj.row.ELEMPELIGROSOS) {
          return 
        }
        if (obj.row.ELEMPELIGROSOS[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 7:
        if(!obj.row.BONIFICACION) {
          return 
        }
        if (obj.row.BONIFICACION[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 8:
        if(!obj.row.HERMETECIDAD) {
          return 
        }
        if (obj.row.HERMETECIDAD[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;

      default:
      //default statement or expression;
      }
      //this.wait = true;
      //this.load_edit(number);
      
      //setTimeout(() => {
        //this.load_data_edit();
        //this.emp_cont=this.form_e.rs;
        //this.wait = false;
      //}, 400)
    },

    cellStyle2(obj) {
      switch(obj.columnIndex)
      {
      case 2:
        if(!obj.row.CITV6m) {
          return 
        }
        if (obj.row.CITV6m[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 3:
        if(!obj.row.CITV12m) {
          return 
        }
        if (obj.row.CITV12m[0].color=="#92d36e") {
          
          return "cell-1";
        }
        if (obj.row.CITV12m[0].color=="#ff3823") {
          
          return "cell-3";
        }


      break;
      case 4:
        if(!obj.row.SOAT) {
          return 
        }
        if (obj.row.SOAT[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 5:
        if(!obj.row.POLIZA) {
          return 
        }
        if (obj.row.POLIZA[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 6:
        if(!obj.row.ELEMPELIGROSOS) {
          return 
        }
        if (obj.row.ELEMPELIGROSOS[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 7:
        if(!obj.row.BONIFICACION) {
          return 
        }
        if (obj.row.BONIFICACION[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;
      case 8:
        if(!obj.row.HERMETECIDAD) {
          return 
        }
        if (obj.row.HERMETECIDAD[0].color=="#92d36e") {
          
          return "cell-1";
        }
      break;

      default:
      //default statement or expression;
      }

    },
    charger(obj,idx) {
      
    },
    get_nombre(obj,idx) {

      switch(idx)
      {
      case 2:
        if(!obj.CITV6m) {
          return "No info"
        }
        else {
          return obj.CITV6m[0].fecha
        }
      break;
      case 3:
        if(!obj.CITV12m) {
          return "No info"
        }
        else {
          return obj.CITV12m[0].fecha
        }

      break;
      case 4:
        if(!obj.SOAT) {
          return "No info"
        }
        else {
          return obj.SOAT[0].fecha
        }
      break;
      case 5:
        if(!obj.POLIZA) {
          return "No info"
        }
        else {
          return obj.POLIZA[0].fecha
        }
      break;
      case 6:
        if(!obj.ELEMPELIGROSOS) {
          return "No info"
        }
        else {
          return obj.ELEMPELIGROSOS[0].fecha
        }
      break;
      case 7:
        if(!obj.BONIFICACION) {
          return "No info"
        }
        else {
          return obj.BONIFICACION[0].fecha
        }
      break;
      case 8:
        if(!obj.HERMETECIDAD) {
          return "No info"
        }
        else {
          return obj.HERMETECIDAD[0].fecha
        }
      break;

      default:
      //default statement or expression;
      }
    }
  },
  

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
  <el-container class="layout-container" style="height: calc( 100vh - 20px );">
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          Documentos > Vehículos
        </el-tag>
      </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
      </el-col>
    </el-header>

    <el-container style="height: calc( 100vh - 100px );">
      <el-aside width="200px">
        <el-scrollbar>
          <Sidebar />
        </el-scrollbar>
      </el-aside>

      <el-main style="background-color:white">
        <el-scrollbar>
          
          <el-form  :inline="true" :model="form" label-width="auto" :size="small"  >
            <el-row style="widht:100%"> 
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
              
              <el-form-item label="Placa">
                <el-input v-model="form_b.placa" />
              </el-form-item>

            </el-col>
            <el-col :span="3">               
              <div class="button-container">
                <el-row class="mb-4">
                  <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
                </el-row>
              </div>    
            </el-col>
            </el-row>
            
            </el-form>
          
          <div class="table-container">
          <el-table :cell-class-name="cellStyle2" :data="datap" border header-row-style="color:black;"  >
              <el-table-column align="center" prop="emp_razonsocial" label="Razon soc. aso. " width="130" />
              <el-table-column prop="veh_placa" label="Placa " width="140" />
              <el-table-column label="CITV 6m" width="150">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,2)" >{{get_nombre(scope.row,2)}}</el-button>
                </template>
              </el-table-column>
              <el-table-column label="CITV 12m" width="150">
                <template #default="scope">
                  <el-link  type="text"  @click="button_handle(scope.row,3)" >{{get_nombre(scope.row,3)}}</el-link>
                </template>
              </el-table-column>
              <el-table-column label="SOAT" width="150">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,4)" >{{get_nombre(scope.row,4)}}</el-button>
                </template>
              </el-table-column>
              <el-table-column label="POLIZA" width="150">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,5)" >{{get_nombre(scope.row,5)}}</el-button>
                </template>
              </el-table-column>
              <el-table-column label="ELEM. PELIGROSOS" width="170">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,6)" >{{get_nombre(scope.row,6)}}</el-button>
                </template>
              </el-table-column>
              <el-table-column label="BONIFICACIÓN" width="150">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,7)" >{{get_nombre(scope.row,7)}}</el-button>
                </template>
              </el-table-column>
              <el-table-column label="HERMETICIDAD" width="150">
                <template #default="scope">
                  <el-button  type="text"  @click="button_handle(scope.row,8)" >{{get_nombre(scope.row,8)}}</el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
          
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Vehiculo" width="500px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >

    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Placa o ID" prop="placa">
      <el-input v-model="form_c.placa" />
    </el-form-item>
    
    <hr size="1" color="gray"> 

    <el-form-item label="Marca" prop="marca">
      <el-select  v-model="form_c.marca" default-first-option>
        <el-option
          v-for="item in opt_mar"
          :key="item.vma_id"
          :label="item.vma_nombre"
          :value="item.vma_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Modelo" prop="modelo">
      <el-select  v-model="form_c.modelo" default-first-option>
        <el-option
          v-for="item in opt_mod"
          :key="item.vmo_id"
          :label="item.vmo_nombre"
          :value="item.vmo_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Año" prop="year">
      <el-date-picker
          v-model="form_c.year"
          format="YYYY"
          value-format="YYYY"
          type="year"
          placeholder="Seleccione año"
      />
    </el-form-item>
    <el-form-item label="Clase" prop="clase">
      <el-select  v-model="form_c.clase"  @change="check_op" default-first-option>
        <el-option
          v-for="item in opt_cla"
          :key="item.vcl_id"
          :label="item.vcl_nombre"
          :value="item.vcl_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Tipo" prop="tipo">
      <el-select  v-model="form_c.tipo"  @change="check_op" default-first-option>
        <el-option
          v-for="item in opt_ti"
          :key="item.vti_id"
          :label="item.vti_nombre"
          :value="item.vti_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Nro. de serie">
      <el-input v-model="form_c.serie" />
    </el-form-item>

    <el-form-item label="Código MTC">
      <el-input v-model="form_c.mtc" />
    </el-form-item>

    <el-form-item label="Carga útil">
      <el-input v-model="form_c.carga_util" />
    </el-form-item>
    <hr> 
    
    <el-form-item label="Km. estimado">
      <el-input v-model="form_c.kilometraje" />
    </el-form-item>
    
    <hr>  

  </el-form>
</modal>



<modal ref="mo_editar_per" no-close-on-backdrop title="Detalles" width="500px" @ok="editar_usr" cancel-title="Atrás" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >
    <el-row style="text-align=center">
    <div style="margin-left: auto;margin-right: auto;text-align=center">
      <h4>Placa: {{placa_act}}</h4>
      <h4>Tipo de doc.: {{tipo_act}}</h4>
    </div>
    </el-row>
    
    <el-form-item label="Fecha de emisión">
      <el-date-picker
          v-model="form_e.fech_emision"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
      />
    </el-form-item>
    <el-form-item label="Fecha de vencimiento">
      <el-date-picker
          v-model="form_e.fech_venc"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
      />
    </el-form-item>

    <el-form-item  label="Entidad emisora">
      <el-input autosize style="width=10px" v-model="form_e.ent_emisora" />
    </el-form-item>


    <el-row style="text-align=center">
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar este vehiculo?')">Eliminar</el-button>
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
</modal>

</template>

<style>
.el-table .cell-1 {
  background: #92d36e;
}

.el-table .cell-2 {
  background: #fcee57;
}
.el-table .cell-3 {
  background: #fb2525;
  color: white;
}
.el-table .cell-3 .el-link {
  color: white;
}
.el-table .cell-3 .el-link :hover{
  color: black;
}
</style>


<style scoped>

.layout-container .el-header {
  position: relative;
  background-color: rgb(8, 68, 164);
  color: rgb(240, 240, 240);
  text-align: left;
  font-family: "Roboto", sans-serif;
}
.layout-container .el-aside {
  color: var(--el-text-color-primary);
  background: white;
}
.layout-container .el-menu {
  border-right: none;
}
.layout-container .el-main {
  padding: 0;
}
.layout-container .el-header {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}
.layout-container .el-form {
  padding-top: 15px;
  background-color: white;
}

.form-container {
  width: 100%;
}

.table-container {
  padding: 20px;
}


.el-table {
  font-family: "Roboto", sans-serif;
  --el-table-header-bg-color:rgb(199, 199, 199);
}

.el-col {
  text-align:center;
}

.el-row {
  margin-bottom: 5px;
}


.button-container .el-button {
  width: 100px;
  border-radius: 20px;
}



.layout-container .toolbar {
  display: block;
  text-align: left;
  margin-left: 0;
  margin-right: auto;
}

.layout-container .sitebar {
  display: block;
  text-align: center;
  margin-left: auto;
  margin-right: auto;
}
</style>
