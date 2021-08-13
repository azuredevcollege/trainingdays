<template>
  <v-avatar :tile="tile" v-if="image && image != ''" :size="size">
    <img
      :lazy-src="require('../../assets/no-user.png')"
      :src="image"
      :alt="`${firstname} ${lastname}`"
    />
  </v-avatar>
  <v-avatar
    :tile="tile"
    v-else
    :size="size"
    :color="color && color != '' ? color : calculatedColor"
  >
    <span :class="textclass">{{initials}}</span>
  </v-avatar>
</template>
<script>
export default {
  computed: {
    initials() {
      var f = this.firstname.charAt(0).toUpperCase();
      var l = this.lastname.charAt(0).toUpperCase();
      return `${f}${l}`;
    },
    calculatedColor() {
      return this.stringToHslColor(
        `${this.firstname} ${this.lastname}`,
        75,
        50
      );
    }
  },
  methods: {
    stringToHslColor(str, s, l) {
      var hash = 0;
      for (var i = 0; i < str.length; i++) {
        hash = str.charCodeAt(i) + ((hash << 5) - hash);
      }

      var h = hash % 360;
      return "hsl(" + h + ", " + s + "%, " + l + "%)";
    }
  },
  props: {
    image: {
      type: String,
      default: ""
    },
    firstname: {
      type: String,
      default: ""
    },
    lastname: {
      type: String,
      default: ""
    },
    color: {
      type: String,
      default: ""
    },
    tile: {
      type: Boolean,
      default: false
    },
    textclass: {
      type: String,
      default: "white--text"
    },
    size: {
      type: Number,
      default: 32
    }
  }
};
</script>