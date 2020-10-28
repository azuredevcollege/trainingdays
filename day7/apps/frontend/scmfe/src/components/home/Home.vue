<template>
  <div>
    <v-divider />
    <v-toolbar flat>
      <v-breadcrumbs :items="items">
        <v-icon slot="divider">mdi-chevron-right</v-icon>
      </v-breadcrumbs>
    </v-toolbar>
    <v-divider />
    <v-container grid-list-md>
      <v-layout row text-center align-center wrap>
        <v-flex xs12 my-4>
          <h1 class="display-2 font-weight-bold mb-3">Welcome to SCM Contacts App</h1>
        </v-flex>
        <v-flex xs12 my-4>
          <v-icon :size="120">mdi-contacts</v-icon>
        </v-flex>
        <v-flex xs12 my-4>
          <h1 class="display-1 mb-3">Super-professional contacts management in the Azure Cloud.</h1>
          <p>
            Sample app for the
            <i>Azure Developer College</i> by the Microsoft Cloud Solutions Architects (Germany).
          </p>
        </v-flex>
        <v-flex xs12>
          <p>Source Code can be found at:</p>
          <v-card class="elevation-0" color="transparent">
            <v-card-actions class="justify-center">
              <a
                href="https://github.com/azuredevcollege/trainingdays"
                target="_blank"
              >
                <v-img
                  :max-width="120"
                  :src="require('../../assets/octocat_sm.png')"
                />
              </a>
            </v-card-actions>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      items: [
        {
          text: "Home",
          disabled: true,
          to: "/home",
          exact: true
        }
      ],
      loading: false
    };
  }
};
</script>