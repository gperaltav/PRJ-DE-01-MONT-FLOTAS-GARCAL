<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
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

    send_descarga() {
      axios
        .post('http://51.222.25.71:8080/garcal-report-api/api/productoscsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_productos')
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
            return false;
        });
    },
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
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos',
      {
        "emp_id": 0,
        "pro_descripcion":"",
        "pro_codigo":""
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos',
      {
        "emp_id": this.form_b.rs,
        "pro_descripcion":this.form_b.descripcion,
        "pro_codigo":this.form_b.codigo
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    send_delete(number) {
      this.editpointer=number;
      this.alert_mo="Realmente desea eliminar este producto?";
      this.$refs.mo_advertencia.open();
    },

    send_delete_master() {
      this.$refs.mo_advertencia.hide();
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/borrar/'+String(this.editpointer))
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
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/nuevo', {
        "emp_id": this.form_c.rs,
        "pro_codigo":this.form_c.codigo,
        "pro_descripcion":this.form_c.descripcion,
        "uni_codigomenor":"UNI",
        "mod_codigo":"SOL",
        "pro_preciominimo":0,
        "pro_precioventa":0,
        "pro_preciocompra":0,
        "pro_codsunat":"",
        "pro_usucreacion":this.$store.state.username
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

  <div v-if="$isMobile()">
  <el-collapse>
    <el-collapse-item title="Opciones">
      <el-form :inline="true" :model="formInline" label-width="auto" size="small" >
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
    <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
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
      <el-table-column prop="emp_razonsocial" label="Razón social" width="170" align="center" />
      <el-table-column prop="pro_descripcion" label="Descripción" />
      <el-table-column prop="pro_codsunat" label="Código"/>
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="send_delete(scope.row.pro_id)" ><el-icon :size="17"><Delete /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar producto" width="500px" @ok="api_nuevo" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  @submit.prevent ref="form_cref" :rules="rules" :model="form_c" label-width="150px" :size="$isMobile() ? 'small':'default'">
    
    <el-form-item  label="Razón soc. asoc." prop="rs">
      <el-select style="width:300px" v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Código de producto">
      <el-input style="width:300px" v-model="form_c.codigo" />
    </el-form-item>

    <el-form-item label="Descripción">
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
