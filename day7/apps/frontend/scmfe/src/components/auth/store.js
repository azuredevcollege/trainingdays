const state = {
    accessToken: ""
};

// getters
const getters = {
    accessToken: state => state.accessToken
};

// actions
const actions = {
    setAccessToken({ commit }, token) {
        commit("clearAccessToken");
        commit("setAccessToken", token);
    }
};

// mutations
const mutations = {
    clearAccessToken(state) {
        state.accessToken = "";
    },
    setAccessToken(state, token) {
        state.accessToken = token;
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}