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
      datap:[],
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
          .get('http://localhost:5000/personal_a'+String(this.form.nombre))
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
          <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
              <el-col :span="21">
                <el-form-item label="Razon social">
                  <el-select v-model="form.region" placeholder="Seleccionar">
                    <el-option label="Garcal" value="garcal" />
                    <el-option label="LC" value="lc" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Nro. de DNI">
                  <el-input v-model="form.dni" />
                </el-form-item>

                <el-form-item label="Nombres">
                  <el-input v-model="form.name" />
                </el-form-item>

                <el-form-item label="Apellidos">
                  <el-input v-model="form.lastname" />
                </el-form-item>

                <el-form-item label="Tipo">
                  <el-select v-model="form.tipo" placeholder="Seleccionar">
                    <el-option label="Administrativo" value="adm" />
                    <el-option label="Operario" value="op" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Contrato">
                  <el-select v-model="form.contra" placeholder="Seleccionar">
                    <el-option label="En prueba" value="pr" />
                    <el-option label="Planilla" value="pl" />
                  </el-select>
                </el-form-item>

                <el-form-item label="Fecha inicio">
                  <el-date-picker
                    v-model="form.datei"
                    type="date"
                    placeholder="Seleccionar fecha inicio"
                    style="width: 100%"
                  />
                </el-form-item>

                <el-form-item label="Fecha fin">
                  <el-date-picker
                    v-model="form.datef"
                    type="date"
                    placeholder="Seleccionar fecha fin"
                    style="width: 100%"
                  />
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

            
          <el-table :data="datap">
              <el-table-column prop="rs" label="Razon soc. asoc." width="130" />
              <el-table-column prop="tnombre" label="Nombre" />
              <el-table-column prop="nrodoc" label="Nro. de doc." />
              <el-table-column prop="puesto" label="Tipo" />
              <el-table-column prop="tipocontrato" label="Tipo de contrato" />
              <el-table-column prop="fechaingreso" label="Fecha de ingreso" />
              <el-table-column prop="fechacese" label="Fecha de cese" />
              
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
