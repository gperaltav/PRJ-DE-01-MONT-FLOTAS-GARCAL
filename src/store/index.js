import { createStore } from 'vuex'

// Instancia de router
const store = createStore({
    state () {
      return {
        authenticated: false,
        ismovile:false,
        Account: {
          username: "admin",
          password: "123",
        },
        Credentials:{
          
        },
        username: '',
        api_key1: '',
        api_key2: '',
      }
    },
    mutations: {
      authenticate(state) {
        state.authenticated=true;
      },
      is_movile(state) {
        state.ismovile=true;
      },
      deauthenticate(state) {
        state.authenticated=false;
      },
      set_user (state, payload) {
        state.username = payload.username;
      },
      set_permisos (state, payload) {
        state.Credentials=payload;
      },
      set_key1(state,payload) {
        state.api_key1=payload.key;
      },
      set_key2(state,payload) {
        state.api_key2=payload.key;
      }
    },
    actions: {
      authenticate (context) {
        context.commit('authenticate');
      },
      deauthenticate (context) {
        context.commit('deauthenticate');
        context.commit('set_user', {
          username: ""
        });
      }
    }
  })

export default store