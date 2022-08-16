<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, List, Search} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'


const form_cref = ref<FormInstance>();

const rules = reactive({
  rs:[{ 
      type: 'number',
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  placa: [{ 
      required: true,
      message: 'Por favor inserte un nro de placa o id',
      trigger: 'blur',
    },
  ],
})
</script>

<script lang="ts">
import modal from "../../components/modal.vue"
export default {
  components: {
    modal
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      datap: [],
      opt_rs: [],
      opt_fp: [],
      opt_td:[],
      opt_via:[],

      data_op:[],

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      alert_mo:'',

      emp_cont:'1',

      form_c : reactive({
        rs:'',
        codigo: '',
        descripcion: '',
      }),
    }
  },

  methods: {

    clear_c() {
      this.form_c.rs= '';
      this.form_c.codigo='';
      this.form_c.descripcion='';
    },

    open_succes(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado.open(); 
    },
    open_succes_ed(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado_ed.open();
    },
    open_confirmar(msg) {
      this.alert_mo=msg;
      this.$refs.mo_advertencia_eliim.open(); 
    },
    close_confirmar() {
      this.$refs.mo_advertencia_eliim.hide();
    },
    close_succes() {
      this.$refs.mo_realizado.hide();
      this.api_get_all();
    },
    close_succes_all() {
      this.$refs.mo_realizado.hide();
      this.clear_c();
      this.$refs.mo_create_per.hide();
    },
    close_succes_ed() {
      this.$refs.mo_realizado_ed.hide(); 
      this.$refs.mo_editar_per.hide();
      this.api_get_all();
      this.search_rs_clear();
    },
    open_fail(msg) {
      this.alert_mo=msg;
      this.$refs.mo_error.open(); 
    },
    close_fail() {
      this.$refs.mo_error.hide(); 
    },
    openedit() {
      this.$refs.mo_editar_per.open();
    },
    closeedit() {
      this.$refs.mo_editar_per.hide();
      this.search_rs_clear();
    },

    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },

    transaccion_insertar() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas/nuevo', 
      {
        "emp_id": this.form_c.rs,
        "tar_codigo": this.form_c.codigo,
        "tar_descripcion": this.form_c.descripcion,
        "tar_usucreacion": this.$store.state.username
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          this.clear_c();
          return true;
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      .catch((e) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, detalles de error: "+String(e) );
        return false;
      })
    },
  },

  mounted () {
    //llamada a API
    this.load_rs();
  },
}

</script>


<template>
  
  <div style="width:900px; margin-left:4.3vw ">

    <el-row style="text-align=center; margin-left:85px">
      <h1 style="margin-left: auto;margin-right: auto">Nueva tarea</h1>
    </el-row>

  
  <el-form :model="form" :label-position="left" label-width="200px"  >


    <el-form-item  label="Razón social asociada">
      <el-select v-model="form_c.rs" placeholder="Seleccionar" style="width:600px" clearable>
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Código">
      <div style="width:600px">
        <el-input v-model="form_c.codigo" placeholder=""/>
      </div>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Tarea">
      <div style="width:600px">
        <el-input v-model="form_c.descripcion" placeholder=""/>
      </div>
    </el-form-item>

    <el-row style="text-align=center; margin-left:100px" >
      <el-button  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto" color="#0844a4" >Guardar</el-button>
    </el-row>
      
    </el-form>
  </div>


<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
