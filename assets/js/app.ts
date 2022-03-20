import { createApp } from 'vue'
import { VueCookieNext } from 'vue-cookie-next'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import { loadProgressBar } from 'axios-progress-bar'
import 'axios-progress-bar/dist/nprogress.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faComment, faArrowUpRightFromSquare } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

import router from './router'
import store from './vuex'
import App from './App.vue'

loadProgressBar()

library.add(faComment)
library.add(faArrowUpRightFromSquare)

const app = createApp(App)
app.use(store)
app.use(router)
app.use(VueCookieNext)
app.use(ElementPlus)
app.component('font-awesome-icon', FontAwesomeIcon)

app.mount('#app')
