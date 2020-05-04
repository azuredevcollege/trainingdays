import Vue from "vue";
import Router from "vue-router";
import Home from "./components/home/Home";
import ContactDetail from "./components/contacts/ContactDetail";
import ContactsList from "./components/contacts/ContactsList";
import Stats from "./components/stats/Stats";
import VisitReportsList from "./components/visitreports/VisitReportsList";
import VisitReportDetail from "./components/visitreports/VisitReportDetail";
import Search from "./components/search/Search";
import goTo from "vuetify/lib/services/goto";

Vue.use(Router);

export default new Router({
  mode: "history",
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/",
      name: "home",
      component: Home
    },
    {
      path: "/contacts",
      name: "contacts",
      component: ContactsList
    },
    {
      path: "/reports",
      name: "reports",
      component: VisitReportsList
    },
    {
      path: "/reports/:id",
      name: "reportDetail",
      component: VisitReportDetail
    },
    {
      path: "/stats",
      name: "stats",
      component: Stats
    },
    {
      path: "/search",
      name: "search",
      component: Search
    },
    {
      path: "/contacts/:id",
      name: "contactDetail",
      component: ContactDetail
    },
    {
      path: "*",
      redirect: "/"
    }
  ],
  scrollBehavior: () => {
    let scrollTo = 0
    return goTo(scrollTo);
  }
})
