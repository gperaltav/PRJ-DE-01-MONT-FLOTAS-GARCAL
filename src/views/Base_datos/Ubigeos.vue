<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold,Search,CreditCard} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'

</script>

<script lang="ts">
import modal from "../../components/modal.vue"
export default {
  components: {
    modal
  },
  computed: {
    rs_disable() {
      return this.form_b.rs=='';
    }
  },
  data(){
    return {
      datap: [],

      opt_rs: [],
      opt_td: [],
      opt_fcobro:[],

      alert_mo:'',
      emp_cont:'1',

      form_b : reactive({
        nombre: '',
      }),

      form_c : reactive({
        nombre: '',
        nombre_c: '',
        codigo:''
        
      }),
    }
  },

  methods: {
    checkformx (formEl: FormInstance | undefined) {

      formEl.validate((valid, fields) => {
        if (valid) {
          console.log('submit!');
          return true;
        } else {
          console.log('error submit!', fields)
          return false;
        }
      })
    },

    open_succes(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado.open(); 
    },
    close_succes() {
      this.$refs.mo_realizado.hide();
      this.api_get_all();
    },

    open_fail(msg) {
      this.alert_mo=msg;
      this.$refs.mo_error.open(); 
    },
    close_fail() {
      this.alert_cause="";
      this.$refs.mo_error.hide(); 
    },
    opencrear() {
      this.open_op=false;
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
      this.search_rs_clear();
    },

    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.tipo_gui="";
      this.form_b.estado_gui="";

      //cargar listas
      this.get_tipos_doc();
      this.get_formas_cobro();
      

    },
    search_rs_clear() {
      this.form_b.tipo_gui="";
      this.form_b.rs="";
      this.form_b.estado_gui="";
      this.opt_td = [];
      this.opt_ed=[];
    },
    
    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },
    
    get_formas_cobro() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdecobro/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);  
          this.opt_fcobro = resp.data;
        })
    },

    get_tipos_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprastipos/'+String(this.emp_cont))
      .then((resp) => {
        console.log(resp);
        this.opt_td = resp.data;
      })
    },

    get_estados_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprasestados/'+String(this.emp_cont))
      .then((resp) => {
        console.log(resp);
        this.opt_ed = resp.data;
      })
    },

    api_get_all(){
      //llamada a API
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/ubigeo',
      {
        "ubi_nombre":"arequipa"
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/ubigeo', {
        "ubi_nombre":this.form_b.nombre
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },
    api_nuevo(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/ubigeo/nuevo', {
        "ubi_codigo":this.form_c.codigo,
        "ubi_nombre": this.form_c.nombre,
        "ubi_departamento":"",
        "ubi_provincia":"",
        "ubi_distrito":"",
        "ubi_nombrecompleto":this.form_c.nombre_c,
        "ubi_departamentonombre":"",
        "ubi_provincianombre":"",
        "ubi_usucreacion":this.$store.state.username
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          return true;
          
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      .catch((e) => {
        this.open_fail("Hubo un error interno al ejecutar la operación, código de error: "+String(e));
        return false;
      })
    },
  },

  mounted () {
    //Al cargar página:
    this.api_get_all();
    this.load_rs();
    //this.load_tc();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
  
<div class="main-container">
  <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
    <el-row>
    <el-col :span="21">

      <el-form-item label="Nombre completo de ubigeo">
        <el-input  v-model="form_b.nombre" clearable />
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
    <el-table :data="datap" border header-row-style="color:black" height="98%">
      <el-table-column prop="ubi_codigo" label="Código" width="130" align="center" />
      <el-table-column prop="ubi_nombre" label="Nombre corto"   />
      <el-table-column prop="ubi_nombrecompleto" label="Nombre completo"/>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Ubigeo" width="500px" @ok="api_nuevo" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  @submit.prevent ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >
    
    <el-form-item label="Nombre de ubigeo">
      <el-input v-model="form_c.nombre" />
    </el-form-item>

    <el-form-item label="Nombre completo">
      <el-input v-model="form_c.nombre_c" />
    </el-form-item>

    <el-form-item label="Código asignado">
      <el-input v-model="form_c.codigo" />
    </el-form-item>

  </el-form>
</modal>


<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
  <br/> {{alert_cause}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
