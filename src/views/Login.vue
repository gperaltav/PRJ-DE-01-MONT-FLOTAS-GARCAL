<template>
  <div id="login">
    <h2>Iniciar sesión</h2>
    <div>
      <input type="text" name="username" v-model="input.username" placeholder="Usuario" />
      <input type="password" name="password" v-model="input.password" placeholder="Contraseña" />
      <button type="button" v-on:click="login()">Login</button></div>
    </div>
</template>

<script>
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
                        this.$router.replace({ name: "Usuarios" });
                    } else {
                        
                        console.log("Usuario o contraseña incorrectos");
                    }
                } else {
                    console.log("Se debe ingresar una contraseña");
                }
            }
        }
    }
</script>

<style scoped>
    #login {
        width: 500px;
        border: 1px solid #CCCCCC;
        background-color: #dddddd;
        margin: auto;
        margin-top: 200px;
        padding: 20px;
    }
</style>