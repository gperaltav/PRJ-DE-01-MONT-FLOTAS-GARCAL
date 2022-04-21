<script setup>
import { reactive } from 'vue'

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
  rs: 'Garcal',
  name: 'Example',
  id: 'R3T-1232',
}
const tableData = ref(Array.from({ length: 15 }).fill(item))
</script>

<script>
import Sidebar from "../../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
  }
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
            <el-table :data="tableData">
              <el-table-column prop="rs" label="Razon social aso." width="140" />
              <el-table-column prop="id" label="Id" width="120" />
              <el-table-column prop="clase" label="Clase" />
              <el-table-column prop="marca" label="Marca" />
              <el-table-column prop="modelo" label="Modelo" />
              <el-table-column prop="year" label="Año" />
              <el-table-column prop="km_est" label="Km. estimado" />
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

.layout-container .el-form .el-col {
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
