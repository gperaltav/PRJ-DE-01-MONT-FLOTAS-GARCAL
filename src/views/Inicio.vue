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
      editpointer:'',

      form : reactive({
        nombre: '',
      }),
      form_b : reactive({
        nombre: '',
        nro_doc:'',
        
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
        this.api_get_all();
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

    button_handle(key){
      console.log(key);
      this.editpointer=key;

      this.$refs.EditMo.open();
      this.wait = true;
      this.load_edit(key);
      
      setTimeout(() => {
        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      }, 400)

      
    },

    api_get_all (){
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
     this.api_get_all();
  },
}
</script>


<template>

<div class="main-container">
  <el-form :inline="true" model="formInline" label-width="auto" :size="small" >
    <el-row>
      <el-col :span="21">
        <el-form-item label="Nombre">
          <el-input v-model="form_b.nombre" />
        </el-form-item>
        <el-form-item label="Nro. de documento">
          <el-input v-model="form_b.nro_doc" />
        </el-form-item>
      </el-col>

      <el-col :span="3">
          <div class="button-container">
            <el-row class="mb-4">
              <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
            </el-row>
            <el-row class="mb-4">
              <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
            </el-row>
          </div>  
      </el-col>
    </el-row>
  </el-form>

  <div class="table-container">
    <el-table :data="users" border header-row-style="color:black;" height="100%" >
      <el-table-column prop="usu_codigo" label="Codigo" width="120" />
      <el-table-column prop="usu_nombres" label="Nombre" width="240" />
      <el-table-column prop="usu_nrodocumento" label="Nro. de doc." />
      <el-table-column prop="usu_telefono" label="Telefono" />
      <el-table-column prop="usu_direccion" label="Direccion" />
      <el-table-column fixed="right" label="" width="45">
        <template #default="scope">
          <el-button type="text"  @click="button_handle(scope.row.usu_codigo)"><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
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


<style scoped src="./styles/internal.css">

</style>

