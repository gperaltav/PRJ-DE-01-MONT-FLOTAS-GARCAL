<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, List,Search} from '@element-plus/icons-vue'

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
      opt_prv: [],
      opt_fp: [],
      opt_td:[],
      opt_via:[],
      opt_tp:[],

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
        referencia:'',
        subtotal:0,
        moneda:'',
        total:"",
        tipo_pago:'',
        igv:18
      }),

    }
  },

  methods: {

    clear_c() {
      this.form_c.rs= '';
      this.form_c.prv_id='';
      this.form_c.prv_nom='';
      this.form_c.tipo_doc='';
      this.form_c.serie_doc='';
      this.form_c.nro_doc='';
      this.form_c.fecha_em='';
      this.form_c.fecha_via='';
      this.form_c.via_id='';
      this.form_c.cantidad_n='';
      this.form_c.cantidad_un='';
      this.form_c.cantidad_p_uni='';
      this.form_c.referencia='';
      this.form_c.subtotal=0;
      this.form_c.moneda='';
      this.form_c.total="";
      this.form_c.tipo_pago='';
      this.form_c.igv=18;
    },

    rs_changer() {
      this.emp_cont=this.form_c.rs;
      this.form_c.prv_id="";
      this.form_c.prv_nom="";
      this.form_c.via_id="";
      this.form_c.fecha_via="";
      //cargar listas
      this.get_formas_pago();
      this.get_tipos_doc();
      this.get_proveedores("");
    },
    fech_changer() {
      //cargar listas
      this.get_viajes();
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
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },

    load_viajes() {
      
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": Number(this.form_c.rs),
        "gui_fechaemision": this.form_c.fecha_em,
        "gti_codigo": this.form_c.tipo_doc,
        "gui_serie": this.form_c.serie_doc,
        "gui_numero": this.form_c.nro_doc ,
        "via_id": Number(this.form_c.via_id),
        "gui_entdestinatario":"",
        "veh_id": 0,
        "veh_idacople":"",
        "pro_id":3,
        "gui_estado":"",
        "gui_peso":2,
        "ubi_codigoorigen":"010112",
        "ubi_codigodestino":"010113",
        "gui_observacion":"",
        "gui_usucreacion":this.$store.state.username
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
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
    },
    
    get_proveedores(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.form_c.rs),
        "ent_nrodocumento": query,
        "ext_id": "prv"
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp);
        this.opt_prv = resp.data;
      })
    },

    select_proveedores(idx) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/" + String(idx),
      {
        "emp_id":this.form_c.rs,
        "ext_id":"prv"
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data[0]);
          if (resp.data[0]) {
            this.form_c.prv_nom= String(resp.data[0].ent_nombre);
            this.data_clis=[];
            return;
          }
          else {
            return "No name";
          }
        })
    },

    clear_proveedores() {
      this.form_c.prv_nom= "";
    },

    get_formas_pago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.form_c.rs),{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp);
        this.opt_tp = resp.data;
      })
    },

    get_tipos_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprastipos/'+String(this.form_c.rs),{},{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp);
        this.opt_td = resp.data;
      })
    },

    get_viajes() {

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.form_c.rs,
        "via_fechaviaje":this.form_c.fecha_via
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp);
        this.opt_via = resp.data;
      })
    },

    insertar_comprobante() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprascab/nuevo', 
      {
        "emp_id": Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "ccc_serie": this.form_c.serie_doc,
        "ccc_numero": this.form_c.nro_doc,
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
        "ccc_fechaingreso": this.form_c.fecha_em,
        "ccc_periodoregistro":"",
        "usu_codigo": this.$store.state.username,
        "ccc_usucreacion":this.$store.state.username
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          return true;
          
        }
        else {
          return false;
        }
      })
    },

    insertar_guia() {
      axios
      .post('http://51.222.25.71:8080//garcal-erp-apiv1/api/guias/nuevo', 
      {
        "emp_id": Number(this.form_c.rs),
        "gui_fechaemision": this.form_c.fecha_em,
        "gti_codigo": this.form_c.tipo_doc,
        "gui_serie": this.form_c.serie_doc,
        "gui_numero": this.form_c.nro_doc ,
        "via_id": Number(this.form_c.via_id),
        "gui_entdestinatario":"",
        "veh_id": 0,
        "veh_idacople":"",
        "pro_id":3,
        "gui_estado":"",
        "gui_peso":2,
        "ubi_codigoorigen":"010112",
        "ubi_codigodestino":"010113",
        "gui_observacion":"",
        "gui_usucreacion":this.$store.state.username
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          return true;
          
        }
        else {
          return false;
        }
      })
    },

    transaccion_insertar() {
      const tiempoTranscurrido = Date.now();
      const hoy = new Date(tiempoTranscurrido);
      var mm=String(hoy.getMonth() + 1);
      var aa=String(hoy.getFullYear());
      var dd=String(hoy.getDate());

      if(mm.length==1)
        mm="0"+mm;
      if(dd.length==1)
        dd="0"+dd;

      var fech=aa+"-"+mm+"-"+dd;

      console.log(fech);

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescompras/nuevo', 
      {
        "emp_id": Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "ccc_serie": this.form_c.serie_doc,
        "ccc_numero": this.form_c.nro_doc,
        "ccc_fechaemision": this.form_c.fecha_em,
        "ccc_subtotal": "",
        "ccc_impuesto":"",
        "ccc_total": Number(this.form_c.total),
        "cct_codigo": this.form_c.tipo_doc,
        "cce_codigo": "CAN",
        "mon_codigo": "SOL",
        "ccc_observaciones": "",
        "ccc_idreferencia":this.form_c.referencia,
        "ccc_tipocambio": 18,
        "ccc_generamovimiento":false,
        "ccc_fechaingreso": fech,
        "ccc_periodoregistro": fech,
        "ccr_codigo":"PAG",
        "usu_codigo": this.$store.state.username,
        "ccc_usucreacion":this.$store.state.username,
        "detalle":[{
          "pro_id":"",
          "via_id":Number(this.form_c.via_id),
          "veh_id":"",
          "tra_id":"",
          "ccd_serie":this.form_c.serie_doc,
          "ccd_cantidad":"",
          "ccd_preciounitario":this.form_c.cantidad_p_uni,
          "ccd_subtotal":this.form_c.total,
          "uni_unidad":"UNI"
        }]
      },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
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
      .catch((error) => {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
    },

    create_api(){
      //llamada a API
      var r1=this.insertar_comprobante();
      var r2=this.insertar_guia();

      if(r1 && r2) {
        this.open_succes("Operación realizada satisfactoriamente");
      }
      else {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación");
      }

    },  

    roundUp(num, precision) {
      precision = Math.pow(10, precision)
      return Math.ceil(num * precision) / precision
    },
    roundDwn(num, precision) {
      precision = Math.pow(10, precision)
      return Math.floor(num * precision) / precision
    },
    calcular1() {
      this.form_c.impuesto=String(this.roundUp((Number(this.form_c.igv)/100)*Number(this.form_c.subtotal),1));
      this.form_c.total=String(Number(this.form_c.impuesto)+Number(this.form_c.subtotal));
    },
    calcular2() {
      var aux=Number(this.form_c.total)/(100+Number(this.form_c.igv));
      this.form_c.impuesto=String(this.roundUp(aux*Number(this.form_c.igv),1));
      this.form_c.subtotal=String(this.roundDwn(aux*100,1));
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
  
  <div v-if="!$isMobile()" style="width:900px; margin-left:auto;margin-right:auto;padding-right:200px">

    <el-row style="text-align=center;">
      <h1 style="margin-left: auto;margin-right: auto">Añadir pago</h1>
    </el-row>

  
  <el-form @submit.prevent :model="form" :label-position="left" label-width="200px" >

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
      <el-col :span="8">
        <el-select
          v-model="form_c.prv_id"
          filterable
          :remote-method="get_proveedores"
          @change="select_proveedores"
          @clear="clear_proveedores"
          placeholder="Inserte ID de proveedor"
          remote
          clearable
          :disabled="stop_cliente"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in opt_prv"
            :key="item.ent_id"
            :label="item.ent_nrodocumento"
            :value="item.ent_id"
          />
        </el-select>
      </el-col>
      <el-col :span="16"><el-input disabled v-model="form_c.prv_nom" placeholder="Nombre de proveedor" /></el-col>
      </el-row>
    </el-form-item>

    <el-row style="width:800px; margin-bottom: 18px"> 
      <el-col :span="6">
        <el-select v-model="form_c.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  clearable>
        <el-option
          v-for="item in opt_td"
          :key="item.cct_codigo"
          :label="item.cct_descripcion"
          :value="item.cct_codigo"
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

    <el-form-item  label="Fecha de pago">
      <el-date-picker
        type="date"
        v-model="form_c.fecha_em"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        placeholder="Seleccione fecha"
        style="width: 300px"
      />
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
      <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
        <el-option
          v-for="item in opt_tp"
          :key="item.fdp_id"
          :label="item.fdp_descripcion"
          :value="item.fdp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Nro. de referencia">
      <div style="width:300px">
        <el-input v-model="form_c.referencia" placeholder="Inserte codigo de referencia"/>
      </div>
    </el-form-item>

    <el-form-item  label="Monto">
      <el-row style="width:600px">
        <el-col :span="6">
          <el-input v-model="form_c.total" placeholder="Monto" /> 
        </el-col>
        <el-col :span="6"> 
          <el-select v-model="form_c.moneda" placeholder="Moneda" style="width:150px" clearable>
            <el-option label="SOLES (S/.)" value="SOL" />
            <el-option label="DOLARES ($)" value="DOL" />
          </el-select> 
        </el-col>
      </el-row>
    </el-form-item>
    <el-row style="text-align=center;" >
      <el-button  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto" color="#0844a4" >Guardar</el-button>
    </el-row>   
    </el-form>
  </div>

  <div v-else>
     <el-row style="text-align=center;">
      <h1 style="margin-left: auto;margin-right: auto">Añadir pago</h1>
    </el-row>

  
  <el-form @submit.prevent :model="form" :label-position="left" label-width="100px" :size="$isMobile() ? 'small':'default'">

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
        <el-select
          v-model="form_c.prv_id"
          filterable
          :remote-method="get_proveedores"
          @change="select_proveedores"
          @clear="clear_proveedores"
          placeholder="Inserte ID de proveedor"
          remote
          clearable
          :disabled="stop_cliente"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in opt_prv"
            :key="item.ent_id"
            :label="item.ent_nrodocumento"
            :value="item.ent_id"
          />
        </el-select>

      <el-input disabled v-model="form_c.prv_nom" placeholder="Nombre de proveedor" />
      </el-row>
    </el-form-item>



      <el-form-item label="Tipo de doc">
        <el-select v-model="form_c.tipo_doc"  placeholder="Tipo de doc."  clearable>
        <el-option
          v-for="item in opt_td"
          :key="item.cct_codigo"
          :label="item.cct_descripcion"
          :value="item.cct_codigo"
        > </el-option>
        </el-select>
      </el-form-item>

    

      <el-form-item  label="Nro. de serie">
        <el-input v-model="form_c.serie_doc" placeholder="nro de serie" />
      </el-form-item>
      <el-form-item  label="Nro. de documento">
        <el-input v-model="form_c.nro_doc" placeholder="nro de documento" />
      </el-form-item>


    <el-form-item  label="Fecha de pago">
      <el-date-picker
        type="date"
        v-model="form_c.fecha_em"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        placeholder="Seleccione fecha"
        style="width: 300px"
      />
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
      <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
        <el-option
          v-for="item in opt_tp"
          :key="item.fdp_id"
          :label="item.fdp_descripcion"
          :value="item.fdp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Nro. de referencia">
      <div style="width:300px">
        <el-input v-model="form_c.referencia" placeholder="Inserte codigo de referencia"/>
      </div>
    </el-form-item>

    <el-form-item  label="Monto">
      <el-row style="width:600px">
        <el-col :span="6">
          <el-input v-model="form_c.total" placeholder="Monto" /> 
        </el-col>
        <el-col :span="6"> 
          <el-select v-model="form_c.moneda" placeholder="Moneda" style="width:150px" clearable>
            <el-option label="SOLES (S/.)" value="SOL" />
            <el-option label="DOLARES ($)" value="DOL" />
          </el-select> 
        </el-col>
      </el-row>
    </el-form-item>
    <el-row style="text-align=center;" >
      <el-button  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto" color="#0844a4" >Guardar</el-button>
    </el-row>   
    </el-form>
  </div>


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


<style scoped src="../styles/internal.css">

</style>
