
<script>
export default {
  name: 'TableA',
  data() {
    return {
      data:{
        items:[
          { Id: '123456', Name:"Pancho"},
          { Id: '123234', Name:"Carlos"},
          { Id: '124424', Name:"Rosario"},
          { Id: '152345', Name:"Ana"},
          { Id: '654324', Name:"Paco"},
          { Id: '231254', Name:"Alejandra"},
        ],
        types:["Id","Name"],
        names:["Id","Nombre"]
      }};
  },
  methods: { 
    
  }
}
</script>

<template>
  <div id="TableA">
    <table>
      <tr><th v-for="id in this.data.names" :key="id">{{id}} </th></tr>

      <tr v-for="item in this.data.items" :key="item.Id">
        <th v-for="id in this.data.types" :key="id">{{item[id]}} </th>
      </tr>
    </table>
  </div>

</template>

<style>
body {
  padding-left: 200px;
}
.TableA {
  padding-left: 200px;
  width: 70%;
}
.TableA table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 70%;

}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
