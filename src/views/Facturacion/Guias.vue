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
      gem_id: 'GEM',
      gtr_id: 'GTR',
      datap: [],
      opt_rs: [],

      opt_tguia: [],

      data_aux: [],

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],
      opt_via:[],

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
        tipo_guia: '',
        codigo: '',
        fech_inicio: null,
        fech_fin:null
      }),

      form_c : reactive({
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
        gt_producto:'',

        gt_pro_id:'',
        veh_remolque:'',
        veh_tracto:'',
        ubi_origen:'',
        ubi_destino:''
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
        gt_producto:'',

        tipo:'',

        gt_pro_id:'',
        veh_remolque:'',
        veh_tracto:'',
        ubi_origen:'',
        ubi_destino:''
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
      this.form_c.c_pago="";
      this.form_c.tipo_doc="";
      this.form_c.prod="";

      //cargar listas
      this.load_fpago();
      this.load_tdoc();
      this.load_prod();
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

    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      this.form_e.id_via=this.data_edit[0].via_id;
      //carga de listas

      //carga de datos
      this.form_e.tipo=this.data_edit[0].gti_codigo;
      if(this.form_e.tipo==this.gem_id) {
        this.form_e.gr_serie=this.data_edit[0].gui_serie;
        this.form_e.gr_numero=this.data_edit[0].gui_numero;
        
        this.form_e.gr_fecha_em=this.data_edit[0].gui_fechaemision;
        this.form_e.gr_peso=this.data_edit[0].gui_peso;
      }
      if(this.form_e.tipo==this.gtr_id) {
        this.form_e.gt_serie=this.data_edit[0].gui_serie;
        this.form_e.gt_numero=this.data_edit[0].gui_numero;
        this.form_e.gt_fecha_em=this.data_edit[0].gui_fechaemision;
        
        this.form_e.gt_producto=this.data_edit[0].pro_id;
      }
      
      
      this.form_e.fecha_via=this.data_edit[0].gui_fechaemision;

      this.form_e.serie=this.data_edit[0].gui_serie;
      this.form_e.numero=this.data_edit[0].gui_numero;
      this.form_e.direccion=this.data_edit[0].ent_direccion;
      this.form_e.correo=this.data_edit[0].ent_correo;
      this.form_e.telefono=this.data_edit[0].ent_telefono;
      this.form_e.c_pago=this.data_edit[0].fdp_id;
      this.form_e.prod=this.data_edit[0].pro_id;
    },

    select_viaje(id) {
      this.load_viaje_data(id);
      for (let tmp in this.opt_via)  {
        console.log(tmp);
        if (this.opt_via[tmp].via_id == id) {
          this.form_c.gt_pro_id= this.opt_via[tmp].pro_id;
          this.form_c.gt_producto=this.opt_via[tmp].pro_descripcion;
          this.form_c.veh_remolque= this.opt_via[tmp].veh_idremolque;
          this.form_c.veh_tracto= this.opt_via[tmp].veh_idtracto;
          return;
        }
      }
    },

    load_viaje_data(id) {
      console.log(id);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/'+String(id))
      .then((resp) => {
        console.log(resp);
        this.data_aux = resp.data[0];
        console.log(this.datap);
        this.form_c.ubi_origen= this.data_aux.ubi_codigoorigen;
        this.form_c.ubi_destino= this.data_aux.ubi_codigodestino;
      })
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      this.err_code=false;
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Guia eliminada correctamente");
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


    api_get_all(){
      //llamada a API
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias')
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias', 
        {
          "emp_id": Number(this.form_b.rs),
          "gti_codigo": this.form_b.tipo_guia,
          "gui_serienumero": this.form_b.codigo,
          "gui_fechaemision_inicio": this.form_b.fech_inicio,
          "gui_fechaemision_fin": this.form_b.fech_fin
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    crear_guia(){
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/nuevo',
      {      
        "emp_id": Number(this.form_c.rs),
        "gui_fechaemision": this.form_c.gr_fecha_em,
        "gti_codigo": "GEM",
        "gui_serie":this.form_c.gr_serie,
        "gui_numero": this.form_c.gr_numero,
        "via_id":  Number(this.form_c.id_via),
        "gui_entdestinatario":"",
        "veh_id":  Number(this.form_c.veh_tracto),
        "veh_idacople": "",
        "pro_id":Number(this.form_c.gt_pro_id),
        "gui_estado":"",
        "gui_peso": Number(this.form_c.gr_peso),
        "ubi_codigoorigen":this.form_c.ubi_origen,
        "ubi_codigodestino":this.form_c.ubi_destino,
        "gui_observacion":"",
        "gui_usucreacion":"admin"
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          axios
          .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/nuevo',
          {      
            "emp_id": Number(this.form_c.rs),
            "gui_fechaemision": this.form_c.gt_fecha_em,
            "gti_codigo": "GTR",
            "gui_serie":this.form_c.gt_serie,
            "gui_numero": this.form_c.gt_numero,
            "via_id": Number(this.form_c.id_via),
            "gui_entdestinatario":"",
            "veh_id": Number(this.form_c.veh_tracto),
            "veh_idacople":"",
            "pro_id":Number(this.form_c.gt_pro_id),
            "gui_estado":"",
            "gui_peso":Number(this.form_c.gr_peso),
            "ubi_codigoorigen":this.form_c.ubi_origen,
            "ubi_codigodestino":this.form_c.ubi_destino,
            "gui_observacion":"",
            "gui_usucreacion":"admin"
          })
          .then((resp) => {
            console.log(resp.data);
            this.succes=resp.data.status;
            if (this.succes) {
                  this.open_succes("Operación realizada satisfactoriamente");
                  return true;
            }
            else {
              this.open_fail("Hubo un error con el servidor al insertar la guia de transportista");
              return false;
            }
          })
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

    editar_guia(){
      //llamada a API
      var send={};
      if(this.form_e.tipo==this.gem_id) {
        send= {
          "gui_id": Number(this.editpointer),
          "emp_id":  Number(this.form_e.rs),
          "gui_fechaemision": this.form_e.gr_fecha_em,
          "gti_codigo":"GEM",
          "gui_serie": this.form_e.gr_serie,
          "gui_numero": this.form_e.gr_numero,
          "via_id":  Number(this.data_edit[0].via_id),
          "gui_entdestinatario":"",
          "veh_id": Number(this.data_edit[0].veh_id),
          "veh_idacople":"",
          "pro_id":  Number(this.data_edit[0].pro_id),
          "gui_estado":"THB",
          "gui_peso": Number(this.data_edit[0].gui_peso),
          "ubi_codigoorigen":this.data_edit[0].ubi_codigoorigen,
          "ubi_codigodestino":this.data_edit[0].ubi_codigodestino,
          "gui_observacion":"",
          "gui_usucreacion":"admin"
        }
      }
      if(this.form_e.tipo==this.gtr_id) {
        send= {
          "gui_id": this.editpointer,
          "emp_id": this.form_e.rs,
          "gui_fechaemision": this.form_e.gt_fecha_em,
          "gti_codigo":"GTR",
          "gui_serie": this.form_e.gt_serie,
          "gui_numero": this.form_e.gt_numero,
          "via_id": this.data_edit[0].via_id,
          "gui_entdestinatario":"",
          "veh_id": this.data_edit[0].veh_id,
          "veh_idacople":"",
          "pro_id": this.data_edit[0].pro_id,
          "gui_estado":"THB",
          "gui_peso":this.data_edit[0].gui_peso,
          "ubi_codigoorigen":this.data_edit[0].ubi_codigoorigen,
          "ubi_codigodestino":this.data_edit[0].ubi_codigodestino,
          "gui_observacion":"",
          "gui_usucreacion":"admin"
        }
      }

      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/actualizar', 
        send)
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Guia modificada satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((error)=> {
          this.open_fail("Hubo un error interno al ejecutar la operación, error: "+String(error));
          return false;
        })
    },

    button_handle(id){
      console.log(id);
      this.editpointer=id;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      //this.load_edit(id);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/guias/"+String(id))
      .then((resp) => {
        this.data_edit = resp.data;

        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      })
      .catch((error)=> {
        this.open_fail("Hubo un error interno al ejecutar la operación, error: "+String(error));
        return false;
      })
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
  
<div class="main-container">
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
        <el-select v-model="form_b.tipo_guia" placeholder="Seleccionar" clearable>
          <el-option label="GUIA DE EMISION" value="GEM" />
          <el-option label="GUIA TRANSPORTISTA" value="GTR" />
        </el-select>
      </el-form-item>

      <el-form-item label="Codigo">
        <el-input placeholder="serie-numero" v-model="form_b.codigo" clearable />
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
        <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
      </el-row>
      <el-row class="mb-4">
        <el-button color="#95d475" :icon=" Download"  disabled>A Excel</el-button>
      </el-row>
      </div>
    </el-col>
    </el-row>

    </el-form>

  <div class="table-container">
    <el-table :data="datap" border header-row-style="color:black;" >
      <el-table-column prop="emp_razonsocial" label="Razon soc. aso." width="140" align="center"/>
      <el-table-column prop="gti_descripcion" label="Tipo de guia"  width="200"/>
      <el-table-column prop="gui_fechaemision" label="Fecha emisión" />  
      <el-table-column prop="gui_serienumero" label="Nro. Guia" />
      <el-table-column prop="veh_placa" label="Placa" />
      <el-table-column prop="via_descripcion" label="Viaje" width="210"/>  
      <el-table-column prop="gui_estado" label="Estado" /> 
      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.gui_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Guia" width="900px" @ok="crear_guia" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >
    <el-row style="text-align:center">
    <el-form-item style="margin-left: auto;margin-right: auto" label="Razón soc. asoc." prop="rs">
      <el-select style="width:300px" v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    </el-row>
    <el-row style="text-align:center">
    <el-form-item style="margin-left: auto;margin-right: auto" label="Fecha de viaje">
      <el-row >

          <el-date-picker
            type="date"
            v-model="form_c.fecha_via"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Inserte fecha"
            style="width: 140px"
            @change="fech_changer"
          />

          <el-select v-model="form_c.id_via" placeholder="Seleccione una opcion" style="width: 300px" @change="select_viaje" clearable>
            <el-option
              v-for="item in opt_via"
              :key="item.via_id"
              :label="item.via_descripcion"
              :value="item.via_id"
              
            > </el-option>
          </el-select> 

      </el-row>
    </el-form-item>
    </el-row>

    <el-row>
      <el-col style="text-align:center" :span="12">
        <h4>Guia Remitente </h4>
        <el-form-item label="Serie" >
          <el-input v-model="form_c.gr_serie" style="width: 200px" />
        </el-form-item>
        <el-form-item label="Numero" >
          <el-input v-model="form_c.gr_numero" style="width: 200px" />
        </el-form-item>
        <el-form-item label="Fecha emision" >
          <el-date-picker
            type="date"
            v-model="form_c.gr_fecha_em"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Seleccione fecha"
            style="width: 200px"
            @change="fech_changer"
          />
        </el-form-item>
        <el-form-item label="Peso" >
          <el-input v-model="form_c.gr_peso" style="width: 200px" />
        </el-form-item>
      </el-col>

      <el-col :span="12">
        <h4>Guia Transportista </h4>
        <el-form-item label="Serie" >
          <el-input v-model="form_c.gt_serie" style="width: 200px"/>
        </el-form-item>
        <el-form-item label="Numero" >
          <el-input v-model="form_c.gt_numero" style="width: 200px"/>
        </el-form-item>
        <el-form-item label="Fecha emision" >
          <el-date-picker
            type="date"
            v-model="form_c.gt_fecha_em"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Seleccione fecha"
            style="width: 200px"
            @change="fech_changer"
          />
        </el-form-item>
        <el-form-item label="Producto" >
          <el-input v-model="form_c.gt_producto" style="width: 200px" disabled/>
        </el-form-item>
      </el-col>
    </el-row>

  </el-form>
</modal>



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Guia" width="600px" @ok="editar_guia" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_cref" :rules="rules" :model="form" label-width="150px" >


    <el-form-item label="Razón soc. asoc.">
      <el-select style="width:300px" v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar" disabled>
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>


    <el-form-item label="Viaje">
      <el-row >
          <el-select v-model="form_e.id_via" placeholder="Seleccione una opcion" style="width: 300px" @change="select_viaje" disabled>
            <el-option
              v-for="item in opt_via"
              :key="item.via_id"
              :label="item.via_descripcion"
              :value="item.via_id"
              
            > </el-option>
          </el-select> 
      </el-row>
    </el-form-item>


    <div v-if="form_e.tipo==gem_id" style="margin-left:50px;margin-right:50px;text-align:center">
    <h4 style="text">Guia Remitente </h4>

      
      <el-form-item label="Serie" >
        <el-input v-model="form_e.gr_serie" style="width: 200px" />
      </el-form-item>
      <el-form-item label="Numero" >
        <el-input v-model="form_e.gr_numero" style="width: 200px" />
      </el-form-item>
      <el-form-item label="Fecha emision" >
        <el-date-picker
          type="date"
          v-model="form_e.gr_fecha_em"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          style="width: 200px"
          @change="fech_changer"
        />
      </el-form-item>
      <el-form-item label="Peso" >
        <el-input v-model="form_e.gr_peso" style="width: 200px" />
      </el-form-item>

    </div>

    <div v-if="form_e.tipo==gtr_id" style="margin-left:50px;margin-right:50px;text-align:center">
    <h4 style="text">Guia Transportista </h4>

      <el-form-item label="Serie" >
        <el-input v-model="form_e.gt_serie" style="width: 200px"/>
      </el-form-item>
      <el-form-item label="Numero" >
        <el-input v-model="form_e.gt_numero" style="width: 200px"/>
      </el-form-item>
      <el-form-item label="Fecha emision" >
        <el-date-picker
          type="date"
          v-model="form_e.gt_fecha_em"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          style="width: 200px"
          @change="fech_changer"
        />
      </el-form-item>
      <el-form-item label="Producto" >
        <el-input v-model="form_e.gt_producto" style="width: 200px" disabled/>
      </el-form-item>

    </div>
    <el-row style="text-align=center">
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar este documento?')">Eliminar</el-button>
    </el-row>
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
