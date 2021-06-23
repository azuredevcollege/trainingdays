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
          <span class="ml-3 hidden-sm-and-down">Azure Cognitive Services - Statistics</span>
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
        <v-flex xs12 md6>
          <v-card :min-height="460" :loading="loading">
            <v-toolbar flat dense color="transparent">
              <span class="font-weight-light">Text Analytics / Sentiment Analysis</span>
            </v-toolbar>
            <v-divider></v-divider>
            <v-card-text class="text-center pa-0">
              <scm-score :score="currentScore" />
            </v-card-text>
          </v-card>
        </v-flex>
        <v-flex xs12 md6>
          <v-card class="mb-4" :loading="loading">
            <v-card-text>Number of Visit Results</v-card-text>
            <v-container>
              <v-layout>
                <v-flex xs12>
                  <v-card-text class="pa-0">
                    <v-icon color="#37A2DA" size="65">mdi-file-document-outline</v-icon>
                  </v-card-text>
                </v-flex>
                <v-flex xs12>
                  <v-card-text class="text-center pa-0">
                    <h1 class="display-3 font-weight-light">{{currentVisits}}</h1>
                  </v-card-text>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card>
          <v-card class="mb-4" :loading="loading">
            <v-card-text>Worst Score</v-card-text>
            <v-container>
              <v-layout>
                <v-flex xs12>
                  <v-card-text class="pa-0">
                    <v-icon color="error" size="65">mdi-thumb-down-outline</v-icon>
                  </v-card-text>
                </v-flex>
                <v-flex xs12>
                  <v-card-text class="text-center pa-0">
                    <h1 class="display-3 font-weight-light">{{currentMinScore}}</h1>
                  </v-card-text>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card>
          <v-card class="mb-4" :loading="loading">
            <v-card-text>Best Score</v-card-text>
            <v-container>
              <v-layout>
                <v-flex xs12>
                  <v-card-text class="pa-0">
                    <v-icon color="success" size="65">mdi-thumb-up-outline</v-icon>
                  </v-card-text>
                </v-flex>
                <v-flex xs12>
                  <v-card-text class="text-center pa-0">
                    <h1 class="display-3 font-weight-light">{{currentMaxScore}}</h1>
                  </v-card-text>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card>
        </v-flex>
        <v-flex xs12>
          <v-card :min-height="460" :loading="loading">
            <v-toolbar flat dense color="transparent">
              <span class="font-weight-light">Visits with Results / per Day</span>
            </v-toolbar>
            <v-divider></v-divider>
            <v-card-text class="text-center pa-0">
              <scm-timeline :dataset="statsTimeline" />
            </v-card-text>
          </v-card>
        </v-flex>
      </v-layout>
    </v-container>
  </div>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import ScmScore from "../charts/ScmScore";
import ScmTimeline from "../charts/ScmTimeline";
export default {
  components: {
    ScmScore,
    ScmTimeline
  },
  computed: {
    ...mapGetters({
      stats: "stats/stats",
      statsTimeline: "stats/statsTimeline"
    }),
    currentScore: function() {
      return this.stats.length > 0 ? this.stats[0].avgScore : 0;
    },
    currentVisits: function() {
      return this.stats.length > 0 ? this.stats[0].countScore : 0;
    },
    currentMinScore: function() {
      return this.stats.length > 0 ? Math.floor(this.stats[0].minScore * 100) : 0;
    },
    currentMaxScore: function() {
      return this.stats.length > 0 ? Math.floor(this.stats[0].maxScore * 100) : 0;
    },
  },
  mounted() {
    return this.refresh();
  },
  methods: {
    ...mapActions({
      statsOverall: "stats/statsOverall",
      statsTl: "stats/statsTimeline"
    }),
    refresh() {
      this.loading = true;
      this.statsOverall()
        .then(() => {
          this.statsTl().then(() => (this.loading = false));
        })
        .catch(() => (this.loading = false));
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
          text: "Statistics",
          disabled: true,
          to: "/stats"
        }
      ],
      loading: false
    };
  }
};
</script>