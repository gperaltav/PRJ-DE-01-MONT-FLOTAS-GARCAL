<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
</script>

<script>
import Sidebar from "../../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
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
    <el-aside width="200px">
      <el-scrollbar>
        <Sidebar />
      </el-scrollbar>
    </el-aside>

    <el-container>
      <el-header style="text-align: left; font-size: 24px">
        <div class="toolbar">
          
          <span>ERP Garcal</span>
        </div>
      </el-header>

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
                <el-row>
                  <el-button type="primary" @click="onSubmit">Filtrar</el-button>
                </el-row>
                <el-row>
                  <el-button type="info">Crear</el-button>
                </el-row>
                <el-row>
                  <el-button type="success">Exportar a Excel</el-button>
                </el-row>
                
              </el-col>
              
            </el-form>

            
          <el-table :data="datav">
            <el-table-column prop="rs" label="Razon soc. asoc. " width="140" />
            <el-table-column prop="placa" label="Placa" width="130" />
            <el-table-column prop="clase" label="Clase" />
            <el-table-column prop="tipo" label="Tipo" />
            <el-table-column prop="marca" label="Marca" />
            <el-table-column prop="modelo" label="Modelo" />
            <el-table-column prop="anno" label="Año" />
            <el-table-column prop="serie" label="Nro. serie" />
            <el-table-column prop="mtc" label="MTC" />
            <el-table-column prop="cargautil" label="Carga util" />
            <el-table-column prop="km" label="Kilometraje" />                
          </el-table>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>
</template>


<style scoped>
.layout-container .el-header {
  position: relative;
  background-color: rgb(8, 68, 164);
  color: rgb(240, 240, 240);
  text-align: left;
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
.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}
.layout-container .el-form {
  padding-top: 15px;
  padding-bottom: 15px;
  background-color: white;
}
.layout-container .el-form .el-button {
  padding-top: 5px;
  padding-bottom: 5px;
}
</style>
