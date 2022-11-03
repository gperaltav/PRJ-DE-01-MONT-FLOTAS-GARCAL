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
      edit_rs:0,
      succes: false,
      operarios_id:[2,4],

      datap: [],
      opt_rs: [],
      placa_act:"",
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
        placa: '',
      }),

      form_e : reactive({
        rs: '',
        placa: '',
        tipo_doc: '',
        ent_emisora: '',
        fech_emision: '',
        fech_venc: '',
      }),
    }
  },
 
  methods: {

    clear_eop() {
      this.form_e.rs= '';
      this.form_e.placa= '';
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
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/nuevo', 
        { 
          "veh_id":String(this.editpointer),
          "emp_id": String(this.edit_rs),
          "veh_placa":this.edit_placa,
          "vtd_id":this.tipo_doc,
          "vxd_entidademisora":'',
          "vxd_fechaemision":'',
          "vxd_fechavencimiento":'',
          "vxd_usucreacion":"admin"
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
          console.log(resp);
        })
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
        .post('http://51.222.25.71:8080/garcal-report-api/api/controldocumentosvehiculoscsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_doc_vehiculos')
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
    },

    api_get_all(){
      //llamada a API
     axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos',
        {
          "emp_id": "",
          "veh_placa":""
        })
        .then((resp) => {
          this.datap = resp.data;
          console.log(this.datap);
        })
    },

    api_get_filt(){
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos',
        {
          "emp_id": this.form_b.rs,
          "veh_placa":this.form_b.placa
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },

    send_editar_doc(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/nuevo', 
        { 
          "veh_id":String(this.editpointer),
          "emp_id": String(this.edit_rs),
          "veh_placa":this.edit_placa,
          "vtd_id":this.tipo_doc,
          "vxd_entidademisora":this.form_e.ent_emisora,
          "vxd_fechaemision":this.form_e.fech_emision,
          "vxd_fechavencimiento":this.form_e.fech_venc,
          "vxd_usucreacion":"admin"
        })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Datos modificados satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error: "+String(error));
          return false;
        });
        return false;
    },

    load_edit() {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/vista",
        {
          "veh_id": this.editpointer,
          "vtd_id": this.tipo_doc
        })
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })      
    },

    load_data_edit() {
      if(this.data_edit.length==0) return;
      this.form_e.ent_emisora=this.data_edit[0].vxd_entidademisora;
      this.form_e.fech_emision=this.data_edit[0].vxd_fechaemision;
      this.form_e.fech_venc=this.data_edit[0].vxd_fechavencimiento;

    },

    button_handle(obj,index){
      console.log(obj);
      this.clear_eop();
      this.editpointer=obj.veh_id;
      this.edit_rs=obj.emp_id;
      this.edit_placa=obj.veh_placa;
      this.placa_act=this.edit_placa;
      this.wait = true;
      this.tipo_doc=-1;
      //this.editpointer=number;

      this.$refs.mo_editar_per.open();
      switch(index)
      {
      case 2:
        this.tipo_act="CITV 6m";
        if(!obj.CITV6m) {
          return 
        }
        this.tipo_doc=obj.CITV6m[0].id;

      break;
      case 3:
        this.tipo_act="CITV 12m";
        if(!obj.CITV12m) {
          return 
        }
        this.tipo_doc=obj.CITV12m[0].id;

      break;
      case 4:
        this.tipo_act="SOAT";
        if(!obj.SOAT) {
          return 
        }
        this.tipo_doc=obj.SOAT[0].id;
      break;
      case 5:
        this.tipo_act="POLIZA";
        if(!obj.POLIZA) {
          return 
        }
        this.tipo_doc=obj.POLIZA[0].id;
      break;
      case 6:
        this.tipo_act="ELEMENTOS PELIGROSOS";
        if(!obj.MTCMATPEL) {
          return 
        }
        this.tipo_doc=obj.MTCMATPEL[0].id;
      break;
      case 7:
        this.tipo_act="BONIFICACIÓN";
        if(!obj.BONIFICACION) {
          return 
        }
        this.tipo_doc=obj.BONIFICACION[0].id;
      break;
      case 8:
        this.tipo_act="HERMETICIDAD";
        if(!obj.HERMETECIDAD) {
          return 
        }
        this.tipo_doc=obj.HERMETECIDAD[0].id;
      break;
      case 9:
        this.tipo_act="MTC MERCANCIAS";
        if(!obj.MTCMERCANCIAS) {
          return 
        }
        this.tipo_doc=obj.MTCMERCANCIAS[0].id;
      break;

      }
      if(this.tipo_doc!=-1) {
        //this.load_edit();
        axios
        .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/vista",
        {
          "veh_id": this.editpointer,
          "vtd_id": this.tipo_doc
        })
        .then((resp) => {
          this.data_edit = resp.data;

          this.load_data_edit();
          this.emp_cont=this.form_e.rs;
          this.wait = false;

        })
        .catch(function (error) {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación, error: "+String(error));
          return false;
        });

      }
      else {
        this.open_fail("Hubo un error interno al obtener los datos del servidor");
      }

    },

    cellStyle2(obj) {
      switch(obj.columnIndex)
      {
      case 3:
        if(!obj.row.CITV6m) {
          return 
        }
        if (obj.row.CITV6m[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.CITV6m[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.CITV6m[0].color=="#ff3823") {
          return "cell-3";
        }
      break;
      case 4:
        if(!obj.row.CITV12m) {
          return 
        }
        if (obj.row.CITV12m[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.CITV12m[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.CITV12m[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 5:
        if(!obj.row.SOAT) {
          return 
        }
        if (obj.row.SOAT[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.SOAT[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.SOAT[0].color=="#ff3823") {
          return "cell-3";
        }
        
      break;
      case 6:
        if(!obj.row.POLIZA) {
          return 
        }
        if (obj.row.POLIZA[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.POLIZA[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.POLIZA[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 7:
        if(!obj.row.MTCMATPEL) {
          return 
        }
        if (obj.row.MTCMATPEL[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.MTCMATPEL[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.MTCMATPEL[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 8:
        if(!obj.row.BONIFICACION) {
          return 
        }
        if (obj.row.BONIFICACION[0].color=="#92d36e") {  
          return "cell-1";
        }
        if (obj.row.BONIFICACION[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.BONIFICACION[0].color=="#ff3823") {
          return "cell-3";
        }

      break;
      case 9:
        if(!obj.row.HERMETECIDAD) {
          return 
        }
        if (obj.row.HERMETECIDAD[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.CITV6m[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.HERMETECIDAD[0].color=="#ff3823") {
          return "cell-3";
        }
      break;

      case 10:
        if(!obj.row.MTCMERCANCIAS) {
          return 
        }
        if (obj.row.MTCMERCANCIAS[0].color=="#92d36e") {
          return "cell-1";
        }
        if (obj.row.CITV6m[0].color=="#fefb64") {
          return "cell-2";
        }
        if (obj.row.MTCMERCANCIAS[0].color=="#ff3823") {
          return "cell-3";
        }

      break;

      }

    },

    get_nombre(obj,idx) {

      switch(idx)
      {
      case 2:
        if(!obj.CITV6m) {
          return "No info"
        }
        else {
          if (!obj.CITV6m[0].fecha) {
            return "No info"
          }
          return obj.CITV6m[0].fecha
        }
      break;
      case 3:
        if(!obj.CITV12m) {
          return "No info"
        }
        else {
          if (!obj.CITV12m[0].fecha) {
            return "No info"
          }
          return obj.CITV12m[0].fecha
        }

      break;
      case 4:
        if(!obj.SOAT) {
          return "No info"
        }
        else {
          if (!obj.SOAT[0].fecha) {
            return "No info"
          }
          return obj.SOAT[0].fecha
        }
      break;
      case 5:
        if(!obj.POLIZA) {
          return "No info"
        }
        else {
          if (!obj.POLIZA[0].fecha) {
            return "No info"
          }
          return obj.POLIZA[0].fecha
        }
      break;
      case 6:
        if(!obj.MTCMATPEL) {
          return "No info"
        }
        else {
          if (!obj.MTCMATPEL[0].fecha) {
            return "No info"
          }
          return obj.MTCMATPEL[0].fecha
        }
      break;
      case 7:
        if(!obj.BONIFICACION) {
          return "No info"
        }
        else {
          if (!obj.BONIFICACION[0].fecha) {
            return "No info"
          }
          return obj.BONIFICACION[0].fecha
        }
      break;
      case 8:
        if(!obj.HERMETECIDAD) {
          return "No info"
        }
        else {
          if (!obj.HERMETECIDAD[0].fecha) {
            return "No info"
          }
          return obj.HERMETECIDAD[0].fecha
        }
      break;
      case 9:
        if(!obj.MTCMERCANCIAS) {
          return "No info"
        }
        else {
          if (!obj.MTCMERCANCIAS[0].fecha) {
            return "No info"
          }
          return obj.MTCMERCANCIAS[0].fecha
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
  <el-form  :inline="true" :model="form" label-width="auto" :size="small"  >
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
        
        <el-form-item label="Placa">
          <el-input v-model="form_b.placa" />
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
  
  <div class="table-container">
  <el-table :cell-class-name="cellStyle2" :data="datap" border header-row-style="color:black;" height="98%" >
      <el-table-column fixed align="center" prop="emp_razonsocial" label="Razon soc. aso. " width="140" />
      <el-table-column  fixed prop="veh_placa" label="Placa " width="100" />
      <el-table-column  fixed prop="vcl_nombre" label="Tipo " width="100" />
      
      <el-table-column label="CITV 6m" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,2)" >{{get_nombre(scope.row,2)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="CITV 12m" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,3)" >{{get_nombre(scope.row,3)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="SOAT" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,4)" >{{get_nombre(scope.row,4)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="POLIZA" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,5)" >{{get_nombre(scope.row,5)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="MTC MATPEL" width="170">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,6)" >{{get_nombre(scope.row,6)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="BONIFICACIÓN" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,7)" >{{get_nombre(scope.row,7)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="HERMETICIDAD" width="150">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,8)" >{{get_nombre(scope.row,8)}}</el-button>
        </template>
      </el-table-column>
      <el-table-column label="MTC MERCANCIAS" width="160">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row,9)" >{{get_nombre(scope.row,9)}}</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>
          

<modal ref="mo_editar_per" no-close-on-backdrop title="Detalles" width="500px" @ok="send_editar_doc" cancel-title="Atrás" @cancel="closeedit"  centered>
  <el-form v-loading="wait" ref="form_edit_ref" :rules="rules" :model="form" label-width="150px" >
    <el-row style="text-align=center">
    <div style="margin-left: auto;margin-right: auto;text-align=center">
      <h4>Nombre: {{placa_act}}</h4>
      <h4>Tipo de doc.: {{tipo_act}}</h4>
    </div>
    </el-row>
    
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
  color: #bfbd3a;
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
