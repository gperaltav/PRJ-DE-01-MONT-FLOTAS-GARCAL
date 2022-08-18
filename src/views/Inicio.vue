<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import { ref } from 'vue'

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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/'+String(id))
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
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_c("Operación realizada satisfactoriamente");
            return true;
            
          }
          else {
            this.open_fail("Hubo un error con el servidor al ejecutar la operación");
            return false;
          }
        })
        .catch((e) => {
          this.open_fail("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
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
        })
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_e("Usuario modificado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          this.open_fail("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
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
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_e("Usuario eliminado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
        })
        .catch((e) => {
          this.open_fail("Hubo un error interno al ejecutar la operacion. Log:"+String(e));
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
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios')
        .then((resp) => {
          console.log(resp);
          this.users = resp.data;
        })
    },
    api_get_filt (){
      //llamada a API
      axios
        .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios',{
          usu_codigo:this.form_b.codigo,
          usu_nombres:this.form_b.nombre,
          usu_nrodocumento:this.form_b.nro_doc,
          usu_telefono:this.form_b.telefono,
          usu_direccion:this.form_b.direccion,
        })
        .then((resp) => {
          console.log(resp);
          this.users = resp.data;
        })
    }
    
  },
  mounted () {
     this.api_get_all();
  },
}
</script>


<template>

<div class="main-container">
  <el-form :inline="true" model="formInline" label-width="auto" :size="small" >
    <el-row>
      <el-col :span="21">
        <el-form-item label="Nombre">
          <el-input v-model="form_b.nombre" />
        </el-form-item>
        <el-form-item label="Nro. de documento">
          <el-input v-model="form_b.nro_doc" />
        </el-form-item>
        <el-form-item label="Nro. de telefono">
          <el-input v-model="form_b.telefono" />
        </el-form-item>
        <el-form-item label="Codigo">
          <el-input v-model="form_b.codigo" />
        </el-form-item>
      </el-col>

      <el-col :span="3">
          <div class="button-container">
            <el-row class="mb-4">
              <el-button color="#0844a4" :icon="Filter" @click="api_get_filt">Filtrar</el-button>
            </el-row>
            <el-row class="mb-4">
              <el-button color="#008db1" :icon="Plus"  @click="open_create">Crear</el-button>
            </el-row>
          </div>  
      </el-col>
    </el-row>
  </el-form>

  <div class="table-container">
    <el-table :data="users" border header-row-style="color:black;" height="98%" >
      <el-table-column prop="usu_codigo" label="Codigo" width="120" />
      <el-table-column prop="usu_nombres" label="Nombre" width="240" />
      <el-table-column prop="usu_nrodocumento" label="Nro. de doc." />
      <el-table-column prop="usu_telefono" label="Telefono" />
      <el-table-column prop="usu_direccion" label="Direccion" />
      <el-table-column fixed="right" label="" width="45">
        <template #default="scope">
          <el-button type="text"  @click="button_handle(scope.row.usu_codigo)"><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</div>


<modal ref="CreateMo" title="Crear usuario" width="500px"  @ok="create_usr()" @cancel="close_create" cancel-title="Atras" centered>

  <el-form  ref="form_cref" :model="form_c" label-width="200px" >

    <el-form-item label="Código del usuario">
      <el-input style="width:300px" v-model="form_c.codigo" />
    </el-form-item>

    <el-form-item label="Nombre" prop="nombre">
      <el-input style="width:300px" v-model="form_c.nombre" />
    </el-form-item>
    
    <el-form-item label="Apellido paterno">
      <el-input style="width:300px" v-model="form_c.ap_pat" />
    </el-form-item>

    <el-form-item label="Apellido materno">
      <el-input style="width:300px" v-model="form_c.ap_mat" />
    </el-form-item>

    <el-form-item label="Nro. de documento">
      <el-input style="width:300px" v-model="form_c.nro_doc" />
    </el-form-item>

    <el-form-item label="Nro. de telefono">
      <el-input style="width:300px" v-model="form_c.nro_tel" />
    </el-form-item>

    <el-form-item label="Dirección">
      <el-input style="width:300px" v-model="form_c.direccion" />
    </el-form-item>

    <el-form-item label="Contraseña">
      <el-input style="width:300px" v-model="form_c.password" />
    </el-form-item>

  </el-form>

</modal>

<modal ref="EditMo" no-close-on-backdrop title="Editar usuario" width="500px" cancel-title="Atras" @ok="editar_usr()" centered>
  
  <el-form v-loading="wait" ref="form_cref" :model="form_e" label-width="200px" >

    <el-form-item label="Código del usuario">
      <el-input style="width:300px" v-model="form_e.codigo" />
    </el-form-item>

    <el-form-item label="Nombre" prop="nombre">
      <el-input style="width:300px" v-model="form_e.nombre" />
    </el-form-item>
    
    <el-form-item label="Apellido paterno">
      <el-input style="width:300px" v-model="form_e.ap_pat" />
    </el-form-item>

    <el-form-item label="Apellido materno">
      <el-input style="width:300px" v-model="form_e.ap_mat" />
    </el-form-item>

    <el-form-item label="Nro. de documento">
      <el-input style="width:300px" v-model="form_e.nro_doc" />
    </el-form-item>

    <el-form-item label="Nro. de telefono">
      <el-input style="width:300px" v-model="form_e.nro_tel" />
    </el-form-item>

    <el-form-item label="Dirección">
      <el-input style="width:300px" v-model="form_e.direccion" />
    </el-form-item>

    <el-form-item label="Contraseña">
      <el-input placeholder="Dejar vacío para conservar" style="width:300px" v-model="form_e.password" />
    </el-form-item>

    <el-row style="text-align=center">
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_advertencia_e('Realmente desea eliminar a este usuario?')">Eliminar</el-button>
    </el-row>

  </el-form>

</modal>

<modal ref="mo_advertencia_elim" title="Confirmar" centered @ok="send_delete" @cancel="close_advertencia_e" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success hide-cancel  title="Operacion completada" centered @ok="close_succes_c" ok-title="Cerrar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_ed" success hide-cancel  title="Operacion completada" centered @ok="close_succes_e" ok-title="Cerrar" >
  {{alert_mo}}
</modal>

<modal ref="mo_error" hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
  <br/> {{alert_cause}}
</modal>

</template>


<style scoped src="./styles/internal.css">

</style>

