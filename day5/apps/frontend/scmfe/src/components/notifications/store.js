import uuidv4 from "uuid/v4";
import _ from "lodash";

const state = {
    messages: [],
    visible: false,
    timeout: 6000
}

// getters
const getters = {
    currentMessage: state => state.messages.length > 0 ? state.messages[state.messages.length - 1] : null,
    messages: state => _.sortBy(state.messages, m => m.timestamp).reverse(),
    readMessages: state => _.sortBy(state.messages.filter(m => m.read == true), m => m.timestamp).reverse(),
    unreadMessages: state => _.sortBy(state.messages.filter(m => m.read == false), m => m.timestamp).reverse(),
    unreadMessagesCount: state => state.messages.filter(m => m.read == false).length,
    unreadImportantMessagesCount: state => state.messages.filter(m => m.read == false && m.type != "success" && m.type != "info").length,
    hasUnreadImportantMessages: state => state.messages.filter(m => m.read == false && m.type != "success" && m.type != "info").length > 0,
    hasUnreadMessages: state => state.messages.filter(m => m.read == false).length > 0,
    visible: state => state.visible,
    timeout: state => state.timeout,
};

// actions
const actions = {
    addMessage({ commit }, message) {
        commit("addMessage", message);
        commit("setVisible", true);
    },
    setVisible({ commit }, visible) {
        commit("setVisible", visible);
    },
    setReadMessage({ commit }, id) {
        commit("setReadMessage", id);
    },
    setReadAllMessages({ commit }) {
        commit("setReadAllMessages");
    },
    removeMessage({ commit }, id) {
        commit("removeMessage", id);
    },
    removeAllMessages({ commit }) {
        commit("removeAllMessages");
    }
};

// mutations
const mutations = {
    addMessage(state, message) {
        var uuid = uuidv4();
        message.id = uuid;
        message.timestamp = new Date();
        state.messages.push(message);
    },
    setVisible(state, visible) {
        state.visible = visible;
    },
    setReadMessage(state, id) {
        state.messages.forEach(message => {
            if (message.id == id) {
                message.read = true;
            }
        });
    },
    setReadAllMessages(state) {
        state.messages.forEach(message => {
            message.read = true;
        });
    },
    removeMessage(state, id) {
        _.remove(state.messages, message => message.id == id);
    },
    removeAllMessages(state) {
        state.messages = [];
    }
}

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}