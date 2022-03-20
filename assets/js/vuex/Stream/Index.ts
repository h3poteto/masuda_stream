import axios from 'axios'
import { ActionTree, Module, MutationTree } from 'vuex'
import { RootState } from '..'
import { Entry } from '../../entity/entry'

export type IndexState = {
  entries: Array<Entry>
  lazyLoading: boolean
}

const state = (): IndexState => ({
  entries: [],
  lazyLoading: false,
})

export const MUTATION_TYPES = {
  LOAD_ENTRIES: 'loadEntries',
  CHANGE_LAZY_LOADING: 'changeLazyLoading',
  APPEND_ENTRIES: 'appendEntries',
}

const mutations: MutationTree<IndexState> = {
  [MUTATION_TYPES.LOAD_ENTRIES]: (state, entries: Array<Entry>) => {
    state.entries = entries
  },
  [MUTATION_TYPES.CHANGE_LAZY_LOADING]: (state, flag: boolean) => {
    state.lazyLoading = flag
  },
  [MUTATION_TYPES.APPEND_ENTRIES]: (state, entries: Array<Entry>) => {
    state.entries = state.entries.concat(entries)
  },
}

const actions: ActionTree<IndexState, RootState> = {
  fetchEntries: async ({ commit }) => {
    try {
      const res = await axios.get('/api/masuda/entries')
      commit(MUTATION_TYPES.LOAD_ENTRIES, res.data.entries as Array<Entry>)
    } catch (err) {
      // TODO: エラー表示は後で考えよう
      // eslint-disable-next-line no-console
      console.log(err)
    }
  },
  lazyFetchEntries: async ({ commit, state }, before: string) => {
    if (state.lazyLoading) {
      return
    }
    commit(MUTATION_TYPES.CHANGE_LAZY_LOADING, true)
    try {
      const res = await axios.get(`/api/masuda/entries?before=${before}`)
      commit(MUTATION_TYPES.APPEND_ENTRIES, res.data.entries as Array<Entry>)
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    } finally {
      commit(MUTATION_TYPES.CHANGE_LAZY_LOADING, false)
    }
  },
}

const Index: Module<IndexState, RootState> = {
  namespaced: true,
  state: state,
  mutations: mutations,
  actions: actions,
}

export default Index
