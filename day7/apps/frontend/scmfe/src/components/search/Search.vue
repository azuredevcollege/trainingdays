<template >
  <div>
    <v-divider />
    <v-toolbar flat>
      <v-breadcrumbs :items="items">
        <v-icon slot="divider">mdi-chevron-right</v-icon>
      </v-breadcrumbs>
    </v-toolbar>
    <v-divider />
    <v-container class="grid-list-xl">
      <v-toolbar class="px-0" flat color="transparent">
        <v-toolbar-title class="pt-0 px-0 headline">
          <span v-if="phrase != ''" class="ml-3 hidden-sm-and-down">Search Results for: "{{phrase}}"</span>
          <span v-else class="ml-3 hidden-sm-and-down">Search for Contacts</span>
        </v-toolbar-title>
        <div class="flex-grow-1"></div>
        <v-spacer></v-spacer>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" icon @click="clearInternal()">
              <v-icon>mdi-close</v-icon>
            </v-btn>
          </template>
          <span>Clear</span>
        </v-tooltip>
      </v-toolbar>
      <v-layout row class="px-5">
        <v-flex v-for="contact in contacts" :key="contact.id" xs12 sm12 md6 lg6 xlg4>
          <v-card class="mx-auto" max-width="344" raised>
            <v-list-item three-line>
              <v-list-item-content>
                <div class="overline mb-4">CONTACT</div>
                <v-list-item-title
                  class="headline mb-1"
                >{{contact.document.firstname}} {{contact.document.lastname}}</v-list-item-title>
                <v-list-item-subtitle>
                  <v-icon :size="15">mdi-domain</v-icon>
                  {{contact.document.company}}
                </v-list-item-subtitle>
                <v-list-item-subtitle class="font-weight-light pt-2">
                  <v-icon :size="15">mdi-map-marker</v-icon>
                  {{contact.document.street}} / {{contact.document.city}}
                </v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar tile size="80" color="grey">
                <avatar
                  :tile="true"
                  :size="80"
                  :image="contact.document.avatarlocation"
                  :firstname="contact.document.firstname"
                  :lastname="contact.document.lastname"
                ></avatar>
              </v-list-item-avatar>
            </v-list-item>

            <v-card-actions>
              <v-btn text @click="openContact(contact.document.id)">Open</v-btn>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import Avatar from "../avatar/Avatar";

export default {
  components: {
    Avatar
  },
  computed: {
    ...mapGetters({
      contacts: "search/searchcontactsresults"
    })
  },
  beforeRouteUpdate(to, from, next) {
    this.searchInternal(decodeURIComponent(to.query.phrase));
    next();
  },
  mounted() {
    return this.searchInternal(decodeURIComponent(this.$route.query.phrase));
  },
  methods: {
    ...mapActions({
      search: "search/searchContacts",
      clear: "search/clearresults"
    }),
    searchInternal(phrase) {
      this.loading = true;
      this.phrase = phrase;
      this.search({ phrase }).then(() => (this.loading = false));
    },
    openContact(id) {
      this.$router.push({ name: "contactDetail", params: { id } });
    },
    clearInternal() {
      this.phrase = "";
      this.clear();
    }
  },
  data() {
    return {
      phrase: "",
      items: [
        {
          text: "Home",
          disabled: false,
          to: "/home",
          exact: true
        },
        {
          text: "Search Results",
          disabled: true,
          to: "search"
        }
      ],
      loading: false
    };
  }
};
</script>