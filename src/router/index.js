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
      path: '/ubigeos',
      name: 'Ubigeos',
      component: () => import('../views/Base_datos/Ubigeos.vue'),

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
      path: '/operaciones_pagos_vista',
      name: 'Vista de pagos',
      component: () => import('../views/Operaciones/Pago_v.vue'),
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
      path: '/operaciones_compras_vista',
      name: 'Vista de compras',
      component: () => import('../views/Operaciones/Compras_v.vue'),
    },
    {
      path: '/facturacion_guias',
      name: 'Guias',
      component: () => import('../views/Facturacion/Guias.vue'),
      
    },
    {
      path: '/facturacion_configuracion',
      name: 'Configuración guia',
      component: () => import('../views/Facturacion/Configuracion.vue'),
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

    {
      path: '/mantenimiento_vista',
      name: 'Vista de mantenimientos',
      component: () => import('../views/Mantenimiento/Mantenimientos.vue'),
    },
    {
      path: '/mantenimiento_plan',
      name: 'Plan de mantenimiento',
      component: () => import('../views/Mantenimiento/Plan_mantenimientos.vue'),
    },
    {
      path: '/mantenimiento_tareas',
      name: 'Tareas',
      component: () => import('../views/Mantenimiento/Tareas.vue'),
    },
    {
      path: '/mantenimiento_plantillas',
      name: 'Plantillas',
      component: () => import('../views/Mantenimiento/Plantillas.vue'),
    },

  ]
})

export default router
