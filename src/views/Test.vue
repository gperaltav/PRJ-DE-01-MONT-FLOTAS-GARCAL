<script lang="ts" setup>
import { reactive } from 'vue'

import { ref } from 'vue'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts} from '@element-plus/icons-vue'

// do not use same name with ref
const form = reactive({
  name: '',
  region: '',
  date1: '',
  date2: '',
  delivery: false,
  type: [],
  resource: '',
  desc: '',
})

const onSubmit = () => {
  console.log('submit!')
}

const item = {
  date: '2016-05-02',
  name: 'Tom',
  address: 'No. 189, Grove St, Los Angeles',
}
const tableData = ref(Array.from({ length: 20 }).fill(item))
</script>


<template>
  <el-container class="layout-container" style="height: 900px">
    <el-header style="text-align: right; font-size: 12px">
      <div class="toolbar">
        <el-dropdown>
        <el-icon style="margin-right: 8px; margin-top: 1px"><setting/></el-icon>
        <template #dropdown>
          <el-dropdown-menu>
          <el-dropdown-item>View</el-dropdown-item>
          <el-dropdown-item>Add</el-dropdown-item>
          <el-dropdown-item>Delete</el-dropdown-item>
          </el-dropdown-menu>
        </template>
        </el-dropdown>
        <span>Tom</span>
      </div>
    </el-header>
    <el-container>
      <el-aside width="200px" height="700px" >
          <el-scrollbar>
            <el-menu :default-openeds="['1', '2']">
              <el-menu-item index="0">
                <template #title>
                  <el-icon><office-building /></el-icon>Inicio 
                </template>
              </el-menu-item>
              <el-sub-menu index="1">
                <template #title>
                  <el-icon><notebook /></el-icon>Base de datos
                </template>
                <el-menu-item index="1-1">Clientes</el-menu-item>
                <el-menu-item index="1-2">Personal</el-menu-item>
                <el-menu-item index="1-3">Vehiculos</el-menu-item>
                <el-menu-item index="1-4">Proveedores</el-menu-item>
              </el-sub-menu>
              <el-sub-menu index="2">
                <template #title>
                  <el-icon><document-checked /></el-icon>Documentos
                </template>
                <el-menu-item index="2-1">Vehiculos</el-menu-item>
                <el-menu-item index="2-2">Personal</el-menu-item>
              </el-sub-menu>
              <el-menu-item index="3">
                <template #title>
                  <el-icon><trend-charts /></el-icon> Planifiación
                </template>
              </el-menu-item>
              <el-menu-item index="4">
                <template #title>
                  <el-icon><operation /></el-icon> Operaciones
                </template>
              </el-menu-item>
    
            </el-menu>
          </el-scrollbar>
        </el-aside>
        <el-main>
          <el-scrollbar height="700px">
            
            <el-form :model="form" label-width="100px">
              <el-form-item label="Razon social">
                <el-select v-model="form.region" placeholder="Seleccionar">
                  <el-option label="Garcal" value="garcal" />
                  <el-option label="LC" value="lc" />
                </el-select>
              </el-form-item>

              <el-form-item label="Nombre">
                <el-input v-model="form.name" />
              </el-form-item>
              
              <el-form-item label="Fecha">
                <el-col :span="11">
                  <el-date-picker
                    v-model="form.date1"
                    type="date"
                    placeholder="Seleccionar fecha inicio"
                    style="width: 100%"
                  />
                </el-col>
                <el-col :span="2" class="text-center">
                  <span class="text-gray-500">-</span>
                </el-col>
                <el-col :span="11">
                  <el-date-picker
                    v-model="form.date1"
                    type="date"
                    placeholder="Seleccionar fecha fin"
                    style="width: 100%"
                  />
                </el-col>

              </el-form-item>
              <el-form-item label="Switch">
                <el-switch v-model="form.delivery" />
              </el-form-item>
              <el-form-item label="Check">
                <el-checkbox-group v-model="form.type">
                  <el-checkbox label="A" name="type" />
                  <el-checkbox label="B" name="type" />
                  <el-checkbox label="C" name="type" />
                  <el-checkbox label="D" name="type" />
                </el-checkbox-group>
              </el-form-item>
              <el-form-item label="Radio check">
                <el-radio-group v-model="form.resource">
                  <el-radio label="A" />
                  <el-radio label="B" />
                </el-radio-group>
              </el-form-item>
              <el-form-item label="Activity form">
                <el-input v-model="form.desc" type="textarea" />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" @click="onSubmit">Filtrar</el-button>
                <el-button>Crear</el-button>
                <el-button>Exportar a Excel</el-button>
              </el-form-item>
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
  background-color: var(--el-color-primary-light-7);
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
}
.layout-container .el-form {
  background-color: white;
  color: var(--el-text-color-primary);
}
.layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 80%;
  right: 20px;
}
</style>
