import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "planSelect"]

  connect() {
    // Ẩn modal khi mới load
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
    }
  }

  // Gọi khi bấm nút Select Plan — set sẵn gói theo card được chọn
  open(event) {
    event.preventDefault()
    if (this.hasModalTarget) {
      this.modalTarget.classList.remove("hidden")
    }
    const planId = event.currentTarget?.dataset?.planId
    if (planId && this.hasPlanSelectTarget) {
      this.planSelectTarget.value = planId
    }
  }

  // Gọi khi bấm nút Close
  close(event) {
    event.preventDefault()
    if (this.hasModalTarget) {
      this.modalTarget.classList.add("hidden")
    }
  }

  // Đóng khi click ra ngoài nội dung modal
  closeOutside(event) {
    if (!this.hasModalTarget) return

    // Nếu click đúng vào overlay (phần nền tối)
    if (event.target === this.modalTarget) {
      this.modalTarget.classList.add("hidden")
    }
  }
}