<template>
  <div>
    <el-dialog :title="entry.title" :model-value="entryDetailVisible" @close="handleClose">
      <a v-bind:href="entry.link" target="_blank"
        ><el-button class="entry-info" type="text"> <font-awesome-icon icon="arrow-up-right-from-square" /> </el-button
      ></a>
      <div v-html="entry.anond_content_html" class="anond-content" v-loading="loading"></div>
      <div class="line"></div>
      <div class="tool-box">
        <div class="comment">
          <font-awesome-icon icon="comment" />
          <span>{{ entry.hatena_bookmarkcount }}</span>
        </div>
        <div class="date">
          {{ parseDatetime(entry.posted_at) }}
        </div>
        <div class="clearfix"></div>
      </div>
      <div class="my-bookmark">
        <div class="my-comment" v-if="isLoggedIn() && userAlreadyBookmarked">
          <div class="bookmark">
            <div class="icon"><img :src="loginedUser.avatar_url" /></div>
            <div class="head-wrapper">
              <div class="user">{{ loginedUser.uid }}</div>
              <div class="bookmarked_at">
                {{ cutJSTDatetime(userBookmarked.created_datetime) }}
              </div>
            </div>
            <div class="comment">{{ userBookmarked.comment }}</div>
            <div class="clearfix"></div>
          </div>
        </div>
        <div class="add-bookmark" v-if="isLoggedIn() && !userAlreadyBookmarked">
          <el-form :model="bookmarkForm" :rules="bookmarkRules" ref="bookmarkForm" class="add-bookmark-form">
            <el-form-item prop="comment">
              <el-input type="textarea" v-model="bookmarkForm.comment"></el-input>
            </el-form-item>
            <el-form-item class="submit">
              <el-button type="primary" @click="submitBookmark">ブックマークする</el-button>
            </el-form-item>
          </el-form>
        </div>
        <div class="login-required" v-if="!isLoggedIn()">
          <el-button type="primary" @click="goToLoginPage">ログインしてブックマークする</el-button>
        </div>
      </div>
      <div class="bookmark-comment">
        <div class="bookmark" v-for="bookmark in bookmarks" v-bind:key="bookmark.id">
          <div class="icon"><img :src="icon(bookmark.user)" /></div>
          <div class="head-wrapper">
            <div class="user">{{ bookmark.user }}</div>
            <div class="bookmarked_at">
              {{ parseDatetime(bookmark.bookmarked_at) }}
            </div>
          </div>
          <div class="comment">{{ bookmark.comment }}</div>
          <div class="clearfix"></div>
          <div class="fill-line"></div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import moment from 'moment'

export default {
  name: 'stream-show',
  data() {
    return {
      bookmarkForm: {
        comment: '',
      },
      bookmarkRules: {
        comment: [
          {
            required: false,
            min: 1,
            max: 100,
            message: 'コメントは100文字以内にしてください',
            trigger: 'blur',
          },
        ],
      },
    }
  },
  computed: {
    ...mapState({
      entry: (state) => state.Stream.Show.entry,
      loading: (state) => state.Stream.Show.loading,
      bookmarks: (state) => state.Stream.Show.bookmarks,
      loginedUser: (state) => state.GlobalHeader.user,
      userAlreadyBookmarked: (state) => state.Stream.Show.userAlreadyBookmarked,
      userBookmarked: (state) => state.Stream.Show.userBookmarked,
    }),
    entryDetailVisible: {
      get() {
        return this.$store.state.Stream.Show.entryDetailVisible
      },
      set(value) {
        this.$store.commit('Stream/Show/changeEntryDetailVisible', value)
      },
    },
  },
  created() {
    this.$store.dispatch('Stream/Show/startLoading', this.$store.state.Stream.Show.loading)
    this.$store.dispatch('Stream/Show/loadEntry', this.$route.params.id).then((res) => {
      let url = res.link
      this.$store.dispatch('Stream/Show/fetchUserBookmark', url)
    })
    this.$store.dispatch('Stream/Show/loadBookmarks', this.$route.params.id)
  },
  methods: {
    parseDatetime(datetime) {
      return moment.unix(datetime).format('YYYY-MM-DD HH:mm')
    },
    cutJSTDatetime(datetime) {
      // JSTでもらった時刻を適切な形に整形
      return moment(datetime).format('YYYY-MM-DD HH:mm')
    },
    handleClose(e) {
      this.$store.dispatch('Stream/Show/cleanup', e)
      this.$router.push({ path: '/' })
    },
    icon(hatena_user) {
      return `http://cdn1.www.st-hatena.com/users/${hatena_user.slice(0, 2)}/${hatena_user}/profile.gif`
    },
    isLoggedIn() {
      return this.loginedUser
    },
    goToLoginPage() {
      window.location.href = '/auth/hatena'
    },
    submitBookmark() {
      this.$refs['bookmarkForm'].validate((valid, fields) => {
        if (valid) {
          let csrf = this.$cookie.getCookie('csrftoken')
          this.$store
            .dispatch(
              'Stream/Show/addBookmark',
              Object.assign({}, this.bookmarkForm, {
                csrf: csrf,
                url: this.entry.link,
              })
            )
            .then((res) => {
              this.$message({
                message: 'ブックマークしました',
                type: 'success',
              })
            })
            .catch((err) => {
              this.$message({
                message: 'ブックマークできませんでした',
                type: 'error',
              })
            })
        } else {
          console.error(fields)
          this.$message({
            message: 'エラーがあります',
            type: 'error',
          })
        }
      })
    },
  },
}
</script>

<style lang="scss" scoped>
.entry-info {
  float: right;
  padding: 0;
}

.line {
  height: 1px;
  background-color: #f2f6fc;
  margin: 1.5em 0 0.5em;
}

.fill-line {
  height: 1px;
  background-color: #f2f6fc;
  margin: 1em 0 0.5em;
}

.tool-box {
  padding: 0 1em;
  color: #c0c4cc;

  .comment {
    float: left;
  }

  .date {
    float: right;
  }
}

.my-bookmark {
  background-color: #e4e7ed;
  padding: 1em 1em;
  margin: 1.5em 0 1em 0;
  border-radius: 4px;

  .add-bookmark {
    .el-form-item {
      margin-bottom: 4px;
    }

    .submit {
      text-align: right;
    }
  }

  .login-required {
    text-align: center;
  }
}

.bookmark {
  .icon {
    float: left;
    margin-right: 0.8em;
    margin-top: 0.6em;

    img {
      width: 36px;
      height: 36px;
      border-radius: 4px;
    }
  }

  .head-wrapper {
    .user {
      float: left;
      color: #409eff;
    }

    .bookmarked_at {
      width: 100%;
      text-align: right;
      color: #c0c4cc;
    }
  }
}
</style>
