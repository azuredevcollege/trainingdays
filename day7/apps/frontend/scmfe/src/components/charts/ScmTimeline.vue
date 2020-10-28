<template>
  <div style="width:100%">
    <v-chart :autoresize="true" :options="options" theme="light"></v-chart>
  </div>
</template>
<script>
import _ from 'lodash';

export default {
  components: {},
  computed: {
    currentData: function() {
      return _.orderBy(this.dataset, ['visitDate'],['asc']);
    }
  },
  methods: {
    setdata() {
      if (this.currentData.length > 0) {
        this.options.dataset.source = this.currentData;
      }
    }
  },
  data: () => ({
    scoreDisplay: 0,
    options: {
      legend: { show: true },
      tooltip: {
        show: true
      },
      textStyle: {
        fontFamily: "Roboto"
      },
      xAxis: {
        type: "category",
        axisLine: {
          show: false
        },
        axisLabel: {
          show: true,
          inside: false
        }
      },
      yAxis: {
        type: "value",
        axisLine: {
          show: false
        },
        axisTick: {
          show: false
        }
      },
      dataset: {
        dimensions: ["visitDate", "visits"],
        source: []
      },
      series: [
        {
          name: "Visits per Day",
          type: "bar",
          barWidth: "60%"
        }
      ]
    }
  }),
  props: {
    title: String,
    dataset: Array
  },
  watch: {
    dataset: {
      handler() {
        this.setdata();
      },
      immediate: true,
      deep: true
    }
  }
};
</script>

<style scoped>
.echarts {
  width: 100%;
}
</style>