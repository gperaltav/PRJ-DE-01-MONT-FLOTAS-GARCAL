import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'inicio',
      component: () => import('../views/Inicio.vue'),
    },
    {
      path: '/personal',
      name: 'Personal',
      component: () => import('../views/Base_datos/Personal.vue'),

    },
    {
      path: '/proveedores',
      name: 'Proveedores',
      component: () => import('../views/Base_datos/Proveedores.vue'),

    },
    {
      path: '/clientes',
      name: 'Clientes',
      component: () => import('../views/Base_datos/Clientes.vue'),

    },
    {
      path: '/vehiculos',
      name: 'Vehiculos',
      component: () => import('../views/Base_datos/Vehiculos.vue'),
    },
    {
      path: '/doc_personal',
      name: 'PermisosPersonal',
      component: () => import('../views/Documentos/Personal.vue'),
      
    },
    {
      path: '/doc_vehiculos',
      name: 'PermisosVehiculos',
      component: () => import('../views/Documentos/Vehiculos.vue'),
      
    },
    {
      path: '/planificacion',
      name: 'Planificacion',
      component: () => import('../views/Planificacion.vue'),
      
    },
    {
      path: '/operaciones_combustible',
      name: 'Combustible',
      component: () => import('../views/Operaciones/Combustible.vue'),
      
    },
    {
      path: '/operaciones_viaticos',
      name: 'Viaticos',
      component: () => import('../views/Operaciones/Viaticos.vue'),
      
    },
    {
      path: '/operaciones_personal',
      name: 'Pagos personal',
      component: () => import('../views/Operaciones/Choferes.vue'),
      
    },
    {
      path: '/operaciones_pago',
      name: 'Pagos ',
      component: () => import('../views/Operaciones/Pago.vue'),
      
    },
    {
      path: '/operaciones_rendicion_cuentas',
      name: 'Rendición de cuentas ',
      component: () => import('../views/Operaciones/Rendicion_cuentas.vue'),
      
    },
    {
      path: '/operaciones_compras',
      name: 'Agregar compra',
      component: () => import('../views/Operaciones/Compras.vue'),
      
    },
    {
      path: '/facturacion_guias',
      name: 'Guias',
      component: () => import('../views/Facturacion/Guias.vue'),
      
    },

    {
      path: '/facturacion_comprobantes',
      name: 'Comprobantes',
      component: () => import('../views/Facturacion/Comprobantes.vue'),
      
    },
    
    {
      path: '/facturacion_cobranza',
      name: 'Cobranza',
      component: () => import('../views/Facturacion/Cobranza.vue'),
      
    },

    {
      path: '/disposicion_dinero',
      name: 'Disposicion de dinero',
      component: () => import('../views/Disposicion_dinero.vue'),
      
    },

  ]
})

export default router
