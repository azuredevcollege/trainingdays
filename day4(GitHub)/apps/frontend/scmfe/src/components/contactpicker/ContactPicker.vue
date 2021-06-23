<template>
  <v-dialog
    :fullscreen="$vuetify.breakpoint.xsOnly"
    v-model="dialog"
    :max-width="options.width"
    @keydown.esc="cancel"
    v-bind:style="{ zIndex: options.zIndex }"
  >
    <v-card>
      <v-toolbar dark color="grey" dense flat>
        <v-toolbar-title class="white--text">Contact Picker</v-toolbar-title>
      </v-toolbar>
      <v-data-table
        v-if="dialog"
        v-model="selected"
        :headers="headers"
        :items="contacts"
        show-select
        :single-select="!options.multiple"
        v-on:click:row="select"
      >
        <template v-slot:item.avatarLocation="{item}">
          <avatar :image="item.avatarLocation" :firstname="item.firstname" :lastname="item.lastname"></avatar>
        </template>
      </v-data-table>
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn
          :disabled="this.selected.length == 0"
          color="primary darken-1"
          text
          @click="agree"
        >{{options.agreeText}}</v-btn>
        <v-btn color="grey" text @click="cancel">{{options.disagreeText}}</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
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
      contacts: "contacts/contactsPicker"
    })
  },
  mounted() {
    this.list();
  },
  data() {
    return {
      dialog: false,
      resolve: null,
      reject: null,
      selected: [],
      options: {
        width: 600,
        zIndex: 200,
        agreeText: "Select",
        disagreeText: "Cancel",
        multiple: false
      },
      headers: [
        { text: "", value: "avatarLocation", sortable: false, align: "center" },
        { text: "Firstname", value: "firstname" },
        { text: "Lastname", value: "lastname" },
        { text: "Company", value: "company" }
      ]
    };
  },
  methods: {
    ...mapActions({
      list: "contacts/listPicker"
    }),
    select(selectedItem) {
      var wasInArray = false;
      this.selected.forEach((item, i) => {
        if (item.id == selectedItem.id) {
          this.selected.splice(i, 1);
          wasInArray = true;
        }
      });
      if (this.options.multiple == false) this.selected = [];
      if (wasInArray) return;
      this.contacts.forEach(item => {
        if (item.id == selectedItem.id) {
          this.selected.push(item);
        }
      });
    },
    open(options) {
      this.selected = [];
      this.dialog = true;
      this.options = Object.assign(this.options, options);
      return new Promise((resolve, reject) => {
        this.resolve = resolve;
        this.reject = reject;
      });
    },
    agree() {
      this.resolve(this.options.multiple ? this.selected : this.selected[0]);
      this.dialog = false;
    },
    cancel() {
      this.resolve(false);
      this.dialog = false;
    }
  }
};
</script>
