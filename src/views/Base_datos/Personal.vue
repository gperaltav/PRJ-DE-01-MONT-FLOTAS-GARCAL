<script lang="ts" setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'
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
      succes: false,
      datap:[],
      opt_rs : [],
      opt_tc : [],
      data_edit : [],
      form_b : reactive({
        rs: '',
        nombre: '',
        nro_doc: '',
        apellidos: '',
        tipo: '',
        contrato: '',
        date_i: '',
        date_f: '',
      }),
      form_c : reactive({
        rs: '',
        nombre: '',
        tipo: '',
        nro_doc: '',
        apellido_p: '',
        apellido_m: '',
        contrato: '',
        fecha_nac:'',
        fecha_i: '',
        fecha_ip: '',
        fecha_c: '',
      }),
      form_e : reactive({
        rs: '',
        nombre: '',
        tipo: '',
        nro_doc: '',
        apellido_p: '',
        apellido_m: '',
        contrato: '',
        fecha_nac:'',
        fecha_i: '',
        fecha_ip: '',
        fecha_c: '',
      }),
      rules : reactive<FormRules>({
        nombre: [
          { required: true, message: 'Please input Activity name', trigger: 'blur' },
          { min: 3, max: 5, message: 'Length should be 3 to 5', trigger: 'blur' },
        ],
        
      })
    }
  },
  methods: {
    check() {
      //verificar campos
      if (this.form_b.nombre=='') {
        this.api_get_all();
        
      }
      else {
        this.api_get_filt();
      }
    },
    openedit() {
      this.$refs.mo_create_per.open();
    },
    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },

    load_tc() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/contratos/1')
        .then((resp) => {
          console.log(resp);
          this.opt_tc = resp.data;
        })
    },

    load_edit(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
          console.log(this.data_edit)
        })      
    },

    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.form_e.tipo=this.data_edit[0].pue_id;
      this.form_e.nro_doc=this.data_edit[0].tra_nrodocumento;
      this.form_e.nombre=this.data_edit[0].tra_nombres;
      this.form_e.apellido_p=this.data_edit[0].tra_apellidomaterno;
      this.form_e.apellido_m=this.data_edit[0].tra_apellidopaterno;
      this.form_e.fecha_nac=this.data_edit[0].tra_fechanacimiento;
      this.form_e.contrato=this.data_edit[0].tra_tipocontrato;
      this.form_e.fecha_i=this.data_edit[0].tra_fechaingreso;
      this.form_e.fecha_ip=this.data_edit[0].tra_fechaingresoplanilla;
      this.form_e.fecha_c=this.data_edit[0].tra_fechacese;

      
    },

    api_get_all(){
      //llamada a API
     axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },

    api_get_filt(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores', 
        { 
          "emp_id": this.form_b.rs,
          "tra_nombreyapellidos":this.form_b.nombre,
          "tra_nrodocumento": this.form_b.nro_doc,
          "pue_nombre": this.form_b.tipo,
          "tra_tipocontrato":this.form_b.contrato,
          "tra_fechaingreso":this.form_b.date_i,
          "tra_fechacese":this.form_b.date_f
        })
        .then((resp) => {
          this.succes=resp.data.status;
          if (this.succes) {

            this.$refs.mo_create_per.hide();
            
          }
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/nuevo', 
        { 
          "are_id": 1,
          "pue_id": this.form_c.tipo,
          "emp_id": this.form_c.rs,
          "tra_nombres":this.form_c.nombre,
          "tra_apellidopaterno":this.form_c.apellido_p,
          "tra_apellidomaterno":this.form_c.apellido_m,
          "tra_nrodocumento": this.form_c.nro_doc,
          "tra_identificador": "",
          "tra_fechanacimiento":this.form_c.fecha_nac,
          "tra_tipocontrato":this.form_c.contrato,
          "tra_fechaingreso":this.form_c.fecha_i,
          "tra_fechaingresoplanilla":this.form_c.fecha_ip,
          "tra_fechacese":this.form_c.fecha_c,
          "tra_usucreacion":"admin" 
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.$refs.mo_realizado.open(); 
          }
          console.log(resp);
        })
        return false;
    },

    close_succes() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_realizado.hide();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/actualizar', 
        { 
          "tra_id": this.editpointer,
          "are_id": 1,
          "pue_id": this.form_e.tipo,
          "emp_id": this.form_e.rs,
          "tra_nombres":this.form_e.nombre,
          "tra_apellidopaterno":this.form_e.apellido_p,
          "tra_apellidomaterno":this.form_e.apellido_m,
          "tra_nrodocumento": this.form_e.nro_doc,
          "tra_identificador": "",
          "tra_fechanacimiento":this.form_e.fecha_nac,
          "tra_tipocontrato":this.form_e.contrato,
          "tra_fechaingreso":this.form_e.fecha_i,
          "tra_fechaingresoplanilla":this.form_e.fecha_ip,
          "tra_fechacese":this.form_e.fecha_c,
          "tra_usucreacion":"admin" 
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.$refs.mo_realizado.open(); 
          }
          console.log(resp);
        })
        return false;
    },

    button_handle(number){
      this.editpointer=number;
      this.load_edit(number);
      //console.log(this.data_edit[0].tra_nombres);
      this.load_data_edit();
      this.$refs.mo_editar_per.open();
      
    }
    
  },
  mounted () {
    //llamada a API
     this.api_get_all();
     this.load_rs();
     this.load_tc();
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
          Base de datos > Personal
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
          <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
              <el-col :span="21">
                <el-form-item label="Razon social">
                  <el-select v-model="form_b.rs" placeholder="Seleccionar">
                    <el-option label="Garcal" value="garcal" />
                    <el-option label="LC" value="lc" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Nro. de DNI">
                  <el-input v-model="form_b.nro_doc" />
                </el-form-item>

                <el-form-item label="Nombre">
                  <el-input v-model="form_b.nombre" />
                </el-form-item>

                <el-form-item label=" Apellidos">
                  <el-input v-model="form_b.apellidos" />
                </el-form-item>

                <el-form-item label="Tipo">
                  <el-select v-model="form_b.tipo" placeholder="Seleccionar">
                    <el-option label="Administrativo" value="adm" />
                    <el-option label="Operario" value="op" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Contrato">
                  <el-select v-model="form_b.contrato" placeholder="Seleccionar">
                    <el-option label="En prueba" value="pr" />
                    <el-option label="Planilla" value="pl" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Fecha inicio">
                  <el-date-picker
                    v-model="form_b.datei"
                    type="date"
                    placeholder="Seleccionar fecha inicio"
                    style="width: 100%"
                  />
                </el-form-item>

                <el-form-item label="Fecha fin">
                  <el-date-picker
                    v-model="form_b.datef"
                    type="date"
                    placeholder="Seleccionar fecha fin"
                    style="width: 100%"
                  />
                </el-form-item>
              </el-col>
              <el-col :span="3">
                
                <div class="button-container">
                <el-row class="mb-4">
                  <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#008db1" :icon="Plus"  @click="openedit">Crear</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#95d475" :icon=" Download" disabled>A Excel</el-button>
                </el-row>
                </div>
                
              </el-col>
              
            </el-form>

          <div class="table-container">
          <el-table :data="datap" border header-row-style="color:black;" >
              <el-table-column prop="emp_razonsocial" label="Razon soc. asoc." width="140" />
              <el-table-column prop="tra_nombreyapellidos" label="Nombre" />
              <el-table-column prop="tra_nrodocumento" label="Nro. de doc." />
              <el-table-column prop="pue_nombre" label="Tipo" />
              <el-table-column prop="tipocontrato" label="Tipo de contrato" />
              <el-table-column prop="fechaingreso" label="Fecha de ingreso" />
              <el-table-column prop="fechacese" label="Fecha de cese" />
              <el-table-column fixed="right" label="" width="40">
              <template #default="scope">
                <el-button type="text"  @click="button_handle(scope.row.tra_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
              </template>
            </el-table-column>
            </el-table>
          </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" title="Agregar Trabajador" width="500px" @ok="create_usr" cancel-title="Cancelar" centered>
<el-form ref="form_create_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select v-model="form_c.rs" placeholder="Seleccionar">
        <el-option
          v-for="item in this.opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Tipo">
        <el-select  v-model="form_c.tipo" default-first-option>
          <el-option label="Administrativo " value="0" />
          <el-option label="Operario " value="1" />
          
        </el-select>
    </el-form-item>
    <el-form-item label="DNI o carnet de extranjería">
      <el-input v-model="form_c.nro_doc" />
    </el-form-item>
    <hr size="1" color="gray"> 
    <el-form-item label="Nombres">
      <el-input v-model="form_c.nombre" />
    </el-form-item>
    <el-form-item label="Apellido Paterno">
      <el-input v-model="form_c.apellido_p" />
    </el-form-item>
    <el-form-item label="Apellido Materno">
      <el-input v-model="form_c.apellido_m" />
    </el-form-item>
    <hr> 
    <el-form-item label="Fecha de nac.">
      <el-date-picker v-model="form_c.fecha_nac" />
    </el-form-item>

    <el-form-item label="Tipo de contrato">
        <el-select v-model="form_c.contrato"  default-first-option>
          <el-option
            v-for="item in this.opt_tc"
            :key="item.tco_id"
            :label="item.tco_nombre"
            :value="item.tco_id"
          > </el-option>
          
        </el-select>
    </el-form-item>
    <el-form-item label="Fecha de ingreso">
      <el-date-picker v-model="form_c.fecha_i" />
    </el-form-item>
    <el-form-item label="Fecha de ingreso planilla">
      <el-date-picker v-model="form_c.fecha_ip" />
    </el-form-item>
    <el-form-item label="Fecha de cese">
      <el-date-picker v-model="form_c.fecha_c" />
    </el-form-item>
    <!-- <el-form-item label="Clase">
      <el-radio-group v-model="form.resource">
        <el-radio label="Administrativo" />
        <el-radio label="Conductor" />
      </el-radio-group>
    </el-form-item> -->
    <hr>  
    <div v-if="form_c.tipo==1" class="form-worker">
      <el-form-item label="Nro. de licencia">
        <el-input />
      </el-form-item>
      <el-form-item label="Categoria de licencia">
        <el-input />
      </el-form-item>
      <el-form-item label="Fecha de venc. licencia">
        <el-date-picker />
      </el-form-item>
      <el-form-item label="Especialidad">
        <el-select   default-first-option>
          <el-option label="Volvo " value="0" />
          <el-option label="Americano " value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-checkbox  label="Inscrito en SUNAT-IQBF" />
    </el-form-item>
      
    </div>

  </el-form>
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes" cancel-title="Atras" >
  Operación completada satisfactoriamente
</modal>

<modal ref="mo_error" error title="Error al ejecutar operación" centered  @ok="$refs.mo_error.hide()" >
  Hubo un error al ejecutar la operación
</modal>

<modal ref="mo_editar_per" title="Editar datos de Trabajador" width="500px" @ok="editar_usr" cancel-title="Cancelar" centered>
<el-form ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select v-model="form_e.rs" placeholder="Seleccionar">
        <el-option label="Garcal " value="0" />
        <el-option label="LC " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="Tipo">
        <el-select  v-model="form_e.tipo" default-first-option>
          <el-option label="Administrativo " value="0" />
          <el-option label="Operario " value="1" />
          
        </el-select>
    </el-form-item>
    <el-form-item label="DNI o carnet de extranjería">
      <el-input v-model="form_e.nro_doc" />
    </el-form-item>
    <hr size="1" color="gray"> 
    <el-form-item label="Nombres">
      <el-input v-model="form_e.nombre" />
    </el-form-item>
    <el-form-item label="Apellido Paterno">
      <el-input v-model="form_e.apellido_p" />
    </el-form-item>
    <el-form-item label="Apellido Materno">
      <el-input v-model="form_e.apellido_m" />
    </el-form-item>
    <hr> 
    <el-form-item label="Fecha de nac.">
      <el-date-picker v-model="form_e.fecha_nac" />
    </el-form-item>

    <el-form-item label="Tipo de contrato">
        <el-select v-model="form_e.contrato"  default-first-option>
          <el-option label="A prueba " value="prueba" />
          <el-option label="Planilla " value="planilla" />
          
        </el-select>
    </el-form-item>
    <el-form-item label="Fecha de ingreso">
      <el-date-picker v-model="form_e.fecha_i" />
    </el-form-item>
    <el-form-item label="Fecha de ingreso planilla">
      <el-date-picker v-model="form_e.fecha_ip" />
    </el-form-item>
    <el-form-item label="Fecha de cese">
      <el-date-picker v-model="form_e.fecha_c" />
    </el-form-item>
    <!-- <el-form-item label="Clase">
      <el-radio-group v-model="form.resource">
        <el-radio label="Administrativo" />
        <el-radio label="Conductor" />
      </el-radio-group>
    </el-form-item> -->
    <hr>  
    <div v-if="form_c.tipo==1" class="form-worker">
      <el-form-item label="Nro. de licencia">
        <el-input />
      </el-form-item>
      <el-form-item label="Categoria de licencia">
        <el-input />
      </el-form-item>
      <el-form-item label="Fecha de venc. licencia">
        <el-date-picker />
      </el-form-item>
      <el-form-item label="Especialidad">
        <el-select   default-first-option>
          <el-option label="Volvo " value="0" />
          <el-option label="Americano " value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-checkbox  label="Inscrito en SUNAT-IQBF" />
    </el-form-item>
      
    </div>

  </el-form>
</modal>

</template>


<style scoped src="../styles/basededatos.css">

</style>
