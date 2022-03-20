import { Module } from 'vuex'
import { RootState } from '.'
import Index, { IndexState } from './Stream/Index'
import Show, { ShowState } from './Stream/Show'

export type StreamState = {}

type StreamModule = {
  Index: IndexState
  Show: ShowState
}

export type StreamModuleState = StreamModule & StreamState

const Stream: Module<StreamState, RootState> = {
  namespaced: true,
  modules: {
    Index,
    Show,
  },
}

export default Stream
