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
import modal from "../../components/modal.vue"
export default {
  components: {
    modal
  },
  computed: {
    is_movile() {
      return this.$store.state.ismovile;
    },
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      operarios_id:[2,4],
      datap: [],
      opt_rs: [],

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      open_op:false,
      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',

      form_b : reactive({
        descripcion: '',
      }),

      form_c : reactive({
        rs:'',
        codigo: '',
        descripcion: '',
      }),

      form_e : reactive({
        rs:'',
        codigo: '',
        descripcion: '',
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Tarea eliminada correctamente");
            return true;
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
          return false;
        });
        return false;
    },


    load_data_edit() {
      this.form_e.codigo=this.data_edit[0].tar_codigo;
      this.form_e.descripcion=this.data_edit[0].tar_descripcion;
      //carga de listas
    },

    api_get_all(){
      //llamada a API
     axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas')
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas', 
        {
          "emp_id": "",
          "tar_descripcion": this.form_b.descripcion
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas/nuevo', 
      {
        "emp_id": this.form_c.rs,
        "tar_codigo": this.form_c.codigo,
        "tar_descripcion": this.form_c.descripcion,
        "tar_usucreacion": this.$store.state.username
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
      .catch(function (error) {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
      return false;

    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
    
    axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas/actualizar', 
      { 
        "tar_id": 0,
        "emp_id": 0,
        "tar_codigo": "",
        "tar_descripcion": "",
        "tar_usucreacion": ""
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
      .catch(function (error) {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
      return false;
    },

    button_handle(number){
      console.log(number);
      this.clear_eop;
      this.editpointer=number;
      this.$refs.mo_editar_per.open();
      this.wait = true;
      //this.load_edit(number);

      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tareas/"+String(number))
      .then((resp) => {
        console.log(resp);
        
        this.data_edit = resp.data;

        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      })
      .catch(function (error) {
        this.open_fail("Hubo un error con el servidor al ejecutar la operación, error:"+String(error));
        return false;
      });
    }
  },

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
  },
}

</script>


<template>

<div class="main-container">
  <div v-if="$isMobile()">
  <el-collapse>
    <el-collapse-item title="Opciones">

    <el-form @submit.prevent :inline="true" :model="formInline" label-width="auto" size="small" >
    <el-row justify="center">


        <el-form-item label="Descripción" clearable>
          <el-input v-model="form_b.descripcion" />
        </el-form-item>
 
        <div class="button-container">
        <el-row class="mb-4">
          <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
        </el-row>
        <el-row class="mb-4">
          <el-button color="#008db1" :icon="Plus"  @click="opencrear">Crear</el-button>
        </el-row>

        </div>

    </el-row>
      
    </el-form>
    
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
    <el-form @submit.prevent :inline="true" :model="formInline" label-width="auto" :size="small" >
    <el-row>
      <el-col :span="21">
        <el-form-item label="Descripción" clearable>
          <el-input v-model="form_b.descripcion" />
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

        </div>
      </el-col>
    </el-row>
      
    </el-form>
  </div>
  

  <div class="table-container">
    <el-table :data="datap" border header-row-style="color:black;" height="98%" :size="$isMobile() ? 'small':'default'">
      <el-table-column prop="tar_descripcion" label="Descripcion"  align="center" />
      <el-table-column prop="tar_codigo" label="Código"  align="center"/>

      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.tar_id)" ><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_create_per" no-close-on-backdrop title="Agregar Tarea" width="500px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  @submit.prevent ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >

    <el-form-item style="margin-left: auto;margin-right: auto" label="Código">
      <div style="width:600px">
        <el-input v-model="form_c.codigo" placeholder=""/>
      </div>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Descripción">
      <div style="width:600px">
        <el-input v-model="form_c.descripcion" placeholder=""/>
      </div>
    </el-form-item>

  </el-form>
</modal>

<modal ref="mo_editar_per" no-close-on-backdrop title="Editar datos de Tarea" width="500px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
  <el-form @submit.prevent v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >

    <el-form-item style="margin-left: auto;margin-right: auto" label="Código">
      <div style="width:600px">
        <el-input disabled v-model="form_e.codigo" placeholder=""/>
      </div>
    </el-form-item>

    <el-form-item style="margin-left: auto;margin-right: auto" label="Descripción">
      <div style="width:600px">
        <el-input v-model="form_e.descripcion" placeholder=""/>
      </div>
    </el-form-item>

    <el-row style="text-align=center">
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar a este cliente?')">Eliminar</el-button>
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
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
