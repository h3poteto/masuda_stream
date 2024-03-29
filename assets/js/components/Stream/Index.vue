<template>
  <div class="margin-container">
    <el-row :gutter="20">
      <el-col :span="18">
        <div class="grid-content">
          <div class="entry" v-for="entry in entries" v-bind:key="entry.id" v-on:click="openEntryDetail(entry.id)">
            <el-card class="box-card entry-card">
              <div slot="header" class="clearfix">
                <span>{{ entry.title }}</span>
              </div>
              <div>
                {{ entry.summary }}
              </div>
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
            </el-card>
          </div>
          <el-card class="box-card loading-card" v-loading="lazyloading"> </el-card>
        </div>
      </el-col>
      <el-col :span="6">
        <div class="grid-content">
          <el-card class="box-card">
            <sidemenu></sidemenu>
          </el-card>
        </div>
      </el-col>
    </el-row>
    <router-view></router-view>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import moment from 'moment'
import Sidemenu from '../Sidemenu'

export default {
  name: 'stream-index',
  components: {
    Sidemenu,
  },
  computed: {
    ...mapState({
      entries: (state) => state.Stream.Index.entries,
      lazyloading: (state) => state.Stream.Index.lazyloading,
    }),
  },
  created() {
    this.$store.dispatch('Stream/Index/fetchEntries', this.$store.state.Stream.Index.entries)
    window.addEventListener('scroll', this.onScroll)
  },
  unmounted() {
    window.removeEventListener('scroll', this.onScroll)
  },
  methods: {
    parseDatetime(datetime) {
      return moment.unix(datetime).format('YYYY-MM-DD HH:mm')
    },
    onScroll(event) {
      if (this.$store.state.Stream.Index.lazyloading) {
        return
      }

      if (document.documentElement.clientHeight + document.documentElement.scrollTop >= event.target.body.clientHeight - 20) {
        this.$store.dispatch(
          'Stream/Index/lazyFetchEntries',
          this.$store.state.Stream.Index.entries[this.$store.state.Stream.Index.entries.length - 1].posted_at
        )
      }
    },
    openEntryDetail(entryId) {
      // モーダルを開いた際にvue-routerによる遷移をさせることでURLを変えたい
      this.$store.dispatch('Stream/Show/openEntryDetail', entryId)
      this.$router.push({ path: `/entries/${entryId}` })
    },
  },
}
</script>

<style lang="scss" scoped>
.margin-container {
  .entry-card {
    cursor: pointer;
    margin-bottom: 0.5em;

    .entry-info {
      float: right;
      padding: 0;
    }

    .line {
      height: 1px;
      background-color: #f2f6fc;
      margin: 1.5em 0 0.5em;
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
  }

  .loading-card {
    height: 4em;
  }
}
</style>
