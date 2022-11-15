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
      edit:false,
      succes: false,
      datag: [],
      datap: [],
      datav: [],
      opt_rs: [],
      opt_prv: [],
      opt_fp: [],
      opt_td:[],
      opt_via:[],
      opt_sald:[],
      opt_tra:[],
      opt_prod:[],
      opt_uni:[],

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      alert_mo:'',

      subtotal:0,
      ps_id:0,
      sal_din:0,
      doc_din:0,
      resta:0,

      emp_cont:'1',

      form_g : reactive({
        rs: '',
        tra_id:'',
        tra_nom:'',
        sal_dinero:'',
      }),

      form_c : reactive({
        id:this.ps_id,
        rs:'',
        rs_nom:'',
        prv_id:'',
        prv_nom:'',
        doc_tipo:'',
        doc_tipo_nom:'',
        doc_serie:'',
        doc_num:'',
        fech_emi:'',
        fech_viaje:'',
        via_id:'',
        pro_id:'',
        cantidad:'',
        un_id:'',
        subtotal:'',
        igv:18,
        impuesto:'',
        total:'',
        tipo_pago:'',
      }),
    }
  },

  methods: {
    rs_changer() {
      this.emp_cont=this.form_g.rs;
      this.form_g.tra_id='';
      this.form_g.tra_nom='';
      this.load_prod();
      this.opt_prv=[];
      this.opt_tra=[];
      this.opt_sald=[];
    },

    rscc_changer() {
      this.get_tipos_doc();
      this.get_formas_pago();
      this.get_proveedores("");
      this.form_c.prv_id='';
      this.form_c.prv_nom='';
      this.form_c.fech_viaje='';
      this.form_c.via_id='';
      this.form_c.pro_id='';
      this.form_c.tipo_pago='';
      let rscc=this.form_c.rs;
      for (let tmp in this.opt_rs)  {
        console.log(tmp);
        if (this.opt_rs[tmp].emp_id == rscc) {
          this.form_c.rs_nom= this.opt_rs[tmp].emp_razonsocial;
          return;
        }
      }
    },

    tdocc_changer() {
      let tdcc=this.form_c.doc_tipo;
      for (let tmp in this.opt_td)  {
        if (this.opt_td[tmp].cct_codigo == tdcc) {
          this.form_c.doc_tipo_nom= this.opt_td[tmp].cct_descripcion;
          return;
        }
      }
    },

    rscc_clear() {
      this.opt_td=[];
    },

    clear_rs() {
      this.opt_prv=[];
      this.opt_tra=[];
      this.opt_sald=[];
    },
    fech_changer() {
      //cargar listas
      this.get_viajes();
    },

    open_crear() {
      this.$refs.mo_create.open(); 
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

    clear_det() {
      this.form_c.rs='';
      this.form_c.rs_nom='';
      this.form_c.prv_id='';
      this.form_c.prv_nom='';
      this.form_c.doc_tipo='';
      this.form_c.doc_tipo_nom='';
      this.form_c.doc_serie='';
      this.form_c.doc_num='';
      this.form_c.fech_emi='';
      this.form_c.fech_viaje='';
      this.form_c.via_id='';
      this.form_c.pro_id='';
      this.form_c.cantidad='';
      this.form_c.un_id='';
      this.form_c.subtotal='';
      this.form_c.impuesto='';
      this.form_c.total='';
      this.form_c.tipo_pago='';
    },

    close_det() {
      this.$refs.mo_create.hide();
      this.clear_det();
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
        "gti_codigo": this.form_c.doc_tipo,
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

    get_proveedores(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.form_c.rs),
        "ent_nrodocumento": query,
        "ext_id": "prv"
      })
      .then((resp) => {
        console.log(resp);
        this.opt_prv = resp.data;
      })
    },
    
    select_proveedores(idx) {
      for (let tmp in this.opt_prv)  {
        if (this.opt_prv[tmp].ent_id == idx) {
          this.form_c.prv_nom  = this.opt_prv[tmp].ent_nombre;
          return;
        }
      }
    },

    get_salida_dinero(id) {
      console.log(id);

      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprasentregardineropendiente" ,
      {
        "tra_nrodocumento":id,
      })
        .then((resp) => {
          console.log(resp);
          this.opt_sald = resp.data;
        })
    },

    get_productos(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/buscarnombre" ,
      {
        "emp_id":this.form_c.rs,
        "ent_nrodocumento":query,
      })
        .then((resp) => {
          console.log(resp);
          this.opt_prod = resp.data;
        })
    },

    select_prod(idx) {
      for (let tmp in this.opt_prod)  {
        console.log(tmp);
        if (this.opt_prod[tmp].pro_id == idx) {
          this.form_c.prod_nom  = this.opt_prod[tmp].pro_nombre;
          return;
        }
      }
    },

    clear_proveedores() {
      this.form_c.prv_nom= "";
    },

    check_dinero() {
      this.doc_din=this.subtotal;
      this.resta=Number(this.sal_din)-Number(this.doc_din);
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

    get_viajes() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.form_c.rs,
        "via_fechaviaje":this.form_c.fech_viaje
      })
      .then((resp) => {
        console.log(resp);
        this.opt_via = resp.data;
      })
    },

    load_prod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/'+String(this.form_g.rs))
        .then((resp) => {
          console.log(resp);  
          this.opt_prod = resp.data;
        })
    },

    get_chofer(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacionoperariodocumentos" ,
      {
        "emp_id": this.emp_cont,
        "tra_nrodocumento ": query,
        "tra_nombre": ""
      })
      .then((resp) => {
        console.log(resp);
        this.opt_tra = resp.data;
      })
    },

    select_chofer(id) {
      for (let tmp in this.opt_tra)  {
        console.log(tmp);
        if (this.opt_tra[tmp].tra_id == id) {
          this.form_g.tra_nom= this.opt_tra[tmp].tra_nombre;
          this.get_salida_dinero(this.opt_tra[tmp].tra_nrodocumento);
          return;
        }
      }
    },

    api_det_ready() {
      this.datap=[];
      for (let tmp in this.datag)  {
        this.datap.push({
          "pro_id":Number(this.datag[tmp].pro_id),
          "via_id":Number(this.datag[tmp].via_id),
          "veh_id":"",
          "tra_id":Number(this.form_g.tra_id),
          "ccd_serie":this.datag[tmp].doc_serie,
          "ccd_cantidad":this.datag[tmp].cantidad,
          "ccd_preciounitario":"",
          "ccd_subtotal":this.datag[tmp].subtotal,
          "uni_unidad":"UNI"
        });
      }
    },

    create_det() {
      if (this.edit) {
        console.log(this.datav);
        console.log(this.editpointer);
        for (let tmp in this.datav)  {
          if (this.datav[tmp].id == this.editpointer) {
            this.datav[tmp].det_rs=this.form_c.rs_nom;
            this.datav[tmp].det_td=this.form_c.doc_tipo_nom;
            this.datav[tmp].det_cod=this.form_c.doc_serie;
            this.datav[tmp].det_fecha_em=this.form_c.fech_emi;
            this.datav[tmp].det_proveedor=this.form_c.prv_nom;
            this.datav[tmp].det_subtotal=this.form_c.subtotal;
            this.datav[tmp].det_impuesto=this.form_c.impuesto;

            this.subtotal=Number(this.subtotal)-Number(this.datav[tmp].det_total);
            this.datav[tmp].det_total=this.form_c.total;

            this.subtotal=Number(this.subtotal)+Number(this.form_c.total);

            this.edit=false;
            console.log(this.datav);
            console.log(this.datag);
            this.clear_det;
            this.$refs.mo_create.hide(); 
            this.check_dinero();
          }
        }

      }
      else {
        this.form_c.id=this.ps_id;
        this.datag.push(this.form_c);
      
        this.datav.push({
          "id":this.ps_id,
          "det_rs":this.form_c.rs_nom,
          "det_td":this.form_c.doc_tipo_nom,
          "det_cod":this.form_c.doc_serie,
          "det_fecha_em":this.form_c.fech_emi,
          "det_proveedor":this.form_c.prv_nom,
          "det_subtotal":this.form_c.subtotal,
          "det_impuesto":this.form_c.impuesto,
          "det_total":this.form_c.total,
        });
        this.subtotal=Number(this.subtotal)+Number(this.form_c.total);
        this.ps_id=this.ps_id+1;
        this.clear_det;
        this.$refs.mo_create.hide();
        this.check_dinero(); 
      } 
    },

    open_edit_det(id) {
      console.log(id);
      console.log(this.datag);
      for (let tmp in this.datag)  {
        if (this.datag[tmp].id == id) {
          this.editpointer=id;
          this.edit=true;
          this.form_c.rs=this.datag[tmp].rs;
          this.get_tipos_doc();
          this.get_formas_pago();
          this.form_c.rs_nom=this.datag[tmp].rs_nom;
          this.get_proveedores("");
          this.form_c.prv_id=this.datag[tmp].prv_id;
          this.form_c.prv_nom=this.datag[tmp].prv_nom;
          this.form_c.doc_tipo=this.datag[tmp].doc_tipo;
          this.form_c.doc_tipo_nom=this.datag[tmp].doc_tipo_nom;
          this.form_c.doc_serie=this.datag[tmp].doc_serie;
          this.form_c.doc_num=this.datag[tmp].doc_num;
          this.form_c.fech_emi=this.datag[tmp].fech_emi;
          this.form_c.fech_viaje=this.datag[tmp].fech_viaje;
          this.form_c.via_id=this.datag[tmp].via_id;
          this.form_c.pro_id=this.datag[tmp].pro_id;
          this.form_c.cantidad=this.datag[tmp].cantidad;
          this.form_c.un_id=this.datag[tmp].un_id;
          this.form_c.subtotal=this.datag[tmp].subtotal;
          this.form_c.igv=18;
          this.form_c.impuesto=this.datag[tmp].impuesto;
          this.form_c.total=this.datag[tmp].total;
          this.form_c.tipo_pago=this.datag[tmp].tipo_pago;
          this.$refs.mo_create.open();
          return;
        }
      }
    },

    select_sald(id) {
      console.log(id);
      for (let tmp in this.opt_sald)  {
        console.log(tmp);
        if (this.opt_sald[tmp].ccc_id == id) {
          this.sal_din= this.opt_sald[tmp].ccc_total;
          this.get_salida_dinero(this.opt_sald[tmp].tra_nrodocumento);
          this.check_dinero();
          return;
        }
      }
    },

    transaccion_insertar() {
      this.api_det_ready();
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
        "emp_id": Number(this.form_g.rs),
        "ent_id": "",
        "ccc_serie": "",
        "ccc_numero": "",
        "ccc_fechaemision": fech,
        "ccc_subtotal": "",
        "ccc_impuesto": "",
        "ccc_total": Number(this.doc_din),
        "cct_codigo": "END",
        "cce_codigo": "CAN",
        "mon_codigo": "SOL",
        "ccc_observaciones": "",
        "ccc_idreferencia":"",
        "ccc_tipocambio": 18,
        "ccc_generamovimiento":false,
        "ccc_fechaingreso": fech,
        "ccc_periodoregistro": fech,
        "ccr_codigo":"PEA",
        "usu_codigo": this.$store.state.username,
        "ccc_usucreacion":this.$store.state.username,
        "detalle":this.datap,
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          axios
          .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprascab/actualizar" ,
          {
            "ccc_id":Number(this.form_g.sal_dinero),
            "cce_codigo":"CAN"
          })
          .then((resp) => {
            console.log(resp.data);
            this.succes=resp.data.status;
            if (this.succes) {
              this.open_succes("Operación realizada satisfactoriamente");
              this.clear_g();
              return true;
            }
            else {
              this.open_fail("Hubo un error con el servidor al ejecutar la operación");
              return false;
            }
          })
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
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
    },


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
  

  <div v-if="$isMobile()">
    <el-form :inline="true"  label-width="auto" size="small" >
    <el-row>
      <el-form-item style="margin-left:auto;margin-right:auto" label="Razón social asociada">
        <el-select v-model="form_g.rs" @change="rs_changer" @clear="clear_rs" placeholder="Seleccionar" clearable>
          <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
          > </el-option>
        </el-select>
      </el-form-item>
    </el-row>

    <el-row style="height:50px">
      <el-form-item style="margin-left:auto;margin-right:auto" label="Conductor">
        <el-row justify="center"> 

          <el-select
            v-model="form_g.tra_id"
            filterable
            :remote-method="get_chofer"
            @change="select_chofer"
            @clear="clear_chofer"
            placeholder="Inserte ID de conductor"
            remote
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>

            <el-option
              v-for="item in opt_tra"
              :key="item.tra_nrodocumento"
              :label="item.tra_nrodocumento"
              :value="item.tra_id"
            />
          </el-select>

        <el-input disabled v-model="form_g.tra_nom" placeholder="Nombre del conductor" />
        </el-row>
      </el-form-item>
    </el-row>

    <el-row>
      <el-form-item style="margin-left:auto;margin-right:auto" label="Salida de dinero">
        <el-select v-model="form_g.sal_dinero"  placeholder="Seleccionar"  clearable @change="select_sald">
          <el-option
            v-for="item in opt_sald"
            :key="item.ccc_id"
            :label="item.ccc_observaciones"
            :value="item.ccc_id"
          > </el-option>
        </el-select>
      </el-form-item>
    </el-row>
      
  </el-form>
  </div>

  <div v-else>
    <el-form :inline="true"  label-width="auto" :size="small" >
    <el-row>
      <el-form-item style="margin-left:auto;margin-right:auto" label="Razón social asociada">
        <el-select v-model="form_g.rs" @change="rs_changer" @clear="clear_rs" placeholder="Seleccionar" style="width:600px" clearable>
          <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
          > </el-option>
        </el-select>
      </el-form-item>
    </el-row>

    <el-row style="height:50px">
      <el-form-item style="margin-left:auto;margin-right:auto" label="Conductor">
        <el-row style="width:600px"> 
        <el-col :span="8">
          <el-select
            v-model="form_g.tra_id"
            filterable
            :remote-method="get_chofer"
            @change="select_chofer"
            @clear="clear_chofer"
            placeholder="Inserte ID de conductor"
            remote
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>

            <el-option
              v-for="item in opt_tra"
              :key="item.tra_nrodocumento"
              :label="item.tra_nrodocumento"
              :value="item.tra_id"
            />
          </el-select>
        </el-col>
        <el-col :span="16"><el-input disabled v-model="form_g.tra_nom" placeholder="Nombre del conductor" /></el-col>
        </el-row>
      </el-form-item>
    </el-row>

    <el-row>
      <el-form-item style="margin-left:auto;margin-right:auto" label="Salida de dinero">
        <el-select v-model="form_g.sal_dinero"  placeholder="Seleccionar" style="width:600px" clearable @change="select_sald">
          <el-option
            v-for="item in opt_sald"
            :key="item.ccc_id"
            :label="item.ccc_observaciones"
            :value="item.ccc_id"
          > </el-option>
        </el-select>
      </el-form-item>
    </el-row>
      
  </el-form>
  </div>
  

    <div >
      <el-container style="border-style: solid; border-color:grey">
        <el-header style="padding-top:7px; background-color:grey; height:40px; color:white">
          Detalle:
        </el-header>
        <el-main>
          <div class="table-container">
          <el-table :data="datav" border header-row-style="color:black" :size="$isMobile() ? 'small':'default'">
              <el-table-column prop='det_rs' label="Razon Soc." width="120" align="center" />
              <el-table-column prop='det_td' label="Tipo de doc." width="120" align="center" />
              <el-table-column prop='det_cod' label="Serie-Numero" width="120" align="center" />
              <el-table-column prop="det_fecha_em" label="Fecha emision" width="140" align="center"/>
              <el-table-column prop="det_proveedor" label="Proveedor" width="140" />
              <el-table-column prop="det_subtotal" label="Subtotal"  />
              <el-table-column prop="det_impuesto" label="Impuesto" />
              <el-table-column prop="det_total" label="Total"  align="center" />
              <el-table-column fixed="right" label="" width="45" align="center">
                <template #default="scope">
                  <el-button  type="text"  @click="open_edit_det(scope.row.id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
          <el-row style="text-align=center" >
            <el-button color="#008db1" :icon="Plus"  @click="open_crear" style="margin-left: auto;margin-right: auto">Agregar</el-button>
          </el-row>
        </el-main>
      </el-container>

      <div v-if="$isMobile()">
        
        <el-row justify="center">
          <h5 >Resumen: </h5>
        </el-row>
        
        <el-row justify="right">
        <el-form :inline="true" model="formInline" label-width="auto" size="small">
        <el-form-item size="small" label="Total salida de dinero" prop="subtotal">
          <el-input  v-model="sal_din" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>


 
        <el-form-item size="small" label="Total documentos" prop="subtotal">
          <el-input  v-model="doc_din" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>



        <el-form-item size="small" label="Resta" prop="subtotal">
          <el-input v-model="resta" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>
        </el-form>
        </el-row>

      <el-row justify="center" >
        <el-button size="small" color="#0844a4"  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto">Guardar</el-button>
      </el-row>
      </div>

      <div v-else>
        <el-row>
          <h3 style="margin-left:auto; margin-right:50px">Resumen: </h3>
        </el-row>
        
        <el-row>
        <el-form-item style="margin-left:auto; margin-right:50px" label="Total salida de dinero" prop="subtotal">
          <el-input style="width:250px" v-model="sal_din" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>
        </el-row>

        <el-row>
        <el-form-item style="margin-left:auto; margin-right:50px" label="Total documentos" prop="subtotal">
          <el-input style="width:250px" v-model="doc_din" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>
        </el-row>

        <el-row>
        <el-form-item style="margin-left:auto; margin-right:50px" label="Resta" prop="subtotal">
          <el-input style="width:250px" v-model="resta" disabled>
            <template #prepend>S/</template>
          </el-input>
        </el-form-item>
        </el-row>

      <el-row style="text-align=center" >
        <el-button color="#0844a4"  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto">Guardar</el-button>
      </el-row>
      </div>
      
  </div>


<modal ref="mo_create" no-close-on-backdrop title="Documento" width="900px" @ok="create_det" @cancel="close_det" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" :label-width="$isMobile() ? '150px':'200px'" :size="$isMobile() ? 'small':'default'" >
    
    <el-form-item  label="Razón social asociada">
      <el-select v-model="form_c.rs" @change="rscc_changer" @clear="rscc_clear" placeholder="Seleccionar" style="width:600px" clearable>
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
      <el-col :span="$isMobile() ? 24:8">
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
      <el-col :span="$isMobile() ? 24:8"><el-input disabled v-model="form_c.prv_nom" placeholder="Nombre de proveedor" /></el-col>
      </el-row>
    </el-form-item>

    <el-row :style="$isMobile() ? '':'width:800px; margin-bottom: 18px'"> 
      <el-col :span="$isMobile() ? 24:6">
        <el-select v-model="form_c.doc_tipo" @change="tdocc_changer" :style="$isMobile() ? 'width:150px; margin-left:50px':'width:150px; margin-left:50px'" placeholder="Tipo de doc."  clearable>
        <el-option
          v-for="item in opt_td"
          :key="item.cct_codigo"
          :label="item.cct_descripcion"
          :value="item.cct_codigo"
        > </el-option>
        </el-select>
      </el-col>
    
      <el-col :span="$isMobile() ? 24:18">     
          <el-row > 
            <el-col :span="$isMobile() ? 24:12" >
              <el-input v-model="form_c.doc_serie" placeholder="nro de serie" :style="$isMobile() ? 'width:150px; margin-left:50px':''"/>
            </el-col>
            <el-col :span="$isMobile() ? 24:12">
              <el-input v-model="form_c.doc_num" placeholder="nro de documento" :style="$isMobile() ? 'width:150px; margin-left:50px':''" />
            </el-col>
          </el-row>
      </el-col>

    </el-row>

    <el-form-item  label="Fecha de emisión">
      <el-date-picker
        type="date"
        v-model="form_c.fech_emi"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        placeholder="Seleccione fecha"
        style="width: 300px"
      />
    </el-form-item>

    <el-form-item label="Fecha de viaje">
      <el-row :style="$isMobile() ? '':'width:600px'">
      <el-col :span="$isMobile() ? 24:12">
        <el-date-picker
          type="date"
          v-model="form_c.fech_viaje"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          :style="$isMobile() ? '':'width:300px'"
          @change="fech_changer"
        />
      </el-col>
      
      <el-col :span="$isMobile() ? 24:12">
        <el-select v-model="form_c.via_id" placeholder="Seleccione una opcion" :style="$isMobile() ? '':'width:300px'" clearable>
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


    <el-form-item  label="Producto">
      <el-row :style="$isMobile() ? '':'width:600px'">
        <el-col :span="$isMobile() ? 24:8">
          <el-select
            v-model="form_c.pro_id"
            filterable
            :remote-method="get_productos"
            placeholder="Tipo de producto"
            remote
            clearable
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>

            <el-option
              v-for="item in opt_prod"
              :key="item.pro_id"
              :label="item.pro_descripcion"
              :value="item.pro_id"
            />
          </el-select>
           
        </el-col>
        <el-col :span="$isMobile() ? 24:8"> 
          <el-input v-model="form_c.cantidad" placeholder="Cantidad" />
        </el-col>
        <el-col :span="$isMobile() ? 24:8">
          <el-select v-model="form_c.un_id" placeholder="Unidad"  clearable>
            <el-option
              v-for="item in opt_uni"
              :key="item.fdp_id"
              :label="item.fdp_descripcion"
              :value="item.fdp_id"
            > </el-option>
          </el-select>
        </el-col>
      </el-row>
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

    <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
      <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
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

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
