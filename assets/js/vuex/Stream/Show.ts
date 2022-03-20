import axios from 'axios'
import { ActionTree, MutationTree } from 'vuex'
import { RootState } from '..'
import { Bookmark } from '../../entity/bookmark'
import { Entry } from '../../entity/entry'
import { UserBookmarked } from '../../entity/user_bookmarked'

export type ShowState = {
  entry: Entry
  bookmarks: Array<Bookmark>
  entryDetailVisible: boolean
  loading: boolean
  userAlreadyBookmarked: boolean
  userBookmarked: UserBookmarked
}

const emptyEntry: Entry = {
  id: 0,
  title: '',
  summary: '',
  content: '',
  anond_content_html: '',
  link: '',
  hatena_bookmarkcount: 0,
  posted_at: 0,
}

const state = (): ShowState => ({
  entry: emptyEntry,
  bookmarks: [],
  entryDetailVisible: true,
  loading: true,
  userAlreadyBookmarked: false,
  userBookmarked: {},
})

const MUTATION_TYPES = {
  CHANGE_ENTRY_DETAIL_VISIBLE: 'changeEntryDetailVisible',
  SET_ENTRY: 'setEntry',
  SET_BOOKMARKS: 'setBookmarks',
  CLEAN_ENTRY: 'cleanEntry',
  CLEAN_BOOKMARKS: 'cleanBookmarks',
  CHANGE_LOADING: 'changeLoading',
  CHANGE_ALREADY_BOOKMARKED: 'changeAlreadyBookmarked',
  SET_USER_BOOKMARKED: 'setUserBookmarked',
}

const mutations: MutationTree<ShowState> = {
  [MUTATION_TYPES.CHANGE_ENTRY_DETAIL_VISIBLE]: (state, open: boolean) => {
    state.entryDetailVisible = open
  },
  [MUTATION_TYPES.SET_ENTRY]: (state, entry: Entry) => {
    state.entry = entry
  },
  [MUTATION_TYPES.SET_BOOKMARKS]: (state, bookmarks: Array<Bookmark>) => {
    state.bookmarks = bookmarks
  },
  [MUTATION_TYPES.CLEAN_ENTRY]: (state) => {
    state.entry = emptyEntry
  },
  [MUTATION_TYPES.CLEAN_BOOKMARKS]: (state) => {
    state.bookmarks = []
  },
  [MUTATION_TYPES.CHANGE_LOADING]: (state, loading: boolean) => {
    state.loading = loading
  },
  [MUTATION_TYPES.CHANGE_ALREADY_BOOKMARKED]: (state, bookmarked: boolean) => {
    state.userAlreadyBookmarked = bookmarked
  },
  [MUTATION_TYPES.SET_USER_BOOKMARKED]: (state, response: UserBookmarked) => {
    state.userBookmarked = response
  },
}

const actions: ActionTree<ShowState, RootState> = {
  openEntryDetail: ({ commit }) => {
    commit(MUTATION_TYPES.CHANGE_ENTRY_DETAIL_VISIBLE, true)
  },
  loadEntry: async ({ commit }, id: string): Promise<Entry> => {
    try {
      const res = await axios.get(`/api/masuda/entries/${id}`)
      commit(MUTATION_TYPES.SET_ENTRY, res.data.entry)
      return res.data.entry
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    } finally {
      commit(MUTATION_TYPES.CHANGE_LOADING, false)
    }
  },
  loadBookmarks: async ({ commit }, id: string) => {
    try {
      const res = await axios.get(`/api/masuda/entries/${id}/bookmarks`)
      commit(MUTATION_TYPES.SET_BOOKMARKS, res.data.bookmarks)
    } catch (err) {
      // eslint-disable-next-line no-console
      console.log(err)
    }
  },
  cleanup: ({ commit }) => {
    commit(MUTATION_TYPES.CLEAN_ENTRY)
    commit(MUTATION_TYPES.CLEAN_BOOKMARKS, {})
  },
  startLoading: ({ commit }) => {
    commit(MUTATION_TYPES.CHANGE_LOADING, true)
  },
  stopLoading: ({ commit }) => {
    commit(MUTATION_TYPES.CHANGE_LOADING, false)
  },
  addBookmark: async ({ commit }, form) => {
    const res = await axios.post(
      '/api/user/bookmark',
      {
        comment: form.comment,
        url: form.url,
      },
      {
        headers: {
          'X-CSRFToken': form.csrf,
        },
      }
    )

    commit(MUTATION_TYPES.CHANGE_ALREADY_BOOKMARKED, true)
    commit(MUTATION_TYPES.SET_USER_BOOKMARKED, res.data)
  },
  fetchUserBookmark: async ({ commit }, url: string) => {
    try {
      const res = await axios.get(`/api/user/bookmark?url=${url}`)
      commit(MUTATION_TYPES.CHANGE_ALREADY_BOOKMARKED, true)
      commit(MUTATION_TYPES.SET_USER_BOOKMARKED, res.data)
    } catch (err) {
      commit(MUTATION_TYPES.CHANGE_ALREADY_BOOKMARKED, false)
    }
  },
}

const Show = {
  namespaced: true,
  state: state,
  mutations: mutations,
  actions: actions,
}

export default Show
