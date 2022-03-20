import { createStore, createLogger } from 'vuex'

import GlobalHeader from './GlobalHeader'
import Stream from './Stream'

const store = createStore({
  // eslint-disable-next-line no-undef
  strict: process.env.NODE_ENV !== 'production',
  // eslint-disable-next-line no-undef
  plugins: process.env.NODE_ENV !== 'production' ? [createLogger()] : [],
  modules: {
    GlobalHeader,
    Stream,
  },
})

export default store
