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
      datav:[],
      form : reactive({
        nombre: '',
    })
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
      console.log(this.form.nombre);
      axios
          .get('http://localhost:5000/vehiculos_a'+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.datav = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/vehiculos_a')
        .then((resp) => {
          console.log(resp);
          this.datav = resp.data;
        })
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
            Base de datos > Vehiculos
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
         
         
         <el-form :inline="true" :model="formInline" label-width="auto" :size="small" label-position="right">
              <el-col :span="21">
                <el-form-item label="Razon social">
                  <el-select v-model="form.rs" placeholder="Seleccionar">
                    <el-option label="Garcal" value="garcal" />
                    <el-option label="LC" value="lc" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Placa">
                  <el-input v-model="form.placa" />
                </el-form-item>

                <el-form-item label="Marca">
                  <el-input v-model="form.marca" />
                </el-form-item>

                <el-form-item label="Modelo">
                  <el-input v-model="form.model" />
                </el-form-item>

                <el-form-item label="Año">
                  <el-col :span="11">
                    <el-date-picker
                      v-model="form.date1"
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
                      v-model="form.date2"
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
                  <el-button color="#0844a4" :icon="Filter" @click="onSubmit">Filtrar</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#008db1" :icon="Plus" @click="this.$refs.mo_create_veh.open()" >Crear</el-button>
                </el-row>
                <el-row class="mb-4">
                  <el-button color="#95d475" :icon=" Download" disabled>A Excel</el-button>
                </el-row>
                </div>
              </el-col>
              
            </el-form>

          <div class="table-container">
          <el-table :data="datav" border header-row-style="color:black;" >
            <el-table-column prop="rs" label="Razon soc. asoc. " width="140" />
            <el-table-column prop="placa" label="Placa" width="90" />
            <el-table-column prop="clase" label="Clase" />
            <el-table-column prop="tipo" label="Tipo" />
            <el-table-column prop="marca" label="Marca" />
            <el-table-column prop="modelo" label="Modelo" />
            <el-table-column prop="anno" label="Año" width="60"  />
            <el-table-column prop="serie" label="Nro. serie" />
            <el-table-column prop="mtc" label="MTC" />
            <el-table-column prop="cargautil" label="Carga util" />
            <el-table-column prop="km" label="Km" />   
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

<modal ref="mo_create_veh" title="Agregar vehiculo" width="500px" cancel-title="Cancelar" centered>
<el-form :model="form" label-width="150px">

    <el-form-item  label="Razón soc. asoc.">
      <el-select  v-model="form.region" placeholder="Seleccionar">
        <el-option label="Garcal " value="0" />
        <el-option label="LC " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="ID">
        <el-input  />
    </el-form-item>
    <el-form-item label="Clase">
      <!-- Aca se deberia jalar de la BD las clases -->
      <el-select  v-model="form.region" placeholder="Seleccionar">
        <el-option label="Semirremolque " value="0" />
        <el-option label="Trailer " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="Marca">
      <el-input />
    </el-form-item>
    <el-form-item label="Modelo">
      <el-input />
    </el-form-item>
    <el-form-item label="Año">
      <el-input />
    </el-form-item>
    <el-form-item label="Tipo">
      <el-input />
    </el-form-item>
    <el-form-item label="Nro de serie">
      <el-input />
    </el-form-item>
    <el-form-item label="Código MTC">
      <el-input />
    </el-form-item>
    <el-form-item label="Carga útil">
      <el-input />
    </el-form-item>
    <el-form-item label="Km. estimado">
      <el-input />
    </el-form-item>
  </el-form>
</modal>

</template>


<style scoped src="../styles/basededatos.css">

</style>
