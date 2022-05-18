<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'
</script>

<script>
import Sidebar from "../../components/Sidebar.vue"
import modal from "../../components/modal.vue"
export default {
  components: {
    Sidebar,
    modal
  },
  data(){
    return {
      datap:[],
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
        apellidos: '',
        tipo: '',
        contrato: '',
        date_i: '',
        date_f: '',
      }),
    }
  },
  methods: {
    check() {
      //verificar campos
      if (nombre=='') {
        this.onSubmitall();
      }
      else {
        this.onSubmit2();
      }
    },
    onSubmit2 (){
      axios
          .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/1')
          .then((resp) => {
            console.log(resp);
            this.datap = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/personal_a')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    Sendnuevo(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/nuevo', 
        { "are_id": 1,
          "pue_id": 1,
          "emp_id": 1,
          "tra_nombres":"Cesar Gabriel",
          "tra_apellidopaterno":"Huisa",
          "tra_apellidomaterno":"Flores",
          "tra_nrodocumento": "14141414",
          "tra_identificador": "000",
          "tra_fechanacimiento":"1990-01-01",
          "tra_tipocontrato":"reg",
          "tra_fechaingreso":"2022-01-01",
          "tra_usucreacion":"admin" })
    }
    
  },
  mounted () {
    //llamada a API
     this.onSubmitall();
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
                  <el-button color="#0844a4" :icon="Filter" @click="onSubmit2">Filtrar</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#008db1" :icon="Plus"  @click="this.$refs.mo_create_per.open()">Crear</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#95d475" :icon=" Download" disabled>A Excel</el-button>
                </el-row>
                </div>
                
              </el-col>
              
            </el-form>

          <div class="table-container">
          <el-table :data="datap" border header-row-style="color:black;" >
              <el-table-column prop="rs" label="Razon soc. asoc." width="140" />
              <el-table-column prop="tnombre" label="Nombre" />
              <el-table-column prop="nrodoc" label="Nro. de doc." />
              <el-table-column prop="puesto" label="Tipo" />
              <el-table-column prop="tipocontrato" label="Tipo de contrato" />
              <el-table-column prop="fechaingreso" label="Fecha de ingreso" />
              <el-table-column prop="fechacese" label="Fecha de cese" />
              <el-table-column fixed="right" label="" width="40">
              <template #default>
                <el-button type="text" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
              </template>
            </el-table-column>
            </el-table>
          </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" title="Agregar Trabajador" width="500px" @ok="Sendnuevo" cancel-title="Cancelar" centered>
<el-form :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select   placeholder="Seleccionar">
        <el-option label="Garcal " value="0" />
        <el-option label="LC " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="Tipo">
        <el-select  v-model="form_c.tipo" default-first-option>
          <el-option label="Administrativo " value="0" />
          <el-option label="Operario " value="1" />
          
        </el-select>
    </el-form-item>
    <el-form-item label="DNI o carnet de extranjería">
      <el-input />
    </el-form-item>
    <hr size="1" color="gray"> 
    <el-form-item label="Nombres">
      <el-input />
    </el-form-item>
    <el-form-item label="Apellido Paterno">
      <el-input />
    </el-form-item>
    <el-form-item label="Apellido Materno">
      <el-input />
    </el-form-item>
    <hr> 
    <el-form-item label="Fecha de nac.">
      <el-date-picker />
    </el-form-item>

    <el-form-item label="Tipo de contrato">
        <el-select   default-first-option>
          <el-option label="A prueba " value="0" />
          <el-option label="Planilla " value="1" />
          
        </el-select>
    </el-form-item>
    <el-form-item label="Fecha de ingreso">
      <el-date-picker />
    </el-form-item>
    <el-form-item label="Fecha de ingreso planilla">
      <el-date-picker />
    </el-form-item>
    <el-form-item label="Fecha de cese">
      <el-date-picker />
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
