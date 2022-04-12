<script setup>
import { RouterLink, RouterView } from 'vue-router'

</script>


<script>
    import Login from "./views/Login.vue"
    export default {
        name: 'App',
        data() {
            return {
                authenticated: false,
                Account: {
                    username: "admin",
                    password: "123",
                }
            }
        },
        components: {
            Login,
        },
        mounted() {
            console.log(this.Account)
            if(!this.authenticated) {
                //this.$router.replace({ name: "Secure" });
            }
        },
        methods: {
            setAuthenticated(status) {
                this.authenticated = status;
            },
            logout() {
                this.authenticated = false;
            }
        }
        
    }
</script>


<template>
    <div id="app">
        <div id="nav">
            <router-link v-if="authenticated" to="/login" v-on:click.native="logout()" replace>Salir</router-link>
            <router-link v-else to="/inicio" ></router-link>
        </div>
        <router-view @authenticated="setAuthenticated" />
    </div>
</template>

<style>
    body {
        background-color: #c4c4c4;
    }
    h1 {
        padding: 0;
        margin-top: 0;
    }
    #app {
        width: 1024px;
        margin: auto;
    }
</style>
