import Vue from "vue";
import Vuex from "vuex";
import createPersistedState from "vuex-persistedstate";
import contactsStore from "./components/contacts/store";
import notificationsStore from "./components/notifications/store";
import resourcesStore from "./components/resources/store";

Vue.use(Vuex);

export default new Vuex.Store({
  plugins: [createPersistedState({
    key: "$scm__store",
    reducer: (persistedState) => {
      const stateFilter = Object.assign({}, persistedState);
      const blackList = ["wait"];

      blackList.forEach((item) => {
        delete stateFilter[item];
      });
      return stateFilter;
    }

  })],
  strict: true,
  modules: {
    contacts: contactsStore,
    notifications: notificationsStore,
    resources: resourcesStore
  },
  state: {

  },
  mutations: {

  },
  actions: {

  }
})
