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
  }, 50)
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
      edit_rs:0,
      succes: false,
      operarios_id:[2,4],

      datap: [],
      datatest: [{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12},{"dt":12}],
      opt_rs: [],
      tra_act:"",
      tipo_act:"",
      tipo_doc:"",

      data_edit: [],
      wait:false,
      wait2:false,

      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',

      form_b : reactive({
        rs: '',
        nombre: '',
      }),

      form_e : reactive({
        rs: '',
        placa: '',
        tipo_doc: '',
        ent_emisora: '',
        fech_emision: '',
        fech_venc: '',
        nro_lic:'',
      }),
    }
  },
 
  methods: {

    clear_eop() {
      this.form_e.rs= '';
      this.form_e.placa= '';
      this.form_e.nro_lic='';
      this.form_e.tipo_doc= '';
      this.form_e.ent_emisora= '';
      this.form_e.fech_emision= '';
      this.form_e.fech_venc= '';
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
      this.$refs.mo_create_per.open();
    },
    closecrear() {
      this.$refs.mo_create_per.hide();
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

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion/nuevo', 
        { 
          "emp_id": String(this.edit_rs),
          "tri_id":String(this.editpointer),
          "ttd_id":this.tipo_doc,
          "txd_entidademisora":"",
          "txd_fechaemision":"",
          "txd_fechavencimiento":"",
          "txd_usucreacion":this.$store.state.username
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Datos eliminados satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((error) => {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error: "+String(error));
          return false;
        });
        return false;
    },

    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    send_descarga() {
      axios
        .post('http://51.222.25.71:8080/garcal-report-api/api/controldocumentoschoferescsv',{},{ 
          headers:{
          "x-api-key":this.$store.state.api_key1
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_doc_personal')
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

    api_get_all(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion',
        {
          "emp_id": "",
          "veh_placa":""
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion',
        {
           "emp_id": this.form_b.rs,
            "tri_nombre":this.form_b.nombre,
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },

    send_editar_doc(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion/nuevo', 
        { 
          "emp_id": String(this.edit_rs),
          "tri_id":String(this.editpointer),
          "ttd_id":this.tipo_doc,
          "txd_entidademisora":this.form_e.ent_emisora,
          "txd_fechaemision":this.form_e.fech_emision,
          "txd_fechavencimiento":this.form_e.fech_venc,
          "txd_usucreacion":this.$store.state.username
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          //console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Datos modificados satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((error) => {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error: "+String(error));
          return false;
        });
        return false;
    },

    load_edit() {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion/"+String(this.editpointer),
        {
          "tri_id": this.editpointer,
          "ttd_id": this.tipo_doc
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })
    },

    load_data_edit() {
      if(this.data_edit.length==0) return;
      this.form_e.ent_emisora=this.data_edit[0].txd_entidademisora;
      this.form_e.fech_emision=this.data_edit[0].txd_fechaemision;
      this.form_e.fech_venc=this.data_edit[0].txd_fechavencimiento;

    },

    button_handle(obj,index){
      console.log(obj);
      this.clear_eop();
      this.editpointer=obj.tri_id;
      this.edit_rs=obj.emp_id;
      this.edit_placa=obj.tri_nombre;
      this.tra_act=this.edit_placa;
      this.wait = true;
      this.tipo_doc=-1;
      //this.editpointer=number;

      this.$refs.mo_editar_per.open();
      switch(index)
      {
      case 3:
        this.tipo_act="Licencia A3";
        if(!obj.LICENCIAA3) {
          return 
        }
        this.tipo_doc=obj.LICENCIAA3[0].id;

      break;
      case 4:
        this.tipo_act="Licencia A4";
        if(!obj.LICENCIAA4) {
          return 
        }
        this.tipo_doc=obj.LICENCIAA4[0].id;

      break;
      case 5:
        this.tipo_act="SCTR";
        if(!obj.SCTR) {
          return 
        }
        this.tipo_doc=obj.SCTR[0].id;
      break;
      case 6:
        this.tipo_act="Revisión Médica";
        if(!obj.REVMEDICA) {
          return 
        }
        this.tipo_doc=obj.REVMEDICA[0].id;
      break;
      case 7:
        this.tipo_act="Seguro de vida ley";
        if(!obj.SEGUROVIDALEY) {
          return 
        }
        this.tipo_doc=obj.SEGUROVIDALEY[0].id;
      break;

      }
      if(this.tipo_doc!=-1) {
        //this.load_edit();
        axios
        .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentostripulacion/"+String(this.editpointer),
          {
            "tri_id": this.editpointer,
            "ttd_id": this.tipo_doc
          },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
          .then((resp) => {
            //console.log(resp);
            this.data_edit = resp.data;

            this.load_data_edit();
            this.emp_cont=this.form_e.rs;
            this.wait = false;
          })
      }
      else {
        this.open_fail("Hubo un error interno al obtener los datos del servidor");
      }

    },

    cellStyle2(obj) {
      switch(obj.columnIndex)
      {
      case 3:
        if(!obj.row.LICENCIAA3) {
          return 
        }
        if (obj.row.LICENCIAA3[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.LICENCIAA3[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.LICENCIAA3[0].color=="#ff3823") {
          return "cell-3";
        }
      break;
      case 4:
        if(!obj.row.LICENCIAA4) {
          return 
        }
        if (obj.row.LICENCIAA4[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.LICENCIAA4[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.LICENCIAA4[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 5:
        if(!obj.row.SCTR) {
          return 
        }
        if (obj.row.SCTR[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.SCTR[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.SCTR[0].color=="#ff3823") {
          return "cell-3";
        }
        
      break;
      case 6:
        if(!obj.row.REVMEDICA) {
          return 
        }
        if (obj.row.REVMEDICA[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.REVMEDICA[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.REVMEDICA[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 7:
        if(!obj.row.SEGUROVIDALEY) {
          return 
        }
        if (obj.row.SEGUROVIDALEY[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.SEGUROVIDALEY[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.SEGUROVIDALEY[0].color=="#ff3823") {
          return "cell-3";
        }

      break;

      }

    },

    get_nombre(obj,idx) {

      switch(idx)
      {
      case 3:
        if(!obj.LICENCIAA3) {
          return "No info"
        }
        else {
          if (!obj.LICENCIAA3[0].fecha) {
            return "No info"
          }
          return obj.LICENCIAA3[0].fecha
        }
      break;
      case 4:
        if(!obj.LICENCIAA4) {
          return "No info"
        }
        else {
          if (!obj.LICENCIAA4[0].fecha) {
            return "No info"
          }
          return obj.LICENCIAA4[0].fecha
        }

      break;
      case 5:
        if(!obj.SCTR) {
          return "No info"
        }
        else {
          if (!obj.SCTR[0].fecha) {
            return "No info"
          }
          return obj.SCTR[0].fecha
        }
      break;
      case 6:
        if(!obj.REVMEDICA) {
          return "No info"
        }
        else {
          if (!obj.REVMEDICA[0].fecha) {
            return "No info"
          }
          return obj.REVMEDICA[0].fecha
        }
      break;
      case 7:
        if(!obj.SEGUROVIDALEY) {
          return "No info"
        }
        else {
          if (!obj.SEGUROVIDALEY[0].fecha) {
            return "No info"
          }
          return obj.SEGUROVIDALEY[0].fecha
        }
      break;

      }
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
      <el-form @submit.prevent :inline="true" :model="form" label-width="auto" size="small"  >
    <el-row justify="center"> 
        <el-form-item label="Razón social">
          <el-select v-model="form_b.rs" placeholder="Seleccionar" clearable>
            <el-option
              v-for="item in opt_rs"
              :key="item.emp_id"
              :label="item.emp_razonsocial"
              :value="item.emp_id"
            > </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="Nombre">
          <el-input v-model="form_b.nombre" />
        </el-form-item>
             
        <div class="button-container">
          <el-row class="mb-4">
            <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
          </el-row>
          <el-row class="mb-4">
            <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
          </el-row>
        </div>    
    </el-row>
    
  </el-form>
    </el-collapse-item>
  </el-collapse>
  </div>

  <div v-else>
    <el-form @submit.prevent  :inline="true" :model="form" label-width="auto" :size="small"  >
    <el-row> 
      <el-col :span="21">
        <el-form-item label="Razón social">
          <el-select v-model="form_b.rs" placeholder="Seleccionar" clearable>
            <el-option
              v-for="item in opt_rs"
              :key="item.emp_id"
              :label="item.emp_razonsocial"
              :value="item.emp_id"
            > </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="Nombre">
          <el-input v-model="form_b.nombre" />
        </el-form-item>
      </el-col>

      <el-col :span="3">               
        <div class="button-container">
          <el-row class="mb-4">
            <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
          </el-row>
          <el-row class="mb-4">
            <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
          </el-row>
        </div>    
      </el-col>
    </el-row>
    
  </el-form>
  </div>
  
  
  <div class="table-container">
    <el-table :cell-class-name="cellStyle2" :data="datap" border header-row-style="color:black;" height="98%" :size="$isMobile() ? 'small':'default'" >
      <el-table-column fixed prop="tri_nombre" label="Nombre "  />
      <el-table-column :fixed="!$isMobile()" align="center" prop="emp_razonsocial" label="Razon soc. aso. " width="140" />
      
      <el-table-column prop="tri_nrolicencia" label="Licencia " width="120" />
      
      <el-table-column label="Licencia A3" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,3)"> {{get_nombre(scope.row,3)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="Licencia A4" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,4)"> {{get_nombre(scope.row,4)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="SCTR" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,5)"> {{get_nombre(scope.row,5)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="Rev. Medica" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,6)"> {{get_nombre(scope.row,6)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="Seguro de vida ley" width="170">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,7)"> {{get_nombre(scope.row,7)}}</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="mo_editar_per" no-close-on-backdrop title="Detalles" width="500px" @ok="send_editar_doc" cancel-title="Atrás" @cancel="closeedit"  centered>
  <el-form @submit.prevent v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >
    <el-row style="text-align=center">
    <div style="margin-left: auto;margin-right: auto;text-align=center">
      <h4>Nombre: {{tra_act}}</h4>
      <h4>Tipo de doc.: {{tipo_act}}</h4>
    </div>
    </el-row>
    <el-form-item  label="Nro. de licencia">
      <el-input autosize style="width=10px" v-model="form_e.nro_lic" />
    </el-form-item>
    
    <el-form-item label="Fecha de emisión">
      <el-date-picker
          v-model="form_e.fech_emision"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
      />
    </el-form-item>
    <el-form-item label="Fecha de vencimiento">
      <el-date-picker
          v-model="form_e.fech_venc"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
      />
    </el-form-item>

    <el-form-item  label="Entidad emisora">
      <el-input autosize style="width=10px" v-model="form_e.ent_emisora" />
    </el-form-item>


    <el-row style="text-align=center">
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar los datos de este documento?')">Eliminar</el-button>
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

<style>

  .el-table .cell-1 {
    background: #92d36e;
  }
  .el-table .cell-1 .el-button {
    color: rgb(0, 0, 0);
  }
  .el-table .cell-1 .el-button  :hover{
    color: #92d36e;
  }

  .el-table .cell-2 {
    background: #fefb64;
  }
  .el-table .cell-2 .el-button {
    color: rgb(0, 0, 0);
  }
  .el-table .cell-2 .el-button :hover{
    color: #aeab22;
  }

  .el-table .cell-3 {
    background: #fb2525;
  }
  .el-table .cell-3 .el-button {
    color: rgb(42, 42, 42);
  }
  .el-table .cell-3 .el-button :hover{
    color: #fb2525;
  }

  .el-table .hover-row .cell3{
      color: #982278;
      background: #982278;
  }

</style>


<style scoped>

.main-container {
  height:100%;
  display:flex; 
  flex-direction:column;
  box-sizing:border-box;
}

.table-container {
  flex:1;
  padding: 15px 20px 15px 20px;
}

.layout-container .el-form {
  padding-top: 15px;
  background-color: white;
}

.el-table {
  font-family: "Roboto", sans-serif;
  --el-table-header-bg-color:rgb(199, 199, 199);
}

.el-col {
  text-align:center;
}

.el-row {
  margin-bottom: 5px;
}

.button-container .el-button {
  width: 100px;
  border-radius: 20px;
}

</style>
