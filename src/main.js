import {createApp} from 'vue'
import {createStore} from 'vuex'
import {createRouter, createWebHashHistory} from 'vue-router'
import ElementPlus from 'element-plus'
import es from 'element-plus/es/locale/lang/es'
import 'element-plus/dist/index.css'

import App from './App.vue'
//import router from './router'

const store = createStore({
  state () {
    return {
      authenticated: false,
      Account: {
        username: "admin",
        password: "123",
      }
    }
  },
  mutations: {
    authenticate(state) {
      state.authenticated=true;
    },
    deauthenticate(state) {
      state.authenticated=false;
    }
  },
  actions: {
    authenticate (context) {
      context.commit('authenticate')
    }
  }
  
})

const router = createRouter({
  history: createWebHashHistory(),
  //history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: {
        name: "Usuarios"
      }
    },
    {
      path: '/login',
      name: 'login',

      component: () => import('./views/Login.vue')
    },
    {
      path: '/t_inter',
      name: 'Test interface',
      component: () => import('./views/Testinterface.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/personal',
      name: 'Personal',
      component: () => import('./views/Base_datos/Personal.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/proveedores',
      name: 'Proveedores',
      component: () => import('./views/Base_datos/Proveedores.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/clientes',
      name: 'Clientes',
      component: () => import('./views/Base_datos/Clientes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/vehiculos',
      name: 'Vehiculos',
      component: () => import('./views/Base_datos/Vehiculos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/doc_personal',
      name: 'PermisosPersonal',
      component: () => import('./views/Documentos/Personal.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/doc_vehiculos',
      name: 'PermisosVehiculos',
      component: () => import('./views/Documentos/Vehiculos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/planificacion',
      name: 'Planificacion',
      component: () => import('./views/Planificacion.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_combustible',
      name: 'Combustible',
      component: () => import('./views/Operaciones/Combustible.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_viaticos',
      name: 'Viaticos',
      component: () => import('./views/Operaciones/Viaticos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_personal',
      name: 'Pagos personal',
      component: () => import('./views/Operaciones/Choferes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_pago',
      name: 'Pagos ',
      component: () => import('./views/Operaciones/Pago.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_rendicion_cuentas',
      name: 'Rendición de cuentas ',
      component: () => import('./views/Operaciones/Rendicion_cuentas.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/operaciones_compras',
      name: 'Agregar compra',
      component: () => import('./views/Operaciones/Compras.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/facturacion_guias',
      name: 'Guias',
      component: () => import('./views/Facturacion/Guias.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },

    {
      path: '/facturacion_comprobantes',
      name: 'Comprobantes',
      component: () => import('./views/Facturacion/Comprobantes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    
    {
      path: '/facturacion_cobranza',
      name: 'Cobranza',
      component: () => import('./views/Facturacion/Cobranza.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },

    {
      path: '/disposicion_dinero',
      name: 'Disposicion de dinero',
      component: () => import('./views/Disposicion_dinero.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
    {
      path: '/inicio',
      name: 'Usuarios',
      component: () => import('./views/Usuarios.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.authenticated == false) {
          next(false);
        } else {
          next();
        }
      }
    },
  ]
})


const app = createApp(App)

app.use(store)
app.use(router)

app.use(ElementPlus, {
  locale: es,
})

app.mount('#app')
