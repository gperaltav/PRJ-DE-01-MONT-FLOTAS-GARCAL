<script lang="ts" setup>
import { reactive } from 'vue'

import { API } from '@/API';

import { EditPen, Filter, Plus, Download, CloseBold,Search,CreditCard ,Delete} from '@element-plus/icons-vue'

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
      pointer:'',

      form_b : reactive({
        nombre: '',
        descripcion: '',
        codigo: ''
      }),

      form_c : reactive({
        rs: '',
        codigo: '',
        descripcion:''
      }),

      form_e : reactive({
        rs: '',
        codigo: '',
        descripcion:''
        
      }),
    }
  },

  methods: {
    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    
    checkformx (formEl: FormInstance | undefined) {

      this.formEl.validate((valid, fields) => {
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
      this.$refs.mo_create_per.hide();
      this.api_get_all();
    },

    close_succes_all() {
      this.$refs.mo_realizado.hide();
      this.$refs.mo_create_per.hide();
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

    open_confirmar(msg) {
      this.alert_mo=msg;
      this.$refs.mo_advertencia.open(); 
    },
    close_confirmar() {
      this.$refs.mo_advertencia.hide();
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
      API
      .get('empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },
    
    get_formas_cobro() {
      API
      .get('formasdecobro/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);  
          this.opt_fcobro = resp.data;
        })
    },


    get_estados_doc() {
      API
      .post('comprobantescomprasestados/'+String(this.emp_cont))
      .then((resp) => {
        console.log(resp);
        this.opt_ed = resp.data;
      })
    },

    api_get_all(){
      //llamada a API
      API
      .get('controldocumentosvehiculos/pivot_tra')
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
      .catch((e)=> {
        console.log(e);
      })
    },

    api_get_filt(){
      API
      .get('controldocumentosvehiculos/pivot_tra')
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
      .catch((e)=> {
        console.log(e);
      })
    },

    send_delete(number) {
      this.editpointer=number;
      this.alert_mo="Realmente desea eliminar este producto?";
      this.$refs.mo_advertencia.open();
    },

    send_delete_master() {
      this.$refs.mo_advertencia.hide();
      API
      .post('productos/borrar/'+String(this.editpointer),{},{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;

        if (this.succes) {
          this.open_succes("Producto eliminado correctamente");
          return true;
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      .catch((e) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, c+odigo de error:"+String(e));
        return false;
      })
    },

    api_nuevo(){
      API
      .post('productos/nuevo', {
        "emp_id": this.form_c.rs,
        "pro_codigo":this.form_c.codigo,
        "pro_descripcion":this.form_c.descripcion,
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
  },
}

</script>


<template>
  
<div class="main-container">

  <div v-if="$isMobile()">
  <el-collapse>
    <el-collapse-item title="Opciones">
      <el-form @submit.prevent :inline="true" label-width="auto" size="small" >
    <el-row justify="center">

      <el-form-item label="Razón social">
        <el-select v-model="form_b.rs" @change="search_rs_ch" @clear="search_rs_clear" placeholder="Seleccionar" clearable>
          <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
          > </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="Descripción">
        <el-input  v-model="form_b.descripcion" clearable />
      </el-form-item>

       <el-form-item label="Cód. de producto">
        <el-input  v-model="form_b.codigo" clearable />
      </el-form-item>

      <div class="button-container">
      <el-row class="mb-4">
        <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
      </el-row>
      <el-row class="mb-4">
        <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
      </el-row>
      </div>
    </el-row>

    </el-form>
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
    <el-form @submit.prevent :inline="true" label-width="auto"  >
    <el-row>
    <el-col :span="21">
      <el-form-item label="Razón social">
        <el-select v-model="form_b.rs" @change="search_rs_ch" @clear="search_rs_clear" placeholder="Seleccionar" clearable>
          <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
          > </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="Descripción">
        <el-input  v-model="form_b.descripcion" clearable />
      </el-form-item>

       <el-form-item label="Cód. de producto">
        <el-input  v-model="form_b.codigo" clearable />
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
      <el-row class="mb-4">
        <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
      </el-row>
      </div>
    </el-col>
    </el-row>

    </el-form>
  </div>
  

  <div class="table-container">
    <el-table :data="datap" border header-row-style="color:black" height="98%" :size="$isMobile() ? 'small':'default'">
      <el-table-column prop="ttd_nombre" label="Denominación"  align="center" />
      <el-table-column prop="ttd_avisovencimiento" width="170" label="Aviso" />
      <el-table-column prop="u_ti_nombre" width="170" label="Unidades"/>
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="send_delete(scope.row.ttd_id)" ><el-icon :size="17"><Delete /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar documento" width="500px" @ok="api_nuevo" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form @submit.prevent ref="form_cref"  :model="form_c" label-width="150px" :size="$isMobile() ? 'small':'default'">
 
    <el-form-item label="Nombre de documento">
      <el-input style="width:300px" v-model="form_c.codigo" />
    </el-form-item>

    <el-form-item label="Periodo de alerta">
      <el-input style="width:300px" v-model="form_c.descripcion" />
    </el-form-item>

  </el-form>
</modal>

<modal ref="mo_advertencia" title="Confirmar" centered @ok="send_delete_master" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>



</template>


<style scoped src="../styles/internal.css">

</style>
