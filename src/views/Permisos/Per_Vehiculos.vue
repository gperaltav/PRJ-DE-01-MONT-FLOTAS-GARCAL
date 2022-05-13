<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'
</script>

<script>
import Sidebar from "../../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
  },
  data(){
    return {
      datax:[],
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
          .get('http://localhost:5000/doc_personal'+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.datax = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/doc_personal')
        .then((resp) => {
          console.log(resp);
          this.datax = resp.data;
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
            Documentos > Vehiculos
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
          <div class="form-container">
          <el-form :inline="true" :model="formInline" label-width="auto" :size="small" label-position="right">
            <el-col :span="21">
              <el-form-item label="Razon social">
              <el-select v-model="form.rs" placeholder="Seleccionar">
                <el-option label="Garcal" value="garcal" />
                <el-option label="LC" value="lc" />
              </el-select>
            </el-form-item>

            <el-form-item label="Número de placa">
              <el-input v-model="form.id" />
            </el-form-item>
            
            </el-col>

            <el-col :span="3" style="text-align=center">
              <el-row class="mb-4">
                <el-button color="#0844a4" :width="200" :icon="Filter" @click="onSubmit">Filtrar</el-button>
              </el-row>
              <el-row class="mb-4">
                <el-button color="#008db1"  :icon="Plus" >Crear</el-button>
              </el-row>
              <el-row class="mb-4">
                <el-button color="#95d475"  :icon=" Download">A Excel</el-button>
              </el-row>
              
            </el-col>
          </el-form>
          </div>
          
          <div class="table-container" >
            
          <el-table :data="datax" border header-row-style="color:black;">
            <el-table-column prop="" label="Razon soc. aso." width="135" />
            <el-table-column prop="" label="Placa" />
            <el-table-column prop="" label="CITV 6m" />
            <el-table-column prop="" label="CITV 12m" />
            <el-table-column prop="" label="SOAT" />
            <el-table-column prop="" label="Poliza" />
            <el-table-column width="140" prop="" label="Elem. peligrosos" />
            <el-table-column prop="" label="Bonificación" />
            <el-table-column width="120" prop="" label="Hermeticidad" />
            
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
</template>


<style scoped src="../styles/basededatos.css">

</style>
