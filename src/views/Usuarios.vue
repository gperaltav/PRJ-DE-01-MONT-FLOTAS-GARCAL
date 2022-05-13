<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import { ref } from 'vue'

const item = {
  date: '2016-05-02',
  unombre: 'Tom',
  address: 'No. 189, Grove St, Los Angeles',
}
const testdata = ref(Array.from({ length: 20 }).fill(item))
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
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios')
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
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          Usuarios
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

              <el-form-item label="Nombre">
                <el-input v-model="this.form.nombre" />
              </el-form-item>

              <el-form-item>
                <el-button color="#0844a4"  :icon="Filter" @click="onSubmit2">Filtrar</el-button>
                <el-button color="#008db1"  :icon="Plus" >Crear</el-button>
                <el-button color="#95d475"  :icon=" Download">A Excel</el-button>
              </el-form-item>
            </el-form>
          <div class="table-container">
          <el-table :data="users" border header-row-style="color:black;" >
            <el-table-column prop="uid" label="Codigo" width="120" />
            <el-table-column prop="unombre" label="Nombre" width="240" />
            <el-table-column prop="unrodocumento" label="Nro. de doc." />
            <el-table-column prop="utelefono" label="Telefono" />
            <el-table-column prop="udireccion" label="Direccion" />
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


<style scoped>
.layout-container .el-header {
  position: relative;
  background-color: rgb(8, 68, 164);
  color: rgb(240, 240, 240);
  text-align: left;
  font-family: "Roboto", sans-serif;
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

.layout-container .el-header {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.layout-container .toolbar {
  display: block;
  text-align: left;
  margin-left: 0;
  margin-right: auto;
}

.layout-container .sitebar {
  display: block;
  text-align: center;
  margin-left: auto;
  margin-right: auto;
}

.layout-container .el-form {
  padding-top: 15px;
  background-color: white;
}

.table-container {
  padding: 20px;
}
.el-table {
  font-family: "Roboto", sans-serif;
  --el-table-header-bg-color:rgb(199, 199, 199);
}
.el-col {
  text-align:center;
}

.el-row {
  margin-bottom: 5px;
}

</style>

