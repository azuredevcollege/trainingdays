<template>
  <div style="width:100%">
    <v-chart :autoresize="true" :options="gaugeOptions"></v-chart>
  </div>
</template>
<script>
export default {
  components: {},
  computed: {
      currentScore: function() {
          return Math.floor(this.score * 100);
      }
  },
  methods: {
    setdata() {
      this.gaugeOptions.series[0].data[0].value = this.currentScore;
    }
  },
  data: () => ({
    scoreDisplay: 0,
    gaugeOptions: {
      textStyle: {
        fontFamily: "Roboto"
      },
      tooltip: {
        formatter: "{b} : {c}"
      },
      series: [
        {
          title: {
            offsetCenter: [0, "70%"]
          },
          name: "Score",
          type: "gauge",
          data: [{ value: 0, name: "Overall Sentiment" }],
          axisLine: {
            lineStyle: {
              color: [
                [0.2, "#E73C09"],
                [0.4, "#EE8200"],
                [0.6, "#FDCC01"],
                [0.8, "#86BD2B"],
                [1, "#02823F"]
              ]
            }
          },
          axisTick: { show: true },
          splitLine: { show: false },
          pointer: {
            length: "66%",
            width: 6
          }
        }
      ]
    }
  }),
  props: {
    title: String,
    score: Number
  },
  watch: {
    score: {
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