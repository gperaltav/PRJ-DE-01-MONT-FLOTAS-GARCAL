<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, List,Search} from '@element-plus/icons-vue'

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
      datap: [],
      datav: [],
      opt_rs: [],
      opt_prv: [],
      opt_fp: [],
      opt_td:[],
      opt_via:[],

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
      }),

      form_c : reactive({

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
        marca:'',
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
      this.form_t.marca='';
      this.form_t.modelo='';
    },

    rs_changer() {
      this.emp_cont=this.form_g.rs;
      this.load_prod();

      
    },
    fech_changer() {
      //cargar listas
      this.get_viajes();
    },

    open_crear() {
      this.$refs.mo_create.open(); 
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

    load_rs() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/empresas')
        .then((resp) => {
          console.log(resp);
          this.opt_rs = resp.data;
        })
    },

    load_viajes() {
      
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesfecha', 
      {
        "emp_id": Number(this.form_c.rs),
        "gui_fechaemision": this.form_c.fecha_em,
        "gti_codigo": this.form_c.tipo_doc,
        "gui_serie": this.form_c.serie_doc,
        "gui_numero": this.form_c.nro_doc ,
        "via_id": Number(this.form_c.via_id),
        "gui_entdestinatario":"",
        "veh_id": 0,
        "veh_idacople":"",
        "pro_id":3,
        "gui_estado":"",
        "gui_peso":2,
        "ubi_codigoorigen":"010112",
        "ubi_codigodestino":"010113",
        "gui_observacion":"",
        "gui_usucreacion":"admin"
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
        if (this.opt_prv[tmp].pro_id == idx) {
          this.form_g.prod_nom  = this.opt_prv[tmp].pro_nombre;
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

    clear_proveedores() {
      this.form_c.prv_nom= "";
    },

    get_formas_pago() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/formasdepago/'+String(this.form_c.rs))
      .then((resp) => {
        console.log(resp);
        this.opt_fp = resp.data;
      })
    },

    get_tipos_doc() {
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/comprobantescomprastipos/'+String(this.form_c.rs))
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
          "ccd_serie":this.form_c.serie_doc,
          "ccd_cantidad":this.form_t.cantidad,
          "ccd_preciounitario":this.form_t.precio_u,
          "ccd_subtotal":this.form_c.subtotal,
          "uni_unidad":this.form_c.unidad
        }
      }
      if(this.form_t.afi=="2") {
        tmp={
          "pro_id":Number(this.form_t.prod),
          "via_id":"",
          "veh_id":Number(this.form_t.veh_id),
          "tra_id":"",
          "ccd_serie":this.form_c.serie_doc,
          "ccd_cantidad":this.form_t.cantidad,
          "ccd_preciounitario":this.form_t.precio_u,
          "ccd_subtotal":this.form_c.subtotal,
          "uni_unidad":this.form_c.unidad
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
        "emp_id": Number(this.form_c.rs),
        "ent_id": Number(this.form_c.prv_id),
        "ccc_serie": this.form_c.serie_doc,
        "ccc_numero": this.form_c.nro_doc,
        "ccc_fechaemision": this.form_c.fecha_em,
        "ccc_subtotal": Number(this.form_c.subtotal),
        "ccc_impuesto": Number(this.form_c.impuesto),
        "ccc_total": Number(this.form_c.total),
        "cct_codigo": this.form_c.tipo_doc,
        "cce_codigo": "CAN",
        "mon_codigo": "SOL",
        "ccc_observaciones": "",
        "ccc_idreferencia":"",
        "ccc_tipocambio": 18,
        "ccc_generamovimiento":false,
        "ccc_fechaingreso": fech,
        "ccc_periodoregistro": fech,
        "ccr_codigo":"PEA",
        "usu_codigo": "admin",
        "ccc_usucreacion":"admin",
        "detalle":[{
          "pro_id":"",
          "via_id":String(this.form_c.via_id),
          "veh_id":"",
          "tra_id":"",
          "ccd_serie":this.form_c.serie_doc,
          "ccd_cantidad":this.form_c.cantidad_n,
          "ccd_preciounitario":this.form_c.cantidad_p_uni,
          "ccd_subtotal":this.form_c.total,
          "uni_unidad":"UNI"
        }]
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes("Operación realizada satisfactoriamente");
          this.clear_c();
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
          Operaciones > Rendicion de cuentas
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
              <el-form-item style="margin-left:auto;margin-right:auto" label="Conductor">
                <el-row style="width:600px"> 
                <el-col :span="8">
                  <el-select
                    v-model="form_c.tra_id"
                    filterable
                    :remote-method="get_chofer"
                    @change="select_chofer"
                    @clear="clear_chofer"
                    placeholder="Inserte ID de conductor"
                    remote
                    clearable
                  >
                    <template #prefix>
                      <el-icon><Search /></el-icon>
                    </template>

                    <el-option
                      v-for="item in data_op"
                      :key="item.tra_nrodocumento"
                      :label="item.tra_nrodocumento"
                      :value="item.tra_id"
                    />
                  </el-select>
                </el-col>
                <el-col :span="16"><el-input disabled v-model="form_c.tra_nom" placeholder="Nombre del conductor" /></el-col>
                </el-row>
              </el-form-item>
            </el-row>

            <el-row style="width:800px; margin-left:auto; margin-right:auto"> 
              <el-form-item style="margin-left:auto;margin-right:auto" label="Salida de dinero">
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
              
            </el-form>

            <div >
              <el-container style="border-style: solid; border-color:grey">
                <el-header style="background-color:grey; height:40px">
                  Detalle
                </el-header>
                <el-main>
                  <div class="table-container">
                  <el-table :data="datav" border header-row-style="color:black;" >
                      <el-table-column prop='det_rs' label="Razon Soc." width="120" align="center" />
                      <el-table-column prop='det_td' label="Tipo de doc." width="120" align="center" />
                      <el-table-column prop='det_cod' label="Serie-Numero" width="120" align="center" />
                      <el-table-column prop="det_fecha_em" label="Fecha emision" width="140" align="center"/>
                      <el-table-column prop="det_cliente" label="Cliente" width="140" />
                      <el-table-column prop="det_subtotal" label="Subtotal"  />
                      <el-table-column prop="det_impuesto" label="Impuesto" />
                      <el-table-column prop="det_p_unitario" label="Precio unitario" />
                      <el-table-column prop="det_subtotal" label="Sub total"  align="center" />
                      <el-table-column fixed="right" label="" width="45" align="center">
                        <template #default="scope">
                          <el-button  type="text"  @click="button_handle(scope.row.cvc_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
                        </template>
                      </el-table-column>
                    </el-table>
                  </div>
                  <el-row style="text-align=center" >
                    <el-button color="#008db1" :icon="Plus"  @click="open_crear" style="margin-left: auto;margin-right: auto">Agregar</el-button>
                  </el-row>
                </el-main>
              </el-container>
              <el-row>
                <h3 style="margin-left:auto; margin-right:50px">Resumen: </h3>
              </el-row>
              
              <el-row>
              <el-form-item style="margin-left:auto; margin-right:50px" label="Total salida de dinero" prop="subtotal">
                <el-input style="width:250px" v-model="form_g.subtotal">
                  <template #prepend>S/</template>
                </el-input>
              </el-form-item>
              </el-row>

              <el-row>
              <el-form-item style="margin-left:auto; margin-right:50px" label="Total documentos" prop="subtotal">
                <el-input style="width:250px" v-model="form_g.subtotal">
                  <template #prepend>S/</template>
                </el-input>
              </el-form-item>
              </el-row>

              <el-row>
              <el-form-item style="margin-left:auto; margin-right:50px" label="TotaL" prop="subtotal">
                <el-input style="width:250px" v-model="form_g.subtotal">
                  <template #prepend>S/</template>
                </el-input>
              </el-form-item>
              </el-row>

            <el-row style="text-align=center" >
              <el-button color="#0844a4"  @click="transaccion_insertar" style="margin-left: auto;margin-right: auto">Guardar</el-button>
            </el-row>
            </div>
        </el-scrollbar>
      </el-main>
    </el-container>
  </el-container>

<modal ref="mo_create" no-close-on-backdrop title="Agregar Documento" width="900px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="200px" >
    <el-form-item  label="Razón social asociada">
      <el-select v-model="form_c.rs" @change="rs_changer" @clear="clear_c" placeholder="Seleccionar" style="width:600px" clearable>
        <el-option
            v-for="item in opt_rs"
            :key="item.emp_id"
            :label="item.emp_razonsocial"
            :value="item.emp_id"
        > </el-option>
      </el-select>
    </el-form-item>

  <el-form-item  label="Cliente">
    <el-row style="width:600px"> 
    <el-col :span="8">
    <el-select
      v-model="form_c.prv_id"
      filterable
      :remote-method="get_clientes"
      @change="select_clientes"
      @clear="clear_clientes"
      placeholder="Inserte ID de cliente"
      remote
      clearable
    >
      <template #prefix>
        <el-icon><Search /></el-icon>
      </template>

      <el-option
      v-for="item in opt_cli"
      :key="item.ent_id"
      :label="item.ent_nrodocumento"
      :value="item.ent_id"
      />
    </el-select>
    </el-col>
    <el-col :span="16"><el-input disabled v-model="form_c.prv_nom" placeholder="Nombre de cliente" /></el-col>
    </el-row>
  </el-form-item>

  
  <el-form-item label="Fecha de viaje">
      <el-row style="width:600px">
      <el-col :span="12">
      <el-date-picker
          type="date"
          v-model="form_c.fecha_via"
          format="YYYY-MM-DD"
          value-format="YYYY-MM-DD"
          placeholder="Seleccione fecha"
          style="width: 300px"
          @change="fech_changer"
      />
      </el-col>
      
      <el-col :span="12">
      <el-select v-model="form_c.via_id" placeholder="Seleccione una opcion" style="width:300px" clearable>
          <el-option
          v-for="item in opt_via"
          :key="item.via_id"
          :label="item.via_descripcion"
          :value="item.via_id"
          > </el-option>
      </el-select> 
      </el-col>
      </el-row>
  </el-form-item>

  <el-row style="width:800px; margin-bottom: 18px"> 
    <el-col :span="6">
    <el-select v-model="form_c.tipo_doc" style="width:150px; margin-left:50px" placeholder="Tipo de doc."  clearable>
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
        <el-input v-model="form_c.serie_doc" placeholder="nro de serie" />
      </el-col>
      <el-col :span="12">
        <el-input v-model="form_c.nro_doc" placeholder="nro de documento" />
      </el-col>
      </el-row>
    </el-col>

  </el-row>

  <el-form-item  label="Fecha de emisión">
      <el-date-picker
      type="date"
      v-model="form_c.fecha_em"
      format="YYYY-MM-DD"
      value-format="YYYY-MM-DD"
      placeholder="Seleccione fecha"
      style="width: 300px"
      />
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Valor venta">
      <div style="width:300px">
      <el-input v-model="form_c.subtotal" placeholder="Inserte una cantidad">
          <template #append>
          <el-button @click="calcular1()" ><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
      </el-input>
      </div>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Impuesto">
      <div style="width:240px">
      <el-input v-model="form_c.impuesto" placeholder="Inserte una cantidad">
          <template #prepend>S/</template>
      </el-input>
      </div>
      <el-input style="width:60px" v-model="form_c.igv">
      <template #suffix>%</template>
      </el-input>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Total">
      <div style="width:300px">
      <el-input v-model="form_c.total" placeholder="Inserte una cantidad">
          <template #append>
          <el-button  @click="calcular2()"><img style="fill:#797979" width="15" height="15" src = "../../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
      </el-input>
      </div>
  </el-form-item>

  <el-form-item style="margin-left: auto;margin-right: auto" label="Tipo de cobro">
      <el-select v-model="form_c.tipo_pago" placeholder="Seleccione una opcion" style="width:300px" clearable>
      <el-option
          v-for="item in opt_fp"
          :key="item.fdc_codigo"
          :label="item.fdc_descripcion"
          :value="item.fdc_codigo"
      > </el-option>
      </el-select>
  </el-form-item>
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


<style scoped src="../styles/basededatos.css">

</style>
