import { createApp } from 'vue'
import { createStore } from 'vuex'
import { createRouter, createWebHistory } from 'vue-router'

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

      component: () => import('./views/Login.vue')
    },
    {
      path: '/inicio',
      name: 'Secure',
      component: () => import('./views/Secure.vue'),
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
      component: () => import('./views/Base_datos/Personal.vue')
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
  ]
})



const app = createApp(App)

app.use(store)
app.use(router)

app.mount('#app')
