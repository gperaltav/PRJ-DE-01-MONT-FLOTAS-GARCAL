<script  setup>
import axios from 'axios'
</script>

<script >
  export default {
    name: 'Login',

    data() {
      return {
        input: {
          username: "",
          password: ""
        },
      }
    },

    methods: {
      login() {
        //console.log(this.$store.state.authenticated);
        if(this.input.username != "" && this.input.password != "") {
          if(this.input.username ==  this.$store.state.Account.username && this.input.password == this.$store.state.Account.password) {
            this.$store.dispatch('authenticate');
          }
          else {
            alert ("Contraseña incorrecta, intente nuevamente");  
            console.log("Usuario o contraseña incorrectos");
          }
        } else {
          alert ("Campos vacios");  
          console.log("Se debe ingresar una contraseña");
        }
      },
      
      login_api() {
        axios
        .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/usuarios/comprobar', 
          { 
            "usu_codigo": String(this.input.username),
            "usu_clave": String(this.input.password)
          },{ 
          headers:{
            "x-api-key":this.$store.state.api_key2
          }
        })
        .then((resp) => {
          console.log(resp);  
          var logg=resp.data[0].usu_existe;
          if(logg) {
            this.$store.dispatch('authenticate');
            this.$store.commit('set_user', {
              username: resp.data[0].usu_codigo
            });
            axios
            .post('http://51.222.25.71:8080/garcal-erp-apiv1/api/menusxusuarios', 
            { 
              "usu_codigo":resp.data[0].usu_codigo
            },{ 
              headers:{
                "x-api-key":this.$store.state.api_key2
              }
            })
            .then((resp2) => {
              var prmtmp={}
              if(resp.data[0].usu_codigo==='admin') {
                for (let index = 1; index <= 26; index++) {
                  prmtmp[index]=true;
                }
              }
              else {
                for (const key in resp2.data) {
                  prmtmp[resp2.data[key].mnu_id]=true;
                }
              }
              
              this.$store.commit('set_permisos', prmtmp);
            })
            .catch((e)=>{
              alert("Hubo un error externo al obtener informacion sobre los permisos, se recomienda reiniciar la aplicación"+String(e))
            })

          }
          else {
            console.log("No Logeado");
            console.log("Usuario o contraseña incorrectos");
          }
        })
        .catch((e)=> {
          console.log(e);
          console.log("Error interno al iniciar sesión");
        })
      },
    },
    mounted() {
      //console.log(navigator.userAgentData.mobile);
      // problemas en otras areas
    }
  }
  
</script>


<template>
  <el-container class="layout-container" style="height: calc( 100vh - 20px );">
    <el-container>

      <el-header style="text-align: left; font-size: 24px">
        <div class="toolbar">
          <span>ERP Garcal</span>
        </div>
      </el-header>

      <el-main style="background-color:white">
        <div class="login-page">
          <div class="logsection">
          <p> Iniciar sesión </p>
          <div class="form">
            <form @submit.prevent class="login-form">
              <input type="text" v-model="input.username" placeholder="Nombre de usuario"/>
              <input type="password" v-model="input.password" placeholder="Contraseña"/>
              <button v-on:click="login_api()">Entrar</button>
            </form>
          </div>
          </div>
        </div>
      </el-main>
    </el-container>
  </el-container>
</template>

<style scoped>
  .layout-container .el-header {
    position: relative;
    background-color: rgb(8, 68, 164);
    color: rgb(240, 240, 240);
    text-align: left;
    font-family: "Roboto", sans-serif;
  }
  .layout-container .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}
  #login {
    width: 500px;
    border: 1px solid #ffffff;
    background-color: #f0f0f0;
    margin: auto;
    margin-top: 200px;
    padding: 20px;
  }
  canvas {
    background: 
      linear-gradient(
        hsl(200, 50%, 80%) 0%, 
        hsl(200, 30%, 95%) 75%)
    ;
    display: block;
  }

  .back {
    background: url(https://jackrugile.com/images/misc/skyline-texture.png);
    height: 100%;
    left: 0;
    position: fixed;
    top: 0;
    width: 100%;
}

.login-page {
  width: 360px;
  padding: 8% 0 0;
  margin: auto;
  
}
.logsection {
  box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
}
.login-page p {
  
  font-family: "Roboto", sans-serif;
  position: relative;
  z-index: 1;
  background: #d4d4d4;
  max-width: 360px;
  margin: 0;
  padding: 15px;
  text-align: center;
  
}
.form {
  position: relative;
  z-index: 1;
  background: #FFFFFF;
  max-width: 360px;
  margin: 0 auto 100px;
  padding: 45px;
  text-align: center;
}
.form input {
  font-family: "Roboto", sans-serif;
  outline: 0;
  background: #f2f2f2;
  width: 100%;
  border: 0;
  margin: 0 0 15px;
  padding: 15px;
  box-sizing: border-box;
  font-size: 14px;
}
.form button {
  font-family: "Roboto", sans-serif;
  text-transform: uppercase;
  outline: 0;
  background: #dadada;
  width: 100%;
  border: 0;
  padding: 15px;
  color: #252525;
  font-size: 14px;
  -webkit-transition: all 0.3 ease;
  transition: all 0.3 ease;
  cursor: pointer;
  margin-top: 20px;
}
.form button:hover,.form button:active,.form button:focus {
  background: #325ea0;
}
.form .message {
  margin: 15px 0 0;
  color: #b3b3b3;
  font-size: 12px;
}
.form .message a {
  color: #4CAF50;
  text-decoration: none;
}
.form .register-form {
  display: none;
}
.container {
  position: relative;
  z-index: 1;
  max-width: 300px;
  margin: 0 auto;
}
</style>