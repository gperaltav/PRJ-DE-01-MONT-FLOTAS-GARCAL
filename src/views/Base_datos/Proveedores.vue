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
          .get('http://localhost:5000/proveedores_a'+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.datax = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/proveedores_a')
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
            
          <el-table :data="datax">
              <el-table-column prop="rs" label="Razon soc. aso." width="140" />
              <el-table-column prop="pnombre" label="Nombre" />
              <el-table-column prop="pnatural" label="P. Natural" />
              <el-table-column prop="ndoc" label="Nro. de documento" />
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
</style>
