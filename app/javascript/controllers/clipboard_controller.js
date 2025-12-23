import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    linkUrl: String
  }

  connect() {
    console.log("ClipboardController connected");
    console.log(this.linkUrlValue);
  }

  copyLink() {
    navigator.clipboard.writeText(this.linkUrlValue);
  }
}
