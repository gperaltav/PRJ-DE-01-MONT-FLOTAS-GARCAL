<script setup>
  import { XMLParser } from "fast-xml-parser";


  function vs_r() {
    let input = document.createElement('input');
    input.type = 'file';
    input.accept='.xml';
    input.id='filet'
    input.onchange = e => {

      let file = e.target.files[0];
      

      let fil= new FileReader()
      fil.onload = xy => {

        const parser = new XMLParser();
        let jObj = parser.parse(xy.target.result);

        console.log(jObj);

        for (const key in jObj.Invoice['cac:InvoiceLine']) {
          var element = jObj.Invoice['cac:InvoiceLine'][key]['cac:Item']['cbc:Description'];
          console.log(element);
        }

      }

      fil.readAsText(file)
      
    }
    input.click();
  }

</script>

<template>
  <el-button @click="vs_r()">Subir</el-button>
</template>