<template>
  <div>
    <v-dialog
      :fullscreen="$vuetify.breakpoint.xsOnly"
      v-model="logoDialog"
      width="500"
      :persistent="true"
      @keydown.esc="cancel"
    >
      <v-card>
        <v-card-title class="headline" primary-title>Image Upload</v-card-title>
        <v-divider></v-divider>
        <v-card-text>
          <vue-cropper
            v-show="logoImgSrc"
            ref="logoCropper"
            :guides="true"
            :view-mode="2"
            drag-mode="crop"
            :auto-crop-area="0.5"
            :min-container-width="250"
            :min-container-height="180"
            :background="true"
            :rotatable="true"
            :aspect-ratio="1/1"
            :src="logoImgSrc"
            alt="Source Image"
            :img-style="{ 'width': '400px', 'height': '300px' }"
          ></vue-cropper>
          <p v-show="!logoImgSrc" class="text-center">Select an image to upload.</p>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-btn color="primary" @click="uploadLogo()" text>Select</v-btn>
          <v-spacer></v-spacer>
          <v-btn @click="cancel()">Cancel</v-btn>
          <v-btn
            color="primary"
            @click="saveLogo()"
            :disabled="!this.logoImgSrc"
            :loading="logoProcessing"
          >Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <input
      id="logo-file-input"
      type="file"
      name="logo-file-input"
      style="display: none;"
      @change="logoSetImage"
    />
  </div>
</template>

<script>
import VueCropper from "vue-cropperjs";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    VueCropper
  },
  computed: {
    ...mapGetters({
      image: "resources/contactimage"
    })
  },
  data: () => ({
    logoProcessing: false,
    logoDialog: false,
    logoImgSrc: null,
    logoUrl: "",
    logoCropImg: null,
    resolve: null,
    reject: null,
    fileType: "",
    fileName: ""
  }),
  methods: {
    ...mapActions({
      uploadImage: "resources/uploadImage",
      clearImage: "resources/clearImage"
    }),
    saveLogo() {
      if (this.logoProcessing == true) return;
      this.logoProcessing = true;
      this.logoCropImg = this.$refs.logoCropper
        .getCroppedCanvas()
        .toBlob(blob => {
          return this.uploadImage({
            blob,
            fileType: this.fileType
          }).then(() => {
            this.logoUrl = this.image;
            this.close();
          });
        });
    },
    logoSetImage(e) {
      const file = e.target.files[0];
      if (file == null || file == undefined) return;

      if (!file.type.includes("image/")) {
        this.snackbar.text = "Wrong file type.";
        this.snackbar.color = "orange";
        this.snackbar.show = true;
        return;
      }

      this.fileType = file.type;
      this.fileName = file.name;

      if (typeof FileReader === "function") {
        const reader = new FileReader();

        reader.onload = event => {
          this.logoImgSrc = event.target.result;
          // rebuild cropperjs with the updated source
          this.$refs.logoCropper.replace(event.target.result);
        };

        reader.readAsDataURL(file);
      } else {
        this.snackbar.text = "FileReader API not available";
        this.snackbar.color = "red";
        this.snackbar.show = true;
      }
    },
    uploadLogo() {
      this.logoImgSrc = null;
      document.getElementById("logo-file-input").click();
    },
    open() {
      this.logoDialog = true;
      return new Promise((resolve, reject) => {
        this.resolve = resolve;
        this.reject = reject;
      });
    },
    close() {
      this.resolve(this.logoUrl);
      this.clearImage();
      this.logoUrl = "";
      this.logoProcessing = false;
      this.logoDialog = false;
      this.logoImgSrc = null;
      this.logoCropImg = null;
      this.resolve = null;
      this.reject = null;
      this.fileType = "";
      this.fileName = "";
    },
    cancel() {
      this.resolve(false);
      this.clearImage();
      this.logoUrl = "";
      this.logoProcessing = false;
      this.logoDialog = false;
      this.logoImgSrc = null;
      this.logoCropImg = null;
      this.resolve = null;
      this.reject = null;
      this.fileName = "";
      this.fileType = "";
    }
  },
  watch: {
    logoProcessing(processing) {
      if (processing) {
        this.$refs.logoCropper.disable();
      } else {
        this.$refs.logoCropper.enable();
      }
    }
  }
};
</script>