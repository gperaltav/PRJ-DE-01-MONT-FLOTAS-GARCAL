<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'



const checkyear = (rule: any, value: any, callback: any) => {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!/^[0-9][0-9][0-9][0-9]/.test(value)) {
      callback(new Error('Sólo se permiten números'));
    }
    else {
      callback()
    }
  }, 500)
}

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

  marca:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  modelo:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  clase:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  tipo:[{ 
      required: true,
      message: 'Por favor seleccione una opción',
      trigger: 'change',
    },
  ],
  year:[
    {required: true, message: 'Inserte un año'},
    {validator: checkyear, trigger: 'blur' },
  ],
})
</script>

<script lang="ts">
import Sidebar from "../../components/Sidebar.vue"
import modal from "../../components/modal.vue"
export default {
  components: {
    Sidebar,
    modal
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      datap: [],
      opt_rs: [],

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      alert_mo:'',

      emp_cont:'1',

      form_c : reactive({
        rs: '',
        prv_id:'',
        prv_nom:'',
        tipo_doc:'',
        serie_doc:'',
        nro_doc:'',
        fecha_em:'',
        fecha_via:'',
        via_id:'',
        cantidad_n:'',
        cantidad_un:'',
        cantidad_p_uni:'',
        subtotal:'',
        impuesto:'',
        total:'',
        tipo_pago:''
      }),

    }
  },

  methods: {

    clear_c() {
      this.form_c.rs='';
      this.form_c.placa='';
      this.form_c.marca='';
      this.form_c.modelo='';
      this.form_c.tipo='';
      this.form_c.clase='';
      this.form_c.year='';
      this.form_c.serie='';
      this.form_c.mtc='';
      this.form_c.carga_uti='';
      this.form_c.kilometraje='';
    },

    rs_changer() {
      this.emp_cont=this.form_c.rs;
      this.form_c.prv_id="";
      this.form_c.prv_nom="";
      this.form_c.via_id="";
      this.form_c.fecha_via="";
      //cargar listas
      this.load_mar();
      this.load_mod();
      this.load_cla();
      this.load_ti();
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
      this.$refs.mo_editar_per.hide();
      this.api_get_all();
      this.search_rs_clear();
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

    create_api(){
      //llamada a API

          axios
          .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprascab/nuevo', 
          { 
            "emp_id": Number(this.form_c.rs),
            "ent_id": Number(this.form_c.prv_id),
            "ccc_serie": this.form_c.serie_doc,
            "ccc_numero": this.form_c.numero_doc,
            "ccc_fechaemision": this.form_c.fecha_em,
            "ccc_subtotal": Number(this.form_c.subtotal),
            "ccc_impuesto": Number(this.form_c.impuesto),
            "ccc_total": Number(this.form_c.total),
            "cct_codigo": "BOL",
            "cce_codigo": "CAN",
            "mon_codigo": "SOL",
            "ccc_observaciones": "",
            "ccc_idreferencia":null,
            "ccc_tipocambio": 18,
            "ccc_generamovimiento":false,
            "ccc_fechaingreso": "2022-01-06",
            "ccc_periodoregistro": "2022-01-07",
            "usu_codigo": "admin",
            "ccc_usucreacion":"admin"
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
          return false;
    },  

    button_handle(number){
      console.log(number);
      this.clear_eop;
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      this.load_edit(number);
      
      setTimeout(() => {
        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      }, 400)
    }
  },

  mounted () {
    //llamada a API
    this.load_rs();
    //this.load_tc();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
  <el-container class="layout-container" style="height: calc( 100vh - 20px );" >
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          Base de datos > Vehículos
        </el-tag>
      </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
      </el-col>
    </el-header>

    <el-container style="height: calc( 100vw - 100px );">
      <el-aside width="200px">
        <el-scrollbar>
          <Sidebar />
        </el-scrollbar>
      </el-aside>

      <el-main style="background-color:white">
        <el-scrollbar>
          
          <div style="width:900px; margin-left:4.3vw ">

            <el-row style="text-align=center; margin-left:85px">
              <h1 style="margin-left: auto;margin-right: auto">Añadir combustible</h1>
            </el-row>

          
          <el-form :model="form" :label-position="left" label-width="200px" >

            <el-form-item  label="Razón social asociada">
              <el-select v-model="form_c.rs" @change="rs_changer" @clear="clear_c" placeholder="Seleccionar" style="width:600px" clearable>
                <el-option
                  v-for="item in opt_rs"
                  :key="item.emp_id"
                  :label="item.emp_razonsocial"
                  :value="item.emp_id"
                  
                > </el-option>
              </el-select>
            </el-form-item>

            <el-form-item  label="Proveedor">
              <el-row style="width:600px"> 
              <el-col :span="8"><el-input v-model="form_c.prv_id" placeholder="ID de proveedor" /></el-col>
              <el-col :span="16"><el-input v-model="form_c.prv_nom" placeholder="Nombre de proveedor" /></el-col>
              </el-row> 
            </el-form-item>

            <el-row style="width:800px; margin-bottom: 18px"> 
              <el-col :span="6">
                <el-select v-model="form_c.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  clearable>
                <el-option
                  v-for="item in opt_rs"
                  :key="item.emp_id"
                  :label="item.emp_razonsocial"
                  :value="item.emp_id"
                > </el-option>
                </el-select>
              </el-col>
            
              <el-col :span="18">     
                  <el-row > 
                    <el-col :span="12" >
                      <el-input v-model="form_c.serie_doc" placeholder="nro de serie" />
                    </el-col>
                    <el-col :span="12">
                      <el-input v-model="form_c.nro_doc" placeholder="nro de documento" />
                    </el-col>
                  </el-row>
              </el-col>

            </el-row>

            <el-form-item  label="Fecha de emisión">
              <el-date-picker
                type="date"
                v-model="form_c.fecha_em"
                format="YYYY-MM-DD"
                value-format="YYYY-MM-DD"
                placeholder="Seleccione fecha"
                style="width: 300px"
              />
            </el-form-item>

            <el-form-item label="Fecha de viaje">
              <el-row style="width:600px">
              <el-col span="12">
                <el-date-picker
                  type="date"
                  v-model="form_c.fecha_via"
                  format="YYYY-MM-DD"
                  value-format="YYYY-MM-DD"
                  placeholder="Seleccione fecha"
                  style="width: 300px"
                />
              </el-col>
              
              <el-col :span="12">
                <el-select v-model="form_c.via_id" placeholder="Seleccione una opcion" style="width:300px" clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                  > </el-option>
                </el-select> 
              </el-col>
              </el-row>
            </el-form-item>

            <el-form-item  label="Cantidad">
              <el-row style="width:600px">
                <el-col :span="6">
                  <el-input v-model="form_c.cantidad_n" placeholder="Cantidad" /> 
                </el-col>
                <el-col :span="6"> 
                  <el-select v-model="form_c.cantidad_un" placeholder="Unidad" style="width:150px" clearable>
                    <el-option
                      v-for="item in opt_rs"
                      :key="item.emp_id"
                      :label="item.emp_razonsocial"
                      :value="item.emp_id"
                    > </el-option>
                  </el-select> 
                </el-col>
                <el-col span="12">
                  <el-form-item label-width="100px" label="P. Unitario">
                    <el-input v-model="form_c.cantidad_p_uni" placeholder="Seleccionar" />
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form-item>

            <el-form-item style="margin-left: auto;margin-right: auto" label="Valor venta">
              <div style="width:300px">
                <el-input v-model="form_c.subtotal" placeholder="Inserte una cantidad"/>
              </div>
            </el-form-item>

            <el-form-item style="margin-left: auto;margin-right: auto" label="Impuesto">
              <div style="width:300px">
                <el-input v-model="form_c.impuesto" placeholder="Inserte una cantidad"/>
              </div>
            </el-form-item>

            <el-form-item style="margin-left: auto;margin-right: auto" label="Total">
              <div style="width:300px">
                <el-input v-model="form_c.total" placeholder="Inserte una cantidad"/>
              </div>
            </el-form-item>

            <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
              <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
                <el-option
                  v-for="item in opt_rs"
                  :key="item.emp_id"
                  :label="item.emp_razonsocial"
                  :value="item.emp_id"
                  
                > </el-option>
              </el-select>
            </el-form-item>

            <el-row style="text-align=center; margin-left:100px" >
              <el-button style="margin-left: auto;margin-right: auto" color="#0844a4" >Guardar</el-button>
            </el-row>
              
            </el-form>
            </div>

          
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>


<modal ref="mo_advertencia_eliim" title="Confirmar" centered @ok="send_delete" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="../styles/basededatos.css">

</style>
