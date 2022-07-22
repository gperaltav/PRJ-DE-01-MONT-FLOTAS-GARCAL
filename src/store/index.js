import { createStore } from 'vuex'

// Instancia de router
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
export default store