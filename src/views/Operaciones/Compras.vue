<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, List,Search,DArrowLeft} from '@element-plus/icons-vue'

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
  data(){
    return {
      editpointer:0,
      succes: false,
      datap: [],
      datav: [],
      opt_rs: [],
      opt_prv: [],
      opt_fp: [],
      opt_veh:[],
      opt_via:[],
      opt_td:[],

      data_edit: [],
      data_edit2: [],
      wait:false,
      wait2:false,
      alert_mo:'',

      subtotal:0,

      emp_cont:'1',

      form_g : reactive({
        rs: '',
        prv_id:'',
        prv_nom:'',
        
        tipo_doc:'',
        serie_doc:'',
        nro_doc:'',
        fecha_em:'',

        tipo_pago:'',

        subtotal:'',
        impuesto:'',
        igv: 18,
        total:'',
      }),

      form_t : reactive({
        prod:'',
        prod_nom:'',
        cantidad:'',
        precio_u:'',
        subtotal:'',
        unidad:'UNI',
        afi:'',

        fecha_via:'',
        via_id:'',

        veh_id:'',
        tipo:'',
        modelo:''
      }),


      aux : reactive({
        veh_id:'',
        acople_id:'',
        pro_id:'',

      }),

    }
  },

  methods: {

    clear_t() {
      this.form_t.prod='';
      this.form_t.cantidad='';
      this.form_t.precio_u='';
      this.form_t.afi='';

      this.form_t.fecha_via='';
      this.form_t.via_id='';

      this.form_t.veh_id='';
      this.form_t.tipo='';
      this.form_t.modelo='';
    },

    clear_g() {
      this.form_g.rs= '';
      this.form_g.prv_id='';
      this.form_g.prv_nom='';

      this.form_g.tipo_doc='';
      this.form_g.serie_doc='';
      this.form_g.nro_doc='';
      this.form_g.fecha_em='';

      this.form_g.tipo_pago='';

      this.form_g.subtotal='';
      this.form_g.impuesto='';
      this.form_g.igv= 18;
      this.form_g.total='';

      this.datap= [];
      this.datav = [];
      this.opt_prv= [];
      this.opt_fp= [];

    },

    clear_c() {
      this.form_g.rs= '';
      this.form_g.prv_id='';
      this.form_g.prv_nom='';

      this.form_g.tipo_doc='';

      this.form_g.tipo_pago='';

      this.datap= [];
      this.opt_prv= [];
      this.opt_fp= [];

    },

    rs_changer() {
      this.emp_cont=this.form_g.rs;
      this.load_prod();
      this.get_tipos_doc();
      this.get_formas_pago();
    },

    fech_changer() {
      //cargar listas
      this.get_viajes();
    },

    open_crear() {
      this.$refs.mo_create_det.open(); 
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

    closedet() {
      this.$refs.mo_create_det.hide();
      this.clear_t();
    },

    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },
    
    get_proveedores(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.form_g.rs),
        "ent_nrodocumento": query,
        "ext_id": "prv"
      })
      .then((resp) => {
        console.log(resp);
        this.opt_prv = resp.data;
      })
    },

    select_proveedores(idx) {
      for (let tmp in this.opt_prv)  {
        if (this.opt_prv[tmp].ent_id == idx) {
          this.form_g.prv_nom  = this.opt_prv[tmp].ent_nombre;
          return;
        }
      }
    },

    select_prod(idx) {
      for (let tmp in this.opt_prod)  {
        console.log(tmp);
        if (this.opt_prod[tmp].pro_id == idx) {
          this.form_t.prod_nom  = this.opt_prod[tmp].pro_nombre;
          return;
        }
      }
    },

    get_formas_pago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.form_g.rs))
      .then((resp) => {
        console.log(resp);
        this.opt_fp = resp.data;
      })
    },

    get_tipos_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprastipos/'+String(this.form_g.rs))
      .then((resp) => {
        console.log(resp);
        this.opt_td = resp.data;
      })
    },

    get_viajes() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": this.form_g.rs,
        "via_fechaviaje":this.form_t.fecha_via
      })
      .then((resp) => {
        console.log(resp);
        this.opt_via = resp.data;
      })
    },

    veh_changer(id) {
      for (let tmp in this.opt_veh)  {
        console.log(tmp);
        if (this.opt_veh[tmp].veh_id == id) {
          this.form_t.tipo = this.opt_veh[tmp].vcl_nombre;
          return;
        }
      }
    },

    get_vehiculos(query) {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/controldocumentosvehiculos', 
      {
        "emp_id": this.form_g.rs,
        "via_fechaviaje":query
      })
      .then((resp) => {
        console.log(resp);
        this.opt_veh = resp.data;
      })
    },

    load_prod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/'+String(this.form_g.rs))
        .then((resp) => {
          console.log(resp);  
          this.opt_prod = resp.data;
        })
    },

    create_det() {
      var tmp;
      if(this.form_t.afi=="1") { //viaje
        tmp={
          "pro_id":Number(this.form_t.prod),
          "via_id":Number(this.form_t.via_id),
          "veh_id":"",
          "tra_id":"",
          "ccd_serie":this.form_g.serie_doc,
          "ccd_cantidad":this.form_t.cantidad,
          "ccd_preciounitario":this.form_t.precio_u,
          "ccd_subtotal":Number(this.form_t.cantidad)*Number(this.form_t.precio_u),
          "uni_unidad":"UNI"
        }
      }
      if(this.form_t.afi=="2") {
        tmp={
          "pro_id":Number(this.form_t.prod),
          "via_id":"",
          "veh_id":Number(this.form_t.veh_id),
          "tra_id":"",
          "ccd_serie":this.form_g.serie_doc,
          "ccd_cantidad":this.form_t.cantidad,
          "ccd_preciounitario":this.form_t.precio_u,
          "ccd_subtotal":Number(this.form_t.cantidad)*Number(this.form_t.precio_u),
          "uni_unidad":"UNI"
        }
      }
      this.datap.push(tmp);
      var num=Number(this.form_t.precio_u)*Number(this.form_t.cantidad);
      this.datav.push({
        "det_cantidad":this.form_t.cantidad,
        "det_producto":this.form_t.prod_nom,
        "det_unidad":this.form_t.unidad,
        "det_p_unitario":this.form_t.precio_u,
        "det_subtotal":num,
      });
      this.subtotal=this.subtotal+num;
      
      this.closedet();
      
    },
    roundUp(num, precision) {
      precision = Math.pow(10, precision)
      return Math.ceil(num * precision) / precision
    },
    roundDwn(num, precision) {
      precision = Math.pow(10, precision)
      return Math.floor(num * precision) / precision
    },
    calcular1() {
      this.form_g.subtotal=Number(this.subtotal);
      this.form_g.impuesto=String(this.roundUp((Number(this.form_g.igv)/100)*Number(this.form_g.subtotal),1));
      this.form_g.total=String(Number(this.form_g.impuesto)+Number(this.form_g.subtotal));
    },
    calcular2() {
      this.form_g.total=Number(this.subtotal);
      var aux=Number(this.form_g.total)/(100+Number(this.form_g.igv));
      this.form_g.impuesto=String(this.roundUp(aux*Number(this.form_g.igv),1));
      this.form_g.subtotal=String(this.roundDwn(aux*100,1));
    },

    transaccion_insertar() {
      const tiempoTranscurrido = Date.now();
      const hoy = new Date(tiempoTranscurrido);
      var mm=String(hoy.getMonth() + 1);
      var aa=String(hoy.getFullYear());
      var dd=String(hoy.getDate());

      if(mm.length==1)
        mm="0"+mm;
      if(dd.length==1)
        dd="0"+dd;

      var fech=aa+"-"+mm+"-"+dd;

      console.log(fech);

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescompras/nuevo', 
      {
        "emp_id": Number(this.form_g.rs),
        "ent_id": Number(this.form_g.prv_id),
        "ccc_serie": this.form_g.serie_doc,
        "ccc_numero": this.form_g.nro_doc,
        "ccc_fechaemision": this.form_g.fecha_em,
        "ccc_subtotal": Number(this.form_g.subtotal),
        "ccc_impuesto": Number(this.form_g.impuesto),
        "ccc_total": Number(this.form_g.total),
        "cct_codigo": this.form_g.tipo_doc,
        "cce_codigo": "CAN",
        "mon_codigo": "SOL",
        "ccc_observaciones": this.form_g.tipo_pago,
        "ccc_idreferencia":"",
        "ccc_tipocambio": 18,
        "ccc_generamovimiento":false,
        "ccc_fechaingreso": fech,
        "ccc_periodoregistro": fech,
        "ccr_codigo":"PEA",
        "usu_codigo": "admin",
        "ccc_usucreacion":"admin",
        "detalle":this.datap
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          this.clear_g();
          this.subtotal=0;
          return true;
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
      })
    },

  },

  mounted () {
    //llamada a API
    this.load_rs();
    //this.load_tc();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
  
  <el-form :inline="true"  label-width="auto" :size="small" >

    <el-row>
      <el-form-item style="margin-left:auto;margin-right:auto" label="Razón social asociada">
        <el-select v-model="form_g.rs" @change="rs_changer" @clear="clear_c" placeholder="Seleccionar" style="width:600px" clearable>
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
      <el-form-item style="margin-left:auto;margin-right:auto" label="Proveedor">
        <el-row style="width:600px"> 
          <el-col :span="8">
            <el-select
              v-model="form_g.prv_id"
              filterable
              :remote-method="get_proveedores"
              @change="select_proveedores"
              @clear="clear_proveedores"
              placeholder="Inserte ID de proveedor"
              remote
              clearable
              :disabled="stop_cliente"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>

              <el-option
                v-for="item in opt_prv"
                :key="item.ent_id"
                :label="item.ent_nrodocumento"
                :value="item.ent_id"
              />
            </el-select>
          </el-col>
          <el-col :span="16">
            <el-input disabled v-model="form_g.prv_nom" placeholder="Nombre de proveedor" />
          </el-col>
        </el-row>
      </el-form-item>
    </el-row>

    <el-row style="width:800px; margin-left:auto; margin-right:auto"> 
      <el-col :span="6">
        <el-select v-model="form_g.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  clearable>
        <el-option
          v-for="item in opt_td"
          :key="item.cct_codigo"
          :label="item.cct_descripcion"
          :value="item.cct_codigo"
        > </el-option>
        </el-select>
      </el-col>
    
      <el-col :span="18">     
          <el-row > 
            <el-col :span="12" >
              <el-input v-model="form_g.serie_doc" placeholder="nro de serie" />
            </el-col>
            <el-col :span="12">
              <el-input v-model="form_g.nro_doc" placeholder="nro de documento" />
            </el-col>
          </el-row>
      </el-col>
    </el-row>

  <el-row>
    <el-form-item style="margin-left:auto;margin-right:auto" label="Fecha de pago">
      <el-date-picker
        type="date"
        v-model="form_g.fecha_em"
        format="YYYY-MM-DD"
        value-format="YYYY-MM-DD"
        placeholder="Seleccione fecha"
        style="width: 300px"
      />
    </el-form-item>
  </el-row>
      
    </el-form>

    <div >
      <el-container style="border-style: solid; border-color:grey">
        <el-header style="background-color:grey; height:40px">
          Detalle
        </el-header>
        <el-main>
          <div class="table-container">
          <el-table :data="datav" border header-row-style="color:black;" >
              <el-table-column prop="det_cantidad" label="Cantidad" width="140" align="center"/>
              <el-table-column prop="det_producto" label="Producto"  />
              <el-table-column prop="det_unidad" label="Unidad" />
              <el-table-column prop="det_p_unitario" label="Precio unitario" />
              <el-table-column prop="det_subtotal" label="Sub total"  align="center" />
            </el-table>
          </div>
          <el-row style="text-align=center" >
            <el-button color="#008db1" :icon="Plus"  @click="open_crear" style="margin-left: auto;margin-right: auto">Agregar</el-button>
          </el-row>
        </el-main>
      </el-container>
      <el-row>
        <h3 style="margin-left:auto; margin-right:50px">Importe: {{subtotal}}</h3>
      </el-row>
      
      <el-row>
      <el-form-item style="margin-left:auto; margin-right:50px" label="Subtotal" prop="subtotal">
        <el-input style="width:250px" v-model="form_g.subtotal">
          <template #append>
            <el-button @click="calcular1()" :icon="DArrowLeft"> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>
      </el-row>

      <el-row>
      <el-form-item style="margin-right: auto;" label="Tipo de pago">
      <el-select v-model="form_g.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
        <el-option
          v-for="item in opt_fp"
          :key="item.fdp_id"
          :label="item.fdp_descripcion"
          :value="item.fdp_id"
          
        > </el-option>
      </el-select>
    </el-form-item>

      <el-form-item style="margin-left:auto; margin-right:50px" label="Impuesto" prop="impuesto">
        <el-input style="width:190px" v-model="form_g.impuesto">
          <template #prepend>S/</template>
        </el-input>
        <el-input style="width:60px" v-model="form_g.igv">
          <template #suffix>%</template>
        </el-input>
      </el-form-item>
      </el-row>

      <el-row>
      <el-form-item style="margin-left:auto; margin-right:50px" label="Total" prop="total">
        <el-input style="width:250px" v-model="form_g.total">
          <template #append>
          <el-button  @click="calcular2()" :icon="DArrowLeft"> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>
      </el-row>
    </div>
    <el-row style="text-align=center" >
      <el-button color="#0844a4"  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto">Guardar</el-button>
    </el-row>

<modal ref="mo_create_det" no-close-on-backdrop title="Agregar detalle" width="500px" @ok="create_det" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_t" label-width="150px" >

    <el-form-item label="Producto" >
      <el-select style="width:300px" v-model="form_t.prod" @change="select_prod" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_prod"
          :key="item.pro_id"
          :label="item.pro_nombre"
          :value="item.pro_id"
        > </el-option>
      </el-select>
    </el-form-item>
    
    <el-form-item  prop="nro_doc">
      <el-row style="width:300px">
        <el-col :span="12">
          <el-input placeholder="Cantidad" v-model="form_t.cantidad" />
        </el-col>
        <el-col :span="12">
          <el-input placeholder="Precio unitario" v-model="form_t.precio_u" />
        </el-col>
      </el-row>
    </el-form-item>

    <el-form-item label="">
      <el-radio-group v-model="form_t.afi">
        <el-radio label="1">Viaje</el-radio>
        <el-radio label="2">Vehiculo</el-radio>
        
      </el-radio-group>
    </el-form-item>

    <div v-if='form_t.afi=="1" '>
      <el-form-item label="Fecha de viaje">
        <el-date-picker
          type="date"
          v-model="form_t.fecha_via"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          style="width: 300px"
          @change="fech_changer"
        />
      </el-form-item>
      <el-form-item >
        <el-select v-model="form_t.via_id" placeholder="Seleccione una opcion" style="width:300px" clearable>
          <el-option
            v-for="item in opt_via"
            :key="item.via_id"
            :label="item.via_descripcion"
            :value="item.via_id"
          > </el-option>
        </el-select> 
      </el-form-item>
    </div>

    <div v-if='form_t.afi=="2" '>
      <el-form-item  label="Vehiculo ">
        <el-select
          v-model="form_t.veh_id"
          filterable
          :remote-method="get_vehiculos"
          placeholder="Inserte ID de vehiculo"
          remote
          clearable
          @change="veh_changer"
          style="width:300px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in opt_veh"
            :key="item.veh_id"
            :label="item.veh_placa"
            :value="item.veh_id"
          />
        </el-select>
      </el-form-item>
      <el-form-item >
        <el-row style="width:300px">
          <el-input v-model="form_t.tipo" placeholder="Tipo" disabled/>
        </el-row> 
      </el-form-item>
    </div>
  </el-form>
</modal>


<modal ref="mo_advertencia_eliim" title="Confirmar" centered @ok="send_delete" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="../styles/internal.css">

</style>
