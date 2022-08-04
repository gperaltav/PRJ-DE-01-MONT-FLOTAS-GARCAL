import { createStore } from 'vuex'

// Instancia de router
const store = createStore({
    state () {
      return {
        authenticated: false,
        Account: {
          username: "admin",
          password: "123",
        },
        username: '',
      }
    },
    mutations: {
      authenticate(state) {
        state.authenticated=true;
      },
      deauthenticate(state) {
        state.authenticated=false;
      },
      set_user (state, payload) {
        state.username = payload.username;
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