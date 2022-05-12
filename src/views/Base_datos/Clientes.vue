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
          .get('http://localhost:5000/clientes?name='+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.datax = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/clientes_a')
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
      <div class="toolbar">
        <span>ERP Garcal</span>
      </div>
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

              <el-form-item label="Nro. de documento">
                <el-input v-model="form.id" />
              </el-form-item>

              <el-form-item label="Nombre">
                <el-input v-model="form.nombre" />
              </el-form-item>

              <el-form-item label="Forma de pago preferido">
                <el-select v-model="form.fpago" placeholder="Seleccionar">
                  <el-option label="Deposito" value="dep" />
                  <el-option label="Credito" value="cred" />
                </el-select>
              </el-form-item>
              
              </el-col>
              <el-col :span="3">
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
          
          <div class="table-container">
          <el-table :data="datax" border header-row-style="color:black;" >
            <el-table-column prop="rs" label="Razon soc. aso." width="140" />
            <el-table-column prop="cnombre" label="Nombre" />
            <el-table-column prop="pnatural" label="P. Natural" />
            <el-table-column prop="ndoc" label="Nro. de documento" />
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
