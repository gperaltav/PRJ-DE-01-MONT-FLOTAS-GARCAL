<script  setup>
import { reactive } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download} from '@element-plus/icons-vue'

import { ref } from 'vue'

</script>

<script>
import modal from "../components/modal.vue"
import Sketch from "../assets/sketch.min"
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
    animation() {
      (function() {
        var Mountain, MountainRange, dt, mountainRanges, sketch;

        sketch = Sketch.create();

        sketch.mouse.x = sketch.width / 10;

        sketch.mouse.y = sketch.height;

        mountainRanges = [];

        dt = 1;

        Mountain = function(config) {
          return this.reset(config);
        };

        Mountain.prototype.reset = function(config) {
          this.layer = config.layer;
          this.x = config.x;
          this.y = config.y;
          this.width = config.width;
          this.height = config.height;
          return this.color = config.color;
        };

        MountainRange = function(config) {
          this.x = 0;
          this.mountains = [];
          this.layer = config.layer;
          this.width = {
            min: config.width.min,
            max: config.width.max
          };
          this.height = {
            min: config.height.min,
            max: config.height.max
          };
          this.speed = config.speed;
          this.color = config.color;
          this.populate();
          return this;
        };

        MountainRange.prototype.populate = function() {
          var newHeight, newWidth, totalWidth, _results;
          totalWidth = 0;
          _results = [];
          while (totalWidth <= sketch.width + (this.width.max * 4)) {
            newWidth = round(random(this.width.min, this.width.max));
            newHeight = round(random(this.height.min, this.height.max));
            this.mountains.push(new Mountain({
              layer: this.layer,
              x: this.mountains.length === 0 ? 0 : this.mountains[this.mountains.length - 1].x + this.mountains[this.mountains.length - 1].width,
              y: sketch.height - newHeight,
              width: newWidth,
              height: newHeight,
              color: this.color
            }));
            _results.push(totalWidth += newWidth);
          }
          return _results;
        };

        MountainRange.prototype.update = function() {
          var firstMountain, lastMountain, newHeight, newWidth;
          this.x -= (sketch.mouse.x * this.speed) * dt;
          firstMountain = this.mountains[0];
          if (firstMountain.width + firstMountain.x + this.x < -this.width.max) {
            newWidth = round(random(this.width.min, this.width.max));
            newHeight = round(random(this.height.min, this.height.max));
            lastMountain = this.mountains[this.mountains.length - 1];
            firstMountain.reset({
              layer: this.layer,
              x: lastMountain.x + lastMountain.width,
              y: sketch.height - newHeight,
              width: newWidth,
              height: newHeight,
              color: this.color
            });
            return this.mountains.push(this.mountains.shift());
          }
        };

        MountainRange.prototype.render = function() {
          var c, d, i, pointCount, _i, _ref;
          sketch.save();
          sketch.translate(this.x, (sketch.height - sketch.mouse.y) / 20 * this.layer);
          sketch.beginPath();
          pointCount = this.mountains.length;
          sketch.moveTo(this.mountains[0].x, this.mountains[0].y);
          for (i = _i = 0, _ref = pointCount - 2; _i <= _ref; i = _i += 1) {
            c = (this.mountains[i].x + this.mountains[i + 1].x) / 2;
            d = (this.mountains[i].y + this.mountains[i + 1].y) / 2;
            sketch.quadraticCurveTo(this.mountains[i].x, this.mountains[i].y, c, d);
          }
          sketch.lineTo(sketch.width - this.x, sketch.height);
          sketch.lineTo(0 - this.x, sketch.height);
          sketch.closePath();
          sketch.fillStyle = this.color;
          sketch.fill();
          return sketch.restore();
        };

        sketch.setup = function() {
          var i, _results;
          i = 5;
          _results = [];
          while (i--) {
            _results.push(mountainRanges.push(new MountainRange({
              layer: i + 1,
              width: {
                min: (i + 1) * 50,
                max: (i + 1) * 70
              },
              height: {
                min: 200 - (i * 40),
                max: 300 - (i * 40)
              },
              speed: (i + 1) * .003,
              color: 'hsl( 120, ' + (((i + 1) * 1) + 10) + '%, ' + (75 - (i * 13)) + '% )'
            })));
          }
          return _results;
        };

        sketch.clear = function() {
          return sketch.clearRect(0, 0, sketch.width, sketch.height);
        };

        sketch.update = function() {
          var i, _results;
          dt = sketch.dt < .1 ? .1 : sketch.dt / 16;
          dt = dt > 5 ? 5 : dt;
          i = mountainRanges.length;
          _results = [];
          while (i--) {
            _results.push(mountainRanges[i].update(i));
          }
          return _results;
        };

        sketch.draw = function() {
          var i, _results;
          i = mountainRanges.length;
          _results = [];
          while (i--) {
            _results.push(mountainRanges[i].render(i));
          }
          return _results;
        };

        $(window).on('mousemove', function(e) {
          sketch.mouse.x = e.pageX;
          return sketch.mouse.y = e.pageY;
        });

      }).call(this);
    },
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

<style>
canvas {
  background: 
    linear-gradient(
      hsl(200, 50%, 80%) 0%, 
      hsl(200, 30%, 95%) 75%)
  ;
  display: block;
}

div {
  background: url(https://jackrugile.com/images/misc/skyline-texture.png);
  height: 100%;
  left: 0;
  position: fixed;
  top: 0;
  width: 100%;
}
</style>

<style scoped src="./styles/internal.css">

</style>

