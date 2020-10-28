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
          <span class="ml-3 hidden-sm-and-down">Visit Reports List</span>
        </v-toolbar-title>
        <div class="flex-grow-1"></div>
        <v-spacer></v-spacer>
        <v-tooltip bottom>
          <template v-slot:activator="{ on }">
            <v-btn v-on="on" icon @click="refresh()">
              <v-icon>mdi-refresh</v-icon>
            </v-btn>
          </template>
          <span>Refresh</span>
        </v-tooltip>
      </v-toolbar>
      <v-layout row class="px-5">
        <v-flex xs12>
          <v-data-table :headers="headers" :items="reports" class="elevation-1">
            <template v-slot:item.subject="{item}">
              <router-link style="padding-left: 5px;" :to="`reports/${item.id}`">{{ item.subject }}</router-link>
            </template>
            <template v-slot:item.avatar="{item}">
              <avatar
                :image="item.contact.avatarLocation"
                :firstname="item.contact.firstname"
                :lastname="item.contact.lastname"
              ></avatar>
            </template>
            <template v-slot:item.actions="{item}">
              <v-hover>
                <v-icon
                  slot-scope="{ hover }"
                  :color="`${hover ? 'primary' : ''}`"
                  small
                  class="mr-2"
                  @click="editReport(item)"
                >mdi-pencil</v-icon>
              </v-hover>
              <v-hover>
                <v-icon
                  slot-scope="{ hover }"
                  :color="`${hover ? 'red' : ''}`"
                  small
                  @click="deleteReport(item)"
                >mdi-delete</v-icon>
              </v-hover>
            </template>
          </v-data-table>
        </v-flex>
      </v-layout>
    </v-container>
    <visit-report-create ref="reportsCreate"></visit-report-create>
    <v-btn bottom color="green" dark fab fixed right @click="createReport()">
      <v-icon>mdi-plus</v-icon>
    </v-btn>
    <confirmation-dialog ref="confirm"></confirmation-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import VisitReportCreate from "./VisitReportCreate";
import ConfirmationDialog from "../dialog/ConfirmationDialog";
import Avatar from "../avatar/Avatar";

export default {
  components: {
    VisitReportCreate,
    ConfirmationDialog,
    Avatar
  },
  computed: {
    ...mapGetters({
      reports: "reports/reports"
    })
  },
  mounted() {
    return this.refresh();
  },
  methods: {
    ...mapActions({
      list: "reports/list",
      delete: "reports/delete"
    }),
    refresh() {
      this.loading = true;
      this.list().then(() => (this.loading = false));
    },
    createReport() {
      this.$refs.reportsCreate.open({}).then(newReport => {
        if (newReport != null) {
          this.refresh();
          this.$router.push({
            name: "reportDetail",
            params: { id: newReport }
          });
        }
      });
    },
    editReport(report) {
      this.$router.push({ name: "reportDetail", params: { id: report.id } });
    },
    deleteReport(report) {
      this.$refs.confirm
        .open(
          "Delete Report",
          `Are you sure you want to delete report ${report.subject}?`,
          {
            color: "red"
          }
        )
        .then(confirm => {
          if (confirm) this.delete(report.id).then(() => this.refresh());
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
          text: "Visit Reports List",
          disabled: true,
          to: "/reports"
        }
      ],
      loading: false,
      headers: [
        {
          text: "Subject",
          sortable: true,
          value: "subject"
        },
        {
          text: "",
          align: "center",
          sortable: false,
          value: "avatar"
        },
        {
          text: "First Name",
          sortable: true,
          value: "contact.firstname"
        },
        {
          text: "Last Name",
          sortable: true,
          value: "contact.lastname"
        },
        {
          text: "Company",
          sortable: true,
          value: "contact.company"
        },
        {
          text: "Visit Date",
          sortable: true,
          value: "visitDate"
        },
        {
          text: "Actions",
          value: "actions",
          sortable: false,
          align: "end"
        }
      ]
    };
  }
};
</script>