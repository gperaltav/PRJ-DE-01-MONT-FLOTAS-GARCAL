<script setup>
import { reactive } from 'vue'

import axios from 'axios'

import { ref } from 'vue'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts} from '@element-plus/icons-vue'

const form = reactive({
  id: '',
  razon: '',
  nombre: '',
  fpago: '',
})

const onSubmit = () => {
  console.log('submit!')
}

const item = {
  date: '2016-05-02',
  name: 'Tom',
  address: 'No. 189, Grove St, Los Angeles',
}
const tableData = ref(Array.from({ length: 15 }).fill(item))
</script>

<script>
import Sidebar from "../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
  },
  data(){
    return {
      users:[]
    }
  },
  methods: {
    
  },
  mounted () {
    //llamada a API
     axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuario')
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
              <el-form-item label="Razon social">
                <el-select v-model="form.region" placeholder="Seleccionar">
                  <el-option label="Garcal" value="garcal" />
                  <el-option label="LC" value="lc" />
                </el-select>
              </el-form-item>

              <el-form-item label="Nro. de documento">
                <el-input v-model="form.id" />
              </el-form-item>

              <el-form-item label="Nombre">
                <el-input v-model="form.name" />
              </el-form-item>

              <el-form-item label="Forma de pago preferido">
                <el-select v-model="form.pagop" placeholder="Seleccionar">
                  <el-option label="Deposito" value="dep" />
                  <el-option label="Credito" value="cred" />
                </el-select>
              </el-form-item>
              
              <el-form-item>
                <el-button type="primary" @click="onSubmit">Filtrar</el-button>
                <el-button type="info">Crear</el-button>
                <el-button type="success">Exportar a Excel</el-button>
              </el-form-item>
            </el-form>
            <el-table :data="users">
              <el-table-column prop="codigo" label="Codigo" width="140" />
              <el-table-column prop="usu_nombre" label="Nombre" width="120" />
              <el-table-column prop="usu_apepaterno" label="Ap. Paterno" />
              <el-table-column prop="usu_apematerno" label="Ap. Materno" />
              <el-table-column prop="usu_nrodocumento" label="Nro. de doc." />
              <el-table-column prop="usu_telefono" label="Telefono" />
              <el-table-column prop="usu_direccion" label="Direccion" />
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
