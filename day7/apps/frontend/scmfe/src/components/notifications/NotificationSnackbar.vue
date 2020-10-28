<template>
  <v-snackbar
    v-if="currentMessage"
    v-model="snackbarVisible"
    :top="true"
    :color="currentMessage.type"
    vertical
    :timeout="timeout"
  >
    {{ currentMessage.message }}
    <v-btn dark text @click="closeMessage()">Close</v-btn>
  </v-snackbar>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
export default {
    computed: {
    ...mapGetters({
      currentMessage: "notifications/currentMessage",
      timeout: "notifications/timeout",
      messages: "notifications/messages",
      unreadMessages: "notifications/unreadMessages",
      unreadMessagesCount: "notifications/unreadMessagesCount",
      hasUnreadMessages: "notifications/hasUnreadMessages",
      readMessages: "notifications/readMessages"
    }),
    snackbarVisible: {
      get() {
        return this.$store.getters["notifications/visible"];
      },
      set(value) {
        this.$store.dispatch("notifications/setVisible", value, { root: true });
      }
    }
  },
  methods: {
    ...mapActions({
      markMessageRead: "notifications/setReadMessage"
    }),
    closeMessage() {
      this.markMessageRead(this.currentMessage.id);
      this.snackbarVisible = false;
    }
  },
}
</script>
