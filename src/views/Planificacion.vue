<script lang="ts" setup>
import { reactive,ref } from 'vue'
import axios from 'axios'
import { EditPen, Filter, Plus, Download, CloseBold, List, Search, Flag} from '@element-plus/icons-vue'

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
  cliente_id: [{ 
      required: true,
      message: 'Por favor busque y seleccion un cliente',
      trigger: 'blur',
    },
  ],

  producto_tipo:[{ 
      required: true,
      message: 'Por favor seleccione un tipo de producto',
      trigger: 'change',
    },
  ],
  flete:[{ 
      required: true,
      message: 'Por favor seleccione un tipo de flete',
      trigger: 'change',
    },
  ],
  subtotal:[{ 
      required: true,
      message: 'Monto requerido',
      trigger: 'change',
    },
  ],
  impuesto:[{ 
      required: true,
      message: 'Monto requerido',
      trigger: 'change',
    },
  ],
  total:[{ 
      required: true,
      message: 'Monto requerido',
      trigger: 'change',
    },
  ],

  fecha:[{ 
      required: true,
      message: 'Fecha requerida',
      trigger: 'change',
    },
  ],

  origen:[{ 
      required: true,
      message: 'Campo obligatorio',
      trigger: 'blur',
    },
  ],

  destino:[{ 
      required: true,
      message: 'Campo obligatorio',
      trigger: 'blur',
    },
  ],

  tracto:[{ 
      required: true,
      message: 'Campo obligatorio',
      trigger: 'blur',
    },
  ],

  conductor:[{ 
      required: true,
      message: 'Campo obligatorio',
      trigger: 'blur',
    },
  ],

})
</script>

<script lang="ts">
import modal from "../components/modal.vue"
export default {
  components: {
    modal
  },
  data(){
    return {
      editpointer:0,
      succes: false,
      operarios_id:[2,4],
      datap: [],
      opt_rs: [],
      opt_flete: [],

      stop_cliente: true,
      stop_con: true,

      via_estado: '',

      opt_mar:[],
      opt_mod:[],
      opt_cla:[],
      opt_ti:[],
      opt_estados:[],

      data_edit: [],
      data_edit2: [],
      data_ubi:[],
      data_clis:[],
      data_prods:[],
      data_op:[],
      data_vh1:[],
      data_vh2:[],

      wait:false,
      wait2:false,
      open_op:false,
      aux1:true,

      alert_mo:'',
      id_tmp:-1,
      emp_cont:'1',

      form_b : reactive({
        rs: '',
        placa: '',
        fecha_i: '',
        fecha_f: '',
        origen:'',
        destino:''
      }),

      form_c : reactive({
        rs: '',
        ruta: '',
        semirremolque: '',
        cliente_id: '',
        cliente_nom: '',
        producto_tipo: '',
        observacion: '',
        flete: '',
        subtotal: 0,
        igv: 18,
        impuesto: 0,
        total: 0,
        fecha: '',
        hora: '',
        f_h: '',
        origen: '',
        destino: '',
        semire_id: '',
        tracto_id: '',
        oper_id: '',
        oper_nom:'',
        cantidad_flete:'',

      }),

      form_e : reactive({
        rs: '',
        ruta: '',
        semirremolque: '',
        cliente_id: '',
        cliente_nom: '',
        producto_tipo: '',
        observacion: '',
        flete: '',
        subtotal: 0,
        igv: 18,
        impuesto: 0,
        total: 0,
        fecha: '',
        hora: '',
        f_h: '',
        origen: '',
        destino: '',
        semire_id: '',
        tracto_id: '',
        oper_id: '',
        oper_nom:'',
        cantidad_flete:'',
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
      this.form_c.cliente_id="";
      this.form_c.cliente_nom="";
      this.form_c.producto_tipo="";
      this.form_c.observacion="";
      this.form_c.semire_id="";
      this.form_c.tracto_id="";
      this.form_c.oper_id="";
      this.form_c.oper_nom="";
      this.data_clis=[];
      this.data_op=[];
      if(this.form_c.rs!="") {
        this.stop_cliente=false;
      }
      //cargar listas
      this.load_flete();
      this.data_prods=[];
    },
    rs_changer2() {
      this.emp_cont=this.form_e.rs;
      this.form_e.cliente_id="";
      this.form_e.cliente_nom="";
      this.form_e.producto_tipo="";
      this.form_e.observacion="";
      this.form_e.semire_id="";
      this.form_e.tracto_id="";
      this.form_e.oper_id="";
      this.form_e.oper_nom="";
      this.data_clis=[];
      this.data_op=[];
      if(this.form_e.rs!="") {
        this.stop_cliente=false;
      }
      //cargar listas
      this.load_flete();
    },

    open_succes(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado.open(); 
    },

    open_error_estado() {
      this.$refs.mo_advertencia_edicion.open(); 
    },

    close_error_estado() {
      this.$refs.mo_advertencia_edicion.hide(); 
    },

    open_succes_estado(msg) {
      this.alert_mo=msg;
      this.$refs.mo_realizado_estado.open(); 
    },

    close_succes_estado() {
      this.$refs.mo_realizado_estado.hide(); 
      this.$refs.mo_estado.hide();
      this.api_get_all();
      this.via_estado="";
    },

    close_succes_estado2() {
      this.$refs.mo_realizado_estado.hide(); 
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
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/"+String(id))
        .then((resp) => {
          console.log(resp);
          this.data_edit = resp.data;
        }) 
    },

    load_flete() {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/flete")
        .then((resp) => {
          console.log(resp);
          this.opt_flete = resp.data;
        })   
    },

    load_prod() {
      axios
      .get('http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/'+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.data_prods = resp.data;
        })
    },

    get_descargas(uri, name) {
      var link = document.createElement("a");
      link.download = name;
      link.href = uri;
      link.click();
    },

    send_descarga() {
      axios
        .post('http://51.222.25.71:8080/garcal-report-api/api/viajescsv')
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.get_descargas(resp.data.message,'Reporte_planificacion')
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

    get_productos(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/productos/buscarnombre" ,
      {
        "emp_id":this.emp_cont,
        "ent_nrodocumento":query,
      })
        .then((resp) => {
          console.log(resp);
          this.data_prods = resp.data;
        })
    },

    get_ubigeos(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/ubigeo" ,
      {
        "ubi_nombre":query,
      })
      .then((resp) => {
        console.log(resp);
        this.data_ubi = resp.data;
      })
    },

    get_clientes(query) {
      console.log(query);
      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/buscarentidadnumero', 
      {
        "emp_id": Number(this.emp_cont),
        "ent_nrodocumento": query,
        "ext_id": "cli"
      })
        .then((resp) => {
          console.log(resp);
          this.data_clis = resp.data;
        })
    },
    
    select_clientes(idx) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/" + String(idx),
      {
        "emp_id":Number(this.emp_cont),
        "ext_id":"cli"
      })
        .then((resp) => {
          console.log(resp.data[0]);
          if (resp.data[0]) {
            this.form_c.cliente_nom= String(resp.data[0].ent_nombre);
            this.data_clis=[];
            return;
          }
          else {
            return "No name";
          }
        })
    },

    get_estados() {
      axios
      .get("http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesestados/"+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_estados = resp.data;
        })
    },

    set_estados() {
      axios
      .get("http://51.222.25.71:8080/garcal-erp-apiv1/api/viajesestados/"+String(this.emp_cont))
        .then((resp) => {
          console.log(resp);
          this.opt_estados = resp.data;
        })
    },

    clear_clientes() {
      this.form_c.cliente_nom= "";
    },

    select_clientes2(idx) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/entidad/" + String(idx),
      {
        "emp_id":this.form_e.rs,
        "ext_id":"cli"
      })
        .then((resp) => {
          console.log(resp.data[0]);
          if (resp.data[0]) {
            this.form_e.cliente_nom= String(resp.data[0].ent_nombre);
            this.data_clis=[];
            return;
          }
          else {
            return "No name";
          }
        })
    },

    clear_clientes2() {
      this.form_e.cliente_nom= "";
    },

    clear_operarios() {
      this.form_c.oper_nom= "";
    },
    clear_operarios2() {
      this.form_e.cliente_nom= "";
    },

    get_operarios(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacionpendientesviajes" ,
      {
        "emp_id": this.emp_cont,
        "tra_nrodocumento":query,
        "tri_licencianro":"",
        "tra_nombre":"",
        "via_fechaviaje":this.form_c.fecha,
        "via_horaviaje":this.form_c.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_op = resp.data;
        })
    },

    get_operarios2(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/tripulacionpendientesviajes" ,
      {
        "emp_id": this.emp_cont,
        "tra_nrodocumento":query,
        "tri_licencianro":"",
        "tra_nombre":"",
        "via_fechaviaje":this.form_e.fecha,
        "via_horaviaje":this.form_e.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_op = resp.data;
        })
    },

    select_operarios(idx) {
      for (let tmp in this.data_op)  {
          console.log(tmp);
          if (this.data_op[tmp].tri_id == idx) {
            this.form_c.oper_nom= this.data_op[tmp].tra_nombre;
            this.data_op=[];
            return;
          }
        }
    },

    select_operarios3(idx) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/trabajadores/"+String(idx))
        .then((resp) => {
          console.log(resp);
          if (resp.data[0]) {
            this.form_e.oper_nom= String(resp.data[0].tra_nombre);
          }
          else {
            this.form_e.oper_nom= "No name";
          }
        })
    },

    select_operarios2(idx) {
      this.get_operarios2("");
      setTimeout( ()  => {
        for (let tmp in this.data_op)  {
          console.log(tmp);
          if (this.data_op[tmp].tri_id == idx) {
            this.form_e.oper_nom= this.data_op[tmp].tra_nombre;
            this.data_op=[];
            return;
          }
        }
        
      } ,600)

    },

    get_vehiculo1(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculospendientesviajes" ,
      {
        "emp_id": this.form_c.rs,
        "veh_placa":query,
        "vcl_id":"TRA",
        "via_fechaviaje":this.form_c.fecha,
        "via_horaviaje":this.form_c.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_vh1 = resp.data;
        })
    },

    get_vehiculo12(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculospendientesviajes" ,
      {
        "emp_id": this.form_e.rs,
        "veh_placa":query,
        "vcl_id":"TRA",
        "via_fechaviaje":this.form_e.fecha,
        "via_horaviaje":this.form_e.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_vh1 = resp.data;
        })
    },

    get_vehiculo2(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculospendientesviajes" ,
      {
        "emp_id": this.form_c.rs,
        "veh_placa":query,
        "vcl_id":"SEM",
        "via_fechaviaje":this.form_c.fecha,
        "via_horaviaje":this.form_c.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_vh2 = resp.data;
        })
    },

    get_vehiculo22(query) {
      console.log(query);
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/vehiculospendientesviajes" ,
      {
        "emp_id": this.form_e.rs,
        "veh_placa":query,
        "vcl_id":"SEM",
        "via_fechaviaje":this.form_e.fecha,
        "via_horaviaje":this.form_e.hora
      })
        .then((resp) => {
          console.log(resp);
          this.data_vh2 = resp.data;
        })
    },

    send_delete() {
      this.$refs.mo_advertencia_eliim.hide();
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/borrar/'+String(this.editpointer))
        .then((resp) => {
          console.log(resp.data);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes("Viaje eliminado correctamente");
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
      this.load_flete();


      this.form_e.subtotal=this.data_edit[0].via_subtotal;
      this.form_e.rs =this.data_edit[0].emp_id;
      this.form_e.ruta =this.data_edit[0].rut_id;
      this.form_e.tracto_id =this.data_edit[0].veh_idtracto;
      this.form_e.semire_id =this.data_edit[0].veh_idremolque;
      this.form_e.cliente_id =this.data_edit[0].ent_id;
      this.form_e.fecha =this.data_edit[0].via_fechaviaje;
      this.form_e.hora =this.data_edit[0].via_horaviaje;
      this.form_e.subtotal =this.data_edit[0].via_subtotal;
      this.form_e.impuesto =this.data_edit[0].via_impuesto;
      this.form_e.total =this.data_edit[0].via_total;
      this.form_e.observacion =this.data_edit[0].via_observacion;
      this.form_e.origen =this.data_edit[0].ubi_codigoorigen;
      this.form_e.destino =this.data_edit[0].ubi_codigodestino;
      this.form_e.flete =this.data_edit[0].vfl_codigo;
      this.form_e.producto_tipo =this.data_edit[0].pro_id;
      this.form_e.oper_id =this.data_edit[0].tri_id;

      this.select_clientes2(this.data_edit[0].ent_id);
      this.get_clientes(this.form_e.cliente_nom);

      this.get_productos("");
      this.get_clientes("");
      this.get_vehiculo12("");
      this.get_vehiculo22("");
      this.get_operarios2("");
      this.select_operarios2(this.form_e.oper_id);
    },

    get_estado(id) {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/codigo/"+String(id))
      .then((resp) => {
        console.log(resp);
        this.via_estado= resp.data[0].vie_codigo;
      })
    },

    set_estado() {
      axios
      .post("http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/actualizarcodigo" ,
      {
        "via_id":this.editpointer,
        "vie_codigo":this.via_estado
      })
      .then((resp) => {
        console.log(resp.data);
        this.succes=resp.data.status;
        if (this.succes) {
          this.open_succes_estado("Estado actualizado correctamente");
          return true;
        }
        else {
          this.open_fail("Hubo un error con el servidor al ejecutar la operación");
          return false;
        }
        
      })
    },

    api_get_all(){
      //llamada a API
      const tiempoTranscurrido = Date.now();
      const hoy = new Date(tiempoTranscurrido);

      var mm=hoy.getMonth() + 1;
      var aa=hoy.getFullYear();
      var dd=hoy.getDate();

      var fech=aa+"-"+mm+"-"+dd;
      var fech2=aa+"-"+mm+"-01";

      console.log(aa+mm+dd);

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes', 
      {
        "emp_id":"",
        "via_fechaviajeinicio":fech2,
        "via_fechaviajefin":fech,
        "veh_placa":"",
        "ubi_nombreorigen":"",
        "ubi_nombredestino":"",
      })
      .then((resp) => {
        console.log(resp);
        this.datap = resp.data;
        console.log(this.datap);
      })
    },

    api_get_filt(){
      console.log(this.form_b.rs);
      axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes', 
        {
          "emp_id":String(this.form_b.rs),
          "via_fechaviajeinicio":String(this.form_b.fecha_i),
          "via_fechaviajefin":String(this.form_b.fecha_f),
          "veh_placa":this.form_b.placa,
          "ubi_nombreorigen":this.form_b.origen,
          "ubi_nombredestino":this.form_b.destino,
        })
        .then((resp) => {
          console.log(resp);
          this.datap = resp.data;
        })
    },
    
    create_usr(){
      //llamada a API

      axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/nuevo', 
      { 
        "emp_id": Number(this.form_c.rs),
        "rut_id":"",
        "via_serie":"", 
        "via_numero":"", 
        "vie_codigo":"PLA",
        "veh_idtracto":Number(this.form_c.tracto_id),
        "veh_idremolque":this.form_c.semire_id,
        "ent_id":Number(this.form_c.cliente_id),
        "via_fechaviaje":this.form_c.fecha,
        "via_horaviaje":this.form_c.hora,
        "via_subtotal":Number(this.form_c.subtotal),
        "via_impuesto":Number(this.form_c.impuesto),
        "via_total":Number(this.form_c.total),
        "via_observacion":this.form_c.observacion,
        "ubi_codigoorigen":this.form_c.origen,
        "ubi_codigodestino":this.form_c.destino,
        "vfl_codigo":this.form_c.flete,
        "tri_id":this.form_c.oper_id,
        "pro_id":Number(this.form_c.producto_tipo),
        "via_usucreacion":"admin",
        "via_cantidad":Number(this.form_c.cantidad_flete)
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
    },  

    close_create() {
      this.$refs.form_create_ref.resetFields();
      this.$refs.mo_create_per.hide(); 
    },

    editar_usr(){
      //llamada a API
    
    axios
      .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/viajes/actualizar', 
      { 
        "via_id":this.editpointer,
        "emp_id":Number(this.form_e.rs),
        "rut_id":"",
        "veh_idtracto":Number(this.form_e.tracto_id),
        "veh_idremolque":this.form_e.semire_id,
        "ent_id":Number(this.form_e.cliente_id),
        "via_serie":"",
        "via_numero":"",
        "via_fechaviaje":this.form_e.fecha,
        "via_horaviaje":this.form_e.hora,
        "via_subtotal":Number(this.form_e.subtotal),
        "via_impuesto":Number(this.form_e.impuesto),
        "via_total":Number(this.form_e.total),
        "via_observacion":this.form_e.observacion,
        "via_usumodificacion":"admin",
        "vie_codigo":"TER",
        "ubi_codigoorigen":this.form_e.origen,
        "ubi_codigodestino":this.form_e.destino,
        "vfl_codigo":this.form_e.flete,
        "pro_id":Number(this.form_e.producto_tipo),
        "tri_id":this.form_e.oper_id,
        "via_cantidad":Number(this.form_e.cantidad_flete)
      })
        .then((resp) => {
          console.log(resp.data.status);
          this.succes=resp.data.status;
          if (this.succes) {
            this.open_succes_ed("Viaje modificado satisfactoriamente");
          }
          else {
            this.open_fail("Hubo un error al comunicarse con el servidor");
          }
          console.log(resp);
        })
        return false;
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
      this.form_c.impuesto=String(this.roundUp((Number(this.form_c.igv)/100)*Number(this.form_c.subtotal),1));
      this.form_c.total=String(Number(this.form_c.impuesto)+Number(this.form_c.subtotal));
    },
    calcular2() {
      var aux=Number(this.form_c.total)/(100+Number(this.form_c.igv));
      this.form_c.impuesto=String(this.roundUp(aux*Number(this.form_c.igv),1));
      this.form_c.subtotal=String(this.roundDwn(aux*100,1));
    },

    button_handle(number){
      console.log(number);
      this.clear_eop;
      this.editpointer=number;
      this.get_estado(number);
      setTimeout(() => {

        if(this.via_estado=="TER") {
          console.log("si entre");
          this.open_error_estado();
          return;
        }
        console.log("si pase");
        this.$refs.mo_editar_per.open();
        this.wait = true;
        this.load_edit(number);
        
        setTimeout(() => {
          this.load_data_edit();
          this.emp_cont=this.form_e.rs;
          this.wait = false;
        }, 400)
      }, 600)


      
    },

    button_handle2(number){
      console.log(number);
      this.editpointer=number;
      this.get_estados();
      this.get_estado(number);
      setTimeout(() => {
        this.$refs.mo_estado.open();
      }, 800)
      
    }
  },
  

  mounted () {
    //llamada a API
    this.api_get_all();
    this.load_rs();
    this.load_flete();
    //this.load_tc();
    //this.load_pues();
    //this.load_esp();
  },
}

</script>


<template>
 
  <el-form :inline="true" :model="formInline" label-width="auto" :size="small" >
    <el-row>
      <el-col :span="21">
        
        <el-form-item label="Razón social">
            <el-select v-model="form_b.rs" @change="search_rs_ch" @clear="search_rs_clear" placeholder="Seleccionar" clearable>
              <el-option
                v-for="item in opt_rs"
                :key="item.emp_id"
                :label="item.emp_razonsocial"
                :value="item.emp_id"
              > </el-option>
            </el-select>
          </el-form-item>

        <el-form-item label="Origen" clearable>
          <el-input v-model='form_b.origen'/>
        </el-form-item>
        <el-form-item label="Destino" clearable>
          <el-input v-model='form_b.destino'/>
        </el-form-item>

        <el-form-item label="Fecha de viaje:" clearable>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_i"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              type="date"
              placeholder="Seleccionar limite inicial"
              style="width: 100%"
            />
          </el-col>
          <el-col :span="2" class="text-center">
            <span class="text-gray-500">-</span>
          </el-col>
          <el-col :span="11">
            <el-date-picker
              v-model="form_b.fecha_f"
              format="YYYY-MM-DD"
              value-format="YYYY-MM-DD"
              type="date"
              placeholder="Seleccionar limite final"
              style="width: 100%"
            />
          </el-col>

        </el-form-item>

        <el-form-item label="Placa" clearable>
          <el-input v-model="form_b.placa" />
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
          <el-button color="#95d475" :icon=" Download" @click="send_descarga">A Excel</el-button>
        </el-row>
        </div>  
      </el-col>
    </el-row>
      
    </el-form>

  <div class="table-container">
  <el-table :data="datap" border header-row-style="color:black;" >
      <el-table-column prop="emp_razonsocial" label="Razon soc. asoc. " width="140" align="center"/>
      <el-table-column prop="via_ordenservicio" label="Nro. de servicio" width="135" align="center"/>
      <el-table-column prop="vie_nombre" label="Estado de serv." width="130" align="center"/>
      <el-table-column prop="via_fechaviaje" label="Fecha de programada" width="180" />
      <el-table-column prop="ubi_nombreorigen" label="Punto de partida" width="140" align="center"/>
      <el-table-column prop="veh_conductor" label="Conductor" width="150"/>
      <el-table-column prop="tri_licencianro" label="Licencia nro." width="140" align="center" />
      <el-table-column prop="veh_tracto" label="Placa de Tracto" width="130" align="center"/>
      <el-table-column prop="veh_semiremolque" label="Placa de Acople" width="140" align="center"/>
      <el-table-column prop="ubi_nombredestino" label="Destino" width="140" align="center"/>

      <el-table-column prop="via_horaviaje" label="Hora de viaje" width="130" />              
      <el-table-column prop="vfl_nombre" label="Flete" width="140"/>

      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle2(scope.row.via_id)" size="small"><el-icon :size="17"><Flag /></el-icon></el-button>
        </template>
      </el-table-column>

      <el-table-column fixed="right" label="" width="45" align="center">
        <template #default="scope">
          <el-button  type="text"  @click="button_handle(scope.row.via_id)" size="small"><el-icon :size="17"><EditPen /></el-icon></el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>



<modal ref="mo_create_per" no-close-on-backdrop title="Nro. de orden de servicio" width="900px" @ok="create_usr" @cancel="closecrear" cancel-title="Atras" centered>
  <el-form  ref="form_cref" :rules="rules" :model="form_c" label-width="150px" >
    <el-row style="text-align:center">
    <el-form-item style="margin-left: auto;margin-right: auto" label="Razón soc. asoc." prop="rs">
      <el-select  v-model="form_c.rs" @change="rs_changer()" placeholder="Seleccionar">
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
    <el-col :span="12">
      
      <el-form-item  label="Cliente " prop="cliente_id">
        <el-select
          v-model="form_c.cliente_id"
          filterable
          :remote-method="get_clientes"
          @change="select_clientes"
          @clear="clear_clientes"
          placeholder="Inserte ID de cliente"
          remote
          clearable
          style="width:250px"
          :disabled="stop_cliente"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_clis"
            :key="item.ent_id"
            :label="item.ent_nrodocumento"
            :value="item.ent_id"
          />
        </el-select>
        <el-input style="width:250px" disabled v-model="form_c.cliente_nom" placeholder="Nombre de cliente"/>
      </el-form-item>

      <el-form-item  label="Producto " prop="producto_tipo">
        <el-select
          v-model="form_c.producto_tipo"
          filterable
          :remote-method="get_productos"
          placeholder="Tipo de producto"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_prods"
            :key="item.pro_id"
            :label="item.pro_descripcion"
            :value="item.pro_id"
          />
        </el-select>
        
      </el-form-item>

      <el-form-item  label="Flete " prop="flete">
        <el-select style="width:150px" v-model="form_c.flete" placeholder="Seleccionar">
          <el-option
            v-for="item in opt_flete"
            :key="item.vfl_codigo"
            :label="item.vfl_nombre"
            :value="item.vfl_codigo"
          > </el-option>
        </el-select>
        <el-input placeholder="Cantidad" style="width:100px" v-model="form_c.cantidad_flete"/>
      </el-form-item>

      <el-form-item label="Subtotal" prop="subtotal">
        
        <el-input style="width:250px" v-model="form_c.subtotal">
          <template #append>
            <el-button @click="calcular1()"><img width="15" height="15" src = "../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>

      <el-form-item label="Impuesto" prop="impuesto">
        <el-input style="width:190px" v-model="form_c.impuesto">
          <template #prepend>S/</template>
        </el-input>
        <el-input style="width:60px" v-model="form_c.igv">
          <template #suffix>%</template>
        </el-input>

      </el-form-item>
      
      <el-form-item label="Total" prop="total">
        <el-input style="width:250px" v-model="form_c.total">
          <template #append>
            <el-button  @click="calcular2()" ><img width="15" height="15" src = "../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>

    </el-col>
    <el-col :span="12">

      <el-form-item label="Fecha y hora " prop="fecha">
        <el-date-picker
            v-model="form_c.fecha"
            type="date"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Fecha"
            style="width: 125px"
          />
          <el-time-picker
            v-model="form_c.hora"
            placeholder="Hora"
            format="hh:mm a"
            value-format="HH:mm:ss"
            style="width: 125px"
          />
      </el-form-item>

      <el-form-item  label="Partida " prop="origen">
        <el-select label="Ruta"
          v-model="form_c.origen"
          filterable
          :remote-method="get_ubigeos"
          placeholder="Punto de partida"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_ubi"
            :key="item.ubi_codigo"
            :label="item.ubi_nombre"
            :value="item.ubi_codigo"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="Destino" prop="destino">
        <el-select 
          v-model="form_c.destino"
          filterable
          :remote-method="get_ubigeos"
          placeholder="Punto de destino"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_ubi"
            :key="item.ubi_codigo"
            :label="item.ubi_nombre"
            :value="item.ubi_codigo"
          />
        </el-select>
      </el-form-item>

      <el-form-item  label="Tracto " prop="tracto">
        <el-select
          v-model="form_c.tracto_id"
          filterable
          :remote-method="get_vehiculo1"
          placeholder="Inserte ID de tracto"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_vh1"
            :key="item.veh_id"
            :label="item.veh_placa"
            :value="item.veh_id"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="Acople ">
        <el-select
          v-model="form_c.semire_id"
          filterable
          :remote-method="get_vehiculo2"
          placeholder="Inserte placa de semirremolque"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_vh2"
            :key="item.veh_id"
            :label="item.veh_placa"
            :value="item.veh_id"
          />
        </el-select>
      </el-form-item>

      <el-form-item  label="Conductor " prop="conductor">
        <el-select
          v-model="form_c.oper_id"
          filterable
          :remote-method="get_operarios"
          @change="select_operarios"
          @clear="clear_operarios"
          placeholder="Inserte ID de conductor"
          remote
          clearable
          :disabled="stop_conductor"
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_op"
            :key="item.tra_nrodocumento"
            :label="item.tra_nrodocumento"
            :value="item.tri_id"
          />
        </el-select>
        <el-input style="width:250px" disabled v-model="form_c.oper_nom" placeholder="Nombre de conductor"/>
      </el-form-item>
    </el-col>
    </el-row>
    <el-row style="text-align=center" >
      <el-form-item label="Observacion">
        <el-input 
          style="width:700px" 
          v-model="form_c.observacion" 
          placeholder="Observacion"
        />
      </el-form-item>
    </el-row>
  </el-form>
</modal>

<modal ref="mo_editar_per" no-close-on-backdrop title="Editar Viaje" width="900px" @ok="editar_usr" cancel-title="Cancelar" @cancel="closeedit"  centered>
   <el-form  ref="form_cref" :rules="rules" :model="form_e" label-width="150px" >
    <el-row style="text-align:center">
    <el-form-item style="margin-left: auto;margin-right: auto" label="Razón soc. asoc." prop="rs">
      <el-select  v-model="form_e.rs" @change="rs_changer2()" placeholder="Seleccionar">
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
    <el-col :span="12">
      
      <el-form-item  label="Cliente " prop="cliente_id">
        <el-select
          v-model="form_e.cliente_id"
          filterable
          :remote-method="get_clientes"
          @change="select_clientes"
          placeholder="Inserte ID de cliente"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_clis"
            :key="item.ent_id"
            :label="item.ent_nrodocumento"
            :value="item.ent_id"
          />
        </el-select>
        <el-input style="width:250px" disabled v-model="form_e.cliente_nom" placeholder="Nombre de cliente"/>
      </el-form-item>

      <el-form-item  label="Producto " prop="producto_tipo">
        <el-select
          v-model="form_e.producto_tipo"
          filterable
          :remote-method="get_productos"
          placeholder="Tipo de producto"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_prods"
            :key="item.pro_id"
            :label="item.pro_descripcion"
            :value="item.pro_id"
          />
        </el-select>
        
      </el-form-item>

      <el-form-item  label="Flete " prop="flete">
        <el-select style="width:150px" v-model="form_e.flete" placeholder="Seleccionar">
          <el-option
            v-for="item in opt_flete"
            :key="item.vfl_codigo"
            :label="item.vfl_nombre"
            :value="item.vfl_codigo"
          > </el-option>
        </el-select>
        <el-input placeholder="Cantidad" style="width:100px" v-model="form_e.cantidad_flete"/>
      </el-form-item>

      <el-form-item label="Subtotal" prop="subtotal">
        
        <el-input style="width:250px" v-model="form_e.subtotal">
          <template #append>
            <el-button @click="calcular1()"><img width="15" height="15" src = "../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>

      <el-form-item label="Impuesto" prop="impuesto">
        <el-input style="width:190px" v-model="form_e.impuesto">
          <template #prepend>S/</template>
        </el-input>
        <el-input style="width:60px" v-model="form_e.igv">
          <template #suffix>%</template>
        </el-input>

      </el-form-item>
      
      <el-form-item label="Total" prop="total">
        <el-input style="width:250px" v-model="form_e.total">
          <template #append>
            <el-button  @click="calcular2()"><img width="15" height="15" src = "../components/calculadora.svg"/> </el-button>
          </template>
          <template #prepend>S/</template>
        </el-input>
      </el-form-item>

    </el-col>
    <el-col :span="12">

      <el-form-item label="Fecha y hora " prop="fecha">
        <el-date-picker
            v-model="form_e.fecha"
            type="date"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            placeholder="Fecha"
            style="width: 125px"
          />
          <el-time-picker
            v-model="form_e.hora"
            placeholder="Hora"
            format="hh:mm a"
            value-format="HH:mm:ss"
            style="width: 125px"
          />
      </el-form-item>

      <el-form-item  label="Origen "  prop="origen">
        <el-select label="Ruta"
          v-model="form_e.origen"
          filterable
          :remote-method="get_ubigeos"
          placeholder="Inserte origen"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_ubi"
            :key="item.ubi_codigo"
            :label="item.ubi_nombre"
            :value="item.ubi_codigo"
          />
        </el-select>
      </el-form-item>

      <el-form-item label="Destino"  prop="destino">
        <el-select 
          v-model="form_e.destino"
          filterable
          :remote-method="get_ubigeos"
          placeholder="Inserte origen"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>

          <el-option
            v-for="item in data_ubi"
            :key="item.ubi_codigo"
            :label="item.ubi_nombre"
            :value="item.ubi_codigo"
          />
        </el-select>
      </el-form-item>

      <el-form-item  label="Tracto " prop="tracto">
        <el-select
          v-model="form_e.tracto_id"
          filterable
          :remote-method="get_vehiculo1"
          placeholder="Inserte ID de tracto"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_vh1"
            :key="item.veh_id"
            :label="item.veh_placa"
            :value="item.veh_id"
          />
        </el-select>
      </el-form-item>

      <el-form-item disabled="aux1" label="Acople " >
        <el-select
          v-model="form_e.semire_id"
          filterable
          :remote-method="get_vehiculo2"
          placeholder="Inserte placa de semirremolque"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_vh2"
            :key="item.veh_id"
            :label="item.veh_placa"
            :value="item.veh_id"
          />
        </el-select>
      </el-form-item>

      

      <el-form-item  label="Conductor " prop="conductor">
        <el-select
          v-model="form_e.oper_id"
          filterable
          :remote-method="get_operarios2"
          @change="select_operarios3"
          placeholder="Inserte ID de conductor"
          remote
          clearable
          style="width:250px"
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
          <el-option
            v-for="item in data_op"
            :key="item.tra_nrodocumento"
            :label="item.tra_nrodocumento"
            :value="item.tri_id"
          />
        </el-select>
        <el-input style="width:250px" disabled v-model="form_e.oper_nom" placeholder="Nombre de conductor"/>
      </el-form-item>

    </el-col>
    </el-row>

    <el-row style="text-align=center" >
      <el-form-item label="Observacion">
        <el-input 
          style="width:690px" 
          v-model="form_e.observacion" 
          placeholder="Observacion"
        />
      </el-form-item>
    </el-row>

    <el-row style="text-align=center" >
      <el-button style="margin-left: auto;margin-right: auto" color="#E21747" :icon="CloseBold" @click="open_confirmar('Realmente desea eliminar este viaje pendiente?')">Eliminar</el-button>
    </el-row>
  </el-form>
</modal>

<modal ref="mo_estado" no-close-on-backdrop title="Estado de viaje" width="500px" @ok="set_estado" cancel-title="Cancelar" @cancel="close_estado()"  centered>
   <el-form  ref="form_cref" :rules="rules" :model="form_e" label-width="150px" >
    <el-row style="text-align:center">
    <el-form-item style="margin-left: auto;margin-right: auto" label="Estado de viaje" >
      <el-select  v-model="via_estado" placeholder="Seleccionar">
        <el-option
          v-for="item in opt_estados"
          :key="item.vie_codigo"
          :label="item.vie_nombre"
          :value="item.vie_codigo"
        > </el-option>
      </el-select>
    </el-form-item> 
    </el-row>
   </el-form>
</modal>

<modal ref="mo_advertencia_eliim" title="Confirmar" centered @ok="send_delete" @cancel="close_confirmar" ok-title="Si" cancel-title="Cancelar" >
  {{alert_mo}}
</modal>

<modal ref="mo_advertencia_edicion" title="Acceso caducado" centered @cancel="close_error_estado" hide-ok cancel-title="Atras" >
  El viaje está registrado como terminado por ende ya no se puede modificar
</modal>

<modal ref="mo_realizado" success title="Operacion completada" centered @ok="close_succes_all" @cancel="close_succes" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_estado" success title="Operacion completada" centered @ok="close_succes_estado" @cancel="close_succes_estado2" ok-title="Cerrar" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_realizado_ed" hide-cancel success title="Operacion completada" centered @ok="close_succes_ed" cancel-title="Atras" >
  {{alert_mo}}
</modal>

<modal ref="mo_error"  hide-cancel error title="Error al ejecutar operación" centered @ok="close_fail">
  {{alert_mo}}
</modal>

</template>


<style scoped src="./styles/internal.css">

</style>
