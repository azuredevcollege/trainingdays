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
      <v-card-title class="headline">Create Visit Report</v-card-title>
      <v-divider />
      <v-card-text>
        <v-container container--fluid grid-list-md>
          <v-layout row wrap>
            <v-flex xs12>
              <v-text-field
                name="subject"
                label="Subject"
                type="text"
                data-vv-as="Subject"
                v-model="reportFields.subject"
                v-validate="'required|max:255'"
                :error-messages="errors.collect('subject')"
                required
              ></v-text-field>
            </v-flex>
            <v-flex xs12>
              <v-textarea
                name="description"
                label="Description"
                type="text"
                v-model="reportFields.description"
              ></v-textarea>
            </v-flex>
            <v-flex xs12>
              <v-dialog
                ref="dialog"
                v-model="modal"
                :return-value.sync="reportFields.visitDate"
                width="290px"
              >
                <template v-slot:activator="{ on }">
                  <v-text-field
                    name="visitDate"
                    label="Visit Date"
                    type="visitDate"
                    data-vv-as="Visit Date"
                    v-model="reportFields.visitDate"
                    v-validate="'required|max:255'"
                    :error-messages="errors.collect('visitDate')"
                    v-on="on"
                    append-icon="mdi-calendar"
                    required
                    readonly
                  ></v-text-field>
                </template>
                <v-date-picker v-model="reportFields.visitDate" scrollable>
                  <v-spacer></v-spacer>
                  <v-btn text color="primary" @click="modal = false">Cancel</v-btn>
                  <v-btn text color="primary" @click="$refs.dialog.save(reportFields.visitDate)">OK</v-btn>
                </v-date-picker>
              </v-dialog>
            </v-flex>
            <v-flex xs12>
              <contact-picker ref="contactspicker"></contact-picker>
              <v-text-field
                name="contact"
                label="Contact"
                type="text"
                data-vv-as="#Contact"
                v-model="contact"
                v-validate="'required'"
                :error-messages="errors.collect('contact')"
                required
                readonly
                @click="openContactPicker()"
              >
                <template v-slot:prepend>
                  <avatar
                    v-if="reportFields.contact.id && reportFields.contact.id != ''"
                    :image="reportFields.contact.avatarLocation"
                    :firstname="reportFields.contact.firstname"
                    :lastname="reportFields.contact.lastname"
                  ></avatar>
                </template>
              </v-text-field>
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
import ContactPicker from "../contactpicker/ContactPicker";
import Avatar from "../avatar/Avatar";
import { mapGetters, mapActions } from "vuex";
export default {
  components: {
    ContactPicker,
    Avatar
  },
  data: () => ({
    modal: false,
    date: "",
    dialog: false,
    resolve: null,
    reject: null,
    options: {
      color: "primary",
      width: 700,
      zIndex: 200
    },
    reportFields: {
      subject: "",
      description: "",
      visitDate: "",
      contact: {
        id: "",
        firstname: "",
        lastname: "",
        avatarLocation: "",
        company: ""
      }
    }
  }),
  computed: {
    ...mapGetters({
      newReport: "reports/newReport"
    }),
    contact() {
      if (
        this.reportFields.contact &&
        (this.reportFields.contact.firstname ||
          this.reportFields.contact.lastname)
      ) {
        return `${this.reportFields.contact.firstname} ${this.reportFields.contact.lastname}`;
      } else {
        return "";
      }
    }
  },
  methods: {
    open(options) {
      this.reportFields = {
        subject: "",
        description: "",
        visitDate: "",
        contact: {
          id: "",
          firstname: "",
          lastname: "",
          avatarLocation: "",
          company: ""
        }
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
      create: "reports/create"
    }),
    openContactPicker() {
      this.$refs.contactspicker.open().then(usr => {
        if (usr) {
          var c = {
          id: usr.id,
          firstname: usr.firstname,
          lastname: usr.lastname,
          avatarLocation: usr.avatarLocation,
          company: usr.company
        }
          this.reportFields.contact = c;
        }
      });
    },
    agree() {
      this.$validator.validateAll().then(valid => {
        if (valid) {
          this.create(this.reportFields).then(() => {
            this.resolve(this.newReport);
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