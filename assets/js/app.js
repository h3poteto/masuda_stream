import { createApp } from 'vue'
import { VueCookieNext } from 'vue-cookie-next'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import 'vue-awesome/icons'
import Icon from 'vue-awesome/components/Icon'
import { loadProgressBar } from 'axios-progress-bar'
import 'axios-progress-bar/dist/nprogress.css'
import router from './router'
import store from './vuex'

loadProgressBar()

Vue.component('icon', Icon)

const app = createApp()
app.use(store)
app.use(router)
app.use(VueCookieNext)
app.use(ElementPlus)

app.mount('#app')
