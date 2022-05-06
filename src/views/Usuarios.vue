<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
</script>

<script>
import Sidebar from "../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
  },
  data(){
    return {
      users:[],
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
          .get('http://localhost:5000/usuarios?name='+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.users = resp.data;
          })
    },
    onSubmitall (){
      //llamada a API
     axios
        .get('http://localhost:5000/usuarios_a')
        .then((resp) => {
          console.log(resp);
          this.users = resp.data;
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

              <el-form-item label="Nombre">
                <el-input v-model="this.form.nombre" />
              </el-form-item>

              <el-form-item>
                <el-button type="primary" @click="onSubmit2">Filtrar</el-button>
                <el-button type="info">Crear</el-button>
                <el-button type="success">Exportar a Excel</el-button>
              </el-form-item>
            </el-form>
          <el-table :data="users">
            <el-table-column prop="uid" label="Codigo" width="140" />
            <el-table-column prop="unombre" label="Nombre" width="240" />
            <el-table-column prop="unrodocumento" label="Nro. de doc." />
            <el-table-column prop="utelefono" label="Telefono" />
            <el-table-column prop="udireccion" label="Direccion" />
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
  background-color: white;
}
</style>
