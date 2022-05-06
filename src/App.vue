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
            console.log(this.$store.state.authenticated)
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
html, body {
  background-color: #373737;
}
</style>
