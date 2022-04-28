<script setup>
import { reactive } from 'vue'
import axios from 'axios'


const form = reactive({
  id: '',
  razon: '',
  nombre: '',
  fpago: '',
})

const onSubmit = () => {
  console.log('funcion de filtrado! bep bop bip bop')
}

</script>

<script>
import Sidebar from "../../components/Sidebar.vue"
export default {
  components: {
    Sidebar,
  },
  data(){
    return {
      datax:[]
    }
  },
  methods: {
    
  },
  mounted () {
    //llamada a API
     axios
      .get('http://localhost:5000/vehiculos')
      .then((resp) => {
        console.log(resp);
        this.datax = resp.data;
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
            <el-table :data="datax">
              <el-table-column prop="emp_razonsocial" label="Razon soc. asoc. "/>
              <el-table-column prop="veh_placa" label="Placa" width="120" />
              <el-table-column prop="vcl_nombre" label="Clase" />
              <el-table-column prop="vti_nombre" label="Tipo" />
              <el-table-column prop="vma_nombre" label="Marca" />
              <el-table-column prop="vmo_nombre" label="Modelo" />
              <el-table-column prop="veh_anno" label="Año" />
              <el-table-column prop="veh_serie" label="Nro. serie" />
              <el-table-column prop="veh_mtc" label="MTC" />
              <el-table-column prop="veh_cargautil" label="Carga util" />
              <el-table-column prop="veh_kilometraje" label="Kilometraje" />
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
