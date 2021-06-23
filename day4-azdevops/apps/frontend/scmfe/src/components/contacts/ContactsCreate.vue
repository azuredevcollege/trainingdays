<template>
  <v-dialog
    v-model="dialog"
    :max-width="options.width"
    @keydown.esc="cancel()"
    persistent
    v-bind:style="{ zIndex: options.zIndex }"
    :fullscreen="$vuetify.breakpoint.xsOnly"
  >
    <v-card tile>
      <v-card-title class="headline">Create Contact</v-card-title>
      <v-divider />
      <v-card-text>
        <v-container container--fluid grid-list-md>
          <v-layout row wrap>
            <v-flex md6 xs12>
              <v-text-field
                name="firstname"
                label="First Name"
                type="text"
                data-vv-as="First Name"
                v-model="contactFields.firstname"
                v-validate="'required|max:255'"
                :error-messages="errors.collect('firstname')"
                required
              ></v-text-field>
            </v-flex>
            <v-flex md6 xs12>
              <v-text-field
                name="lastname"
                label="Last Name"
                type="text"
                data-vv-as="Last Name"
                v-model="contactFields.lastname"
                v-validate="'required|max:255'"
                :error-messages="errors.collect('lastname')"
                required
              ></v-text-field>
            </v-flex>
            <v-flex xs12>
              <v-text-field
                name="email"
                label="Email"
                type="email"
                data-vv-as="Email"
                v-model="contactFields.email"
                v-validate="'required|max:255'"
                :error-messages="errors.collect('email')"
                required
              ></v-text-field>
            </v-flex>
            <v-flex xs12>
              <v-text-field
                name="company"
                label="Company"
                type="text"
                data-vv-as="Company"
                v-model="contactFields.company"
                v-validate="'required|max:255'"
                :error-messages="errors.collect('company')"
                required
              ></v-text-field>
            </v-flex>
          </v-layout>
        </v-container>
      </v-card-text>
      <v-divider />
      <v-card-actions>
        <v-spacer></v-spacer>
        <v-btn color="primary darken-1" text @click="agree()">Save</v-btn>
        <v-btn color="grey" text @click="cancel()">Cancel</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { mapGetters, mapActions } from "vuex";

export default {
  components: {},
  data: () => ({
    dialog: false,
    resolve: null,
    reject: null,
    options: {
      color: "primary",
      width: 700,
      zIndex: 200
    },
    contactFields: {
      firstname: "",
      lastname: "",
      email: "",
      company: ""
    }
  }),
  computed: {
    ...mapGetters({
      newContact: "contacts/newContact"
    })
  },
  methods: {
    open(options) {
      this.contactFields = {
        firstname: "",
        lastname: "",
        email: "",
        company: ""
      };
      this.$validator.reset();
      this.dialog = true;
      this.options = Object.assign(this.options, options);
      return new Promise((resolve, reject) => {
        this.resolve = resolve;
        this.reject = reject;
      });
    },
    ...mapActions({
      create: "contacts/create"
    }),
    agree() {
      this.$validator.validateAll().then(valid => {
        if (valid) {
          this.create(this.contactFields).then(() => {
            this.resolve(this.newContact);
            this.dialog = false;
          });
        }
      });
    },
    cancel() {
      this.resolve(null);
      this.dialog = false;
    }
  }
};
</script>