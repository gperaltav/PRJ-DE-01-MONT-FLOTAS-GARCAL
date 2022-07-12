<script setup>

import { ref } from 'vue'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts,Money,Tickets} from '@element-plus/icons-vue'

</script>

<script>

export default {
  name:"Sidebar",
}

</script>


<template>

<el-menu :default-openeds="['1', '2','4','5']" router=true>
  <el-menu-item index="inicio">
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
    <el-menu-item index="doc_vehiculos">Vehiculos</el-menu-item>
    <el-menu-item index="doc_personal">Personal</el-menu-item>
  </el-sub-menu>
  <el-menu-item index="planificacion">
    <template #title>
      <el-icon><trend-charts /></el-icon> Planifiación
    </template>
  </el-menu-item>
  <el-sub-menu index="4">
    <template #title>
      <el-icon><operation /></el-icon>Operaciones
    </template>
    <el-menu-item index="operaciones_combustible">Combustible</el-menu-item>
    <el-menu-item index="operaciones_viaticos">Viáticos</el-menu-item>
    <el-menu-item index="operaciones_personal">Personal</el-menu-item>
    <el-menu-item index="operaciones_pago">Pago</el-menu-item>
    <el-menu-item index="operaciones_compras">Compras</el-menu-item>
    <el-menu-item index="operaciones_rendicion_cuentas">Rendicion de cuentas</el-menu-item>
    
  </el-sub-menu>
  <el-sub-menu index="5">
    <template #title>
      <el-icon><Tickets /></el-icon>Facturación
    </template>
    <el-menu-item index="facturacion_guias">Guias</el-menu-item>
    <el-menu-item index="facturacion_comprobantes">Comprobantes</el-menu-item>
    <el-menu-item index="facturacion_cobranza">Cobranza</el-menu-item>
  </el-sub-menu>
  <el-menu-item disabled index="disposicion_dinero">
    <template #title>
      <el-icon><Money /></el-icon> Disposicion de dinero
    </template>
  </el-menu-item>



</el-menu>


</template>

<style scoped>
.el-menu {
  border-right: none;
  font-family: "Roboto", sans-serif;
}
</style>
