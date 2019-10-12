<template>
  <div>
    <el-container>
      <el-header>
        <el-menu
          :default-active="activeIndex"
          class="header-menu"
          mode="horizontal"
          active-text-color="#409EFF"
          :router="true"
          @select="handleSelect"
        >
          <span class="title-logo">MasudaStream</span>
          <el-menu-item index="1" :route="{ path: '/' }">エントリー</el-menu-item>
          <el-submenu index="3" v-if="isLoggedIn()" class="right-menu">
            <template slot="title"
              ><img class="avatar" :src="user.avatar_url"
            /></template>
            <el-menu-item index="3-1" :route="{ path: '/' }">ログアウト</el-menu-item>
          </el-submenu>
          <el-menu-item index="4" v-if="!isLoggedIn()" class="right-menu" :route="{ path: '/auth/login' }">ログイン</el-menu-item>
        </el-menu>
      </el-header>
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState({
      user: state => state.GlobalHeader.user,
      activeIndex: state => state.GlobalHeader.activeIndex
    })
  },
  created() {
    this.$store.dispatch('GlobalHeader/fetchUser')
  },
  methods: {
    isLoggedIn() {
      return this.user !== null
    },
    handleSelect(key, keyPath) {
      switch (key) {
        case '3-1':
          // ログアウトにはCSRFTokenが必要になる
          let csrf = this.$cookie.get('csrftoken')
          return this.$store.dispatch('GlobalHeader/logout', csrf).then(res => {
            this.$message({
              message: 'ログアウトしました',
              type: 'success'
            })
            this.$store.dispatch('GlobalHeader/changeActiveIndex', '1')
          })
        case '4':
          return this.$router.push('/auth/login')
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.el-header {
  padding: 0;

  .title-logo {
    float: left;
    height: 60px;
    line-height: 60px;
    padding-right: 1.5em;
  }

  .header-menu {
    padding-left: 3.5em;
    padding-right: 3.5em;
  }

  .right-menu {
    float: right;
  }

  img.avatar {
    width: 28px;
    height: 28px;
    border-radius: 2px;
  }
}
</style>

<style lang="scss">
html {
  font-family: 'Rounded Mplus 1c';
}

@media screen and (min-width: 768px) {
  html {
    font-size: 87.5%;
  }
}

@media screen and (min-width: 1024px) {
  html {
    font-size: 100%;
  }
}

@mixin side-margin-container($width: 80%) {
  max-width: 70rem;
  width: $width;
  margin: 0 auto;
}

.clearfix:before,
.clearfix:after {
  display: table;
  content: '';
}

.clearfix:after {
  clear: both;
}

// colors
$blue-color: #409eff;
$success-color: #67c23a;
$warning-color: #e6a23c;
$danger-color: #f56c6c;
$info-color: #909399;
$primary-text-color: #303133;
$regular-text-color: #606366;
$secondary-text-color: #909399;
$placeholder-text-color: #c0c4cc;
$base-border-color: #dcdfe6;
$light-border-color: #e4e7ed;
$lighter-border-color: #ebeef5;
$extra-light-border-color: #f2f6fc;

a:link,
a:visited,
a:hover,
a:active,
a:focus {
  color: $regular-text-color;
}

body {
  margin: 0;
}

#app {
  background-color: #ebeef5;
}

.margin-container {
  @include side-margin-container(80%);
}
</style>
