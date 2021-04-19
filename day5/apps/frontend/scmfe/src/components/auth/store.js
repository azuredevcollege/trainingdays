const state = {
    accessToken: "",
    account: {}
};

// getters
const getters = {
    accessToken: state => state.accessToken,
    account: state => state.account
};

// actions
const actions = {
    setAccessToken({ commit }, token) {
        commit("clearAccessToken");
        commit("setAccessToken", token);
    },
    setAccount({ commit }, account) {
        commit("clearAccount");
        commit("setAccount", account);
        console.log(account)
    }
};

// mutations
const mutations = {
    clearAccessToken(state) {
        state.accessToken = "";
    },
    setAccessToken(state, token) {
        state.accessToken = token;
    },
    clearAccount(state) {
        state.account = {};
    },
    setAccount(state, account) {
        state.account = account;
        console.log(account)
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}