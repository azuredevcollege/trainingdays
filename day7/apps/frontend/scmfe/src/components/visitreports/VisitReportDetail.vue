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
          <span class="ml-3 hidden-sm-and-down">Visit Report Details</span>
        </v-toolbar-title>
        <div class="flex-grow-1"></div>
        <v-spacer></v-spacer>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" icon @click="updateReport()">
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
            <v-list-item @click="deleteReport()">
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
                  <v-flex xs12 class="py-0">
                    <v-text-field
                      :error-messages="errors.collect('subject')"
                      data-vv-as="Subject"
                      name="subject"
                      v-validate="'required|max:255'"
                      v-model="reportFields.subject"
                      label="Subject"
                    ></v-text-field>
                  </v-flex>
                  <v-flex class="py-0" xs12>
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
                          type="date"
                          data-vv-as="Visit Date"
                          v-model="reportFields.visitDate"
                          v-validate="'required'"
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
                        <v-btn
                          text
                          color="primary"
                          @click="$refs.dialog.save(reportFields.visitDate)"
                        >OK</v-btn>
                      </v-date-picker>
                    </v-dialog>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-textarea
                      name="description"
                      v-model="reportFields.description"
                      label="Description"
                      data-vv-as="Description"
                      v-validate="'max:1000'"
                      :error-messages="errors.collect('description')"
                    ></v-textarea>
                  </v-flex>
                  <v-flex class="py-0" xs12>
                    <v-textarea
                      name="result"
                      v-model="reportFields.result"
                      label="Visit Result"
                      data-vv-as="Visit Result"
                      v-validate="'max:1000'"
                      :error-messages="errors.collect('result')"
                    ></v-textarea>
                  </v-flex>
                </v-layout>
              </v-container>
            </v-card-text>
          </v-card>
        </v-flex>
        <v-flex xs12 md4 sm5>
          <v-card>
            <v-subheader>Visiting Contact</v-subheader>
            <v-card-text class="text-center">
              <avatar
                :size="140"
                :image="reportFields.contact.avatarLocation"
                :firstname="reportFields.contact.firstname"
                :lastname="reportFields.contact.lastname"
              ></avatar>
            </v-card-text>
            <v-divider />
            <v-list dense two-line subheader>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title>{{reportFields.contact.firstname}} {{reportFields.contact.lastname}}</v-list-item-title>
                  <v-list-item-subtitle>Name</v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
              <v-list-item>
                <v-list-item-content>
                  <v-list-item-title>{{reportFields.contact.company}}</v-list-item-title>
                  <v-list-item-subtitle>Company</v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-list>
            <v-divider />
            <v-card-actions class="justify-center">
              <v-btn color="primary" text @click="showContact()">Open Contact</v-btn>
            </v-card-actions>
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

export default {
  components: {
    Avatar,
    ConfirmationDialog,
    ImageUploadDialog
  },
  computed: {
    ...mapGetters({
      report: "reports/report"
    }),
    isFormDirty() {
      return Object.keys(this.fields).some(key => this.fields[key].dirty);
    }
  },
  created() {
    return this.read(this.$route.params.id);
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
      read: "reports/read",
      update: "reports/update",
      delete: "reports/delete"
    }),
    updateReport() {
      this.update(this.reportFields).then(() => this.$validator.reset());
    },
    showContact() {
      this.$router.push({
        name: "contactDetail",
        params: { id: this.reportFields.contact.id }
      });
    },
    deleteReport() {
      this.$refs.confirm
        .open(
          "Delete Report",
          `Are you sure you want to delete report ${this.reportFields.firstname} ${this.reportFields.lastname}?`,
          {
            color: "red"
          }
        )
        .then(confirm => {
          if (confirm)
            this.delete(this.reportFields.id).then(() =>
              this.$router.push({ name: "reports" })
            );
        });
    }
  },
  data() {
    return {
      modal: false,
      items: [
        {
          text: "Home",
          disabled: false,
          to: "/home",
          exact: true
        },
        {
          text: "Visit Reports List",
          disabled: false,
          to: "/reports",
          exact: true
        },
        {
          text: "Report Detail",
          disabled: true
        }
      ],
      loading: false,
      reportFields: {
        contact: {}
      }
    };
  },
  watch: {
    report: {
      handler() {
        this.reportFields.avatarLocation = "";
        this.reportFields = _.cloneDeep(this.report);
      },
      deep: true
    }
  }
};
</script>