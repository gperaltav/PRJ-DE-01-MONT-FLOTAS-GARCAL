<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold,Search} from '@element-plus/icons-vue'

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
import Sidebar from "../../components/Sidebar.vue"
import modal from "../../components/modal.vue"
export default {
  components: {
    Sidebar,
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

      data_aux: [],

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],
      opt_td:[],
      opt_via:[],
      opt_fp: [],

      opt_prv:[],

      opt_tdoc:[],
      opt_fpago:[],
      opt_prod:[],

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
        nro_doc: '',
        nombre: '',
        f_pago: '',
        prod:''
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
        fecha_via:'',
        id_via:'',
        gr_serie:'',
        gr_numero:'',
        gr_fecha_em:'',
        gr_peso:'',
        gt_serie:'',
        gt_numero:'',
        gt_fecha_em:'',
        gt_producto:''
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
      this.form_b.prod="";
      this.form_b.f_pago="";

      //cargar listas
      this.load_fpago();
      this.load_prod();

    },
    search_rs_clear() {
      this.form_b.prod="";
      this.form_b.f_pago="";
      this.opt_fpago = [];
      this.opt_prod = [];
    },
    clear_c() {
      this.form_c.rs='';
      this.form_c.tipo_doc='';
      this.form_c.nro_doc='';
      this.form_c.nombre='';
      this.form_c.c_pago='';
      this.form_c.direccion='';
      this.form_c.correo='';
      this.form_c.telefono='';
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
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
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
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      this.err_code=false;
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/borrar/',
        {
          "ent_id":String(this.editpointer),
          "emp_id":String(this.form_e.rs),
          "ext_id":this.var_type
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Guia anulada correctamente");
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

    get_proveedores(query) {
      console.log(query);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.emp_cont),
        "ent_nrodocumento": query,
        "ext_id": "prv"
      })
      .then((resp) => {
        console.log(resp);
        this.opt_prv = resp.data;
      })
    },

    select_proveedores (id) {
      for (let tmp in this.opt_prv)  {
        console.log(tmp);
        if (this.opt_prv[tmp].ent_id == id) {
          this.form_c.prv_nom= this.opt_prv[tmp].ent_nombre;
          return;
        }
      }
    },

    clear_proveedores() {
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
      this.load_fpago();
      this.load_tdoc();
      this.load_prod();

      this.form_e.tipo_doc=this.data_edit[0].dti_id;
      this.form_e.nro_doc=this.data_edit[0].ent_nrodocumento;
      this.form_e.nombre=this.data_edit[0].ent_nombre;
      this.form_e.c_pago=this.data_edit[0].vti_id;
      this.form_e.direccion=this.data_edit[0].ent_direccion;
      this.form_e.correo=this.data_edit[0].ent_correo;
      this.form_e.telefono=this.data_edit[0].ent_telefono;
      this.form_e.c_pago=this.data_edit[0].fdp_id;
      this.form_e.prod=this.data_edit[0].pro_id;
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
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab', {
        "emp_id": "",
        "cvt_codigo":"",
        "cvc_serienumero":"",
        "cve_codigo":"",
        "cvc_fechaemisioninicio": null,
        "cvc_fechaemisionfin": null
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

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad', 
        {
          "emp_id": String(this.form_b.rs),
          "ext_id":this.var_type,
          "ent_nombre":this.form_b.nombre, 
          "ent_nrodocumento":this.form_b.nro_doc,
          "fdp_id":this.form_b.f_pago,
          "pro_id":this.form_b.prod
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){
      console.log(
        { 
        "emp_id":Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "cvc_serie": this.form_c.serie_doc,
        "cvc_numero": this.form_c.nro_doc,
        "cvc_fechaemision": this.form_c.fecha_em,
        "cvc_fechavencimiento": "",
        "cvc_subtotal": Number(this.form_c.subtotal),
        "cvc_impuesto":  Number(this.form_c.impuesto),
        "cvc_total":  Number(this.form_c.total),
        "cvt_codigo": this.form_c.tipo_doc,
        "cve_codigo": "CAN",
        "mon_codigo": "SOL",
        "cve_tipocambio":18,
        "cvc_idreferencia": null,
        "cvc_observaciones":"",
        "cvc_observacionesopcional": "",
        "gui_idremitente": "",
        "gui_idtransportisa": "",
        "via_id":this.form_c.via_id,
        "usu_codigo":"admin",
        "cvc_usucreacion":"admin"
      }
      );
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantesventacab/nuevo', 
      { 
        "emp_id":Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "cvc_serie": this.form_c.serie_doc,
        "cvc_numero": this.form_c.nro_doc,
        "cvc_fechaemision": this.form_c.fecha_em,
        "cvc_fechavencimiento": "",
        "cvc_subtotal": this.form_c.subtotal,
        "cvc_impuesto": this.form_c.impuesto,
        "cvc_total": this.form_c.total,
        "cvt_codigo": this.form_c.tipo_doc,
        "cve_codigo": "CAN",
        "mon_codigo": "SOL",
        "cve_tipocambio":18,
        "cvc_idreferencia": null,
        "cvc_observaciones":"",
        "cvc_observacionesopcional": "",
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

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/actualizar', 
        { 
          "ent_id" :this.editpointer,
          "emp_id":parseInt(this.form_e.rs),
          "Ubi_codigo":"",
          "ent_nombre":this.form_e.nombre,
          "dti_id":this.form_e.tipo_doc,
          "ent_nrodocumento":this.form_e.nro_doc,
          "ent_apellidopaterno":"",
          "ent_apellidomaterno":"",
          "ent_activo":true,
          "zon_id":0,
          "ent_direccion":this.form_e.direccion,
          "ent_telefono":this.form_e.telefono,
          "ent_celular":"",
          "ent_paginaweb":"",
          "ent_correo":this.form_e.correo,
          "ent_contacto":"",
          "ent_sexo":"",
          "ent_usucreacion":"admin",
          "ent_personanatural":true,
          "ext_id":this.var_type,
          "fdp_id":this.form_e.c_pago,
          "fpd_diasvencimiento":this.form_e.plazo,
          "ent_estadocontribuyente":this.form_e.c_activo,
          "ent_condicioncontribuyente":this.form_e.c_habido,
          "pro_id":this.form_e.prod
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Proveedor modificado satisfactoriamente");
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

    button_handle(number,number2){
      console.log(number);
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      this.load_edit(number,number2);
      
      setTimeout(() => {
        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      }, 500)
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
  <el-container class="layout-container" style="height: calc( 100vh - 20px );">
    <el-header style="text-align: left; font-size: 24px">
      <el-col :span="8" style="text-align=left">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
        <div class="sitebar">
        <el-tag style="color:white;" color="#0c59cf">
          Facturación > Comprobantes
        </el-tag>
      </div>
      </el-col>
      <el-col :span="8" style="text-align=center">
      </el-col>
    </el-header>

    <el-container style="height: calc( 100vh - 100px );">
      <el-aside width="200px">
        <el-scrollbar>
          <Sidebar />
        </el-scrollbar>
      </el-aside>

      <el-main style="background-color:white">
        <el-scrollbar>
          <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
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
                <el-select v-model="form_b.f_pago" placeholder="Seleccionar" clearable>
                  <el-option
                    v-for="item in opt_fpago"
                    :key="item.fdp_id"
                    :label="item.fdp_descripcion"
                    :value="item.fdp_id"
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

            </el-form>

          <div class="table-container">
          <el-table :data="datap" border header-row-style="color:black;" >
            <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="140" />
            <el-table-column prop="cvt_descripcion" label="Tipo de doc."  width="200" sortable/>
            <el-table-column prop="cvc_serienumero" label="Serie-numero" />  
            <el-table-column prop="cvc_fechaemision" label="Fecha emision" />  
            <el-table-column prop="ent_nombre" label="Nombre cliente" />
            <el-table-column prop="cvc_subtotal" label="Subtotal" />
            <el-table-column prop="cvc_impuesto" label="Impuesto" />
            <el-table-column prop="cvc_total" label="Total" /> 

            <el-table-column prop="cvc_comprobantereferencia" label="Referencia" />
            <el-table-column fixed="right" label="" width="40">
              <template #default="scope">
                <el-button  type="text"  @click="button_handle(scope.row.cvc_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
              </template>
            </el-table-column>
          </el-table>
          </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Comprobante" width="900px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
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



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Comprobante" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_cref" :rules="rules" :model="form" label-width="150px" >

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

    <el-form-item  label="Proveedor">
      <el-row style="width:600px"> 
      <el-col :span="8">
      <el-select
        v-model="form_e.prv_id"
        filterable
        :remote-method="get_proveedores"
        @change="select_proveedores"
        @clear="clear_proveedores"
        placeholder="Inserte ID de proveedor"
        remote
        clearable
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
      <el-col :span="16"><el-input disabled v-model="form_e.prv_nom" placeholder="Nombre de proveedor" /></el-col>
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
            @change="fech_changer"
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

    <el-form-item  label="Cantidad">
        <el-row style="width:600px">
        <el-col :span="6">
            <el-input v-model="form_e.cantidad_n" placeholder="Cantidad" /> 
        </el-col>
        <el-col :span="6"> 
            <el-select v-model="form_e.cantidad_un" placeholder="Unidad" style="width:150px" clearable>
            <el-option label="Galones" value="gal" />
            </el-select> 
        </el-col>
        <el-col :span="12">
            <el-form-item label-width="100px" label="P. Unitario">
            <el-input v-model="form_e.cantidad_p_uni" placeholder="Insertar monto" >
                <template #prepend>S/</template>
            </el-input>
            </el-form-item>
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
            :key="item.fdp_id"
            :label="item.fdp_descripcion"
            :value="item.fdp_id"
            
        > </el-option>
        </el-select>
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


<style scoped src="../styles/basededatos.css">

</style>
