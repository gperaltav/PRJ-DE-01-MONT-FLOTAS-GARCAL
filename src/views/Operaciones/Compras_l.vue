<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold,Search,CreditCard} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'

const checknombre = (rule: any, value: any, callback: any) => {
  if (!value) {
    return callback(new Error('Por favor inserte un nombre'))
  }
  setTimeout(() => {
    if (!/^[a-zA-Z\u00C0-\u00D6\u00D9-\u00F6\u00F9-\u00FF ]+$/.test(value)) {
      callback(new Error('Sólo se permiten letras y espacios'));
    }
    else {
      callback()
    }
  }, 500)
}
const checknumeros = (rule: any, value: any, callback: any) => {
  if (!value) {
    return callback();
  }
  setTimeout(() => {
    if (!/^[0-9\u0000]+$/.test(value)) {
      callback(new Error('Sólo se permiten letras y espacios'));
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
  nro_doc: [{ 
      required: true,
      message: 'Por favor inserte un nro de documento',
      trigger: 'blur',
    },
  ],

  nombre: [
    {required: true, validator: checknombre, trigger: 'blur' },
  ],
  
  telefono: [
    {required: true, message: 'Inserte un numero de telefono'},
    {validator: checknumeros, trigger: 'blur' },
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
      var_type:'prv',
      editpointer:0,
      succes: false,
      operarios_id:[2,4],
      datap: [],
      opt_rs: [],
      opt_via: [],

      data_aux: [],

      opt_cli:[],

      opt_td:[],
      opt_fp:[],
      opt_prod:[],

      opt_fcobro:[],

      err_code:false,
      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      open_op:false,
      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',
      alert_cause:'',

      form_b : reactive({
        rs: '',
        tipo_gui: '',
        codigo: '',
        fech_inicio: null,
        fech_fin:null
      }),

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
        igv:18
      }),

      form_e : reactive({
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
        igv:18
      }),

      form_p : reactive({
        rs: '',
        cli_id:'',
        cli_nom:'',
        tipo_doc:'',
        serie_doc:'',
        nro_doc:'',
        tipo_cobro:'',
        fecha_cobro:'',
        nro_referencia:'',
        monto:"",
        moneda:'',
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
    get_descarga() {
       axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);  
          //Download(resp.data.message,"Descargar");
          const url = window.URL
                .createObjectURL(new Blob([resp.data.message]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', 'reporte.csv');
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
        })
      
    },

    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.tipo_gui="";

      //cargar listas
      this.get_tipos_doc();

    },
    search_rs_clear() {
      this.form_b.tipo_gui="";
      this.opt_td = [];
    },

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
      this.form_c.subtotal=0;
      this.form_c.impuesto=0;
      this.form_c.total=0;
      this.form_c.tipo_pago='';
      this.form_c.igv=18;
    },

    clear_p() {
      this.form_p.rs='';
      this.form_p.cli_id='';
      this.form_p.cli_nom='';
      this.form_p.tipo_doc='';
      this.form_p.serie_doc='';
      this.form_p.nro_doc='';
      this.form_p.tipo_cobro='';
      this.form_p.fecha_cobro='';
      this.form_p.nro_referencia='';
      this.form_p.monto="";
      this.form_p.moneda='';
    },

    rs_changer(id) {
      console.log(id);
      
      this.emp_cont=id;

      this.form_c.prv_id="";
      this.form_c.prv_nom="";
      this.form_c.via_id="";
      this.form_c.fecha_via="";

      this.form_e.prv_id="";
      this.form_e.prv_nom="";
      this.form_e.via_id="";
      this.form_e.fecha_via="";

      this.form_p.cli_id="";
      this.form_p.cli_nom="";

      this.opt_cli=[];
      this.opt_fcobro=[];
      //cargar listas
      if(id) {
        this.get_formas_pago();
        this.get_tipos_doc();
      }
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
      this.$refs.mo_create.hide();
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
    open_fail2(msg,msg2) {
      this.alert_mo=msg;
      this.alert_cause=msg2;
      this.$refs.mo_error.open(); 
    },
    close_fail() {
      this.alert_cause="";
      this.$refs.mo_error.hide(); 
    },
    openedit() {
      this.$refs.mo_editar_per.open();
    },
    closeedit() {
      this.$refs.mo_editar_per.hide();
      this.search_rs_clear();
    },
    opencrear() {
      this.open_op=false;
      this.load_rs();
      this.$refs.mo_create.open();
    },
    closecrear() {
      this.$refs.mo_create.hide();
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
    
    load_fpago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);  
          this.opt_fpago = resp.data;
        })
    },
    load_tdoc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/documentos', 
        { 
          "emp_id":String(this.emp_cont),
          "dti_referencia_uso":""
        })
        .then((resp) => {
          console.log(resp);  
          this.opt_tdoc = resp.data;
        })
    },
    load_prod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);  
          this.opt_prod = resp.data;
        })
    },

    load_edit(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      this.err_code=false;
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Comprobante anulada correctamente");
            this.err_code = true;
          }
          else {
            this.open_fail2("Hubo un error con el servidor al ejecutar la operación","Código de error: "+resp.data.message);
          }
        })
        setTimeout(() => {
        if (this.err_code==false) {
          this.open_fail("Hubo un error al comunicarse con el servidor, revise su conexión");
        }
        }, 700)
        
        return this.err_code;
    },

    get_clientes(query) {
      console.log(query);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.emp_cont),
        "ent_nrodocumento": query,
        "ext_id": "cli"
      })
      .then((resp) => {
        console.log(resp);
        this.opt_cli = resp.data;
      })
    },

    select_clientes (id) {
      for (let tmp in this.opt_cli)  {
        console.log(tmp);
        if (this.opt_cli[tmp].ent_id == id) {
          this.form_c.prv_nom= this.opt_cli[tmp].ent_nombre;
          return;
        }
      }
    },

    select_clientes2 (id) {
      for (let tmp in this.opt_cli)  {
        console.log(tmp);
        if (this.opt_cli[tmp].ent_id == id) {
          this.form_e.prv_nom= this.opt_cli[tmp].ent_nombre;
          return;
        }
      }
    },

    select_clientes3 (id) {
      for (let tmp in this.opt_cli)  {
        console.log(tmp);
        if (this.opt_cli[tmp].ent_id == id) {
          this.form_p.cli_nom= this.opt_cli[tmp].ent_nombre;
          return;
        }
      }
    },

    select_clientes4 (id) {
      for (let tmp in this.opt_cli)  {
        console.log(tmp);
        if (this.opt_cli[tmp].ent_id == id) {
          this.form_p.cli_nom= this.opt_cli[tmp].ent_nombre;
          return;
        }
      }
    },

    clear_clientes() {
      this.form_c.prv_nom="";
    },

    get_formas_pago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdecobro/'+String(this.emp_cont))
      .then((resp) => {
        console.log(resp);
        this.opt_fp = resp.data;
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

    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.get_formas_pago();
      this.get_tipos_doc();

      this.form_e.prv_id=this.data_edit[0].ent_id;
      this.get_clientes("");
      this.select_clientes2(this.form_e.prv_id);

      this.form_e.tipo_doc=this.data_edit[0].cvt_codigo;
      this.form_e.serie_doc=this.data_edit[0].cvc_serie;
      this.form_e.nro_doc=this.data_edit[0].cvc_numero;
      this.form_e.fecha_em=this.data_edit[0].cvc_fechaemision;
      this.form_e.via_id=this.data_edit[0].via_id;
      this.form_e.subtotal=this.data_edit[0].cvc_subtotal;
      this.form_e.impuesto=this.data_edit[0].cvc_impuesto;
      this.form_e.total=this.data_edit[0].cvc_total;

      this.form_e.fecha_via=this.data_edit[0].cvc_observaciones;
      this.get_viajes2();

      this.form_e.tipo_pago=this.data_edit[0].cvc_observacionesopcional;
    },

    load_data_pago() {
      this.form_p.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_p.rs;
      //carga de listas
      this.get_formas_pago();
      this.get_tipos_doc();

      this.form_p.cli_id=this.data_edit[0].ent_id;
      this.get_clientes("");

      this.form_p.tipo_doc=this.data_edit[0].cvt_codigo;
      this.form_p.serie_doc=this.data_edit[0].cvc_serie;
      this.form_p.nro_doc=this.data_edit[0].cvc_numero;

      setTimeout(() => {
        this.select_clientes4(this.form_p.cli_id);
      }, 500)

      this.form_p.tipo_cobro=this.data_edit[0].cvc_observacionesopcional;
    },

    load_viaje_data(id) {
      console.log(id);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/'+String(id))
      .then((resp) => {
        console.log(resp);
        this.data_aux = resp.data[0];
        console.log(this.datap);
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
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab', {
        "emp_id": "",
        "cvt_codigo":"",
        "cvc_serienumero":"",
        "cve_codigo":"",
        "cvc_fechaemisioninicio": fech,
        "cvc_fechaemisionfin": fech
      })
      .then((resp) => {
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab', 
      {
        "emp_id": Number(this.form_b.rs),
        "cvt_codigo":this.form_b.tipo_gui,
        "cvc_serienumero":"",
        "cve_codigo":this.form_b.codigo,
        "cvc_fechaemisioninicio": this.form_b.fech_inicio,
        "cvc_fechaemisionfin": this.form_b.fech_fin
      })
      .then((resp) => {
        console.log(resp);
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    fech_changer() {
      //cargar listas
      this.get_viajes();
    },

    fech_changer2() {
      //cargar listas
      this.get_viajes2();
    },

    get_viajes() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.emp_cont,
        "via_fechaviaje":this.form_c.fecha_via
      })
      .then((resp) => {
        console.log(resp);
        this.opt_via = resp.data;
      })
    },

    get_viajes2() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.emp_cont,
        "via_fechaviaje":this.form_e.fecha_via
      })
      .then((resp) => {
        console.log(resp);
        this.opt_via = resp.data;
      })
    },
    
    create_usr(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab/nuevo', 
      { 
        "emp_id":Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "cvc_serie": this.form_c.serie_doc,
        "cvc_numero": this.form_c.nro_doc,
        "cvc_fechaemision": this.form_c.fecha_em,
        "cvc_fechavencimiento": null,
        "cvc_subtotal": this.form_c.subtotal,
        "cvc_impuesto": this.form_c.impuesto,
        "cvc_total": this.form_c.total,
        "cvt_codigo": this.form_c.tipo_doc,
        "cve_codigo": "EMI",
        "mon_codigo": "SOL",
        "cve_tipocambio":18,
        "cvc_idreferencia": null,
        "cvc_observaciones":this.form_c.fecha_via,
        "cvc_observacionesopcional": this.form_c.tipo_pago,
        "gui_idremitente": "",
        "gui_idtransportisa": "",
        "via_id":this.form_c.via_id,
        "usu_codigo":"admin",
        "cvc_usucreacion":"admin"
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

    create_cobranza() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventascobros/nuevo', 
      { 
        "emp_id": Number(this.form_p.rs),
        "cvc_id": Number(this.editpointer),
        "fdc_codigo": this.form_p.tipo_cobro,
        "vec_monto":Number(this.form_p.monto),
        "vec_nroreferencia":this.form_p.nro_referencia,
        "vec_fechacancelacion":this.form_p.fecha_cobro,
        "vec_descripcion":"",
        "vec_tipocambio":18,
        "mon_codigo":this.form_p.moneda,
        "vec_usucreacion":"admin"
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          this.clear_p();
          this.$refs.mo_create_pago.hide();
          return true;
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
      return false;

    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create.hide(); 
    },

    editar_usr(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab/actualizar', 
        { 
          "cvc_id":Number(this.editpointer),
          "emp_id":Number(this.form_e.rs),
          "ent_id": Number(this.form_e.prv_id),
          "cvc_serie": this.form_e.serie_doc,
          "cvc_numero": this.form_e.nro_doc,
          "cvc_fechaemision": this.form_e.fecha_em,
          "cvc_fechavencimiento": null,
          "cvc_subtotal": this.form_e.subtotal,
          "cvc_impuesto": this.form_e.impuesto,
          "cvc_total": this.form_e.total,
          "cvt_codigo": this.form_e.tipo_doc,
          "cve_codigo": "EMI",
          "mon_codigo": "SOL",
          "cve_tipocambio":18,
          "cvc_idreferencia": null,
          "cvc_observaciones":this.form_e.fecha_via,
          "cvc_observacionesopcional": this.form_e.tipo_pago,
          "gui_idremitente": "",
          "gui_idtransportisa": "",
          "via_id":this.form_e.via_id,
          "usu_codigo":"admin",
          "cvc_usucreacion":"admin"
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Comprobante modificado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
          console.log(resp);
        })
        return false;
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
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      this.load_edit(number);
      
      setTimeout(() => {
        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      }, 500)
    },

    button_handle_pago(number){
      console.log(number);
      this.editpointer=number;
      this.wait2 = true;
      this.load_edit(number);
      this.$refs.mo_create_pago.open();

      setTimeout(() => {
        this.load_data_pago();
        this.wait2 = false;
      }, 600)
    }
  },

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
    //this.load_tc();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
  
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

      <el-form-item label="Tipo de guia">
        <el-select v-model="form_b.tipo_gui" placeholder="Seleccionar" clearable>
          <el-option
            v-for="item in opt_td"
            :key="item.cct_codigo"
            :label="item.cct_descripcion"
            :value="item.cct_codigo"
          > </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="Codigo">
        <el-input placeholder="serie-numero" v-model="form_b.nombre" clearable />
      </el-form-item>

      <el-form-item label="Fecha de emisión">
        <el-col :span="11">
          <el-date-picker
            v-model="form_b.fecha_i"
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
            v-model="form_b.fecha_f"
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
        <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
      </el-row>
      <el-row class="mb-4">
        <el-button color="#95d475" :icon=" Download" @click="get_descarga" disabled>A Excel</el-button>
      </el-row>
      </div>
    </el-col>
    </el-row>

    </el-form>

  <div class="table-container">
    <el-table :data="datap" border header-row-style="color:black;"  max-height="75vh">
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="140" align="center" />
      <el-table-column prop="cvt_descripcion" label="Tipo de doc."  width="120" align="center" />
      <el-table-column prop="cvc_serienumero" label="Serie-numero" width="140" sortable/>  
      <el-table-column prop="cvc_fechaemision" label="Fecha emision" width="130" align="center"/>  
      <el-table-column prop="ent_nombre" label="Nombre cliente" width="160"/>
      <el-table-column prop="cvc_subtotal" label="Subtotal" />
      <el-table-column prop="cvc_impuesto" label="Impuesto" />
      <el-table-column prop="cvc_total" label="Total" /> 
      <el-table-column prop="cvc_comprobantereferencia" label="Referencia" />
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle_pago(scope.row.cvc_id)" size="small"><el-icon :size="17"><CreditCard /></el-icon></el-button>
        </template>
      </el-table-column>
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.cvc_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>


<modal ref="mo_create" no-close-on-backdrop title="Agregar Comprobante" width="900px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="200px" >
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

  <el-form-item  label="Cliente">
    <el-row style="width:600px"> 
    <el-col :span="8">
    <el-select
      v-model="form_c.prv_id"
      filterable
      :remote-method="get_clientes"
      @change="select_clientes"
      @clear="clear_clientes"
      placeholder="Inserte ID de cliente"
      remote
      clearable
    >
      <template #prefix>
        <el-icon><Search /></el-icon>
      </template>

      <el-option
      v-for="item in opt_cli"
      :key="item.ent_id"
      :label="item.ent_nrodocumento"
      :value="item.ent_id"
      />
    </el-select>
    </el-col>
    <el-col :span="16"><el-input disabled v-model="form_c.prv_nom" placeholder="Nombre de cliente" /></el-col>
    </el-row>
  </el-form-item>

  
  <el-form-item label="Fecha de viaje">
      <el-row style="width:600px">
      <el-col :span="12">
      <el-date-picker
          type="date"
          v-model="form_c.fecha_via"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          style="width: 300px"
          @change="fech_changer"
      />
      </el-col>
      
      <el-col :span="12">
      <el-select v-model="form_c.via_id" placeholder="Seleccione una opcion" style="width:300px" clearable>
          <el-option
          v-for="item in opt_via"
          :key="item.via_id"
          :label="item.via_descripcion"
          :value="item.via_id"
          > </el-option>
      </el-select> 
      </el-col>
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

  <el-form-item style="margin-left: auto;margin-right: auto" label="Valor venta">
      <div style="width:300px">
      <el-input v-model="form_c.subtotal" placeholder="Inserte una cantidad">
          <template #append>
          <el-button @click="calcular1()" ><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
      </el-input>
      </div>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Impuesto">
      <div style="width:240px">
      <el-input v-model="form_c.impuesto" placeholder="Inserte una cantidad">
          <template #prepend>S/</template>
      </el-input>
      </div>
      <el-input style="width:60px" v-model="form_c.igv">
      <template #suffix>%</template>
      </el-input>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Total">
      <div style="width:300px">
      <el-input v-model="form_c.total" placeholder="Inserte una cantidad">
          <template #append>
          <el-button  @click="calcular2()"><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
      </el-input>
      </div>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de cobro">
      <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
      <el-option
          v-for="item in opt_fp"
          :key="item.fdc_codigo"
          :label="item.fdc_descripcion"
          :value="item.fdc_codigo"
      > </el-option>
      </el-select>
  </el-form-item>
  </el-form>
</modal>



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Comprobante" width="900px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_cref" :rules="rules" :model="form" label-width="200px" >

    <el-form-item  label="Razón social asociada">
      <el-select v-model="form_e.rs" @change="rs_changer" @clear="clear_c" placeholder="Seleccionar" style="width:600px" clearable>
        <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item  label="Cliente">
      <el-row style="width:600px"> 
      <el-col :span="8">
      <el-select
        v-model="form_e.prv_id"
        filterable
        :remote-method="get_clientes"
        @change="select_clientes"
        @clear="clear_clientes"
        placeholder="Inserte ID de cliente"
        remote
        clearable
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>

        <el-option
        v-for="item in opt_cli"
        :key="item.ent_id"
        :label="item.ent_nrodocumento"
        :value="item.ent_id"
        />
      </el-select>
      </el-col>
      <el-col :span="16"><el-input disabled v-model="form_e.prv_nom" placeholder="Nombre de cliente" /></el-col>
      </el-row>
    </el-form-item>

    <el-row style="width:800px; margin-bottom: 18px"> 
      <el-col :span="6">
      <el-select v-model="form_e.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  clearable>
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
          <el-input v-model="form_e.serie_doc" placeholder="nro de serie" />
        </el-col>
        <el-col :span="12">
          <el-input v-model="form_e.nro_doc" placeholder="nro de documento" />
        </el-col>
        </el-row>
      </el-col>

    </el-row>

    <el-form-item  label="Fecha de emisión">
        <el-date-picker
        type="date"
        v-model="form_e.fecha_em"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        placeholder="Seleccione fecha"
        style="width: 300px"
        />
    </el-form-item>

    <el-form-item label="Fecha de viaje">
        <el-row style="width:600px">
        <el-col :span="12">
        <el-date-picker
            type="date"
            v-model="form_e.fecha_via"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Seleccione fecha"
            style="width: 300px"
            @change="fech_changer2"
        />
        </el-col>
        
        <el-col :span="12">
        <el-select v-model="form_e.via_id" placeholder="Seleccione una opcion" style="width:300px" clearable>
            <el-option
            v-for="item in opt_via"
            :key="item.via_id"
            :label="item.via_descripcion"
            :value="item.via_id"
            > </el-option>
        </el-select> 
        </el-col>
        </el-row>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Valor venta">
        <div style="width:300px">
        <el-input v-model="form_e.subtotal" placeholder="Inserte una cantidad">
            <template #append>
            <el-button @click="calcular1()" ><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
            </template>
            <template #prepend>S/</template>
        </el-input>
        </div>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Impuesto">
        <div style="width:240px">
        <el-input v-model="form_e.impuesto" placeholder="Inserte una cantidad">
            <template #prepend>S/</template>
        </el-input>
        </div>
        <el-input style="width:60px" v-model="form_e.igv">
        <template #suffix>%</template>
        </el-input>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Total">
        <div style="width:300px">
        <el-input v-model="form_e.total" placeholder="Inserte una cantidad">
            <template #append>
            <el-button  @click="calcular2()"><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
            </template>
            <template #prepend>S/</template>
        </el-input>
        </div>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
        <el-select v-model="form_e.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
        <el-option
          v-for="item in opt_fp"
          :key="item.fdc_codigo"
          :label="item.fdc_descripcion"
          :value="item.fdc_codigo"
        > </el-option>
        </el-select>
    </el-form-item>

    <el-row style="text-align=center" >
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar este comprobante?')">Eliminar</el-button>
    </el-row>

  </el-form>
</modal>

<modal ref="mo_create_pago" no-close-on-backdrop title="Agregar Cobranza" width="900px" @ok="create_cobranza"  cancel-title="Atras" centered>
  <el-form v-loading="wait2" ref="form_cref" :rules="rules" :model="form_c" label-width="200px" >

  <el-form-item  label="Razón social asociada">
    <el-select v-model="form_p.rs" @change="rs_changer" @clear="rs_changer" placeholder="Seleccionar" style="width:600px" disabled>
      <el-option
        v-for="item in opt_rs"
        :key="item.emp_id"
        :label="item.emp_razonsocial"
        :value="item.emp_id"
      > </el-option>
    </el-select>
  </el-form-item>

  <el-form-item  label="Cliente">
    <el-row style="width:600px"> 
    <el-col :span="8">
    <el-select
      v-model="form_p.cli_id"
      filterable
      :remote-method="get_clientes"
      @change="select_clientes3"
      @clear="clear_clientes"
      placeholder="Inserte ID de cliente"
      remote
      disabled
    >
      <template #prefix>
        <el-icon><Search /></el-icon>
      </template>

      <el-option
      v-for="item in opt_cli"
      :key="item.ent_id"
      :label="item.ent_nrodocumento"
      :value="item.ent_id"
      disabled
      />
    </el-select>
    </el-col>
      <el-col :span="16">
        <el-input disabled v-model="form_p.cli_nom" placeholder="Nombre de cliente" />
      </el-col>
    </el-row>
  </el-form-item>

  <el-row style="width:800px; margin-bottom: 18px"> 
    <el-col :span="6">
      <el-select v-model="form_p.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  disabled>
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
          <el-input v-model="form_p.serie_doc" placeholder="nro de serie" disabled/>
        </el-col>
        <el-col :span="12">
          <el-input v-model="form_p.nro_doc" placeholder="nro de documento" disabled/>
        </el-col>
      </el-row>
    </el-col>

  </el-row>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de cobro">
    <el-select v-model="form_p.tipo_cobro" placeholder="Seleccione una opcion" style="width:300px" clearable>
      <el-option
          v-for="item in opt_fp"
          :key="item.fdc_codigo"
          :label="item.fdc_descripcion"
          :value="item.fdc_codigo"
      > </el-option>
    </el-select>
  </el-form-item>

  <el-form-item  label="Fecha de cobro">
    <el-date-picker
    type="date"
    v-model="form_p.fecha_cobro"
    format="YYYY-MM-DD"
    value-format="YYYY-MM-DD"
    placeholder="Seleccione fecha"
    style="width: 300px"
    />
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Nro. de referencia">
    <div style="width:300px">
      <el-input v-model="form_p.nro_referencia" placeholder="Inserte nro. de referencia"/>
    </div>
  </el-form-item>

  <el-form-item  label="Monto">
    <el-row style="width:600px">
      <el-col :span="12">
        <el-input v-model="form_p.monto" placeholder="Cantidad" /> 
      </el-col>
      <el-col :span="6"> 
        <el-select v-model="form_p.moneda" placeholder="Moneda" style="width:150px" clearable>
          <el-option label="Soles (S/)" value="SOL" />
          <el-option label="Dólares Americanos ($)" value="DOL" />
        </el-select> 
      </el-col>
    </el-row>
  </el-form-item>
  
  </el-form>
</modal>


<modal ref="mo_advertencia_eliim" title="Confirmar" centered @ok="send_delete" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_ed" hide-cancel success title="Operacion completada" centered @ok="close_succes_ed" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
  <br/> {{alert_cause}}
</modal>

<modal ref="mo_sunat" no-close-on-backdrop title="Consultar RUC" width="700px" cancel-title="Cancelar" centered>
 <div> 
    <object type="text/html" data="https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias?accion=consPorRazonSoc&razSoc=MTS" width="700px" height="400px" style="overflow:auto;">
    </object>
 </div>

</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
