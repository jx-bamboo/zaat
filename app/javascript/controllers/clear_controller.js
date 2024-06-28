import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  clear() {
    document.getElementById("preview").src = "/assets/add.svg"
  }
}