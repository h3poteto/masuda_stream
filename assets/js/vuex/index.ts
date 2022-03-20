import { createStore, createLogger, useStore as baseUseStore, Store } from 'vuex'
import { InjectionKey } from 'vue'

import GlobalHeader, { GlobalHeaderState } from './GlobalHeader'
import Stream, { StreamModuleState } from './Stream'

export const key: InjectionKey<Store<RootState>> = Symbol()

export function useStore() {
  return baseUseStore(key)
}

export interface RootState {
  GlobalHeader: GlobalHeaderState
  Stream: StreamModuleState
}

const store = createStore<RootState>({
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
