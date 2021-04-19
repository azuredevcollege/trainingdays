import { getReportsHttpClient } from "../../utils/http-client";

const BASE_PATH = "/stats";

const state = {
    stats: [],
    statsByContact: [],
    statsTimeline: []
};

// getters
const getters = {
    stats: state => state.stats,
    statsByContact: state => state.statsByContact,
    statsTimeline: state => state.statsTimeline
};

// actions
const actions = {
    statsByContact({ commit, dispatch }, id) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        commit("clearStatsByContact");
        return client.get(`${BASE_PATH}/${id}`).then(response => {
            commit("setStatsByContact", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Stats Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    statsOverall({ commit, dispatch }) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.get(`${BASE_PATH}`).then(response => {
            commit("setStats", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Stats Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    statsTimeline({ commit, dispatch }) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.get(`${BASE_PATH}/timeline`).then(response => {
            commit("setStatsTimeline", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Stats Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
};

// mutations
const mutations = {
    setStats(state, payload) {
        state.stats = payload;
    },
    setStatsByContact(state, payload) {
        state.statsByContact = payload;
    },
    clearStatsByContact(state) {
        state.statsByContact = [];
    },
    setStatsTimeline(state, payload) {
        state.statsTimeline = payload;
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}