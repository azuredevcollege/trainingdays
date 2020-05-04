import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import router from "./router";
import store from "./store";
import VueWait from "vue-wait";
import VeeValidate from "vee-validate";
import VueAppInsights from "vue-application-insights";
import ECharts from 'vue-echarts';
import "echarts/lib/chart/bar";
import "echarts/lib/chart/line";
import "echarts/lib/chart/gauge";
import "echarts/lib/component/tooltip";
import "echarts/lib/component/legend";
import "echarts/lib/component/title";
import "echarts/lib/component/dataset";
import msal from 'vue-msal';

Vue.config.productionTip = false
Vue.use(VueWait);
Vue.use(VeeValidate);
Vue.use(VueAppInsights, {
  id: window.uisettings.aiKey,
  router
});

Vue.use(msal, {
  auth: {
    clientId: window.uisettings.clientId,
    tenantId: window.uisettings.tenantId,
    requireAuthOnInitialize: true,
    onToken: (ctx, error, response) => {
      store.commit('auth/setAccessToken', response.accessToken);
    }
  },
  request: {
    scopes: [
      `${window.uisettings.audience}/Contacts.Read`,
      `${window.uisettings.audience}/Contacts.Create`,
      `${window.uisettings.audience}/Contacts.Update`,
      `${window.uisettings.audience}/Contacts.Delete`,
      `${window.uisettings.audience}/VisitReports.Read`,
      `${window.uisettings.audience}/VisitReports.Create`,
      `${window.uisettings.audience}/VisitReports.Update`,
      `${window.uisettings.audience}/VisitReports.Create`
    ]
  }
});

Vue.prototype.$uisettings = window.uisettings;

Vue.component("v-chart", ECharts);
const myapp = new Vue({
  vuetify,
  router,
  store,
  wait: new VueWait({
    useVuex: true,
    vuexModuleName: "wait",
    registerComponent: true,
    componentName: "v-wait",
    registerDirective: true,
    directiveName: "wait",
  }),
  render: h => h(App)
});

myapp.$mount('#app');
