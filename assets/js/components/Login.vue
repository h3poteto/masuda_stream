<template>
  <div class="margin-container">
    <el-row :gutter="20">
      <el-col :span="18">
        <div class="gird-content not-login">
          <el-button type="primary" @click="login">はてなアカウントでログイン</el-button>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="grid-content">
          <el-card class="box-card">
            <Sidemenu></Sidemenu>
          </el-card>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import Sidemenu from '@/components/Sidemenu'

export default {
  components: { Sidemenu },
  methods: {
    login() {
      window.location.href = '/auth/hatena'
    }
  }
}
</script>

<style lang="scss" scoped>
.not-login {
  text-align: center;
}
</style>
