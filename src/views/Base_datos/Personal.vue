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
      editpointer:0,
      succes: false,
      operarios_id:[2,4],
      datap:[],
      opt_rs : [],
      opt_tc : [],
      opt_pues : [],
      data_edit : [],
      data_edit2 : [],
      wait:false,
      wait2:false,
      open_op:false,
      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',
      form_b : reactive({
        rs: '',
        nombre: '',
        nro_doc: '',
        apellidos: '',
        tipo: '',
        contrato: '',
        date_i: null,
        date_f: null,
      }),
      form_c : reactive({
        rs: '',
        nombre: '',
        tipo: '',
        nro_doc: '',
        apellido_p: '',
        apellido_m: '',
        contrato: '',
        fecha_nac:null,
        fecha_i: null,
        fecha_ip: null,
        fecha_c: null,
      }),
      form_c_op : reactive({
        rs: '',
        nro_lic: '',
        cat_lic: '',
        esp:'',
        ins_iqbf:null,
        venc_lic: null,

      }),
      form_e : reactive({
        rs: '',
        nombre: '',
        tipo: '',
        nro_doc: '',
        apellido_p: '',
        apellido_m: '',
        contrato: '',
        fecha_nac:'',
        fecha_i: '',
        fecha_ip: '',
        fecha_c: '',
      }),
      form_e_op : reactive({
        nro_lic: '',
        cat_lic: '',
        esp:'',
        ins_iqbf:null,
        venc_lic: null,
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
    check() {
      //verificar campos
      if (this.form_b.nombre=='') {
        this.api_get_all();
      }
      else {
        this.api_get_filt();
      }
    },
    check_op()  {
      for ( var xd in this.operarios_id) {
        if (this.form_c.tipo == this.operarios_id[xd]) {
          this.open_op=true;
          return;
        }
      }
      this.open_op=false;
      return;
    },
    check_op2()  {
      for ( var xd in this.operarios_id) {
        if (this.form_e.tipo == this.operarios_id[xd]) {
          this.open_op=true;
          return;
        }
      }
      this.open_op=false;
      return;
    },
    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.contrato="";
      this.form_b.tipo="";
      this.load_tc();
      this.load_pues();
    },
    clear_c() {
      this.form_c.rs= '';
      this.form_c.nombre= '';
      this.form_c.tipo= '';
      this.form_c.nro_doc= '';
      this.form_c.apellido_p= '';
      this.form_c.apellido_m= '';
      this.form_c.contrato= '';
      this.form_c.fecha_nac=null;
      this.form_c.fecha_i= null;
      this.form_c.fecha_ip= null;
      this.form_c.fecha_c= null;
      this.form_c_op.rs= '';
      this.form_c_op.nro_lic= '';
      this.form_c_op.cat_lic= '';
      this.form_c_op.esp='';
      this.form_c_op.ins_iqbf=null;
      this.form_c_op.venc_lic= null;
    },

    rs_changer() {
      this.emp_cont=this.form_c.rs;
      this.form_c.contrato="";
      this.form_c.tipo="";
      this.open_op=false;
      this.load_tc();
      this.load_pues();
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
    close_fail() {
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
      this.load_tc();
      this.load_pues();
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

    load_tc() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/contratos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_tc = resp.data;
        })
    },

    load_pues() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/puestos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_pues = resp.data;
        })
    },

    load_edit(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },
    load_edit_op(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacion/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit2 = resp.data;
        })      
    },

    send_delete_op() {
    axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacion/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Trabajador (operario) eliminado correctamente");
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        });
    },  

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            if(this.check_op2) {
              console.log("Tripulacion")
              var tmpop=this.send_delete_op();
              console.log(tmpop);
              if(tmpop) {
                return true;
              }
              else {
                return false;
              }
            }
            else {
              this.open_succes("Trabajador eliminado correctamente");
              return true;
            }
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        return false;
    },


    load_data_edit() {
      this.form_e.rs=this.data_edit[0].emp_id;
      this.form_e.tipo=this.data_edit[0].pue_id;
      this.form_e.nro_doc=this.data_edit[0].tra_nrodocumento;
      this.form_e.nombre=this.data_edit[0].tra_nombres;
      this.form_e.apellido_m=this.data_edit[0].tra_apellidomaterno;
      this.form_e.apellido_p=this.data_edit[0].tra_apellidopaterno;
      this.form_e.fecha_nac=this.data_edit[0].tra_fechanacimiento;
      this.form_e.contrato=this.data_edit[0].tra_tipocontrato;
      this.form_e.fecha_i=this.data_edit[0].tra_fechaingreso;
      this.form_e.fecha_ip=this.data_edit[0].tra_fechaingresoplanilla;
      this.form_e.fecha_c=this.data_edit[0].tra_fechacese;
    },

    load_data_edit_op() {
      this.form_e_op.cat_lic=this.data_edit2[0].tri_licenciacategoria;
      this.form_e_op.nro_lic=this.data_edit2[0].tri_licencianro;
      this.form_e_op.esp=this.data_edit2[0].tri_especialidad;
      this.form_e_op.venc_lic=this.data_edit2[0].tri_licenciafechavencimiento;
      this.form_e_op.ins_iqbf=this.data_edit2[0].tri_inscritossunatiqbf;
    },

    api_get_all(){
      //llamada a API
     axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores', 
        { 
          "emp_id": String(this.form_b.rs),
          "tra_nombreyapellidos":this.form_b.nombre,
          "tra_nrodocumento": this.form_b.nro_doc,
          "pue_nombre":String( this.form_b.tipo),
          "tra_tipocontrato":String(this.form_b.contrato),
          "tra_fechaingreso":this.form_b.date_i,
          "tra_fechacese":this.form_b.date_f
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/nuevo', 
        { 
          "are_id": 1,
          "pue_id": this.form_c.tipo,
          "emp_id": this.form_c.rs,
          "tra_nombres":this.form_c.nombre,
          "tra_apellidopaterno":this.form_c.apellido_p,
          "tra_apellidomaterno":this.form_c.apellido_m,
          "tra_nrodocumento": this.form_c.nro_doc,
          "tra_identificador": "",
          "tra_fechanacimiento":this.form_c.fecha_nac,
          "tra_tipocontrato":this.form_c.contrato,
          "tra_fechaingreso":this.form_c.fecha_i,
          "tra_fechaingresoplanilla":this.form_c.fecha_ip,
          "tra_fechacese":this.form_c.fecha_c,
          "tra_usucreacion":"admin" 
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            if(this.form_c.tipo=='2') {
              console.log("Tripulacion")
              this.id_tmp=resp.data.idValue;
              var tmpop=this.create_usr_op();
              console.log("Yolo");
              console.log(tmpop);
              if(tmpop) {
                return true;
              }
              else {
                return false;
              }
            }
            else {
              this.open_succes("Operación realizada satisfactoriamente");
              return true;
            }
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        return false;
    },  

    create_usr_op(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacion/nuevo', 
        {
          "tra_id": this.id_tmp,
          "tri_licenciacategoria":this.form_c_op.cat_lic,
          "tri_licencianro":this.form_c_op.nro_lic,
          "tri_especialidad":this.form_c_op.esp,
          "tri_licenciafechavencimiento": this.form_c_op.venc_lic,
          "tri_inscritossunatiqbf": this.form_c_op.ins_iqbf,
          "tri_usucreacion":"admin"
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Operación realizada satisfactoriamente");
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        });
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/actualizar', 
        { 
          "tra_id": this.editpointer,
          "are_id": 1,
          "pue_id": this.form_e.tipo,
          "emp_id": this.form_e.rs,
          "tra_nombres":this.form_e.nombre,
          "tra_apellidopaterno":this.form_e.apellido_p,
          "tra_apellidomaterno":this.form_e.apellido_m,
          "tra_nrodocumento": this.form_e.nro_doc,
          "tra_identificador": "",
          "tra_fechanacimiento":this.form_e.fecha_nac,
          "tra_tipocontrato":this.form_e.contrato,
          "tra_fechaingreso":this.form_e.fecha_i,
          "tra_fechaingresoplanilla":this.form_e.fecha_ip,
          "tra_fechacese":this.form_e.fecha_c,
          "tra_usucreacion":"admin" 
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Uusario modificado satisfactoriamente");
          }
          else {
            this.$refs.mo_error.open(); 
          }
          console.log(resp);
        })
        return false;
    },
    editar_usr_op() {
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacion/actualizar', 
        { 
          "tra_id": this.editpointer,
          "tri_licenciacategoria":this.form_e_op.cat_lic,
          "tri_licencianro":this.form_e_op.nro_lic,
          "tri_especialidad":this.form_e_op.esp,
          "tri_licenciafechavencimiento": this.form_e_op.venc_lic,
          "tri_inscritossunatiqbf": this.form_e_op.ins_iqbf,
          "tri_usumodificacion":"admin"
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.$refs.mo_realizado.open(); 
          }
          else {
            this.$refs.mo_error.open(); 
          }
          console.log(resp);
        })
        return false;
    },

    button_handle(number){
      console.log(number);
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      this.load_edit(number);
      setTimeout(() => {
        this.load_data_edit();
        if (this.form_e.tipo==2) {
          this.load_edit_op(number);
          setTimeout(() => {
          try {
            this.load_data_edit_op();
          }
          catch(err) {
            this.open_fail("Hubo un error con el servidor al cargar los datos de operario");
          }
          this.emp_cont=this.form_e.rs;
          this.load_tc();
          this.check_op2() ;
          this.wait = false;
          }, 400)
        }
        else {
          this.emp_cont=this.form_e.rs;
          this.load_tc();
          this.check_op2() ;
          this.wait = false;
        }
      }, 400)
    }
  },

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
    this.load_tc();
    this.load_pues();
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
                <el-form-item label="Razon social">
                  <el-select v-model="form_b.rs" @change="search_rs_ch" placeholder="Seleccionar" clearable>
                    <el-option
                      v-for="item in opt_rs"
                      :key="item.emp_id"
                      :label="item.emp_razonsocial"
                      :value="item.emp_id"
                    > </el-option>
                  </el-select>
                </el-form-item>

                <el-form-item label="Tipo">
                  <el-select v-model="form_b.tipo" placeholder="Seleccionar" clearable>
                    <el-option
                      v-for="item in opt_pues"
                      :key="item.pue_id"
                      :label="item.pue_nombre"
                      :value="item.pue_id"
                    > </el-option>
                  </el-select>
                </el-form-item>

                <el-form-item label="Contrato">
                  <el-select v-model="form_b.contrato" placeholder="Seleccionar" clearable>
                    <el-option
                      v-for="item in opt_tc"
                      :key="item.tco_id"
                      :label="item.tco_nombre"
                      :value="item.tco_id"
                    > </el-option>
                  </el-select>
                </el-form-item>

                <el-form-item label="Nro. de DNI">
                  <el-input v-model="form_b.nro_doc" clearable/>
                </el-form-item>

                <el-form-item label="Nombre">
                  <el-input v-model="form_b.nombre" clearable/>
                </el-form-item>

                <el-form-item label=" Apellidos">
                  <el-input v-model="form_b.apellidos" clearable/>
                </el-form-item>

                

                <el-form-item label="Fecha inicio">
                  <el-col :span="11">
                  <el-date-picker format="YYYY-MM-DD" value-format="YYYY-MM-DD"
                    v-model="form_b.date_i"
                    type="date"
                    placeholder="Seleccionar limite inicio"
                    style="width: 100%"
                  />
                  </el-col>
                  <el-col :span="2" class="text-center">
                    <span class="text-gray-500">-</span>
                  </el-col>
                  <el-col :span="11">
                  <el-date-picker format="YYYY-MM-DD" value-format="YYYY-MM-DD"
                    v-model="form_b.date_f"
                    type="date"
                    placeholder="Seleccionar limite fin"
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
                  <el-button color="#95d475" :icon=" Download" disabled>A Excel</el-button>
                </el-row>
                </div>
                
              </el-col>
              
            </el-form>

          <div class="table-container">
          <el-table :data="datap" border header-row-style="color:black;" >
              <el-table-column prop="emp_razonsocial" label="Razon soc. asoc." width="140" />
              <el-table-column prop="tra_nombreyapellidos" label="Nombre" width="200"/>
              <el-table-column prop="tra_nrodocumento" label="Nro. de doc."  />
              <el-table-column prop="pue_nombre" label="Tipo" />
              <el-table-column prop="tra_tipocontrato" label="Tipo de contrato" />
              <el-table-column prop="tra_fechaingreso" label="Fecha de ingreso" />
              <el-table-column prop="tra_fechacese" label="Fecha de cese" />
              <el-table-column fixed="right" label="" width="40">
              <template #default="scope">
                <el-button  type="text"  @click="button_handle(scope.row.tra_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
              </template>
            </el-table-column>
            </el-table>
          </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Trabajador" width="500px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
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
    <el-form-item label="Tipo">
      <el-select  v-model="form_c.tipo"  @change="check_op" default-first-option>
        <el-option
          v-for="item in opt_pues"
          :key="item.pue_id"
          :label="item.pue_nombre"
          :value="item.pue_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="DNI o carnet de extranjería">
      <el-input v-model="form_c.nro_doc" />
    </el-form-item>
    <hr size="1" color="gray"> 
    <el-form-item label="Nombres">
      <el-input v-model="form_c.nombre" />
    </el-form-item>
    <el-form-item label="Apellido Paterno">
      <el-input v-model="form_c.apellido_p" />
    </el-form-item>
    <el-form-item label="Apellido Materno">
      <el-input v-model="form_c.apellido_m" />
    </el-form-item>
    <hr> 
    <el-form-item label="Fecha de nac.">
      <el-date-picker  format="YYYY-MM-DD" value-format="YYYY-MM-DD" v-model="form_c.fecha_nac" />
    </el-form-item>

    <el-form-item label="Tipo de contrato">
        <el-select v-model="form_c.contrato"  default-first-option>
          <el-option
            v-for="item in opt_tc"
            :key="item.tco_id"
            :label="item.tco_nombre"
            :value="item.tco_id"
        > </el-option>       
        </el-select>
        
    </el-form-item>
    <el-form-item label="Fecha de ingreso">
      <el-date-picker format="YYYY-MM-DD" value-format="YYYY-MM-DD" v-model="form_c.fecha_i" />
    </el-form-item>
    <el-form-item label="Fecha de ingreso planilla">
      <el-date-picker format="YYYY-MM-DD" value-format="YYYY-MM-DD" v-model="form_c.fecha_ip" />
    </el-form-item>
    <el-form-item label="Fecha de cese">
      <el-date-picker format="YYYY-MM-DD" value-format="YYYY-MM-DD" v-model="form_c.fecha_c" />
    </el-form-item>
    <!-- <el-form-item label="Clase">
      <el-radio-group v-model="form.resource">
        <el-radio label="Administrativo" />
        <el-radio label="Conductor" />
      </el-radio-group>
    </el-form-item> -->
    <hr>  
    <div v-if="open_op" class="form-worker">
      <el-form-item label="Nro. de licencia">
        <el-input v-model="form_c_op.nro_lic"/>
      </el-form-item>
      <el-form-item label="Categoria de licencia">
        <el-input v-model="form_c_op.cat_lic" />
      </el-form-item>
      <el-form-item label="Fecha de venc. licencia">
        <el-date-picker v-model="form_c_op.venc_lic" />
      </el-form-item>
      <el-form-item label="Especialidad">
        <el-select v-model="form_c_op.esp"  default-first-option>
          <el-option label="Volvo " value="0" />
          <el-option label="Americano " value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-checkbox v-model="form_c_op.ins_iqbf" label="Inscrito en SUNAT-IQBF" />
    </el-form-item>
      
    </div>

  </el-form>
</modal>



<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Trabajador" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
<el-form v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item  label="Razón soc. asoc.">
      <el-select disabled v-model="form_e.rs" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_rs"
          :key="item.emp_id"
          :label="item.emp_razonsocial"
          :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>
    <el-form-item label="Tipo">
        <el-select disabled  v-model="form_e.tipo" >
          <el-option
          v-for="item in opt_pues"
          :key="item.pue_id"
          :label="item.pue_nombre"
          :value="item.pue_id"
        > </el-option>
        </el-select>
    </el-form-item>
    <el-form-item label="DNI o carnet de extranjería">
      <el-input v-model="form_e.nro_doc" />
    </el-form-item>
    <hr size="1" color="gray"> 
    <el-form-item label="Nombres">
      <el-input v-model="form_e.nombre" />
    </el-form-item>
    <el-form-item label="Apellido Paterno">
      <el-input v-model="form_e.apellido_p" />
    </el-form-item>
    <el-form-item label="Apellido Materno">
      <el-input v-model="form_e.apellido_m" />
    </el-form-item>
    <hr> 
    <el-form-item label="Fecha de nac.">
      <el-date-picker v-model="form_e.fecha_nac" />
    </el-form-item>

    <el-form-item label="Tipo de contrato">
        <el-select v-model="form_e.contrato" >
          <el-option
            v-for="item in opt_tc"
            :key="item.tco_id"
            :label="item.tco_nombre"
            :value="item.tco_id"
          > </el-option>
          
        </el-select>
    </el-form-item>
    <el-form-item label="Fecha de ingreso">
      <el-date-picker v-model="form_e.fecha_i" />
    </el-form-item>
    <el-form-item label="Fecha de ingreso planilla">
      <el-date-picker v-model="form_e.fecha_ip" />
    </el-form-item>
    <el-form-item label="Fecha de cese">
      <el-date-picker v-model="form_e.fecha_c" />
    </el-form-item>
    <!-- <el-form-item label="Clase">
      <el-radio-group v-model="form.resource">
        <el-radio label="Administrativo" />
        <el-radio label="Conductor" />
      </el-radio-group>
    </el-form-item> -->
    <hr>  
    <div v-if="open_op" class="form-worker">
      <el-form-item label="Nro. de licencia">
        <el-input v-model="form_e_op.nro_lic" />
      </el-form-item>
      <el-form-item label="Categoria de licencia">
        <el-input v-model="form_e_op.cat_lic"/>
      </el-form-item>
      <el-form-item label="Fecha de venc. licencia">
        <el-date-picker v-model="form_e_op.venc_lic"/>
      </el-form-item>
      <el-form-item label="Especialidad">
        <el-select v-model="form_e_op.esp"  default-first-option>
          <el-option label="Volvo " value="0" />
          <el-option label="Americano " value="1" />
        </el-select>
      </el-form-item>
      <el-form-item label="">
        <el-checkbox v-model="form_e_op.ins_iqbf" label="Inscrito en SUNAT-IQBF" />
      </el-form-item>
      
    </div>
    <el-button color="#E21747" :icon="CloseBold" @click="open_confirmar('Desea eliminar a este trabajador?')">Eliminar</el-button>

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
</modal>

</template>


<style scoped src="../styles/basededatos.css">

</style>
