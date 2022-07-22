<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink, RouterView } from 'vue-router'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts,Money,Tickets} from '@element-plus/icons-vue'

const isCollapse = ref(false)
const handleOpen = (key: string, keyPath: string[]) => {
  console.log(key, keyPath)
}
const handleClose = (key: string, keyPath: string[]) => {
  console.log(key, keyPath)
}

</script>

<script lang="ts">
    import Login from "./views/Login.vue"
    export default {
        name: 'App',

        components: {
            Login,
        },
        mounted() {
            console.log(this.$store.state.authenticated)
        },
        methods: {

        }
        
    }
</script>

<template>
  <el-container v-if="!this.$store.state.authenticated" class="layout-container" style="width: 100vw; height: 100vh;">
    <Login/>
  </el-container>
  <el-container v-else class="layout-container" style="width: 100vw; height: 100vh;">
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          ERP
        </el-tag>
      </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
      </el-col>
    </el-header>

    <el-container style=" height: calc( 100vh - 100px ); ">
      <el-aside width="200px">
        <el-scrollbar>
          <el-menu :default-openeds="['1', '2','4','5']" 
          router=true 
          :collapse="isCollapse" 
          class="el-menu-v"
          @open="handleOpen"
          @close="handleClose"
          >
            <el-menu-item index="/">
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
              <el-menu-item index="operaciones_rendicion_cuentas">Rendicion de cuentas</el-menu-item>
              <el-menu-item index="operaciones_compras">Compras</el-menu-item>
              <el-menu-item index="operaciones_personal">Personal</el-menu-item>
              <el-menu-item index="operaciones_pago">Pago</el-menu-item>
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
        </el-scrollbar>
      </el-aside>

      <el-main style="background-color:white">
        <el-scrollbar>
          <RouterView />
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>
</template>


<style scoped>

.el-menu-v:not(.el-menu--collapse) {
  width: 200px;
  min-height: 400px;
}
.layout-container {
  width: 100%;
  height: 100%;
}
.layout-container .el-header {
  position: relative;
  background-color: rgb(8, 68, 164);
  color: rgb(240, 240, 240);
  text-align: left;
  font-family: "Roboto", sans-serif;
  width: 100%;
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
.layout-container .el-form {
  padding-top: 15px;
  background-color: white;
}

.layout-container .sitebar {
  display: block;
  text-align: center;
  margin-left: auto;
  margin-right: auto;
}

</style>
