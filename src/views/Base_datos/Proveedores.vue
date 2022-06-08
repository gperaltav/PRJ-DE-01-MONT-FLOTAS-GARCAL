<script lang="ts" setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold} from '@element-plus/icons-vue'

import type { FormInstance, FormRules } from 'element-plus'
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

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],

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
        prod:'',
      }),

      form_c : reactive({
        rs: '',
        tipo_doc:'',
        nro_doc:'',
        nombre:'',
        c_pago:'',
        direccion:'',
        correo:'',
        telefono:'',
        prod:'',
      }),

      form_e : reactive({
        rs: '',
        tipo_doc:'',
        nro_doc:'',
        nombre:'',
        c_pago:'',
        direccion:'',
        correo:'',
        telefono:'',
        prod:'',
      }),

      rules : reactive<FormRules>({
        nombre: [
          { required: true, message: 'Please input Activity name', trigger: 'blur' },
          { min: 3, max: 5, message: 'Length should be 3 to 5', trigger: 'blur' },
        ],
        
      })
    }
  },

  methods: {

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
      this.load_prod();
      this.load_fpago();
    },
    search_rs_clear() {
      this.form_b.contrato="";
      this.form_b.tipo="";
      this.opt_tc = [];
      this.opt_pues = [];
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
    },
    close_succes_ed() {
      this.$refs.mo_realizado_ed.hide(); 
      this.$refs.mo_editar_per.hide();
      this.api_get_all();
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
    },
    opencrear() {
      this.open_op=false;
      this.load_rs();
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
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

    load_edit(id,rss) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/"+String(id),
        {
          "emp_id":String(rss),
          "ext_id":this.var_type
        })
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
            this.open_succes("Proveedor eliminado correctamente");

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


    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.load_fpago();
      this.load_tdoc();

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

    api_get_all(){
      //llamada a API
     axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/proveedor')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
          console.log(this.datap);
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
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/nuevo', 
        { 
          "emp_id":parseInt(this.form_c.rs),
          "Ubi_codigo":"",
          "ent_nombre":this.form_c.nombre,
          "dti_id":this.form_c.tipo_doc,
          "ent_nrodocumento":this.form_c.nro_doc,
          "ent_apellidopaterno":"",
          "ent_apellidomaterno":"",
          "ent_activo":true,
          "zon_id":0,
          "ent_direccion":this.form_c.direccion,
          "ent_telefono":this.form_c.telefono,
          "ent_celular":"",
          "ent_paginaweb":"",
          "ent_correo":this.form_c.correo,
          "ent_contacto":"",
          "ent_sexo":"",
          "ent_usucreacion":"admin",
          "ent_personanatural":true,
          "ext_id":this.var_type,
          "fdp_id":this.form_c.c_pago,
          "pro_id":this.form_c.prod
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
          Base de datos > Personal
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

              <el-form-item label="Nro. de documento">
                <el-input v-model="form_b.nro_doc" clearable />
              </el-form-item>

              <el-form-item label="Nombre">
                <el-input v-model="form_b.nombre" clearable />
              </el-form-item>

              <el-form-item label="Forma de pago preferido">
                <el-select v-model="form_b.f_pago" placeholder="Seleccionar" clearable>
                  <el-option
                      v-for="item in opt_fpago"
                      :key="item.fdp_id"
                      :label="item.fdp_descripcion"
                      :value="item.fdp_id"
                    > </el-option>
                </el-select>
              </el-form-item>

              <el-form-item label="Producto o servicio">
                <el-select v-model="form_b.prod" placeholder="Seleccionar" clearable>
                  <el-option
                      v-for="item in opt_prod"
                      :key="item.pro_id"
                      :label="item.pro_nombre"
                      :value="item.pro_id"
                    > </el-option>
                </el-select>
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
              <el-table-column prop="ent_nombre" label="Nombre de proveedor" />
              
              <el-table-column prop="ent_nrodocumento" label="RUC" />  
              <el-table-column prop="pro_descri" label="Bien o servicio" />
              <el-table-column prop="fdp_descri" label="Forma típica de pago" />  
              <el-table-column fixed="right" label="" width="40">
              <template #default="scope">
                <el-button  type="text"  @click="button_handle(scope.row.ent_id,scope.row.emp_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
              </template>
            </el-table-column>
            </el-table>
          </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Proveedor" width="500px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_create_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select v-model="form_c.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Nro. de documento">
      <el-col :span="6">
      <el-select  v-model="form_c.tipo_doc">
        <el-option
          v-for="item in opt_tdoc"
          :key="item.dti_id"
          :label="item.dti_id"
          :value="item.dti_id"
        > </el-option>
      </el-select>
      </el-col>
      <el-col :span="18">
      <el-input v-model="form_c.nro_doc" />
      </el-col>
    </el-form-item>

    <el-form-item label="Nombre del cliente">
      <el-input v-model="form_c.nombre" />
    </el-form-item>

    <el-form-item label="Bien o servicio">
      <el-select  v-model="form_c.prod" >
        <el-option
          v-for="item in opt_prod"
          :key="item.pro_id"
          :label="item.pro_nombre"
          :value="item.pro_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Condición de pago">
      <el-select  v-model="form_c.c_pago" >
        <el-option
          v-for="item in opt_fpago"
          :key="item.fdp_id"
          :label="item.fdp_descripcion"
          :value="item.fdp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Dirección">
      <el-input v-model="form_c.direccion" />
    </el-form-item>
    <el-form-item label="Correo">
      <el-input v-model="form_c.correo" />
    </el-form-item>
    <el-form-item label="Teléfono">
      <el-input v-model="form_c.telefono" />
    </el-form-item>

  </el-form>
</modal>



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Proveedor" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select v-model="form_e.rs" @change="rs_changer" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item label="Nro. de documento">
      <el-col :span="6">
      <el-select  v-model="form_e.tipo_doc">
        <el-option
          v-for="item in opt_tdoc"
          :key="item.vma_id"
          :label="item.vma_nombre"
          :value="item.vma_id"
        > </el-option>
      </el-select>
      </el-col>
      <el-col :span="18">
      <el-input v-model="form_e.nro_doc" />
      </el-col>
    </el-form-item>

    <el-form-item label="Nombre del cliente">
      <el-input v-model="form_e.nombre" />
    </el-form-item>

    <el-form-item label="Bien o servicio">
      <el-select  v-model="form_e.prod" >
        <el-option
          v-for="item in opt_prod"
          :key="item.pro_id"
          :label="item.pro_nombre"
          :value="item.pro_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Condición de pago">
      <el-select  v-model="form_e.c_pago" >
        <el-option
          v-for="item in opt_fpago"
          :key="item.fdp_id"
          :label="item.fdp_descripcion"
          :value="item.fdp_id"
        > </el-option>
      </el-select>
    </el-form-item>

    <el-form-item label="Dirección">
      <el-input v-model="form_e.direccion" />
    </el-form-item>
    <el-form-item label="Correo">
      <el-input v-model="form_e.correo" />
    </el-form-item>
    <el-form-item label="Teléfono">
      <el-input v-model="form_e.telefono" />
    </el-form-item>

    <el-row style="text-align=center">
      <el-button color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar a este proveedor?')">Eliminar</el-button>
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

</template>


<style scoped src="../styles/basededatos.css">

</style>
