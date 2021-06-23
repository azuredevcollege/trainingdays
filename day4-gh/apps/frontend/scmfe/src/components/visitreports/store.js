import { getReportsHttpClient } from "../../utils/http-client";

const BASE_PATH = "/reports";

const state = {
    reportsForContact: [],
    report: {},
    reports: [],
    newReport: ""
};

// getters
const getters = {
    reports: state => state.reports,
    reportsForContact: state => state.reportsForContact,
    report: state => state.report,
    newReport: state => state.newReport
};

// actions
const actions = {
    list({ commit, dispatch }) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.get(BASE_PATH).then(response => {
            commit("setReports", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    read({ commit, dispatch }, id) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.get(`${BASE_PATH}/${id}`).then(response => {
            commit("setReport", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    update({ dispatch }, payload) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.put(`${BASE_PATH}/${payload.id}`, payload).then(() => {
            dispatch("wait/end", "apicall", { root: true });
            dispatch("notifications/addMessage", { type: "success", message: "Report successfully updated.", read: false }, { root: true });
            return dispatch("read", payload.id);
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    create({ commit, dispatch }, payload) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.post(`${BASE_PATH}`, payload).then(response => {
            var newreport = response.headers.location;
            commit("setNewReport", newreport);
            dispatch("notifications/addMessage", { type: "success", message: "Report successfully created.", read: false }, { root: true });
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    delete({ dispatch }, id) {
        dispatch("wait/start", "apicall", { root: true });
        var client = getReportsHttpClient();
        return client.delete(`${BASE_PATH}/${id}`).then(() => {
            dispatch("notifications/addMessage", { type: "success", message: "Report successfully deleted.", read: false }, { root: true });
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    listContactVisits({ commit, dispatch }, contactid) {
        dispatch("wait/start", "apicall", { root: true });
        commit("clearReportsForContact");
        var client = getReportsHttpClient();
        return client.get(`${BASE_PATH}?contactid=${contactid}`).then(response => {
            commit("setReportsForContact", response.data);
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Report Service unavailable.", read: false }, { root: true });
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
    setReports(state, payload) {
        state.reports = payload;
    },
    setReportsForContact(state, payload) {
        state.reportsForContact = payload;
    },
    clearReportsForContact(state) {
        state.reportsForContact = [];
    },
    setReport(state, payload) {
        state.report = payload;
    },
    setNewReport(state, payload) {
        state.newReport = payload;
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}