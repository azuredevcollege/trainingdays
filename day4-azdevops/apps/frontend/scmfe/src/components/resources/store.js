import { getResourcesHttpClient } from "../../utils/http-client";

const state = {
    contactimage: ""
}

// getters
const getters = {
    contactimage: state => state.contactimage,
};

// actions
const actions = {
    uploadImage({ commit, dispatch }, payload) {
        var {
            blob,
            fileType
        } = payload;
        dispatch("wait/start", "apicall", { root: true });
        commit("clearImage");
        var client = getResourcesHttpClient();
        const config = {
            headers: {
                "content-type": fileType
            }
        };
        return client.post("/contactimages/binary", blob, config).then(response => {
            commit("setImage", response.headers.location);
            dispatch("notifications/addMessage", { type: "success", message: "Image upload successful.", read: false }, { root: true });
            dispatch("wait/end", "apicall", { root: true });
        }).catch(err => {
            if (typeof err == "object" && err.code) {
                if (err.code == "ECONNABORTED") {
                    dispatch("notifications/addMessage", { type: "error", message: "Resources Service unavailable.", read: false }, { root: true });
                }
            } else {
                if (err && err.message) {
                    dispatch("notifications/addMessage", { type: "error", message: err.message, read: false }, { root: true });
                }
            }
            dispatch("wait/end", "apicall", { root: true });
        });
    },
    clearImage({ commit }) {
        commit("clearImage");
    }
};

// mutations
const mutations = {
    clearImage(state) {
        state.contactimage = "";
    },
    setImage(state, payload) {
        state.contactimage = payload;
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}