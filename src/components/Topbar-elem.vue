<script>
export default {
  name: 'Topbar-elem',
  data() {
  return {};
  }
}
</script>


<template>

  <div className="path">
    <a> <i class="arrow right"></i> Base de datos </a>
  </div>

</template>

<style>
  .arrow {
    border: solid black;
    border-width: 0 3px 3px 0;
    display: inline-block;
    padding: 3px;
  }
  .right {
    transform: rotate(-45deg);
    -webkit-transform: rotate(-45deg);
  }

</style>