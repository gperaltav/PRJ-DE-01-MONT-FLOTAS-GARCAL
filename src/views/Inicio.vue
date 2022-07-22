<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import { ref } from 'vue'

</script>

<script>
import modal from "../components/modal.vue"
export default {
  components: {
    modal,
  },
  data(){
    return {
      users:[],
      open_m:false,
      puntero_edit:1,
      form : reactive({
        nombre: '',
      }),
      form_edit : reactive({
        nombre: '',
      })
    }
  },
  methods: {
    open_mod() {
      this.$refs.CreateMo.open()
    },
    check() {
      //verificar campos
      if (nombre=='') {
        this.onSubmitall();
      }
      else {
        this.onSubmit2();
      }
    },
    set_actual(usr) {
      this.$refs.myRef.open();
    }, 
    onSubmit2 (){
      console.log(this.form.nombre);

    },
    okis() {
      console.log("Todo ok");
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
     this.onSubmitall();
  },
}
</script>


<template>
  
  <el-form @submit.prevent :inline="true" :model="form" label-width="auto" :size="small" >

      <el-form-item label="Nombre">
        <el-input v-model="form.nombre" />
      </el-form-item>

      <el-form-item>
        <el-button color="#0844a4"  :icon="Filter" @click="onSubmit2()">Filtrar</el-button>
        <el-button color="#008db1"  :icon="Plus"  @click="open_mod()" >Crear</el-button>
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
        <template #default="scope">
          <el-button type="text" size="small" @click="setactual(scope.row)"><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>



<modal ref="EditMo" title="Editar usuario" width="600px"  hide-footer centered>
  
  <el-form label-width="150px">
    <el-form-item style="z-index: 10000" label="Razón soc. asoc.">
      <el-select  v-model="form.region" placeholder="Seleccionar">
        <el-option label="Garcal " value="0" />
        <el-option label="LC " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="Nro. de documento">
      
      <el-col :span="8">
        <el-select   default-first-option>
          <el-option label="RUC " value="0" />
          <el-option label="DNI " value="1" />
        </el-select>
      </el-col>

      <el-col :span="16">
        <el-input  />
      </el-col>
    </el-form-item>
    <el-form-item label="Nombre de cliente">
      <el-input />
    </el-form-item>
    <el-form-item label="Condicion de pago">
      <el-select   default-first-option>
          <el-option label="15 dias " value="0" />
          <el-option label="10 dias " value="1" />
        </el-select>
    </el-form-item>
    <el-form-item label="Dirección de cliente">
      <el-input />
    </el-form-item>
    <el-form-item label="Correo">
      <el-input />
    </el-form-item>
    <el-form-item label="Telefono">
      <el-input />
    </el-form-item>
  </el-form>
</modal>


<modal ref="CreateMo" title="Crear usuario" width="600px"  @ok="okis()" centered>
<el-form  label-width="150px">

    <el-form-item style="z-index: 10000" label="Razón soc. asoc.">
      <el-select  v-model="form.region" placeholder="Seleccionar">
        <el-option label="Garcal " value="0" />
        <el-option label="LC " value="1" />
      </el-select>
    </el-form-item>
    <el-form-item label="Nro. de documento">
      
      <el-col :span="8">
        <el-select   default-first-option>
          <el-option label="RUC " value="0" />
          <el-option label="DNI " value="1" />
        </el-select>
      </el-col>

      <el-col :span="16">
        <el-input  />
      </el-col>
    </el-form-item>
    <el-form-item label="Nombre de cliente">
      <el-input />
    </el-form-item>
    <el-form-item label="Condicion de pago">
      <el-select   default-first-option>
          <el-option label="15 dias " value="0" />
          <el-option label="10 dias " value="1" />
        </el-select>
    </el-form-item>
    <el-form-item label="Dirección de cliente">
      <el-input />
    </el-form-item>
    <el-form-item label="Correo">
      <el-input />
    </el-form-item>
    <el-form-item label="Telefono">
      <el-input />
    </el-form-item>
  </el-form>
</modal>

</template>


<style scoped>

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

