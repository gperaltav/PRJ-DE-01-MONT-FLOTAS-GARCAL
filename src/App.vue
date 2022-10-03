<script setup lang="ts">
import { ref } from 'vue'
import { RouterLink, RouterView } from 'vue-router'
import { Notebook, OfficeBuilding,DocumentChecked,Operation,TrendCharts,Money,Tickets,Expand,Setting} from '@element-plus/icons-vue'

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
  import Loginb from "./views/login_beta.vue"
  export default {
    name: 'App',

    data(){
      return {
        ancho:200,
        titlebar:'Inicio'
      }
    },

    components: {
      Login,
      Loginb
    },
    mounted() {
      console.log(this.$store.state.authenticated);
      if(this.isMobile()) {
        this.ancho=64;
        this.isCollapse=true;
      }
    },
    methods: {
      isMobile() {
        if(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
          return true
        } else {
          return false
        }
      },
      changetool() {
        if(!this.isCollapse) {
          this.ancho=64;
        }
        else {
          this.ancho=200;
        }
        this.isCollapse=!this.isCollapse;
      },
      change_title(tt) {
        this.titlebar=tt;
      },
      log_out() {
        this.$store.dispatch('deauthenticate');
      }
    },
    computed: {
      state() {
        return this.$store.state.authenticated
      },
      username() {
        return this.$store.state.username
      }
    },      
  }
  
</script>

<template>
  <el-container v-if="!state" class="layout-container" style="width: 100vw; height: 100vh;">
    <Login/>
  </el-container>
  <el-container v-else class="layout-container" style="width: 100vw; height: 100vh;">
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          <el-button type="text" style="padding:20px" size="small" @click="changetool()"><el-icon style="color:white" :size="20"><Expand /></el-icon></el-button>
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          {{titlebar}}
        </el-tag>
      </div>
      </el-col>
      <el-col :span="8" style="text-align:right">
        <div class="userarea">
          <el-dropdown>
            <el-icon style="margin-right: 8px; margin-top: 1px; color:white"
              ><setting
            /></el-icon>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="log_out" >Salir</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
          <h6 style="margin:0">{{username}}</h6>
        </div>
      </el-col>
    </el-header>

    <el-container style=" height: calc( 100vh - 100px ); ">
      <el-aside :width="ancho">
        <el-scrollbar>
          <el-menu :default-openeds="['1', '2','4','5','7']" 
          router=true 
          :collapse="isCollapse" 
          class="el-menu-v"
          @open="handleOpen"
          @close="handleClose"
          >
            <el-menu-item @click='change_title("Inicio")' index="/">
              <el-icon><office-building /></el-icon>
              <template #title>Inicio</template>
            </el-menu-item>
            <el-sub-menu index="1">
              <template #title>
                <el-icon><notebook /></el-icon>
                <span>Base de datos</span>
              </template>
              <el-menu-item @click='change_title("Base de datos > Usuarios")' index="usuarios">Usuarios</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Clientes")' index="clientes">Clientes</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Personal")' index="personal">Personal</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Vehiculos")' index="vehiculos">Vehiculos</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Proveedores")' index="proveedores">Proveedores</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Productos")' index="productos">Productos</el-menu-item>
              <el-menu-item @click='change_title("Base de datos > Ubigeos")' index="ubigeos">Ubigeos</el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="2">
              <template #title>
                <el-icon><document-checked /></el-icon>
                <span>Documentos</span>
              </template>
              <el-menu-item @click='change_title("Documentos > Vehiculos")' index="doc_vehiculos">Vehiculos</el-menu-item>
              <el-menu-item @click='change_title("Documentos > Personal")' index="doc_personal">Personal</el-menu-item>
            </el-sub-menu>
            <el-menu-item @click='change_title("Planificación")' index="planificacion">
              <el-icon><trend-charts /></el-icon>
              <template #title>Planificación</template>
            </el-menu-item>
            <el-sub-menu index="4">
              <template #title>
                <el-icon><operation /></el-icon>
                <span>Operaciones</span>
              </template>
              <el-menu-item @click='change_title("Operaciones > Combustible")' index="operaciones_combustible">Combustible</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Viáticos")' index="operaciones_viaticos">Viáticos</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Personal")' index="operaciones_personal">Personal</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Rendición de cuentas")' index="operaciones_rendicion_cuentas">Rendicion de cuentas</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Compras")' index="operaciones_compras">Compras</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Vista de compras")' index="operaciones_compras_vista">Vista de compras</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Pagos")' index="operaciones_pago">Pagos</el-menu-item>
              <el-menu-item @click='change_title("Operaciones > Vista de pagos")' index="operaciones_pagos_vista">Vista de pagos</el-menu-item>
            </el-sub-menu>
            <el-sub-menu index="5">
              <template #title>
                <el-icon><Tickets /></el-icon>
                <span>Facturación</span>
              </template>
              <el-menu-item @click='change_title("Facturación > Guías")' index="facturacion_guias">Guias</el-menu-item>
              <el-menu-item @click='change_title("Facturación > Configuración")' index="facturacion_configuracion">Configuración</el-menu-item>
              <el-menu-item @click='change_title("Facturación > Comprobantes")' index="facturacion_comprobantes">Comprobantes</el-menu-item>
              <el-menu-item @click='change_title("Facturación > Cobranzas")' index="facturacion_cobranza">Cobranzas</el-menu-item>
            </el-sub-menu>
            <el-menu-item index="disposicion_dinero" disabled>
              <el-icon><Money /></el-icon>
              <template #title>Disposicion de dinero</template>
            </el-menu-item>
            <el-sub-menu index="7">
              <template #title>
                <el-icon><img width="15" height="15" src= "./components/mantenimiento.svg"/></el-icon>
                <span>Mantenimiento</span>
              </template>
              <el-menu-item @click='change_title("Mantenimiento > Mantenimientos vista")' index="mantenimiento_vista">Vista mantenimiento</el-menu-item>
              <el-menu-item @click='change_title("Mantenimiento > Plan de mantenimiento")' index="mantenimiento_plan">Plan de mantenimiento</el-menu-item>
              <el-menu-item @click='change_title("Mantenimiento > Tareas")' index="mantenimiento_tareas">Tareas</el-menu-item>
              <el-menu-item @click='change_title("Mantenimiento > Plantillas")' index="mantenimiento_plantillas">Plantillas</el-menu-item>
            </el-sub-menu>
          </el-menu>
        </el-scrollbar>
      </el-aside>

      <el-main style="background-color:white">

          <RouterView />

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
  padding: 0;
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

.layout-container .el-header .userarea{
  display: inline-flex;
  justify-content: center;
  margin-left:auto;
  margin-right: 40px;
  margin-bottom: 10px;
  text-align: right; 
  font-size: 18px;
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
