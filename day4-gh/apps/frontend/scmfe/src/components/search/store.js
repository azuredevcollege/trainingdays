import { getSearchHttpClient } from "../../utils/http-client";

const BASE_PATH = "/";

const state = {
    searchcontactsresults: []
};

// getters
const getters = {
    searchcontactsresults: state => state.searchcontactsresults
};

// actions
const actions = {
    searchContacts({ commit, dispatch }, options) {
        var { phrase } = options;
        dispatch("wait/start", "apicall", { root: true });
        var client = getSearchHttpClient();
        return client.get(`${BASE_PATH}contacts?phrase=${phrase}`).then(response => {
            commit("setSearchContactsResults", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Search Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    clearresults({ commit }) {
        commit("clearResults");
    }
};

// mutations
const mutations = {
    setSearchContactsResults(state, payload) {
        state.searchcontactsresults = payload;
    },
    clearResults(state) {
        state.searchcontactsresults = [];
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}