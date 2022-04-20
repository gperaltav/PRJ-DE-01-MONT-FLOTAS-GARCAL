<script setup>

import { ref } from 'vue'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts} from '@element-plus/icons-vue'

</script>

<script>

export default {
  name:"Sidebar",
}

</script>


<template>

<el-menu :default-openeds="['1', '2']" router=true>
  <el-menu-item index="0">
    <template #title>
      <el-icon><office-building /></el-icon>Inicio 
    </template>
  </el-menu-item>
  <el-sub-menu index="1">
    <template #title>
      <el-icon><notebook /></el-icon>Base de datos
    </template>
    <el-menu-item index="clientes">Clientes</el-menu-item>
    <el-menu-item index="personal">Personal</el-menu-item>
    <el-menu-item index="vehiculos">Vehiculos</el-menu-item>
    <el-menu-item index="proveedores">Proveedores</el-menu-item>
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


</template>

<style scoped>
.el-menu {
  border-right: none;
}
</style>
