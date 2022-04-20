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
  date: '2020-05-02',
  name: 'Example',
  address: 'Calle Terapacá 123',
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
            <el-table :data="tableData">
              <el-table-column prop="date" label="Date" width="140" />
              <el-table-column prop="name" label="Name" width="120" />
              <el-table-column prop="address" label="Address" />
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
