import { createRouter, createWebHistory } from 'vue-router'


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: {
        name: "Secure"
      }
    },
    {
      path: '/login',
      name: 'login',

      component: () => import('../views/Login.vue')
    },
    {
      path: '/inicio',
      name: 'Secure',
      component: () => import('../views/Secure.vue'),
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
      component: () => import('../views/Base_datos/Personal.vue')
    },
    {
      path: '/vehiculos',
      name: 'Vehiculos',
      component: () => import('../views/Base_datos/Vehiculos.vue'),
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

export default router
