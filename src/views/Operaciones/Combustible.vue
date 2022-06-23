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
      operarios_id:[2,4],
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
      open_op:false,
      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',

      form_b : reactive({
        rs: '',
        placa: '',
        marca: '',
        modelo: '',
        fecha_i: '',
        fecha_f: '',
      }),

      form_c : reactive({
        rs: '',
        placa: '',
        marca: '',
        modelo: '',
        tipo: '',
        clase: '',
        year: '',
        serie: '',
        mtc: '',
        carga_util:'',
        kilometraje: '',
      }),

      form_e : reactive({
        rs: '',
        placa: '',
        marca: '',
        modelo: '',
        tipo: '',
        clase: '',
        year: '',
        serie: '',
        mtc: '',
        carga_util:'',
        kilometraje: '',
      }),
    }
  },

  methods: {

    search_rs_ch() {
      this.emp_cont=this.form_b.rs;
      this.form_b.modelo="";
      this.form_b.marca="";

      //cargar listas
      this.load_mar();
      this.load_mod();
    },
    search_rs_clear() {
      this.form_b.contrato="";
      this.form_b.tipo="";
      this.opt_tc = [];
      this.opt_pues = [];
    },
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

    clear_eop() {
      this.form_e_op.nro_lic= '';
      this.form_e_op.cat_lic= '';
      this.form_e_op.esp= '';
      this.form_e_op.ins_iqbf= null;
      this.form_e_op.venc_lic= null;
    },

    rs_changer() {
      this.emp_cont=this.form_c.rs;
      this.form_c.modelo="";
      this.form_c.marca="";
      this.form_c.clase="";
      this.form_c.tipo="";
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
    load_mar() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosmarcas/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mar = resp.data;
        })
    },
    load_mod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosmodelos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_mod = resp.data;
        })
    },
    load_cla() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculosclases/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_cla = resp.data;
        })
    },
    load_ti() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api//vehiculostipos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_ti = resp.data;
        })
    },
    load_esp() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/especialidad/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_esp = resp.data;
        })
    },

    load_edit(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Vehiculo eliminado correctamente");
            return true;
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
      this.emp_cont=this.form_e.rs;
      //carga de listas
      this.load_mar();
      this.load_mod();
      this.load_cla();
      this.load_ti();

      this.form_e.placa=this.data_edit[0].veh_placa;
      this.form_e.marca=this.data_edit[0].vma_id;
      this.form_e.modelo=this.data_edit[0].vmo_id;
      this.form_e.tipo=this.data_edit[0].vti_id;
      this.form_e.clase=this.data_edit[0].vcl_id;
      this.form_e.year=String(this.data_edit[0].veh_anno);
      this.form_e.serie=this.data_edit[0].veh_serie;
      this.form_e.mtc=this.data_edit[0].veh_mtc;
      this.form_e.carga_util=this.data_edit[0].veh_cargautil;
      this.form_e.kilometraje=this.data_edit[0].veh_kilometraje;
    },

    api_get_all(){
      //llamada a API
     axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos', 
        {
          "emp_id": String(this.form_b.rs),
          "veh_placa":this.form_b.placa,
          "vma_nombre":this.form_b.marca,
          "vmo_nombre":this.form_b.modelo,
          "veh_anno_inicio":String(this.form_b.fecha_i),
          "veh_anno_fin":String(this.form_b.fecha_f)
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    async create_usr(){
      //llamada a API
      //if (!this.form_cref) return
      //await this.form_cref.validate((valid, fields) => {
      //  if (valid) {
       //   console.log(this.form_c.year);

          axios
          .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/nuevo', 
          { 
            "emp_id": String(this.form_c.rs),
            "veh_placa":this.form_c.placa,
            "vma_id": String(this.form_c.marca),
            "vmo_id": String(this.form_c.modelo),
            "vti_id": this.form_c.tipo,
            "vcl_id": this.form_c.clase,
            "veh_anno":this.form_c.year,
            "veh_usucreacion":"admin",
            "veh_serie":this.form_c.serie,
            "veh_mtc":this.form_c.mtc,
            "veh_cargautil":String(this.form_c.carga_util),
            "veh_kilometraje":String(this.form_c.kilometraje)
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
         // } 
       // else {
          //console.log('Error en campos', fields);
         // return;
        //}
      //})
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
    
    axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculos/actualizar', 
        { 
          "veh_id":String(this.editpointer),
          "emp_id": String(this.form_e.rs),
          "veh_placa":this.form_e.placa,
          "vma_id":String(this.form_e.marca),
          "vmo_id":String(this.form_e.modelo),
          "vti_id": this.form_e.tipo,
          "vcl_id": this.form_e.clase,
          "veh_anno":this.form_e.year,
          "veh_usucreacion":"admin",
          "veh_serie":this.form_e.serie,
          "veh_mtc":this.form_e.mtc,
          "veh_cargautil":String(this.form_e.carga_util),
          "veh_kilometraje":String(this.form_e.kilometraje)
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Vehiculo modificado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
          console.log(resp);
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
          Base de datos > Vehículos
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
            <el-row style="text-align=center">
              <h1 style="margin-left: auto;margin-right: auto">Añadir combustible</h1>
            </el-row>


          <el-form :inline="true" :size="small" >
            <el-row >
              <el-form-item style="margin-left: auto;margin-right: auto" label="Razón social asociada">
                <el-select v-model="form_b.rs" @change="search_rs_ch" @clear="search_rs_clear" placeholder="Seleccionar" style="width:500px" clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                    
                  > </el-option>
                </el-select>
              </el-form-item>
            </el-row>

            

            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Proveedor">
                <el-col :span="8"><el-input /></el-col>
                <el-col :span="16"><el-input /></el-col>
                
                
              </el-form-item>
            </el-row>

            <el-row style="width:500px;">
              <el-form-item style="width:500px; margin-left: auto; margin-right: auto" label="">
                <el-col :span="8">
                  <el-select v-model="form_b.rs" placeholder="Seleccionar"  clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                  > </el-option>
                </el-select>
                </el-col>
                <el-col :span="8">
                  <el-input  />
                </el-col>
                <el-col :span="8">
                  <el-input />
                </el-col>
              </el-form-item>
            </el-row>

            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="">
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Fecha de emisión">
                <el-date-picker
                  
                  type="date"
                  format="YYYY-MM-DD"
                  value-format="YYYY-MM-DD"
                  placeholder="Fecha"
                  style="width: 250px"
                />
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Fecha de viaje">
                <el-col>
                <el-date-picker
                  type="date"
                  format="YYYY-MM-DD"
                  value-format="YYYY-MM-DD"
                  placeholder="Fecha"
                  style="width: 250px"
                />
              </el-col>
              <el-col>
                <el-select v-model="form_b.rs" placeholder="Seleccionar"  clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                  > </el-option>
                </el-select> 
              </el-col>
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Cantidad">
                <el-col> <el-input /> </el-col>
                <el-col> <el-select v-model="form_b.rs" placeholder="Seleccionar"  clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                  > </el-option>
                  </el-select> 
                </el-col>
                <el-col>
                  <el-form-item label="Precio unitario">
                    <el-input placeholder="inserte" />
                  </el-form-item>
                </el-col>
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Valor venta">
                <el-input />
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Impuesto">
                <el-input />
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Total">
                <el-input />
              </el-form-item>
            </el-row>
            <el-row>
              <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de pago">
                <el-select v-model="form_b.rs" placeholder="Seleccionar"  clearable>
                  <el-option
                    v-for="item in opt_rs"
                    :key="item.emp_id"
                    :label="item.emp_razonsocial"
                    :value="item.emp_id"
                  > </el-option>
                </el-select>
              </el-form-item>
            </el-row>
            
              
            </el-form>

          
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

<modal ref="mo_realizado_ed" hide-cancel success title="Operacion completada" centered @ok="close_succes_ed" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="../styles/basededatos.css">

</style>
