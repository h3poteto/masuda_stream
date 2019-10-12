<template>
  <div class="side-menu">
    <p><a href="/about">MasudaStreamについて</a></p>
    <p>
      &copy; 2019
      <a href="https://pleroma.io/users/h3poteto" target="_blank">@h3poteto@pleroma.io</a>
    </p>
  </div>
</template>

<script>
export default {
  name: 'sidemenu',
  data() {
    return {}
  }
}
</script>

<style lang="scss" scoped>
.side-menu {
  font-size: 14px;
  color: #606366;

  a:link,
  a:visited,
  a:hover,
  a:active,
  a:focus {
    color: #606366;
  }
}
</style>
