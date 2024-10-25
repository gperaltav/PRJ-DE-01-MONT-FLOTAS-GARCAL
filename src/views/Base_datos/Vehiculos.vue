<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold} from '@element-plus/icons-vue'

import {API} from '@/API'
import {REAPI} from '@/API/report.js'

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
import modal from "../../components/modal.vue"
export default {
  components: {
    modal
  },
  computed: {
    is_movile() {
      return this.$store.state.ismovile;
    },
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      operarios_id:[2,4],
      datap: [],
      opt_rs: [],

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],

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
    }
  },

  methods: {

    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    send_descarga() {
      REAPI
        .post('vehiculoscsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_vehiculos')
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

    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.modelo="";
      this.form_b.marca="";

      //cargar listas
      this.load_mar();
      this.load_mod();
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
      API
      .get('empresas')
      .then((resp) => {
        console.log(resp);
        this.opt_rs = resp.data;
      })
    },
    load_mar() {
      API
      .get('vehiculosmarcas/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mar = resp.data;
        })
    },
    load_mod() {
      API
      .get('vehiculosmodelos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mod = resp.data;
        })
    },
    load_cla() {
      API
      .get('vehiculosclases/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_cla = resp.data;
        })
    },
    load_ti() {
      API
      .get('vehiculostipos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_ti = resp.data;
        })
    },
    load_esp() {
      API
      .get('especialidad/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_esp = resp.data;
        })
    },

    load_edit(id) {
      API
      .post("vehiculos/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      API
        .post('vehiculos/borrar/'+String(this.editpointer))
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
        .catch((error) => {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
          return false;
        });
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
     API
        .get('vehiculos')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      API
        .post('vehiculos', 
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
    
    create_usr(){

      API
      .post('vehiculos/nuevo', 
      { 
        "emp_id": String(this.form_c.rs),
        "veh_placa":this.form_c.placa,
        "vma_id": String(this.form_c.marca),
        "vmo_id": String(this.form_c.modelo),
        "vti_id": this.form_c.tipo,
        "vcl_id": this.form_c.clase,
        "veh_anno":this.form_c.year,
        "veh_usucreacion":this.$store.state.username,
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
      .catch((error) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
      return false;

    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
    axios
      .post('vehiculos/actualizar', 
      { 
        "veh_id":String(this.editpointer),
        "emp_id": String(this.form_e.rs),
        "veh_placa":this.form_e.placa,
        "vma_id":String(this.form_e.marca),
        "vmo_id":String(this.form_e.modelo),
        "vti_id": this.form_e.tipo,
        "vcl_id": this.form_e.clase,
        "veh_anno":this.form_e.year,
        "veh_usucreacion":this.$store.state.username,
        "veh_serie":this.form_e.serie,
        "veh_mtc":this.form_e.mtc,
        "veh_cargautil":String(this.form_e.carga_util),
        "veh_kilometraje":String(this.form_e.kilometraje)
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
      .catch((error) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
      return false;
    },

    button_handle(number){
      console.log(number);
      this.clear_eop;
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      //this.load_edit(number);

      API
      .post("vehiculos/"+String(number))
      .then((resp) => {
        this.data_edit = resp.data;

        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      })
      .catch((error) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
      
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

        <el-form-item label="Placa" clearable>
          <el-input v-model="form_b.placa" />
        </el-form-item>

        <el-form-item label="Marca" clearable>
          <el-select  v-model="form_b.marca" >
            <el-option
              v-for="item in opt_mar"
              :key="item.vma_id"
              :label="item.vma_nombre"
              :value="item.vma_id"
            > </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="Modelo" clearable>
          <el-select  v-model="form_b.modelo" >
            <el-option
              v-for="item in opt_mod"
              :key="item.vmo_id"
              :label="item.vmo_nombre"
              :value="item.vmo_id"
            > </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="Año" clearable>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_i"
              format="YYYY"
              value-format="YYYY"
              type="year"
              placeholder="Seleccionar año inicio"
              style="width: 100%"
            />
          </el-col>
          <el-col :span="2" class="text-center">
            <span class="text-gray-500">-</span>
          </el-col>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_f"
              format="YYYY"
              value-format="YYYY"
              type="year"
              placeholder="Seleccionar año fin"
              style="width: 100%"
            />
          </el-col>

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

        <el-form-item label="Placa" clearable>
          <el-input v-model="form_b.placa" />
        </el-form-item>

        <el-form-item label="Marca" clearable>
          <el-select  v-model="form_b.marca" >
            <el-option
              v-for="item in opt_mar"
              :key="item.vma_id"
              :label="item.vma_nombre"
              :value="item.vma_id"
            > </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="Modelo" clearable>
          <el-select  v-model="form_b.modelo" >
            <el-option
              v-for="item in opt_mod"
              :key="item.vmo_id"
              :label="item.vmo_nombre"
              :value="item.vmo_id"
            > </el-option>
          </el-select>
        </el-form-item>

        <el-form-item label="Año" clearable>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_i"
              format="YYYY"
              value-format="YYYY"
              type="year"
              placeholder="Seleccionar año inicio"
              style="width: 100%"
            />
          </el-col>
          <el-col :span="2" class="text-center">
            <span class="text-gray-500">-</span>
          </el-col>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_f"
              format="YYYY"
              value-format="YYYY"
              type="year"
              placeholder="Seleccionar año fin"
              style="width: 100%"
            />
          </el-col>

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
      <el-table-column prop="emp_razonsocial" label="Razon soc. asoc. " width="140" align="center" />
      <el-table-column prop="veh_placa" label="Placa" width="90" align="center"/>
      <el-table-column prop="vcl_nombre" label="Clase" width="150"/>
      <el-table-column prop="vti_nombre" label="Tipo" width="130"/>
      <el-table-column prop="vma_nombre" label="Marca" width="140" sortable/>
      <el-table-column prop="vmo_nombre" label="Modelo" />
      <el-table-column prop="veh_anno" label="Año" width="70" align="center" />
      <el-table-column prop="veh_serie" label="Nro. serie" width="140"/>
      <el-table-column prop="veh_mtc" label="MTC" width="130"/>
      <el-table-column prop="veh_cargautil" label="Carga util" width="90" align="center"/>
      <el-table-column prop="veh_kilometraje" label="Km" />   
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.veh_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Vehiculo" width="500px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  @submit.prevent ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >

    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select  v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
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
    
    <el-form-item label="Año" prop="year">
      <el-date-picker
          v-model="form_c.year"
          format="YYYY"
          value-format="YYYY"
          type="year"
          placeholder="Seleccione año"
      />
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



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Vehiculo" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form @submit.prevent v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Placa o ID">
      <el-input v-model="form_e.placa" />
    </el-form-item>
    
    <hr size="1" color="gray"> 
    <el-form-item label="Clase">
      <el-select  v-model="form_e.clase"  @change="check_op" default-first-option>
        <el-option
          v-for="item in opt_cla"
          :key="item.vcl_id"
          :label="item.vcl_nombre"
          :value="item.vcl_id"
        > </el-option>
      </el-select>
    </el-form-item>

    
    <el-form-item label="Marca">
      <el-select  v-model="form_e.marca" default-first-option>
        <el-option
          v-for="item in opt_mar"
          :key="item.vma_id"
          :label="item.vma_nombre"
          :value="item.vma_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Año">
      <el-date-picker
          v-model="form_e.year"
          format="YYYY"
          value-format="YYYY"
          type="year"
          placeholder="Seleccione año"
      />
    </el-form-item>
    
    <el-form-item label="Tipo">
      <el-select  v-model="form_e.tipo"  @change="check_op" default-first-option>
        <el-option
          v-for="item in opt_ti"
          :key="item.vti_id"
          :label="item.vti_nombre"
          :value="item.vti_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Modelo">
      <el-select  v-model="form_e.modelo" default-first-option>
        <el-option
          v-for="item in opt_mod"
          :key="item.vmo_id"
          :label="item.vmo_nombre"
          :value="item.vmo_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Nro. de serie">
      <el-input v-model="form_e.serie" />
    </el-form-item>

    <el-form-item label="Código MTC">
      <el-input v-model="form_e.mtc" />
    </el-form-item>

    <el-form-item label="Carga útil">
      <el-input v-model="form_e.carga_util" />
    </el-form-item>
    <hr> 
    
    <el-form-item label="Km. estimado">
      <el-input v-model="form_e.kilometraje" />
    </el-form-item>
    
    <hr>  
    <el-row style="text-align:center">
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


<style scoped src="../styles/internal.css">

</style>
