<script setup>
import { RouterLink, RouterView } from 'vue-router'

</script>


<script>
    import Login from "./views/Login.vue"
    export default {
        name: 'App',

        components: {
            Login,
        },
        mounted() {
            console.log(this.Account)
            if(!this.$store.state.authenticated) {
                this.$router.replace({ name: "login" });
            }
        },
        methods: {

        }
        
    }
</script>


<template>
    <div>
        <router-view></router-view>
    </div>
</template>

<style>
    body {
        background-color: #373737;
    }
    h1 {
        padding: 0;
        margin-top: 0;
    }

</style>
