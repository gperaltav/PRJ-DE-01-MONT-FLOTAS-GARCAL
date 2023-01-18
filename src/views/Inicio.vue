<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import { ref } from 'vue'
import '../assets/plotly.min.js'

</script>

<script>
import modal from "../components/modal.vue"
export default {
  components: {
    modal,
  },
  data(){
    return {
      users:[],
      open_m:false,
      puntero_edit:1,
      editpointer:'',
      alert_mo:'',

      data_edit:[],

      data_tra1:[],
      data_tra2:[],
      data_t2:[],
      data_t3:[],
      data_t4:[],
      data_t5:[],
      data_t6:[],

      wait:false,

      form_c : reactive({
        nombre: '',
        codigo: '',
        ap_mat: '',
        ap_pat: '',
        nro_doc: '',
        nro_tel: '',
        direccion: '',
        password: '',
      }),
      form_e : reactive({
        nombre: '',
        codigo: '',
        ap_mat: '',
        ap_pat: '',
        nro_doc: '',
        nro_tel: '',
        direccion: '',
        password: '',
      }),
      form_b : reactive({
        nombre: '',
        codigo: '',
        nro_doc:'',
        telefono:'',
        direccion:''
      }),
      form_edit : reactive({
        nombre: '',
      })
    }
  },
  methods: {
    clear_c() {
      this.form_c.nombre= '';
      this.form_c.codigo= '';
      this.form_c.ap_mat= '';
      this.form_c.ap_pat= '';
      this.form_c.nro_doc= '';
      this.form_c.nro_tel= '';
      this.form_c.direccion= '';
      this.form_c.password= '';
    },
    clear_e() {
      this.form_e.nombre= '';
      this.form_e.codigo= '';
      this.form_e.ap_mat= '';
      this.form_e.ap_pat= '';
      this.form_e.nro_doc= '';
      this.form_e.nro_tel= '';
      this.form_e.direccion= '';
      this.form_e.password= '';
    },

    open_edit() {
      this.$refs.EditMo.open()
    },
    close_edit() {
      this.$refs.EditMo.hide()
    },

    open_create() {
      this.$refs.CreateMo.open()
    },
    close_create() {
      this.$refs.CreateMo.hide()
    },

    open_succes_c(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado.open();
    },
    close_succes_c() {
      this.$refs.mo_realizado.hide();
      this.$refs.CreateMo.hide();
      this.api_get_all();
      this.clear_c();
    },

    open_succes_e(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado_ed.open();
    },
    close_succes_e() {
      this.$refs.mo_realizado_ed.hide();
      this.$refs.EditMo.hide();
      this.api_get_all();
      this.clear_e();
    },

    open_advertencia_e(msg) {
      this.alert_mo=msg;
      this.$refs.mo_advertencia_elim.open();
    },
    close_advertencia_e() {
      this.$refs.mo_advertencia_elim.hide();
    },


    open_fail(msg) {
      this.alert_mo=msg;
      this.$refs.mo_error.open();
    },
    close_fail() {
      this.$refs.mo_error.hide();
    },

    check() {
      //verificar campos
      if (nombre=='') {
        this.api_get_all();
      }
      else {
        this.onSubmit2();
      }
    },
    set_actual(usr) {
      this.$refs.myRef.open();
    }, 
    onSubmit2 (){
      console.log(this.form.nombre);
    },

    okis() {
      console.log("Todo ok");
    },

    load_edit(id) {
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/'+String(id),{},{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        })
    },

    create_usr(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/nuevo', 
        { 
          "usu_codigo": this.form_c.codigo,
          "usu_clave": this.form_c.password,
          "usu_nombres": this.form_c.nombre,
          "usu_apellidopaterno": this.form_c.ap_pat,
          "usu_apellidomaterno": this.form_c.ap_mat,
          "usu_nrodocumento": this.form_c.nro_doc,
          "usu_telefono": this.form_c.nro_tel,
          "usu_direccion": this.form_c.direccion,
          "usu_usucreacion": this.$store.state.username
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_c("Operación realizada satisfactoriamente");
            return true;
            
          }
          else {
            console.log("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch((e) => {
          console.log("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
          return false;
        });
    },

    editar_usr(){
      //llamada a API
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/actualizar', 
        { 
          "usu_codigo": this.editpointer,
          "usu_clave": this.form_e.password,
          "usu_nombres": this.form_e.nombre,
          "usu_apellidopaterno": this.form_e.ap_pat,
          "usu_apellidomaterno": this.form_e.ap_mat,
          "usu_nrodocumento": this.form_e.nro_doc,
          "usu_telefono": this.form_e.nro_tel,
          "usu_direccion": this.form_e.direccion,
          "usu_usucreacion": this.$store.state.username
        },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_e("Usuario modificado satisfactoriamente");
          }
          else {
            console.log("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          console.log("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
          return false;
        });
    },

    load_data_edit() {
      this.form_e.codigo=this.editpointer;
      this.form_e.nombre=this.data_edit[0].usu_nombres;
      this.form_e.ap_pat=this.data_edit[0].usu_apellidopaterno;
      this.form_e.ap_mat=this.data_edit[0].usu_apellidomaterno;
      this.form_e.direccion=this.data_edit[0].usu_direccion;
      this.form_e.nro_doc=this.data_edit[0].usu_nrodocumento;
      this.form_e.nro_tel=this.data_edit[0].usu_telefono;
    },

    send_delete() {
      this.close_advertencia_e();

      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/borrar/'+String(this.editpointer),{},{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_e("Usuario eliminado satisfactoriamente");
          }
          else {
            console.log("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          console.log("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
          return false;
        });

    },

    button_handle(key){
      console.log(key);
      
      this.editpointer=key;
      this.open_edit();
      this.wait = true;
      this.load_edit(key);
      
      setTimeout(() => {
        this.load_data_edit();
        this.emp_cont=this.form_e.rs;
        this.wait = false;
      }, 400)
    },

    api_get_all (){
      //llamada a API
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.users = resp.data;
        })
    },

    get_fig3() {
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_t3 = resp.data;
        })
    },

    get_fig4() {
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/mantenimientoscab/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_t4 = resp.data;
        })
    },

    get_fig5() {
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprascab/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_t5 = resp.data;
        })
    },
    get_fig6() {
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprasdet/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);
          this.data_t6 = resp.data;
        })
    },


    get_plot() {
      this.data_tra1=[];
      this.data_tra2=[];
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (resp.data) {
            for (const key in resp.data) {
              this.data_tra1.push(resp.data[key].emp_razonsocial);
              this.data_tra2.push(1);
            }
            console.log(this.data_tra1);
            var data = [{
              values: this.data_tra2,
              labels: this.data_tra1,
              domain: {column: 0},
              name: 'Trabajadores',
              hoverinfo: 'label+percent+name',
              hole: .4,
              type: 'pie'
            }];

            var layout = {
              title: 'Personal activo',
              annotations: [
                {
                  font: {
                    size: 15
                  },
                  showarrow: false,
                  text: '',
                  x: 0.17,
                  y: 0.5
                }
              ],
              height: 350,
              width: 350,
              showlegend: false,
              grid: {rows: 1, columns: 1}
            };

            Plotly.newPlot('graph1', data, layout);
          }
          else {
            console.log("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          console.log("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
          return false;
        });
    
    },

    get_plot2() {
      this.data_t2=[];
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/graficos',{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (resp.data) {
            for (const key in resp.data) {
              var x_tmp=[];
              var y_tmp=[];
              for (const key2 in resp.data[key].detalle) {
                x_tmp.push(resp.data[key].detalle[key2].con);
                y_tmp.push(resp.data[key].detalle[key2].monto);
              }
              this.data_t2.push({
                x:x_tmp,
                y:y_tmp,
                name:resp.data[key].via_descripcion,
                type: 'bar'
              })
            }
            console.log(this.data_t2);
            //grafica
            var data = this.data_t2;

            var layout = {
              title: 'Recursos asignados por viaje',
              barmode: 'group',
              annotations: [
                {
                  font: {
                    size: 15
                  },
                  showarrow: false,
                  text: '',
                  x: 0.17,
                  y: 0.5
                }
              ],
              height: 350,
              width: 350,
              showlegend: true,
              grid: {rows: 1, columns: 1}
            }
            Plotly.newPlot('graph2', data, layout);
          }
          else {
            console.log("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          console.log("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
          return false;
        });
    }
    
  },
  mounted () {
     this.api_get_all();
     this.get_plot();
     this.get_plot2();
     this.get_fig3();
     this.get_fig4();
     this.get_fig5();
     this.get_fig6();
  },
}
</script>


<template>

<el-row>
  <el-col :span="$isMobile() ? 24:8">
    <div id="graph1"> 
    </div>
  </el-col>

  <el-col :span="$isMobile() ? 24:8">
    <div id="graph2"> 
    </div>
  </el-col>

  <el-col :span="$isMobile() ? 24:8" style="margin-top:30px">
    <span style="margin-button:30px">Documentos a vencer:</span>
    <el-table size="small" :data="data_t3" style="width: 100%" height="250">
      <el-table-column prop="emp_razonsocial" label="Empresa"  />
      <el-table-column prop="veh_placa" label="Placa" />
      <el-table-column prop="vtd_nombre" label="Tipo doc." />
      <el-table-column prop="vxd_fechavencimiento" label="Venc."/>
       <el-table-column prop="vcl_nombre" label="Clase"  />
    </el-table>
  </el-col>
  
</el-row>

<el-row :gutter="5">
  <el-col :span="$isMobile() ? 24:8">
    <span style="margin-button:30px">Alerta para mantenimiento:</span>
    <el-table size="small" :data="data_t4" style="width: 100%" height="250">
      <el-table-column prop="emp_razonsocial" label="Empresa"  />
      <el-table-column prop="veh_placa" label="Placa" />
      <el-table-column prop="man_fecha" label="Fecha de mant." />
    </el-table>
  </el-col>
  <el-col :span="$isMobile() ? 24:8">
    <span style="margin-button:30px">Vencimiento de cuentas:</span>
    <el-table size="small" :data="data_t5" style="width: 100%" height="250">
      <el-table-column prop="emp_razonsocial" label="Empresa"  />
      <el-table-column prop="ccc_serienumero" label="Nro. de doc." />
      <el-table-column prop="cce_descripcion" label="Tipo" />
    </el-table>
  </el-col>
  <el-col :span="$isMobile() ? 24:8">
    <span style="margin-button:30px">Combustible:</span>
    <el-table size="small" :data="data_t6" style="width: 100%" height="250">
      <el-table-column prop="ruta" label="Ruta"  />
      <el-table-column prop="veh_placa" label="Vehículo" />
      <el-table-column prop="costo" label="Costo" />
    </el-table>
  </el-col>
</el-row>

</template>


<style scoped src="./styles/internal.css">

</style>

