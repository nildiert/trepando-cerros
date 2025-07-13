import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "frame"]

  change() {
    const id = this.selectTarget.value
    this.frameTarget.src = `/roles/${id}`
  }
}
