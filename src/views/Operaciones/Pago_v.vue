<script lang="ts" setup>
import { reactive } from 'vue'
import {  Filter, Download} from '@element-plus/icons-vue'

import {API} from '@/API'
import {REAPI} from '@/API/report.js';

import type { FormInstance } from 'element-plus'

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
        rs: '',
        tipo_gui: '',
        nro_referencia:'',
        codigo: '',
        fdc: '',
        fech_inicio: null,
        fech_fin: null
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
      REAPI
        .post('facturacionpagoscsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_pagos')
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

    open_fail(msg) {
      this.alert_mo=msg;
      this.$refs.mo_error.open(); 
    },
  
    close_fail() {
      this.alert_cause="";
      this.$refs.mo_error.hide(); 
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

    get_tipos_doc() {
      API
      .post('comprobantescomprastipos/'+String(this.emp_cont))
      .then((resp) => {
        console.log(resp);
        this.opt_td = resp.data;
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
      const tiempoTranscurrido = Date.now();
      const hoy = new Date(tiempoTranscurrido);

      var mm=hoy.getMonth() + 1;
      var aa=hoy.getFullYear();
      var dd=hoy.getDate();

      var fech=aa+"-"+mm+"-"+dd;
      var fech2=aa+"-"+mm+"-01";

      console.log(aa+mm+dd);
      API
      .post('comprobantescompraspagos', {
        "emp_id":"",
        "cct_codigo":"",
        "ccc_serienumero":"",
        "fdc_codigo":"",
        "ccp_nroreferencia":"",
        "ccp_fechacancelacioninicio": null,
        "ccp_fechacancelacionfin": null
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      API
      .post('comprobantescompraspagos', {
        "emp_id": this.form_b.rs,
        "cct_codigo":this.form_b.tipo_gui,
        "ccc_serienumero":this.form_b.codigo,
        "fdc_codigo":this.form_b.fdc,
        "ccp_nroreferencia":this.form_b.nro_referencia,
        "ccp_fechacancelacioninicio": this.form_b.fech_inicio,
        "ccp_fechacancelacionfin": this.form_b.fech_fin
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
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

          <el-form-item label="Tipo de guia">
            <el-select v-model="form_b.tipo_gui" placeholder="Seleccionar" :disabled=rs_disable clearable>
              <el-option
                v-for="item in opt_td"
                :key="item.cct_codigo"
                :label="item.cct_descripcion"
                :value="item.cct_codigo"
              > </el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="Forma de pago">
            <el-select v-model="form_b.fdc" placeholder="Seleccionar" :disabled=rs_disable clearable>
              <el-option
                v-for="item in opt_fcobro"
                :key="item.fdc_codigo"
                :label="item.fdc_descripcion"
                :value="item.fdc_codigo"
              > </el-option>
            </el-select>
          </el-form-item>

          <el-form-item label="Codigo">
            <el-input placeholder="serie-numero" v-model="form_b.codigo" clearable />
          </el-form-item>

          <el-form-item label="Nro. de referencia">
            <el-input v-model="form_b.nro_referencia" clearable />
          </el-form-item>

          <el-form-item label="Fecha de emisión">
            <el-col :span="11">
              <el-date-picker
                v-model="form_b.fech_inicio"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
                type="date"
                placeholder="Seleccionar limite inicial"
                style="width: 100%"
              />
            </el-col>
            <el-col :span="2" class="text-center">
              <span class="text-gray-500">-</span>
            </el-col>
            <el-col :span="11">
              <el-date-picker
                v-model="form_b.fech_fin"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
                type="date"
                placeholder="Seleccionar limite final"
                style="width: 100%"
              />
            </el-col>
          </el-form-item>

          <div class="button-container">
          <el-row class="mb-4">
            <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
          </el-row>
          <el-row class="mb-4">
            <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
          </el-row>
          </div>
        </el-row>

        </el-form>
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
    <el-form @submit.prevent :inline="true"  label-width="auto"  >
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

      <el-form-item label="Tipo de guia">
        <el-select v-model="form_b.tipo_gui" placeholder="Seleccionar" :disabled=rs_disable clearable>
          <el-option
            v-for="item in opt_td"
            :key="item.cct_codigo"
            :label="item.cct_descripcion"
            :value="item.cct_codigo"
          > </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="Forma de pago">
        <el-select v-model="form_b.fdc" placeholder="Seleccionar" :disabled=rs_disable clearable>
          <el-option
            v-for="item in opt_fcobro"
            :key="item.fdc_codigo"
            :label="item.fdc_descripcion"
            :value="item.fdc_codigo"
          > </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="Codigo">
        <el-input placeholder="serie-numero" v-model="form_b.codigo" clearable />
      </el-form-item>

      <el-form-item label="Nro. de referencia">
        <el-input v-model="form_b.nro_referencia" clearable />
      </el-form-item>

      <el-form-item label="Fecha de emisión">
        <el-col :span="11">
          <el-date-picker
            v-model="form_b.fech_inicio"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            type="date"
            placeholder="Seleccionar limite inicial"
            style="width: 100%"
          />
        </el-col>
        <el-col :span="2" class="text-center">
          <span class="text-gray-500">-</span>
        </el-col>
        <el-col :span="11">
          <el-date-picker
            v-model="form_b.fech_fin"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            type="date"
            placeholder="Seleccionar limite final"
            style="width: 100%"
          />
        </el-col>
      </el-form-item>
    </el-col>

    <el-col :span="3">
      <div class="button-container">
      <el-row class="mb-4">
        <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
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
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="140" align="center" />
      <el-table-column prop="ent_nombre" label="Proveedor"  width="200"  />
      <el-table-column prop="ccc_serienumero" label="Serie-Numero" width="120"/>
      <el-table-column prop="cct_descripcion" label="Tipo de doc." width="120" align="center"/>  
      <el-table-column prop="ccc_fechaemision" label="Fecha emision" width="130" align="center"/>
      <el-table-column prop="ccp_fechacancelacion" label="Fecha de pago" width="130" align="center"/>
      <el-table-column prop="cce_descripcion" label="Estado" width="120" align="center"/>
      <el-table-column prop="fdp_descripcion" label="Forma de pago" width="130" align="center" />
      <el-table-column prop="ccc_total" label="Total" /> 
      <el-table-column prop="ccp_nroreferencia" label="Nro. de referencia" width="150" />
    </el-table>
  </div>
</div>

</template>


<style scoped src="../styles/internal.css">

</style>
