<template>
  <v-app id="inspire">
    <v-progress-linear
      v-if="$wait.any"
      color="white"
      style="z-index: 6; margin-top: 0px; position: fixed"
      height="3"
      :indeterminate="true"
    ></v-progress-linear>
    <v-navigation-drawer v-model="drawer" :clipped="$vuetify.breakpoint.lgAndUp" app>
      <v-list>
        <template v-for="item in items">
          <v-list-group
            v-if="item.children"
            :key="item.text"
            v-model="item.model"
            :prepend-icon="item.model ? item.icon : item['icon-alt']"
            append-icon
          >
            <template v-slot:activator>
              <v-list-item :to="item.route">
                <v-list-item-content>
                  <v-list-item-title>{{ item.text }}</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </template>
            <v-list-item v-for="(child, i) in item.children" :key="i" link :to="child.route">
              <v-list-item-action v-if="child.icon">
                <v-icon>{{ child.icon }}</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>{{ child.text }}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list-group>
          <v-list-item v-else :key="item.text" link :to="item.route">
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title>{{ item.text }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </template>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar :clipped-left="$vuetify.breakpoint.lgAndUp" app color="blue darken-3" flat dark>
      <v-toolbar-title style="width: 300px" class="ml-0 pl-4">
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
        <span class="hidden-sm-and-down">SCM Contacts</span>
      </v-toolbar-title>
      <v-text-field
        v-if="$uisettings.searchEndpoint && $uisettings.searchEndpoint != ''"
        flat
        hide-details
        prepend-inner-icon="mdi-magnify"
        label="Search"
        class="hidden-sm-and-down"
        v-model="searchphrase"
        @keyup.enter="search()"
      />
      <v-spacer />
    </v-app-bar>
    <v-content>
      <router-view></router-view>
    </v-content>
    <notification-snackbar></notification-snackbar>
  </v-app>
</template>

<script>
import NotificationSnackbar from "./components/notifications/NotificationSnackbar";
export default {
  name: "App",
  created() {
    if (
      this.$uisettings.reportsEndpoint &&
      this.$uisettings.reportsEndpoint != ""
    ) {
      this.items.push({
        icon: "mdi-file-document-outline",
        text: "Visit Reports",
        route: "/reports"
      });
    }

    if (this.$uisettings.enableStats) {
      this.items.push({
        icon: "mdi-finance",
        text: "Statistics",
        route: "/stats"
      });
    }
  },
  components: {
    NotificationSnackbar
  },
  methods: {
    search() {
      if (this.searchphrase != "") {
        var search = this.searchphrase;
        this.searchphrase = "";
        this.$router.push({
          name: "search",
          query: { phrase: encodeURIComponent(search) }
        });
      }
    }
  },
  data: () => ({
    dialog: false,
    searchphrase: "",
    drawer: null,
    items: [
      { icon: "mdi-desktop-mac", text: "Home", route: "/" },
      { icon: "mdi-contacts", text: "Contacts", route: "/contacts" }
    ]
  })
};
</script>
