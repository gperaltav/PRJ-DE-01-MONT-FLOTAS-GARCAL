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
import modal from "../components/modal.vue"
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
        subtotal:0,
        impuesto:0,
        total:0,
        tipo_pago:'',
        igv:18,
        obs:''
      }),

      aux : reactive({
        veh_id:'',
        acople_id:'',
        pro_id:'',
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
      this.get_formas_pago();
      this.get_tipos_doc();
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
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
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
    

    get_formas_pago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.form_c.rs))
      .then((resp) => {
        console.log(resp);
        this.opt_fp = resp.data;
      })
    },

    get_tipos_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprastipos/'+String(this.form_c.rs))
      .then((resp) => {
        console.log(resp);
        this.opt_td = resp.data;
      })
    },

    get_chofer(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacionpendientesviajes" ,
      {
        "emp_id": this.emp_cont,
        "tra_nrodocumento":query,
        "tri_licencianro":"",
        "tra_nombre":"",
        "via_fechaviaje":this.form_c.fecha,
        "via_horaviaje":this.form_c.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_op = resp.data;
        })
    },

    get_viajes() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.form_c.rs,
        "via_fechaviaje":this.form_c.fecha_via
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
        "ccc_fechaingreso":  this.form_c.fecha_em,
        "ccc_periodoregistro":"",
        "usu_codigo": this.$store.state.username,
        "ccc_usucreacion":this.$store.state.username
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
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprascab/nuevo', 
      {
        "cabecera": {
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
          "ccc_fechaingreso":  this.form_c.fecha_em,
          "ccc_periodoregistro":"",
          "usu_codigo": this.$store.state.username,
          "ccc_usucreacion":this.$store.state.username
        },
        "detalle": [{
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
          "gui_estado":"VAR",
          "gui_peso":2,
          "ubi_codigoorigen":"010112",
          "ubi_codigodestino":"010113",
          "gui_observacion":"",
          "gui_usucreacion":this.$store.state.username
        }]
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


<style scoped src="./styles/internal.css">

</style>
