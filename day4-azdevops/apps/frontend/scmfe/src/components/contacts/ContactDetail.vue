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
          <span class="ml-3 hidden-sm-and-down">Contact Details</span>
        </v-toolbar-title>
        <div class="flex-grow-1"></div>
        <v-spacer></v-spacer>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" icon @click="updateContact()">
              <v-icon>mdi-content-save</v-icon>
            </v-btn>
          </template>
          <span>Save</span>
        </v-tooltip>
        <v-icon disabled>mdi-circle-small</v-icon>
        <v-menu bottom left>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" icon>
              <v-icon>mdi-dots-vertical</v-icon>
            </v-btn>
          </template>
          <v-list>
            <v-list-item @click="deleteContact()">
              <v-list-item-avatar>
                <v-icon color="red">mdi-delete</v-icon>
              </v-list-item-avatar>
              <v-list-item-title>Delete</v-list-item-title>
            </v-list-item>
          </v-list>
        </v-menu>
      </v-toolbar>
      <v-layout row class="px-5">
        <v-flex xs12 md8 sm7>
          <v-card>
            <v-card-text>
              <v-container fluid>
                <v-layout wrap row>
                  <v-flex class="px-0" xs12>
                    <v-subheader>Details</v-subheader>
                  </v-flex>
                  <v-flex xs12 md6 class="py-0">
                    <v-text-field
                      :error-messages="errors.collect('firstname')"
                      data-vv-as="First Name"
                      name="firstname"
                      v-validate="'required|max:255'"
                      v-model="contactFields.firstname"
                      label="First Name"
                    ></v-text-field>
                  </v-flex>
                  <v-flex xs12 md6 class="py-0">
                    <v-text-field
                      :error-messages="errors.collect('lastname')"
                      data-vv-as="Last Name"
                      name="lastname"
                      v-validate="'required|max:255'"
                      v-model="contactFields.lastname"
                      label="Last Name"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-text-field
                      :error-messages="errors.collect('email')"
                      data-vv-as="Email Address"
                      name="email"
                      v-validate="'required|max:255'"
                      v-model="contactFields.email"
                      label="Email Address"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-textarea
                      name="description"
                      v-model="contactFields.description"
                      label="My Comments / Description"
                    ></v-textarea>
                  </v-flex>
                  <v-flex class="px-0" xs12>
                    <v-subheader>Company Details</v-subheader>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-text-field
                      :error-messages="errors.collect('company')"
                      data-vv-as="Company"
                      name="company"
                      v-validate="'required|max:255'"
                      v-model="contactFields.company"
                      label="Company"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" md8 xs12>
                    <v-text-field
                      :error-messages="errors.collect('street')"
                      data-vv-as="Street"
                      name="street"
                      v-validate="'required|max:255'"
                      v-model="contactFields.street"
                      label="Street"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" md4 xs12>
                    <v-text-field
                      :error-messages="errors.collect('houseNumber')"
                      data-vv-as="House Number"
                      name="houseNumber"
                      v-validate="'required|max:255'"
                      v-model="contactFields.houseNumber"
                      label="House Number"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" md4 xs12>
                    <v-text-field
                      :error-messages="errors.collect('postalCode')"
                      data-vv-as="Postal Code"
                      name="postalCode"
                      v-validate="'required|max:255'"
                      v-model="contactFields.postalCode"
                      label="Postal Code"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" md8 xs12>
                    <v-text-field
                      :error-messages="errors.collect('city')"
                      data-vv-as="City"
                      name="city"
                      v-validate="'required|max:255'"
                      v-model="contactFields.city"
                      label="City"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-text-field
                      :error-messages="errors.collect('country')"
                      data-vv-as="Country"
                      name="country"
                      v-validate="'required|max:255'"
                      v-model="contactFields.country"
                      label="Country"
                    ></v-text-field>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>
          </v-card>
        </v-flex>
        <v-flex xs12 md4 sm5>
          <v-card>
            <v-subheader>Contact Avatar</v-subheader>
            <v-card-text class="text-center">
              <avatar
                :size="140"
                :image="contactFields.avatarLocation"
                :firstname="contactFields.firstname"
                :lastname="contactFields.lastname"
              ></avatar>
            </v-card-text>
            <v-divider v-if="$uisettings.resourcesEndpoint && $uisettings.resourcesEndpoint != ''" />
            <v-card-actions class="justify-center">
              <v-btn
                v-if="$uisettings.resourcesEndpoint && $uisettings.resourcesEndpoint != ''"
                color="primary"
                text
                @click="changeImage()"
              >Change Avatar</v-btn>
            </v-card-actions>
          </v-card>
          <v-card v-if="visits.length >0" class="mt-8">
            <v-subheader>Next Visits</v-subheader>
            <v-list dense two-line subheader>
              <v-list-item v-for="visit in visits" :key="visit.id" :to="`/reports/${visit.id}`">
                <v-list-item-content>
                  <v-list-item-title>{{visit.subject}}</v-list-item-title>
                  <v-list-item-subtitle>
                    <v-icon :size="17">mdi-calendar</v-icon>
                    {{visit.visitDate}}
                  </v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
          <v-card v-if="$uisettings.enableStats && stats.length > 0"  class="mt-8">
            <v-toolbar flat dense color="transparent">
              <span class="font-weight-light">Visit Results: Sentiment Analysis</span>
            </v-toolbar>
            <v-divider></v-divider>
            <v-card-text class="text-center pa-0">
              <scm-score :score="currentScore" />
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
    <confirmation-dialog ref="confirm"></confirmation-dialog>
    <image-upload-dialog ref="logoupload"></image-upload-dialog>
  </div>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
import _ from "lodash";
import Avatar from "../avatar/Avatar";
import ConfirmationDialog from "../dialog/ConfirmationDialog";
import ImageUploadDialog from "../resources/ImageUploadDialog";
import ScmScore from "../charts/ScmScore";
export default {
  components: {
    Avatar,
    ConfirmationDialog,
    ImageUploadDialog,
    ScmScore

  },
  computed: {
    ...mapGetters({
      contact: "contacts/contact",
      visits: "reports/reportsForContact",
      stats: "stats/statsByContact",
    }),
    isFormDirty() {
      return Object.keys(this.fields).some(key => this.fields[key].dirty);
    },
    currentScore: function() {
      return this.stats.length > 0 ? this.stats[0].avgScore : 0;
    }
  },
  created() {
    return this.read(this.$route.params.id).then(() => {
      if (
        this.$uisettings.reportsEndpoint &&
        this.$uisettings.reportsEndpoint != ""
      ) {
        this.readVisits(this.$route.params.id);
      }
      if (
        this.$uisettings.enableStats
      ) {
        this.statsByContact(this.$route.params.id);
      }
    });
  },
  beforeRouteLeave(to, from, next) {
    if (this.isFormDirty) {
      this.$refs.confirm
        .open("You've got unsaved changes", "Leave anyway?", {
          color: "orange"
        })
        .then(confirm => {
          if (confirm) next();
        });
    } else {
      next();
    }
  },
  methods: {
    ...mapActions({
      read: "contacts/read",
      update: "contacts/update",
      delete: "contacts/delete",
      readVisits: "reports/listContactVisits",
      statsByContact: "stats/statsByContact"
    }),
    updateContact() {
      this.update(this.contactFields).then(() => this.$validator.reset());
    },
    deleteContact() {
      this.$refs.confirm
        .open(
          "Delete Contact",
          `Are you sure you want to delete contact ${this.contactFields.firstname} ${this.contactFields.lastname}?`,
          {
            color: "red"
          }
        )
        .then(confirm => {
          if (confirm)
            this.delete(this.contactFields.id).then(() =>
              this.$router.push({ name: "contacts" })
            );
        });
    },
    changeImage() {
      this.$refs.logoupload.open().then(url => {
        if (url) {
          this.contactFields.avatarLocation = url;
        }
      });
    }
  },
  data() {
    return {
      items: [
        {
          text: "Home",
          disabled: false,
          to: "/home",
          exact: true
        },
        {
          text: "Contacts",
          disabled: false,
          to: "/contacts",
          exact: true
        },
        {
          text: "Contact Detail",
          disabled: true
        }
      ],
      loading: false,
      contactFields: {}
    };
  },
  watch: {
    contact: {
      handler() {
        this.contactFields.avatarLocation = "";
        this.contactFields = _.cloneDeep(this.contact);
      },
      deep: true
    }
  }
};
</script>