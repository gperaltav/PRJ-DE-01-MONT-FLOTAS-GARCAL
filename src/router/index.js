import { createRouter, createWebHistory } from 'vue-router'

import store from '@/store'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'inicio',
      component: () => import('../views/Inicio.vue'),
    },
    {
      path: '/demo',
      name: 'Test',
      component: () => import('../views/test.vue')
    },
    {
      path: '/usuarios',
      name: 'Adm. usuarios',
      component: () => import('../views/Usuarios.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[1]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/personal',
      name: 'Personal',
      component: () => import('../views/Base_datos/Personal.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[3]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/proveedores',
      name: 'Proveedores',
      component: () => import('../views/Base_datos/Proveedores.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[5]) {
          next();
          
        } else {
          next(false);
        }
      }

    },
    {
      path: '/clientes',
      name: 'Clientes',
      component: () => import('../views/Base_datos/Clientes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[2]) {
          next();
          
        } else {
          next(false);
        }
      }

    },
    {
      path: '/vehiculos',
      name: 'Vehiculos',
      component: () => import('../views/Base_datos/Vehiculos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[4]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/bienes_servicios',
      name: 'Bienes y servicios',
      component: () => import('../views/Base_datos/Productos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[6]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/ubigeos',
      name: 'Ubigeos',
      component: () => import('../views/Base_datos/Ubigeos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[7]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/tdoc_vehiculos',
      name: 'Tipos doc. Vehiculos',
      component: () => import('../views/Documentos/TiposDocV.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[8]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/tdoc_personal',
      name: 'Tipos doc. Personal',
      component: () => import('../views/Documentos/TiposDocP.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[9]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/doc_personal',
      name: 'PermisosPersonal',
      component: () => import('../views/Documentos/Personal.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[9]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/doc_vehiculos',
      name: 'PermisosVehiculos',
      component: () => import('../views/Documentos/Vehiculos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[8]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/planificacion',
      name: 'Planificacion',
      component: () => import('../views/Planificacion.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[10]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_combustible',
      name: 'Combustible',
      component: () => import('../views/Operaciones/Combustible.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[11]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_viaticos',
      name: 'Viaticos',
      component: () => import('../views/Operaciones/Viaticos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[12]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_personal',
      name: 'Pagos personal',
      component: () => import('../views/Operaciones/Choferes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[13]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_pago',
      name: 'Pagos ',
      component: () => import('../views/Operaciones/Pago.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[17]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_pagos_vista',
      name: 'Vista de pagos',
      component: () => import('../views/Operaciones/Pago_v.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[18]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/operaciones_rendicion_cuentas',
      name: 'Rendición de cuentas ',
      component: () => import('../views/Operaciones/Rendicion_cuentas.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[14]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/operaciones_compras',
      name: 'Agregar compra',
      component: () => import('../views/Operaciones/Compras.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[15]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/operaciones_compras_vista',
      name: 'Vista de compras',
      component: () => import('../views/Operaciones/Compras_v.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[16]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/facturacion_guias',
      name: 'Guias',
      component: () => import('../views/Facturacion/Guias.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[19]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    {
      path: '/facturacion_configuracion',
      name: 'Configuración guia',
      component: () => import('../views/Facturacion/Configuracion.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[20]) {
          next();
          
        } else {
          next(false);
        }
      }
    },

    {
      path: '/facturacion_comprobantes',
      name: 'Comprobantes',
      component: () => import('../views/Facturacion/Comprobantes.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[21]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },
    
    {
      path: '/facturacion_cobranza',
      name: 'Cobranza',
      component: () => import('../views/Facturacion/Cobranza.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[22]) {
          next();
          
        } else {
          next(false);
        }
      }
      
    },

    {
      path: '/mantenimiento_vista',
      name: 'Vista de mantenimientos',
      component: () => import('../views/Mantenimiento/Mantenimientos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[23]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/mantenimiento_plan',
      name: 'Plan de mantenimiento',
      component: () => import('../views/Mantenimiento/Plan_mantenimientos.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[24]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/mantenimiento_tareas',
      name: 'Tareas',
      component: () => import('../views/Mantenimiento/Tareas.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[25]) {
          next();
          
        } else {
          next(false);
        }
      }
    },
    {
      path: '/mantenimiento_plantillas',
      name: 'Plantillas',
      component: () => import('../views/Mantenimiento/Plantillas.vue'),
      beforeEnter: (to, from, next) => {
        if(store.state.Credentials[26]) {
          next();
          
        } else {
          next(false);
        }
      }
    },

  ]
})

export default router
