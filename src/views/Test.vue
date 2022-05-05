<script setup>
import { reactive } from 'vue'
import axios from 'axios'

const form = reactive({
  nombre: '',
})

const onSubmit = () => {
  axios
      .get('http://localhost:5000/usuarios?nombre='+String(form.nombre))
      .then((resp) => {
        console.log(resp);
        this.users = resp.data;
      })
}

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
    onSubmit2 (){
      console.log(this.form.nombre);
      axios
          .get('http://localhost:5000/usuarios?name='+String(this.form.nombre))
          .then((resp) => {
            console.log(resp);
            this.users = resp.data;
          })
    }
    
  },
  mounted () {
    //llamada a API
     axios
      .get('http://localhost:5000/usuarios_a')
      .then((resp) => {
        console.log(resp);
        this.users = resp.data;
      })
  },
}
</script>


<template>
  <el-container class="layout-container" style="height: 900px">
    <el-header style="text-align: right; font-size: 12px">
      <div class="toolbar">
        <span>ERP GARCAL</span>
      </div>
    </el-header>
    <el-container>
      <el-aside width="200px" height="700px" >
          <el-scrollbar>
            <Sidebar />
          </el-scrollbar>
        </el-aside>
        <el-main>
          <el-scrollbar height="700px">
            
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
  color: var(--el-text-color-primary);
}
.layout-container .el-aside {
  color: var(--el-text-color-primary);
  background: var(--el-color-primary-light-8);
  height: 80%;
}
.layout-container .el-menu {
  border-right: none;
}
.layout-container .el-main {
  padding: 0;
  height: 80%;
  padding-left: 10px;
}
.layout-container .el-form {
  background-color: white;
  color: var(--el-text-color-primary);
  size: 20px;
  border-top: 20px;
}
.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 80%;
  right: 20px;
}
.el-form-item {
  size: 2px;
}

</style>
