import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  search(event) {
    event.preventDefault()
    const id = this.inputTarget.value.trim()
    if (id !== "") {
      window.location = `/athletes/${id}`
    }
  }
}
