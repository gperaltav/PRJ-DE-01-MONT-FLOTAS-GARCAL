<template>
  <div>
    <el-table :data="myTable" :cell-class-name="cellStyle">
      <el-table-column prop="name" label="name" width="115"/>
      <el-table-column prop="occupation" label="occupation" align="right" width="115"/>
    </el-table>
  </div>
</template>

<script>

export default {

  name: "HelloWorld",
  data() {
    return {
      myTable: [
        {
          name: "jhon",
          occupation: "Lawyer"
        },
        {
          name: "Tom",
          occupation: "Judge"
        }
      ]
    };
  },
  methods: {
    cellStyle() {
      return "selected-cell"
    }
  },
  props: {
    msg: String
  }
};
</script>

<style>

.selected-cell {
    background: red;
    color: red;
}
</style>