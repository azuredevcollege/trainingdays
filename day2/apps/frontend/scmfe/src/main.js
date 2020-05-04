import Vue from 'vue'
import App from './App.vue'
import vuetify from './plugins/vuetify';
import router from "./router";
import store from "./store";
import VueWait from "vue-wait";
import VeeValidate from "vee-validate";
import VueAppInsights from "vue-application-insights";

Vue.config.productionTip = false
Vue.use(VueWait);
Vue.use(VeeValidate);
Vue.use(VueAppInsights, {
  id: window.uisettings.aiKey,
  router
});

Vue.prototype.$uisettings = window.uisettings;

new Vue({
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
}).$mount('#app')
