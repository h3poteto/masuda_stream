import Vue from 'vue'
import VueRouter from 'vue-router'
import GlobalHeader from './components/GlobalHeader.vue'
import StreamIndex from './components/Stream/Index.vue'
import StreamShow from './components/Stream/Show.vue'
import Login from './components/Login.vue'
import About from './components/About.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/about',
    component: About,
    name: 'about'
  },
  {
    path: '/',
    component: GlobalHeader,
    name: 'global-header',
    children: [
      {
        path: '',
        component: StreamIndex,
        name: 'stream-index',
        children: [
          {
            path: 'entries/:id',
            component: StreamShow,
            name: 'stream-show'
          }
        ]
      },
      {
        path: 'auth/login',
        component: Login,
        name: 'login'
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  routes: routes
})

export default router
