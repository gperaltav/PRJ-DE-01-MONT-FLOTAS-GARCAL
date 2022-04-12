<script>
export default {
  name: 'Topbar',
  data() {
  return {};
  },
  methods: {

  }

}
</script>


<template>

  <div className="navbar">
    <div className="path"> </div>
    
  </div>

</template>

<style scoped>
  #secure {
    background-color: #FFFFFF;
    border: 1px solid #ffffff;
    padding: 20px;
    margin-top: 10px;
  }
  .sidenav {
    padding-top: 25px;
    height: 90%;
    width: 160px;
    position: fixed;
    z-index: 1;
    top: 0;
    left: 0;
    background-color: #111;
    border-radius: 20px;
    overflow-x: hidden;

    margin:15px;
    margin-left: 15px;
  }

  .sidenav a {
    padding: 8px 16px 8px 16px;
    text-decoration: none;
    font-size: 14px;
    color: #818181;
    display: block;
    font-family: Arial, sans-serif;
  }

  .sidenav a:hover {
    color: #f1f1f1;
  }

  .sidenav img {
    display: block;
    margin-top: 10px;
    margin-bottom: 10px;
    margin-left: auto;
    margin-right: auto;

  }

  .main {
    margin-left: 160px; /* Same as the width of the sidenav */
    font-size: 28px; /* Increased text to enable scrolling */
    padding: 0px 10px;
  }

  .accordion {
    transition: 0.4s;
    cursor: pointer;
  }

  .active, .accordion:hover {
    background-color: rgb(37, 37, 37); 
  }

  .panel {
    padding: 8px 6px 8px 16px;
    text-decoration: none;
    font-size: 20px;
    color: #818181;
    display: block;
  }

  @media screen and (max-height: 450px) {
    .sidenav {padding-top: 15px;}
    .sidenav a {font-size: 18px;}
  }

</style>