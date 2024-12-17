import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reg-mod"
export default class extends Controller {
  connect() {
  }

  nameUp() {
    console.log(document.getElementById("wait").values)
    // console.log(document.getElementById("wait").values[document.getElementById("wait").values.length -1])
    // document.getElementById("wait").values = document.getElementById("wait").values + document.getElementById("wait").values[document.getElementById("wait").values.length -1]

  }
}
