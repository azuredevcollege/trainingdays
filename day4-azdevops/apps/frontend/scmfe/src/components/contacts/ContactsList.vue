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
          <span class="ml-3 hidden-sm-and-down">Contacts List</span>
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
          <v-data-table :headers="headers" :items="contacts" class="elevation-1">
            <template v-slot:item.firstname="{item}">
              <router-link style="padding-left: 5px;" :to="`contacts/${item.id}`">{{ item.firstname }}</router-link>
            </template>
            <template v-slot:item.lastname="{item}">
              <router-link style="padding-left: 5px;" :to="`contacts/${item.id}`">{{ item.lastname }}</router-link>
            </template>
            <template v-slot:item.avatar="{item}">
              <avatar
                :image="item.avatarLocation"
                :firstname="item.firstname"
                :lastname="item.lastname"
              ></avatar>
            </template>
            <template v-slot:item.actions="{item}">
              <v-hover>
                <v-icon
                  slot-scope="{ hover }"
                  :color="`${hover ? 'primary' : ''}`"
                  small
                  class="mr-2"
                  @click="editContact(item)"
                >mdi-pencil</v-icon>
              </v-hover>
              <v-hover>
                <v-icon
                  slot-scope="{ hover }"
                  :color="`${hover ? 'red' : ''}`"
                  small
                  @click="deleteContact(item)"
                >mdi-delete</v-icon>
              </v-hover>
            </template>
          </v-data-table>
        </v-flex>
      </v-layout>
    </v-container>
    <contacts-create ref="contactsCreate"></contacts-create>
    <v-btn bottom color="green" dark fab fixed right @click="createContact()">
      <v-icon>mdi-plus</v-icon>
    </v-btn>
    <confirmation-dialog ref="confirm"></confirmation-dialog>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ContactsCreate from "./ContactsCreate";
import ConfirmationDialog from "../dialog/ConfirmationDialog";
import Avatar from "../avatar/Avatar";

export default {
  components: {
    ContactsCreate,
    ConfirmationDialog,
    Avatar
  },
  computed: {
    ...mapGetters({
      contacts: "contacts/contacts"
    })
  },
  mounted() {
    return this.refresh();
  },
  methods: {
    ...mapActions({
      list: "contacts/list",
      delete: "contacts/delete"
    }),
    refresh() {
      this.loading = true;
      this.list().then(() => (this.loading = false));
    },
    createContact() {
      this.$refs.contactsCreate.open({}).then(newContact => {
        if (newContact != null) {
          this.refresh();
          this.$router.push({
            name: "contactDetail",
            params: { id: newContact }
          });
        }
      });
    },
    editContact(contact) {
      this.$router.push({ name: "contactDetail", params: { id: contact.id } });
    },
    deleteContact(contact) {
      this.$refs.confirm
        .open(
          "Delete Contact",
          `Are you sure you want to delete contact ${contact.firstname} ${contact.lastname}?`,
          {
            color: "red"
          }
        )
        .then(confirm => {
          if (confirm) this.delete(contact.id).then(() => this.refresh());
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
          disabled: true,
          to: "contacts"
        }
      ],
      loading: false,
      headers: [
        {
          text: "",
          align: "center",
          sortable: false,
          value: "avatar"
        },
        {
          text: "First Name",
          sortable: true,
          value: "firstname"
        },
        {
          text: "Last Name",
          sortable: true,
          value: "lastname"
        },
        {
          text: "Email",
          sortable: true,
          value: "email"
        },
        {
          text: "Company",
          sortable: true,
          value: "company"
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