import { getHttpClient } from '../../utils/http-client'

const BASE_PATH = '/'

const state = {
  contacts: [],
  contactsPicker: [],
  contact: {},
  newContact: '',
}

// getters
const getters = {
  contacts: state => state.contacts,
  contact: state => state.contact,
  newContact: state => state.newContact,
  contactsPicker: state => state.contactsPicker,
}

// actions
const actions = {
  list({ commit, dispatch }) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .get(BASE_PATH)
      .then(response => {
        commit('setContacts', response.data)
        dispatch('wait/end', 'apicall', { root: true })
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
  listPicker({ commit, dispatch }) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .get(BASE_PATH)
      .then(response => {
        commit('setContactsList', response.data)
        dispatch('wait/end', 'apicall', { root: true })
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
  read({ commit, dispatch }, id) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .get(`${BASE_PATH}${id}`)
      .then(response => {
        commit('setContact', response.data)
        dispatch('wait/end', 'apicall', { root: true })
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
  update({ dispatch }, payload) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .put(`${BASE_PATH}${payload.id}`, payload)
      .then(() => {
        dispatch('wait/end', 'apicall', { root: true })
        dispatch(
          'notifications/addMessage',
          {
            type: 'success',
            message: 'Contact successfully updated.',
            read: false,
          },
          { root: true }
        )
        return dispatch('read', payload.id)
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
  create({ commit, dispatch }, payload) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .post(`${BASE_PATH}`, payload)
      .then(response => {
        var newcontact = response.data.id
        commit('setNewContact', newcontact)
        dispatch(
          'notifications/addMessage',
          {
            type: 'success',
            message: 'Contact successfully created.',
            read: false,
          },
          { root: true }
        )
        dispatch('wait/end', 'apicall', { root: true })
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
  delete({ dispatch }, id) {
    dispatch('wait/start', 'apicall', { root: true })
    var client = getHttpClient()
    return client
      .delete(`${BASE_PATH}${id}`)
      .then(() => {
        dispatch(
          'notifications/addMessage',
          {
            type: 'success',
            message: 'Contact successfully deleted.',
            read: false,
          },
          { root: true }
        )
        dispatch('wait/end', 'apicall', { root: true })
      })
      .catch(err => {
        if (typeof err == 'object' && err.code) {
          if (err.code == 'ECONNABORTED') {
            dispatch(
              'notifications/addMessage',
              {
                type: 'error',
                message: 'Contact Service unavailable.',
                read: false,
              },
              { root: true }
            )
          }
        } else {
          if (err && err.message) {
            dispatch(
              'notifications/addMessage',
              { type: 'error', message: err.message, read: false },
              { root: true }
            )
          }
        }
        dispatch('wait/end', 'apicall', { root: true })
      })
  },
}

// mutations
const mutations = {
  setContacts(state, payload) {
    state.contacts = payload
  },
  setContactsList(state, payload) {
    state.contactsPicker = payload
  },
  setContact(state, payload) {
    state.contact = payload
  },
  setNewContact(state, payload) {
    state.newContact = payload
  },
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
}
