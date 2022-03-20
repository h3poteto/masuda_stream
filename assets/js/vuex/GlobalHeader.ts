import axios from 'axios'
import { ActionTree, MutationTree } from 'vuex'
import { RootState } from '.'

export type GlobalHeaderState = {
  user: any
  activeIndex: string
}

const state = (): GlobalHeaderState => ({
  user: null,
  activeIndex: '1',
})

export const MUTATION_TYPES = {
  LOAD_USER: 'loadUser',
  LOGOUT_USER: 'logoutUser',
  CHANGE_ACTIVE_INDEX: 'changeActiveIndex',
}

const mutations: MutationTree<GlobalHeaderState> = {
  [MUTATION_TYPES.LOAD_USER]: (state: GlobalHeaderState, user: any) => {
    state.user = user
  },
  [MUTATION_TYPES.LOGOUT_USER]: (state: GlobalHeaderState) => {
    state.user = null
  },
  [MUTATION_TYPES.CHANGE_ACTIVE_INDEX]: (state: GlobalHeaderState, index: string) => {
    state.activeIndex = index
  },
}

const actions: ActionTree<GlobalHeaderState, RootState> = {
  fetchUser: async ({ commit }) => {
    try {
      const res = await axios.get('/api/user/my')
      commit(MUTATION_TYPES.LOAD_USER, res.data.user)
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    }
  },
  logout: async ({ commit }, csrf: string) => {
    return new Promise((resolve, reject) => {
      axios
        .delete('/api/user/logout', {
          headers: {
            'X-CSRFToken': csrf,
          },
        })
        .then((res) => {
          commit(MUTATION_TYPES.LOGOUT_USER)
          resolve(res)
        })
        .catch((err) => {
          reject(err)
        })
    })
  },
  changeActiveIndex: ({ commit }, index: string) => {
    commit(MUTATION_TYPES.CHANGE_ACTIVE_INDEX, index)
  },
}

const GlobalHeader = {
  namespaced: true,
  state: state,
  mutations: mutations,
  actions: actions,
}

export default GlobalHeader
