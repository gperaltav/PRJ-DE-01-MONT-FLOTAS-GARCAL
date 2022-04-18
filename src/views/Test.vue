<script>
  import Sidebar from "../components/Sidebar.vue"
  import TableA from "../components/table.vue"
    export default {
        name: 'Test',
        data() {
            return {};
        },
        components: {
            Sidebar,
            TableA
        }
    }
</script>

<template>
  <div id="secure">
    <Sidebar />
    <TableA />
  </div>
</template>

<style>

</style>